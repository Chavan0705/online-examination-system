<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.exam.model.Exam" %>
<%
    Exam exam = (Exam) request.getAttribute("exam");
    if (exam == null) {
        response.sendRedirect(request.getContextPath() + "/student/dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student | Exam Instructions</title>
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
            <div class="col-md-9 col-lg-8 animate-fade-in">
                
                <div class="glass-panel p-5">
                    <div class="text-center mb-5">
                        <span class="p-3 rounded-circle d-inline-block mb-3" style="background: rgba(139, 92, 246, 0.1); border: 1px solid rgba(139, 92, 246, 0.2);">
                            <i class="fa-solid fa-circle-info fa-2x" style="color: var(--accent-purple);"></i>
                        </span>
                        <h2 class="text-white fw-bold">Instructions &amp; Guidelines</h2>
                        <p class="text-secondary">Please read the instructions carefully before initiating the exam.</p>
                    </div>

                    <div class="glass-card p-4 mb-4" style="background: rgba(0,0,0,0.15);">
                        <h5 class="text-white fw-bold mb-3"><%= exam.getExamName() %></h5>
                        <div class="row g-3 text-secondary">
                            <div class="col-md-6 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-book" style="color: var(--accent-blue);"></i>
                                <span>Subject: <strong><%= exam.getSubject().getSubjectName() %></strong></span>
                            </div>
                            <div class="col-md-6 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-clock" style="color: var(--accent-purple);"></i>
                                <span>Duration: <strong><%= exam.getDuration() %> Minutes</strong></span>
                            </div>
                            <div class="col-md-6 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-award" style="color: var(--accent-cyan);"></i>
                                <span>Total Marks: <strong><%= exam.getTotalMarks() %> Marks</strong></span>
                            </div>
                            <div class="col-md-6 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-circle-question" style="color: var(--accent-emerald);"></i>
                                <span>Passing Criteria: <strong>40% and above</strong></span>
                            </div>
                        </div>
                    </div>

                    <div class="text-secondary mb-5">
                        <h6 class="text-white fw-bold mb-3">General Rules:</h6>
                        <ul class="ps-3 d-flex flex-column gap-2 small">
                            <li>Ensure you have a stable internet connection.</li>
                            <li>The exam must be completed within the allocated duration of <%= exam.getDuration() %> minutes.</li>
                            <li>A countdown timer will run at the top of the exam dashboard. The exam will <strong>auto-submit</strong> when the timer reaches zero.</li>
                            <li>Only one attempt is permitted per student. Do not refresh or navigate away from the page, or the exam will automatically submit.</li>
                            <li>If you experience accidental refresh, the system preserves selected answers in your browser's local cache.</li>
                        </ul>
                    </div>

                    <form action="<%= request.getContextPath() %>/exam/start" method="get">
                        <input type="hidden" name="examId" value="<%= exam.getId() %>">

                        <div class="form-check mb-5">
                            <input class="form-check-input" type="checkbox" id="agreeRules" onchange="toggleStartBtn()">
                            <label class="form-check-label text-secondary small" for="agreeRules">
                                I hereby declare that I have read the instructions and agree to all the terms, conditions, and guidelines.
                            </label>
                        </div>

                        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                            <a href="<%= request.getContextPath() %>/student/dashboard" class="btn-premium-outline">
                                <i class="fa-solid fa-arrow-left me-2"></i>Back to Dashboard
                            </a>
                            <button type="submit" class="btn-premium" id="startExamBtn" disabled>
                                Initiate Exam <i class="fa-solid fa-circle-play ms-1"></i>
                            </button>
                        </div>
                    </form>

                </div>

            </div>
        </div>
    </div>

    <script>
        function toggleStartBtn() {
            const check = document.getElementById('agreeRules');
            const btn = document.getElementById('startExamBtn');
            btn.disabled = !check.checked;
        }
    </script>
    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
