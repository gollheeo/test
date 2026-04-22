package com.bookshop.model;

import java.math.BigDecimal;
import java.util.Date;

public class Book {
    private Integer id;
    private String title;
    private String author;
    private Integer categoryId;
    private BigDecimal price;
    private BigDecimal oldPrice;
    private Integer stock;
    private String description;
    private String coverImage;
    private Boolean isHot;
    private Boolean isFeatured;
    private Integer status;
    private Date publishDate;
    private Integer sales;
    private String publisher;



    // 构造函数、Getter、Setter
    public Book() {}

    public Book(String title, String author, BigDecimal price, Integer stock) {
        this.title = title;
        this.author = author;
        this.price = price;
        this.stock = stock;
        this.status = 1;
    }

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public Integer getCategoryId() { return categoryId; }
    public void setCategoryId(Integer categoryId) { this.categoryId = categoryId; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public Integer getStock() { return stock; }
    public void setStock(Integer stock) { this.stock = stock; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }

    public Boolean getIsHot() { return isHot; }
    public void setIsHot(Boolean isHot) { this.isHot = isHot; }

    public Boolean getIsFeatured() { return isFeatured; }
    public void setIsFeatured(Boolean isFeatured) { this.isFeatured = isFeatured; }

    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }

    public Date getPublishDate() { return publishDate; }
    public void setPublishDate(Date publishDate) { this.publishDate = publishDate; }

    public Integer getSales() {
        return sales;
    }

    public void setSales(Integer sales) {
        this.sales = sales;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public BigDecimal getOldPrice() {
        return oldPrice;
    }

    public void setOldPrice(BigDecimal oldPrice) {
        this.oldPrice = oldPrice;
    }
}
