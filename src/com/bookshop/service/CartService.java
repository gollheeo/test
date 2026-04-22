package com.bookshop.service;

import com.bookshop.dao.BookDAO;
import com.bookshop.dao.CartDAO;
import com.bookshop.model.Book;
import com.bookshop.model.CartItem;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class CartService {
    private CartDAO cartDAO = new CartDAO();
    private BookDAO bookDAO = new BookDAO();

    /**
     * 添加商品到购物车
     * @param userId 用户ID
     * @param bookId 商品ID
     * @return 是否成功
     */
    public boolean addToCart(int userId, int bookId) {
        try {
            // 获取图书信息
            Book book = bookDAO.getBookById(bookId);
            if (book == null) {
                return false;
            }

            // 检查商品是否已在购物车中
            if (cartDAO.isItemInCart(userId, bookId)) {
                // 如果已存在，更新数量（增加1）
                CartItem existingItem = cartDAO.getCartItem(userId, bookId);
                cartDAO.updateQuantity(userId, bookId, existingItem.getQuantity() + 1);
            } else {
                // 如果不存在，添加新商品
                cartDAO.insertNewItem(userId, bookId, book.getTitle(), book.getPrice(), 1);
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 更新购物车中商品的数量
     * @param userId 用户ID
     * @param bookId 商品ID
     * @param quantity 新数量
     * @return 是否成功
     */
    public boolean updateQuantity(int userId, int bookId, int quantity) {
        try {
            cartDAO.updateQuantity(userId, bookId, quantity);
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 从购物车中移除商品
     * @param userId 用户ID
     * @param bookId 商品ID
     * @return 是否成功
     */
    public boolean removeItem(int userId, int bookId) {
        try {
            cartDAO.deleteItem(userId, bookId);
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 清空用户购物车
     * @param userId 用户ID
     * @return 是否成功
     */
    public boolean clearCart(int userId) {
        try {
            cartDAO.clearCart(userId);
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 获取用户购物车中的所有商品
     * @param userId 用户ID
     * @return 购物车商品列表
     */
    public List<CartItem> getCartItems(int userId) {
        try {
            return cartDAO.getCartItems(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 获取购物车中指定商品
     * @param userId 用户ID
     * @param bookId 商品ID
     * @return 购物车商品项
     */
    public CartItem getCartItem(int userId, int bookId) {
        try {
            return cartDAO.getCartItem(userId, bookId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
