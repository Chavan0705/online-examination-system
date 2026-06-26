<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.exam.model.ActivityLog" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin | Dashboard</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome for Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom Premium CSS -->
    <link href="<%= request.getContextPath() %>/assets/css/styles.css" rel="stylesheet">
    <!-- Chart.js Library -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

    <!-- Reusable Admin Navbar -->
    <jsp:include page="navbar.jsp" />

    <div class="container py-4">
        
        <div class="row mb-4 justify-content-between align-items-center g-3 animate-fade-in">
            <div class="col-md-8">
                <h2 class="text-white fw-bold text-glow-purple">System Analytics Console</h2>
                <p class="text-secondary mb-0">Overview of student performance metrics, exams database, and activity log tracking.</p>
            </div>
            <div class="col-md-4 text-md-end">
                <span class="text-secondary small">Session status: </span>
                <span class="badge bg-success bg-opacity-20 border border-success text-success p-2">Active Admin</span>
            </div>
        </div>

        <!-- System Stats Grid -->
        <div class="row g-3 mb-5 animate-fade-in" style="animation-delay: 0.1s;">
            <div class="col-md-3">
                <div class="glass-panel stat-card purple p-3 h-100">
                    <span class="text-secondary small d-block">Registered Students</span>
                    <h3 class="text-white fw-bold mt-1 mb-0"><%= request.getAttribute("studentCount") %></h3>
                </div>
            </div>
            <div class="col-md-3">
                <div class="glass-panel stat-card blue p-3 h-100">
                    <span class="text-secondary small d-block">Subjects Active</span>
                    <h3 class="text-white fw-bold mt-1 mb-0"><%= request.getAttribute("subjectCount") %></h3>
                </div>
            </div>
            <div class="col-md-3">
                <div class="glass-panel stat-card emerald p-3 h-100">
                    <span class="text-secondary small d-block">Exams Created</span>
                    <h3 class="text-white fw-bold mt-1 mb-0"><%= request.getAttribute("examCount") %></h3>
                </div>
            </div>
            <div class="col-md-3">
                <div class="glass-panel stat-card rose p-3 h-100">
                    <span class="text-secondary small d-block">Average Performance</span>
                    <h3 class="text-white fw-bold mt-1 mb-0"><%= String.format(java.util.Locale.US, "%.1f", request.getAttribute("avgScore")) %>%</h3>
                </div>
            </div>
        </div>

        <!-- Charts Visualizations -->
        <div class="row g-4 mb-5 animate-fade-in" style="animation-delay: 0.2s;">
            <!-- Subject performance bar chart -->
            <div class="col-lg-8">
                <div class="glass-panel p-4 h-100">
                    <h5 class="text-white fw-bold mb-4">Subject-Wise Performance Averages</h5>
                    <div style="height: 280px; position: relative;">
                        <canvas id="subjectChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Pass/Fail ratio pie chart -->
            <div class="col-lg-4">
                <div class="glass-panel p-4 h-100">
                    <h5 class="text-white fw-bold mb-4">Pass / Fail Ratio</h5>
                    <div style="height: 280px; position: relative; display:flex; justify-content:center;">
                        <canvas id="passFailChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Logs Section -->
        <div class="row animate-fade-in" style="animation-delay: 0.3s;">
            <div class="col-12">
                <div class="glass-panel p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="d-flex align-items-center gap-3">
                            <span class="p-2 rounded bg-opacity-10" style="background: rgba(139, 92, 246, 0.1);">
                                <i class="fa-solid fa-list-check text-glow-purple" style="color: var(--accent-purple);"></i>
                            </span>
                            <h4 class="text-white fw-bold mb-0">Recent Activity Logs</h4>
                        </div>
                        <a href="<%= request.getContextPath() %>/admin/logs" class="btn-premium-outline py-1 px-3" style="font-size: 0.85rem;">
                            View All Logs <i class="fa-solid fa-arrow-right ms-1"></i>
                        </a>
                    </div>

                    <div class="table-responsive">
                        <table class="table-premium" style="font-size: 0.9rem;">
                            <thead>
                                <tr>
                                    <th>User Type</th>
                                    <th>Operator Name</th>
                                    <th>Activity Description</th>
                                    <th>Timestamp</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<ActivityLog> logs = (List<ActivityLog>) request.getAttribute("recentLogs");
                                    SimpleDateFormat logSdf = new SimpleDateFormat("MMM dd, yyyy hh:mm:ss a");
                                    if (logs == null || logs.isEmpty()) {
                                %>
                                    <tr>
                                        <td colspan="4" class="text-center text-secondary py-3">No activity logs recorded.</td>
                                    </tr>
                                <%
                                    } else {
                                        for (ActivityLog log : logs) {
                                %>
                                    <tr>
                                        <td>
                                            <span class="badge bg-dark border <%= log.getUserType().equalsIgnoreCase("Admin") ? "border-danger text-danger" : "border-info text-info" %> px-3 py-2">
                                                <%= log.getUserType() %>
                                            </span>
                                        </td>
                                        <td class="fw-bold text-white"><%= log.getUserName() %></td>
                                        <td class="text-secondary"><%= log.getActivity() %></td>
                                        <td class="text-muted"><%= logSdf.format(log.getTimestamp()) %></td>
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

    <!-- Chart rendering Javascript -->
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            fetch("<%= request.getContextPath() %>/admin/dashboard-data")
                .then(res => res.json())
                .then(data => {
                    renderCharts(data);
                })
                .catch(err => console.error("Error loading chart data: ", err));
        });

        function renderCharts(data) {
            // Chart.js Theme Settings
            Chart.defaults.color = '#9ca3af';
            Chart.defaults.borderColor = 'rgba(255, 255, 255, 0.08)';

            // 1. Pass Fail Chart (Pie)
            const pfCtx = document.getElementById('passFailChart').getContext('2d');
            new Chart(pfCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Passed', 'Failed'],
                    datasets: [{
                        data: [data.passCount, data.failCount],
                        backgroundColor: [
                            'rgba(16, 185, 129, 0.65)',  // Emerald
                            'rgba(244, 63, 94, 0.65)'    // Rose
                        ],
                        borderColor: [
                            'hsl(150, 80%, 45%)',
                            'hsl(340, 85%, 55%)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 15,
                                font: {
                                    size: 11
                                }
                            }
                        }
                    },
                    cutout: '65%'
                }
            });

            // 2. Subject Averages Chart (Bar)
            const subCtx = document.getElementById('subjectChart').getContext('2d');
            new Chart(subCtx, {
                type: 'bar',
                data: {
                    labels: data.subjectNames,
                    datasets: [{
                        label: 'Average Score (%)',
                        data: data.subjectAverages,
                        backgroundColor: 'rgba(59, 130, 246, 0.45)', // Blue
                        borderColor: 'hsl(210, 100%, 50%)',
                        borderWidth: 1,
                        borderRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 100,
                            ticks: {
                                callback: function(value) { return value + "%"; }
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        }
                    }
                }
            });
        }
    </script>
    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
