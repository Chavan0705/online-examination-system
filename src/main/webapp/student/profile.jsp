<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.exam.model.Student" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?type=student");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student | My Profile</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome for Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom Premium CSS -->
    <link href="<%= request.getContextPath() %>/assets/css/styles.css" rel="stylesheet">
</head>
<body>

    <!-- Reusable Navbar -->
    <jsp:include page="navbar.jsp" />

    <div class="container py-4">
        
        <div class="row justify-content-center">
            <div class="col-lg-10">
                
                <div class="row g-4 justify-content-center">
                    <!-- Left: Profile Details Card -->
                    <div class="col-md-6 animate-fade-in">
                        <div class="glass-panel p-4 h-100">
                            <h4 class="text-white fw-bold mb-4 border-bottom border-secondary pb-3 text-glow-blue">Student Credentials</h4>

                            <div class="mb-3">
                                <label class="form-label text-secondary small">Full Name</label>
                                <input type="text" class="form-control form-input-premium" value="<%= student.getName() %>" disabled style="opacity: 0.7;">
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-secondary small">Registered Email</label>
                                <input type="text" class="form-control form-input-premium" value="<%= student.getEmail() %>" disabled style="opacity: 0.7;">
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-secondary small">Mobile Number</label>
                                <input type="text" class="form-control form-input-premium" value="<%= student.getMobile() %>" disabled style="opacity: 0.7;">
                            </div>

                            <div class="row g-3">
                                <div class="col-6">
                                    <label class="form-label text-secondary small">Course</label>
                                    <input type="text" class="form-control form-input-premium" value="<%= student.getCourse() %>" disabled style="opacity: 0.7;">
                                </div>
                                <div class="col-6">
                                    <label class="form-label text-secondary small">Semester</label>
                                    <input type="text" class="form-control form-input-premium" value="<%= student.getSemester() %>" disabled style="opacity: 0.7;">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Password Reset Card -->
                    <div class="col-md-6 animate-fade-in" style="animation-delay: 0.1s;">
                        <div class="glass-panel p-4 h-100">
                            <h4 class="text-white fw-bold mb-4 border-bottom border-secondary pb-3 text-glow-purple">Security settings</h4>

                            <!-- Alerts -->
                            <%
                                String error = (String) request.getAttribute("error");
                                String success = (String) request.getAttribute("success");
                                if (error != null) {
                            %>
                                <div class="alert alert-danger border-0 text-white py-2" style="background: rgba(244, 63, 94, 0.2); border-left: 4px solid var(--accent-rose) !important;">
                                    <i class="fa-solid fa-circle-exclamation me-1"></i><%= error %>
                                </div>
                            <% } %>
                            <% if (success != null) { %>
                                <div class="alert alert-success border-0 text-white py-2" style="background: rgba(16, 185, 129, 0.2); border-left: 4px solid var(--accent-emerald) !important;">
                                    <i class="fa-solid fa-circle-check me-1"></i><%= success %>
                                </div>
                            <% } %>

                            <form action="<%= request.getContextPath() %>/student/profile" method="post" onsubmit="return validatePasswords()">
                                <div class="mb-3">
                                    <label class="form-label text-secondary small">Current Password</label>
                                    <input type="password" name="oldPassword" class="form-control form-input-premium" required placeholder="••••••••">
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-secondary small">New Password</label>
                                    <input type="password" name="newPassword" id="newPassword" class="form-control form-input-premium" minlength="6" required placeholder="••••••••">
                                </div>

                                <div class="mb-4">
                                    <label class="form-label text-secondary small">Confirm New Password</label>
                                    <input type="password" id="confirmNewPassword" class="form-control form-input-premium" required placeholder="••••••••">
                                    <div class="invalid-feedback text-danger mt-1 small" id="pwMatchError" style="display:none;">Passwords do not match!</div>
                                </div>

                                <div class="d-grid">
                                    <button type="submit" class="btn-premium">
                                        Update Password <i class="fa-solid fa-key ms-1"></i>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

            </div>
        </div>

    </div>

    <!-- Client-side Validation Script -->
    <script>
        function validatePasswords() {
            const p1 = document.getElementById('newPassword').value;
            const p2 = document.getElementById('confirmNewPassword').value;
            const err = document.getElementById('pwMatchError');
            
            if (p1 !== p2) {
                err.style.display = 'block';
                return false;
            }
            err.style.display = 'none';
            return true;
        }
    </script>
    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
