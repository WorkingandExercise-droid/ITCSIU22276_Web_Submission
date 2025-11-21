<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Student" %>
<%@ page import="java.util.List" %>

<%
    List<Student> students = (List<Student>) request.getAttribute("students");
    int currentPage = (Integer) request.getAttribute("currentPage");
    int totalPages = (Integer) request.getAttribute("totalPages");
    String keyword = (String) request.getAttribute("keyword");
%>

<!DOCTYPE html>
<html>
<head>
<title>Student List</title>
<style>
/* your previous CSS */
</style>
</head>
<body>
<h2>Student List</h2>

<!-- Add/Search -->
<a href="<%= request.getContextPath() %>/student?action=new">+ Add Student</a>
<form action="<%= request.getContextPath() %>/student" method="GET">
    <input type="hidden" name="action" value="list">
    <input type="text" name="keyword" value="<%= keyword != null ? keyword : "" %>" placeholder="Search...">
    <button type="submit">Search</button>
</form>

<table border="1">
<tr>
<th>ID</th><th>Code</th><th>Name</th><th>Email</th><th>Major</th><th>Action</th>
</tr>
<% for (Student s : students) { %>
<tr>
<td><%= s.getId() %></td>
<td><%= s.getStudentCode() %></td>
<td><%= s.getFullName() %></td>
<td><%= s.getEmail() %></td>
<td><%= s.getMajor() %></td>
<td>
<a href="<%= request.getContextPath() %>/student?action=edit&id=<%= s.getId() %>">Edit</a>
|
<a href="<%= request.getContextPath() %>/student?action=delete&id=<%= s.getId() %>"
   onclick="return confirm('Delete?');">Delete</a>
</td>
</tr>
<% } %>
</table>

<!-- Pagination -->
<%
    String base = request.getContextPath() + "/student?action=list";
    if (keyword != null && !keyword.trim().isEmpty()) base += "&keyword=" + keyword;
    for (int i = 1; i <= totalPages; i++) {
        if (i == currentPage) { %>
            <strong><%= i %></strong>
<%      } else { %>
            <a href="<%= base + "&page=" + i %>"><%= i %></a>
<%      }
    }
%>

</body>
</html>
