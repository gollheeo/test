<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>购物车</title>
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

        .cart-item {
            background: white;
            padding: 20px;
            margin-bottom: 15px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            box-shadow: 0 4px 10px rgba(0,0,0,0.03);
            transition: transform 0.2s;
        }
        .cart-item:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(0,0,0,0.08); }

        .cart-summary {
            background: white;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            position: sticky;
            top: 100px;
        }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 0.95rem; color: #636e72; }
        .total-price { font-size: 1.8rem; color: #2d3436; font-weight: 800; }
        .btn-checkout {
            background: linear-gradient(135deg, #4a90e2 0%, #3498db 100%);
            color: white; border: none; padding: 15px; border-radius: 50px;
            font-size: 1.1rem; font-weight: 600; width: 100%; box-shadow: 0 8px 20px rgba(74, 144, 226, 0.4);
            transition: all 0.3s;
        }
        .btn-checkout:hover { transform: translateY(-2px); box-shadow: 0 12px 25px rgba(74, 144, 226, 0.5); }

        .qty-input {
            border: 2px solid #f1f2f6; border-radius: 10px; padding: 5px;
            text-align: center; width: 70px; font-weight: 600;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light fixed-top">
    <div class="container">
        <a class="navbar-brand font-weight-bold" href="/Jsp/front/index.jsp">📚 图书商城</a>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}../index.jsp">继续购物</a></li>
                <li class="nav-item active"><a class="nav-link" href="#">购物车</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h2 class="mb-4 font-weight-bold">购物车</h2>

    <!-- 消息提示 -->
    <c:if test="${not empty message}">
        <div class="alert alert-success rounded-pill px-4 shadow-sm">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger rounded-pill px-4 shadow-sm">${error}</div>
    </c:if>

    <div class="row">
        <!-- 购物车列表 -->
        <div class="col-lg-8">
            <c:choose>
                <c:when test="${empty cartItems}">
                    <div class="text-center py-5 bg-white rounded-lg shadow-sm">
                        <i class="fas fa-shopping-basket fa-3x text-muted mb-3"></i>
                        <p class="text-muted">购物车空空如也</p>
                        <a href="${pageContext.request.contextPath}../index.jsp" class="btn btn-outline-primary rounded-pill px-4">去选购</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="item" items="${cartItems}">
                        <div class="cart-item">
                            <div class="mr-3 text-center" style="width: 60px;">
                                <i class="fas fa-book fa-2x text-muted"></i>
                            </div>
                            <div class="flex-grow-1">
                                <h5 class="mb-1 font-weight-bold"><c:out value="${item.bookName}" escapeXml="true"/></h5>
                                <span class="text-muted small">单价: ¥<fmt:formatNumber value="${item.price}" pattern="0.00"/></span>
                            </div>
                            <div class="mx-3">
                                <form action="${pageContext.request.contextPath}/Jsp/front/cart/update" method="post" class="mb-0">
                                    <input type="hidden" name="bookId" value="${item.bookId}">
                                    <input type="number" name="quantity" min="1" value="${item.quantity}"
                                           class="qty-input" onchange="this.form.submit()">
                                </form>
                            </div>
                            <div class="text-right" style="min-width: 100px;">
                                <div class="font-weight-bold mb-1" style="color: #2d3436;">
                                    ¥<fmt:formatNumber value="${item.subtotal}" pattern="0.00"/>
                                </div>
                                <a href="${pageContext.request.contextPath}/Jsp/front/cart/remove?bookId=${item.bookId}"
                                   class="text-danger small" onclick="return confirm('确认删除？')">
                                    <i class="fas fa-trash-alt"></i> 删除
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 结算区域 -->
        <c:if test="${not empty cartItems}">
            <div class="col-lg-4">
                <div class="cart-summary">
                    <h5 class="font-weight-bold mb-4">订单摘要</h5>
                    <div class="summary-row">
                        <span>商品数量</span>
                        <span class="font-weight-bold">${totalCount} 本</span>
                    </div>
                    <div class="summary-row">
                        <span>小计</span>
                        <span>¥<fmt:formatNumber value="${subtotal}" pattern="0.00"/></span>
                    </div>
                    <div class="summary-row">
                        <span>运费</span>
                        <span class="text-success">免费</span>
                    </div>
                    <hr class="my-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <span class="font-weight-bold">总计</span>
                        <span class="total-price">¥<fmt:formatNumber value="${totalAmount}" pattern="0.00"/></span>
                    </div>

                    <form action="${pageContext.request.contextPath}/Jsp/front/order/create" method="post">
                        <button type="submit" class="btn-checkout">
                            立即结算 <i class="fas fa-arrow-right ml-2"></i>
                        </button>
                    </form>

                    <div class="text-center mt-3">
                        <a href="${pageContext.request.contextPath}clear" class="text-muted small" onclick="return confirm('清空购物车？')">清空购物车</a>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</div>

<div class="mt-5">
    <jsp:include page="common/footer.jsp"/>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
