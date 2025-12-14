package com.assignmate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ReopenAssignmentServlet")
public class ReopenAssignmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int assignmentId = Integer.parseInt(request.getParameter("assignment_id"));
        System.out.println("🛠️ Reopening assignment: " + assignmentId);  // debug print

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false); // Begin transaction

            try {
                // 1. Update assignment
                String updateAssignment = "UPDATE assignments SET status = 'public', accepted_writer_id = NULL WHERE id = ? AND status = 'accepted'";
                try (PreparedStatement ps = con.prepareStatement(updateAssignment)) {
                    ps.setInt(1, assignmentId);
                    int rows = ps.executeUpdate();
                    System.out.println("🛠️ Rows updated: " + rows);  // debug

                    if (rows == 0) {
                        throw new Exception("Assignment not found or not in accepted state.");
                    }
                }

                // 2. Delete writer requests
                String deleteSql = "DELETE FROM writer_requests WHERE assignment_id = ?";
                try (PreparedStatement ps = con.prepareStatement(deleteSql)) {
                    ps.setInt(1, assignmentId);
                    int deleted = ps.executeUpdate();
                    System.out.println("🛠️ Writer requests deleted: " + deleted);  // debug
                }

                con.commit();
                request.getSession().setAttribute("success", "Assignment reopened.");
                response.sendRedirect("user/accepted_writers.jsp");

            } catch (Exception ex) {
                con.rollback();
                ex.printStackTrace();
                request.getSession().setAttribute("error", "Reopen failed: " + ex.getMessage());
                response.sendRedirect("user/accepted_writers.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
