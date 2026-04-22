<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  <!-- 添加格式化标签库 -->
<%@ page import="java.util.List" %>

<html>
<head>
  <meta charset="UTF-8">
  <title>在线书城首页</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
  <style>
    body {
      background-color: #f7f7f7;
      padding-top: 80px;
    }
    .navbar-brand {
      font-weight: bold;
    }
    .carousel-item img {
      height: 360px;
      object-fit: cover;
      width: 100%;
    }
    .section-title {
      margin: 30px 0 15px 0;
    }
    .book-card {
      margin-bottom: 20px;
    }
    .book-img {
      height: 180px;
      object-fit: cover;
    }
    .price {
      color: #e4393c;
      font-weight: bold;
    }
    .old-price {
      text-decoration: line-through;
      color: #999;
      margin-left: 5px;
    }
    .category-list a {
      margin-right: 10px;
      margin-bottom: 5px;
    }
    .footer {
      margin-top: 40px;
      padding: 20px 0;
      background: #fff;
      border-top: 1px solid #ddd;
      color: #777;
    }
    .book-link:hover {
      text-decoration: none;
    }
    .social-links a:hover {
      transform: translateY(-2px);
      transition: all 0.3s ease;
    }
  </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark fixed-top" style="background-color: #343a40;">
  <div class="container">
    <a class="navbar-brand" href="index.jsp">📚 图书商城
      <img src="${pageContext.request.contextPath}../include/images/logo.png" width="200" height="60" border="0" />
    </a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarNav">
      <!-- 搜索框 -->
      <form class="form-inline my-2 my-lg-0 ml-auto"
            action="${pageContext.request.contextPath}book/search"
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
              <a class="nav-link" href="${pageContext.request.contextPath}user/profile">
                欢迎，<c:out value="${sessionScope.user.username}"/>
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}order/list">
                我的订单
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}user/logout">
                退出
              </a>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}login.jsp">登录</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}register.jsp">注册</a>
            </li>
          </c:otherwise>
        </c:choose>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}cart/list">
            购物车
            <img src="${pageContext.request.contextPath}../include/images/cart.gif" width="26" height="23" style="margin-bottom:-4px" />
          </a>
        </li>
      </ul>
    </div>
  </div>
</nav>

