<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctx = request.getContextPath();
    String coverBase = ctx + "/Jsp/include/books/Book-Cover/";
    List<?> bookList = (List<?>) request.getAttribute("bookList");
%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>全部图书 - BookShop</title>
    <jsp:include page="../common/style.jsp"/>
</head>
<body class="front-page">
<jsp:include page="../common/nav.jsp"/>

<main class="container front-container pb-5">
    <section class="page-banner surface-card mt-4">
        <span class="eyebrow">Catalog Overview</span>
        <h1>全部图书</h1>
        <p>
            图书列表页重点优化了封面比例、价格信息和搜索区域的层级，
            让它既能承担“查书”的效率任务，也能保持像在线书店一样的浏览体验。
        </p>
        <div class="hero-metrics">
            <div class="metric-pill">
                <strong><%= bookList != null ? bookList.size() : 0 %></strong>
                <span>当前书目</span>
            </div>
            <div class="metric-pill">
                <strong>2</strong>
                <span>主要浏览模式</span>
            </div>
            <div class="metric-pill">
                <strong>1s</strong>
                <span>核心信息定位</span>
            </div>
        </div>
    </section>

    <section class="section-block">
        <div class="section-panel surface-card">
            <div class="section-heading">
                <div>
                    <h2>图书书库</h2>
                    <p>更紧凑的顶部说明，更聚焦的卡片信息层级。</p>
                </div>
                <form class="front-search" action="<%= ctx %>/Jsp/front/book/search" method="get">
                    <div class="search-shell">
                        <input class="form-control" type="search" name="keyword" placeholder="搜索书名、作者或 ISBN" value="${param.keyword}">
                        <button class="btn btn-brand" type="submit"><i class="fas fa-search"></i></button>
                    </div>
                </form>
            </div>

            <c:choose>
                <c:when test="${empty bookList}">
                    <div class="data-empty">
                        <i class="fas fa-books fa-3x"></i>
                        暂无图书数据，后续可在后台添加后自动展示。
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="feature-grid">
                        <c:forEach var="book" items="${bookList}">
                            <div class="feature-grid-card">
                                <div class="feature-grid-media">
                                    <a href="<%= ctx %>/Jsp/front/book/detail?bookId=${book.id}">
                                        <img src="<%= coverBase %>${book.coverImage}" alt="${book.title}">
                                    </a>
                                </div>
                                <h5>
                                    <a href="<%= ctx %>/Jsp/front/book/detail?bookId=${book.id}">
                                        <c:out value="${book.title}"/>
                                    </a>
                                </h5>
                                <p class="mb-2"><c:out value="${book.author}"/></p>
                                <div class="price-row">
                                    <span class="price-current">&#165;<c:out value="${book.price}"/></span>
                                    <c:if test="${book.oldPrice != null && book.oldPrice > book.price}">
                                        <span class="price-old">&#165;<c:out value="${book.oldPrice}"/></span>
                                    </c:if>
                                </div>
                                <div class="meta-row mb-3">
                                    <span><i class="fas fa-layer-group mr-1"></i>分类 ID ${book.categoryId}</span>
                                    <c:if test="${book.isHot}">
                                        <span><i class="fas fa-fire-alt mr-1"></i>热销图书</span>
                                    </c:if>
                                </div>
                                <a class="btn btn-brand btn-block" href="<%= ctx %>/Jsp/front/cart/add?bookId=${book.id}">
                                    <i class="fas fa-cart-plus"></i> 加入购物车
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>
</main>

<jsp:include page="../common/footer.jsp"/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
