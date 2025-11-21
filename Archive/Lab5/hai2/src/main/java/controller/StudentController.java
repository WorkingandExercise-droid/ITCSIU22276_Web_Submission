package controller;

import dao.StudentDAO;
import model.Student;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/student")
public class StudentController extends HttpServlet {

    private StudentDAO studentDAO;
    private static final int STUDENTS_PER_PAGE = 5;

    @Override
    public void init() {
        studentDAO = new StudentDAO(); 
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                listStudents(request, response);
                break;
            case "new":
                showForm(request, response, "/WEB-INF/views/add_student.jsp", null);
                break;
            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                Student existing = studentDAO.getStudentById(id);
                showForm(request, response, "/WEB-INF/views/edit_student.jsp", existing);
                break;
            case "delete":
                deleteStudent(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        switch (action) {
            case "insert":
                insertStudent(request, response);
                break;
            case "update":
                updateStudent(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ====== Methods ======

    private void listStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        if (keyword == null) keyword = "";

        int page = 1;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception ignored) {}

        int offset = (page - 1) * STUDENTS_PER_PAGE;

        int totalStudents = studentDAO.countStudents(keyword);
        int totalPages = (int) Math.ceil((double) totalStudents / STUDENTS_PER_PAGE);

        List<Student> students = studentDAO.searchStudents(keyword, offset, STUDENTS_PER_PAGE);

        request.setAttribute("students", students);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);

        RequestDispatcher dispatcher =
                request.getRequestDispatcher("/WEB-INF/views/list_students.jsp");
        dispatcher.forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, String jspPath, Student student)
            throws ServletException, IOException {
        if (student != null) request.setAttribute("student", student);
        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
        dispatcher.forward(request, response);
    }

    private void insertStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String code = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");

        Student s = new Student(0, code, fullName, email, major);
        studentDAO.addStudent(s);
        response.sendRedirect(request.getContextPath() + "/student?action=list");
    }

    private void updateStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String code = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");

        Student s = new Student(id, code, fullName, email, major);
        studentDAO.updateStudent(s);
        response.sendRedirect(request.getContextPath() + "/student?action=list");
    }

    private void deleteStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        studentDAO.deleteStudent(id);
        response.sendRedirect(request.getContextPath() + "/student?action=list");
    }
}
