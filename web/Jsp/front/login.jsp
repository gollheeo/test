<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 - BookShop</title>
    <jsp:include page="common/style.jsp"/>
</head>
<body class="auth-page">
<%
    String ctx = request.getContextPath();
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>

<main class="container front-container auth-shell">
    <section class="auth-showcase">
        <span class="eyebrow text-white">Member Access</span>
        <h1 class="serif-title">欢迎回来，继续管理你的图书与订单</h1>
        <p>
            登录页改成了“品牌说明 + 表单卡片”的组合结构，视觉更稳，信息更聚焦，
            同时保留原有登录流程与接口，不影响你现在的业务逻辑。
        </p>

        <div class="auth-points">
            <div class="auth-point">
                <strong>更清晰的输入焦点</strong>
                <div>表单交互改为更明显的高亮与圆角层次，降低输入时的视觉疲劳。</div>
            </div>
            <div class="auth-point">
                <strong>更强的品牌一致性</strong>
                <div>与首页、列表页共用同一套暖色书店风格，不再像是单独拼出来的页面。</div>
            </div>
            <div class="auth-point">
                <strong>更适合桌面与移动端</strong>
                <div>大屏双栏、小屏单栏，兼顾展示感与表单可操作性。</div>
            </div>
        </div>

        <div class="auth-stats">
            <div class="auth-stat">
                <strong>测试账号</strong>
                <div>管理员：`admin / admin123`</div>
            </div>
            <div class="auth-stat">
                <strong>普通用户</strong>
                <div>`user1 / password123`</div>
            </div>
        </div>
    </section>

    <section class="auth-card">
        <span class="eyebrow">Sign In</span>
        <h2>登录系统</h2>
        <p class="mb-4">输入你的账号信息后即可继续浏览图书、管理购物车和查看订单。</p>

        <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle mr-2"></i><%= error %></div>
        <% } %>
        <% if (success != null && !success.isEmpty()) { %>
        <div class="alert alert-success"><i class="fas fa-check-circle mr-2"></i><%= success %></div>
        <% } %>

        <form class="auth-form" method="post" action="<%= ctx %>/Jsp/front/user/login">
            <div class="form-group">
                <label for="username">用户名</label>
                <div class="input-group">
                    <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                    </div>
                    <input type="text" class="form-control" id="username" name="username" required placeholder="请输入用户名" autocomplete="username" autofocus>
                </div>
            </div>

            <div class="form-group">
                <label for="password">密码</label>
                <div class="input-group">
                    <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                    </div>
                    <input type="password" class="form-control" id="password" name="password" required placeholder="请输入密码" autocomplete="current-password">
                </div>
            </div>

            <button type="submit" class="btn btn-brand btn-block mt-4">
                <i class="fas fa-arrow-right"></i> 登录并进入系统
            </button>
        </form>

        <div class="account-hint">
            <strong class="d-block mb-2">还没有账号？</strong>
            <div class="helper-text mb-3">新用户可以先注册，再使用购物车、下单和个人中心功能。</div>
            <div class="d-flex flex-wrap gap-2">
                <a class="btn btn-soft mr-2 mb-2" href="<%= ctx %>/Jsp/front/register.jsp">创建账号</a>
                <a class="btn btn-soft mb-2" href="<%= ctx %>/Jsp/front/index.jsp">返回首页</a>
            </div>
        </div>
    </section>
</main>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
