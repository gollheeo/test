<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <meta charset="UTF-8">
  <title>${currentCategory.name} - 分类浏览</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
  <style>
    body { background-color: #f8f9fc; padding-top: 80px; font-family: 'Inter', sans-serif; }
    .navbar { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); }
    .book-card { background: white; border: none; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); transition: transform 0.3s; height: 100%; }
    .book-card:hover { transform: translateY(-5px); box-shadow: 0 8px 15px rgba(0,0,0,0.1); }
    .card-img-top { height: 180px; object-fit: cover; padding: 15px; }
    .price { color: #e74c3c; font-weight: 700; }
    .btn-buy { background: #4a90e2; color: white; border: none; border-radius: 20px; font-size: 0.8rem; padding: 5px 15px; }
  </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light fixed-top">
  <div class="container">
    <a class="navbar-brand font-weight-bold" href="${pageContext.request.contextPath}../index.jsp">📚 图书商城</a>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ml-auto">
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}../index.jsp">首页</a></li>
        <li class="nav-item active"><a class="nav-link" href="#">分类浏览</a></li>
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-4">
  <h4 class="mb-4">分类：<span class="text-primary font-weight-bold">${currentCategory.name}</span></h4>

  <c:if test="${empty categoryBookList}">
    <div class="alert alert-light text-center py-5 shadow-sm">当前分类暂无图书</div>
  </c:if>

  <div class="row">
    <c:forEach var="book" items="${categoryBookList}">
      <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 col-6 mb-4">
        <div class="book-card card">
          <a href="detail?bookId=${book.id}">
            <img class="card-img-top" src="${pageContext.request.contextPath}../../include/books/Book-Cover/${book.coverImage}" alt="${book.title}">
          </a>
          <div class="card-body p-3 d-flex flex-column">
            <h6 class="text-truncate font-weight-bold mb-1">
              <a href="detail?bookId=${book.id}" class="text-dark text-decoration-none">${book.title}</a>
            </h6>
            <p class="small text-muted mb-2 text-truncate">${book.author}</p>
            <div class="mt-auto d-flex justify-content-between align-items-center">
              <span class="price">¥${book.price}</span>
              <a href="${pageContext.request.contextPath}../cart/add?bookId=${book.id}" class="btn-buy">购</a>
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
