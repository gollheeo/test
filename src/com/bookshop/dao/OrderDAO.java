package com.bookshop.dao;

import com.bookshop.model.Order;
import com.bookshop.model.OrderItem;
import com.bookshop.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    /**
     * 创建订单
     */
    public int createOrder(Order order) {
        String sql = "INSERT INTO orders (user_id, order_no, total_price, status) " +
                "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, order.getUserId());
            pstmt.setString(2, order.getOrderNo());
            pstmt.setBigDecimal(3, order.getTotalPrice());
            pstmt.setString(4, order.getStatus());

            int result = pstmt.executeUpdate();
            if (result > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * 添加订单项
     */
    public int addOrderItem(OrderItem item) {
        String sql = "INSERT INTO order_items (order_id, book_id, quantity, price, book_name) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, item.getOrderId());
            pstmt.setInt(2, item.getBookId());
            pstmt.setInt(3, item.getQuantity());
            pstmt.setBigDecimal(4, item.getPrice());
            pstmt.setString(5, item.getBookName()); // 添加图书名称

            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }


    /**
     * 根据用户ID获取订单列表（普通用户权限）
     * 确保用户只能查看自己的订单
     */
    public List<Order> getOrdersByUserId(Integer userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // 获取订单项目
                order.setItems(getOrderItems(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * 获取订单详情
     * 需要验证用户权限（用户只能查看自己的订单，管理员可以查看所有订单）
     */
    public Order getOrderById(Integer orderId) {
        String sql = "SELECT * FROM orders WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // 获取订单项目
                order.setItems(getOrderItems(orderId));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 获取订单项目
     */
    public List<OrderItem> getOrderItems(Integer orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setBookId(rs.getInt("book_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setBookName(rs.getString("book_name")); // 获取图书名称
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }


    /**
     * 更新订单状态（仅管理员权限）
     */
    public int updateOrderStatus(Integer orderId, String status) {
        String sql = "UPDATE orders SET status = ?, updated_at = NOW() WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setInt(2, orderId);

            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }


    /**
     * 删除订单（仅管理员权限）
     */
    public int deleteOrder(Integer orderId) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 先删除订单项
            String delItemsSql = "DELETE FROM order_items WHERE order_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(delItemsSql)) {
                pstmt.setInt(1, orderId);
                pstmt.executeUpdate();
            }

            // 再删除订单
            String delOrderSql = "DELETE FROM orders WHERE id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(delOrderSql)) {
                pstmt.setInt(1, orderId);
                int result = pstmt.executeUpdate();
                conn.commit();
                return result;
            }
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            return -1;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 获取所有订单（仅管理员权限）
     * 普通用户不应调用此方法
     */
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // 获取订单项目
                order.setItems(getOrderItems(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * 根据状态获取订单（管理员权限）
     */
    public List<Order> getOrdersByStatus(String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE status = ? ORDER BY created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // 获取订单项目
                order.setItems(getOrderItems(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    /**
     * 根据关键词搜索订单（订单号或用户ID）
     */
    public List<Order> searchOrders(String keyword) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE order_no LIKE ? OR user_id LIKE ? ORDER BY created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String searchKeyword = "%" + keyword + "%";
            pstmt.setString(1, searchKeyword);
            pstmt.setString(2, searchKeyword);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    // 获取订单项目
                    order.setItems(getOrderItems(order.getId()));
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }


    /**
     * 根据用户ID和状态获取订单
     */
    public List<Order> getOrdersByUserIdAndStatus(Integer userId, String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? AND status = ? ORDER BY created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            pstmt.setString(2, status);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // 获取订单项目
                order.setItems(getOrderItems(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * 获取用户订单总数
     */
    public int getUserOrderCount(Integer userId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE user_id = ?";
        int count = 0;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    /**
     * 获取所有订单总数（管理员权限）
     */
    public int getAllOrderCount() {
        String sql = "SELECT COUNT(*) FROM orders";
        int count = 0;

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    /**
     * 根据用户ID和时间范围获取订单
     */
    public List<Order> getOrdersByUserIdAndDateRange(Integer userId, Date startDate, Date endDate) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? AND created_at BETWEEN ? AND ? ORDER BY created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            pstmt.setDate(2, new java.sql.Date(startDate.getTime()));
            pstmt.setDate(3, new java.sql.Date(endDate.getTime()));
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // 获取订单项目
                order.setItems(getOrderItems(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * 映射ResultSet到Order对象
     */
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setOrderNo(rs.getString("order_no"));
        order.setTotalPrice(rs.getBigDecimal("total_price"));
        order.setStatus(rs.getString("status"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setUpdatedAt(rs.getTimestamp("updated_at"));
        return order;
    }
}
