package com.exam.dao;

import com.exam.model.Admin;
import com.exam.util.HibernateUtil;
import com.exam.util.PasswordUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

public class AdminDAO extends BaseDAO<Admin> {
    public AdminDAO() {
        super(Admin.class);
    }

    public Admin authenticate(String username, String password) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Admin> query = session.createQuery("from Admin where username = :username", Admin.class);
            query.setParameter("username", username);
            Admin admin = query.uniqueResult();
            if (admin != null && PasswordUtil.checkPassword(password, admin.getPassword())) {
                return admin;
            }
            return null;
        } finally {
            session.close();
        }
    }

    public void seedAdmin() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            Long count = session.createQuery("select count(id) from Admin", Long.class).uniqueResult();
            if (count == null || count == 0) {
                tx = session.beginTransaction();
                Admin defaultAdmin = new Admin("admin", PasswordUtil.hashPassword("admin123"));
                session.save(defaultAdmin);
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
