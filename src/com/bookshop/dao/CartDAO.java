// CartDAO.java
package com.bookshop.dao;

import com.bookshop.model.CartItem;
import com.bookshop.util.DBUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    /**
     * 向用户购物车添加新商品
     */
    public void insertNewItem(int userId, int bookId, String bookName, BigDecimal price, int quantity)
            throws SQLException {
        String sql = "INSERT INTO cart_items (user_id, book_id, book_name, price, quantity, created_at, updated_at) " +
                "VALUES (?, ?, ?, ?, ?, NOW(), NOW())";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            pstmt.setInt(2, bookId);
            pstmt.setString(3, bookName);
            pstmt.setBigDecimal(4, price);
            pstmt.setInt(5, quantity);

            pstmt.executeUpdate();
        }
    }

    /**
     * 更新购物车中商品的数量
     */
    public void updateQuantity(int userId, int bookId, int quantity) throws SQLException {
        String sql = "UPDATE cart_items SET quantity = ?, updated_at = NOW() WHERE user_id = ? AND book_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, quantity);
            pstmt.setInt(2, userId);
            pstmt.setInt(3, bookId);

            pstmt.executeUpdate();
        }
    }

    /**
     * 从购物车中删除指定商品
     */
    public void deleteItem(int userId, int bookId) throws SQLException {
        String sql = "DELETE FROM cart_items WHERE user_id = ? AND book_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            pstmt.setInt(2, bookId);

            pstmt.executeUpdate();
        }
    }

    /**
     * 清空用户购物车
     */
    public void clearCart(int userId) throws SQLException {
        String sql = "DELETE FROM cart_items WHERE user_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);

            pstmt.executeUpdate();
        }
    }

    /**
     * 获取购物车中的单个商品项
     */
    public CartItem getCartItem(int userId, int bookId) throws SQLException {
        String sql = "SELECT user_id, book_id, book_name, price, quantity, created_at, updated_at " +
                "FROM cart_items WHERE user_id = ? AND book_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            pstmt.setInt(2, bookId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    CartItem item = new CartItem();
                    item.setBookId(rs.getInt("book_id"));
                    item.setBookName(rs.getString("book_name"));
                    item.setPrice(rs.getBigDecimal("price"));
                    item.setQuantity(rs.getInt("quantity"));

                    Timestamp createtime = rs.getTimestamp("created_at");
                    if (createtime != null) {
                        item.setCreatedAt(new java.util.Date(createtime.getTime()));
                    }

                    Timestamp updatetime = rs.getTimestamp("updated_at");
                    if (updatetime != null) {
                        item.setUpdatedAt(new java.util.Date(updatetime.getTime()));
                    }

                    return item;
                }
            }
        }
        return null;
    }

    /**
     * 获取用户购物车中的所有商品项
     */
    public List<CartItem> getCartItems(int userId) throws SQLException {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT book_id, book_name, price, quantity, created_at, updated_at " +
                "FROM cart_items WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setBookId(rs.getInt("book_id"));
                    item.setBookName(rs.getString("book_name"));
                    item.setPrice(rs.getBigDecimal("price"));
                    item.setQuantity(rs.getInt("quantity"));

                    Timestamp createtime = rs.getTimestamp("created_at");
                    if (createtime != null) {
                        item.setCreatedAt(new java.util.Date(createtime.getTime()));
                    }

                    Timestamp updatetime = rs.getTimestamp("updated_at");
                    if (updatetime != null) {
                        item.setUpdatedAt(new java.util.Date(updatetime.getTime()));
                    }

                    cartItems.add(item);
                }
            }
        }
        return cartItems;
    }

    /**
     * 检查商品是否已在购物车中
     */
    public boolean isItemInCart(int userId, int bookId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM cart_items WHERE user_id = ? AND book_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            pstmt.setInt(2, bookId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
}
