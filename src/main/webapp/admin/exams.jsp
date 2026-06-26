<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.exam.model.Exam" %>
<%@ page import="com.exam.model.Subject" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin | Exam Management</title>
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
                <h2 class="text-white fw-bold text-glow-blue">Exam Management</h2>
                <p class="text-secondary mb-0">Create online assessments, define durations, marks structure, and scheduler validity windows.</p>
            </div>
        </div>

        <div class="row g-4">
            <!-- Left: Add Exam Form -->
            <div class="col-lg-4 animate-fade-in" style="animation-delay: 0.1s;">
                <div class="glass-panel p-4">
                    <h5 class="text-white fw-bold mb-4">Create New Exam</h5>

                    <form action="<%= request.getContextPath() %>/admin/exams" method="post">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-3">
                            <label class="form-label text-secondary small">Exam Name</label>
                            <input type="text" name="examName" class="form-control form-input-premium" placeholder="e.g. Java Midterm 1" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-secondary small">Subject</label>
                            <select name="subjectId" class="form-select form-input-premium" style="background-image:none;" required>
                                <option value="" disabled selected>Select Subject</option>
                                <%
                                    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
                                    if (subjects != null) {
                                        for (Subject sub : subjects) {
                                %>
                                    <option value="<%= sub.getId() %>"><%= sub.getSubjectName() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-6">
                                <label class="form-label text-secondary small">Duration (Mins)</label>
                                <input type="number" name="duration" class="form-control form-input-premium" placeholder="e.g. 60" min="5" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label text-secondary small">Total Marks</label>
                                <input type="number" name="totalMarks" class="form-control form-input-premium" placeholder="e.g. 100" min="1" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-secondary small">Starts At</label>
                            <input type="datetime-local" name="startDate" class="form-control form-input-premium" required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label text-secondary small">Ends At</label>
                            <input type="datetime-local" name="endDate" class="form-control form-input-premium" required>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn-premium">
                                Save Exam <i class="fa-solid fa-square-plus ms-1"></i>
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Right: Exams List Table -->
            <div class="col-lg-8 animate-fade-in" style="animation-delay: 0.2s;">
                <div class="glass-panel p-4">
                    <h5 class="text-white fw-bold mb-4">Assessments Inventory</h5>

                    <div class="table-responsive">
                        <table class="table-premium">
                            <thead>
                                <tr>
                                    <th>Exam Name</th>
                                    <th>Subject</th>
                                    <th>Duration</th>
                                    <th>Total Marks</th>
                                    <th>Status</th>
                                    <th class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Exam> exams = (List<Exam>) request.getAttribute("exams");
                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                                    if (exams == null || exams.isEmpty()) {
                                %>
                                    <tr>
                                        <td colspan="6" class="text-center text-secondary py-4">No exams created yet.</td>
                                    </tr>
                                <%
                                    } else {
                                        for (Exam e : exams) {
                                %>
                                    <tr>
                                        <td class="fw-semibold text-white">
                                            <%= e.getExamName() %>
                                            <div class="text-muted small" style="font-size:0.75rem;">
                                                Validity: <%= sdf.format(e.getStartDate()) %> to <%= sdf.format(e.getEndDate()) %>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-dark border border-secondary px-3 py-2"><%= e.getSubject().getSubjectName() %></span></td>
                                        <td><%= e.getDuration() %> mins</td>
                                        <td class="fw-bold"><%= e.getTotalMarks() %> M</td>
                                        <td>
                                            <% if (e.isPublished()) { %>
                                                <span class="badge-premium pass">Published</span>
                                            <% } else { %>
                                                <span class="badge bg-dark border border-secondary text-secondary py-1 px-2">Draft</span>
                                            <% } %>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex align-items-center justify-content-center gap-1">
                                                <% if (!e.isPublished()) { %>
                                                    <form action="<%= request.getContextPath() %>/admin/exams" method="post" class="d-inline">
                                                        <input type="hidden" name="action" value="publish">
                                                        <input type="hidden" name="id" value="<%= e.getId() %>">
                                                        <button type="submit" class="btn btn-outline-success btn-sm px-2 py-1">
                                                            <i class="fa-solid fa-upload"></i> Publish
                                                        </button>
                                                    </form>
                                                <% } %>
                                                
                                                <a href="<%= request.getContextPath() %>/admin/questions?examId=<%= e.getId() %>" class="btn btn-outline-info btn-sm px-2 py-1">
                                                    <i class="fa-solid fa-clipboard-question"></i> Questions
                                                </a>

                                                <form action="<%= request.getContextPath() %>/admin/exams" method="post" onsubmit="return confirm('Are you sure you want to permanently delete this exam? All student results and questions for this exam will be deleted!');" class="d-inline">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="<%= e.getId() %>">
                                                    <button type="submit" class="btn btn-outline-danger btn-sm px-2 py-1">
                                                        <i class="fa-solid fa-trash-can"></i>
                                                    </button>
                                                </form>
                                            </div>
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
