package com.exam.dao;

import com.exam.model.Question;
import com.exam.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import java.util.List;

public class QuestionDAO extends BaseDAO<Question> {
    public QuestionDAO() {
        super(Question.class);
    }

    public long countQuestions() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Long count = session.createQuery("select count(id) from Question", Long.class).uniqueResult();
            return count != null ? count : 0;
        } finally {
            session.close();
        }
    }

    public List<Question> getQuestionsByExam(int examId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Question> query = session.createQuery("from Question where exam.id = :examId", Question.class);
            query.setParameter("examId", examId);
            return query.list();
        } finally {
            session.close();
        }
    }
}
