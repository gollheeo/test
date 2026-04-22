package com.bookshop.controller;

import com.bookshop.model.Book;
import com.bookshop.model.Category;
import com.bookshop.service.BookService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import com.bookshop.service.CategoryService;

@WebServlet("/Jsp/front/book/*")
public class BookController extends HttpServlet {
    private BookService bookService = new BookService();
    private CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        System.out.println("PathInfo: " + req.getPathInfo());

        String action = getAction(req);

        switch (action) {
            case "list":
                listBooks(req, resp);
                break;
            case "search":
                searchBooks(req, resp);
                break;
            case "category":
                booksByCategory(req, resp);
                break;
            case "detail":
                bookDetail(req, resp);
                break;
            case "hot":
                hotBooks(req, resp);
                break;
            case "new":  // 添加这一行
                newBooks(req, resp);  // 添加这一行
                break;  // 添加这一行
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * 列出所有图书
     */
    private void listBooks(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Book> books = bookService.getAllBooks();
        req.setAttribute("bookList", books);
        req.getRequestDispatcher("/Jsp/front/books/bookList.jsp").forward(req, resp);
    }

    /**
     * 搜索图书
     */
    private void searchBooks(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        List<Book> books = bookService.searchBooks(keyword);

        // 为每本书获取分类信息
        for (Book book : books) {
            Category category = categoryService.findById(book.getCategoryId());
            // 可以将分类名称直接设置到book对象的一个临时属性中
            // 或者创建一个新的数据传输对象来包装book和category信息
            req.setAttribute("category", category);
        }

        req.setAttribute("bookList", books);
        req.setAttribute("keyword", keyword);
        req.getRequestDispatcher("/Jsp/front/books/searchResult.jsp").forward(req, resp);
    }


    /**
     * 按分类浏览
     */
    private void booksByCategory(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. 读取分类 id 参数，注意参数名要与你的链接保持一致
        String categoryIdStr = req.getParameter("categoryId");

        if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
            // 参数缺失：可以回首页或者给出友好提示
            // 这里示例回到首页，并带上中文错误信息
            String msg = java.net.URLEncoder.encode("分类参数缺失", "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/index.jsp?error=" + msg);
            return;
        }

        int categoryId;
        try {
            categoryId = Integer.parseInt(categoryIdStr.trim());
        } catch (NumberFormatException e) {
            // 参数格式不对：例如传了 categoryId=abc
            String msg = java.net.URLEncoder.encode("分类参数格式错误", "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/index.jsp?error=" + msg);
            return;
        }

        // 2. 调用 Service 查询该分类下图书
        List<Book> books = bookService.getBooksByCategory(categoryId);

        // 3. 查询当前分类信息（如果你有 CategoryService）
         Category category = categoryService.findById(categoryId);
         req.setAttribute("currentCategory", category);

        req.setAttribute("categoryBookList", books);
        req.setAttribute("currentCategoryId", categoryId);

        // 4. 转发到 JSP 展示
        req.getRequestDispatcher("/Jsp/front/books/categoryBooks.jsp").forward(req, resp);
    }

    /**
     * 图书详情
     */
    private void bookDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String bookIdStr = req.getParameter("bookId");

        if (bookIdStr == null || bookIdStr.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing bookId parameter");
            return;
        }

        try {
            Integer bookId = Integer.parseInt(bookIdStr);
            Book book = bookService.getBookDetail(bookId);

            // 获取分类信息
            Category category = categoryService.findById(book.getCategoryId());

            req.setAttribute("book", book);
            req.setAttribute("category", category);

            req.getRequestDispatcher("/Jsp/front/books/bookDetail.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid bookId format");
        }
    }


    /**
     * 热卖图书
     */
    private void hotBooks(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Book> hotBookList = bookService.getHotBooks(-1);
        req.setAttribute("hotBookList", hotBookList);
        req.getRequestDispatcher("/Jsp/front/books/hotBooks.jsp").forward(req, resp);
    }

    private String getAction(HttpServletRequest req) {
        String path = req.getPathInfo();
        if (path != null && path.length() > 1) {
            return path.substring(1);
        }
        return "";
    }
    /**
     * 最新上架图书
     */
    private void newBooks(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Book> newBookList = bookService.getNewBooks(-1);
        req.setAttribute("newBookList", newBookList);
        req.getRequestDispatcher("/Jsp/front/books/newBook.jsp").forward(req, resp);
    }


}
