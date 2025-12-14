package com.assignmate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/DeleteAssignmentServlet")
public class DeleteAssignmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int assignmentId = Integer.parseInt(request.getParameter("assignment_id"));
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect("user/user_login.jsp");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            // Check if the assignment belongs to the user and is not accepted
            String checkSql = "SELECT status FROM assignments WHERE id = ? AND user_id = ?";
            try (PreparedStatement checkStmt = con.prepareStatement(checkSql)) {
                checkStmt.setInt(1, assignmentId);
                checkStmt.setInt(2, userId);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    String status = rs.getString("status");

                    if (!"public".equals(status)) {
                        response.getWriter().println("❌ Cannot delete. Assignment already accepted.");
                        return;
                    }
                } else {
                    response.getWriter().println("❌ Assignment not found or unauthorized.");
                    return;
                }
            }

            // First delete related writer requests
            try (PreparedStatement deleteRequests = con.prepareStatement(
                    "DELETE FROM writer_requests WHERE assignment_id = ?")) {
                deleteRequests.setInt(1, assignmentId);
                deleteRequests.executeUpdate();
            }

            // Then delete the assignment
            try (PreparedStatement deleteAssignment = con.prepareStatement(
                    "DELETE FROM assignments WHERE id = ? AND user_id = ?")) {
                deleteAssignment.setInt(1, assignmentId);
                deleteAssignment.setInt(2, userId);
                deleteAssignment.executeUpdate();
            }

            // Redirect back
            response.sendRedirect("user/view_assignments.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("user/view_assignments.jsp");
    }
}
