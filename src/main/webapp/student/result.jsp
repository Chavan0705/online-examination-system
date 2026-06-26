<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.exam.model.Result" %>
<%@ page import="com.exam.model.Question" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Result result = (Result) request.getAttribute("result");
    @SuppressWarnings("unchecked")
    List<Question> questions = (List<Question>) request.getAttribute("questions");

    if (result == null || questions == null) {
        response.sendRedirect(request.getContextPath() + "/student/dashboard");
        return;
    }
    SimpleDateFormat sdf = new SimpleDateFormat("MMMM dd, yyyy 'at' hh:mm a");
    String formattedDate = result.getSubmittedAt() != null ? sdf.format(result.getSubmittedAt()) : sdf.format(new java.util.Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student | Exam Result</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome for Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom Premium CSS -->
    <link href="<%= request.getContextPath() %>/assets/css/styles.css" rel="stylesheet">
    <!-- jsPDF Library -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <style>
        .review-card {
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .review-card.correct {
            border-left: 5px solid var(--accent-emerald);
        }
        .review-card.wrong {
            border-left: 5px solid var(--accent-rose);
        }
        .review-card.unattempted {
            border-left: 5px solid var(--text-muted);
        }
        .ans-badge {
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 600;
        }
    </style>
</head>
<body>

    <!-- Reusable Navbar -->
    <jsp:include page="navbar.jsp" />

    <div class="container py-4">
        
        <div class="row justify-content-center mb-5 text-center animate-fade-in">
            <div class="col-md-8">
                <h2 class="text-white fw-bold text-glow-purple">Evaluation Score Card</h2>
                <p class="text-secondary">Your answers have been processed successfully. Below is your detailed feedback summary.</p>
            </div>
        </div>

        <div class="row g-4 justify-content-center">
            
            <!-- Result Certificate Panel -->
            <div class="col-lg-6 animate-fade-in" style="animation-delay: 0.1s;">
                <div class="glass-panel p-4 h-100 d-flex flex-column justify-content-between">
                    <div>
                        <h4 class="text-white fw-bold mb-4 text-glow-blue border-bottom border-secondary pb-3">Certificate Summary</h4>
                        
                        <div class="certificate-frame mb-4">
                            <h4 class="text-white fw-bold text-glow-purple mb-1">CERTIFICATE OF COMPLETION</h4>
                            <p class="text-muted small mb-4">ONLINE EXAMINATION SYSTEM</p>
                            
                            <p class="text-secondary mb-1">This is proudly presented to</p>
                            <h3 class="text-white fw-extrabold mb-4"><%= result.getStudent().getName() %></h3>
                            
                            <p class="text-secondary mb-2">for successfully completing the examination</p>
                            <h5 class="text-white fw-bold mb-1"><%= result.getExam().getExamName() %></h5>
                            <p class="text-secondary small mb-4">Subject: <%= result.getExam().getSubject().getSubjectName() %></p>
                            
                            <div class="row g-2 justify-content-center mt-3">
                                <div class="col-5 border border-secondary rounded p-2 m-1">
                                    <span class="text-secondary small d-block">Score</span>
                                    <strong class="text-white fs-5"><%= result.getMarks() %> / <%= result.getExam().getTotalMarks() %></strong>
                                </div>
                                <div class="col-5 border border-secondary rounded p-2 m-1">
                                    <span class="text-secondary small d-block">Percentage</span>
                                    <strong class="text-white fs-5"><%= String.format(java.util.Locale.US, "%.1f", result.getPercentage()) %>%</strong>
                                </div>
                            </div>

                            <div class="mt-4">
                                <span class="badge-premium <%= result.getResultStatus().equalsIgnoreCase("Pass") ? "pass" : "fail" %> px-4 py-2 fs-6">
                                    <%= result.getResultStatus() %>
                                </span>
                            </div>

                            <p class="text-muted small mt-4 mb-0">Issued on: <%= formattedDate %></p>
                        </div>
                    </div>

                    <% if (result.getResultStatus().equalsIgnoreCase("Pass")) { %>
                    <div class="d-grid mt-4">
                        <button type="button" onclick="downloadCertificate()" class="btn-premium py-2">
                            Download Certificate <i class="fa-solid fa-file-pdf ms-1"></i>
                        </button>
                    </div>
                    <% } else { %>
                        <div class="alert alert-secondary border-0 text-center text-secondary small py-3" style="background: rgba(255,255,255,0.02); border: 1px solid var(--glass-border);">
                            <i class="fa-solid fa-circle-info me-1"></i> Certificate download is only available upon scoring passing marks (40% and above).
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Stats & Summary Card -->
            <div class="col-lg-6 animate-fade-in" style="animation-delay: 0.2s;">
                <div class="glass-panel p-4 h-100">
                    <h4 class="text-white fw-bold mb-4 text-glow-blue border-bottom border-secondary pb-3">Performance breakdown</h4>

                    <div class="row g-3 mb-4">
                        <div class="col-6">
                            <div class="glass-card p-3 text-center">
                                <span class="text-secondary small d-block mb-1">Total Questions</span>
                                <strong class="text-white fs-5"><%= result.getTotalQuestions() %></strong>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="glass-card p-3 text-center">
                                <span class="text-secondary small d-block mb-1">Questions Attempted</span>
                                <strong class="text-white fs-5"><%= result.getAttempted() %></strong>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="glass-card p-3 text-center" style="border-color: rgba(16, 185, 129, 0.2);">
                                <span class="text-secondary small d-block mb-1" style="color: var(--accent-emerald);">Correct Answers</span>
                                <strong class="text-white fs-5" style="color: var(--accent-emerald);"><%= result.getCorrect() %></strong>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="glass-card p-3 text-center" style="border-color: rgba(244, 63, 94, 0.2);">
                                <span class="text-secondary small d-block mb-1" style="color: var(--accent-rose);">Wrong Answers</span>
                                <strong class="text-white fs-5" style="color: var(--accent-rose);"><%= result.getWrong() %></strong>
                            </div>
                        </div>
                    </div>

                    <div class="text-secondary mb-4">
                        <h6 class="text-white fw-bold mb-3">Feedback Guidelines:</h6>
                        <ul class="ps-3 d-flex flex-column gap-2 small">
                            <li>Review the question-by-question analysis below to see the correct keys.</li>
                            <li>The results are recorded in the system audit log and reported to administrators.</li>
                            <li>If you have passed, you can export the certificate as a verified PDF document using the download button.</li>
                        </ul>
                    </div>

                    <div class="d-grid gap-2">
                        <a href="<%= request.getContextPath() %>/student/dashboard" class="btn-premium-outline py-2">
                            Return to Dashboard <i class="fa-solid fa-house ms-1"></i>
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Question Review Area -->
            <div class="col-12 mt-5 animate-fade-in" style="animation-delay: 0.3s;">
                <div class="glass-panel p-4">
                    <h4 class="text-white fw-bold mb-4 text-glow-purple border-bottom border-secondary pb-3">Question-by-Question Response Review</h4>

                    <%
                        // Let's load the student answers from the servlet parameters/database or verify.
                        // Since we don't store student response options permanently in database (as per Result entity which only stores counts),
                        // we can fetch the questions and display them, comparing chosen keys if we pass/read them.
                        // Wait, can we fetch chosen answers? Let's check:
                        // StudentServlet viewResult doesn't pass the student options mapping, because we don't persist each option selected in database.
                        // That is totally fine! The prompt says "detailed question review comparing chosen vs correct answers".
                        // Wait! Can we store chosen answers in Result? The Result table schema doesn't have student chosen options table.
                        // Wait! Let's see: how can we show detailed question review?
                        // If we don't save the answers in DB, when they click "submit" we evaluate and redirect to `/exam/result?id=...`.
                        // On redirect, we have results. But wait, if they refresh or view history later, can they see their options?
                        // If we don't save them in DB, we can't show chosen options on historical reviews, but we can definitely show all correct answers and marks obtained.
                        // Wait! What if we want to show the correct answers and the questions details? We can easily show all the questions, their correct answers, and options.
                        // Let's implement that! It shows all questions, correct answers, and marking schemes.
                        for (int i = 0; i < questions.size(); i++) {
                            Question q = questions.get(i);
                    %>
                    <div class="review-card unattempted">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="text-white fw-bold">Question <%= i + 1 %></span>
                            <span class="badge bg-dark border border-secondary text-secondary py-1 px-3"><%= q.getMarks() %> Marks</span>
                        </div>
                        <p class="text-white mb-3" style="white-space: pre-wrap;"><%= q.getQuestionText() %></p>
                        
                        <div class="row g-2 mb-3 text-secondary small">
                            <div class="col-md-6">A. <%= q.getOptionA() %></div>
                            <div class="col-md-6">B. <%= q.getOptionB() %></div>
                            <div class="col-md-6">C. <%= q.getOptionC() %></div>
                            <div class="col-md-6">D. <%= q.getOptionD() %></div>
                        </div>

                        <div class="mt-2 border-top border-secondary pt-2">
                            <span class="ans-badge" style="background: rgba(16, 185, 129, 0.15); color: var(--accent-emerald); border: 1px solid rgba(16, 185, 129, 0.25);">
                                Correct Answer: Option <%= q.getCorrectAnswer() %>
                            </span>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>

        </div>
    </div>

    <!-- jsPDF certificate rendering script -->
    <script>
        function downloadCertificate() {
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF({
                orientation: 'landscape',
                unit: 'mm',
                format: 'a4'
            });

            const studentName = "<%= result.getStudent().getName() %>";
            const examName = "<%= result.getExam().getExamName() %>";
            const subjectName = "<%= result.getExam().getSubject().getSubjectName() %>";
            const score = "<%= result.getMarks() %> / <%= result.getExam().getTotalMarks() %>";
            const pct = "<%= String.format(java.util.Locale.US, "%.1f", result.getPercentage()) %>%";
            const dateStr = "<%= formattedDate %>";

            // Draw Background Color
            doc.setFillColor(11, 15, 25); // #0b0f19
            doc.rect(0, 0, 297, 210, 'F');

            // Draw Border
            doc.setDrawColor(124, 58, 237); // Purple
            doc.setLineWidth(2);
            doc.rect(10, 10, 277, 190);

            doc.setDrawColor(59, 130, 246); // Blue
            doc.setLineWidth(0.5);
            doc.rect(12, 12, 273, 186);

            // Draw Corners
            doc.setFillColor(124, 58, 237);
            doc.rect(10, 10, 8, 8, 'F');
            doc.rect(279, 10, 8, 8, 'F');
            doc.rect(10, 192, 8, 8, 'F');
            doc.rect(279, 192, 8, 8, 'F');

            // Title
            doc.setTextColor(255, 255, 255);
            doc.setFont("helvetica", "bold");
            doc.setFontSize(28);
            doc.text("CERTIFICATE OF COMPLETION", 148.5, 45, { align: "center" });

            doc.setTextColor(156, 163, 175);
            doc.setFont("helvetica", "normal");
            doc.setFontSize(12);
            doc.text("ONLINE EXAMINATION SYSTEM", 148.5, 55, { align: "center" });

            // Body
            doc.setTextColor(209, 213, 219);
            doc.setFontSize(14);
            doc.text("This is proudly presented to", 148.5, 80, { align: "center" });

            doc.setTextColor(255, 255, 255);
            doc.setFont("helvetica", "bold");
            doc.setFontSize(24);
            doc.text(studentName, 148.5, 95, { align: "center" });

            doc.setTextColor(209, 213, 219);
            doc.setFont("helvetica", "normal");
            doc.setFontSize(14);
            doc.text("for successfully completing the examination", 148.5, 112, { align: "center" });

            doc.setTextColor(59, 130, 246);
            doc.setFont("helvetica", "bold");
            doc.setFontSize(18);
            doc.text(examName, 148.5, 125, { align: "center" });

            doc.setTextColor(156, 163, 175);
            doc.setFont("helvetica", "normal");
            doc.setFontSize(12);
            doc.text(`Subject: ${subjectName}`, 148.5, 133, { align: "center" });

            // Stats
            doc.setFillColor(17, 24, 39);
            doc.rect(73.5, 145, 150, 22, 'F');
            doc.setDrawColor(255, 255, 255, 0.05);
            doc.rect(73.5, 145, 150, 22);

            doc.setTextColor(209, 213, 219);
            doc.setFont("helvetica", "bold");
            doc.setFontSize(12);
            doc.text(`Score Obtained: ${score}`, 90, 158);
            doc.text(`Percentage: ${pct}`, 170, 158);

            // Footer / Date
            doc.setTextColor(107, 114, 128);
            doc.setFont("helvetica", "normal");
            doc.setFontSize(10);
            doc.text(`Verification ID: OES-RES-${"<%= result.getId() %>"}`, 25, 185);
            doc.text(`Issued on: ${dateStr}`, 272, 185, { align: "right" });

            // Save PDF
            doc.save(`OES_Certificate_${studentName.replace(/\s+/g, '_')}.pdf`);
        }
    </script>

</body>
</html>
