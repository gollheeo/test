package com.bookshop.controller;

import com.bookshop.dao.OrderDAO;
import com.bookshop.model.Order;
import com.bookshop.model.User;
import com.bookshop.service.OrderService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

@WebServlet("/Jsp/front/order/*")
public class OrderManageController extends HttpServlet {

    private OrderService orderService = new OrderService();
    private OrderDAO orderDAO = new OrderDAO();

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

        String path = req.getPathInfo(); // /list /detail /delete /updateStatus
        if (path == null) {
            path = "/list";
        }

        switch (path) {
            case "/detail":
                detail(req, resp);
                break;
            case "/list":
                list(req, resp);
                break;
            case "/delete":
                delete(req, resp);
                break;
            case "/updateStatus":
                updateStatus(req, resp);
                break;
            default:
                list(req, resp);
        }
    }

    private void list(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 获取当前登录用户
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // 如果用户未登录，重定向到登录页面
            String msg = URLEncoder.encode("请先登录", "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/Jsp/front/login.jsp?error=" + msg);
            return;
        }

        User user = (User) session.getAttribute("user");

        List<Order> orders;
        // 根据用户角色决定获取订单的方式
        if ("admin".equals(user.getRole())) {
            // 管理员获取所有订单
            orders = orderDAO.getAllOrders();
        } else {
            // 普通用户只获取自己的订单
            orders = orderDAO.getOrdersByUserId(user.getId());
        }

        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/Jsp/front/orders/order_list.jsp").forward(req, resp);
    }

    private void detail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Order order = orderDAO.getOrderById(id);

        if (order == null) {
            req.setAttribute("msg", "订单不存在");
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
            return;
        }

        // 获取当前登录用户
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            String contextPath = req.getContextPath();
            String msg = URLEncoder.encode("请先登录", "UTF-8");
            resp.sendRedirect(contextPath + "/Jsp/front/login.jsp?error=" + msg);
            return;
        }

        User user = (User) session.getAttribute("user");

        // 检查订单是否属于当前用户（管理员可以查看所有订单）
        if (!"admin".equals(user.getRole()) && !order.getUserId().equals(user.getId())) {
            req.setAttribute("msg", "您没有权限查看此订单");
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("order", order);
        req.getRequestDispatcher("/Jsp/front/orders/order_detail.jsp").forward(req, resp);
    }

    private void delete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int orderId = Integer.parseInt(req.getParameter("id"));
        Order order = orderDAO.getOrderById(orderId);

        // 获取当前登录用户
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            String msg = URLEncoder.encode("请先登录", "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/Jsp/front/login.jsp?error=" + msg);
            return;
        }

        User user = (User) session.getAttribute("user");

        // 检查订单是否存在
        if (order == null) {
            String errorMsg = URLEncoder.encode("订单不存在", "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/Jsp/front/order/list?error=" + errorMsg);
            return;
        }

        // 检查用户权限（管理员可以删除任何订单，普通用户只能删除自己的订单）
        if (!"admin".equals(user.getRole()) && !order.getUserId().equals(user.getId())) {
            String errorMsg = URLEncoder.encode("您没有权限删除此订单", "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/Jsp/front/order/list?error=" + errorMsg);
            return;
        }

        // 删除订单
        int result = orderDAO.deleteOrder(orderId);
        if (result > 0) {
            String successMsg = URLEncoder.encode("订单删除成功", "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/Jsp/front/order/list?success=" + successMsg);
        } else {
            String errorMsg = URLEncoder.encode("订单删除失败", "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/Jsp/front/order/list?error=" + errorMsg);
        }
    }

    private void updateStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int orderId = Integer.parseInt(req.getParameter("id"));
        String status = req.getParameter("status");
        Order order = orderDAO.getOrderById(orderId);

        // 获取当前登录用户
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            String msg = URLEncoder.encode("请先登录", "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/Jsp/front/login.jsp?error=" + msg);
            return;
        }

        User user = (User) session.getAttribute("user");

        // 检查订单是否存在
        if (order == null) {
            String errorMsg = URLEncoder.encode("订单不存在", "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/Jsp/front/order/list?error=" + errorMsg);
            return;
        }

        // 检查用户权限（只有管理员可以更新订单状态）
        if (!"admin".equals(user.getRole())) {
            String errorMsg = URLEncoder.encode("您没有权限更新订单状态", "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/Jsp/front/order/detail?id=" + orderId + "&error=" + errorMsg);
            return;
        }

        // 更新订单状态
        int result = orderDAO.updateOrderStatus(orderId, status);
        if (result > 0) {
            String successMsg = URLEncoder.encode("订单状态更新成功", "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/Jsp/front/order/detail?id=" + orderId + "&success=" + successMsg);
        } else {
            String errorMsg = URLEncoder.encode("订单状态更新失败", "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/Jsp/front/order/detail?id=" + orderId + "&error=" + errorMsg);
        }
    }
}
