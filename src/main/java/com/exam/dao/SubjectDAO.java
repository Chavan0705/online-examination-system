package com.exam.dao;

import com.exam.model.Subject;
import com.exam.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

public class SubjectDAO extends BaseDAO<Subject> {
    public SubjectDAO() {
        super(Subject.class);
    }

    public Subject getByName(String subjectName) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Subject> query = session.createQuery("from Subject where subjectName = :name", Subject.class);
            query.setParameter("name", subjectName);
            return query.uniqueResult();
        } finally {
            session.close();
        }
    }

    public long countSubjects() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Long count = session.createQuery("select count(id) from Subject", Long.class).uniqueResult();
            return count != null ? count : 0;
        } finally {
            session.close();
        }
    }

    public void seedSubjects() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            Long count = session.createQuery("select count(id) from Subject", Long.class).uniqueResult();
            if (count == null || count == 0) {
                tx = session.beginTransaction();
                session.save(new Subject("Java Programming"));
                session.save(new Subject("Web Development"));
                session.save(new Subject("Database Management Systems"));
                session.save(new Subject("Software Engineering"));
                tx.commit();
            }
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }
    }
}
