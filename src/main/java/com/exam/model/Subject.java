package com.exam.model;

import javax.persistence.*;

@Entity
@Table(name = "subject")
public class Subject {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "subject_name", nullable = false, unique = true, length = 100)
    private String subjectName;

    public Subject() {}

    public Subject(String subjectName) {
        this.subjectName = subjectName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }
}
