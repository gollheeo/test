<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bookshop.model.User" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        String msg = java.net.URLEncoder.encode("需要管理员权限", StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + "/Jsp/front/login.jsp?error=" + msg);
        return;
    }

    Integer totalUsers = (Integer) request.getAttribute("totalUsers");
    Integer totalBooks = (Integer) request.getAttribute("totalBooks");
    Integer pendingOrders = (Integer) request.getAttribute("pendingOrders");
    String monthlyRevenue = (String) request.getAttribute("monthlyRevenue");
    if (totalUsers == null) totalUsers = 0;
    if (totalBooks == null) totalBooks = 0;
    if (pendingOrders == null) pendingOrders = 0;
    if (monthlyRevenue == null) monthlyRevenue = "0.00";
    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>后台仪表盘 - BookShop</title>
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
            <a class="admin-nav-link active" href="<%= ctx %>/admin/dashboard"><i class="fas fa-chart-pie"></i>仪表盘</a>
            <a class="admin-nav-link" href="<%= ctx %>/admin/books"><i class="fas fa-book"></i>图书管理</a>
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
                <span class="eyebrow">Dashboard</span>
                <h1>后台仪表盘</h1>
                <p>统一数据总览、快捷入口和近期业务提醒，方便你从一个页面把握系统运行状态。</p>
            </div>
            <div class="admin-topbar-meta">
                <div class="text-right">
                    <div class="font-weight-bold text-dark"><%= user.getUsername() %></div>
                    <div class="text-muted small">管理员账号</div>
                </div>
                <span class="admin-user-badge"><%= user.getUsername().substring(0, 1).toUpperCase() %></span>
            </div>
        </section>

        <section class="admin-stat-grid">
            <div class="admin-stat-card">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <span class="label">总用户数</span>
                        <span class="value"><%= totalUsers %></span>
                        <span class="trend"><i class="fas fa-user-friends"></i> 账户总量与活跃运营基础</span>
                    </div>
                    <span class="admin-stat-icon"><i class="fas fa-users"></i></span>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <span class="label">图书总量</span>
                        <span class="value"><%= totalBooks %></span>
                        <span class="trend"><i class="fas fa-book-open"></i> 已上架与已录入的书库体量</span>
                    </div>
                    <span class="admin-stat-icon"><i class="fas fa-book"></i></span>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <span class="label">待处理订单</span>
                        <span class="value"><%= pendingOrders %></span>
                        <span class="trend"><i class="fas fa-receipt"></i> 建议优先关注发货与状态更新</span>
                    </div>
                    <span class="admin-stat-icon"><i class="fas fa-shopping-cart"></i></span>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <span class="label">本月收入</span>
                        <span class="value">&#165;<%= monthlyRevenue %></span>
                        <span class="trend"><i class="fas fa-wallet"></i> 收入概览与经营节奏参考</span>
                    </div>
                    <span class="admin-stat-icon"><i class="fas fa-coins"></i></span>
                </div>
            </div>
        </section>

        <section class="admin-content-grid">
            <div class="admin-panel">
                <div class="card-header-row mb-4">
                    <div>
                        <h3>近期业务概览</h3>
                        <p class="admin-panel-subtitle">当前控制器还没有传入最近订单列表，这里先保留了示例结构，后续可以直接接真数据。</p>
                    </div>
                    <span class="admin-chip"><i class="fas fa-bolt"></i> 本页已统一视觉</span>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>订单号</th>
                            <th>用户</th>
                            <th>金额</th>
                            <th>状态</th>
                            <th>日期</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td class="font-weight-bold">ORDER_EXAMPLE_01</td>
                            <td>演示用户</td>
                            <td>&#165;299.99</td>
                            <td><span class="status-badge pending">待处理</span></td>
                            <td>2026-04-21</td>
                            <td><a class="btn btn-soft btn-sm" href="<%= ctx %>/admin/orders">查看订单</a></td>
                        </tr>
                        <tr>
                            <td class="font-weight-bold">ORDER_EXAMPLE_02</td>
                            <td>测试账号</td>
                            <td>&#165;168.00</td>
                            <td><span class="status-badge completed">已完成</span></td>
                            <td>2026-04-20</td>
                            <td><a class="btn btn-soft btn-sm" href="<%= ctx %>/admin/orders">查看订单</a></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="admin-panel">
                <div class="card-header-row mb-4">
                    <div>
                        <h3>快捷操作</h3>
                        <p class="admin-panel-subtitle">把后台高频动作整合成一个更直观的侧栏面板。</p>
                    </div>
                </div>

                <div class="admin-quick-list">
                    <div class="admin-quick-item">
                        <strong>管理图书库</strong>
                        <div class="mb-3">快速新增图书、修改价格、更新库存与标签信息。</div>
                        <a class="btn btn-brand btn-block" href="<%= ctx %>/admin/books">进入图书管理</a>
                    </div>
                    <div class="admin-quick-item">
                        <strong>发布系统公告</strong>
                        <div class="mb-3">适合用于活动通知、库存调整说明或维护提醒。</div>
                        <a class="btn btn-soft btn-block" href="<%= ctx %>/admin/announcements">进入公告管理</a>
                    </div>
                    <div class="admin-quick-item">
                        <strong>订单处理建议</strong>
                        <div>如果待处理订单持续增长，优先前往订单页统一更新状态，避免前台反馈滞后。</div>
                    </div>
                </div>
            </div>
        </section>
    </main>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