<!-- 主体内容 -->
<div class="container mt-4">
  <!-- 顶部轮播图，可自行替换图片路径 -->
  <div id="bookCarousel" class="carousel slide" data-ride="carousel">
    <ol class="carousel-indicators">
      <li data-target="#bookCarousel" data-slide-to="0" class="active"></li>
      <li data-target="#bookCarousel" data-slide-to="1"></li>
      <li data-target="#bookCarousel" data-slide-to="2"></li>
    </ol>
    <div class="carousel-inner">
      <!-- 轮播图1 -->
      <div class="carousel-item active">
        <a href="${pageContext.request.contextPath}book/detail?bookId=1">
          <img src="../../images/books/ad/index_ad1.jpg"
               class="d-block w-100" alt="编程入门精选">
        </a>
        <div class="carousel-caption d-none d-md-block">
          <h5>编程入门精选</h5>
          <p>从零开始掌握 Java / Python / 前端基础。</p>
        </div>
      </div>
      <!-- 轮播图2 -->
      <div class="carousel-item">
        <a href="book/list">
          <img src="../../images/books/ad/index_ad2.jpg"
               class="d-block w-100" alt="畅销图书排行">
        </a>
        <div class="carousel-caption d-none d-md-block">
          <h5>畅销图书排行</h5>
          <p>看看大家都在读什么。</p>
        </div>
      </div>
      <!-- 轮播图3 -->
      <div class="carousel-item">
        <a href="book/hot">
          <img src="../../images/books/ad/index_ad3.jpg"
               class="d-block w-100" alt="热卖好书推荐">
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

  <!-- 公告展示区域 -->
  <div class="container mt-4" style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h4 style="color: #3498db; margin: 0;">
        <i class="fas fa-bullhorn"></i> 系统公告
      </h4>
      <a href="${pageContext.request.contextPath}announcementslist" class="btn btn-outline-primary btn-sm">更多公告</a>
    </div>
    <div class="list-group">
      <c:choose>
        <c:when test="${empty announcements}">
          <div class="list-group-item text-center text-muted py-4">
            <i class="fas fa-info-circle fa-2x mb-2"></i>
            <p>暂无公告</p>
          </div>
        </c:when>
        <c:otherwise>
          <c:forEach var="announcement" items="${announcements}">
            <div class="list-group-item list-group-item-action border-left-primary" style="border-left: 4px solid #3498db;">
              <div class="d-flex w-100 justify-content-between">
                <h5 class="mb-1">${announcement.title}</h5>
                <small class="text-muted">
                  <i class="fas fa-calendar-alt"></i>
                  <fmt:formatDate value="${announcement.createdTime}" pattern="yyyy-MM-dd"/>
                </small>
              </div>
              <p class="mb-1">${announcement.content}</p>
              <small class="text-muted">
                <i class="fas fa-clock"></i>
                <fmt:formatDate value="${announcement.createdTime}" pattern="HH:mm"/>
              </small>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <!-- 分类快捷入口 -->
  <div class="section-title d-flex justify-content-between align-items-center">
    <h4>图书分类</h4>
    <a href="book/list" class="btn btn-link">查看全部图书 &raquo;</a>
  </div>
  <div class="category-list mb-3">
    <c:forEach var="cat" items="${categoryList}">
      <a class="btn btn-sm btn-outline-secondary"
         href="${pageContext.request.contextPath}book/category?categoryId=${cat.id}">
        <c:out value="${cat.name}"/>
      </a>
    </c:forEach>
    <c:if test="${empty categoryList}">
      <span class="text-muted">暂未配置分类</span>
    </c:if>
  </div>

  <div class="row">
    <!-- 热卖图书 -->
    <!-- 左侧 - 热卖图书 -->
    <div class="col-md-6">
      <h5 class="section-title d-flex justify-content-between align-items-center">
        <span>热卖图书</span>
        <a href="${pageContext.request.contextPath}book/hot" class="small">
          <img src="${pageContext.request.contextPath}../include/images/hottitle.gif" width="120" height="24" />更多 &raquo;</a>
      </h5>
      <div class="list-group">
        <c:forEach var="book" items="${hotBookList}">
          <div class="book-row mb-3 p-3 border rounded">
            <div class="media">
              <a href="${pageContext.request.contextPath}book/detail?bookId=${book.id}" class="book-link">
                <img class="mr-3 book-img" style="width: 80px; height: 100px;"
                     src="${pageContext.request.contextPath}../include/books/Book-Cover/${book.coverImage}"
                     alt="<c:out value="${book.title}"/>">
              </a>
              <div class="media-body">
                <h6 class="mt-0">
                  <a href="${pageContext.request.contextPath}book/detail?bookId=${book.id}" class="book-link">
                    <c:out value="${book.title}"/>
                  </a>
                </h6>
                <p class="mb-1 text-muted">
                  作者：<c:out value="${book.author}"/>
                </p>
                <a href="${pageContext.request.contextPath}cart/add?bookId=${book.id}"
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
    <div class="col-md-6">
      <h5 class="section-title d-flex justify-content-between align-items-center">
        <span>最新上架</span>
        <a href="${pageContext.request.contextPath}book/new" class="small">更多 &raquo;</a>
      </h5>
      <div class="list-group">
        <c:forEach var="book" items="${newBookList}">
          <div class="book-row mb-3 p-3 border rounded">
            <div class="media">
              <a href="${pageContext.request.contextPath}book/detail?bookId=${book.id}" class="book-link">
                <img class="mr-3 book-img" style="width: 80px; height: 100px;"
                     src="${pageContext.request.contextPath}../include/books/Book-Cover/${book.coverImage}"
                     alt="<c:out value="${book.title}"/>">
              </a>
              <div class="media-body">
                <h6 class="mt-0">
                  <a href="${pageContext.request.contextPath}book/detail?bookId=${book.id}" class="book-link">
                    <c:out value="${book.title}"/>
                  </a>
                </h6>
                <p class="mb-1 text-muted">
                  作者：<c:out value="${book.author}"/>
                </p>
                <a href="${pageContext.request.contextPath}cart/add?bookId=${book.id}"
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
  </div>

  <!-- 推荐图书网格展示（可选） -->
  <div class="row mt-4">
    <div class="col-12">
      <h5 class="section-title">精选图书</h5>
      <div class="row">
        <c:forEach var="book" items="${recommendBookList}">
          <div class="col-md-3 col-sm-4 col-6 book-card">
            <div class="card h-100">
              <a href="${pageContext.request.contextPath}book/detail?bookId=${book.id}" class="book-link">
                <img class="card-img-top book-img"
                     src="${pageContext.request.contextPath}../include/books/Book-Cover/${book.coverImage}"
                     alt="<c:out value="${book.title}"/>">
              </a>
              <div class="card-body">
                <h6 class="card-title text-truncate" title="<c:out value="${book.title}"/>">
                  <a href="${pageContext.request.contextPath}book/detail?bookId=${book.id}" class="book-link">
                    <c:out value="${book.title}"/>
                  </a>
                </h6>
                <p class="card-text mb-1 text-muted">
                  作者：<c:out value="${book.author}"/>
                </p>
              </div>
              <div class="card-footer text-center">
                <a href="${pageContext.request.contextPath}cart/add?bookId=${book.id}"
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
</div>

