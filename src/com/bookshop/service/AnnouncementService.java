package com.bookshop.service;

import com.bookshop.dao.AnnouncementDAO;
import com.bookshop.model.Announcement;
import java.util.List;

/**
 * 公告服务类
 * 处理公告相关的业务逻辑
 */
public class AnnouncementService {
    private AnnouncementDAO announcementDAO = new AnnouncementDAO();

    /**
     * 获取所有公告
     * @return 公告列表
     */
    public List<Announcement> getAllAnnouncements() {
        System.out.println("🔍 获取所有公告");
        try {
            List<Announcement> announcements = announcementDAO.findAll();
            System.out.println("✅ 成功获取 " + announcements.size() + " 条公告");
            return announcements;
        } catch (Exception e) {
            System.out.println("❌ 获取公告列表失败: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 根据ID获取公告
     * @param id 公告ID
     * @return 公告对象
     */
    public Announcement getAnnouncementById(int id) {
        System.out.println("🔍 获取公告 ID: " + id);
        try {
            Announcement announcement = announcementDAO.findById(id);
            if (announcement != null) {
                System.out.println("✅ 成功获取公告: " + announcement.getTitle());
            } else {
                System.out.println("⚠️ 未找到ID为 " + id + " 的公告");
            }
            return announcement;
        } catch (Exception e) {
            System.out.println("❌ 获取公告失败: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 添加公告
     * @param title 公告标题
     * @param content 公告内容
     * @return 操作是否成功
     */
    public boolean addAnnouncement(String title, String content) {
        System.out.println("📝 添加公告 - 标题: " + title);
        try {
            Announcement announcement = new Announcement();
            announcement.setTitle(title);
            announcement.setContent(content);

            boolean result = announcementDAO.insert(announcement);
            if (result) {
                System.out.println("✅ 公告添加成功");
                return true;
            } else {
                System.out.println("❌ 公告添加失败");
                return false;
            }
        } catch (Exception e) {
            System.out.println("❌ 添加公告时发生错误: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 更新公告
     * @param id 公告ID
     * @param title 公告标题
     * @param content 公告内容
     * @return 操作是否成功
     */
    public boolean updateAnnouncement(int id, String title, String content) {
        System.out.println("✏️ 更新公告 ID: " + id);
        try {
            Announcement announcement = new Announcement();
            announcement.setId(id);
            announcement.setTitle(title);
            announcement.setContent(content);

            boolean result = announcementDAO.update(announcement);
            if (result) {
                System.out.println("✅ 公告更新成功");
                return true;
            } else {
                System.out.println("❌ 公告更新失败");
                return false;
            }
        } catch (Exception e) {
            System.out.println("❌ 更新公告时发生错误: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 删除公告
     * @param id 公告ID
     * @return 操作是否成功
     */
    public boolean deleteAnnouncement(int id) {
        System.out.println("🗑️ 删除公告 ID: " + id);
        try {
            boolean result = announcementDAO.delete(id);
            if (result) {
                System.out.println("✅ 公告删除成功");
                return true;
            } else {
                System.out.println("❌ 公告删除失败");
                return false;
            }
        } catch (Exception e) {
            System.out.println("❌ 删除公告时发生错误: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 获取公告总数
     * @return 公告总数
     */
    public int getTotalAnnouncements() {
        System.out.println("📊 获取公告总数");
        try {
            int count = announcementDAO.count();
            System.out.println("✅ 公告总数: " + count);
            return count;
        } catch (Exception e) {
            System.out.println("❌ 获取公告总数失败: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 搜索公告
     * @param keyword 搜索关键词
     * @return 匹配的公告列表
     */
    public List<Announcement> searchAnnouncements(String keyword) {
        System.out.println("🔍 搜索公告 - 关键词: " + keyword);
        try {
            List<Announcement> announcements = announcementDAO.searchByTitle(keyword);
            System.out.println("✅ 搜索到 " + announcements.size() + " 条公告");
            return announcements;
        } catch (Exception e) {
            System.out.println("❌ 搜索公告失败: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}
