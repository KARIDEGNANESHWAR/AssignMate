package com.assignmate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/writer/RequestAssignmentServlet")
public class RequestAssignmentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("writer_id") == null) {
            response.sendRedirect(request.getContextPath() + "/writer_login.jsp");
            return;
        }

        Integer writerId = (Integer) session.getAttribute("writer_id");

        String assignmentIdStr = request.getParameter("assignmentId");
        int assignmentId;

        if (assignmentIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/writer/public_assignments.jsp?message=Invalid assignment.");
            return;
        }

        try {
            assignmentId = Integer.parseInt(assignmentIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/writer/public_assignments.jsp?message=Invalid assignment ID.");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Check if request already exists
            String checkSql = "SELECT COUNT(*) FROM writer_requests WHERE writer_id = ? AND assignment_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, writerId);
                ps.setInt(2, assignmentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        response.sendRedirect(request.getContextPath() + "/writer/public_assignments.jsp?message=Already requested.");
                        return;
                    }
                }
            }

            // Insert new request
            String insertSql = "INSERT INTO writer_requests(writer_id, assignment_id, status) VALUES (?, ?, 'pending')";
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, writerId);
                ps.setInt(2, assignmentId);
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect(request.getContextPath() + "/writer/public_assignments.jsp?message=Request sent successfully.");
                } else {
                    response.sendRedirect(request.getContextPath() + "/writer/public_assignments.jsp?message=Request failed.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/writer/public_assignments.jsp?message=Error occurred.");
        }
    }
}