<!-- 页脚 -->
<footer style="background: linear-gradient(135deg, #2c3e50 0%, #1a2530 100%); color: #ecf0f1; padding: 60px 0 30px; margin-top: 50px; box-shadow: 0 -5px 15px rgba(0,0,0,0.2);">
  <div class="container">
    <div class="row">
      <div class="col-md-4 mb-4">
        <h5 style="color: #3498db; margin-bottom: 20px; font-size: 1.4rem;">
          <i class="fas fa-book-reader"></i> 关于我们
        </h5>
        <p style="line-height: 1.8;">
          提供最好的书籍和最优的购物体验。我们致力于为读者提供丰富多样的图书资源，
          让阅读成为一种享受。
        </p>
        <div class="social-links mt-3">
          <a href="#" style="color: #3498db; margin-right: 15px; font-size: 1.2rem;"><i class="fab fa-facebook"></i></a>
          <a href="#" style="color: #3498db; margin-right: 15px; font-size: 1.2rem;"><i class="fab fa-twitter"></i></a>
          <a href="#" style="color: #3498db; margin-right: 15px; font-size: 1.2rem;"><i class="fab fa-instagram"></i></a>
          <a href="#" style="color: #3498db; font-size: 1.2rem;"><i class="fab fa-weixin"></i></a>
        </div>
      </div>

      <div class="col-md-4 mb-4">
        <h5 style="color: #3498db; margin-bottom: 20px; font-size: 1.4rem;">
          <i class="fas fa-link"></i> 快速链接
        </h5>
        <ul style="list-style: none; padding: 0;">
          <li class="mb-2">
            <a href="${pageContext.request.contextPath}/Jsp/front/book/hot"
               style="color: #bdc3c7; text-decoration: none; transition: all 0.3s;">
              <i class="fas fa-chevron-right mr-2"></i>热卖图书
            </a>
          </li>
          <li class="mb-2">
            <a href="${pageContext.request.contextPath}/Jsp/front/book/category"
               style="color: #bdc3c7; text-decoration: none; transition: all 0.3s;">
              <i class="fas fa-chevron-right mr-2"></i>分类浏览
            </a>
          </li>
          <li class="mb-2">
            <a href="#" style="color: #bdc3c7; text-decoration: none; transition: all 0.3s;">
              <i class="fas fa-chevron-right mr-2"></i>新书上市
            </a>
          </li>
          <li class="mb-2">
            <a href="#" style="color: #bdc3c7; text-decoration: none; transition: all 0.3s;">
              <i class="fas fa-chevron-right mr-2"></i>特价专区
            </a>
          </li>
          <li class="mb-2">
            <a href="#" style="color: #bdc3c7; text-decoration: none; transition: all 0.3s;">
              <i class="fas fa-chevron-right mr-2"></i>客户支持
            </a>
          </li>
        </ul>
      </div>

      <div class="col-md-4 mb-4">
        <h5 style="color: #3498db; margin-bottom: 20px; font-size: 1.4rem;">
          <i class="fas fa-address-book"></i> 联系我们
        </h5>
        <ul style="list-style: none; padding: 0;">
          <li class="mb-3">
            <i class="fas fa-map-marker-alt mr-2" style="color: #e74c3c;"></i>
            北京市朝阳区图书大厦123号
          </li>
          <li class="mb-3">
            <i class="fas fa-envelope mr-2" style="color: #e74c3c;"></i>
            support@bookshop.com
          </li>
          <li class="mb-3">
            <i class="fas fa-phone mr-2" style="color: #e74c3c;"></i>
            400-888-8888
          </li>
          <li class="mb-3">
            <i class="fas fa-clock mr-2" style="color: #e74c3c;"></i>
            周一至周日 9:00-21:00
          </li>
        </ul>

        <div class="newsletter mt-4">
          <h6 style="color: #3498db;">订阅我们的资讯</h6>
          <div class="input-group mt-2">
            <input type="email" class="form-control" placeholder="您的邮箱地址"
                   style="border-radius: 20px 0 0 20px; border: none;">
            <div class="input-group-append">
              <button class="btn btn-primary" type="button"
                      style="border-radius: 0 20px 20px 0; background: #e74c3c; border: none;">
                <i class="fas fa-paper-plane"></i>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <hr style="border-color: #34495e; margin: 30px 0;">

    <div class="row">
      <div class="col-md-6 text-center text-md-left">
        <p style="margin: 0;">&copy; 2024 图书商城. 版权所有。</p>
      </div>
      <div class="col-md-6 text-center text-md-right">
        <ul style="list-style: none; padding: 0; margin: 0;">
          <li style="display: inline-block; margin-left: 20px;">
            <a href="#" style="color: #bdc3c7; text-decoration: none;">隐私政策</a>
          </li>
          <li style="display: inline-block; margin-left: 20px;">
            <a href="#" style="color: #bdc3c7; text-decoration: none;">服务条款</a>
          </li>
          <li style="display: inline-block; margin-left: 20px;">
            <a href="#" style="color: #bdc3c7; text-decoration: none;">网站地图</a>
          </li>
        </ul>
      </div>
    </div>
  </div>
</footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
