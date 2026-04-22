<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>最新上架 - 在线书城</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body { background-color: #f8f9fc; padding-top: 80px; font-family: 'Inter', sans-serif; }
        .navbar { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); }
        .book-card { background: white; border: none; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); transition: transform 0.3s; overflow: hidden; height: 100%; }
        .book-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        .card-img-top { height: 200px; object-fit: cover; padding: 15px; border-radius: 20px; }
        .new-badge { position: absolute; top: 10px; right: 10px; background: #2ecc71; color: white; padding: 2px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: bold; }
        .price { color: #e74c3c; font-weight: 700; }
        .btn-cart { width: 100%; border: none; background: #f1f2f6; color: #2d3436; font-weight: 600; padding: 8px; }
        .btn-cart:hover { background: #4a90e2; color: white; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light fixed-top">
    <div class="container">
        <a class="navbar-brand font-weight-bold" href="${pageContext.request.contextPath}../index.jsp">📚 图书商城</a>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}../index.jsp">首页</a></li>
                <li class="nav-item active"><a class="nav-link" href="#">最新上架</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h3 class="mb-4 font-weight-bold text-dark border-bottom pb-3">🌱 最新上架</h3>

    <c:if test="${empty newBookList}">
        <div class="text-center py-5 text-muted">暂无新书上架</div>
    </c:if>

    <div class="row">
        <c:forEach var="book" items="${newBookList}">
            <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 col-6 mb-4">
                <div class="book-card position-relative">
                    <span class="new-badge">NEW</span>
                    <a href="detail?bookId=${book.id}">
                        <img class="card-img-top" src="${pageContext.request.contextPath}../../include/books/Book-Cover/${book.coverImage}" alt="${book.title}">
                    </a>
                    <div class="card-body p-3">
                        <h6 class="text-truncate font-weight-bold mb-1">
                            <a href="detail?bookId=${book.id}" class="text-dark text-decoration-none">${book.title}</a>
                        </h6>
                        <p class="small text-muted mb-2 text-truncate">${book.author}</p>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="price">¥${book.price}</span>
                            <small class="text-muted">${book.publishDate}</small>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}../cart/add?bookId=${book.id}" class="btn btn-cart">
                        <i class="fas fa-cart-plus"></i> 加入
                    </a>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
<jsp:include page="../common/footer.jsp"/>
</body>
</html>
