<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bookshop.model.User, com.bookshop.model.Order, java.util.List" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        String msg = java.net.URLEncoder.encode("需要管理员权限", StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + "/Jsp/front/login.jsp?error=" + msg);
        return;
    }

    List<Order> orders = (List<Order>) request.getAttribute("orders");
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
    <title>订单管理 - BookShop</title>
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
            <a class="admin-nav-link active" href="<%= ctx %>/admin/orders"><i class="fas fa-shopping-bag"></i>订单管理</a>
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
                <span class="eyebrow">Orders</span>
                <h1>订单管理</h1>
                <p>重新整理订单页的搜索、状态控制和操作按钮，让处理流程更像一个真正可用的后台工作台。</p>
            </div>
            <span class="admin-chip"><i class="fas fa-shipping-fast"></i> 支持快速更新状态</span>
        </section>

        <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-danger mb-4"><i class="fas fa-exclamation-circle mr-2"></i><%= error %></div>
        <% } %>

        <section class="admin-panel">
            <div class="admin-toolbar">
                <div>
                    <h3 class="mb-1">订单列表</h3>
                    <p class="admin-panel-subtitle mb-0">支持关键字搜索、状态调整和删除处理。</p>
                </div>
                <form method="get" action="<%= ctx %>/admin/orders" class="admin-searchbar">
                    <input type="text" name="search" class="form-control" placeholder="搜索订单号或用户 ID" value="<%= searchParam %>">
                    <button type="submit" class="btn btn-soft">搜索</button>
                    <% if (!searchParam.isEmpty()) { %>
                    <a class="btn btn-soft" href="<%= ctx %>/admin/orders">重置</a>
                    <% } %>
                </form>
            </div>

            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>订单号</th>
                        <th>用户 ID</th>
                        <th>订单金额</th>
                        <th>订单状态</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (orders != null && !orders.isEmpty()) {
                            for (Order order : orders) {
                    %>
                    <tr>
                        <td class="font-weight-bold"><%= order.getOrderNo() %></td>
                        <td><%= order.getUserId() %></td>
                        <td class="font-weight-bold">&#165;<%= order.getTotalPrice() != null ? order.getTotalPrice() : "0.00" %></td>
                        <td>
                            <select class="status-select" onchange="updateOrderStatus(<%= order.getId() %>, this.value)">
                                <option value="pending" <%= "pending".equals(order.getStatus()) ? "selected" : "" %>>待支付</option>
                                <option value="paid" <%= "paid".equals(order.getStatus()) ? "selected" : "" %>>已支付</option>
                                <option value="shipped" <%= "shipped".equals(order.getStatus()) ? "selected" : "" %>>已发货</option>
                                <option value="completed" <%= "completed".equals(order.getStatus()) ? "selected" : "" %>>已完成</option>
                                <option value="cancelled" <%= "cancelled".equals(order.getStatus()) ? "selected" : "" %>>已取消</option>
                            </select>
                        </td>
                        <td class="text-muted"><%= order.getCreatedAt() != null ? order.getCreatedAt() : "-" %></td>
                        <td>
                            <button class="icon-btn" type="button" onclick="viewOrder(<%= order.getId() %>)">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button class="icon-btn ml-2" type="button" onclick="deleteOrder(<%= order.getId() %>)">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="6" class="data-empty">
                            <i class="fas fa-inbox fa-3x"></i>
                            当前没有可显示的订单数据。
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
    function viewOrder(id) {
        window.location.href = '<%= ctx %>/Jsp/front/order/detail?id=' + id;
    }

    function updateOrderStatus(id, status) {
        if (!confirm('确定更新该订单状态吗？')) {
            return;
        }

        $.ajax({
            url: '<%= ctx %>/admin/order/updateStatus',
            type: 'post',
            data: { id: id, status: status },
            dataType: 'text'
        }).done(function (response) {
            if (response && response.indexOf('"success":true') !== -1) {
                location.reload();
            } else {
                alert('订单状态更新失败，请稍后重试。');
            }
        }).fail(function () {
            alert('订单状态更新失败，请检查网络或后端接口。');
        });
    }

    function deleteOrder(id) {
        if (!confirm('确定删除这个订单吗？')) {
            return;
        }

        var form = document.createElement('form');
        form.method = 'post';
        form.action = '<%= ctx %>/admin/order/delete';

        var input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'id';
        input.value = id;
        form.appendChild(input);

        document.body.appendChild(form);
        form.submit();
    }
</script>
</body>
</html>
