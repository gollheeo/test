package com.bookshop.model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class Order {
    private Integer id;
    private Integer userId;
    private String orderNo;
    private BigDecimal totalPrice;
    private String status; // pending, paid, shipped, completed, cancelled
    private Date createdAt;
    private Date updatedAt;
    private List<OrderItem> items; // 订单项目列表

    public Order() {}

    public Order(Integer userId, String orderNo, BigDecimal totalPrice) {
        this.userId = userId;
        this.orderNo = orderNo;
        this.totalPrice = totalPrice;
        this.status = "pending";
    }

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getOrderNo() { return orderNo; }
    public void setOrderNo(String orderNo) { this.orderNo = orderNo; }

    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }
}
