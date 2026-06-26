package com.exam.dao;

import com.exam.model.Result;
import com.exam.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ResultDAO extends BaseDAO<Result> {
    public ResultDAO() {
        super(Result.class);
    }

    public long countResults() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Long count = session.createQuery("select count(id) from Result", Long.class).uniqueResult();
            return count != null ? count : 0;
        } finally {
            session.close();
        }
    }

    public List<Result> getResultsByStudent(int studentId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Result> query = session.createQuery("from Result where student.id = :studentId", Result.class);
            query.setParameter("studentId", studentId);
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<Result> getResultsByExam(int examId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Result> query = session.createQuery("from Result where exam.id = :examId", Result.class);
            query.setParameter("examId", examId);
            return query.list();
        } finally {
            session.close();
        }
    }

    public boolean hasStudentAttemptedExam(int studentId, int examId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Long> query = session.createQuery(
                "select count(id) from Result where student.id = :studentId and exam.id = :examId", Long.class);
            query.setParameter("studentId", studentId);
            query.setParameter("examId", examId);
            Long count = query.uniqueResult();
            return count != null && count > 0;
        } finally {
            session.close();
        }
    }

    public Result getStudentExamResult(int studentId, int examId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Result> query = session.createQuery(
                "from Result where student.id = :studentId and exam.id = :examId", Result.class);
            query.setParameter("studentId", studentId);
            query.setParameter("examId", examId);
            return query.uniqueResult();
        } finally {
            session.close();
        }
    }

    public double getAverageScore() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Double avg = session.createQuery("select avg(percentage) from Result", Double.class).uniqueResult();
            return avg != null ? avg : 0.0;
        } finally {
            session.close();
        }
    }

    public double getPassRate() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Long total = session.createQuery("select count(id) from Result", Long.class).uniqueResult();
            if (total == null || total == 0) return 0.0;

            Long passed = session.createQuery("select count(id) from Result where resultStatus = 'Pass'", Long.class).uniqueResult();
            if (passed == null) passed = 0L;

            return ((double) passed / total) * 100.0;
        } finally {
            session.close();
        }
    }

    public Map<String, Long> getPassFailCount() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Map<String, Long> map = new HashMap<>();
            Long passed = session.createQuery("select count(id) from Result where resultStatus = 'Pass'", Long.class).uniqueResult();
            Long failed = session.createQuery("select count(id) from Result where resultStatus = 'Fail'", Long.class).uniqueResult();
            map.put("Pass", passed != null ? passed : 0L);
            map.put("Fail", failed != null ? failed : 0L);
            return map;
        } finally {
            session.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Object[]> getSubjectWiseAverageScores() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return session.createQuery(
                "select r.exam.subject.subjectName, avg(r.percentage) from Result r group by r.exam.subject.subjectName"
            ).list();
        } finally {
            session.close();
        }
    }
}
