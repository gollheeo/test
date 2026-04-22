package com.bookshop.dao;

import com.bookshop.model.User;
import com.bookshop.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    /**
     * 用户注册 - 插入新用户到数据库
     *
     * @param user 用户对象
     * @return 影响的行数（>0表示成功）
     */
    public int register(User user) {
        String sql = "INSERT INTO users (username, password, email, phone, address, role, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // 1. 获取数据库连接
            conn = DBUtil.getConnection();

            // 2. 准备SQL语句（使用 PreparedStatement 防止 SQL 注入）
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getAddress());
            pstmt.setString(6, user.getRole() != null ? user.getRole() : "user");
            pstmt.setInt(7, user.getStatus() != null ? user.getStatus() : 1);

            // 3. 执行SQL更新
            int result = pstmt.executeUpdate();

            if (result > 0) {
                System.out.println("✅ 用户注册成功: " + user.getUsername());
            } else {
                System.out.println("❌ 用户注册失败: " + user.getUsername());
            }

            return result;

        } catch (SQLException e) {
            System.err.println("❌ 注册时发生数据库异常: " + e.getMessage());
            e.printStackTrace();
            return -1;
        } finally {
            // 4. 释放资源
            DBUtil.closeStatement(pstmt);
            DBUtil.closeConnection(conn);
        }
    }

    /**
     * 用户登录验证 - 根据用户名和密码查询用户
     *
     * @param username 用户名
     * @param password 密码
     * @return 如果用户存在且密码正确，返回User对象；否则返回null
     */
    public User login(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND status = 1";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 1. 获取数据库连接
            conn = DBUtil.getConnection();

            // 2. 准备SQL语句
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);

            // 3. 执行查询
            rs = pstmt.executeQuery();

            // 4. 检查是否找到用户
            if (rs.next()) {
                // 用户存在且密码正确
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));
                user.setStatus(rs.getInt("status"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setUpdatedAt(rs.getTimestamp("updated_at"));

                System.out.println("✅ 登录成功: " + username);
                return user;
            } else {
                // 用户不存在或密码错误
                System.out.println("❌ 登录失败: 用户名或密码错误");
                return null;
            }

        } catch (SQLException e) {
            System.err.println("❌ 登录时发生数据库异常: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            // 5. 释放资源
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(pstmt);
            DBUtil.closeConnection(conn);
        }
    }

    /**
     * 检查用户名是否已存在
     *
     * @param username 用户名
     * @return 如果用户名存在返回true，否则返回false
     */
    public boolean usernameExists(String username) {
        String sql = "SELECT id FROM users WHERE username = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);

            rs = pstmt.executeQuery();

            boolean exists = rs.next();

            if (exists) {
                System.out.println("⚠️  用户名已存在: " + username);
            } else {
                System.out.println("✅ 用户名可用: " + username);
            }

            return exists;

        } catch (SQLException e) {
            System.err.println("❌ 检查用户名时发生异常: " + e.getMessage());
            e.printStackTrace();
            return true; // 发生异常时，假设用户存在（保守处理）
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(pstmt);
            DBUtil.closeConnection(conn);
        }
    }

    /**
     * 根据用户ID获取用户信息
     */
    public User getUserById(Integer userId) {
        String sql = "SELECT * FROM users WHERE id = ? AND status = 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 更新用户信息
     */
    public int updateUserInfo(User user) {
        String sql = "UPDATE users SET email=?, phone=?, gender=?, avatar=?, birthday=?, address=?, role=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getEmail());
            pstmt.setString(2, user.getPhone());
            pstmt.setString(3, user.getGender());
            pstmt.setString(4, user.getAvatar());
            if (user.getBirthday() != null) {
                pstmt.setDate(5, new java.sql.Date(user.getBirthday().getTime()));
            } else {
                pstmt.setNull(5, Types.DATE);
            }
            pstmt.setString(6, user.getAddress());
            pstmt.setString(7, user.getRole());  // 添加角色字段
            pstmt.setInt(8, user.getId());       // ID作为WHERE条件

            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    /**
     * 获取所有用户的数量
     */
    public int getAllUsersCount() {
        String sql = "SELECT COUNT(*) FROM users";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            System.err.println("❌ 查询用户总数时发生异常: " + e.getMessage());
            e.printStackTrace();
            return 0;
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(pstmt);
            DBUtil.closeConnection(conn);
        }
    }

    /**
     * 获取所有用户
     */
    public List<User> getAllUsers() {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        List<User> users = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                users.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    /**
     * 删除用户
     */
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    /**
     * 根据搜索关键词获取用户
     */
    public List<User> searchUsers(String keyword) {
        String sql = "SELECT * FROM users WHERE username LIKE ? OR email LIKE ? ORDER BY created_at DESC";
        List<User> users = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String searchKeyword = "%" + keyword + "%";
            pstmt.setString(1, searchKeyword);
            pstmt.setString(2, searchKeyword);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }



    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setEmail(rs.getString("email"));
        u.setRole(rs.getString("role"));
        try { u.setPhone(rs.getString("phone")); } catch (SQLException ignored) {}
        try { u.setGender(rs.getString("gender")); } catch (SQLException ignored) {}
        try { u.setAvatar(rs.getString("avatar")); } catch (SQLException ignored) {}
        try { u.setBirthday(rs.getDate("birthday")); } catch (SQLException ignored) {}
        try { u.setAddress(rs.getString("address")); } catch (SQLException ignored) {}
        try {
            u.setCreatedAt(rs.getTimestamp("created_at"));
        } catch (SQLException ignored) {}
        try {
            u.setUpdatedAt(rs.getTimestamp("updated_at"));
        } catch (SQLException ignored) {}
        try {
            u.setStatus(rs.getInt("status"));
        } catch (SQLException ignored) {}
        return u;
    }

}
