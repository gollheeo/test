<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.List, com.bookshop.model.Announcement, com.bookshop.service.AnnouncementService" %>
<%
  AnnouncementService announcementService = new AnnouncementService();
  List<Announcement> announcements = (List<Announcement>) request.getAttribute("announcements");
  if (announcements == null) { announcements = announcementService.getAllAnnouncements(); }
%>
<html>
<head>
  <meta charset="UTF-8">
  <title>系统公告</title>
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
    .announcement-card {
      background: white; border: none; border-radius: 16px;
      padding: 25px; margin-bottom: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.03);
      transition: transform 0.2s; position: relative; overflow: hidden;
    }
    .announcement-card:hover { transform: translateY(-3px); box-shadow: 0 8px 25px rgba(0,0,0,0.08); }
    .announcement-card::before {
      content: ''; position: absolute; left: 0; top: 0; bottom: 0; width: 5px;
      background: linear-gradient(to bottom, #4a90e2, #a29bfe);
    }
    .meta-info { font-size: 0.85rem; color: #b2bec3; }
  </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light fixed-top">
  <div class="container">
    <a class="navbar-brand font-weight-bold" href="index.jsp">📚 图书商城</a>
    <a class="nav-link ml-auto" href="index.jsp">返回首页</a>
  </div>
</nav>

<div class="container mt-4">
  <h3 class="mb-4 font-weight-bold text-center">系统公告</h3>

  <div class="row justify-content-center">
    <div class="col-lg-8">
      <c:choose>
        <c:when test="${empty announcements}">
          <div class="text-center py-5 text-muted">
            <i class="far fa-bell-slash fa-3x mb-3"></i>
            <p>暂无任何公告</p>
          </div>
        </c:when>
        <c:otherwise>
          <c:forEach var="announcement" items="${announcements}">
            <div class="announcement-card">
              <h5 class="font-weight-bold mb-2" style="color: #2d3436;">
                <c:out value="${announcement.title}" default="无标题" />
              </h5>
              <div class="meta-info mb-3">
                <i class="far fa-clock mr-1"></i>
                <fmt:formatDate value="${announcement.createdTime}" pattern="yyyy年MM月dd日 HH:mm"/>
              </div>
              <div class="text-secondary" style="line-height: 1.6;">
                <c:out value="${announcement.content}" default="无内容" />
              </div>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>
</body>
</html>
