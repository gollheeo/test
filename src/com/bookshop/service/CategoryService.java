package com.bookshop.service;

import com.bookshop.dao.CategoryDAO;
import com.bookshop.model.Category;

import java.util.List;

public class CategoryService {

    private CategoryDAO categoryDAO = new CategoryDAO();

    public List<Category> findAll() {
        return categoryDAO.findAll();
    }

    public Category findById(int id) {
        return categoryDAO.findById(id);
    }
}
