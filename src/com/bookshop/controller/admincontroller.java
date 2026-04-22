package com.bookshop.controller;

import com.bookshop.model.Announcement;
import com.bookshop.model.Book;
import com.bookshop.model.Order;
import com.bookshop.model.User;
import com.bookshop.service.AnnouncementService;
import com.bookshop.service.BookService;
import com.bookshop.service.OrderService;
import com.bookshop.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * 管理后台控制器
 * 处理管理员后台页面跳转及相关操作
 */
@WebServlet("/admin/*")
public class admincontroller extends HttpServlet {
    private UserService userService = new UserService();
    private BookService bookService = new BookService();
    private AnnouncementService announcementService = new AnnouncementService();
    private OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 设置请求和响应的编码
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String action = getAction(req);

        // 检查用户是否登录且为管理员
        if (!isAdminUser(req, resp)) {
            return;
        }

        switch (action) {
            case "dashboard":
                showDashboard(req, resp);
                break;
            case "books":
                showBooks(req, resp);
                break;
            case "announcements":
                showAnnouncements(req, resp);
                break;
            case "orders":
                showOrders(req, resp);
                break;
            case "users":
                showUsers(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String action = getAction(req);

        // 检查用户是否登录且为管理员
        if (!isAdminUser(req, resp)) {
            return;
        }

        switch (action) {
            case "book/add":
                addBook(req, resp);
                break;
            case "book/update":
                updateBook(req, resp);
                break;
            case "book/delete":
                deleteBook(req, resp);
                break;
            case "announcement/add":
                addAnnouncement(req, resp);
                break;
            case "announcement/update":
                updateAnnouncement(req, resp);
                break;
            case "announcement/delete":
                deleteAnnouncement(req, resp);
                break;
            case "user/delete":
                deleteUser(req, resp);
                break;
            case "user/update":
                updateUser(req, resp);
                break;
            case "order/updateStatus":
                updateOrderStatus(req, resp);
                break;
            case "order/delete":
                deleteOrder(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }


    /**
     * 显示仪表盘页面
     */
    private void showDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        System.out.println("📊 管理员仪表盘请求");

        // 获取统计数据
        List<Book> books = bookService.getAllBooks();
        int totalBooks = books != null ? books.size() : 0;
        int totalUsers = userService.getAllUsersCount();

        // 获取订单相关统计数据
        List<Order> allOrders = orderService.getAllOrders();
        int totalOrders = allOrders != null ? allOrders.size() : 0;

        // 计算待处理订单数量（未支付、已支付但未发货）
        int pendingOrders = 0;
        BigDecimal monthlyRevenue = BigDecimal.ZERO;

        if (allOrders != null) {
            for (Order order : allOrders) {
                // 统计待处理订单（假设待处理为"pending"或"paid"状态）
                if ("pending".equals(order.getStatus()) || "paid".equals(order.getStatus())) {
                    pendingOrders++;
                }

                // 计算月收入（假设为当前月份的订单）
                if (order.getCreatedAt() != null) {
                    // 检查是否为当前月份（简化实现）
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    java.util.Calendar orderCal = java.util.Calendar.getInstance();
                    orderCal.setTime(order.getCreatedAt());

                    if (orderCal.get(java.util.Calendar.YEAR) == cal.get(java.util.Calendar.YEAR) &&
                            orderCal.get(java.util.Calendar.MONTH) == cal.get(java.util.Calendar.MONTH)) {
                        monthlyRevenue = monthlyRevenue.add(order.getTotalPrice());
                    }
                }
            }
        }

        // 设置属性
        req.setAttribute("totalBooks", totalBooks);
        req.setAttribute("totalUsers", totalUsers);
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("pendingOrders", pendingOrders);
        req.setAttribute("monthlyRevenue", "¥" + monthlyRevenue.setScale(2, BigDecimal.ROUND_HALF_UP));

        req.getRequestDispatcher("/Jsp/Dash/dashboard.jsp").forward(req, resp);
    }



    /**
     * 显示商品管理页面
     */
    private void showBooks(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        System.out.println("📚 商品管理页面请求");

        // 获取搜索参数
        String search = req.getParameter("search");
        List<Book> books;

        if (search != null && !search.trim().isEmpty()) {
            books = bookService.searchBooks(search);
        } else {
            books = bookService.getAllBooksIncludingDeleted();  // 使用新方法
        }

        req.setAttribute("books", books);
        req.getRequestDispatcher("/Jsp/Dash/books.jsp").forward(req, resp);
    }


    /**
     * 添加商品
     */
    private void addBook(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        System.out.println("➕ 添加商品请求");

        // 获取基本参数
        String title = req.getParameter("title");
        String author = req.getParameter("author");
        String priceStr = req.getParameter("price");
        String stockStr = req.getParameter("stock");
        String categoryIdStr = req.getParameter("categoryId");
        String description = req.getParameter("description");

        // 获取额外参数
        String oldPriceStr = req.getParameter("oldPrice");
        String salesStr = req.getParameter("sales");
        String publisher = req.getParameter("publisher");
        String isHotStr = req.getParameter("isHot");
        String isFeaturedStr = req.getParameter("isFeatured");
        String publishDateStr = req.getParameter("publishDate");
        String statusStr = req.getParameter("status");
        String coverImage = req.getParameter("coverImage");

        try {
            // 转换基本参数
            BigDecimal price = priceStr != null && !priceStr.isEmpty()
                    ? new BigDecimal(priceStr) : BigDecimal.ZERO;
            int stock = stockStr != null && !stockStr.isEmpty()
                    ? Integer.parseInt(stockStr) : 0;
            int categoryId = categoryIdStr != null && !categoryIdStr.isEmpty()
                    ? Integer.parseInt(categoryIdStr) : 1;

            // 转换额外参数
            BigDecimal oldPrice = oldPriceStr != null && !oldPriceStr.isEmpty()
                    ? new BigDecimal(oldPriceStr) : null;
            int sales = salesStr != null && !salesStr.isEmpty()
                    ? Integer.parseInt(salesStr) : 0;
            boolean isHot = "true".equalsIgnoreCase(isHotStr);
            boolean isFeatured = "true".equalsIgnoreCase(isFeaturedStr);
            Integer status = statusStr != null && !statusStr.isEmpty()
                    ? Integer.parseInt(statusStr) : 1;

            // 处理日期
            Date publishDate = null;
            if (publishDateStr != null && !publishDateStr.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    publishDate = sdf.parse(publishDateStr);
                } catch (ParseException e) {
                    System.out.println("日期格式错误: " + e.getMessage());
                }
            }

            // 创建图书对象
            Book book = new Book();
            book.setTitle(title);
            book.setAuthor(author);
            book.setPrice(price);
            book.setStock(stock);
            book.setCategoryId(categoryId);
            book.setDescription(description);
            book.setOldPrice(oldPrice);
            book.setSales(sales);
            book.setPublisher(publisher);
            book.setIsHot(isHot);
            book.setIsFeatured(isFeatured);
            book.setPublishDate(publishDate);
            book.setStatus(status);
            book.setCoverImage(coverImage);

            boolean success = bookService.addBook(book);

            if (success) {
                System.out.println("✅ 商品添加成功");
                resp.sendRedirect(req.getContextPath() + "/admin/books");
            } else {
                System.out.println("❌ 商品添加失败");
                redirectWithError(req, resp, "/admin/books", "添加失败");
            }
        } catch (NumberFormatException e) {
            System.out.println("❌ 参数格式错误: " + e.getMessage());
            redirectWithError(req, resp, "/admin/books", "参数格式错误");
        }
    }

    /**
     * 更新商品
     */
    private void updateBook(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        System.out.println("✏️ 更新商品请求");

        // 获取基本参数
        String idStr = req.getParameter("id");
        String title = req.getParameter("title");
        String author = req.getParameter("author");
        String priceStr = req.getParameter("price");
        String stockStr = req.getParameter("stock");
        String categoryIdStr = req.getParameter("categoryId");
        String description = req.getParameter("description");

        // 获取额外参数
        String oldPriceStr = req.getParameter("oldPrice");
        String salesStr = req.getParameter("sales");
        String publisher = req.getParameter("publisher");
        String isHotStr = req.getParameter("isHot");
        String isFeaturedStr = req.getParameter("isFeatured");
        String publishDateStr = req.getParameter("publishDate");
        String statusStr = req.getParameter("status");
        String coverImage = req.getParameter("coverImage");

        try {
            // 转换基本参数
            int id = Integer.parseInt(idStr);
            BigDecimal price = priceStr != null && !priceStr.isEmpty()
                    ? new BigDecimal(priceStr) : BigDecimal.ZERO;
            int stock = stockStr != null && !stockStr.isEmpty()
                    ? Integer.parseInt(stockStr) : 0;
            int categoryId = categoryIdStr != null && !categoryIdStr.isEmpty()
                    ? Integer.parseInt(categoryIdStr) : 1;

            // 转换额外参数
            BigDecimal oldPrice = oldPriceStr != null && !oldPriceStr.isEmpty()
                    ? new BigDecimal(oldPriceStr) : null;
            int sales = salesStr != null && !salesStr.isEmpty()
                    ? Integer.parseInt(salesStr) : 0;
            boolean isHot = "true".equalsIgnoreCase(isHotStr);
            boolean isFeatured = "true".equalsIgnoreCase(isFeaturedStr);
            Integer status = statusStr != null && !statusStr.isEmpty()
                    ? Integer.parseInt(statusStr) : 1;

            // 处理日期
            Date publishDate = null;
            if (publishDateStr != null && !publishDateStr.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    publishDate = sdf.parse(publishDateStr);
                } catch (ParseException e) {
                    System.out.println("日期格式错误: " + e.getMessage());
                }
            }

            // 创建图书对象
            Book book = new Book();
            book.setId(id);
            book.setTitle(title);
            book.setAuthor(author);
            book.setPrice(price);
            book.setStock(stock);
            book.setCategoryId(categoryId);
            book.setDescription(description);
            book.setOldPrice(oldPrice);
            book.setSales(sales);
            book.setPublisher(publisher);
            book.setIsHot(isHot);
            book.setIsFeatured(isFeatured);
            book.setPublishDate(publishDate);
            book.setStatus(status);
            book.setCoverImage(coverImage);

            boolean success = bookService.updateBook(book);

            if (success) {
                System.out.println("✅ 商品更新成功");
                resp.sendRedirect(req.getContextPath() + "/admin/books");
            } else {
                System.out.println("❌ 商品更新失败");
                redirectWithError(req, resp, "/admin/books", "更新失败");
            }
        } catch (NumberFormatException e) {
            System.out.println("❌ 参数格式错误: " + e.getMessage());
            redirectWithError(req, resp, "/admin/books", "参数格式错误");
        }
    }

