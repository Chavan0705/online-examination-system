<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Exam System | Login</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome for Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom Premium CSS -->
    <link href="<%= request.getContextPath() %>/assets/css/styles.css" rel="stylesheet">
</head>
<body class="d-flex align-items-center min-vh-100 py-5">

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5 animate-fade-in">
                <div class="text-center mb-4">
                    <a href="<%= request.getContextPath() %>/index.jsp" class="text-decoration-none">
                        <i class="fa-solid fa-graduation-cap fa-3x text-glow-purple mb-2" style="color: var(--accent-purple);"></i>
                        <h2 class="text-white fw-bold">Online Exam System</h2>
                    </a>
                </div>

                <div class="glass-panel p-5">
                    <h4 class="text-white fw-bold mb-4 text-center">Account Sign In</h4>

                    <!-- Tab Switcher for Student vs Admin -->
                    <%
                        String type = request.getParameter("type");
                        if (type == null) {
                            type = (String) request.getAttribute("type");
                        }
                        if (type == null) {
                            type = "student";
                        }
                    %>
                    <div class="tab-nav">
                        <div class="tab-nav-item flex-fill text-center <%= "student".equals(type) ? "active" : "" %>" id="studentTabBtn" onclick="switchTab('student')">
                            <i class="fa-solid fa-user-graduate me-2"></i>Student
                        </div>
                        <div class="tab-nav-item flex-fill text-center <%= "admin".equals(type) ? "active" : "" %>" id="adminTabBtn" onclick="switchTab('admin')">
                            <i class="fa-solid fa-user-shield me-2"></i>Admin
                        </div>
                    </div>

                    <!-- Alert message container -->
                    <%
                        String error = (String) request.getAttribute("error");
                        String regSuccess = request.getParameter("registered");
                        if (error != null) {
                    %>
                        <div class="alert alert-danger border-0 text-white" style="background: rgba(244, 63, 94, 0.2); border-left: 4px solid var(--accent-rose) !important;">
                            <i class="fa-solid fa-circle-exclamation me-2"></i><%= error %>
                        </div>
                    <% } %>
                    <% if ("true".equals(regSuccess)) { %>
                        <div class="alert alert-success border-0 text-white" style="background: rgba(16, 185, 129, 0.2); border-left: 4px solid var(--accent-emerald) !important;">
                            <i class="fa-solid fa-circle-check me-2"></i>Registration successful! Please login below.
                        </div>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/login" method="post" class="mt-4">
                        <input type="hidden" name="type" id="portalType" value="<%= type %>">

                        <div class="mb-3">
                            <label class="form-label text-secondary" id="usernameLabel">
                                <%= "admin".equals(type) ? "Username" : "Email Address" %>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text bg-transparent border-end-0" style="border-color: var(--glass-border); color: var(--text-secondary);">
                                    <i class="fa-solid <%= "admin".equals(type) ? "fa-user" : "fa-envelope" %>" id="usernameIcon"></i>
                                </span>
                                <input type="text" name="username" class="form-control form-input-premium border-start-0 ps-0" placeholder="<%= "admin".equals(type) ? "Enter username" : "name@example.com" %>" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label text-secondary">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-transparent border-end-0" style="border-color: var(--glass-border); color: var(--text-secondary);">
                                    <i class="fa-solid fa-lock"></i>
                                </span>
                                <input type="password" name="password" class="form-control form-input-premium border-start-0 ps-0" placeholder="••••••••" required>
                            </div>
                        </div>

                        <div class="d-grid mb-3">
                            <button type="submit" class="btn-premium py-2">
                                Sign In <i class="fa-solid fa-right-to-bracket"></i>
                            </button>
                        </div>
                        
                        <div class="text-center mt-4" id="registerLinkContainer" style="<%= "admin".equals(type) ? "display:none;" : "" %>">
                            <span class="text-secondary small">New student? </span>
                            <a href="<%= request.getContextPath() %>/register.jsp" class="text-decoration-none small text-glow-blue" style="color: var(--accent-blue); font-weight:600;">Create an account</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Tab Switch Handler script -->
    <script>
        function switchTab(type) {
            document.getElementById('portalType').value = type;
            
            const studentBtn = document.getElementById('studentTabBtn');
            const adminBtn = document.getElementById('adminTabBtn');
            const label = document.getElementById('usernameLabel');
            const icon = document.getElementById('usernameIcon');
            const input = document.getElementsByName('username')[0];
            const regLink = document.getElementById('registerLinkContainer');
            
            if (type === 'admin') {
                studentBtn.classList.remove('active');
                adminBtn.classList.add('active');
                label.innerText = 'Username';
                icon.className = 'fa-solid fa-user';
                input.placeholder = 'Enter username';
                regLink.style.display = 'none';
            } else {
                adminBtn.classList.remove('active');
                studentBtn.classList.add('active');
                label.innerText = 'Email Address';
                icon.className = 'fa-solid fa-envelope';
                input.placeholder = 'name@example.com';
                regLink.style.display = 'block';
            }
        }
    </script>
    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
