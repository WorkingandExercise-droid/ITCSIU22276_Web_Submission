<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));

    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    Connection conn = DriverManager.getConnection(
        "jdbc:sqlserver://localhost:1433;databaseName=student_management;encrypt=false;",
        "Web_focus_001",
        "kkkkkkkkkk11nenemb0"
    );

    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM students WHERE id=?");
    stmt.setInt(1, id);
    ResultSet rs = stmt.executeQuery();

    if (!rs.next()) {
        out.println("Student not found.");
        return;
    }

    String studentCode = rs.getString("student_code");
    String fullName = rs.getString("full_name");
    String email = rs.getString("email");
    String major = rs.getString("major");

    rs.close();
    stmt.close();
    conn.close();

    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Student</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        form { max-width: 500px; }
        input, select, button { width: 100%; padding: 8px; margin-bottom: 10px; }
        .message { padding: 10px; margin-bottom: 15px; border-radius: 4px; }
        .message.success { background-color: #d4edda; color: #155724; }
        .message.error { background-color: #f8d7da; color: #721c24; }
    </style>
</head>
<body>

<h2>Edit Student</h2>

<!-- Success/Error Messages -->
<% if (error != null) { %>
    <div class="message error">✗ <%= error %></div>
<% } else if (success != null) { %>
    <div class="message success">✓ <%= success %></div>
<% } %>

<form action="process_edit.jsp" method="POST" onsubmit="return submitForm(this)">
    <input type="hidden" name="id" value="<%= id %>">

    <label>Student Code:</label>
    <input type="text" name="student_code" value="<%= studentCode %>" required>

    <label>Full Name:</label>
    <input type="text" name="full_name" value="<%= fullName %>" required>

    <label>Email:</label>
    <input type="email" name="email" value="<%= email != null ? email : "" %>">

    <label>Major:</label>
    <input type="text" name="major" value="<%= major %>">

    <button type="submit">Update Student</button>
</form>

<script>
// Auto-hide messages after 3 seconds
setTimeout(function() {
    var messages = document.querySelectorAll('.message');
    messages.forEach(function(msg) {
        msg.style.display = 'none';
    });
}, 3000);

// Disable submit button + show Processing...
function submitForm(form) {
    var btn = form.querySelector('button[type="submit"]');
    btn.disabled = true;
    btn.textContent = 'Processing...';
    return true;
}
</script>

</body>
</html>
