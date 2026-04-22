package com.bookshop.service;

import com.bookshop.dao.BookDAO;
import com.bookshop.model.Book;

import java.math.BigDecimal;
import java.util.List;

public class BookService {
    private BookDAO bookDAO = new BookDAO();

    /**
     * 获取所有图书
     */
    public List<Book> getAllBooks() {
        return bookDAO.getAllBooks();
    }

    /**
     * 按分类查询
     */
    public List<Book> getBooksByCategory(Integer categoryId) {
        return bookDAO.getBooksByCategory(categoryId);
    }

    /**
     * 搜索图书
     */
    public List<Book> searchBooks(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllBooks();
        }
        return bookDAO.searchBooks(keyword.trim());
    }

    /**
     * 获取热卖图书
     */
    public List<Book> getHotBooks(int limit) {
        return bookDAO.getHotBooks(limit);
    }

    /**
     * 获取推荐图书
     */
    public List<Book> getFeaturedBooks() {
        return bookDAO.getFeaturedBooks(4);
    }

    /**
     * 获取图书详情
     */
    public Book getBookDetail(Integer bookId) {
        return bookDAO.getBookById(bookId);
    }

    /**
     * 添加图书（管理员）- 重载方法，接受各个参数
     */
    public boolean addBook(String title, String author, BigDecimal price, int stock, int categoryId, String description) {
        Book book = new Book();
        book.setTitle(title);
        book.setAuthor(author);
        book.setPrice(price);
        book.setStock(stock);
        book.setCategoryId(categoryId);
        book.setDescription(description);

        return addBook(book);
    }

    /**
     * 添加图书（管理员）- 原方法
     */
    public boolean addBook(Book book) {
        int result = bookDAO.addBook(book);
        return result > 0;
    }

    /**
     * 更新图书 - 重载方法，接受各个参数
     */
    public boolean updateBook(int id, String title, String author, BigDecimal price, int stock, int categoryId, String description) {
        Book book = new Book();
        book.setId(id);
        book.setTitle(title);
        book.setAuthor(author);
        book.setPrice(price);
        book.setStock(stock);
        book.setCategoryId(categoryId);
        book.setDescription(description);

        return updateBook(book);
    }

    /**
     * 更新图书 - 原方法
     */
    public boolean updateBook(Book book) {
        int result = bookDAO.updateBook(book);
        return result > 0;
    }

    /**
     * 删除图书
     */
    public boolean deleteBook(Integer bookId) {
        int result = bookDAO.deleteBook(bookId);
        return result > 0;
    }

    /**
     * 获取最新图书
     */
    public List<Book> getNewBooks(int limit) {
        return bookDAO.getNewBooks(limit);
    }

    public List<Book> getAllBooksIncludingDeleted() {
        return bookDAO.getAllBooksIncludingDeleted();
    }
}
