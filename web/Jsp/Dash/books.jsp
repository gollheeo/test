<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.bookshop.model.Book" %>
<%@ page import="com.bookshop.model.User" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        String msg = java.net.URLEncoder.encode("需要管理员权限", StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + "/Jsp/front/login.jsp?error=" + msg);
        return;
    }

    List<Book> books = (List<Book>) request.getAttribute("books");
    String searchParam = request.getParameter("search");
    if (searchParam == null) searchParam = "";
    String error = request.getParameter("error");
    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>图书管理 - BookShop</title>
    <jsp:include page="../front/common/style.jsp"/>
</head>
<body class="admin-page">
<div class="admin-shell">
    <aside class="admin-sidebar">
        <div class="admin-brand">
            <span class="brand-mark"><i class="fas fa-layer-group"></i></span>
            <span>
                <strong>BookShop Admin</strong>
                <small>图书管理后台</small>
            </span>
        </div>

        <nav class="admin-nav">
            <a class="admin-nav-link" href="<%= ctx %>/admin/dashboard"><i class="fas fa-chart-pie"></i>仪表盘</a>
            <a class="admin-nav-link active" href="<%= ctx %>/admin/books"><i class="fas fa-book"></i>图书管理</a>
            <a class="admin-nav-link" href="<%= ctx %>/admin/announcements"><i class="fas fa-bullhorn"></i>公告管理</a>
            <a class="admin-nav-link" href="<%= ctx %>/admin/orders"><i class="fas fa-shopping-bag"></i>订单管理</a>
            <a class="admin-nav-link" href="<%= ctx %>/admin/users"><i class="fas fa-users"></i>用户管理</a>
        </nav>

        <div class="admin-sidebar-footer">
            <a class="admin-nav-link" href="<%= ctx %>/Jsp/front/index.jsp"><i class="fas fa-arrow-left"></i>返回前台</a>
            <a class="admin-nav-link" href="<%= ctx %>/Jsp/front/user/logout"><i class="fas fa-sign-out-alt"></i>退出登录</a>
        </div>
    </aside>

    <main class="admin-main">
        <section class="admin-topbar">
            <div>
                <span class="eyebrow">Inventory</span>
                <h1>图书管理</h1>
                <p>统一处理图书录入、标签标记、库存状态与封面信息，整体结构更接近可持续维护的后台界面。</p>
            </div>
            <button class="btn btn-brand" data-toggle="modal" data-target="#addBookModal">
                <i class="fas fa-plus"></i> 添加图书
            </button>
        </section>

        <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-danger mb-4"><i class="fas fa-exclamation-circle mr-2"></i><%= error %></div>
        <% } %>

        <section class="admin-panel">
            <div class="admin-toolbar">
                <div>
                    <h3 class="mb-1">书库列表</h3>
                    <p class="admin-panel-subtitle mb-0">保留原有新增、编辑和删除逻辑，只重构外观与表格层级。</p>
                </div>
                <form method="get" action="<%= ctx %>/admin/books" class="admin-searchbar">
                    <input type="text" name="search" class="form-control" placeholder="搜索书名或作者" value="<%= searchParam %>">
                    <button type="submit" class="btn btn-soft">搜索</button>
                </form>
            </div>

            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>图书</th>
                        <th>作者</th>
                        <th>价格</th>
                        <th>库存</th>
                        <th>销量</th>
                        <th>标签</th>
                        <th>状态</th>
                        <th class="text-right">操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (books != null && !books.isEmpty()) {
                            for (Book book : books) {
                                boolean isHot = Boolean.TRUE.equals(book.getIsHot());
                                boolean isFeatured = Boolean.TRUE.equals(book.getIsFeatured());
                    %>
                    <tr>
                        <td class="font-weight-bold text-muted">#<%= book.getId() %></td>
                        <td>
                            <div class="font-weight-bold text-dark"><%= book.getTitle() %></div>
                            <div class="text-muted small">分类 ID：<%= book.getCategoryId() %></div>
                        </td>
                        <td><%= book.getAuthor() %></td>
                        <td class="font-weight-bold">&#165;<%= book.getPrice() %></td>
                        <td>
                            <% if (book.getStock() < 10) { %>
                            <span class="status-badge cancelled">库存紧张：<%= book.getStock() %></span>
                            <% } else { %>
                            <span class="status-badge completed">库存充足：<%= book.getStock() %></span>
                            <% } %>
                        </td>
                        <td><%= book.getSales() != null ? book.getSales() : 0 %></td>
                        <td>
                            <% if (isHot) { %><span class="badge-soft hot mr-1">热销</span><% } %>
                            <% if (isFeatured) { %><span class="badge-soft new">精选</span><% } %>
                            <% if (!isHot && !isFeatured) { %><span class="text-muted small">无标签</span><% } %>
                        </td>
                        <td>
                            <% if (book.getStatus() == 1) { %>
                            <span class="status-badge enabled">已上架</span>
                            <% } else { %>
                            <span class="status-badge disabled">已下架</span>
                            <% } %>
                        </td>
                        <td class="text-right">
                            <button class="icon-btn" type="button" title="编辑"
                                    onclick="editBook(<%= book.getId() %>, '<%= book.getTitle().replace("'", "\\'") %>', '<%= book.getAuthor().replace("'", "\\'") %>', '<%= book.getPrice() %>', '<%= book.getOldPrice() != null ? book.getOldPrice() : "" %>', '<%= book.getStock() %>', '<%= book.getSales() != null ? book.getSales() : 0 %>', '<%= book.getCategoryId() %>', '<%= book.getPublisher() != null ? book.getPublisher().replace("'", "\\'") : "" %>', '<%= isHot %>', '<%= isFeatured %>', '<%= book.getPublishDate() != null ? book.getPublishDate() : "" %>', '<%= book.getStatus() %>', '<%= book.getCoverImage() != null ? book.getCoverImage().replace("'", "\\'") : "" %>', '<%= (book.getDescription() != null ? book.getDescription().replace("'", "\\'") : "").replace("\n", "\\n") %>')">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="icon-btn ml-2" type="button" title="删除" onclick="deleteBook(<%= book.getId() %>)">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="9" class="data-empty">
                            <i class="fas fa-box-open fa-3x"></i>
                            当前没有符合条件的图书数据。
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>

<div class="modal fade" id="addBookModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <div>
                    <h5 class="mb-1">新增图书</h5>
                    <small class="text-muted">补充图书基础信息、标签与封面路径。</small>
                </div>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <form method="post" action="<%= ctx %>/admin/book/add">
                <div class="modal-body">
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>书名</label>
                            <input type="text" name="title" class="form-control" required>
                        </div>
                        <div class="form-group col-md-6">
                            <label>作者</label>
                            <input type="text" name="author" class="form-control" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label>现价</label>
                            <input type="number" name="price" class="form-control" step="0.01" min="0" required>
                        </div>
                        <div class="form-group col-md-4">
                            <label>原价</label>
                            <input type="number" name="oldPrice" class="form-control" step="0.01" min="0">
                        </div>
                        <div class="form-group col-md-4">
                            <label>库存</label>
                            <input type="number" name="stock" class="form-control" min="0" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>分类</label>
                            <select name="categoryId" class="custom-select">
                                <option value="1">计算机基础</option>
                                <option value="2">网络工程</option>
                                <option value="3">编程开发</option>
                                <option value="4">数据库技术</option>
                                <option value="5">人工智能</option>
                            </select>
                        </div>
                        <div class="form-group col-md-6">
                            <label>出版社</label>
                            <input type="text" name="publisher" class="form-control">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-3">
                            <label>热销推荐</label>
                            <select name="isHot" class="custom-select">
                                <option value="false">否</option>
                                <option value="true">是</option>
                            </select>
                        </div>
                        <div class="form-group col-md-3">
                            <label>精选推荐</label>
                            <select name="isFeatured" class="custom-select">
                                <option value="false">否</option>
                                <option value="true">是</option>
                            </select>
                        </div>
                        <div class="form-group col-md-3">
                            <label>状态</label>
                            <select name="status" class="custom-select">
                                <option value="1">上架</option>
                                <option value="0">下架</option>
                            </select>
                        </div>
                        <div class="form-group col-md-3">
                            <label>出版日期</label>
                            <input type="date" name="publishDate" class="form-control">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>封面图片文件名或 URL</label>
                        <input type="text" name="coverImage" class="form-control" placeholder="例如：java_core.jpg">
                    </div>
                    <div class="form-group">
                        <label>图书描述</label>
                        <textarea name="description" class="form-control" rows="4"></textarea>
                    </div>
                    <input type="hidden" name="sales" value="0">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-soft" data-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-brand">保存图书</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="editBookModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <div>
                    <h5 class="mb-1">编辑图书</h5>
                    <small class="text-muted">修改图书信息时，业务提交路径保持不变。</small>
                </div>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <form method="post" action="<%= ctx %>/admin/book/update">
                <input type="hidden" name="id" id="editBookId">
                <div class="modal-body">
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>书名</label>
                            <input type="text" name="title" id="editTitle" class="form-control" required>
                        </div>
                        <div class="form-group col-md-6">
                            <label>作者</label>
                            <input type="text" name="author" id="editAuthor" class="form-control" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label>现价</label>
                            <input type="number" name="price" id="editPrice" class="form-control" step="0.01" required>
                        </div>
                        <div class="form-group col-md-4">
                            <label>原价</label>
                            <input type="number" name="oldPrice" id="editOldPrice" class="form-control" step="0.01">
                        </div>
                        <div class="form-group col-md-4">
                            <label>库存</label>
                            <input type="number" name="stock" id="editStock" class="form-control" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>分类</label>
                            <select name="categoryId" id="editCategoryId" class="custom-select">
                                <option value="1">计算机基础</option>
                                <option value="2">网络工程</option>
                                <option value="3">编程开发</option>
                                <option value="4">数据库技术</option>
                                <option value="5">人工智能</option>
                            </select>
                        </div>
                        <div class="form-group col-md-6">
                            <label>出版社</label>
                            <input type="text" name="publisher" id="editPublisher" class="form-control">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-3">
                            <label>热销推荐</label>
                            <select name="isHot" id="editIsHot" class="custom-select">
                                <option value="false">否</option>
                                <option value="true">是</option>
                            </select>
                        </div>
                        <div class="form-group col-md-3">
                            <label>精选推荐</label>
                            <select name="isFeatured" id="editIsFeatured" class="custom-select">
                                <option value="false">否</option>
                                <option value="true">是</option>
                            </select>
                        </div>
                        <div class="form-group col-md-3">
                            <label>状态</label>
                            <select name="status" id="editStatus" class="custom-select">
                                <option value="1">上架</option>
                                <option value="0">下架</option>
                            </select>
                        </div>
                        <div class="form-group col-md-3">
                            <label>出版日期</label>
                            <input type="date" name="publishDate" id="editPublishDate" class="form-control">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>封面图片文件名或 URL</label>
                        <input type="text" name="coverImage" id="editCoverImage" class="form-control">
                    </div>
                    <div class="form-group">
                        <label>图书描述</label>
                        <textarea name="description" id="editDescription" class="form-control" rows="4"></textarea>
                    </div>
                    <input type="hidden" name="sales" id="editSales">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-soft" data-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-brand">更新图书</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editBook(id, title, author, price, oldPrice, stock, sales, categoryId, publisher, isHot, isFeatured, publishDate, status, coverImage, description) {
        document.getElementById('editBookId').value = id;
        document.getElementById('editTitle').value = title;
        document.getElementById('editAuthor').value = author;
        document.getElementById('editPrice').value = price ? parseFloat(price) : '';
        document.getElementById('editOldPrice').value = oldPrice ? parseFloat(oldPrice) : '';
        document.getElementById('editStock').value = stock;
        document.getElementById('editSales').value = sales;
        document.getElementById('editCategoryId').value = categoryId;
        document.getElementById('editPublisher').value = publisher;
        document.getElementById('editIsHot').value = isHot;
        document.getElementById('editIsFeatured').value = isFeatured;
        document.getElementById('editPublishDate').value = publishDate ? publishDate.split('T')[0] : '';
        document.getElementById('editStatus').value = status;
        document.getElementById('editCoverImage').value = coverImage;
        document.getElementById('editDescription').value = description;
        $('#editBookModal').modal('show');
    }

    function deleteBook(bookId) {
        if (!confirm('确定要删除这本图书吗？该操作不可恢复。')) {
            return;
        }

        var form = document.createElement('form');
        form.method = 'post';
        form.action = '<%= ctx %>/admin/book/delete';

        var input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'bookId';
        input.value = bookId;

        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    }
</script>
</body>
</html>
