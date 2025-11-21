<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
String error = request.getParameter("error");
String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Student</title>
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

<h2>Add Student</h2>

<!-- Success/Error Messages -->
<% if (error != null) { %>
    <div class="message error">✗ <%= error %></div>
<% } else if (success != null) { %>
    <div class="message success">✓ <%= success %></div>
<% } %>

<form action="<%= request.getContextPath() %>/student?action=insert" method="POST" onsubmit="return submitForm(this)">
    <label>Student Code:</label>
    <input type="text" name="studentCode" required>

    <label>Full Name:</label>
    <input type="text" name="fullName" required>

    <label>Email:</label>
    <input type="email" name="email">

    <label>Major:</label>
    <input type="text" name="major">

    <button type="submit">Add Student</button>
</form>

<script>
// Auto-hide messages after 3 seconds
setTimeout(function() {
    var messages = document.querySelectorAll('.message');
    messages.forEach(function(msg) {
        msg.style.display = 'none';
    });
}, 3000);

function submitForm(form) {
    var btn = form.querySelector('button[type="submit"]');
    btn.disabled = true;
    btn.textContent = 'Processing...';
    return true;
}
</script>

</body>
</html>
