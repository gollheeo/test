<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>搜索结果 - 在线书城</title>
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

        .book-card {
            border: none; border-radius: 12px; background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05); transition: transform 0.3s;
            height: 100%; overflow: hidden;
        }
        .book-card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(0,0,0,0.1); }
        .card-img-top { height: 180px; object-fit: cover; padding: 15px; border-radius: 20px; }
        .price { color: #e74c3c; font-weight: 700; font-size: 1.1rem; }
        .old-price { font-size: 0.85rem; color: #b2bec3; text-decoration: line-through; margin-left: 5px; }
        .tag-category { background: #f1f2f6; color: #636e72; padding: 2px 8px; border-radius: 4px; font-size: 0.75rem; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light fixed-top">
    <div class="container">
        <a class="navbar-brand font-weight-bold" href="${pageContext.request.contextPath}../index.jsp">📚 图书商城</a>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}../index.jsp">首页</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}list">所有图书</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h4 class="mb-4">
        搜索结果：<span class="text-primary">"<c:out value="${keyword}"/>"</span>
    </h4>

    <c:if test="${empty bookList}">
        <div class="text-center py-5">
            <i class="fas fa-search fa-3x text-muted mb-3"></i>
            <p class="text-muted">没有找到相关图书，换个关键词试试？</p>
        </div>
    </c:if>

    <div class="row">
        <c:forEach var="book" items="${bookList}">
            <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 col-6 mb-4">
                <div class="book-card">
                    <a href="detail?bookId=${book.id}" class="d-block text-center bg-light">
                        <img class="card-img-top" loading="lazy"
                             src="${pageContext.request.contextPath}../../include/books/Book-Cover/${book.coverImage}"
                             alt="<c:out value="${book.title}"/>">
                    </a>
                    <div class="card-body p-3 d-flex flex-column">
                        <h6 class="text-truncate font-weight-bold mb-1">
                            <a href="detail?bookId=${book.id}" class="text-dark text-decoration-none">
                                <c:out value="${book.title}"/>
                            </a>
                        </h6>
                        <div class="mb-2">
                            <span class="tag-category"><c:out value="${category.name}"/></span>
                        </div>
                        <p class="small text-muted mb-2 text-truncate"><c:out value="${book.author}"/></p>

                        <div class="mt-auto pt-2 border-top d-flex justify-content-between align-items-center">
                            <div>
                                <span class="price">￥<c:out value="${book.price}"/></span>
                                <c:if test="${book.oldPrice != null && book.oldPrice > book.price}">
                                    <span class="old-price">￥<c:out value="${book.oldPrice}"/></span>
                                </c:if>
                            </div>
                            <a href="${pageContext.request.contextPath}../cart/add?bookId=${book.id}" class="btn btn-sm btn-outline-primary rounded-circle">
                                <i class="fas fa-plus"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
</body>
</html>
