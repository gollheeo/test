package com.bookshop.model;

import java.math.BigDecimal;

/**
 * 订单项目类 - 表示订单中的单个商品
 */
public class OrderItem {
    private Integer id;
    private Integer orderId;
    private Integer bookId;
    private String bookName;  // 新增图书名称字段
    private Integer quantity;
    private BigDecimal price;

    // 构造函数
    public OrderItem() {}

    public OrderItem(Integer orderId, Integer bookId, String bookName, Integer quantity, BigDecimal price) {
        this.orderId = orderId;
        this.bookId = bookId;
        this.bookName = bookName;  // 新增参数
        this.quantity = quantity;
        this.price = price;
    }

    // Getters and Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Integer getBookId() {
        return bookId;
    }

    public void setBookId(Integer bookId) {
        this.bookId = bookId;
    }

    // 新增图书名称的getter和setter
    public String getBookName() {
        return bookName;
    }

    public void setBookName(String bookName) {
        this.bookName = bookName;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    @Override
    public String toString() {
        return "OrderItem{" +
                "id=" + id +
                ", orderId=" + orderId +
                ", bookId=" + bookId +
                ", bookName='" + bookName + '\'' +
                ", quantity=" + quantity +
                ", price=" + price +
                '}';
    }
}
