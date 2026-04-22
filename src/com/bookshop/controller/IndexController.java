package com.bookshop.controller;

import com.bookshop.model.Book;
import com.bookshop.model.Category;
import com.bookshop.model.Announcement;
import com.bookshop.service.BookService;
import com.bookshop.service.CategoryService;
import com.bookshop.service.AnnouncementService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet({"/Jsp/front/index.jsp", "/index", "/Jsp/front/announcementslist"})
public class IndexController extends HttpServlet {

    private BookService bookService = new BookService();
    private CategoryService categoryService = new CategoryService();
    private AnnouncementService announcementService = new AnnouncementService(); // 添加公告服务

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String requestURI = req.getRequestURI();
        String contextPath = req.getContextPath();

        // 根据请求URI决定处理逻辑
        if (requestURI.contains("/announcementslist")) {
            // 处理公告列表请求
            handleAnnouncementList(req, resp);
        } else {
            // 处理首页请求
            handleIndexPage(req, resp);
        }
    }

    private void handleIndexPage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 分类列表
        List<Category> categories = categoryService.findAll();
        req.setAttribute("categoryList", categories);

        // 推荐 / 热卖 / 最新图书
        List<Book> recommendList = bookService.getFeaturedBooks();
        List<Book> hotList = bookService.getHotBooks(5);
        List<Book> newList = bookService.getNewBooks(5);

        req.setAttribute("recommendBookList", recommendList);
        req.setAttribute("hotBookList", hotList);
        req.setAttribute("newBookList", newList);

        // 获取公告列表（获取最近的5条公告）
        List<Announcement> announcements = announcementService.getAllAnnouncements();
        if (announcements != null && announcements.size() > 5) {
            announcements = announcements.subList(0, 5); // 只取前5条
        }
        req.setAttribute("announcements", announcements);

        // 转发到RE首页 JSP
        req.getRequestDispatcher("REindex.jsp").forward(req, resp);
    }

    private void handleAnnouncementList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 获取所有公告
        List<Announcement> announcements = announcementService.getAllAnnouncements();
        req.setAttribute("announcements", announcements);

        // 转发到公告列表页面
        req.getRequestDispatcher("announcementlist.jsp").forward(req, resp);
    }
}
