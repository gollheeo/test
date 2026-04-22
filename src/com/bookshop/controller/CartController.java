package com.bookshop.controller;

import com.bookshop.model.CartItem;
import com.bookshop.model.User;
import com.bookshop.service.CartService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet("/Jsp/front/cart/*")
public class CartController extends HttpServlet {

    private final CartService cartService = new CartService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        process(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        process(req, resp);
    }

    private void process(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String path = req.getPathInfo();
        if (path == null) {
            path = "/list";
        }

        HttpSession session = req.getSession();
        switch (path) {
            case "/add":
                add(req, resp, session);
                break;
            case "/update":
                update(req, resp, session);
                break;
            case "/remove":
                remove(req, resp, session);
                break;
            case "/clear":
                clear(req, resp, session);
                break;
            case "/list":
            default:
                list(req, resp, session);
                break;
        }
    }

    private void add(HttpServletRequest req, HttpServletResponse resp, HttpSession session) throws IOException {
        User user = getLoggedInUser(session);
        if (user == null) {
            redirectWithError(req, resp, "/Jsp/front/login.jsp", "请先登录");
            return;
        }

        try {
            int bookId = Integer.parseInt(req.getParameter("bookId"));
            boolean success = cartService.addToCart(user.getId(), bookId);
            if (success) {
                session.setAttribute("message", "商品已加入购物车");
            } else {
                session.setAttribute("error", "加入购物车失败");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "参数格式错误");
        } catch (Exception e) {
            session.setAttribute("error", "加入购物车失败：" + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/Jsp/front/cart/list");
    }

    private void update(HttpServletRequest req, HttpServletResponse resp, HttpSession session) throws IOException {
        User user = getLoggedInUser(session);
        if (user == null) {
            redirectWithError(req, resp, "/Jsp/front/login.jsp", "请先登录");
            return;
        }

        try {
            int bookId = Integer.parseInt(req.getParameter("bookId"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));

            if (quantity <= 0) {
                session.setAttribute("error", "商品数量必须大于 0");
            } else {
                cartService.updateQuantity(user.getId(), bookId, quantity);
                session.setAttribute("message", "购物车已更新");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "参数格式错误");
        } catch (Exception e) {
            session.setAttribute("error", "更新购物车失败：" + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/Jsp/front/cart/list");
    }

    private void remove(HttpServletRequest req, HttpServletResponse resp, HttpSession session) throws IOException {
        User user = getLoggedInUser(session);
        if (user == null) {
            redirectWithError(req, resp, "/Jsp/front/login.jsp", "请先登录");
            return;
        }

        try {
            int bookId = Integer.parseInt(req.getParameter("bookId"));
            cartService.removeItem(user.getId(), bookId);
            session.setAttribute("message", "商品已从购物车移除");
        } catch (NumberFormatException e) {
            session.setAttribute("error", "参数格式错误");
        } catch (Exception e) {
            session.setAttribute("error", "移除商品失败：" + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/Jsp/front/cart/list");
    }

    private void clear(HttpServletRequest req, HttpServletResponse resp, HttpSession session) throws IOException {
        User user = getLoggedInUser(session);
        if (user == null) {
            redirectWithError(req, resp, "/Jsp/front/login.jsp", "请先登录");
            return;
        }

        try {
            cartService.clearCart(user.getId());
            session.setAttribute("message", "购物车已清空");
        } catch (Exception e) {
            session.setAttribute("error", "清空购物车失败：" + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/Jsp/front/cart/list");
    }

    private void list(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws ServletException, IOException {
        User user = getLoggedInUser(session);
        if (user == null) {
            redirectWithError(req, resp, "/Jsp/front/login.jsp", "请先登录");
            return;
        }

        List<CartItem> cartItems = cartService.getCartItems(user.getId());

        BigDecimal subtotal = BigDecimal.ZERO;
        int totalCount = 0;
        if (cartItems != null) {
            for (CartItem item : cartItems) {
                subtotal = subtotal.add(item.getSubtotal());
                totalCount += item.getQuantity();
            }
        }

        BigDecimal shipping = new BigDecimal("10.00");
        BigDecimal totalAmount = subtotal.add(shipping);

        req.setAttribute("cartItems", cartItems);
        req.setAttribute("subtotal", subtotal);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("totalAmount", totalAmount);
        req.setAttribute("shipping", shipping);
        req.getRequestDispatcher("/Jsp/front/cart.jsp").forward(req, resp);
    }

    private User getLoggedInUser(HttpSession session) {
        return (User) session.getAttribute("user");
    }

    private void redirectWithError(HttpServletRequest req, HttpServletResponse resp, String path, String message)
            throws IOException {
        String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8.toString());
        resp.sendRedirect(req.getContextPath() + path + "?error=" + encodedMessage);
    }
}
