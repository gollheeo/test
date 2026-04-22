<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
%>

<footer class="footer-modern">
    <div class="container front-container">
        <div class="row">
            <div class="col-lg-4 mb-4">
                <div class="footer-brand-title">
                    <span class="brand-mark"><i class="fas fa-book-reader"></i></span>
                    <span>BookShop 图书管理系统</span>
                </div>
                <p class="mt-3 mb-0">
                    把传统图书管理系统升级为更现代的线上书店体验，兼顾图书展示、检索、下单与后台管理，让每一本书都更容易被发现。
                </p>
                <div class="footer-social">
                    <a href="#" aria-label="微信"><i class="fab fa-weixin"></i></a>
                    <a href="#" aria-label="微博"><i class="fab fa-weibo"></i></a>
                    <a href="#" aria-label="GitHub"><i class="fab fa-github"></i></a>
                </div>
            </div>

            <div class="col-md-4 col-lg-2 mb-4">
                <h5 class="footer-title">快速访问</h5>
                <ul class="footer-links">
                    <li><a href="<%= ctx %>/Jsp/front/index.jsp">首页</a></li>
                    <li><a href="<%= ctx %>/Jsp/front/book/list">全部图书</a></li>
                    <li><a href="<%= ctx %>/Jsp/front/book/new">新书上架</a></li>
                    <li><a href="<%= ctx %>/Jsp/front/book/hot">热销推荐</a></li>
                </ul>
            </div>

            <div class="col-md-4 col-lg-2 mb-4">
                <h5 class="footer-title">我的服务</h5>
                <ul class="footer-links">
                    <li><a href="<%= ctx %>/Jsp/front/cart/list">购物车</a></li>
                    <li><a href="<%= ctx %>/Jsp/front/order/list">订单中心</a></li>
                    <li><a href="<%= ctx %>/Jsp/front/user/profile">个人资料</a></li>
                    <li><a href="<%= ctx %>/Jsp/front/announcementslist">系统公告</a></li>
                </ul>
            </div>

            <div class="col-md-4 col-lg-4 mb-4">
                <h5 class="footer-title">联系与支持</h5>
                <p class="mb-2"><i class="fas fa-map-marker-alt mr-2"></i>北京市朝阳区科技园路 88 号</p>
                <p class="mb-2"><i class="fas fa-envelope mr-2"></i>support@bookshop.com</p>
                <p class="mb-3"><i class="fas fa-phone-alt mr-2"></i>400-888-8888</p>
                <small>工作日 09:00 - 18:00 提供在线支持与后台运维协助。</small>
            </div>
        </div>

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center pt-4 mt-3" style="border-top: 1px solid rgba(255, 255, 255, 0.12);">
            <small>© 2026 BookShop. 保留所有权利。</small>
            <small class="mt-2 mt-md-0">适用于图书展示、库存管理、订单处理与用户运营。</small>
        </div>
    </div>
</footer>
