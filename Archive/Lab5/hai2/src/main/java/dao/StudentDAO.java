package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Student;

public class StudentDAO {

    private String jdbcURL = "jdbc:sqlserver://localhost:1433;databaseName=student_management;encrypt=true;trustServerCertificate=true";
    private String jdbcUsername = "Web_focus_001";
    private String jdbcPassword = "kkkkkkkkkk11nenemb0";

    private static final String INSERT_STUDENT_SQL =
            "INSERT INTO students (student_code, full_name, email, major) VALUES (?, ?, ?, ?)";
    private static final String SELECT_STUDENT_BY_ID =
            "SELECT * FROM students WHERE id = ?";
    private static final String UPDATE_STUDENT_SQL =
            "UPDATE students SET student_code = ?, full_name = ?, email = ?, major = ? WHERE id = ?";
    private static final String DELETE_STUDENT_SQL =
            "DELETE FROM students WHERE id = ?";

    public StudentDAO() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver"); 
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public void addStudent(Student student) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_STUDENT_SQL)) {

            ps.setString(1, student.getStudentCode());
            ps.setString(2, student.getFullName());
            ps.setString(3, student.getEmail());
            ps.setString(4, student.getMajor());
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Student getStudentById(int id) {
        Student student = null;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_STUDENT_BY_ID)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    student = new Student(
                            id,
                            rs.getString("student_code"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            rs.getString("major")
                    );
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return student;
    }

    public void updateStudent(Student student) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_STUDENT_SQL)) {

            ps.setString(1, student.getStudentCode());
            ps.setString(2, student.getFullName());
            ps.setString(3, student.getEmail());
            ps.setString(4, student.getMajor());
            ps.setInt(5, student.getId());
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteStudent(int id) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_STUDENT_SQL)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ======================== Search ========================
    public List<Student> searchStudents(String keyword) {
        List<Student> students = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllStudents();
        }

        String sql = "SELECT * FROM students " +
                     "WHERE student_code LIKE ? OR full_name LIKE ? OR email LIKE ? " +
                     "ORDER BY id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    students.add(new Student(
                            rs.getInt("id"),
                            rs.getString("student_code"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            rs.getString("major")
                    ));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    /**
     * Paginated search across 3 columns: student_code, full_name, email
     */
    public List<Student> searchStudents(String keyword, int offset, int limit) {
        List<Student> students = new ArrayList<>();
        String sql;

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql = "SELECT * FROM students " +
                  "WHERE student_code LIKE ? OR full_name LIKE ? OR email LIKE ? " +
                  "ORDER BY id DESC " +
                  "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        } else {
            sql = "SELECT * FROM students " +
                  "ORDER BY id DESC " +
                  "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (keyword != null && !keyword.trim().isEmpty()) {
                String pattern = "%" + keyword + "%";
                ps.setString(1, pattern);
                ps.setString(2, pattern);
                ps.setString(3, pattern);
                ps.setInt(4, offset);
                ps.setInt(5, limit);
            } else {
                ps.setInt(1, offset);
                ps.setInt(2, limit);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    students.add(new Student(
                            rs.getInt("id"),
                            rs.getString("student_code"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            rs.getString("major")
                    ));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    // ======================== Pagination Count ========================

    public int countStudents(String keyword) {
        String sql;
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql = "SELECT COUNT(*) FROM students " +
                  "WHERE student_code LIKE ? OR full_name LIKE ? OR email LIKE ?";
        } else {
            sql = "SELECT COUNT(*) FROM students";
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (keyword != null && !keyword.trim().isEmpty()) {
                String pattern = "%" + keyword + "%";
                ps.setString(1, pattern);
                ps.setString(2, pattern);
                ps.setString(3, pattern);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                students.add(new Student(
                        rs.getInt("id"),
                        rs.getString("student_code"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("major")
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }
}
