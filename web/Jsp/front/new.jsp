<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
  <meta charset="UTF-8">
  <title>在线书城首页</title>

  <!-- 提取样式文件 -->
  <jsp:include page="common/style.jsp"/>

  <style>
    body { background-color: #f7f7f7; }
    .navbar-brand { font-weight: bold; }
    .carousel-item img { height: 360px; object-fit: cover; width: 100%; }
    .section-title { margin: 30px 0 15px 0; }
    .book-card { margin-bottom: 20px; }
    .book-img { height: 180px; object-fit: cover; }
    .price { color: #e4393c; font-weight: bold; }
    .old-price { text-decoration: line-through; color: #999; margin-left: 5px; }
    .category-list a { margin-right: 10px; margin-bottom: 5px; }
    .footer { margin-top: 40px; padding: 20px 0; background: #fff; border-top: 1px solid #ddd; color: #777; }
  </style>
</head>
<body>

<!-- 顶部导航 -->
<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">📚 图书商城
      <img src="${pageContext.request.contextPath}/include/images/logo.png" width="200" height="60" border="0" alt="Logo"/>
    </a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarNav">
      <!-- 搜索框 -->
      <form class="form-inline my-2 my-lg-0 ml-auto"
            action="${pageContext.request.contextPath}/book/search"
            method="get">
        <input class="form-control mr-sm-2" type="search"
               name="keyword" placeholder="搜索图书/作者/ISBN">
        <button class="btn btn-outline-success my-2 my-sm-0" type="submit">搜索</button>
      </form>

      <!-- 登录 / 注册 / 我的订单 -->
      <ul class="navbar-nav ml-3">
        <c:choose>
          <c:when test="${not empty sessionScope.user}">
            <li class="nav-item">
              <a class="nav-link" href="#">
                欢迎，<c:out value="${sessionScope.user.username}"/>
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/cart.jsp">
                我的订单
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/user/logout">
                退出
              </a>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">登录</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/register.jsp">注册</a>
            </li>
          </c:otherwise>
        </c:choose>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/cart.jsp">
            购物车
            <img src="${pageContext.request.contextPath}/include/images/cart.gif" width="26" height="23" style="margin-bottom:-4px" alt="Cart Icon"/>
          </a>
        </li>
      </ul>
    </div>
  </div>
</nav>

<!-- 主体内容 -->
<div class="container mt-4">

  <!-- 顶部轮播图 -->
  <div id="bookCarousel" class="carousel slide" data-ride="carousel">
    <ol class="carousel-indicators">
      <li data-target="#bookCarousel" data-slide-to="0" class="active"></li>
      <li data-target="#bookCarousel" data-slide-to="1"></li>
      <li data-target="#bookCarousel" data-slide-to="2"></li>
    </ol>
    <div class="carousel-inner">
      <div class="carousel-item active">
        <a href="${pageContext.request.contextPath}/book/detail?bookId=1">
          <img src="${pageContext.request.contextPath}/images/books/ad/index_ad1.jpg"
               class="d-block w-100" loading="lazy" alt="Banner 1">
        </a>
        <div class="carousel-caption d-none d-md-block">
          <h5>编程入门精选</h5>
          <p>从零开始掌握 Java / Python / 前端基础。</p>
        </div>
      </div>
      <div class="carousel-item">
        <a href="${pageContext.request.contextPath}/book/list">
          <img src="${pageContext.request.contextPath}/images/books/ad/index_ad2.jpg"
               class="d-block w-100" loading="lazy" alt="Banner 2">
        </a>
        <div class="carousel-caption d-none d-md-block">
          <h5>畅销图书排行</h5>
          <p>看看大家都在读什么。</p>
        </div>
      </div>
      <div class="carousel-item">
        <a href="${pageContext.request.contextPath}/book/hot">
          <img src="${pageContext.request.contextPath}/images/books/ad/index_ad3.jpg"
               class="d-block w-100" loading="lazy" alt="Banner 3">
        </a>
        <div class="carousel-caption d-none d-md-block">
          <h5>热卖好书推荐</h5>
          <p>销量与口碑双高的优质图书。</p>
        </div>
      </div>
    </div>
    <a class="carousel-control-prev" href="#bookCarousel" role="button" data-slide="prev">
      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
    </a>
    <a class="carousel-control-next" href="#bookCarousel" role="button" data-slide="next">
      <span class="carousel-control-next-icon" aria-hidden="true"></span>
    </a>
  </div>

  <!-- 分类快捷入口 -->
  <div class="section-title d-flex justify-content-between align-items-center">
    <h4>图书分类</h4>
    <a href="${pageContext.request.contextPath}/book/list" class="btn btn-link">查看全部图书 &raquo;</a>
  </div>
  <div class="category-list mb-3">
    <c:forEach var="cat" items="${categoryList}">
      <a class="btn btn-sm btn-outline-secondary"
         href="${pageContext.request.contextPath}/book/category?categoryId=${cat.id}">
        <c:out value="${cat.name}"/>
      </a>
    </c:forEach>
    <c:if test="${empty categoryList}">
      <span class="text-muted">暂未配置分类</span>
    </c:if>
  </div>

  <div class="row">
    <!-- 热卖图书 -->
    <div class="col-md-4">
      <h5 class="section-title d-flex justify-content-between align-items-center">
        <span>热卖图书</span>
        <a href="${pageContext.request.contextPath}/book/hot" class="small">
          <img src="${pageContext.request.contextPath}/include/images/hottitle.gif" width="120" height="24" alt="Hot Title"/> 更多 &raquo;</a>
      </h5>
      <div class="list-group">
        <c:forEach var="book" items="${hotBookList}">
          <div class="book-row mb-3 p-3 border rounded">
            <div class="media">
              <a href="${pageContext.request.contextPath}/book/detail?bookId=${book.id}">
                <img class="mr-3 book-img" style="width: 80px; height: 100px;" loading="lazy"
                     src="${pageContext.request.contextPath}/include/books/Book-Cover/${book.coverImage}"
                     alt="<c:out value="${book.title}"/>">
              </a>
              <div class="media-body">
                <h6 class="mt-0">
                  <a href="${pageContext.request.contextPath}/book/detail?bookId=${book.id}">
                    <c:out value="${book.title}"/>
                  </a>
                </h6>
                <p class="mb-1 text-muted">
                  作者：<c:out value="${book.author}"/>
                </p>
                <a href="${pageContext.request.contextPath}/cart/add?bookId=${book.id}"
                   class="btn btn-sm btn-primary">加入购物车</a>
              </div>
            </div>
          </div>
        </c:forEach>
        <c:if test="${empty hotBookList}">
          <div class="list-group-item text-muted">暂无热卖数据</div>
        </c:if>
      </div>
    </div>

    <!-- 最新上架 -->
    <div class="col-md-4">
      <h5 class="section-title d-flex justify-content-between align-items-center">
        <span>最新上架</span>
        <a href="${pageContext.request.contextPath}/book/new" class="small">更多 &raquo;</a>
      </h5>
      <div class="list-group">
        <c:forEach var="book" items="${newBookList}">
          <div class="book-row mb-3 p-3 border rounded">
            <div class="media">
              <a href="${pageContext.request.contextPath}/book/detail?bookId=${book.id}">
                <img class="mr-3 book-img" style="width: 80px; height: 100px;" loading="lazy"
                     src="${pageContext.request.contextPath}/include/books/Book-Cover/${book.coverImage}"
                     alt="<c:out value="${book.title}"/>">
              </a>
              <div class="media-body">
                <h6 class="mt-0">
                  <a href="${pageContext.request.contextPath}/book/detail?bookId=${book.id}">
                    <c:out value="${book.title}"/>
                  </a>
                </h6>
                <p class="mb-1 text-muted">
                  作者：<c:out value="${book.author}"/>
                </p>
                <a href="${pageContext.request.contextPath}/cart/add?bookId=${book.id}"
                   class="btn btn-sm btn-primary">加入购物车</a>
              </div>
            </div>
          </div>
        </c:forEach>
        <c:if test="${empty newBookList}">
          <div class="list-group-item text-muted">暂无最新上架数据</div>
        </c:if>
      </div>
    </div>

    <!-- 推荐图书网格展示 -->
    <h5 class="section-title">精选图书</h5>
    <div class="row">
      <c:forEach var="book" items="${recommendBookList}">
        <div class="col-md-3 col-sm-4 col-6 book-card">
          <div class="card h-100">
            <a href="${pageContext.request.contextPath}/book/detail?bookId=${book.id}">
              <img class="card-img-top book-img" loading="lazy"
                   src="${pageContext.request.contextPath}/include/books/Book-Cover/${book.coverImage}"
                   alt="<c:out value="${book.title}"/>">
            </a>
            <div class="card-body">
              <h6 class="card-title text-truncate" title="<c:out value="${book.title}"/>">
                <a href="${pageContext.request.contextPath}/book/detail?bookId=${book.id}">
                  <c:out value="${book.title}"/>
                </a>
              </h6>
              <p class="card-text mb-1 text-muted">
                作者：<c:out value="${book.author}"/>
              </p>
            </div>
            <div class="card-footer text-center">
              <a href="${pageContext.request.contextPath}/cart/add?bookId=${book.id}"
                 class="btn btn-sm btn-primary">加入购物车</a>
            </div>
          </div>
        </div>
      </c:forEach>
      <c:if test="${empty recommendBookList}">
        <div class="col-12 text-muted">暂无精选图书，可稍后在后台配置。</div>
      </c:if>
    </div>
  </div>
</div>

<!-- 页脚 -->
<footer style="background-color: #2c3e50; color: white; padding: 40px 0; margin-top: 50px;">
  <div class="container">
    <div class="row">
      <div class="col-md-4">
        <h5>关于我们</h5>
        <p>提供最好的书籍和最优的购物体验</p>
      </div>
      <div class="col-md-4">
        <h5>快速链接</h5>
        <ul style="list-style: none; padding: 0;">
          <li><a href="${pageContext.request.contextPath}/book/hot" style="color: white; text-decoration: none;">热卖图书</a></li>
          <li><a href="${pageContext.request.contextPath}/book/category" style="color: white; text-decoration: none;">分类浏览</a></li>
          <li><a href="#" style="color: white; text-decoration: none;">新书上市</a></li>
        </ul>
      </div>
      <div class="col-md-4">
        <h5>联系我们</h5>
        <p>邮箱: support@bookshop.com</p>
        <p>电话: 400-888-8888</p>
      </div>
    </div>
    <hr style="border-color: #34495e;">
    <p style="text-align: center; margin: 0;">&copy; 2024 图书商城. 版权所有。</p>
  </div>
</footer>

<!-- 安全加载第三方库 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"
        integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
        crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-Piv4xVNRyMGpqkS2by6br4gNJ7DXjqk09RmUpJ8jgGtD7zP9yug3goQfGII0yAns"
        crossorigin="anonymous"></script>
</body>
</html>
z