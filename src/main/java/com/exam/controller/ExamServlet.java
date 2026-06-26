package com.exam.controller;

import com.exam.dao.ExamDAO;
import com.exam.dao.QuestionDAO;
import com.exam.dao.ResultDAO;
import com.exam.dao.ActivityLogDAO;
import com.exam.model.Student;
import com.exam.model.Exam;
import com.exam.model.Question;
import com.exam.model.Result;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

public class ExamServlet extends HttpServlet {
    private ExamDAO examDAO;
    private QuestionDAO questionDAO;
    private ResultDAO resultDAO;
    private ActivityLogDAO activityLogDAO;

    @Override
    public void init() throws ServletException {
        examDAO = new ExamDAO();
        questionDAO = new QuestionDAO();
        resultDAO = new ResultDAO();
        activityLogDAO = new ActivityLogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Student student = (Student) (session != null ? session.getAttribute("student") : null);
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?type=student");
            return;
        }

        String pathInfo = request.getPathInfo();
        if ("/instruction".equals(pathInfo)) {
            showInstruction(request, response, student);
        } else if ("/start".equals(pathInfo)) {
            startExam(request, response, student);
        } else if ("/result".equals(pathInfo)) {
            viewResult(request, response, student);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Student student = (Student) (session != null ? session.getAttribute("student") : null);
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?type=student");
            return;
        }

        String pathInfo = request.getPathInfo();
        if ("/submit".equals(pathInfo)) {
            submitExam(request, response, student);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showInstruction(HttpServletRequest request, HttpServletResponse response, Student student)
            throws ServletException, IOException {
        int examId = Integer.parseInt(request.getParameter("examId"));
        if (resultDAO.hasStudentAttemptedExam(student.getId(), examId)) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=already_attempted");
            return;
        }

        Exam exam = examDAO.getById(examId);
        if (exam == null || !exam.isPublished()) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=not_available");
            return;
        }

        request.setAttribute("exam", exam);
        request.getRequestDispatcher("/student/instruction.jsp").forward(request, response);
    }

    private void startExam(HttpServletRequest request, HttpServletResponse response, Student student)
            throws ServletException, IOException {
        int examId = Integer.parseInt(request.getParameter("examId"));
        if (resultDAO.hasStudentAttemptedExam(student.getId(), examId)) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=already_attempted");
            return;
        }

        Exam exam = examDAO.getById(examId);
        if (exam == null || !exam.isPublished()) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=not_available");
            return;
        }

        // Fetch questions and shuffle them for randomization
        List<Question> questions = questionDAO.getQuestionsByExam(examId);
        Collections.shuffle(questions);

        HttpSession session = request.getSession(true);
        session.setAttribute("currentExam", exam);
        session.setAttribute("currentQuestions", questions);
        
        long durationMillis = exam.getDuration() * 60 * 1000L;
        long examEndTime = System.currentTimeMillis() + durationMillis;
        session.setAttribute("examEndTime", examEndTime);

        activityLogDAO.log("Student", student.getName(), "Started exam: " + exam.getExamName());
        
        response.sendRedirect(request.getContextPath() + "/student/exam.jsp");
    }

    private void submitExam(HttpServletRequest request, HttpServletResponse response, Student student)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=session_expired");
            return;
        }

        Exam exam = (Exam) session.getAttribute("currentExam");
        @SuppressWarnings("unchecked")
        List<Question> questions = (List<Question>) session.getAttribute("currentQuestions");

        if (exam == null || questions == null) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=invalid_exam_session");
            return;
        }

        // Calculate Score
        int totalQuestions = questions.size();
        int attempted = 0;
        int correct = 0;
        int wrong = 0;
        int marks = 0;

        for (Question q : questions) {
            String studentAnswer = request.getParameter("answer_" + q.getId());
            if (studentAnswer != null && !studentAnswer.trim().isEmpty()) {
                attempted++;
                if (q.getCorrectAnswer().equalsIgnoreCase(studentAnswer.trim())) {
                    correct++;
                    marks += q.getMarks();
                } else {
                    wrong++;
                }
            }
        }

        double percentage = 0.0;
        if (exam.getTotalMarks() > 0) {
            percentage = ((double) marks / exam.getTotalMarks()) * 100.0;
        }

        // Pass threshold is 40%
        String status = (percentage >= 40.0) ? "Pass" : "Fail";

        Result result = new Result(student, exam, totalQuestions, attempted, correct, wrong, marks, percentage, status);
        resultDAO.save(result);

        activityLogDAO.log("Student", student.getName(), 
            "Submitted exam: " + exam.getExamName() + ". Score: " + marks + "/" + exam.getTotalMarks() + " (" + String.format(Locale.US, "%.1f", percentage) + "%), Status: " + status);

        // Clear exam session variables
        session.removeAttribute("currentExam");
        session.removeAttribute("currentQuestions");
        session.removeAttribute("examEndTime");

        response.sendRedirect(request.getContextPath() + "/exam/result?id=" + result.getId());
    }

    private void viewResult(HttpServletRequest request, HttpServletResponse response, Student student)
            throws ServletException, IOException {
        int resultId = Integer.parseInt(request.getParameter("id"));
        Result result = resultDAO.getById(resultId);

        if (result == null || result.getStudent().getId() != student.getId()) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=access_denied");
            return;
        }

        // Fetch questions for this exam to show in the review (correct/wrong answers details)
        List<Question> questions = questionDAO.getQuestionsByExam(result.getExam().getId());
        request.setAttribute("result", result);
        request.setAttribute("questions", questions);

        request.getRequestDispatcher("/student/result.jsp").forward(request, response);
    }
}
