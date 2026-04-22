package com.bookshop.controller;

import com.bookshop.model.User;
import com.bookshop.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;

@WebServlet("/Jsp/front/user/*")
public class UserController extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String action = getAction(req);
        switch (action) {
            case "logout":
                logout(req, resp);
                break;
            case "profile":
                showProfile(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String action = getAction(req);
        switch (action) {
            case "register":
                register(req, resp);
                break;
            case "login":
                login(req, resp);
                break;
            case "updateProfile":
                updateProfile(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    private void register(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        String result = userService.register(username, password, confirmPassword, email, phone, address);
        if ("success".equals(result)) {
            redirectWithMessage(req, resp, "/Jsp/front/index.jsp", "success", "注册成功，请登录");
        } else {
            redirectWithMessage(req, resp, "/Jsp/front/register.jsp", "error", result);
        }
    }

    private void login(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User user = userService.login(username, password);
        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60);
            redirectWithMessage(req, resp, "/Jsp/front/index.jsp", "success", "登录成功");
        } else {
            redirectWithMessage(req, resp, "/Jsp/front/login.jsp", "error", "用户名或密码错误");
        }
    }

    private void logout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        redirectWithMessage(req, resp, "/Jsp/front/index.jsp", "success", "已退出登录");
    }

    private void showProfile(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            redirectWithMessage(req, resp, "/Jsp/front/login.jsp", "error", "请先登录");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        User dbUser = userService.getUserInfo(sessionUser.getId());
        if (dbUser == null) {
            redirectWithMessage(req, resp, "/Jsp/front/login.jsp", "error", "用户不存在");
            return;
        }

        req.setAttribute("userProfile", dbUser);
        req.getRequestDispatcher("/Jsp/front/users/userProfile.jsp").forward(req, resp);
    }

    private void updateProfile(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            redirectWithMessage(req, resp, "/Jsp/front/login.jsp", "error", "请先登录");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");

        User updatedUser = new User();
        updatedUser.setId(sessionUser.getId());
        updatedUser.setEmail(req.getParameter("email"));
        updatedUser.setPhone(req.getParameter("phone"));
        updatedUser.setGender(req.getParameter("gender"));
        updatedUser.setAddress(req.getParameter("address"));
        updatedUser.setAvatar(req.getParameter("avatar"));

        String birthday = req.getParameter("birthday");
        if (birthday != null && !birthday.trim().isEmpty()) {
            try {
                updatedUser.setBirthday(new SimpleDateFormat("yyyy-MM-dd").parse(birthday.trim()));
            } catch (Exception ignored) {
            }
        }

        boolean ok = userService.updateUserInfo(updatedUser);
        if (ok) {
            User freshUser = userService.getUserInfo(sessionUser.getId());
            session.setAttribute("user", freshUser);
            redirectWithMessage(req, resp, "/Jsp/front/user/profile", "success", "资料更新成功");
        } else {
            redirectWithMessage(req, resp, "/Jsp/front/user/profile", "error", "更新失败");
        }
    }

    private void redirectWithMessage(HttpServletRequest req, HttpServletResponse resp, String path, String key, String message)
            throws IOException {
        String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8.toString());
        resp.sendRedirect(req.getContextPath() + path + "?" + key + "=" + encodedMessage);
    }

    private String getAction(HttpServletRequest req) {
        String path = req.getPathInfo();
        if (path != null && path.length() > 1) {
            return path.substring(1);
        }
        return "";
    }
}
