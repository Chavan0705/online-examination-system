package com.exam.dao;

import com.exam.model.Exam;
import com.exam.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import java.util.Date;
import java.util.List;

public class ExamDAO extends BaseDAO<Exam> {
    public ExamDAO() {
        super(Exam.class);
    }

    public long countExams() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Long count = session.createQuery("select count(id) from Exam", Long.class).uniqueResult();
            return count != null ? count : 0;
        } finally {
            session.close();
        }
    }

    public List<Exam> getPublishedExams() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Exam> query = session.createQuery("from Exam where isPublished = true", Exam.class);
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<Exam> getExamsBySubject(int subjectId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Exam> query = session.createQuery("from Exam where subject.id = :subjectId", Exam.class);
            query.setParameter("subjectId", subjectId);
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<Exam> getActiveExams() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Exam> query = session.createQuery("from Exam where isPublished = true and endDate >= :now", Exam.class);
            query.setParameter("now", new Date());
            return query.list();
        } finally {
            session.close();
        }
    }
}
