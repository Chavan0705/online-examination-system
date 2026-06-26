<%@ page import="com.exam.model.Student" %>
<%
    Student currentStudent = (Student) session.getAttribute("student");
    if (currentStudent == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?type=student");
        return;
    }
%>
<nav class="navbar navbar-expand-lg navbar-dark navbar-premium fixed-top py-3">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="<%= request.getContextPath() %>/student/dashboard">
            <i class="fa-solid fa-graduation-cap me-2 text-glow-purple" style="color: var(--accent-purple);"></i>
            <span class="fw-bold">Student Portal</span>
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#studentNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="studentNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                <li class="nav-item">
                    <a class="nav-link text-white fw-medium px-3" href="<%= request.getContextPath() %>/student/dashboard">
                        <i class="fa-solid fa-house me-2" style="color: var(--accent-blue);"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white fw-medium px-3" href="<%= request.getContextPath() %>/student/history">
                        <i class="fa-solid fa-clock-rotate-left me-2" style="color: var(--accent-purple);"></i>Exam History
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white fw-medium px-3" href="<%= request.getContextPath() %>/student/profile">
                        <i class="fa-solid fa-user me-2" style="color: var(--accent-cyan);"></i>My Profile
                    </a>
                </li>
            </ul>
            <div class="d-flex align-items-center gap-3">
                <span class="text-secondary small d-none d-lg-inline">
                    Welcome, <strong class="text-white"><%= currentStudent.getName() %></strong>
                </span>
                <a href="<%= request.getContextPath() %>/logout" class="btn-premium py-1 px-3" style="background: linear-gradient(135deg, var(--accent-rose), #dc2626); box-shadow: 0 4px 15px rgba(244, 63, 94, 0.35);">
                    Logout <i class="fa-solid fa-right-from-bracket ms-1"></i>
                </a>
            </div>
        </div>
    </div>
</nav>
<div style="height: 90px;"></div> <!-- Spacer for fixed-top navbar -->
