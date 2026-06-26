<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.exam.model.Exam" %>
<%@ page import="com.exam.model.Question" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin | Question Management</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome for Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom Premium CSS -->
    <link href="<%= request.getContextPath() %>/assets/css/styles.css" rel="stylesheet">
    <style>
        .q-row {
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 20px;
            transition: var(--transition-smooth);
        }
        .q-row:hover {
            border-color: rgba(255, 255, 255, 0.12);
            background: rgba(255, 255, 255, 0.035);
        }
    </style>
</head>
<body>

    <!-- Reusable Admin Navbar -->
    <jsp:include page="navbar.jsp" />

    <div class="container py-4">
        
        <div class="row mb-5 justify-content-between align-items-center g-3 animate-fade-in">
            <div class="col-md-7">
                <h2 class="text-white fw-bold text-glow-purple">Questions Management Console</h2>
                <p class="text-secondary mb-0">Select an assessment to view, edit, or append multiple-choice questions.</p>
            </div>
            
            <div class="col-md-5 text-md-end">
                <label class="form-label text-secondary small d-block">Select Active Assessment</label>
                <select id="examSelector" class="form-select form-input-premium" style="background-image:none;" onchange="loadExamQuestions()">
                    <option value="" disabled selected>-- Select Exam --</option>
                    <%
                        List<Exam> exams = (List<Exam>) request.getAttribute("exams");
                        Exam selectedExam = (Exam) request.getAttribute("selectedExam");
                        if (exams != null) {
                            for (Exam e : exams) {
                                boolean isSel = (selectedExam != null && selectedExam.getId() == e.getId());
                    %>
                        <option value="<%= e.getId() %>" <%= isSel ? "selected" : "" %>><%= e.getExamName() %> (<%= e.getSubject().getSubjectName() %>)</option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>
        </div>

        <% if (selectedExam == null) { %>
            <!-- If no exam is selected -->
            <div class="row justify-content-center text-center py-5 animate-fade-in">
                <div class="col-md-6 glass-panel p-5">
                    <i class="fa-solid fa-clipboard-question fa-3x text-secondary mb-3"></i>
                    <h5 class="text-white fw-bold mb-2">No Assessment Selected</h5>
                    <p class="text-secondary mb-0">Please select an exam from the dropdown list in the top right corner to manage its questions.</p>
                </div>
            </div>
        <% } else { %>
            
            <!-- Question management panel if exam selected -->
            <div class="row g-4">
                <!-- Left Column: Add Question Form -->
                <div class="col-lg-5 animate-fade-in" style="animation-delay: 0.1s;">
                    <div class="glass-panel p-4">
                        <div class="border-bottom border-secondary pb-3 mb-4">
                            <h5 class="text-white fw-bold mb-1">Add Question</h5>
                            <p class="text-secondary small mb-0">Adding question to: <strong><%= selectedExam.getExamName() %></strong></p>
                        </div>

                        <form action="<%= request.getContextPath() %>/admin/questions" method="post">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="examId" value="<%= selectedExam.getId() %>">

                            <div class="mb-3">
                                <label class="form-label text-secondary small">Question Content</label>
                                <textarea name="question" class="form-control form-input-premium" rows="3" placeholder="Type the question details here..." required></textarea>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <label class="form-label text-secondary small">Option A</label>
                                    <input type="text" name="optionA" class="form-control form-input-premium" placeholder="Option A" required>
                                </div>
                                <div class="col-6">
                                    <label class="form-label text-secondary small">Option B</label>
                                    <input type="text" name="optionB" class="form-control form-input-premium" placeholder="Option B" required>
                                </div>
                                <div class="col-6">
                                    <label class="form-label text-secondary small">Option C</label>
                                    <input type="text" name="optionC" class="form-control form-input-premium" placeholder="Option C" required>
                                </div>
                                <div class="col-6">
                                    <label class="form-label text-secondary small">Option D</label>
                                    <input type="text" name="optionD" class="form-control form-input-premium" placeholder="Option D" required>
                                </div>
                            </div>

                            <div class="row g-2 mb-4">
                                <div class="col-6">
                                    <label class="form-label text-secondary small">Correct Option</label>
                                    <select name="correctAnswer" class="form-select form-input-premium" style="background-image:none;" required>
                                        <option value="" disabled selected>Select Answer</option>
                                        <option value="A">A</option>
                                        <option value="B">B</option>
                                        <option value="C">C</option>
                                        <option value="D">D</option>
                                    </select>
                                </div>
                                <div class="col-6">
                                    <label class="form-label text-secondary small">Marks Weightage</label>
                                    <input type="number" name="marks" class="form-control form-input-premium" placeholder="e.g. 5" min="1" required>
                                </div>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn-premium">
                                    Save Question <i class="fa-solid fa-square-plus ms-1"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Right Column: List of Questions -->
                <div class="col-lg-7 animate-fade-in" style="animation-delay: 0.2s;">
                    <div class="glass-panel p-4">
                        <h5 class="text-white fw-bold mb-4 border-bottom border-secondary pb-3">Questions Inventory (<%= ((List<Question>)request.getAttribute("questions")).size() %> Questions)</h5>

                        <%
                            List<Question> questions = (List<Question>) request.getAttribute("questions");
                            if (questions == null || questions.isEmpty()) {
                        %>
                            <div class="text-center text-secondary py-5">
                                <i class="fa-solid fa-folder-open fa-2x mb-3"></i>
                                <p class="mb-0">No questions have been added to this exam yet.</p>
                            </div>
                        <%
                            } else {
                                for (int i = 0; i < questions.size(); i++) {
                                    Question q = questions.get(i);
                        %>
                            <div class="q-row">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <h6 class="text-white fw-bold mb-0">#<%= i + 1 %></h6>
                                    <div class="d-flex gap-2">
                                        <span class="badge bg-dark border border-secondary text-secondary py-1 px-3"><%= q.getMarks() %> Marks</span>
                                        <form action="<%= request.getContextPath() %>/admin/questions" method="post" onsubmit="return confirm('Are you sure you want to permanently delete this question?');" class="d-inline">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= q.getId() %>">
                                            <input type="hidden" name="examId" value="<%= selectedExam.getId() %>">
                                            <button type="submit" class="btn btn-outline-danger btn-sm py-0 px-2" style="font-size:0.8rem;">
                                                <i class="fa-solid fa-trash-can"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                                <p class="text-white mb-3" style="white-space: pre-wrap;"><%= q.getQuestionText() %></p>
                                <div class="row g-2 text-secondary small mb-3">
                                    <div class="col-md-6">A. <%= q.getOptionA() %></div>
                                    <div class="col-md-6">B. <%= q.getOptionB() %></div>
                                    <div class="col-md-6">C. <%= q.getOptionC() %></div>
                                    <div class="col-md-6">D. <%= q.getOptionD() %></div>
                                </div>
                                <div class="border-top border-secondary pt-2 text-glow-purple" style="color: var(--accent-purple); font-weight: 600; font-size: 0.85rem;">
                                    Correct Key: Option <%= q.getCorrectAnswer() %>
                                </div>
                            </div>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
            </div>

        <% } %>

    </div>

    <!-- Dropdown Selector Redirect Script -->
    <script>
        function loadExamQuestions() {
            const selector = document.getElementById('examSelector');
            const examId = selector.value;
            if (examId) {
                window.location.href = "<%= request.getContextPath() %>/admin/questions?examId=" + examId;
            }
        }
    </script>
    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
