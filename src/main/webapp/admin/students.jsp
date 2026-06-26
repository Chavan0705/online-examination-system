<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.exam.model.Student" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin | Student Accounts</title>
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
            <div class="col-md-7">
                <h2 class="text-white fw-bold text-glow-blue">Student Accounts Database</h2>
                <p class="text-secondary mb-0">View registered profiles, search/filter databases, and manage credentials access.</p>
            </div>
            <div class="col-md-5">
                <form action="<%= request.getContextPath() %>/admin/students" method="get">
                    <div class="input-group">
                        <input type="text" name="query" class="form-control form-input-premium" placeholder="Search by name, email, course..." value="<%= request.getAttribute("query") != null ? request.getAttribute("query") : "" %>">
                        <button type="submit" class="btn-premium">
                            <i class="fa-solid fa-magnifying-glass"></i> Search
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div class="row animate-fade-in" style="animation-delay: 0.1s;">
            <div class="col-12">
                <div class="glass-panel p-4">
                    <div class="table-responsive">
                        <table class="table-premium">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Full Name</th>
                                    <th>Email Address</th>
                                    <th>Mobile Number</th>
                                    <th>Course</th>
                                    <th>Semester</th>
                                    <th class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Student> students = (List<Student>) request.getAttribute("students");
                                    if (students == null || students.isEmpty()) {
                                %>
                                    <tr>
                                        <td colspan="7" class="text-center text-secondary py-4">No student records found.</td>
                                    </tr>
                                <%
                                    } else {
                                        for (Student s : students) {
                                %>
                                    <tr>
                                        <td class="text-secondary">#<%= s.getId() %></td>
                                        <td class="fw-semibold text-white"><%= s.getName() %></td>
                                        <td><%= s.getEmail() %></td>
                                        <td><%= s.getMobile() %></td>
                                        <td><span class="badge bg-dark border border-secondary px-3 py-2"><%= s.getCourse() %></span></td>
                                        <td><%= s.getSemester() %></td>
                                        <td class="text-center">
                                            <form action="<%= request.getContextPath() %>/admin/students" method="post" onsubmit="return confirm('Are you sure you want to permanently delete this student account?');" class="d-inline">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="<%= s.getId() %>">
                                                <button type="submit" class="btn btn-outline-danger btn-sm px-3 py-1">
                                                    <i class="fa-solid fa-trash-can"></i> Delete
                                                </button>
                                            </form>
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
