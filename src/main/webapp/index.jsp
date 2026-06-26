<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Exam System | Welcome</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome for Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom Premium CSS -->
    <link href="<%= request.getContextPath() %>/assets/css/styles.css" rel="stylesheet">
</head>
<body class="d-flex align-items-center min-vh-100 py-5">

    <div class="container">
        <div class="row justify-content-center text-center mb-5">
            <div class="col-md-8 col-lg-6 animate-fade-in">
                <i class="fa-solid fa-graduation-cap fa-4x text-glow-purple mb-4" style="color: var(--accent-purple);"></i>
                <h1 class="display-5 fw-extrabold text-white mb-3">Online Examination System</h1>
                <p class="text-secondary fs-5">A premium platform for timer-based, secure evaluations, detailed analytics, and performance tracking.</p>
            </div>
        </div>

        <div class="row justify-content-center g-4">
            <!-- Student Card -->
            <div class="col-md-5 col-lg-4 animate-fade-in" style="animation-delay: 0.1s;">
                <div class="glass-panel glass-card p-5 text-center h-100 d-flex flex-column justify-content-between">
                    <div>
                        <div class="mb-4">
                            <span class="p-3 rounded-circle d-inline-block" style="background: rgba(59, 130, 246, 0.1); border: 1px solid rgba(59, 130, 246, 0.2);">
                                <i class="fa-solid fa-user-graduate fa-2x" style="color: var(--accent-blue);"></i>
                            </span>
                        </div>
                        <h3 class="fw-bold text-white mb-3">Student Portal</h3>
                        <p class="text-secondary mb-4">Register your account, log in to take timer-based exams, view instant score cards, and download completion certificates.</p>
                    </div>
                    <div class="d-grid mt-4">
                        <a href="<%= request.getContextPath() %>/login.jsp?type=student" class="btn-premium">
                            Access Portal <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Admin Card -->
            <div class="col-md-5 col-lg-4 animate-fade-in" style="animation-delay: 0.2s;">
                <div class="glass-panel glass-card p-5 text-center h-100 d-flex flex-column justify-content-between">
                    <div>
                        <div class="mb-4">
                            <span class="p-3 rounded-circle d-inline-block" style="background: rgba(139, 92, 246, 0.1); border: 1px solid rgba(139, 92, 246, 0.2);">
                                <i class="fa-solid fa-user-shield fa-2x" style="color: var(--accent-purple);"></i>
                            </span>
                        </div>
                        <h3 class="fw-bold text-white mb-3">Administrator Portal</h3>
                        <p class="text-secondary mb-4">Manage subjects, exams, questions, and student list. Track real-time audit logs, analyze averages, and export CSV score logs.</p>
                    </div>
                    <div class="d-grid mt-4">
                        <a href="<%= request.getContextPath() %>/login.jsp?type=admin" class="btn-premium" style="background: linear-gradient(135deg, var(--accent-purple), var(--accent-rose)); box-shadow: 0 4px 15px var(--accent-purple-glow);">
                            Access Portal <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="text-center mt-5 text-glow-blue animate-fade-in" style="animation-delay: 0.3s;">
            <p class="text-muted small">&copy; 2026 Online Examination System. All rights reserved.</p>
        </div>
    </div>

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
