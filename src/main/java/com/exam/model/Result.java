package com.exam.model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "result", uniqueConstraints = {@UniqueConstraint(columnNames = {"student_id", "exam_id"})})
public class Result {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "student_id")
    private Student student;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "exam_id")
    private Exam exam;

    @Column(name = "total_questions", nullable = false)
    private int totalQuestions;

    @Column(name = "attempted", nullable = false)
    private int attempted;

    @Column(name = "correct", nullable = false)
    private int correct;

    @Column(name = "wrong", nullable = false)
    private int wrong;

    @Column(name = "marks", nullable = false)
    private int marks;

    @Column(name = "percentage", nullable = false)
    private double percentage;

    @Column(name = "result_status", nullable = false, length = 20)
    private String resultStatus; // Pass / Fail

    @Column(name = "submitted_at", nullable = false, updatable = false, insertable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    @Temporal(TemporalType.TIMESTAMP)
    private Date submittedAt;

    public Result() {}

    public Result(Student student, Exam exam, int totalQuestions, int attempted, int correct, int wrong, int marks, double percentage, String resultStatus) {
        this.student = student;
        this.exam = exam;
        this.totalQuestions = totalQuestions;
        this.attempted = attempted;
        this.correct = correct;
        this.wrong = wrong;
        this.marks = marks;
        this.percentage = percentage;
        this.resultStatus = resultStatus;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public Exam getExam() {
        return exam;
    }

    public void setExam(Exam exam) {
        this.exam = exam;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public int getAttempted() {
        return attempted;
    }

    public void setAttempted(int attempted) {
        this.attempted = attempted;
    }

    public int getCorrect() {
        return correct;
    }

    public void setCorrect(int correct) {
        this.correct = correct;
    }

    public int getWrong() {
        return wrong;
    }

    public void setWrong(int wrong) {
        this.wrong = wrong;
    }

    public int getMarks() {
        return marks;
    }

    public void setMarks(int marks) {
        this.marks = marks;
    }

    public double getPercentage() {
        return percentage;
    }

    public void setPercentage(double percentage) {
        this.percentage = percentage;
    }

    public String getResultStatus() {
        return resultStatus;
    }

    public void setResultStatus(String resultStatus) {
        this.resultStatus = resultStatus;
    }

    public Date getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Date submittedAt) {
        this.submittedAt = submittedAt;
    }
}
