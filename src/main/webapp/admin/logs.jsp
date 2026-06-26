<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.exam.model.ActivityLog" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin | System Audit Logs</title>
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
                <h2 class="text-white fw-bold text-glow-purple">System Audit Trail</h2>
                <p class="text-secondary mb-0">Review system-wide operator activities, including registrations, logins, exam additions, and evaluation submissions.</p>
            </div>
            
            <div class="col-md-4 text-md-end">
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn-premium-outline">
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
                                    <th>Log ID</th>
                                    <th>User Type</th>
                                    <th>Operator Name</th>
                                    <th>Activity Description</th>
                                    <th>Timestamp</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<ActivityLog> logs = (List<ActivityLog>) request.getAttribute("logs");
                                    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy hh:mm:ss a");
                                    if (logs == null || logs.isEmpty()) {
                                %>
                                    <tr>
                                        <td colspan="5" class="text-center text-secondary py-4">No system audit trails recorded.</td>
                                    </tr>
                                <%
                                    } else {
                                        for (ActivityLog log : logs) {
                                %>
                                    <tr>
                                        <td class="text-secondary">#<%= log.getId() %></td>
                                        <td>
                                            <span class="badge bg-dark border <%= log.getUserType().equalsIgnoreCase("Admin") ? "border-danger text-danger" : "border-info text-info" %> px-3 py-2">
                                                <%= log.getUserType() %>
                                            </span>
                                        </td>
                                        <td class="fw-bold text-white"><%= log.getUserName() %></td>
                                        <td class="text-secondary"><%= log.getActivity() %></td>
                                        <td class="text-muted"><%= sdf.format(log.getTimestamp()) %></td>
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
