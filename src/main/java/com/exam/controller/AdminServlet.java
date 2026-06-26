package com.exam.controller;

import com.google.gson.Gson;
import com.exam.dao.AdminDAO;
import com.exam.dao.StudentDAO;
import com.exam.dao.SubjectDAO;
import com.exam.dao.ExamDAO;
import com.exam.dao.QuestionDAO;
import com.exam.dao.ResultDAO;
import com.exam.dao.ActivityLogDAO;
import com.exam.model.Admin;
import com.exam.model.Student;
import com.exam.model.Subject;
import com.exam.model.Exam;
import com.exam.model.Question;
import com.exam.model.Result;
import com.exam.model.ActivityLog;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

public class AdminServlet extends HttpServlet {
    private StudentDAO studentDAO;
    private SubjectDAO subjectDAO;
    private ExamDAO examDAO;
    private QuestionDAO questionDAO;
    private ResultDAO resultDAO;
    private ActivityLogDAO activityLogDAO;
    private final SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");

    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
        subjectDAO = new SubjectDAO();
        examDAO = new ExamDAO();
        questionDAO = new QuestionDAO();
        resultDAO = new ResultDAO();
        activityLogDAO = new ActivityLogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Admin admin = (Admin) (session != null ? session.getAttribute("admin") : null);
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?type=admin");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || "/dashboard".equals(pathInfo)) {
            showDashboard(request, response);
        } else if ("/dashboard-data".equals(pathInfo)) {
            getDashboardData(request, response);
        } else if ("/students".equals(pathInfo)) {
            listStudents(request, response, admin);
        } else if ("/subjects".equals(pathInfo)) {
            listSubjects(request, response);
        } else if ("/exams".equals(pathInfo)) {
            listExams(request, response);
        } else if ("/questions".equals(pathInfo)) {
            listQuestions(request, response);
        } else if ("/results".equals(pathInfo)) {
            listResults(request, response);
        } else if ("/export-csv".equals(pathInfo)) {
            exportCSV(request, response, admin);
        } else if ("/logs".equals(pathInfo)) {
            listLogs(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Admin admin = (Admin) (session != null ? session.getAttribute("admin") : null);
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?type=admin");
            return;
        }

        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");

        if ("/subjects".equals(pathInfo)) {
            if ("add".equals(action)) {
                addSubject(request, response, admin);
            } else if ("delete".equals(action)) {
                deleteSubject(request, response, admin);
            }
        } else if ("/exams".equals(pathInfo)) {
            if ("add".equals(action)) {
                addExam(request, response, admin);
            } else if ("delete".equals(action)) {
                deleteExam(request, response, admin);
            } else if ("publish".equals(action)) {
                publishExam(request, response, admin);
            }
        } else if ("/questions".equals(pathInfo)) {
            if ("add".equals(action)) {
                addQuestion(request, response, admin);
            } else if ("delete".equals(action)) {
                deleteQuestion(request, response, admin);
            }
        } else if ("/students".equals(pathInfo)) {
            if ("delete".equals(action)) {
                deleteStudent(request, response, admin);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("studentCount", studentDAO.countStudents());
        request.setAttribute("subjectCount", subjectDAO.countSubjects());
        request.setAttribute("examCount", examDAO.countExams());
        request.setAttribute("questionCount", questionDAO.countQuestions());
        request.setAttribute("resultCount", resultDAO.countResults());
        request.setAttribute("avgScore", resultDAO.getAverageScore());
        request.setAttribute("passRate", resultDAO.getPassRate());

        // Fetch recent logs
        List<ActivityLog> logs = activityLogDAO.getRecentLogs(8);
        request.setAttribute("recentLogs", logs);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    private void getDashboardData(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Map<String, Object> data = new HashMap<>();
        Map<String, Long> passFail = resultDAO.getPassFailCount();
        data.put("passCount", passFail.get("Pass"));
        data.put("failCount", passFail.get("Fail"));

        List<Object[]> subjectAvgs = resultDAO.getSubjectWiseAverageScores();
        List<String> subjects = new ArrayList<>();
        List<Double> averages = new ArrayList<>();
        for (Object[] row : subjectAvgs) {
            subjects.add((String) row[0]);
            averages.add((Double) row[1]);
        }
        data.put("subjectNames", subjects);
        data.put("subjectAverages", averages);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriterOut(response, new Gson().toJson(data));
    }

    private void PrintWriterOut(HttpServletResponse response, String json) throws IOException {
        response.getWriter().write(json);
    }

    private void listStudents(HttpServletRequest request, HttpServletResponse response, Admin admin)
            throws ServletException, IOException {
        String query = request.getParameter("query");
        List<Student> students = studentDAO.searchStudents(query);
        request.setAttribute("students", students);
        request.setAttribute("query", query);
        request.getRequestDispatcher("/admin/students.jsp").forward(request, response);
    }

    private void deleteStudent(HttpServletRequest request, HttpServletResponse response, Admin admin)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Student s = studentDAO.getById(id);
        if (s != null) {
            studentDAO.delete(s);
            activityLogDAO.log("Admin", admin.getUsername(), "Deleted student account: " + s.getEmail());
        }
        response.sendRedirect(request.getContextPath() + "/admin/students");
    }

    private void listSubjects(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Subject> subjects = subjectDAO.getAll();
        request.setAttribute("subjects", subjects);
        request.getRequestDispatcher("/admin/subjects.jsp").forward(request, response);
    }

    private void addSubject(HttpServletRequest request, HttpServletResponse response, Admin admin)
            throws IOException {
        String name = request.getParameter("subjectName");
        if (name != null && !name.trim().isEmpty()) {
            if (subjectDAO.getByName(name.trim()) == null) {
                Subject s = new Subject(name.trim());
                subjectDAO.save(s);
                activityLogDAO.log("Admin", admin.getUsername(), "Added new subject: " + name);
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/subjects");
    }

    private void deleteSubject(HttpServletRequest request, HttpServletResponse response, Admin admin)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Subject s = subjectDAO.getById(id);
        if (s != null) {
            subjectDAO.delete(s);
            activityLogDAO.log("Admin", admin.getUsername(), "Deleted subject: " + s.getSubjectName());
        }
        response.sendRedirect(request.getContextPath() + "/admin/subjects");
    }

    private void listExams(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Exam> exams = examDAO.getAll();
        List<Subject> subjects = subjectDAO.getAll();
        request.setAttribute("exams", exams);
        request.setAttribute("subjects", subjects);
        request.getRequestDispatcher("/admin/exams.jsp").forward(request, response);
    }

    private void addExam(HttpServletRequest request, HttpServletResponse response, Admin admin)
            throws IOException {
        try {
            String name = request.getParameter("examName");
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            int duration = Integer.parseInt(request.getParameter("duration"));
            int totalMarks = Integer.parseInt(request.getParameter("totalMarks"));
            Date start = dateTimeFormat.parse(request.getParameter("startDate"));
            Date end = dateTimeFormat.parse(request.getParameter("endDate"));

            Subject sub = subjectDAO.getById(subjectId);
            if (sub != null) {
                Exam exam = new Exam(name, sub, duration, totalMarks, start, end);
                examDAO.save(exam);
                activityLogDAO.log("Admin", admin.getUsername(), "Created exam: " + name + " for " + sub.getSubjectName());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/exams");
    }

    private void deleteExam(HttpServletRequest request, HttpServletResponse response, Admin admin)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Exam e = examDAO.getById(id);
        if (e != null) {
            examDAO.delete(e);
            activityLogDAO.log("Admin", admin.getUsername(), "Deleted exam: " + e.getExamName());
        }
        response.sendRedirect(request.getContextPath() + "/admin/exams");
    }

    private void publishExam(HttpServletRequest request, HttpServletResponse response, Admin admin)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Exam e = examDAO.getById(id);
        if (e != null) {
            e.setPublished(true);
            examDAO.update(e);
            activityLogDAO.log("Admin", admin.getUsername(), "Published exam: " + e.getExamName());
        }
        response.sendRedirect(request.getContextPath() + "/admin/exams");
    }

    private void listQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String examIdParam = request.getParameter("examId");
        List<Exam> exams = examDAO.getAll();
        List<Question> questions = new ArrayList<>();
        Exam selectedExam = null;

        if (examIdParam != null && !examIdParam.trim().isEmpty()) {
            int examId = Integer.parseInt(examIdParam);
            questions = questionDAO.getQuestionsByExam(examId);
            selectedExam = examDAO.getById(examId);
        }

        request.setAttribute("exams", exams);
        request.setAttribute("questions", questions);
        request.setAttribute("selectedExam", selectedExam);
        request.getRequestDispatcher("/admin/questions.jsp").forward(request, response);
    }

    private void addQuestion(HttpServletRequest request, HttpServletResponse response, Admin admin)
            throws IOException {
        int examId = Integer.parseInt(request.getParameter("examId"));
        String questionText = request.getParameter("question");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctAnswer = request.getParameter("correctAnswer");
        int marks = Integer.parseInt(request.getParameter("marks"));

        Exam e = examDAO.getById(examId);
        if (e != null) {
            Question q = new Question(e, questionText, optionA, optionB, optionC, optionD, correctAnswer, marks);
            questionDAO.save(q);
            activityLogDAO.log("Admin", admin.getUsername(), "Added question to exam: " + e.getExamName());
        }
        response.sendRedirect(request.getContextPath() + "/admin/questions?examId=" + examId);
    }

    private void deleteQuestion(HttpServletRequest request, HttpServletResponse response, Admin admin)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        int examId = Integer.parseInt(request.getParameter("examId"));
        Question q = questionDAO.getById(id);
        if (q != null) {
            questionDAO.delete(q);
            activityLogDAO.log("Admin", admin.getUsername(), "Deleted question ID: " + id + " from exam ID: " + examId);
        }
        response.sendRedirect(request.getContextPath() + "/admin/questions?examId=" + examId);
    }

    private void listResults(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Result> results = resultDAO.getAll();
        request.setAttribute("results", results);
        request.getRequestDispatcher("/admin/results.jsp").forward(request, response);
    }

    private void listLogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<ActivityLog> logs = activityLogDAO.getAll();
        // Sort logs desc by id
        Collections.sort(logs, new Comparator<ActivityLog>() {
            @Override
            public int compare(ActivityLog l1, ActivityLog l2) {
                return Integer.compare(l2.getId(), l1.getId());
            }
        });
        request.setAttribute("logs", logs);
        request.getRequestDispatcher("/admin/logs.jsp").forward(request, response);
    }

    private void exportCSV(HttpServletRequest request, HttpServletResponse response, Admin admin)
            throws IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"online_exam_results.csv\"");

        List<Result> results = resultDAO.getAll();
        StringBuilder csv = new StringBuilder();
        csv.append("Student Name,Email,Exam Name,Subject,Duration (Mins),Attempted,Correct,Wrong,Marks Obtained,Total Marks,Percentage,Status,Submitted At\n");

        for (Result r : results) {
            csv.append(escapeCSV(r.getStudent().getName())).append(",")
               .append(escapeCSV(r.getStudent().getEmail())).append(",")
               .append(escapeCSV(r.getExam().getExamName())).append(",")
               .append(escapeCSV(r.getExam().getSubject().getSubjectName())).append(",")
               .append(r.getExam().getDuration()).append(",")
               .append(r.getAttempted()).append(",")
               .append(r.getCorrect()).append(",")
               .append(r.getWrong()).append(",")
               .append(r.getMarks()).append(",")
               .append(r.getExam().getTotalMarks()).append(",")
               .append(String.format(Locale.US, "%.2f", r.getPercentage())).append(",")
               .append(r.getResultStatus()).append(",")
               .append(r.getSubmittedAt() != null ? r.getSubmittedAt().toString() : "").append("\n");
        }

        activityLogDAO.log("Admin", admin.getUsername(), "Exported exam results to CSV");
        response.getWriter().write(csv.toString());
    }

    private String escapeCSV(String value) {
        if (value == null) return "";
        if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
    }
}
