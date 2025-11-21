<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String idParam = request.getParameter("id");

    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect("list_students.jsp?error=Invalid student ID");
        return;
    }

    int studentId = Integer.parseInt(idParam);

    try {
        // Connect to MSSQL
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:sqlserver://localhost:1433;databaseName=student_management;encrypt=false;",
            "Web_focus_001",
            "kkkkkkkkkk11nenemb0"
        );

        // Delete student
        String sql = "DELETE FROM students WHERE id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, studentId);

        int affectedRows = pstmt.executeUpdate();

        pstmt.close();
        conn.close();

        if (affectedRows > 0) {
            response.sendRedirect("list_students.jsp?success=Student deleted successfully");
        } else {
            response.sendRedirect("list_students.jsp?error=Student not found");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("list_students.jsp?error=Error deleting student: " + e.getMessage());
    }
%>
