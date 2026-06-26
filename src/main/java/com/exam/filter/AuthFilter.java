package com.exam.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        // Allow static resources or index page
        if (path.startsWith("/assets/") || path.equals("/") || path.equals("/index.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        boolean loggedInStudent = (session != null && session.getAttribute("student") != null);
        boolean loggedInAdmin = (session != null && session.getAttribute("admin") != null);

        if (path.startsWith("/admin")) {
            if (loggedInAdmin) {
                chain.doFilter(request, response);
            } else {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?type=admin&error=session_expired");
            }
        } else if (path.startsWith("/student") || path.startsWith("/exam")) {
            if (loggedInStudent) {
                chain.doFilter(request, response);
            } else {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?type=student&error=session_expired");
            }
        } else {
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {}
}
