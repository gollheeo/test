//package com.bookshop.filter;
//
//import com.bookshop.model.User;
//
//import javax.servlet.*;
//import javax.servlet.annotation.WebFilter;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//import java.io.IOException;
//import java.net.URLEncoder;
//
///**
// * 登录拦截过滤器：
// * - 允许访问首页、登录/注册页面及其接口、静态资源
// * - 其余请求必须先登录
// */
//@WebFilter("/*")
//public class AuthFilter implements Filter {
//
//    @Override
//    public void init(FilterConfig filterConfig) throws ServletException {
//        // 可选：初始化时打印日志
//        System.out.println("AuthFilter 初始化完成");
//    }
//
//    @Override
//    public void doFilter(ServletRequest request, ServletResponse response,
//                         FilterChain chain) throws IOException, ServletException {
//
//        HttpServletRequest req = (HttpServletRequest) request;
//        HttpServletResponse resp = (HttpServletResponse) response;
//
//        req.setCharacterEncoding("UTF-8");
//        resp.setCharacterEncoding("UTF-8");
//
//        String contextPath = req.getContextPath();      // 如：/Jsp/front
//        String uri = req.getRequestURI();               // 完整路径
//        String path = uri.substring(contextPath.length()); // 去掉 contextPath 后的部分
//
//        // 1. 放行无需登录的路径
//        if (isPublicPath(path)) {
//            chain.doFilter(request, response);
//            return;
//        }
//
//        // 2. 其余路径检查是否已登录
//        HttpSession session = req.getSession(false);
//        User user = (session == null) ? null : (User) session.getAttribute("user");
//
//        if (user != null) {
//            // 已登录，放行
//            chain.doFilter(request, response);
//        } else {
//            // 未登录，重定向到登录页，并带上提示
//            String msg = URLEncoder.encode("请先登录后再进行操作", "UTF-8");
//            resp.sendRedirect(contextPath + "/Jsp/front/login.jsp?error=" + msg);
//        }
//    }
//
//    @Override
//    public void destroy() {
//        System.out.println("AuthFilter 已销毁");
//    }
//
//    /**
//     * 判断是否为无需登录即可访问的路径
//     */
//    private boolean isPublicPath(String path) {
//        // 首页
//        if ("/".equals(path) || "/Jsp/front/".equals(path)) {
//            return true;
//        }
//
//        // 登录、注册页面
//        if ("/Jsp/front/login.jsp".equals(path) || "/Jsp/front/register.jsp".equals(path)) {
//            return true;
//        }
//
//        // 登录、注册接口（与你的 UserController 中的 @WebServlet("/user/*") 对应）
//        if (path.startsWith("/Jsp/front/user/login") || path.startsWith("/Jsp/front/user/register")) {
//            return true;
//        }
//
//        // 静态资源（根据你的项目结构调整）
//        if (path.startsWith("/css/")
//                || path.startsWith("/js/")
//                || path.startsWith("/images/")
//                || path.startsWith("/fonts/")
//                || path.endsWith(".png")
//                || path.endsWith(".jpg")
//                || path.endsWith(".jpeg")
//                || path.endsWith(".gif")
//                || path.endsWith(".ico")) {
//            return true;
//        }
//
//        // 其他默认需要登录
//        return false;
//    }
//}
