<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bookshop.model.User" %>
<%@ page import="com.bookshop.model.Announcement, com.bookshop.service.AnnouncementService, java.util.List, java.text.SimpleDateFormat" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        String msg = java.net.URLEncoder.encode("需要管理员权限", StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + "/Jsp/front/login.jsp?error=" + msg);
        return;
    }

    AnnouncementService announcementService = new AnnouncementService();
    List<Announcement> announcements = (List<Announcement>) request.getAttribute("announcements");
    if (announcements == null) announcements = announcementService.getAllAnnouncements();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    String error = request.getParameter("error");
    String success = request.getParameter("success");
    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公告管理 - BookShop</title>
    <jsp:include page="../front/common/style.jsp"/>
</head>
<body class="admin-page">
<div class="admin-shell">
    <aside class="admin-sidebar">
        <div class="admin-brand">
            <span class="brand-mark"><i class="fas fa-layer-group"></i></span>
            <span>
                <strong>BookShop Admin</strong>
                <small>图书管理后台</small>
            </span>
        </div>

        <nav class="admin-nav">
            <a class="admin-nav-link" href="<%= ctx %>/admin/dashboard"><i class="fas fa-chart-pie"></i>仪表盘</a>
            <a class="admin-nav-link" href="<%= ctx %>/admin/books"><i class="fas fa-book"></i>图书管理</a>
            <a class="admin-nav-link active" href="<%= ctx %>/admin/announcements"><i class="fas fa-bullhorn"></i>公告管理</a>
            <a class="admin-nav-link" href="<%= ctx %>/admin/orders"><i class="fas fa-shopping-bag"></i>订单管理</a>
            <a class="admin-nav-link" href="<%= ctx %>/admin/users"><i class="fas fa-users"></i>用户管理</a>
        </nav>

        <div class="admin-sidebar-footer">
            <a class="admin-nav-link" href="<%= ctx %>/Jsp/front/index.jsp"><i class="fas fa-arrow-left"></i>返回前台</a>
            <a class="admin-nav-link" href="<%= ctx %>/Jsp/front/user/logout"><i class="fas fa-sign-out-alt"></i>退出登录</a>
        </div>
    </aside>

    <main class="admin-main">
        <section class="admin-topbar">
            <div>
                <span class="eyebrow">Announcements</span>
                <h1>公告管理</h1>
                <p>公告页改成更适合阅读的卡片流布局，发布时间、编辑入口与删除动作都更容易识别。</p>
            </div>
            <button class="btn btn-brand" data-toggle="modal" data-target="#addAnnouncementModal">
                <i class="fas fa-plus"></i> 发布公告
            </button>
        </section>

        <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-danger mb-4"><i class="fas fa-exclamation-circle mr-2"></i><%= error %></div>
        <% } %>
        <% if (success != null && !success.isEmpty()) { %>
        <div class="alert alert-success mb-4"><i class="fas fa-check-circle mr-2"></i><%= success %></div>
        <% } %>

        <section class="admin-panel">
            <div class="card-header-row mb-4">
                <div>
                    <h3>已发布公告</h3>
                    <p class="admin-panel-subtitle mb-0">当前采用更醒目的标题层级和更轻的卡片底色，阅读效率会更好。</p>
                </div>
                <span class="admin-chip"><i class="fas fa-bell"></i> 前台首页同步展示</span>
            </div>

            <% if (announcements != null && !announcements.isEmpty()) {
                for (Announcement a : announcements) { %>
            <div class="announcement-block">
                <div class="d-flex justify-content-between align-items-start flex-wrap">
                    <div class="pr-3">
                        <h4 class="mb-2"><%= a.getTitle() %></h4>
                        <p class="mb-2 text-muted"><%= a.getContent() %></p>
                        <div class="announcement-meta"><i class="far fa-clock mr-1"></i><%= a.getCreatedTime() != null ? sdf.format(a.getCreatedTime()) : "-" %></div>
                    </div>
                    <div class="mt-2 mt-md-0">
                        <button class="icon-btn" type="button" onclick="editAnnouncement(<%= a.getId() %>, '<%= a.getTitle().replace("'", "\\'") %>', '<%= a.getContent().replace("'", "\\'").replace("\n", "\\n") %>')">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="icon-btn ml-2" type="button" onclick="deleteAnnouncement(<%= a.getId() %>, '<%= a.getTitle().replace("'", "\\'") %>')">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                    </div>
                </div>
            </div>
            <% } } else { %>
            <div class="data-empty">
                <i class="fas fa-bullhorn fa-3x"></i>
                当前没有公告内容。
            </div>
            <% } %>
        </section>
    </main>
</div>

<div class="modal fade" id="addAnnouncementModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <div>
                    <h5 class="mb-1">发布公告</h5>
                    <small class="text-muted">发布后可在首页公告卡片中展示。</small>
                </div>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <form method="post" action="<%= ctx %>/admin/announcement/add">
                <div class="modal-body">
                    <div class="form-group">
                        <label>标题</label>
                        <input type="text" name="title" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>内容</label>
                        <textarea name="content" class="form-control" rows="5" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-soft" data-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-brand">立即发布</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="editAnnouncementModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <div>
                    <h5 class="mb-1">编辑公告</h5>
                    <small class="text-muted">保持原有更新接口，仅更新展示方式。</small>
                </div>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <form method="post" action="<%= ctx %>/admin/announcement/update">
                <div class="modal-body">
                    <input type="hidden" id="editId" name="id">
                    <div class="form-group">
                        <label>标题</label>
                        <input type="text" id="editTitle" name="title" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>内容</label>
                        <textarea id="editContent" name="content" class="form-control" rows="5" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-soft" data-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-brand">保存修改</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editAnnouncement(id, title, content) {
        $('#editId').val(id);
        $('#editTitle').val(title);
        $('#editContent').val(content);
        $('#editAnnouncementModal').modal('show');
    }

    function deleteAnnouncement(id, title) {
        if (!confirm('确定删除公告“' + title + '”吗？')) {
            return;
        }

        var form = document.createElement('form');
        form.method = 'post';
        form.action = '<%= ctx %>/admin/announcement/delete';

        var input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'id';
        input.value = id;
        form.appendChild(input);

        document.body.appendChild(form);
        form.submit();
    }
</script>
</body>
</html>
