<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Exam System | Register</title>
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
            <div class="col-md-8 col-lg-6 animate-fade-in">
                <div class="text-center mb-4">
                    <a href="<%= request.getContextPath() %>/index.jsp" class="text-decoration-none">
                        <i class="fa-solid fa-graduation-cap fa-3x text-glow-purple mb-2" style="color: var(--accent-purple);"></i>
                        <h2 class="text-white fw-bold">Online Exam System</h2>
                    </a>
                </div>

                <div class="glass-panel p-5">
                    <h4 class="text-white fw-bold mb-4 text-center">Student Onboarding</h4>

                    <%
                        String error = (String) request.getAttribute("error");
                        if (error != null) {
                    %>
                        <div class="alert alert-danger border-0 text-white" style="background: rgba(244, 63, 94, 0.2); border-left: 4px solid var(--accent-rose) !important;">
                            <i class="fa-solid fa-circle-exclamation me-2"></i><%= error %>
                        </div>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/register" method="post">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label text-secondary">Full Name</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-transparent border-end-0" style="border-color: var(--glass-border); color: var(--text-secondary);">
                                        <i class="fa-solid fa-user"></i>
                                    </span>
                                    <input type="text" name="name" class="form-control form-input-premium border-start-0 ps-0" placeholder="John Doe" required>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-secondary">Email Address</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-transparent border-end-0" style="border-color: var(--glass-border); color: var(--text-secondary);">
                                        <i class="fa-solid fa-envelope"></i>
                                    </span>
                                    <input type="email" name="email" class="form-control form-input-premium border-start-0 ps-0" placeholder="john@example.com" required>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-secondary">Mobile Number</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-transparent border-end-0" style="border-color: var(--glass-border); color: var(--text-secondary);">
                                        <i class="fa-solid fa-phone"></i>
                                    </span>
                                    <input type="tel" name="mobile" class="form-control form-input-premium border-start-0 ps-0" placeholder="9876543210" pattern="[0-9]{10}" title="Ten digit mobile number" required>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-secondary">Password</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-transparent border-end-0" style="border-color: var(--glass-border); color: var(--text-secondary);">
                                        <i class="fa-solid fa-lock"></i>
                                    </span>
                                    <input type="password" name="password" class="form-control form-input-premium border-start-0 ps-0" placeholder="••••••••" minlength="6" required>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-secondary">Course</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-transparent border-end-0" style="border-color: var(--glass-border); color: var(--text-secondary);">
                                        <i class="fa-solid fa-book-open"></i>
                                    </span>
                                    <select name="course" class="form-select form-input-premium border-start-0 ps-0" style="background-image:none;" required>
                                        <option value="" disabled selected>Select Course</option>
                                        <option value="B.Tech Computer Science">B.Tech Computer Science</option>
                                        <option value="BCA">BCA</option>
                                        <option value="MCA">MCA</option>
                                        <option value="MBA">MBA</option>
                                        <option value="B.Sc IT">B.Sc IT</option>
                                    </select>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-secondary">Semester</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-transparent border-end-0" style="border-color: var(--glass-border); color: var(--text-secondary);">
                                        <i class="fa-solid fa-list-ol"></i>
                                    </span>
                                    <select name="semester" class="form-select form-input-premium border-start-0 ps-0" style="background-image:none;" required>
                                        <option value="" disabled selected>Select Semester</option>
                                        <option value="Semester 1">Semester 1</option>
                                        <option value="Semester 2">Semester 2</option>
                                        <option value="Semester 3">Semester 3</option>
                                        <option value="Semester 4">Semester 4</option>
                                        <option value="Semester 5">Semester 5</option>
                                        <option value="Semester 6">Semester 6</option>
                                        <option value="Semester 7">Semester 7</option>
                                        <option value="Semester 8">Semester 8</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="d-grid mt-4">
                            <button type="submit" class="btn-premium py-2">
                                Register Account <i class="fa-solid fa-user-plus"></i>
                            </button>
                        </div>
                        
                        <div class="text-center mt-4">
                            <span class="text-secondary small">Already have an account? </span>
                            <a href="<%= request.getContextPath() %>/login.jsp?type=student" class="text-decoration-none small text-glow-blue" style="color: var(--accent-blue); font-weight:600;">Sign in here</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
