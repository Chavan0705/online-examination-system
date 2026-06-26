<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.exam.model.Exam" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student | Dashboard</title>
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
        <!-- Error Alerts -->
        <%
            String error = request.getParameter("error");
            if ("already_attempted".equals(error)) {
        %>
            <div class="alert alert-danger border-0 text-white animate-fade-in" style="background: rgba(244, 63, 94, 0.25); border-left: 4px solid var(--accent-rose) !important;">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>You have already attempted this examination. Only one attempt is permitted.
            </div>
        <% } else if ("not_available".equals(error)) { %>
            <div class="alert alert-danger border-0 text-white animate-fade-in" style="background: rgba(244, 63, 94, 0.25); border-left: 4px solid var(--accent-rose) !important;">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>This examination is not active or has expired.
            </div>
        <% } %>

        <div class="row mb-5 justify-content-center text-center text-lg-start align-items-center g-4 animate-fade-in">
            <div class="col-lg-8">
                <h2 class="text-white fw-bold text-glow-purple">Student Console Dashboard</h2>
                <p class="text-secondary mb-0">Track your progress, view active tests, and check your result certificates.</p>
            </div>
            <div class="col-lg-4 text-lg-end">
                <span class="text-secondary small">Current Time: </span>
                <span class="badge bg-dark border border-secondary p-2"><%= new java.util.Date().toString() %></span>
            </div>
        </div>

        <!-- Stats Cards Grid -->
        <div class="row g-4 mb-5 animate-fade-in" style="animation-delay: 0.1s;">
            <!-- Completed Exams -->
            <div class="col-md-4">
                <div class="glass-panel stat-card emerald p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-secondary fw-semibold mb-1">Total Attempted</p>
                            <h2 class="text-white fw-bold mb-0"><%= request.getAttribute("attemptedCount") %></h2>
                        </div>
                        <span class="p-3 rounded-3" style="background: rgba(16, 185, 129, 0.1);">
                            <i class="fa-solid fa-circle-check fa-xl" style="color: var(--accent-emerald);"></i>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Average Percentage -->
            <div class="col-md-4">
                <div class="glass-panel stat-card blue p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-secondary fw-semibold mb-1">Average Percentage</p>
                            <h2 class="text-white fw-bold mb-0">
                                <%= String.format(java.util.Locale.US, "%.1f", request.getAttribute("avgScore")) %>%
                            </h2>
                        </div>
                        <span class="p-3 rounded-3" style="background: rgba(59, 130, 246, 0.1);">
                            <i class="fa-solid fa-chart-simple fa-xl" style="color: var(--accent-blue);"></i>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Highest Score -->
            <div class="col-md-4">
                <div class="glass-panel stat-card purple p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-secondary fw-semibold mb-1">Highest Percentage</p>
                            <h2 class="text-white fw-bold mb-0">
                                <%= String.format(java.util.Locale.US, "%.1f", request.getAttribute("highestScore")) %>%
                            </h2>
                        </div>
                        <span class="p-3 rounded-3" style="background: rgba(139, 92, 246, 0.1);">
                            <i class="fa-solid fa-award fa-xl" style="color: var(--accent-purple);"></i>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Available Exams Section -->
        <div class="row animate-fade-in" style="animation-delay: 0.2s;">
            <div class="col-12 mb-5">
                <div class="glass-panel p-4">
                    <div class="d-flex align-items-center gap-3 mb-4">
                        <span class="p-2 rounded bg-opacity-10" style="background: rgba(59, 130, 246, 0.1);">
                            <i class="fa-solid fa-clipboard-question text-glow-blue" style="color: var(--accent-blue);"></i>
                        </span>
                        <h4 class="text-white fw-bold mb-0">Active &amp; Available Exams</h4>
                    </div>

                    <div class="table-responsive">
                        <table class="table-premium">
                            <thead>
                                <tr>
                                    <th>Exam Name</th>
                                    <th>Subject</th>
                                    <th>Duration</th>
                                    <th>Total Marks</th>
                                    <th>Valid Until</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Exam> availableExams = (List<Exam>) request.getAttribute("availableExams");
                                    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
                                    if (availableExams == null || availableExams.isEmpty()) {
                                %>
                                    <tr>
                                        <td colspan="6" class="text-center text-secondary py-4">No active examinations are available right now. Check back later!</td>
                                    </tr>
                                <%
                                    } else {
                                        for (Exam exam : availableExams) {
                                %>
                                    <tr>
                                        <td class="fw-semibold text-white"><%= exam.getExamName() %></td>
                                        <td><span class="badge bg-dark border border-secondary py-2 px-3"><%= exam.getSubject().getSubjectName() %></span></td>
                                        <td><%= exam.getDuration() %> mins</td>
                                        <td class="fw-bold"><%= exam.getTotalMarks() %> Marks</td>
                                        <td class="text-secondary"><%= sdf.format(exam.getEndDate()) %></td>
                                        <td>
                                            <a href="<%= request.getContextPath() %>/exam/instruction?examId=<%= exam.getId() %>" class="btn-premium py-1 px-3">
                                                Start Exam <i class="fa-solid fa-play ms-1"></i>
                                            </a>
                                        </td>
                                    </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Upcoming Exams Section -->
        <div class="row animate-fade-in" style="animation-delay: 0.3s;">
            <div class="col-12">
                <div class="glass-panel p-4">
                    <div class="d-flex align-items-center gap-3 mb-4">
                        <span class="p-2 rounded bg-opacity-10" style="background: rgba(139, 92, 246, 0.1);">
                            <i class="fa-solid fa-calendar-days text-glow-purple" style="color: var(--accent-purple);"></i>
                        </span>
                        <h4 class="text-white fw-bold mb-0">Upcoming Scheduled Exams</h4>
                    </div>

                    <div class="table-responsive">
                        <table class="table-premium">
                            <thead>
                                <tr>
                                    <th>Exam Name</th>
                                    <th>Subject</th>
                                    <th>Duration</th>
                                    <th>Total Marks</th>
                                    <th>Starts At</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Exam> upcomingExams = (List<Exam>) request.getAttribute("upcomingExams");
                                    if (upcomingExams == null || upcomingExams.isEmpty()) {
                                %>
                                    <tr>
                                        <td colspan="5" class="text-center text-secondary py-4">No upcoming examinations scheduled.</td>
                                    </tr>
                                <%
                                    } else {
                                        for (Exam exam : upcomingExams) {
                                %>
                                    <tr>
                                        <td class="fw-semibold text-white"><%= exam.getExamName() %></td>
                                        <td><span class="badge bg-dark border border-secondary py-2 px-3"><%= exam.getSubject().getSubjectName() %></span></td>
                                        <td><%= exam.getDuration() %> mins</td>
                                        <td><%= exam.getTotalMarks() %> Marks</td>
                                        <td class="text-glow-purple" style="color: var(--accent-purple); font-weight:600;"><%= sdf.format(exam.getStartDate()) %></td>
                                    </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
