package com.bookshop.controller;

import com.bookshop.model.OrderItem;
import com.bookshop.model.User;
import com.bookshop.service.OrderService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

@WebServlet("/Jsp/front/order/create")
public class OrderCreateController extends HttpServlet {

    private OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // GET请求直接返回错误，因为订单创建应该通过POST请求
        req.setAttribute("msg", "无效的请求方法，请通过购物车页面提交订单");
        req.getRequestDispatcher("/Jsp/front/cart/list").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        create(req, resp, req.getSession());
    }


    // 在 OrderCreateController 中添加数据转换逻辑
// 在 OrderCreateController 中添加数据转换逻辑
    private void create(HttpServletRequest req, HttpServletResponse resp, HttpSession session) throws IOException, ServletException {
        User user = (User) session.getAttribute("user");

        // 首先尝试从请求参数获取购物车数据
        @SuppressWarnings("unchecked")
        List<com.bookshop.model.CartItem> cartItems = (List<com.bookshop.model.CartItem>) req.getAttribute("cartItems");

        // 如果请求属性中没有，则尝试从会话中获取
        if (cartItems == null || cartItems.isEmpty()) {
            cartItems = (List<com.bookshop.model.CartItem>) session.getAttribute("cartItems");
        }

        // 如果会话中也没有，则尝试使用用户ID从数据库获取购物车数据
        if (cartItems == null || cartItems.isEmpty()) {
            if (user != null) {
                com.bookshop.service.CartService cartService = new com.bookshop.service.CartService();
                cartItems = cartService.getCartItems(user.getId());
            }
        }

        // 将CartItem转换为OrderItem
        List<OrderItem> orderItems = new java.util.ArrayList<>();
        if (cartItems != null && !cartItems.isEmpty()) {
            for (com.bookshop.model.CartItem cartItem : cartItems) {
                OrderItem orderItem = new OrderItem();
                orderItem.setBookId(cartItem.getBookId());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setPrice(cartItem.getPrice());
                orderItem.setBookName(cartItem.getBookName());
                orderItems.add(orderItem);
            }
        }

        // 添加调试信息
        System.out.println("购物车项目数量: " + orderItems.size());

        if (orderItems.isEmpty()) {
            req.setAttribute("msg", "下单失败，购物车为空或数据已过期");
            req.getRequestDispatcher("/Jsp/front/cart/list").forward(req, resp);
            return;
        }

        // 如果用户未登录，则跳转到登录页面
        if (user == null) {
            String contextPath = req.getContextPath();
            String msg = URLEncoder.encode("请先登录", "UTF-8");
            resp.sendRedirect(contextPath + "/Jsp/front/login.jsp?error=" + msg);
            return;
        }

        int orderId = orderService.createOrder(user.getId(), orderItems);

        if (orderId <= 0) {
            req.setAttribute("msg", "下单失败");
            req.getRequestDispatcher("/Jsp/front/cart/list").forward(req, resp);
            return;
        }

        // 订单创建成功后清空购物车
        session.removeAttribute("cartItems");
        resp.sendRedirect("/Jsp/front/order/detail?id=" + orderId);
    }



}

