<%@ page import="com.exam.model.Admin" %>
<%
    Admin currentAdmin = (Admin) session.getAttribute("admin");
    if (currentAdmin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?type=admin");
        return;
    }
%>
<nav class="navbar navbar-expand-lg navbar-dark navbar-premium fixed-top py-3">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="<%= request.getContextPath() %>/admin/dashboard">
            <i class="fa-solid fa-user-shield me-2 text-glow-purple" style="color: var(--accent-purple);"></i>
            <span class="fw-bold">Admin Portal</span>
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                <li class="nav-item">
                    <a class="nav-link text-white fw-medium px-2" href="<%= request.getContextPath() %>/admin/dashboard">
                        <i class="fa-solid fa-chart-line me-1" style="color: var(--accent-purple);"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white fw-medium px-2" href="<%= request.getContextPath() %>/admin/students">
                        <i class="fa-solid fa-users me-1" style="color: var(--accent-blue);"></i>Students
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white fw-medium px-2" href="<%= request.getContextPath() %>/admin/subjects">
                        <i class="fa-solid fa-tags me-1" style="color: var(--accent-cyan);"></i>Subjects
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white fw-medium px-2" href="<%= request.getContextPath() %>/admin/exams">
                        <i class="fa-solid fa-file-signature me-1" style="color: var(--accent-emerald);"></i>Exams
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white fw-medium px-2" href="<%= request.getContextPath() %>/admin/questions">
                        <i class="fa-solid fa-clipboard-question me-1" style="color: var(--accent-rose);"></i>Questions
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white fw-medium px-2" href="<%= request.getContextPath() %>/admin/results">
                        <i class="fa-solid fa-square-poll-vertical me-1" style="color: var(--accent-blue);"></i>Results
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white fw-medium px-2" href="<%= request.getContextPath() %>/admin/logs">
                        <i class="fa-solid fa-list-check me-1" style="color: var(--text-secondary);"></i>Logs
                    </a>
                </li>
            </ul>
            <div class="d-flex align-items-center gap-3">
                <span class="text-secondary small d-none d-lg-inline">
                    Admin: <strong class="text-white"><%= currentAdmin.getUsername() %></strong>
                </span>
                <a href="<%= request.getContextPath() %>/logout" class="btn-premium py-1 px-3" style="background: linear-gradient(135deg, var(--accent-rose), #dc2626); box-shadow: 0 4px 15px rgba(244, 63, 94, 0.35);">
                    Logout <i class="fa-solid fa-right-from-bracket ms-1"></i>
                </a>
            </div>
        </div>
    </div>
</nav>
<div style="height: 90px;"></div> <!-- Spacer for fixed-top navbar -->
