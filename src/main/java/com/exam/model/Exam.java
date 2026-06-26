package com.exam.model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "exam")
public class Exam {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "exam_name", nullable = false, length = 100)
    private String examName;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "subject_id")
    private Subject subject;

    @Column(name = "duration", nullable = false)
    private int duration; // in minutes

    @Column(name = "total_marks", nullable = false)
    private int totalMarks;

    @Column(name = "start_date", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date startDate;

    @Column(name = "end_date", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date endDate;

    @Column(name = "is_published")
    private boolean isPublished = false;

    public Exam() {}

    public Exam(String examName, Subject subject, int duration, int totalMarks, Date startDate, Date endDate) {
        this.examName = examName;
        this.subject = subject;
        this.duration = duration;
        this.totalMarks = totalMarks;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getExamName() {
        return examName;
    }

    public void setExamName(String examName) {
        this.examName = examName;
    }

    public Subject getSubject() {
        return subject;
    }

    public void setSubject(Subject subject) {
        this.subject = subject;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public int getTotalMarks() {
        return totalMarks;
    }

    public void setTotalMarks(int totalMarks) {
        this.totalMarks = totalMarks;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public boolean isPublished() {
        return isPublished;
    }

    public void setPublished(boolean published) {
        isPublished = published;
    }
}
