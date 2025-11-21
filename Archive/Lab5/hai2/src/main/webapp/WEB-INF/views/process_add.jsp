<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String studentCode = request.getParameter("student_code");
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");
    String major = request.getParameter("major");

    // ============================
    // 1. VALIDATIONS
    // ============================

    if (studentCode == null || studentCode.trim().isEmpty() ||
        fullName == null || fullName.trim().isEmpty()) {
        response.sendRedirect("add_student.jsp?error=Student Code and Full Name are required");
    } else if (!studentCode.matches("^[A-Z]{2}[0-9]{3,}$")) {
        response.sendRedirect("add_student.jsp?error=Invalid Student Code format (e.g., SV001)");
    } else if (email != null && !email.trim().isEmpty() &&
               !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
        response.sendRedirect("add_student.jsp?error=Invalid email format");
    } else {
        // ============================
        // 2. DATABASE INSERT
        // ============================
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection(
                "jdbc:sqlserver://localhost:1433;databaseName=student_management;encrypt=false;",
                "Web_focus_001",
                "kkkkkkkkkk11nenemb0"
            );

            String sql = "INSERT INTO students (student_code, full_name, email, major) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentCode);
            pstmt.setString(2, fullName);
            pstmt.setString(3, email != null ? email : "");
            pstmt.setString(4, major != null ? major : "");

            pstmt.executeUpdate();
            pstmt.close();
            conn.close();

            response.sendRedirect("add_student.jsp?success=Student added successfully");

        } catch (SQLIntegrityConstraintViolationException e) {
            // Duplicate student code
            response.sendRedirect("add_student.jsp?error=Student Code already exists");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("add_student.jsp?error=Error adding student");
        }
    }
%>
