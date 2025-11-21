<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
int id = Integer.parseInt(request.getParameter("id"));
String studentCode = request.getParameter("student_code");
String fullName = request.getParameter("full_name");
String email = request.getParameter("email");
String major = request.getParameter("major");

// =====================
// VALIDATION
// =====================

if (studentCode == null || !studentCode.matches("[A-Z]{2}[0-9]{3,}")) {
    response.sendRedirect("edit_student.jsp?id=" + id + "&error=Invalid student code format");
    return;
}

if (email != null && !email.trim().isEmpty()) {
    if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
        response.sendRedirect("edit_student.jsp?id=" + id + "&error=Invalid email format");
        return;
    }
}

// =====================
// MSSQL CONNECTION
// =====================
Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
Connection conn = DriverManager.getConnection(
    "jdbc:sqlserver://localhost:1433;databaseName=student_management;encrypt=false;",
    "Web_focus_001",
    "1"
);

String sql = "UPDATE students SET student_code=?, full_name=?, email=?, major=? WHERE id=?";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setString(1, studentCode);
stmt.setString(2, fullName);
stmt.setString(3, email);
stmt.setString(4, major);
stmt.setInt(5, id);

stmt.executeUpdate();
stmt.close();
conn.close();

// Redirect
response.sendRedirect("list_students.jsp");
%>
