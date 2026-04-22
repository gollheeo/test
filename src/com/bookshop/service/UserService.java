package com.bookshop.service;

import com.bookshop.dao.UserDAO;
import com.bookshop.model.User;

import java.util.List;

public class UserService {
    private UserDAO userDAO = new UserDAO();

    /**
     * 用户注册
     * 业务流程：
     * 1. 验证用户名是否为空
     * 2. 检查用户名是否已存在
     * 3. 验证密码长度
     * 4. 验证邮箱格式（可选）
     * 5. 将用户数据保存到数据库
     */
    public String register(String username, String password, String confirmPassword,
                           String email, String phone, String address) {

        // 1. 验证用户名
        if (username == null || username.trim().isEmpty()) {
            System.out.println("❌ 用户名为空");
            return "用户名不能为空";
        }

        if (username.length() < 3 || username.length() > 20) {
            System.out.println("❌ 用户名长度不符合要求");
            return "用户名长度应为3-20个字符";
        }

        // 2. 检查用户名是否已存在
        if (userDAO.usernameExists(username)) {
            System.out.println("❌ 用户名已存在: " + username);
            return "用户名已存在，请选择其他用户名";
        }

        // 3. 验证密码
        if (password == null || password.isEmpty()) {
            System.out.println("❌ 密码为空");
            return "密码不能为空";
        }

        if (password.length() < 6) {
            System.out.println("❌ 密码长度不符合要求");
            return "密码长度至少为6个字符";
        }

        // 4. 验证两次密码是否一致
        if (!password.equals(confirmPassword)) {
            System.out.println("❌ 两次密码不一致");
            return "两次输入的密码不一致";
        }

        // 5. 验证邮箱格式（简单验证）
        if (email != null && !email.isEmpty()) {
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                System.out.println("❌ 邮箱格式不正确");
                return "邮箱格式不正确";
            }
        }

        // 6. 创建User对象
        User user = new User(username, password, email);
        user.setPhone(phone);
        user.setAddress(address);

        // 7. 保存到数据库
        int result = userDAO.register(user);

        if (result > 0) {
            System.out.println("✅ 注册成功");
            return "success";
        } else {
            System.out.println("❌ 注册失败");
            return "注册失败，请稍后重试";
        }
    }

    /**
     * 用户登录
     * 业务流程：
     * 1. 验证用户名和密码不为空
     * 2. 调用DAO查询数据库
     * 3. 返回用户对象或null
     */
    public User login(String username, String password) {

        // 1. 验证用户名和密码
        if (username == null || username.trim().isEmpty()) {
            System.out.println("❌ 用户名为空");
            return null;
        }

        if (password == null || password.isEmpty()) {
            System.out.println("❌ 密码为空");
            return null;
        }

        // 2. 调用DAO查询用户
        User user = userDAO.login(username, password);

        if (user != null) {
            System.out.println("✅ 登录验证成功: " + user.getUsername());
        } else {
            System.out.println("❌ 登录验证失败: 用户名或密码错误");
        }

        return user;
    }

    /**
     * 获取用户信息
     */
    public User getUserInfo(Integer userId) {
        if (userId == null || userId <= 0) {
            return null;
        }
        return userDAO.getUserById(userId);
    }

    /**
     * 更新用户信息
     */
    public boolean updateUserInfo(User user) {
        int rows = userDAO.updateUserInfo(user);
        return rows > 0;
    }
    /**
     * 获取所有用户的数量
     */
    public int getAllUsersCount() {
        return userDAO.getAllUsersCount();
    }

    /**
     * 获取所有用户
     */
    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    /**
     * 根据搜索关键词获取用户
     */
    public List<User> searchUsers(String keyword) {
        return userDAO.searchUsers(keyword);
    }

    /**
     * 删除用户
     */
    public boolean deleteUser(int userId) {
        return userDAO.deleteUser(userId);
    }


}