    /**
     * 删除商品
     */
    private void deleteBook(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        System.out.println("🗑️ 删除商品请求");

        String bookIdStr = req.getParameter("bookId");

        try {
            int bookId = Integer.parseInt(bookIdStr);
            boolean success = bookService.deleteBook(bookId);

            if (success) {
                System.out.println("✅ 商品删除成功");
                resp.sendRedirect(req.getContextPath() + "/admin/books");
            } else {
                System.out.println("❌ 商品删除失败");
                redirectWithError(req, resp, "/admin/books", "删除失败");
            }
        } catch (NumberFormatException e) {
            System.out.println("❌ 商品ID格式错误: " + e.getMessage());
            redirectWithError(req, resp, "/admin/books", "ID格式错误");
        }
    }

    /**
     * 显示公告管理页面
     */
    private void showAnnouncements(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        System.out.println("📢 公告管理页面请求");

        // 获取所有公告
        List<Announcement> announcements = announcementService.getAllAnnouncements();
        req.setAttribute("announcements", announcements);

        req.getRequestDispatcher("/Jsp/Dash/announcements.jsp").forward(req, resp);
    }

    /**
     * 添加公告
     */
    private void addAnnouncement(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        System.out.println("➕ 添加公告请求");

        String title = req.getParameter("title");
        String content = req.getParameter("content");

        boolean success = announcementService.addAnnouncement(title, content);

        if (success) {
            System.out.println("✅ 公告添加成功");
            resp.sendRedirect(req.getContextPath() + "/admin/announcements");
        } else {
            System.out.println("❌ 公告添加失败");
                redirectWithError(req, resp, "/admin/announcements", "添加失败");
        }
    }

