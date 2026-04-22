package com.bookshop.dao;

import com.bookshop.model.Announcement;
import com.bookshop.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 公告数据访问对象
 * 处理公告相关的数据库操作
 */
public class AnnouncementDAO {

    /**
     * 查找所有公告
     * @return 公告列表
     */
    public List<Announcement> findAll() {
        System.out.println("🔍 查询所有公告");
        List<Announcement> announcements = new ArrayList<>();
        String sql = "SELECT * FROM announcements ORDER BY created_time DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Announcement announcement = mapResultSetToAnnouncement(rs);
                announcements.add(announcement);
            }

            System.out.println("✅ 成功查询到 " + announcements.size() + " 条公告");
            return announcements;
        } catch (SQLException e) {
            System.out.println("❌ 查询所有公告失败: " + e.getMessage());
            e.printStackTrace();
            return announcements;
        }
    }

    /**
     * 根据ID查找公告
     * @param id 公告ID
     * @return 公告对象
     */
    public Announcement findById(int id) {
        System.out.println("🔍 查询公告 ID: " + id);
        String sql = "SELECT * FROM announcements WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Announcement announcement = mapResultSetToAnnouncement(rs);
                    System.out.println("✅ 成功查询公告: " + announcement.getTitle());
                    return announcement;
                } else {
                    System.out.println("⚠️ 未找到ID为 " + id + " 的公告");
                    return null;
                }
            }
        } catch (SQLException e) {
            System.out.println("❌ 查询公告失败: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 插入新公告
     * @param announcement 公告对象
     * @return 操作是否成功
     */
    public boolean insert(Announcement announcement) {
        System.out.println("📝 插入公告: " + announcement.getTitle());
        String sql = "INSERT INTO announcements (title, content, created_time) VALUES (?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, announcement.getTitle());
            stmt.setString(2, announcement.getContent());
            stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    announcement.setId(generatedKeys.getInt(1));
                }
                System.out.println("✅ 公告插入成功，ID: " + announcement.getId());
                return true;
            } else {
                System.out.println("❌ 公告插入失败");
                return false;
            }
        } catch (SQLException e) {
            System.out.println("❌ 插入公告失败: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 更新公告
     * @param announcement 公告对象
     * @return 操作是否成功
     */
    public boolean update(Announcement announcement) {
        System.out.println("✏️ 更新公告 ID: " + announcement.getId());
        String sql = "UPDATE announcements SET title = ?, content = ?, updated_time = ? WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, announcement.getTitle());
            stmt.setString(2, announcement.getContent());
            stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            stmt.setInt(4, announcement.getId());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("✅ 公告更新成功");
                return true;
            } else {
                System.out.println("❌ 公告更新失败");
                return false;
            }
        } catch (SQLException e) {
            System.out.println("❌ 更新公告失败: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 删除公告
     * @param id 公告ID
     * @return 操作是否成功
     */
    public boolean delete(int id) {
        System.out.println("🗑️ 删除公告 ID: " + id);
        String sql = "DELETE FROM announcements WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("✅ 公告删除成功");
                return true;
            } else {
                System.out.println("❌ 公告删除失败");
                return false;
            }
        } catch (SQLException e) {
            System.out.println("❌ 删除公告失败: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 统计公告总数
     * @return 公告总数
     */
    public int count() {
        System.out.println("📊 统计公告总数");
        String sql = "SELECT COUNT(*) FROM announcements";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("✅ 公告总数: " + count);
                return count;
            }
        } catch (SQLException e) {
            System.out.println("❌ 统计公告总数失败: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 根据标题搜索公告
     * @param keyword 搜索关键词
     * @return 匹配的公告列表
     */
    public List<Announcement> searchByTitle(String keyword) {
        System.out.println("🔍 搜索公告 - 关键词: " + keyword);
        List<Announcement> announcements = new ArrayList<>();
        String sql = "SELECT * FROM announcements WHERE title LIKE ? ORDER BY created_time DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + keyword + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Announcement announcement = mapResultSetToAnnouncement(rs);
                    announcements.add(announcement);
                }
            }

            System.out.println("✅ 搜索到 " + announcements.size() + " 条公告");
            return announcements;
        } catch (SQLException e) {
            System.out.println("❌ 搜索公告失败: " + e.getMessage());
            e.printStackTrace();
            return announcements;
        }
    }

    /**
     * 将ResultSet记录映射为Announcement对象
     * @param rs ResultSet对象
     * @return Announcement对象
     */
    private Announcement mapResultSetToAnnouncement(ResultSet rs) throws SQLException {
        Announcement announcement = new Announcement();
        announcement.setId(rs.getInt("id"));
        announcement.setTitle(rs.getString("title"));
        announcement.setContent(rs.getString("content"));
        announcement.setCreatedTime(rs.getTimestamp("created_time"));
        announcement.setUpdatedTime(rs.getTimestamp("updated_time"));
        return announcement;
    }
}
