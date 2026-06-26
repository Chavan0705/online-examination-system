<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.exam.model.Exam" %>
<%@ page import="com.exam.model.Question" %>
<%@ page import="java.util.List" %>
<%
    Exam currentExam = (Exam) session.getAttribute("currentExam");
    @SuppressWarnings("unchecked")
    List<Question> currentQuestions = (List<Question>) session.getAttribute("currentQuestions");
    Long examEndTime = (Long) session.getAttribute("examEndTime");

    if (currentExam == null || currentQuestions == null || examEndTime == null) {
        response.sendRedirect(request.getContextPath() + "/student/dashboard");
        return;
    }

    long remainingMillis = examEndTime - System.currentTimeMillis();
    long remainingSeconds = remainingMillis / 1000L;
    if (remainingSeconds < 0) {
        remainingSeconds = 0;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exam Console | <%= currentExam.getExamName() %></title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome for Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom Premium CSS -->
    <link href="<%= request.getContextPath() %>/assets/css/styles.css" rel="stylesheet">
    <style>
        .option-container {
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--glass-border);
            border-radius: 8px;
            padding: 12px 16px;
            cursor: pointer;
            transition: var(--transition-smooth);
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 12px;
        }
        .option-container:hover {
            background: rgba(255, 255, 255, 0.05);
            border-color: rgba(255, 255, 255, 0.15);
        }
        .option-container.selected {
            background: rgba(59, 130, 246, 0.1);
            border-color: var(--accent-blue);
            color: #fff;
        }
        .option-container input[type="radio"] {
            accent-color: var(--accent-blue);
            width: 18px;
            height: 18px;
        }
        .question-panel-inner {
            display: none;
        }
        .question-panel-inner.active {
            display: block;
        }
        .no-select {
            user-select: none;
            -webkit-user-select: none;
        }
    </style>
