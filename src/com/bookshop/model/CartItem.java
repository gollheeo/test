package com.bookshop.model;

import java.math.BigDecimal;
import java.util.Date;

public class CartItem {
    private Integer id;
    private Integer userId;
    private Integer bookId;
    private String bookName;
    private BigDecimal price;
    private Integer quantity;
    private Date createdAt;
    private Date updatedAt;

    public CartItem() {}

    public CartItem(Integer userId, Integer bookId, String bookName, BigDecimal price, Integer quantity) {
        this.userId = userId;
        this.bookId = bookId;
        this.bookName = bookName;
        this.price = price;
        this.quantity = quantity;
    }

    // 计算小计金额
    public BigDecimal getSubtotal() {
        if (price == null || quantity == null) {
            return BigDecimal.ZERO;
        }
        return price.multiply(new BigDecimal(quantity));
    }

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public Integer getBookId() { return bookId; }
    public void setBookId(Integer bookId) { this.bookId = bookId; }

    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
