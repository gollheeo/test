<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.bookshop.model.User" %>
<%
    User userProfile = (User) request.getAttribute("userProfile");
    if (userProfile == null) {
        userProfile = (User) session.getAttribute("user");
    }
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>个人中心 - 在线书城</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
    <style>
        :root { --primary: #4a90e2; --bg: #f8f9fc; }
        body {
            background-color: var(--bg);
            background-image: radial-gradient(circle at 10% 20%, rgba(74, 144, 226, 0.05) 0%, transparent 20%);
            font-family: 'Inter', sans-serif;
            padding-top: 80px;
        }
        .navbar { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); }
        .card-modern {
            background: #fff;
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            padding: 30px;
            margin-bottom: 25px;
        }
        .avatar {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid #fff;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 15px;
        }
        .form-control {
            border-radius: 30px;
            border: 1px solid #e1e1e1;
            padding: 10px 20px;
            background-color: #f9f9f9;
        }
        .form-control:focus { background: #fff; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1); }
        .form-control[disabled] { background-color: #f1f2f6; cursor: not-allowed; }
        .btn-pill { border-radius: 50px; padding: 8px 25px; }
        .footer-modern { background: #2d3436; color: #b2bec3; padding: 40px 0; border-radius: 40px 40px 0 0; margin-top: 50px; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light fixed-top">
    <div class="container">
        <a class="navbar-brand font-weight-bold" href="${pageContext.request.contextPath}../index.jsp">📚 图书商城</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"><span class="navbar-toggler-icon"></span></button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item active"><a class="nav-link" href="#">个人中心</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}../order">我的订单</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}../cart/list">购物车</a></li>
                <li class="nav-item"><a class="nav-link text-danger" href="/Jsp/front/user/logout">退出</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <div class="row">
        <!-- 左侧：头像与快捷菜单 -->
        <div class="col-md-4">
            <div class="card-modern text-center">
                <c:set var="avatarPath" value="${userProfile.avatar}" />
                <c:if test="${empty avatarPath}">
                    <c:set var="avatarPath" value='../../include/user/avatars.jpg' />
                </c:if>
                <img class="avatar" src="<c:out value='${avatarPath}' escapeXml='true'/>" alt="头像">

                <h4 class="font-weight-bold mb-1"><c:out value="${userProfile.username}"/></h4>
                <p class="text-muted small mb-3">加入时间：<c:out value="${userProfile.createdAt}"/></p>

                <div class="mb-4">
                    <span class="badge badge-primary px-3 py-2 rounded-pill">
                        <c:choose>
                            <c:when test="${userProfile.gender == 'M'}"><i class="fas fa-mars"></i> 男生</c:when>
                            <c:when test="${userProfile.gender == 'F'}"><i class="fas fa-venus"></i> 女生</c:when>
                            <c:otherwise>神秘用户</c:otherwise>
                        </c:choose>
                    </span>
                    <c:if test="${userProfile.role == 'admin'}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="badge badge-warning px-3 py-2 rounded-pill text-white ml-2">管理员</a>
                    </c:if>
                </div>

                <div class="d-flex flex-column gap-2">
                    <a href="${pageContext.request.contextPath}../order/list" class="btn btn-outline-primary btn-pill mb-2"><i class="fas fa-list-alt mr-2"></i>我的订单</a>
                    <a href="${pageContext.request.contextPath}../cart/list" class="btn btn-outline-secondary btn-pill"><i class="fas fa-shopping-cart mr-2"></i>我的购物车</a>
                </div>
            </div>
        </div>

        <!-- 右侧：资料编辑 -->
        <div class="col-md-8">
            <div class="card-modern">
                <h5 class="mb-4 font-weight-bold" style="color: #2d3436; border-left: 4px solid var(--primary); padding-left: 15px;">基本资料</h5>

                <c:if test="${param.success == '1'}">
                    <div class="alert alert-success rounded-lg">资料更新成功！</div>
                </c:if>
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger rounded-lg"><c:out value="${param.error}"/></div>
                </c:if>

                <form action="updateProfile" method="post">
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label text-muted">用户名</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" value="<c:out value='${userProfile.username}'/>" disabled>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label text-muted">邮箱</label>
                        <div class="col-sm-9">
                            <input type="email" name="email" class="form-control" value="<c:out value='${userProfile.email}'/>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label text-muted">手机号</label>
                        <div class="col-sm-9">
                            <input type="text" name="phone" class="form-control" value="<c:out value='${userProfile.phone}'/>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label text-muted">性别</label>
                        <div class="col-sm-9">
                            <select name="gender" class="form-control">
                                <option value="">保密</option>
                                <option value="M" <c:if test="${userProfile.gender == 'M'}">selected</c:if>>男</option>
                                <option value="F" <c:if test="${userProfile.gender == 'F'}">selected</c:if>>女</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label text-muted">生日</label>
                        <div class="col-sm-9">
                            <input type="date" name="birthday" class="form-control" value="<c:out value='${userProfile.birthday}'/>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label text-muted">地址</label>
                        <div class="col-sm-9">
                            <input type="text" name="address" class="form-control" value="<c:out value='${userProfile.address}'/>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label text-muted">头像</label>
                        <div class="col-sm-9">
                            <input type="text" name="avatar" class="form-control" placeholder="输入头像路径..." value="<c:out value='${userProfile.avatar}'/>">
                        </div>
                    </div>

                    <div class="form-group row mt-4">
                        <div class="col-sm-9 offset-sm-3">
                            <button type="submit" class="btn btn-primary btn-pill shadow px-4">保存修改</button>
                            <a href="${pageContext.request.contextPath}../index.jsp" class="btn btn-light btn-pill px-4 ml-2">返回</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<footer class="footer-modern text-center">
    <div class="container">
        <p class="mb-0">&copy; 2024 图书商城. Designed for You.</p>
    </div>
</footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
