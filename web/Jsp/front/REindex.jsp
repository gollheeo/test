<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctx = request.getContextPath();
    String coverBase = ctx + "/Jsp/include/books/Book-Cover/";
    List<?> recommendBookList = (List<?>) request.getAttribute("recommendBookList");
    List<?> hotBookList = (List<?>) request.getAttribute("hotBookList");
    List<?> newBookList = (List<?>) request.getAttribute("newBookList");
    List<?> categoryList = (List<?>) request.getAttribute("categoryList");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BookShop 图书管理系统</title>
    <jsp:include page="common/style.jsp"/>
</head>
<body class="front-page">
<jsp:include page="common/nav.jsp"/>

<main class="container front-container pb-5">
    <section class="hero-summary surface-card mt-4">
        <span class="eyebrow">Curated Book Experience</span>
        <h1>把图书管理系统做成更专业、更好逛的线上书店首页</h1>
        <p>
            首页围绕“快速检索、重点推荐、公告提醒、分类进入”四个核心任务重新组织，
            让访客第一眼就能找到书、看到重点、快速进入后台业务流程。
        </p>

        <div class="hero-actions">
            <a class="btn btn-brand" href="<%= ctx %>/Jsp/front/book/list">
                <i class="fas fa-compass"></i> 浏览全部图书
            </a>
            <a class="btn btn-soft" href="<%= ctx %>/Jsp/front/book/new">
                <i class="fas fa-sparkles"></i> 查看新书上架
            </a>
        </div>

        <div class="hero-metrics">
            <div class="metric-pill">
                <strong><%= recommendBookList != null ? recommendBookList.size() : 0 %>+</strong>
                <span>精选推荐</span>
            </div>
            <div class="metric-pill">
                <strong><%= hotBookList != null ? hotBookList.size() : 0 %>+</strong>
                <span>热销榜单</span>
            </div>
            <div class="metric-pill">
                <strong><%= newBookList != null ? newBookList.size() : 0 %>+</strong>
                <span>近期上新</span>
            </div>
            <div class="metric-pill">
                <strong><%= categoryList != null ? categoryList.size() : 0 %></strong>
                <span>图书分类</span>
            </div>
        </div>

        <c:if test="${not empty param.success}">
            <div class="inline-alert success"><c:out value="${param.success}"/></div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="inline-alert error"><c:out value="${param.error}"/></div>
        </c:if>
    </section>

    <section class="hero-layout">
        <div class="surface-card hero-carousel-card">
            <div class="card-header-row mb-4">
                <div>
                    <h3>本周重点推荐</h3>
                    <p>用更强的封面展示和文案层级提升图书曝光效率。</p>
                </div>
                <a class="link-more" href="<%= ctx %>/Jsp/front/book/hot">查看热销榜</a>
            </div>

            <div id="bookCarousel" class="carousel slide hero-carousel" data-ride="carousel">
                <ol class="carousel-indicators">
                    <li data-target="#bookCarousel" data-slide-to="0" class="active"></li>
                    <li data-target="#bookCarousel" data-slide-to="1"></li>
                    <li data-target="#bookCarousel" data-slide-to="2"></li>
                </ol>
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <a href="<%= ctx %>/Jsp/front/book/detail?bookId=1">
                            <img src="<%= ctx %>/images/books/ad/index_ad1.jpg" alt="编程入门精选">
                        </a>
                        <div class="carousel-caption">
                            <h5>编程入门精选</h5>
                            <p class="mb-0">从 Java、Python 到前端基础，用一组更清晰的入口覆盖新读者。</p>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <a href="<%= ctx %>/Jsp/front/book/list">
                            <img src="<%= ctx %>/images/books/ad/index_ad2.jpg" alt="本月热门书单">
                        </a>
                        <div class="carousel-caption">
                            <h5>本月热门书单</h5>
                            <p class="mb-0">技术图书、实战手册与课程配套教材集中展示，更适合书店首页的转化逻辑。</p>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <a href="<%= ctx %>/Jsp/front/book/new">
                            <img src="<%= ctx %>/images/books/ad/index_ad3.jpg" alt="新书上架">
                        </a>
                        <div class="carousel-caption">
                            <h5>新书上架</h5>
                            <p class="mb-0">通过更明确的导航与视觉强调，让“最新到店”成为可持续运营的位置。</p>
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
        </div>

        <div class="hero-aside">
            <div class="surface-card hero-aside-card">
                <div class="card-header-row">
                    <div>
                        <h3>系统公告</h3>
                        <p>最近通知与活动更新</p>
                    </div>
                    <a class="link-more" href="<%= ctx %>/Jsp/front/announcementslist">全部公告</a>
                </div>

                <div class="notice-list">
                    <c:choose>
                        <c:when test="${empty announcements}">
                            <div class="notice-item">
                                <h6>暂无公告</h6>
                                <p>当前没有新的系统通知，后续发布后会在这里展示。</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="announcement" items="${announcements}" end="2">
                                <div class="notice-item">
                                    <h6><c:out value="${announcement.title}"/></h6>
                                    <p><c:out value="${announcement.content}"/></p>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="surface-card hero-aside-card">
                <div class="card-header-row">
                    <div>
                        <h3>热门分类</h3>
                        <p>更适合移动端与桌面端的快速入口</p>
                    </div>
                </div>

                <div class="category-cloud">
                    <c:choose>
                        <c:when test="${empty categoryList}">
                            <span class="text-muted">暂无分类数据</span>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="cat" items="${categoryList}">
                                <a class="category-chip" href="<%= ctx %>/Jsp/front/book/category?categoryId=${cat.id}">
                                    <i class="fas fa-bookmark"></i>
                                    <c:out value="${cat.name}"/>
                                </a>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </section>

    <section class="section-block">
        <div class="row">
            <div class="col-lg-6 mb-4">
                <div class="section-panel surface-card h-100">
                    <div class="section-heading">
                        <div>
                            <h2>热销图书</h2>
                            <p>适合首页快速浏览与加购的横向信息卡。</p>
                        </div>
                        <a class="link-more" href="<%= ctx %>/Jsp/front/book/hot">查看更多</a>
                    </div>

                    <div class="book-list-stack">
                        <c:forEach var="book" items="${hotBookList}">
                            <div class="book-strip">
                                <a href="<%= ctx %>/Jsp/front/book/detail?bookId=${book.id}">
                                    <img class="book-cover" src="<%= coverBase %>${book.coverImage}" alt="${book.title}">
                                </a>
                                <div class="book-strip-body">
                                    <div class="d-flex justify-content-between align-items-start flex-wrap">
                                        <div class="pr-3">
                                            <h5 class="mb-2">
                                                <a href="<%= ctx %>/Jsp/front/book/detail?bookId=${book.id}">
                                                    <c:out value="${book.title}"/>
                                                </a>
                                            </h5>
                                            <p><c:out value="${book.author}"/></p>
                                        </div>
                                        <span class="badge-soft hot">热销推荐</span>
                                    </div>
                                    <div class="meta-row">
                                        <span><i class="fas fa-fire-alt mr-1"></i>高转化展示位</span>
                                        <span><i class="fas fa-truck mr-1"></i>支持快速下单</span>
                                    </div>
                                </div>
                                <a class="btn btn-soft" href="<%= ctx %>/Jsp/front/cart/add?bookId=${book.id}">
                                    <i class="fas fa-cart-plus"></i> 加购
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="col-lg-6 mb-4">
                <div class="section-panel surface-card h-100">
                    <div class="section-heading">
                        <div>
                            <h2>最新上架</h2>
                            <p>把“新书”做成独立入口，增强内容更新感。</p>
                        </div>
                        <a class="link-more" href="<%= ctx %>/Jsp/front/book/new">查看全部</a>
                    </div>

                    <div class="book-list-stack">
                        <c:forEach var="book" items="${newBookList}">
                            <div class="book-strip">
                                <a href="<%= ctx %>/Jsp/front/book/detail?bookId=${book.id}">
                                    <img class="book-cover" src="<%= coverBase %>${book.coverImage}" alt="${book.title}">
                                </a>
                                <div class="book-strip-body">
                                    <div class="d-flex justify-content-between align-items-start flex-wrap">
                                        <div class="pr-3">
                                            <h5 class="mb-2">
                                                <a href="<%= ctx %>/Jsp/front/book/detail?bookId=${book.id}">
                                                    <c:out value="${book.title}"/>
                                                </a>
                                            </h5>
                                            <p><c:out value="${book.author}"/></p>
                                        </div>
                                        <span class="badge-soft new">新品</span>
                                    </div>
                                    <div class="meta-row">
                                        <span><i class="fas fa-clock mr-1"></i>最近上架</span>
                                        <span><i class="fas fa-lightbulb mr-1"></i>便于首页运营</span>
                                    </div>
                                </div>
                                <a class="btn btn-soft" href="<%= ctx %>/Jsp/front/cart/add?bookId=${book.id}">
                                    <i class="fas fa-cart-plus"></i> 加购
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="section-block">
        <div class="section-heading">
            <div>
                <h2>编辑精选</h2>
                <p>统一卡片比例、封面阴影和价格层级，页面会更完整也更高级。</p>
            </div>
            <a class="link-more" href="<%= ctx %>/Jsp/front/book/list">进入书库</a>
        </div>

        <div class="feature-grid">
            <c:forEach var="book" items="${recommendBookList}">
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
                    <p class="mb-0"><c:out value="${book.author}"/></p>
                    <div class="price-row">
                        <span class="price-current">精品推荐</span>
                        <span class="price-old">首页重点展示位</span>
                    </div>
                    <a class="btn btn-brand btn-block" href="<%= ctx %>/Jsp/front/cart/add?bookId=${book.id}">
                        <i class="fas fa-shopping-bag"></i> 加入购物车
                    </a>
                </div>
            </c:forEach>
        </div>
    </section>
</main>

<jsp:include page="common/footer.jsp"/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
