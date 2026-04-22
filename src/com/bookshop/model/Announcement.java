package com.bookshop.model;

import java.sql.Timestamp;

/**
 * 公告模型类
 * 用于表示系统公告信息
 */
public class Announcement {
    private int id;
    private String title;
    private String content;
    private Timestamp createdTime;
    private Timestamp updatedTime;

    // 无参构造函数
    public Announcement() {
    }

    // 有参构造函数
    public Announcement(int id, String title, String content, Timestamp createdTime, Timestamp updatedTime) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.createdTime = createdTime;
        this.updatedTime = updatedTime;
    }

    // Getter 和 Setter 方法
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getCreatedTime() {
        return createdTime;
    }

    public void setCreatedTime(Timestamp createdTime) {
        this.createdTime = createdTime;
    }

    public Timestamp getUpdatedTime() {
        return updatedTime;
    }

    public void setUpdatedTime(Timestamp updatedTime) {
        this.updatedTime = updatedTime;
    }

    @Override
    public String toString() {
        return "Announcement{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", createdTime=" + createdTime +
                ", updatedTime=" + updatedTime +
                '}';
    }
}
