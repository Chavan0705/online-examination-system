<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.exam.model.Result" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin | Student Evaluation Results</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome for Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom Premium CSS -->
    <link href="<%= request.getContextPath() %>/assets/css/styles.css" rel="stylesheet">
</head>
<body>

    <!-- Reusable Admin Navbar -->
    <jsp:include page="navbar.jsp" />

    <div class="container py-4">
        
        <div class="row mb-5 justify-content-between align-items-center g-3 animate-fade-in">
            <div class="col-md-8">
                <h2 class="text-white fw-bold text-glow-blue">Evaluation Logs &amp; Scores</h2>
                <p class="text-secondary mb-0">Review all completed student attempts, inspect percentage reports, and export CSV logs.</p>
            </div>
            
            <div class="col-md-4 text-md-end">
                <a href="<%= request.getContextPath() %>/admin/export-csv" class="btn-premium">
                    Export to CSV <i class="fa-solid fa-file-csv ms-1"></i>
                </a>
            </div>
        </div>

        <div class="row animate-fade-in" style="animation-delay: 0.1s;">
            <div class="col-12">
                <div class="glass-panel p-4">
                    <div class="table-responsive">
                        <table class="table-premium">
                            <thead>
                                <tr>
                                    <th>Student Name</th>
                                    <th>Email</th>
                                    <th>Exam Name</th>
                                    <th>Subject</th>
                                    <th>Score Obtained</th>
                                    <th>Percentage</th>
                                    <th>Status</th>
                                    <th>Submitted At</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Result> results = (List<Result>) request.getAttribute("results");
                                    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
                                    if (results == null || results.isEmpty()) {
                                %>
                                    <tr>
                                        <td colspan="8" class="text-center text-secondary py-4">No examination results recorded yet.</td>
                                    </tr>
                                <%
                                    } else {
                                        for (Result r : results) {
                                %>
                                    <tr>
                                        <td class="fw-semibold text-white"><%= r.getStudent().getName() %></td>
                                        <td><%= r.getStudent().getEmail() %></td>
                                        <td><%= r.getExam().getExamName() %></td>
                                        <td><span class="badge bg-dark border border-secondary py-2 px-3"><%= r.getExam().getSubject().getSubjectName() %></span></td>
                                        <td class="fw-bold"><%= r.getMarks() %> / <%= r.getExam().getTotalMarks() %></td>
                                        <td><%= String.format(java.util.Locale.US, "%.1f", r.getPercentage()) %>%</td>
                                        <td>
                                            <span class="badge-premium <%= r.getResultStatus().equalsIgnoreCase("Pass") ? "pass" : "fail" %>">
                                                <%= r.getResultStatus() %>
                                            </span>
                                        </td>
                                        <td class="text-secondary"><%= r.getSubmittedAt() != null ? sdf.format(r.getSubmittedAt()) : "" %></td>
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
