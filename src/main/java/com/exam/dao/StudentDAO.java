package com.exam.dao;

import com.exam.model.Student;
import com.exam.util.HibernateUtil;
import com.exam.util.PasswordUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import java.util.List;

public class StudentDAO extends BaseDAO<Student> {
    public StudentDAO() {
        super(Student.class);
    }

    public Student authenticate(String email, String password) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Student> query = session.createQuery("from Student where email = :email", Student.class);
            query.setParameter("email", email);
            Student student = query.uniqueResult();
            if (student != null && PasswordUtil.checkPassword(password, student.getPassword())) {
                return student;
            }
            return null;
        } finally {
            session.close();
        }
    }

    public Student getByEmail(String email) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Student> query = session.createQuery("from Student where email = :email", Student.class);
            query.setParameter("email", email);
            return query.uniqueResult();
        } finally {
            session.close();
        }
    }

    public List<Student> searchStudents(String term) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Student> query;
            if (term == null || term.trim().isEmpty()) {
                query = session.createQuery("from Student", Student.class);
            } else {
                query = session.createQuery("from Student where name like :term or email like :term or course like :term or semester like :term", Student.class);
                query.setParameter("term", "%" + term + "%");
            }
            return query.list();
        } finally {
            session.close();
        }
    }

    public long countStudents() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Long count = session.createQuery("select count(id) from Student", Long.class).uniqueResult();
            return count != null ? count : 0;
        } finally {
            session.close();
        }
    }
}
