<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.exam.model.Result" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student | Exam History</title>
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
        
        <div class="row mb-5 justify-content-center text-center text-lg-start align-items-center g-4 animate-fade-in">
            <div class="col-lg-8">
                <h2 class="text-white fw-bold text-glow-purple">Examination History</h2>
                <p class="text-secondary mb-0">Review all your past attempts, download score sheets, and verify certification status.</p>
            </div>
            <div class="col-lg-4 text-lg-end">
                <a href="<%= request.getContextPath() %>/student/dashboard" class="btn-premium-outline">
                    <i class="fa-solid fa-arrow-left me-2"></i>Dashboard
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
                                    <th>Exam Name</th>
                                    <th>Subject</th>
                                    <th>Questions Attempted</th>
                                    <th>Score Obtained</th>
                                    <th>Percentage</th>
                                    <th>Status</th>
                                    <th>Submitted At</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Result> results = (List<Result>) request.getAttribute("results");
                                    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
                                    if (results == null || results.isEmpty()) {
                                %>
                                    <tr>
                                        <td colspan="8" class="text-center text-secondary py-4">You have not attempted any examinations yet.</td>
                                    </tr>
                                <%
                                    } else {
                                        for (Result r : results) {
                                %>
                                    <tr>
                                        <td class="fw-semibold text-white"><%= r.getExam().getExamName() %></td>
                                        <td><span class="badge bg-dark border border-secondary py-2 px-3"><%= r.getExam().getSubject().getSubjectName() %></span></td>
                                        <td><%= r.getAttempted() %> / <%= r.getTotalQuestions() %></td>
                                        <td class="fw-bold"><%= r.getMarks() %> / <%= r.getExam().getTotalMarks() %></td>
                                        <td><%= String.format(java.util.Locale.US, "%.1f", r.getPercentage()) %>%</td>
                                        <td>
                                            <span class="badge-premium <%= r.getResultStatus().equalsIgnoreCase("Pass") ? "pass" : "fail" %>">
                                                <%= r.getResultStatus() %>
                                            </span>
                                        </td>
                                        <td class="text-secondary"><%= r.getSubmittedAt() != null ? sdf.format(r.getSubmittedAt()) : "" %></td>
                                        <td>
                                            <a href="<%= request.getContextPath() %>/exam/result?id=<%= r.getId() %>" class="btn-premium py-1 px-3" style="font-size:0.85rem;">
                                                Feedback <i class="fa-solid fa-square-poll-vertical ms-1"></i>
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

    </div>

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
