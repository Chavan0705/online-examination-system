# Online Examination System

A comprehensive, secure, and responsive web application for conducting and managing exams online. Built using **Java EE (Servlets & JSP)**, **Hibernate ORM**, **MySQL**, and styled with custom responsive CSS.

## 🚀 Features

### 🧑‍🎓 Student Module
- **Registration & Authentication**: Secure sign-up and login with BCrypt password hashing.
- **Student Dashboard**: Live statistics showing available exams, completed exams, average percentage, and overall performance.
- **Exam Portal**:
  - Browse active and published exams.
  - Interactive test-taking interface with an active countdown timer.
  - Automatic submission on timer expiry or manual submission.
- **Results & Performance Analysis**: Detailed scorecards showing total questions, attempted questions, correct/incorrect counts, marks obtained, percentage, and passing status.

### 👑 Admin Module
- **Dashboard Overview**: Quick stats showing total students, exams, subjects, and real-time system activity logs.
- **Student Management**: View all registered students and remove accounts.
- **Subject Management**: Create, update, and delete exam categories/subjects.
- **Exam Management**:
  - Create exams with configurable durations (in minutes), total marks, and schedule (start/end dates).
  - Publish or unpublish exams.
- **Question Bank Management**: Add, update, and delete multiple-choice questions (MCQs) for each exam, specifying options, marks, and the correct option (A, B, C, or D).
- **Result Auditing**: Monitor and view results of all students.
- **Activity Log**: Secure system audit log tracking all key actions performed by students and admins.

---

## 🛠️ Technology Stack

- **Backend Logic**: Java 21 (JDK 21)
- **Web Framework**: Jakarta/Java EE Servlets & JSP
- **ORM & Database Interaction**: Hibernate 5.6.15.Final
- **Database**: MySQL 8.x
- **Dependency Management**: Maven 3.x
- **Security**: BCrypt (`jbcrypt`) for password hashing
- **Data Transfer / AJAX**: Google Gson (for dashboard statistics and dynamic updates)
- **Frontend & Design**: HTML5, CSS3 (Custom styles), and responsive layouts

---

## 📂 Project Directory Structure

```text
OnlineExamSystem/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── exam/
│       │           ├── controller/     # Servlets handling requests (Admin, Exam, Student)
│       │           ├── dao/            # Data Access Objects using Hibernate Session
│       │           ├── filter/         # Authentication and authorization filters
│       │           ├── model/          # Hibernate Entity Models (Student, Exam, Result, etc.)
│       │           └── util/           # Database configuration utilities (HibernateUtil)
│       ├── resources/
│       │   └── hibernate.cfg.xml       # Hibernate XML configuration (DB connection details)
│       └── webapp/
│           ├── WEB-INF/                # Deployment descriptors
│           ├── admin/                  # Admin-specific JSP views (dashboards, CRUD interfaces)
│           ├── student/                # Student-specific JSP views (exams, dashboard, results)
│           ├── assets/
│           │   └── css/
│           │       └── styles.css      # Core application style sheet
│           ├── index.jsp               # Landing / Homepage
│           ├── login.jsp               # Main authentication page
│           └── register.jsp            # Student registration page
├── schema.sql                          # Database creation script and default seeds
├── pom.xml                             # Maven configuration and dependencies
└── LICENSE                             # License information
```

---

## ⚙️ Setup & Installation

### 1. Prerequisites
Ensure you have the following installed on your machine:
- **Java Development Kit (JDK) 21** or higher
- **Apache Maven 3.8+**
- **MySQL Server 8.0+**
- **Apache Tomcat 9.0+** (or any Servlet 4.0 compatible container)

### 2. Database Setup
1. Open your MySQL client (Command Line, Workbench, or DBeaver).
2. Execute the queries in `schema.sql` to set up the database:
   ```sql
   source path/to/schema.sql;
   ```
   *Note: This script automatically creates the `online_exam_db` database and seeds a default Admin account.*

### 3. Configure Hibernate
Open `src/main/resources/hibernate.cfg.xml` and verify the connection settings match your local environment:
```xml
<property name="hibernate.connection.url">jdbc:mysql://localhost:3306/online_exam_db?createDatabaseIfNotExist=true&amp;useSSL=false&amp;allowPublicKeyRetrieval=true</property>
<property name="hibernate.connection.username">your_mysql_username</property>
<property name="hibernate.connection.password">your_mysql_password</property>
```

### 4. Build & Package
Build the project using Maven to generate the `.war` deployment file:
```bash
mvn clean package
```
This will compile the sources and produce a package named `OnlineExamSystem.war` inside the `target/` directory.

### 5. Deployment
- Copy the generated `OnlineExamSystem.war` file from the `target/` directory.
- Paste it into the `webapps/` folder of your Apache Tomcat server installation.
- Start the Tomcat server.

---

## 🔑 Login Credentials

### Admin Module
- **Username**: `admin`
- **Password**: `admin123`

### Student Module
- Register a new student account using the **Register** link on the homepage.
- Use your registered email and password to log in.

---

## 📄 License
This project is licensed under the MIT License.
