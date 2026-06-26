package com.exam.model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "activity_log")
public class ActivityLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "user_type", nullable = false, length = 20)
    private String userType;

    @Column(name = "user_name", nullable = false, length = 100)
    private String userName;

    @Column(name = "activity", nullable = false, columnDefinition = "TEXT")
    private String activity;

    @Column(name = "timestamp", nullable = false, updatable = false, insertable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    @Temporal(TemporalType.TIMESTAMP)
    private Date timestamp;

    public ActivityLog() {}

    public ActivityLog(String userType, String userName, String activity) {
        this.userType = userType;
        this.userName = userName;
        this.activity = activity;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getActivity() {
        return activity;
    }

    public void setActivity(String activity) {
        this.activity = activity;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }
}
