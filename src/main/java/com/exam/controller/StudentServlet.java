package com.exam.controller;

import com.exam.dao.AdminDAO;
import com.exam.dao.StudentDAO;
import com.exam.dao.ExamDAO;
import com.exam.dao.ResultDAO;
import com.exam.dao.ActivityLogDAO;
import com.exam.model.Admin;
import com.exam.model.Student;
import com.exam.model.Exam;
import com.exam.model.Result;
import com.exam.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class StudentServlet extends HttpServlet {
    private StudentDAO studentDAO;
    private AdminDAO adminDAO;
    private ExamDAO examDAO;
    private ResultDAO resultDAO;
    private ActivityLogDAO activityLogDAO;

    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
        adminDAO = new AdminDAO();
        examDAO = new ExamDAO();
        resultDAO = new ResultDAO();
        activityLogDAO = new ActivityLogDAO();

        // Seed default Admin and Subjects if they don't exist
        adminDAO.seedAdmin();
        new com.exam.dao.SubjectDAO().seedSubjects();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        String pathInfo = request.getPathInfo();

        if ("/logout".equals(servletPath)) {
            handleLogout(request, response);
            return;
        }

        if ("/student".equals(servletPath)) {
            HttpSession session = request.getSession(false);
            Student student = (Student) (session != null ? session.getAttribute("student") : null);
            if (student == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?type=student");
                return;
            }

            if (pathInfo == null || "/dashboard".equals(pathInfo) || "/".equals(pathInfo)) {
                showDashboard(request, response, student);
            } else if ("/profile".equals(pathInfo)) {
                request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
            } else if ("/history".equals(pathInfo)) {
                showHistory(request, response, student);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
            return;
        }

        response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        String pathInfo = request.getPathInfo();

        if ("/login".equals(servletPath)) {
            handleLogin(request, response);
        } else if ("/register".equals(servletPath)) {
            handleRegistration(request, response);
        } else if ("/student".equals(servletPath) && "/profile".equals(pathInfo)) {
            handleProfileUpdate(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String emailOrUser = request.getParameter("username");
        String password = request.getParameter("password");
        String type = request.getParameter("type"); // admin or student

        if ("admin".equals(type)) {
            Admin admin = adminDAO.authenticate(emailOrUser, password);
            if (admin != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("admin", admin);
                activityLogDAO.log("Admin", admin.getUsername(), "Logged in to admin portal");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                request.setAttribute("error", "Invalid Admin credentials");
                request.setAttribute("type", "admin");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } else {
            Student student = studentDAO.authenticate(emailOrUser, password);
            if (student != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("student", student);
                activityLogDAO.log("Student", student.getName(), "Logged in to student portal");
                response.sendRedirect(request.getContextPath() + "/student/dashboard");
            } else {
                request.setAttribute("error", "Invalid Student credentials");
                request.setAttribute("type", "student");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        }
    }

    private void handleRegistration(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String password = request.getParameter("password");
        String course = request.getParameter("course");
        String semester = request.getParameter("semester");

        if (studentDAO.getByEmail(email) != null) {
            request.setAttribute("error", "Email already registered");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        Student student = new Student(name, email, mobile, PasswordUtil.hashPassword(password), course, semester);
        studentDAO.save(student);
        activityLogDAO.log("System", name, "Registered a new student profile: " + email);
        response.sendRedirect(request.getContextPath() + "/login.jsp?type=student&registered=true");
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        Student student = (Student) (session != null ? session.getAttribute("student") : null);
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?type=student");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");

        // Reload fresh student object from DB to ensure no stale checks
        student = studentDAO.getById(student.getId());

        if (!PasswordUtil.checkPassword(oldPassword, student.getPassword())) {
            request.setAttribute("error", "Incorrect old password");
            request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
            return;
        }

        student.setPassword(PasswordUtil.hashPassword(newPassword));
        studentDAO.update(student);
        session.setAttribute("student", student);
        activityLogDAO.log("Student", student.getName(), "Successfully updated password");
        request.setAttribute("success", "Password updated successfully");
        request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Admin admin = (Admin) session.getAttribute("admin");
            Student student = (Student) session.getAttribute("student");
            if (admin != null) {
                activityLogDAO.log("Admin", admin.getUsername(), "Logged out");
            } else if (student != null) {
                activityLogDAO.log("Student", student.getName(), "Logged out");
            }
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response, Student student)
            throws ServletException, IOException {
        List<Result> results = resultDAO.getResultsByStudent(student.getId());
        int attemptedCount = results.size();
        double avgScore = 0.0;
        double highestScore = 0.0;

        if (attemptedCount > 0) {
            double totalScore = 0.0;
            for (Result r : results) {
                totalScore += r.getPercentage();
                if (r.getPercentage() > highestScore) {
                    highestScore = r.getPercentage();
                }
            }
            avgScore = totalScore / attemptedCount;
        }

        // Fetch active exams
        List<Exam> activeExams = examDAO.getActiveExams();
        List<Exam> availableExams = new ArrayList<>();
        List<Exam> upcomingExams = new ArrayList<>();
        Date now = new Date();

        // Get all published exams
        List<Exam> allPublished = examDAO.getPublishedExams();
        for (Exam exam : allPublished) {
            boolean attempted = resultDAO.hasStudentAttemptedExam(student.getId(), exam.getId());
            if (attempted) {
                continue; // Do not show attempted exams in available/upcoming lists
            }
            if (exam.getStartDate().after(now)) {
                upcomingExams.add(exam);
            } else if (exam.getEndDate().after(now)) {
                availableExams.add(exam);
            }
        }

        request.setAttribute("attemptedCount", attemptedCount);
        request.setAttribute("avgScore", avgScore);
        request.setAttribute("highestScore", highestScore);
        request.setAttribute("availableExams", availableExams);
        request.setAttribute("upcomingExams", upcomingExams);

        request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
    }

    private void showHistory(HttpServletRequest request, HttpServletResponse response, Student student)
            throws ServletException, IOException {
        List<Result> results = resultDAO.getResultsByStudent(student.getId());
        request.setAttribute("results", results);
        request.getRequestDispatcher("/student/history.jsp").forward(request, response);
    }
}
