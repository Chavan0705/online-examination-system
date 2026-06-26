package com.exam.dao;

import com.exam.model.ActivityLog;
import com.exam.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import java.util.List;

public class ActivityLogDAO extends BaseDAO<ActivityLog> {
    public ActivityLogDAO() {
        super(ActivityLog.class);
    }

    public List<ActivityLog> getRecentLogs(int limit) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<ActivityLog> query = session.createQuery("from ActivityLog order by id desc", ActivityLog.class);
            query.setMaxResults(limit);
            return query.list();
        } finally {
            session.close();
        }
    }

    public void log(String userType, String userName, String activity) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            ActivityLog log = new ActivityLog(userType, userName, activity);
            session.save(log);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }
    }
}
