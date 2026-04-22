package com.bookshop.dao;

import com.bookshop.model.Book;
import com.bookshop.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {

    /**
     * 查询所有图书
     */
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE status = 1";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Book book = mapResultSetToBook(rs);
                books.add(book);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    /**
     * 获取所有图书（包括已删除的）
     */
    public List<Book> getAllBooksIncludingDeleted() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books";  // 不限制status

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Book book = mapResultSetToBook(rs);
                books.add(book);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }


    /**
     * 按分类查询图书
     */
    public List<Book> getBooksByCategory(Integer categoryId) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE category_id = ? AND status = 1";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, categoryId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Book book = mapResultSetToBook(rs);
                books.add(book);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    /**
     * 按书名搜索
     */
    public List<Book> searchBooks(String keyword) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE (title LIKE ? OR author LIKE ?) AND status = 1";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String searchTerm = "%" + keyword + "%";
            pstmt.setString(1, searchTerm);
            pstmt.setString(2, searchTerm);

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Book book = mapResultSetToBook(rs);
                books.add(book);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    /**
     * 获取热卖图书
     */
    public List<Book> getHotBooks(int limit) {
        List<Book> books = new ArrayList<>();
        String sql;

        if (limit <= 0) {
            // 获取全部图书
            sql = "SELECT * FROM books WHERE status = 1 ORDER BY sales DESC";
        } else {
            sql = "SELECT * FROM books WHERE is_hot = 1 AND status = 1 LIMIT ?";
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (limit > 0) {
                pstmt.setInt(1, limit);
            }
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Book book = mapResultSetToBook(rs);
                books.add(book);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }
    /**
     * 获取推荐图书
     */
    public List<Book> getFeaturedBooks(int limit) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE is_featured = 1 AND status = 1 LIMIT ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Book book = mapResultSetToBook(rs);
                books.add(book);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    /**
     * 根据ID获取图书
     */
    public Book getBookById(Integer bookId) {
        String sql = "SELECT * FROM books WHERE id = ? AND status = 1";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, bookId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToBook(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    /**
     * 获取最新上架的图书
     */
    public List<Book> getNewBooks(int limit) {
        List<Book> books = new ArrayList<>();
        String sql;

        if (limit <= 0) {
            // 获取全部图书
            sql = "SELECT * FROM books WHERE status = 1 ORDER BY publishDate DESC";
        } else {
            sql = "SELECT * FROM books WHERE status = 1 ORDER BY publishDate DESC LIMIT ?";
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (limit > 0) {
                pstmt.setInt(1, limit);
            }
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Book book = mapResultSetToBook(rs);
                books.add(book);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }



    /**
     * 添加图书（管理员）
     */
    public int addBook(Book book) {
        String sql = "INSERT INTO books (title, author, category_id, price, stock, " +
                "description, cover_image, is_hot, is_featured, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, book.getTitle());
            pstmt.setString(2, book.getAuthor());
            pstmt.setInt(3, book.getCategoryId());
            pstmt.setBigDecimal(4, book.getPrice());
            pstmt.setInt(5, book.getStock());
            pstmt.setString(6, book.getDescription());
            pstmt.setString(7, book.getCoverImage());
            pstmt.setBoolean(8, book.getIsHot() != null && book.getIsHot());
            pstmt.setBoolean(9, book.getIsFeatured() != null && book.getIsFeatured());
            pstmt.setInt(10, 1);

            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     * 更新图书信息
     */
    public int updateBook(Book book) {
        String sql = "UPDATE books SET title = ?, author = ?, category_id = ?, " +
                "price = ?, stock = ?, description = ?, cover_image = ?, " +
                "is_hot = ?, is_featured = ?, status = ? WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, book.getTitle());
            pstmt.setString(2, book.getAuthor());
            pstmt.setInt(3, book.getCategoryId());
            pstmt.setBigDecimal(4, book.getPrice());
            pstmt.setInt(5, book.getStock());
            pstmt.setString(6, book.getDescription());
            pstmt.setString(7, book.getCoverImage());
            pstmt.setBoolean(8, book.getIsHot() != null && book.getIsHot());
            pstmt.setBoolean(9, book.getIsFeatured() != null && book.getIsFeatured());
            pstmt.setInt(10, book.getStatus());  // 添加状态字段
            pstmt.setInt(11, book.getId());      // ID 作为 WHERE 条件

            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }


    /**
     * 删除图书（逻辑删除）
     */
    public int deleteBook(Integer bookId) {
        String sql = "UPDATE books SET status = 0 WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, bookId);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     * 将ResultSet映射到Book对象
     */
    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setId(rs.getInt("id"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setCategoryId(rs.getInt("category_id"));
        book.setPrice(rs.getBigDecimal("price"));
        book.setStock(rs.getInt("stock"));
        book.setDescription(rs.getString("description"));
        book.setCoverImage(rs.getString("cover_image"));
        book.setIsHot(rs.getBoolean("is_hot"));
        book.setIsFeatured(rs.getBoolean("is_featured"));
        book.setStatus(rs.getInt("status"));
        book.setPublishDate(rs.getTimestamp("publishDate"));
        book.setSales(rs.getInt("sales"));
        book.setPublisher(rs.getString("publisher"));
        book.setOldPrice(rs.getBigDecimal("oldPrice"));
        return book;
    }


//    private Book buildCategory(ResultSet rs) throws SQLException {
//        Book c = new Book();
//        c.setId(rs.getInt("id"));
//        c.setTitle(rs.getString("name"));
//        c.setDescription(rs.getString("description"));
//        return c;
//    }
//    public List<Book> findAllCategories() {
//        String sql = "SELECT * FROM categories ORDER BY status ASC, id ASC";
//        List<Book> list = new ArrayList<>();
//        try (Connection conn = DBUtil.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//            while (rs.next()) {
//                list.add(buildCategory(rs));
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
}
