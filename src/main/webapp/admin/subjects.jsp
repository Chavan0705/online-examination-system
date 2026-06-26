<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.exam.model.Subject" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin | Subject Management</title>
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
                <h2 class="text-white fw-bold text-glow-purple">Subject Management</h2>
                <p class="text-secondary mb-0">Create new academic subjects, manage curriculum groupings, and configure classifications.</p>
            </div>
        </div>

        <div class="row g-4">
            <!-- Left: Add Subject Form -->
            <div class="col-lg-4 animate-fade-in" style="animation-delay: 0.1s;">
                <div class="glass-panel p-4">
                    <h5 class="text-white fw-bold mb-4">Add New Subject</h5>

                    <form action="<%= request.getContextPath() %>/admin/subjects" method="post">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-4">
                            <label class="form-label text-secondary small">Subject Name</label>
                            <input type="text" name="subjectName" class="form-control form-input-premium" placeholder="e.g. Java Programming" required>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn-premium">
                                Save Subject <i class="fa-solid fa-square-plus ms-1"></i>
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Right: Subject List Table -->
            <div class="col-lg-8 animate-fade-in" style="animation-delay: 0.2s;">
                <div class="glass-panel p-4">
                    <h5 class="text-white fw-bold mb-4">Curriculum Subjects List</h5>

                    <div class="table-responsive">
                        <table class="table-premium">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Subject Name</th>
                                    <th class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
                                    if (subjects == null || subjects.isEmpty()) {
                                %>
                                    <tr>
                                        <td colspan="3" class="text-center text-secondary py-4">No subjects registered yet.</td>
                                    </tr>
                                <%
                                    } else {
                                        for (Subject s : subjects) {
                                %>
                                    <tr>
                                        <td class="text-secondary">#<%= s.getId() %></td>
                                        <td class="fw-semibold text-white"><%= s.getSubjectName() %></td>
                                        <td class="text-center">
                                            <form action="<%= request.getContextPath() %>/admin/subjects" method="post" onsubmit="return confirm('Are you sure you want to permanently delete this subject? This will delete all associated exams and questions!');" class="d-inline">
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