    /**
     * 更新公告
     */
    private void updateAnnouncement(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        System.out.println("✏️ 更新公告请求");

        String idStr = req.getParameter("id");
        String title = req.getParameter("title");
        String content = req.getParameter("content");

        try {
            int id = Integer.parseInt(idStr);
            boolean success = announcementService.updateAnnouncement(id, title, content);

            if (success) {
                System.out.println("✅ 公告更新成功");

                resp.sendRedirect(req.getContextPath() + "/admin/announcements");
            } else {
                System.out.println("❌ 公告更新失败");
                String msg = java.net.URLEncoder.encode("更新失败", "UTF-8");  // 关键
                resp.sendRedirect(req.getContextPath() + "/admin/announcements?error="+ msg);
            }
        } catch (NumberFormatException e) {
            System.out.println("❌ 公告ID格式错误: " + e.getMessage());
            String msg = java.net.URLEncoder.encode("ID格式错误", "UTF-8");  // 关键
            resp.sendRedirect(req.getContextPath() + "/admin/announcements?error="+ msg);
        }
    }

    /**
     * 删除公告
     */
    private void deleteAnnouncement(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        System.out.println("🗑️ 删除公告请求");

        String announcementIdStr = req.getParameter("id");

        // 检查参数是否为null或空
        if (announcementIdStr == null || announcementIdStr.trim().isEmpty()) {
            System.out.println("❌ 公告ID参数为空");
            redirectWithError(req, resp, "/admin/announcements", "公告ID不能为空");
            return;
        }

        try {
            int announcementId = Integer.parseInt(announcementIdStr);
            boolean success = announcementService.deleteAnnouncement(announcementId);

            if (success) {
                System.out.println("✅ 公告删除成功: " + announcementId);
                String msg = java.net.URLEncoder.encode("公告删除成功", "UTF-8");  // 关键
                resp.sendRedirect(req.getContextPath() + "/admin/announcements?success="+ msg);
            } else {
                System.out.println("❌ 公告删除失败: " + announcementId);
                String msg = java.net.URLEncoder.encode("公告删除失败", "UTF-8");  // 关键
                resp.sendRedirect(req.getContextPath() + "/admin/announcements?error="+ msg);
            }
        } catch (NumberFormatException e) {
            System.out.println("❌ 公告ID格式错误: " + e.getMessage());
            String msg = java.net.URLEncoder.encode("公告ID格式错误", "UTF-8");  // 关键
            resp.sendRedirect(req.getContextPath() + "/admin/announcements?error="+ msg);
        }
    }

