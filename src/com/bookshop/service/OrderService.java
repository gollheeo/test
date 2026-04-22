package com.bookshop.service;

import com.bookshop.dao.OrderDAO;
import com.bookshop.dao.BookDAO;
import com.bookshop.model.Order;
import com.bookshop.model.OrderItem;
import com.bookshop.model.Book;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.UUID;

public class OrderService {
    private OrderDAO orderDAO = new OrderDAO();
    private BookDAO bookDAO = new BookDAO();

    /**
     * 创建订单
     */
    public int createOrder(Integer userId, List<OrderItem> items) {
        // 计算订单总价
        BigDecimal totalPrice = BigDecimal.ZERO;
        for (OrderItem item : items) {
            BigDecimal itemTotal = item.getPrice().multiply(
                    new BigDecimal(item.getQuantity())
            );
            totalPrice = totalPrice.add(itemTotal);
        }

        // 生成订单号
        String orderNo = "ORDER_" + System.currentTimeMillis() + "_" +
                UUID.randomUUID().toString().substring(0, 8);

        // 创建订单
        Order order = new Order(userId, orderNo, totalPrice);
        int orderId = orderDAO.createOrder(order);

        if (orderId > 0) {
            // 添加订单项
            for (OrderItem item : items) {
                item.setOrderId(orderId);
                // 设置图书名称
                if (item.getBookName() == null) {
                    // 从图书表获取图书名称
                    Book book = bookDAO.getBookById(item.getBookId());
                    if (book != null) {
                        item.setBookName(book.getTitle());
                    }
                }
                orderDAO.addOrderItem(item);

                // 更新库存
                Book book = bookDAO.getBookById(item.getBookId());
                if (book != null) {
                    book.setStock(book.getStock() - item.getQuantity());
                    bookDAO.updateBook(book);
                }
            }
            return orderId;
        }
        return -1;
    }


    /**
     * 获取用户订单列表
     */
    public List<Order> getUserOrders(Integer userId) {
        return orderDAO.getOrdersByUserId(userId);
    }

    /**
     * 获取订单详情
     */
    public Order getOrderDetail(Integer orderId) {
        return orderDAO.getOrderById(orderId);
    }

    /**
     * 更新订单状态
     */
    public boolean updateOrderStatus(Integer orderId, String status) {
        int result = orderDAO.updateOrderStatus(orderId, status);
        return result > 0;
    }

    /**
     * 搜索订单
     */
    public List<Order> searchOrders(String keyword) {
        return orderDAO.searchOrders(keyword);
    }


    /**
     * 删除订单
     */
    public boolean deleteOrder(Integer orderId) {
        int result = orderDAO.deleteOrder(orderId);
        return result > 0;
    }

    /**
     * 获取所有订单
     */
    public List<Order> getAllOrders() {
        return orderDAO.getAllOrders();
    }
}
