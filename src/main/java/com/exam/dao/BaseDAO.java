package com.exam.dao;

import com.exam.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class BaseDAO<T> {
    private final Class<T> clazz;

    public BaseDAO(Class<T> clazz) {
        this.clazz = clazz;
    }

    public void save(T entity) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.save(entity);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }
    }

    public void update(T entity) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.update(entity);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }
    }

    public void delete(T entity) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.delete(entity);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }
    }

    public T getById(int id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return session.get(clazz, id);
        } finally {
            session.close();
        }
    }

    public List<T> getAll() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return session.createQuery("from " + clazz.getName(), clazz).list();
        } finally {
            session.close();
        }
    }
}
