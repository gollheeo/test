<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.*,com.bookshop.model.Order" %>
<%
  List<Order> orders = (List<Order>) request.getAttribute("orders");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>我的订单</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <style>
    :root { --primary: #4a90e2; --bg: #f8f9fc; }
    body {
      background-color: var(--bg);
      background-image: radial-gradient(circle at 10% 20%, rgba(74, 144, 226, 0.05) 0%, transparent 20%);
      font-family: 'Inter', sans-serif;
      padding-top: 80px;
    }
    /* 导航栏样式 (与首页保持一致) */
    .navbar { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
    .navbar-brand { font-weight: 700; color: #2d3436 !important; }
    .nav-link { color: #636e72 !important; font-weight: 500; }

    /* 订单卡片 */
    .order-card {
      background: white;
      border: none;
      border-radius: 16px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.05);
      margin-bottom: 25px;
      padding: 25px;
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;
    }
    .order-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }

    /* 状态标签 */
    .order-status {
      padding: 6px 15px;
      border-radius: 30px;
      font-size: 0.85em;
      font-weight: 600;
      letter-spacing: 0.5px;
      text-transform: uppercase;
    }
    .status-pending { background-color: #fff3cd; color: #856404; }
    .status-paid { background-color: #d4edda; color: #155724; }
    .status-shipped { background-color: #cce5ff; color: #004085; }
    .status-completed { background-color: #d1ecf1; color: #0c5460; }
    .status-cancelled { background-color: #f8d7da; color: #721c24; }

    .price { color: #e74c3c; font-weight: 700; font-size: 1.1em; }
    .btn-primary {
      background-color: var(--primary); border: none; border-radius: 50px;
      padding: 8px 20px; box-shadow: 0 4px 10px rgba(74, 144, 226, 0.3);
    }
    .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 6px 15px rgba(74, 144, 226, 0.4); }

    .page-title { margin-bottom: 30px; font-weight: 700; color: #2d3436; }
    .footer { margin-top: 60px; padding: 40px 0; background: #2d3436; color: #b2bec3; border-radius: 40px 40px 0 0; }
  </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light fixed-top">
  <div class="container">
    <a class="navbar-brand" href="${pageContext.request.contextPath}../index.jsp">📚 图书商城</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <form class="form-inline my-2 my-lg-0 ml-auto" action="${pageContext.request.contextPath}../book/search" method="get">
        <input class="form-control mr-sm-2" style="border-radius: 20px;" type="search" name="keyword" placeholder="搜索图书...">
        <button class="btn btn-outline-primary my-2 my-sm-0" style="border-radius: 20px;" type="submit">搜索</button>
      </form>
      <ul class="navbar-nav ml-3 align-items-center">
        <c:choose>
          <c:when test="${not empty sessionScope.user}">
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/Jsp/front/user/profile">👤 <c:out value="${sessionScope.user.username}"/></a></li>
            <li class="nav-item active"><a class="nav-link" href="${pageContext.request.contextPath}list">我的订单</a></li>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/Jsp/front/user/logout">退出</a></li>
          </c:when>
          <c:otherwise>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}../login.jsp">登录</a></li>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}../register.jsp">注册</a></li>
          </c:otherwise>
        </c:choose>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}../cart/list"><i class="fas fa-shopping-cart"></i> 购物车</a></li>
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-5">
  <h2 class="page-title"><i class="fas fa-clipboard-list mr-2" style="color: #4a90e2;"></i>我的订单</h2>

  <div class="row">
    <div class="col-12">
      <c:choose>
        <c:when test="${empty orders}">
          <div class="text-center py-5">
            <i class="fas fa-shopping-bag fa-4x text-muted mb-3"></i>
            <h4 class="text-muted">暂无订单</h4>
            <a href="${pageContext.request.contextPath}../index.jsp" class="btn btn-primary mt-3">去逛逛</a>
          </div>
        </c:when>
        <c:otherwise>
          <c:forEach var="order" items="${orders}">
            <div class="order-card">
              <div class="d-flex justify-content-between align-items-center flex-wrap">
                <div class="mb-2 mb-md-0">
                  <h5 class="mb-1 font-weight-bold">订单号 # ${order.orderNo}</h5>
                  <p class="mb-0 text-muted small">
                    <i class="far fa-clock mr-1"></i>
                    <fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                  </p>
                </div>
                <div>
                   <span class="order-status status-${order.status}">
                        <c:choose>
                          <c:when test="${order.status eq 'pending'}">待支付</c:when>
                          <c:when test="${order.status eq 'paid'}">已支付</c:when>
                          <c:when test="${order.status eq 'shipped'}">已发货</c:when>
                          <c:when test="${order.status eq 'completed'}">已完成</c:when>
                          <c:when test="${order.status eq 'cancelled'}">已取消</c:when>
                          <c:otherwise>${order.status}</c:otherwise>
                        </c:choose>
                    </span>
                </div>
              </div>

              <hr style="border-top: 1px dashed #e1e1e1; margin: 20px 0;">

              <div class="row align-items-center">
                <div class="col-md-6">
                  <p class="mb-0 text-muted">订单总额</p>
                  <p class="mb-0 price">¥<fmt:formatNumber value="${order.totalPrice}" pattern="0.00"/></p>
                </div>
                <div class="col-md-6 text-right mt-3 mt-md-0">
                  <a href="${pageContext.request.contextPath}detail?id=${order.id}" class="btn btn-primary">
                    查看详情 <i class="fas fa-arrow-right ml-1"></i>
                  </a>
                </div>
              </div>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>

<footer class="footer">
  <div class="container text-center">
    <p>&copy; 2024 图书商城. 版权所有。</p>
  </div>
</footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
