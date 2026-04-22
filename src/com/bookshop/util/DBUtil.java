package com.bookshop.util;

import java.sql.*;
import java.io.InputStream;
import java.util.Properties;

public class DBUtil {
     static String url= "jdbc:mysql://localhost:3306/bookshop?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
     static String username = "root";
     static String password = "123456";

//    private static String driver ;
//    private static String url;
//    private static String username;
//    private static String password;
    // 静态代码块：类加载时执行，加载数据库配置
    static {
        try {
            // 1. 加载配置文件
//            Properties props = new Properties();
//            InputStream input = DBUtil.class.getClassLoader()
//                    .getResourceAsStream("../../resources/config.properties");
//
//            if (input == null) {
//                throw new RuntimeException("config.properties 文件未找到！");
//            }
//
//            props.load(input);
//
//            // 2. 从配置文件读取参数
//            driver = props.getProperty("db.driver");
//            url = props.getProperty("db.url");
//            username = props.getProperty("db.username");
//            password = props.getProperty("db.password");

//             3. 加载 MySQL 驱动
            Class.forName("com.mysql.cj.jdbc.Driver");

            System.out.println("✅ 数据库驱动加载成功！");
            System.out.println("✅ 连接地址: " + url);

        } catch (Exception e) {
            System.err.println("❌ 数据库配置加载失败！");
            e.printStackTrace();
            throw new RuntimeException("数据库配置初始化失败", e);
        }
    }

    /**
     * 获取数据库连接
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(url, username, password);
            System.out.println("✅ 数据库连接成功！");
            return conn;
        } catch (SQLException e) {
            System.err.println("❌ 数据库连接失败！");
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * 关闭数据库连接
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("✅ 数据库连接已关闭！");
            } catch (SQLException e) {
                System.err.println("❌ 关闭连接失败！");
                e.printStackTrace();
            }
        }
    }

    /**
     * 关闭 Statement
     */
    public static void closeStatement(Statement stmt) {
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 关闭 ResultSet
     */
    public static void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 测试数据库连接（可以在应用启动时调用）
     */
    public static void testConnection() {
        Connection conn = null;
        try {
            conn = getConnection();
            if (conn != null) {
                System.out.println("✅ 数据库连接测试成功！");
            }
        } catch (SQLException e) {
            System.err.println("❌ 数据库连接测试失败！");
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
    }
}
