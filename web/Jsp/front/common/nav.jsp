<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctx = request.getContextPath();
    String requestUri = request.getRequestURI();
    boolean homeActive = requestUri.endsWith("/index.jsp") || requestUri.endsWith("/index");
    boolean listActive = requestUri.contains("/book/list");
    boolean newActive = requestUri.contains("/book/new");
    boolean hotActive = requestUri.contains("/book/hot");
%>

<nav class="navbar navbar-expand-lg front-navbar">
    <div class="container front-container">
        <a class="navbar-brand front-brand" href="<%= ctx %>/Jsp/front/index.jsp">
            <span class="brand-mark"><i class="fas fa-book-open"></i></span>
            <span class="brand-copy">
                <strong>BookShop</strong>
                <small>Library Console</small>
            </span>
        </a>

        <button class="navbar-toggler border-0 shadow-none" type="button" data-toggle="collapse" data-target="#frontNavbar">
            <span><i class="fas fa-bars"></i></span>
        </button>

        <div class="collapse navbar-collapse" id="frontNavbar">
            <ul class="navbar-nav ml-4">
                <li class="nav-item">
                    <a class="nav-link front-nav-link <%= homeActive ? "current" : "" %>" href="<%= ctx %>/Jsp/front/index.jsp">首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link front-nav-link <%= listActive ? "current" : "" %>" href="<%= ctx %>/Jsp/front/book/list">全部图书</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link front-nav-link <%= newActive ? "current" : "" %>" href="<%= ctx %>/Jsp/front/book/new">新书上架</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link front-nav-link <%= hotActive ? "current" : "" %>" href="<%= ctx %>/Jsp/front/book/hot">热销推荐</a>
                </li>
            </ul>

            <form class="front-search ml-lg-auto mt-3 mt-lg-0" action="<%= ctx %>/Jsp/front/book/search" method="get">
                <div class="search-shell">
                    <input class="form-control" type="search" name="keyword" placeholder="搜索书名、作者或 ISBN" value="${param.keyword}">
                    <button class="btn btn-brand" type="submit" aria-label="搜索">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </form>

            <ul class="navbar-nav ml-lg-3 mt-3 mt-lg-0 align-items-lg-center">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item dropdown">
                            <a class="nav-link front-nav-link dropdown-toggle" href="#" data-toggle="dropdown">
                                <i class="fas fa-user-circle mr-1"></i>
                                <c:out value="${sessionScope.user.username}"/>
                            </a>
                            <div class="dropdown-menu dropdown-menu-right border-0 shadow-sm" style="border-radius: 18px;">
                                <a class="dropdown-item" href="<%= ctx %>/Jsp/front/user/profile">个人中心</a>
                                <a class="dropdown-item" href="<%= ctx %>/Jsp/front/order/list">我的订单</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item text-danger" href="<%= ctx %>/Jsp/front/user/logout">退出登录</a>
                            </div>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link front-nav-link" href="<%= ctx %>/Jsp/front/login.jsp">登录</a>
                        </li>
                        <li class="nav-item ml-lg-2">
                            <a class="btn btn-soft" href="<%= ctx %>/Jsp/front/register.jsp">注册账号</a>
                        </li>
                    </c:otherwise>
                </c:choose>
                <li class="nav-item ml-lg-2">
                    <a class="btn btn-soft" href="<%= ctx %>/Jsp/front/cart/list">
                        <i class="fas fa-shopping-bag"></i>
                        购物车
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>
