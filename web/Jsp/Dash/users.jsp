<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bookshop.model.User" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"admin".equals(currentUser.getRole())) {
        String msg = java.net.URLEncoder.encode("需要管理员权限", StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + "/Jsp/front/login.jsp?error=" + msg);
        return;
    }

    List<User> users = (List<User>) request.getAttribute("users");
    String searchParam = request.getParameter("search");
    if (searchParam == null) searchParam = "";
    String error = request.getParameter("error");
    String success = request.getParameter("success");
    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户管理 - BookShop</title>
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
            <a class="admin-nav-link" href="<%= ctx %>/admin/books"><i class="fas fa-book"></i>图书管理</a>
            <a class="admin-nav-link" href="<%= ctx %>/admin/announcements"><i class="fas fa-bullhorn"></i>公告管理</a>
            <a class="admin-nav-link" href="<%= ctx %>/admin/orders"><i class="fas fa-shopping-bag"></i>订单管理</a>
            <a class="admin-nav-link active" href="<%= ctx %>/admin/users"><i class="fas fa-users"></i>用户管理</a>
        </nav>

        <div class="admin-sidebar-footer">
            <a class="admin-nav-link" href="<%= ctx %>/Jsp/front/index.jsp"><i class="fas fa-arrow-left"></i>返回前台</a>
            <a class="admin-nav-link" href="<%= ctx %>/Jsp/front/user/logout"><i class="fas fa-sign-out-alt"></i>退出登录</a>
        </div>
    </aside>

    <main class="admin-main">
        <section class="admin-topbar">
            <div>
                <span class="eyebrow">Users</span>
                <h1>用户管理</h1>
                <p>用户页改成更明确的信息卡与操作区，角色、状态和删除动作被放在更清晰的位置。</p>
            </div>
            <span class="admin-chip"><i class="fas fa-shield-alt"></i> 支持角色与状态管理</span>
        </section>

        <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-danger mb-4"><i class="fas fa-exclamation-circle mr-2"></i><%= error %></div>
        <% } %>
        <% if (success != null && !success.isEmpty()) { %>
        <div class="alert alert-success mb-4"><i class="fas fa-check-circle mr-2"></i><%= success %></div>
        <% } %>

        <section class="admin-panel">
            <div class="admin-toolbar">
                <div>
                    <h3 class="mb-1">用户列表</h3>
                    <p class="admin-panel-subtitle mb-0">你可以直接调整用户角色、启用状态，或删除无效账号。</p>
                </div>
                <form method="get" action="<%= ctx %>/admin/users" class="admin-searchbar">
                    <input type="text" name="search" class="form-control" placeholder="搜索用户名或邮箱" value="<%= searchParam %>">
                    <button type="submit" class="btn btn-soft">搜索</button>
                </form>
            </div>

            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>用户</th>
                        <th>邮箱</th>
                        <th>注册时间</th>
                        <th>管理设置</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (users != null && !users.isEmpty()) {
                            for (User u : users) {
                    %>
                    <tr>
                        <td>
                            <div class="d-flex align-items-center">
                                <span class="avatar-chip mr-3"><%= u.getUsername().substring(0, 1).toUpperCase() %></span>
                                <div>
                                    <div class="font-weight-bold text-dark"><%= u.getUsername() %></div>
                                    <div class="text-muted small">ID：<%= u.getId() %></div>
                                </div>
                            </div>
                        </td>
                        <td><%= u.getEmail() != null ? u.getEmail() : "未填写" %></td>
                        <td class="text-muted"><%= u.getCreatedAt() != null ? u.getCreatedAt() : "-" %></td>
                        <td>
                            <div class="d-flex flex-column flex-md-row">
                                <select id="role-<%= u.getId() %>" class="custom-select custom-select-sm mr-md-2 mb-2 mb-md-0" style="width: 140px;">
                                    <option value="user" <%= "user".equals(u.getRole()) ? "selected" : "" %>>普通用户</option>
                                    <option value="admin" <%= "admin".equals(u.getRole()) ? "selected" : "" %>>管理员</option>
                                </select>
                                <select id="status-<%= u.getId() %>" class="custom-select custom-select-sm mr-md-2 mb-2 mb-md-0" style="width: 120px;">
                                    <option value="1" <%= u.getStatus() != null && u.getStatus() == 1 ? "selected" : "" %>>启用</option>
                                    <option value="0" <%= u.getStatus() == null || u.getStatus() == 0 ? "selected" : "" %>>禁用</option>
                                </select>
                                <button class="btn btn-soft btn-sm" type="button" onclick="saveUser(<%= u.getId() %>)">保存</button>
                            </div>
                        </td>
                        <td>
                            <button class="icon-btn" type="button" onclick="viewUser(<%= u.getId() %>, '<%= u.getUsername().replace("'", "\\'") %>')">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button class="icon-btn ml-2" type="button" onclick="deleteUser(<%= u.getId() %>, '<%= u.getUsername().replace("'", "\\'") %>')">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="5" class="data-empty">
                            <i class="fas fa-user-slash fa-3x"></i>
                            当前没有可展示的用户数据。
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function viewUser(userId, username) {
        alert('用户 ' + username + '（ID: ' + userId + '）的详情页尚未单独实现。');
    }

    function saveUser(userId) {
        var role = document.getElementById('role-' + userId).value;
        var status = document.getElementById('status-' + userId).value;

        var form = document.createElement('form');
        form.method = 'post';
        form.action = '<%= ctx %>/admin/user/update';

        [
            { name: 'id', value: userId },
            { name: 'role', value: role },
            { name: 'status', value: status }
        ].forEach(function (item) {
            var input = document.createElement('input');
            input.type = 'hidden';
            input.name = item.name;
            input.value = item.value;
            form.appendChild(input);
        });

        document.body.appendChild(form);
        form.submit();
    }

    function deleteUser(userId, username) {
        if (!confirm('确定删除用户“' + username + '”吗？')) {
            return;
        }

        var form = document.createElement('form');
        form.method = 'post';
        form.action = '<%= ctx %>/admin/user/delete';

        var input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'id';
        input.value = userId;
        form.appendChild(input);

        document.body.appendChild(form);
        form.submit();
    }
</script>
</body>
</html>