</head>
<body class="no-select py-4">

    <!-- Navbar Minimal -->
    <nav class="navbar navbar-dark navbar-premium fixed-top py-3">
        <div class="container">
            <span class="navbar-brand d-flex align-items-center">
                <i class="fa-solid fa-graduation-cap me-2 text-glow-purple" style="color: var(--accent-purple);"></i>
                <span class="fw-bold"><%= currentExam.getExamName() %></span>
                <span class="badge bg-dark border border-secondary ms-3 small"><%= currentExam.getSubject().getSubjectName() %></span>
            </span>
            <div class="d-flex align-items-center gap-3">
                <div class="d-flex align-items-center gap-2">
                    <i class="fa-solid fa-clock text-glow-purple" style="color: var(--accent-purple);"></i>
                    <span class="text-white fw-mono fs-5" id="timerDisplay">--:--</span>
                </div>
            </div>
        </div>
    </nav>
    <div style="height: 90px;"></div>

    <!-- Linear Progress Bar showing remaining time -->
    <div class="progress fixed-top" style="height: 4px; top: 78px; background: rgba(255,255,255,0.05); border-radius: 0;">
        <div class="progress-bar bg-info" id="timeProgressBar" role="progressbar" style="width: 100%; transition: none;" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
    </div>

    <div class="container mt-4">
        <form id="examForm" action="<%= request.getContextPath() %>/exam/submit" method="post">
            <div class="row g-4">
                
                <!-- Main Question Area -->
                <div class="col-lg-8 animate-fade-in">
                    <div class="glass-panel p-4 h-100 d-flex flex-column justify-content-between" style="min-height: 450px;">
                        
                        <!-- Question Panel Wrapper -->
                        <div>
                            <%
                                for (int i = 0; i < currentQuestions.size(); i++) {
                                    Question q = currentQuestions.get(i);
                            %>
                            <div class="question-panel-inner" id="qPanel_<%= i %>" data-q-id="<%= q.getId() %>">
                                <div class="d-flex justify-content-between align-items-center border-bottom border-secondary pb-3 mb-4">
                                    <h5 class="text-white fw-bold mb-0">Question <%= i + 1 %> of <%= currentQuestions.size() %></h5>
                                    <span class="badge bg-dark border border-secondary text-secondary py-2 px-3"><%= q.getMarks() %> Marks</span>
                                </div>
                                
                                <p class="text-white fs-5 mb-4" style="white-space: pre-wrap;"><%= q.getQuestionText() %></p>

                                <div class="options-group">
                                    <label class="option-container" id="lbl_<%= q.getId() %>_A">
                                        <input type="radio" name="answer_<%= q.getId() %>" value="A" onchange="answerSelected(<%= i %>, '<%= q.getId() %>', 'A')">
                                        <span class="fw-bold text-secondary">A.</span>
                                        <span class="text-white"><%= q.getOptionA() %></span>
                                    </label>
                                    <label class="option-container" id="lbl_<%= q.getId() %>_B">
                                        <input type="radio" name="answer_<%= q.getId() %>" value="B" onchange="answerSelected(<%= i %>, '<%= q.getId() %>', 'B')">
                                        <span class="fw-bold text-secondary">B.</span>
                                        <span class="text-white"><%= q.getOptionB() %></span>
                                    </label>
                                    <label class="option-container" id="lbl_<%= q.getId() %>_C">
                                        <input type="radio" name="answer_<%= q.getId() %>" value="C" onchange="answerSelected(<%= i %>, '<%= q.getId() %>', 'C')">
                                        <span class="fw-bold text-secondary">C.</span>
                                        <span class="text-white"><%= q.getOptionC() %></span>
                                    </label>
                                    <label class="option-container" id="lbl_<%= q.getId() %>_D">
                                        <input type="radio" name="answer_<%= q.getId() %>" value="D" onchange="answerSelected(<%= i %>, '<%= q.getId() %>', 'D')">
                                        <span class="fw-bold text-secondary">D.</span>
                                        <span class="text-white"><%= q.getOptionD() %></span>
                                    </label>
                                </div>
                            </div>
                            <%
                                }
                            %>
                        </div>

                        <!-- Question Action Bar -->
                        <div class="border-top border-secondary pt-4 mt-4 d-flex justify-content-between align-items-center flex-wrap gap-2">
                            <div>
                                <button type="button" class="btn btn-secondary py-2 px-3 border border-secondary" style="background: rgba(255,255,255,0.02); color: var(--text-primary);" onclick="prevQuestion()" id="prevBtn">
                                    <i class="fa-solid fa-chevron-left me-1"></i> Previous
                                </button>
                                <button type="button" class="btn btn-secondary py-2 px-3 border border-secondary ms-2" style="background: rgba(255,255,255,0.02); color: var(--text-primary);" onclick="nextQuestion()" id="nextBtn">
                                    Next <i class="fa-solid fa-chevron-right ms-1"></i>
                                </button>
                            </div>
                            
                            <div>
                                <button type="button" class="btn-premium-outline py-2 px-3" onclick="toggleReview()">
                                    <i class="fa-solid fa-thumbtack me-1"></i> Mark Review
                                </button>
                                <button type="button" class="btn btn-outline-danger py-2 px-3 ms-2" onclick="clearResponse()">
                                    Clear Response
                                </button>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- Floating Sidebar Question Grid Navigator -->
                <div class="col-lg-4 animate-fade-in" style="animation-delay: 0.1s;">
                    <div class="glass-panel p-4 d-flex flex-column justify-content-between" style="min-height: 450px;">
                        
                        <div>
                            <h5 class="text-white fw-bold mb-4 border-bottom border-secondary pb-3">Questions Palette</h5>
                            
                            <!-- Key Indicators -->
                            <div class="row g-2 mb-4 text-secondary small">
                                <div class="col-6"><span class="d-inline-block rounded me-2" style="width:12px; height:12px; background:#272d3d;"></span> Unvisited</div>
                                <div class="col-6"><span class="d-inline-block rounded me-2" style="width:12px; height:12px; background:rgba(244,63,94,0.15); border:1px solid var(--accent-rose);"></span> Not Answered</div>
                                <div class="col-6"><span class="d-inline-block rounded me-2" style="width:12px; height:12px; background:rgba(16,185,129,0.15); border:1px solid var(--accent-emerald);"></span> Answered</div>
                                <div class="col-6"><span class="d-inline-block rounded me-2" style="width:12px; height:12px; background:rgba(139,92,246,0.15); border:1px solid var(--accent-purple);"></span> Marked Review</div>
                            </div>

                            <div class="d-flex flex-wrap gap-2 mb-4 overflow-y-auto" style="max-height: 220px;">
                                <%
                                    for (int i = 0; i < currentQuestions.size(); i++) {
                                %>
                                <button type="button" class="question-grid-btn unvisited" id="gridBtn_<%= i %>" onclick="goToQuestion(<%= i %>)">
                                    <%= i + 1 %>
                                </button>
                                <%
                                    }
                                %>
                            </div>
                        </div>

                        <!-- Final Submission Button -->
                        <div class="d-grid mt-4">
                            <button type="button" class="btn-premium py-3" style="background: linear-gradient(135deg, var(--accent-purple), var(--accent-rose)); box-shadow: 0 4px 15px var(--accent-purple-glow);" onclick="confirmSubmit()">
                                Submit Examination <i class="fa-solid fa-paper-plane ms-1"></i>
                            </button>
                        </div>

                    </div>
                </div>

            </div>
        </form>
    </div>

    <!-- Confirm Submit Modal -->
    <div class="modal fade" id="submitModal" tabindex="-1" aria-hidden="true" style="background: rgba(0,0,0,0.8);">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content glass-panel border-0 text-white p-4">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold text-glow-purple">Submit Examination?</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body py-4 text-secondary fs-6">
                    Are you sure you want to end and submit your examination? Once submitted, you cannot review your answers or attempt it again.
                </div>
                <div class="modal-footer border-0 pt-0 justify-content-between">
                    <button type="button" class="btn-premium-outline px-4" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn-premium px-4" style="background: linear-gradient(135deg, var(--accent-purple), var(--accent-rose));" onclick="forceSubmitForm()">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Timer and Palette script -->
    <script>
        const examId = "<%= currentExam.getId() %>";
        const totalQuestions = <%= currentQuestions.size() %>;
        const totalDurationSeconds = <%= currentExam.getDuration() * 60 %>;
        let remainingSeconds = <%= remainingSeconds %>;
        
        let currentIdx = 0;
        const answersState = {}; // local copy of answers
        const reviewState = {}; // local copy of marked review questions

        // Prepopulate answers from LocalStorage (if refresh happened)
        function initLocalStorage() {
            for (let i = 0; i < totalQuestions; i++) {
                const panel = document.getElementById(`qPanel_${i}`);
                const qId = panel.getAttribute('data-q-id');
                const savedAns = localStorage.getItem(`exam_${examId}_ans_${qId}`);
                if (savedAns) {
                    const radio = document.querySelector(`input[name="answer_${qId}"][value="${savedAns}"]`);
                    if (radio) {
                        radio.checked = true;
                        answersState[qId] = savedAns;
                        highlightOptionContainer(qId, savedAns);
                        updateGridStyle(i, 'answered');
                    }
                }
                const savedReview = localStorage.getItem(`exam_${examId}_rev_${qId}`);
                if (savedReview === 'true') {
                    reviewState[qId] = true;
                    updateGridStyle(i, answersState[qId] ? 'review' : 'review');
                }
            }
        }

        function clearLocalStorage() {
            for (let i = 0; i < totalQuestions; i++) {
                const panel = document.getElementById(`qPanel_${i}`);
                const qId = panel.getAttribute('data-q-id');
                localStorage.removeItem(`exam_${examId}_ans_${qId}`);
                localStorage.removeItem(`exam_${examId}_rev_${qId}`);
            }
        }

        // Timer Logic
        function startTimer() {
            const display = document.getElementById('timerDisplay');
            const pbar = document.getElementById('timeProgressBar');

            const interval = setInterval(() => {
                if (remainingSeconds <= 0) {
                    clearInterval(interval);
                    display.innerText = "00:00";
                    pbar.style.width = "0%";
                    pbar.className = "progress-bar bg-danger";
                    alert("Time has expired! Your exam will submit automatically.");
                    forceSubmitForm();
                    return;
                }

                remainingSeconds--;
                
                const mins = Math.floor(remainingSeconds / 60);
                const secs = remainingSeconds % 60;
                display.innerText = `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;

                const percent = (remainingSeconds / totalDurationSeconds) * 100;
                pbar.style.width = `${percent}%`;

                if (percent < 15) {
                    pbar.className = "progress-bar bg-danger";
                    display.style.color = "var(--accent-rose)";
                } else if (percent < 40) {
                    pbar.className = "progress-bar bg-warning";
                }
            }, 1000);
        }

        // Show specific question
        function goToQuestion(index) {
            if (index < 0 || index >= totalQuestions) return;
            
            // Hide current panel
            document.getElementById(`qPanel_${currentIdx}`).classList.remove('active');
            document.getElementById(`gridBtn_${currentIdx}`).classList.remove('active');
            
            // If the old question was unvisited, make it "Not Answered" (visited but no answer)
            const oldPanel = document.getElementById(`qPanel_${currentIdx}`);
            const oldQId = oldPanel.getAttribute('data-q-id');
            const oldGridBtn = document.getElementById(`gridBtn_${currentIdx}`);
            
            if (oldGridBtn.classList.contains('unvisited')) {
                oldGridBtn.classList.remove('unvisited');
                if (answersState[oldQId]) {
                    updateGridStyle(currentIdx, 'answered');
                } else if (reviewState[oldQId]) {
                    updateGridStyle(currentIdx, 'review');
                } else {
                    updateGridStyle(currentIdx, 'visited');
                }
            }

            // Show new panel
            currentIdx = index;
            document.getElementById(`qPanel_${currentIdx}`).classList.add('active');
            
            const activeGridBtn = document.getElementById(`gridBtn_${currentIdx}`);
            activeGridBtn.classList.add('active');
            if (activeGridBtn.classList.contains('unvisited')) {
                activeGridBtn.classList.remove('unvisited');
                activeGridBtn.classList.add('visited');
            }

            // Update Back/Next buttons status
            document.getElementById('prevBtn').disabled = (currentIdx === 0);
            document.getElementById('nextBtn').disabled = (currentIdx === totalQuestions - 1);
        }

        function prevQuestion() {
            goToQuestion(currentIdx - 1);
        }

        function nextQuestion() {
            goToQuestion(currentIdx + 1);
        }

        // Handles click on option containers
        function answerSelected(idx, qId, val) {
            answersState[qId] = val;
            localStorage.setItem(`exam_${examId}_ans_${qId}`, val);
            
            highlightOptionContainer(qId, val);

            if (reviewState[qId]) {
                updateGridStyle(idx, 'review');
            } else {
                updateGridStyle(idx, 'answered');
            }
        }

        function highlightOptionContainer(qId, val) {
            const options = ['A', 'B', 'C', 'D'];
            options.forEach(opt => {
                const label = document.getElementById(`lbl_${qId}_${opt}`);
                if (opt === val) {
                    label.classList.add('selected');
                } else {
                    label.classList.remove('selected');
                }
            });
        }

        function clearResponse() {
            const panel = document.getElementById(`qPanel_${currentIdx}`);
            const qId = panel.getAttribute('data-q-id');
            
            const checkedRadio = document.querySelector(`input[name="answer_${qId}"]:checked`);
            if (checkedRadio) checkedRadio.checked = false;
            
            delete answersState[qId];
            localStorage.removeItem(`exam_${examId}_ans_${qId}`);
            
            const options = ['A', 'B', 'C', 'D'];
            options.forEach(opt => {
                document.getElementById(`lbl_${qId}_${opt}`).classList.remove('selected');
            });

            if (reviewState[qId]) {
                updateGridStyle(currentIdx, 'review');
            } else {
                updateGridStyle(currentIdx, 'visited');
            }
        }

        function toggleReview() {
            const panel = document.getElementById(`qPanel_${currentIdx}`);
            const qId = panel.getAttribute('data-q-id');

            if (reviewState[qId]) {
                delete reviewState[qId];
                localStorage.removeItem(`exam_${examId}_rev_${qId}`);
                if (answersState[qId]) {
                    updateGridStyle(currentIdx, 'answered');
                } else {
                    updateGridStyle(currentIdx, 'visited');
                }
            } else {
                reviewState[qId] = true;
                localStorage.setItem(`exam_${examId}_rev_${qId}`, 'true');
                updateGridStyle(currentIdx, 'review');
            }
        }

        function updateGridStyle(idx, state) {
            const btn = document.getElementById(`gridBtn_${idx}`);
            btn.className = "question-grid-btn " + state;
            if (idx === currentIdx) {
                btn.classList.add('active');
            }
        }

        // Submit actions
        let myModal;
        function confirmSubmit() {
            myModal = new bootstrap.Modal(document.getElementById('submitModal'));
            myModal.show();
        }

        function forceSubmitForm() {
            clearLocalStorage();
            if (myModal) myModal.hide();
            
            // disable no-select to allow smooth submission
            document.body.className = '';
            document.getElementById('examForm').submit();
        }

        // Disable mouse secondary click and shortcut keys (Copy/Paste prevention)
        document.addEventListener('contextmenu', e => e.preventDefault());
        document.addEventListener('keydown', e => {
            if (e.ctrlKey && (e.key === 'c' || e.key === 'v' || e.key === 'r' || e.key === 'p')) {
                e.preventDefault();
            }
        });

        // Initialize on load
        window.onload = () => {
            goToQuestion(0);
            initLocalStorage();
            startTimer();
        };
    </script>
</body>
</html>
