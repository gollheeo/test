<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>注册账号 - BookShop</title>
    <jsp:include page="common/style.jsp"/>
</head>
<body class="auth-page">
<%
    String ctx = request.getContextPath();
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>

<main class="container front-container auth-shell">
    <section class="auth-showcase">
        <span class="eyebrow text-white">Create Account</span>
        <h1 class="serif-title">创建一个更完整的读者账号</h1>
        <p>
            注册页重新整理了表单层级，把必填项、可选项和操作引导拆分得更清楚，
            让第一次使用系统的用户更容易理解下一步该做什么。
        </p>

        <div class="auth-points">
            <div class="auth-point">
                <strong>主次字段分层</strong>
                <div>用户名、邮箱和密码放在首屏核心区域，可选信息则保留但不打断主流程。</div>
            </div>
            <div class="auth-point">
                <strong>更强的可信感</strong>
                <div>使用与首页一致的排版、色彩和间距，让注册页更像产品的一部分。</div>
            </div>
            <div class="auth-point">
                <strong>保留现有接口</strong>
                <div>表单仍然提交到你当前的用户控制器，不影响后端逻辑。</div>
            </div>
        </div>
    </section>

    <section class="auth-card">
        <span class="eyebrow">Register</span>
        <h2>创建账号</h2>
        <p class="mb-4">完成注册后即可登录系统，使用图书浏览、购物车和订单功能。</p>

        <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle mr-2"></i><%= error %></div>
        <% } %>
        <% if (success != null && !success.isEmpty()) { %>
        <div class="alert alert-success"><i class="fas fa-check-circle mr-2"></i><%= success %></div>
        <% } %>

        <form class="auth-form" method="post" action="<%= ctx %>/Jsp/front/user/register" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="username">用户名</label>
                <div class="input-group">
                    <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                    </div>
                    <input type="text" class="form-control" id="username" name="username" required minlength="3" maxlength="20" placeholder="3-20 位字符，支持字母和数字">
                </div>
                <div class="helper-text mt-2">建议使用容易识别的名称，方便后台管理和订单沟通。</div>
            </div>

            <div class="form-group">
                <label for="email">邮箱地址</label>
                <div class="input-group">
                    <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                    </div>
                    <input type="email" class="form-control" id="email" name="email" required placeholder="example@email.com">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group col-md-6">
                    <label for="password">设置密码</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                        </div>
                        <input type="password" class="form-control" id="password" name="password" required minlength="6" placeholder="至少 6 位">
                    </div>
                </div>
                <div class="form-group col-md-6">
                    <label for="confirmPassword">确认密码</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="fas fa-check-circle"></i></span>
                        </div>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required placeholder="再次输入密码">
                    </div>
                </div>
            </div>

            <div class="helper-text mb-3">以下信息可选，但填写后能帮助后续下单与联系。</div>

            <div class="form-group">
                <label for="phone">联系电话</label>
                <div class="input-group">
                    <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fas fa-phone"></i></span>
                    </div>
                    <input type="tel" class="form-control" id="phone" name="phone" placeholder="可选">
                </div>
            </div>

            <div class="form-group">
                <label for="address">收货地址</label>
                <div class="input-group">
                    <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fas fa-map-marker-alt"></i></span>
                    </div>
                    <input type="text" class="form-control" id="address" name="address" placeholder="可选">
                </div>
            </div>

            <button type="submit" class="btn btn-brand btn-block mt-4">
                <i class="fas fa-user-plus"></i> 立即注册
            </button>
        </form>

        <div class="account-hint">
            <strong class="d-block mb-2">已经有账号？</strong>
            <div class="helper-text mb-3">直接登录即可继续浏览图书、管理订单或进入后台。</div>
            <div class="d-flex flex-wrap">
                <a class="btn btn-soft mr-2 mb-2" href="<%= ctx %>/Jsp/front/login.jsp">去登录</a>
                <a class="btn btn-soft mb-2" href="<%= ctx %>/Jsp/front/index.jsp">返回首页</a>
            </div>
        </div>
    </section>
</main>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function validateForm() {
        var password = document.getElementById("password").value;
        var confirmPassword = document.getElementById("confirmPassword").value;

        if (password !== confirmPassword) {
            alert("两次输入的密码不一致，请重新确认。");
            document.getElementById("confirmPassword").focus();
            return false;
        }

        if (password.length < 6) {
            alert("为了账号安全，密码长度至少需要 6 位。");
            return false;
        }

        return true;
    }
</script>
</body>
</html>
