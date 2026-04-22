<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <title><c:out value="${book.title}"/> - 图书详情</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body { background-color: #f8f9fc; padding-top: 80px; font-family: 'Inter', sans-serif; }
        .navbar { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); }

        .detail-card { background: white; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); overflow: hidden; padding: 40px; }
        .book-cover { width: 100%; max-width: 300px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.15); }
        .price-current { color: #e74c3c; font-size: 2.5rem; font-weight: 800; }
        .price-old { text-decoration: line-through; color: #b2bec3; font-size: 1.2rem; margin-left: 10px; }

        .info-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; margin: 20px 0; }
        .info-item { background: #f8f9fa; padding: 10px 15px; border-radius: 8px; font-size: 0.9rem; }
        .info-label { color: #636e72; display: block; font-size: 0.8rem; margin-bottom: 2px; }

        .qty-input { width: 60px; text-align: center; border: 1px solid #dfe6e9; border-radius: 8px; height: 45px; }
        .btn-qty { width: 45px; height: 45px; border-radius: 8px; border: 1px solid #dfe6e9; background: white; }
        .btn-buy { background: #e74c3c; border: none; height: 50px; border-radius: 25px; padding: 0 40px; font-weight: 600; box-shadow: 0 5px 15px rgba(231, 76, 60, 0.3); }
        .btn-buy:hover { background: #c0392b; transform: translateY(-2px); }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light fixed-top">
    <div class="container">
        <a class="navbar-brand font-weight-bold" href="${pageContext.request.contextPath}../index.jsp">📚 图书商城</a>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}list">返回列表</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}../cart.jsp"><i class="fas fa-shopping-cart"></i></a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4 mb-5">
    <div class="detail-card">
        <div class="row">
            <div class="col-md-5 text-center mb-4 mb-md-0">
                <img class="book-cover" src="${pageContext.request.contextPath}../../include/books/Book-Cover/${book.coverImage}" alt="${book.title}">
            </div>
            <div class="col-md-7">
                <div class="badge badge-primary px-3 py-2 mb-3 rounded-pill">${category.name}</div>
                <h1 class="font-weight-bold mb-3">${book.title}</h1>
                <p class="text-muted mb-4"><i class="fas fa-pen-nib mr-2"></i>${book.author}</p>

                <div class="d-flex align-items-baseline mb-4">
                    <span class="price-current">￥${book.price}</span>
                    <c:if test="${book.oldPrice != null && book.oldPrice > book.price}">
                        <span class="price-old">￥${book.oldPrice}</span>
                    </c:if>
                </div>

                <div class="info-grid">
                    <div class="info-item"><span class="info-label">出版社</span>${book.publisher}</div>
                    <div class="info-item"><span class="info-label">出版时间</span>${book.publishDate}</div>
                    <div class="info-item"><span class="info-label">库存</span>${book.stock} 件</div>
                    <div class="info-item"><span class="info-label">累计销量</span>${book.sales}</div>
                </div>

                <form method="post" action="${pageContext.request.contextPath}../cart/add?bookId=${book.id}" class="mt-4">
                    <input type="hidden" name="bookId" value="${book.id}">
                    <div class="d-flex align-items-center">
                        <div class="mr-4 d-flex align-items-center">
                            <button type="button" class="btn-qty" onclick="updateQty(-1)">-</button>
                            <input type="number" id="quantity" name="quantity" value="1" min="1" max="${book.stock}" class="qty-input mx-2 form-control-plaintext" readonly>
                            <button type="button" class="btn-qty" onclick="updateQty(1)">+</button>
                        </div>
                        <button type="submit" class="btn btn-primary btn-buy text-white flex-grow-1">
                            <i class="fas fa-cart-plus mr-2"></i> 加入购物车
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div class="mt-5 pt-5 border-top">
            <h4 class="font-weight-bold mb-3">内容简介</h4>
            <div class="text-secondary" style="line-height: 1.8; white-space: pre-line;">
                <c:out value="${book.description}"/>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

<script>
    function updateQty(change) {
        const input = document.getElementById('quantity');
        let val = parseInt(input.value) + change;
        if (val < 1) val = 1;
        if (val > ${book.stock}) val = ${book.stock};
        input.value = val;
    }
</script>
</body>
</html>
