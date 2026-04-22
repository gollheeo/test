<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>热卖图书 - 在线书城</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
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
        .navbar { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); box-shadow: 0 2px 10px rgba(0,0,0,0.05); }

        .section-header { margin-bottom: 40px; position: relative; display: inline-block; }
        .section-header::after { content: ''; position: absolute; bottom: -10px; left: 0; width: 50px; height: 4px; background: #e74c3c; border-radius: 2px; }

        .book-card {
            border: none; border-radius: 16px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: all 0.3s ease; background: white; height: 100%; overflow: hidden;
        }
        .book-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }

        .book-img-wrapper { position: relative; overflow: hidden; height: 220px; text-align: center; background: #f8f9fa; }
        .book-img { height: 100%; object-fit: cover; transition: transform 0.3s; padding: 15px; }
        .book-card:hover .book-img { transform: scale(1.05); }

        /* 排行榜徽章 */
        .rank-badge {
            position: absolute; top: 10px; left: 10px; width: 32px; height: 32px;
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-weight: 800; font-size: 14px; color: white; box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            z-index: 10;
        }
        .rank-1 { background: linear-gradient(135deg, #FFD700, #FDB931); } /* 金 */
        .rank-2 { background: linear-gradient(135deg, #E0E0E0, #BDBDBD); } /* 银 */
        .rank-3 { background: linear-gradient(135deg, #CD7F32, #A0522D); } /* 铜 */
        .rank-other { background: rgba(0,0,0,0.5); font-size: 12px; width: 24px; height: 24px; }

        .price-tag { color: #e74c3c; font-weight: 700; font-size: 1.1rem; }
        .btn-add-cart {
            width: 100%; border-radius: 0 0 16px 16px; border: none;
            background: #f1f2f6; color: #2d3436; font-weight: 600; padding: 10px;
            transition: all 0.2s;
        }
        .btn-add-cart:hover { background: var(--primary); color: white; }
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
                <li class="nav-item active"><a class="nav-link" href="#">热卖推荐</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}../cart.jsp">购物车</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h3 class="section-header font-weight-bold">🔥 热卖图书排行榜</h3>

    <c:if test="${empty hotBookList}">
        <div class="text-center py-5">
            <i class="fas fa-fire-alt fa-3x text-muted mb-3"></i>
            <h5 class="text-muted">暂无热卖数据</h5>
        </div>
    </c:if>

    <div class="row">
        <c:forEach var="book" items="${hotBookList}" varStatus="status">
            <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 col-6 mb-4">
                <div class="book-card">
                    <div class="book-img-wrapper">
                         <span class="rank-badge
                            <c:if test='${status.index == 0}'>rank-1</c:if>
                            <c:if test='${status.index == 1}'>rank-2</c:if>
                            <c:if test='${status.index == 2}'>rank-3</c:if>
                            <c:if test='${status.index > 2}'>rank-other</c:if>">
                                 ${status.index + 1}
                         </span>
                        <a href="detail?bookId=${book.id}">
                            <img class="book-img" loading="lazy"
                                 src="${pageContext.request.contextPath}../../include/books/Book-Cover/${book.coverImage}"
                                 alt="<c:out value="${book.title}"/>">
                        </a>
                    </div>
                    <div class="card-body p-3">
                        <h6 class="text-truncate font-weight-bold mb-1" title="<c:out value="${book.title}"/>">
                            <a href="detail?bookId=${book.id}" class="text-dark text-decoration-none">
                                <c:out value="${book.title}"/>
                            </a>
                        </h6>
                        <p class="small text-muted mb-2 text-truncate"><c:out value="${book.author}"/></p>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="price-tag">￥<c:out value="${book.price}"/></span>
                            <small class="text-muted"><i class="fas fa-fire text-danger"></i> <c:out value="${book.sales}"/></small>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}../cart/add?bookId=${book.id}" class="btn btn-add-cart">
                        <i class="fas fa-cart-plus"></i> 加入购物车
                    </a>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
</body>
</html>
