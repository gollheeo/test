<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.bookshop.model.Order,com.bookshop.model.OrderItem,java.util.*" %>
<% Order order = (Order) request.getAttribute("order"); %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>订单详情</title>
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
        .navbar { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); }
        .detail-card {
            background: white; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            padding: 30px; margin-bottom: 25px; border: none;
        }
        .info-label { color: #b2bec3; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; }
        .info-value { font-weight: 600; color: #2d3436; font-size: 1.1rem; }
        .item-row { padding: 15px 0; border-bottom: 1px dashed #f1f2f6; }
        .item-row:last-child { border-bottom: none; }
        .status-badge { padding: 5px 15px; border-radius: 20px; font-weight: bold; font-size: 0.9rem; }
        .price-tag { color: #e74c3c; font-weight: 800; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light fixed-top">
    <div class="container">
        <a class="navbar-brand font-weight-bold" href="${pageContext.request.contextPath}../index.jsp">📚 图书商城</a>
        <a class="nav-link text-dark ml-auto" href="${pageContext.request.contextPath}list"><i class="fas fa-arrow-left"></i> 返回订单列表</a>
    </div>
</nav>

<div class="container mt-4">
    <c:choose>
        <c:when test="${empty order}">
            <div class="alert alert-danger rounded-pill shadow-sm text-center">订单信息不存在</div>
        </c:when>
        <c:otherwise>
            <div class="detail-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <div class="info-label">Order Number</div>
                        <div class="info-value">#${order.orderNo}</div>
                    </div>
                    <div class="status-badge bg-light text-primary">
                            ${order.status}
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <div class="info-label">下单时间</div>
                        <div class="info-value"><fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm"/></div>
                    </div>
                    <div class="col-md-4">
                        <div class="info-label">总金额</div>
                        <div class="info-value price-tag">¥<fmt:formatNumber value="${order.totalPrice}" pattern="0.00"/></div>
                    </div>
                </div>
            </div>

            <div class="detail-card">
                <h5 class="font-weight-bold mb-4">商品清单</h5>
                <c:forEach var="item" items="${order.items}">
                    <div class="item-row d-flex align-items-center">
                        <div class="mr-3 text-muted"><i class="fas fa-book fa-2x"></i></div>
                        <div class="flex-grow-1">
                            <h6 class="mb-0 font-weight-bold">${item.bookName}</h6>
                            <small class="text-muted">ID: ${item.bookId}</small>
                        </div>
                        <div class="text-right px-4">
                            <div class="text-muted small">数量</div>
                            <div class="font-weight-bold">x${item.quantity}</div>
                        </div>
                        <div class="text-right" style="min-width: 80px;">
                            <div class="text-muted small">单价</div>
                            <div class="font-weight-bold">¥<fmt:formatNumber value="${item.price}" pattern="0.00"/></div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="detail-card">
                <div class="d-flex justify-content-between align-items-center">
                    <span class="font-weight-bold">实际支付</span>
                    <span class="price-tag" style="font-size: 1.5rem;">¥<fmt:formatNumber value="${order.totalPrice}" pattern="0.00"/></span>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