    /**
     * 显示订单管理页面
     */
    private void showOrders(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        System.out.println("📋 订单管理页面请求");

        // 获取搜索参数
        String search = req.getParameter("search");
        List<Order> orders;

        if (search != null && !search.trim().isEmpty()) {
            orders = orderService.searchOrders(search);
        } else {
            orders = orderService.getAllOrders();
        }

        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/Jsp/Dash/orders.jsp").forward(req, resp);
    }


    /**
     * 显示用户管理页面
     */
    private void showUsers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        System.out.println("👥 用户管理页面请求");

        // 获取搜索参数
        String search = req.getParameter("search");
        List<User> users;

        if (search != null && !search.trim().isEmpty()) {
            users = userService.searchUsers(search);
        } else {
            users = userService.getAllUsers();
        }

        req.setAttribute("users", users);
        req.getRequestDispatcher("/Jsp/Dash/users.jsp").forward(req, resp);
    }


    /**
     * 删除用户
     */
    private void deleteUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String userIdStr = req.getParameter("id");

        try {
            int userId = Integer.parseInt(userIdStr);

            // 检查是否为管理员用户，防止删除自己
            User currentUser = (User) req.getSession().getAttribute("user");
            if (currentUser != null && currentUser.getId() == userId) {
                System.out.println("❌ 不能删除当前登录用户");
                redirectWithError(req, resp, "/admin/users", "不能删除当前登录用户");
                return;
            }

            boolean success = userService.deleteUser(userId);

            if (success) {
                System.out.println("✅ 用户删除成功: " + userId);
                redirectWithSuccess(req, resp, "/admin/users", "用户删除成功");
            } else {
                System.out.println("❌ 用户删除失败: " + userId);
                redirectWithError(req, resp, "/admin/users", "用户删除失败");
            }
        } catch (NumberFormatException e) {
            System.out.println("❌ 用户ID格式错误: " + e.getMessage());
            redirectWithError(req, resp, "/admin/users", "ID格式错误");
        }
    }


    /**
     * 更新用户信息
     */
    private void updateUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        System.out.println("✏️ 更新用户信息请求");

        String userIdStr = req.getParameter("id");
        String role = req.getParameter("role");
        String statusStr = req.getParameter("status");

        try {
            int userId = Integer.parseInt(userIdStr);
            User user = userService.getUserInfo(userId);

            if (user == null) {
                System.out.println("❌ 用户不存在: " + userId);
                redirectWithError(req, resp, "/admin/users", "用户不存在");
                return;
            }

            // 更新角色
            if (role != null && !role.isEmpty()) {
                user.setRole(role);
            }

            // 更新状态
            if (statusStr != null && !statusStr.isEmpty()) {
                try {
                    int status = Integer.parseInt(statusStr);
                    user.setStatus(status);
                } catch (NumberFormatException e) {
                    System.out.println("❌ 状态格式错误: " + e.getMessage());
                }
            }

            boolean success = userService.updateUserInfo(user);

            if (success) {
                System.out.println("✅ 用户信息更新成功: " + userId);
                String msg = java.net.URLEncoder.encode("用户信息更新成功", "UTF-8");  // 关键
                resp.sendRedirect(req.getContextPath() + "/admin/users?success=" + msg);
            } else {
                System.out.println("❌ 用户信息更新失败: " + userId);
                String msg = java.net.URLEncoder.encode("用户信息更新失败", "UTF-8");  // 关键
                resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + msg);
            }
        } catch (NumberFormatException e) {
            System.out.println("❌ 用户ID格式错误: " + e.getMessage());
            String msg = java.net.URLEncoder.encode("格式错误", "UTF-8");  // 关键
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + msg);
        }
    }


    /**
     * 更新订单状态
     */
    private void updateOrderStatus(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8"); // 设置JSON响应类型

        System.out.println("✏️ 更新订单状态请求");

        String orderIdStr = req.getParameter("id");
        String status = req.getParameter("status");

        try {
            int orderId = Integer.parseInt(orderIdStr);

            // 验证状态值是否有效
            if (status == null || !isValidOrderStatus(status)) {
                System.out.println("❌ 无效的订单状态: " + status);
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"success\":false,\"error\":\"无效的订单状态\"}");
                return;
            }

            boolean success = orderService.updateOrderStatus(orderId, status);

            if (success) {
                System.out.println("✅ 订单状态更新成功: " + orderId + ", 新状态: " + status);
                resp.getWriter().write("{\"success\":true,\"message\":\"订单状态更新成功\"}");
            } else {
                System.out.println("❌ 订单状态更新失败: " + orderId);
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{\"success\":false,\"error\":\"订单状态更新失败\"}");
            }
        } catch (NumberFormatException e) {
            System.out.println("❌ 订单ID格式错误: " + e.getMessage());
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"success\":false,\"error\":\"订单ID格式错误\"}");
        }
    }


    /**
     * 验证订单状态是否有效
     */
    private boolean isValidOrderStatus(String status) {
        return "pending".equals(status) || "paid".equals(status) ||
                "shipped".equals(status) || "completed".equals(status) ||
                "cancelled".equals(status);
    }


    /**
     * 删除订单
     */
    private void deleteOrder(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        System.out.println("🗑️ 删除订单请求");

        String orderIdStr = req.getParameter("id");

        try {
            int orderId = Integer.parseInt(orderIdStr);
            boolean success = orderService.deleteOrder(orderId);

            if (success) {
                System.out.println("✅ 订单删除成功: " + orderId);
                resp.sendRedirect(req.getContextPath() + "/admin/orders");
            } else {
                System.out.println("❌ 订单删除失败: " + orderId);
                redirectWithError(req, resp, "/admin/orders", "订单删除失败");
            }
        } catch (NumberFormatException e) {
            System.out.println("❌ 订单ID格式错误: " + e.getMessage());
            redirectWithError(req, resp, "/admin/orders", "ID格式错误");
        }
    }


    /**
     * 检查用户是否为管理员
     */
    private boolean isAdminUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("❌ 未登录用户尝试访问管理员页面");
            String msg = java.net.URLEncoder.encode("请先登录", "UTF-8");  // 关键
            resp.sendRedirect(req.getContextPath() + "/Jsp/front/login.jsp?error="+ msg);
            return false;
        }

        User user = (User) session.getAttribute("user");
        if (!"admin".equals(user.getRole())) {
            System.out.println("❌ 非管理员用户尝试访问管理员页面: " + user.getUsername());
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "需要管理员权限");
            return false;
        }

        return true;
    }

    /**
     * 提取URL中的操作名称
     * 例如：/admin/books → books
     */
    private void redirectWithError(HttpServletRequest req, HttpServletResponse resp, String path, String message)
            throws IOException {
        redirectWithMessage(req, resp, path, "error", message);
    }

    private void redirectWithSuccess(HttpServletRequest req, HttpServletResponse resp, String path, String message)
            throws IOException {
        redirectWithMessage(req, resp, path, "success", message);
    }

    private void redirectWithMessage(HttpServletRequest req, HttpServletResponse resp, String path, String key, String message)
            throws IOException {
        String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8.toString());
        resp.sendRedirect(req.getContextPath() + path + "?" + key + "=" + encodedMessage);
    }

    private String getAction(HttpServletRequest req) {
        String path = req.getPathInfo();
        if (path != null && path.length() > 1) {
            return path.substring(1);
        }
        return "";
    }
}
