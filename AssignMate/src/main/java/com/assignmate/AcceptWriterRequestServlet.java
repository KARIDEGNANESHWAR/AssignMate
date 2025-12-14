package com.assignmate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/AcceptWriterRequestServlet")
public class AcceptWriterRequestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestIdStr = request.getParameter("request_id");

        if (requestIdStr == null) {
            response.getWriter().println("❌ Missing request_id");
            return;
        }

        int requestId = Integer.parseInt(requestIdStr);

        try (Connection con = DBConnection.getConnection()) {

            // 1. Get writer_id and assignment_id from writer_requests
            int writerId = -1;
            int assignmentId = -1;
            String selectSQL = "SELECT writer_id, assignment_id FROM writer_requests WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(selectSQL)) {
                ps.setInt(1, requestId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    writerId = rs.getInt("writer_id");
                    assignmentId = rs.getInt("assignment_id");
                } else {
                    response.getWriter().println("❌ Invalid request ID.");
                    return;
                }
            }

            // 2. Update assignment: set status to 'accepted' and store writer ID
            String updateAssignmentSQL = "UPDATE assignments SET status = 'accepted', accepted_writer_id = ? WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(updateAssignmentSQL)) {
                ps.setInt(1, writerId);
                ps.setInt(2, assignmentId);
                ps.executeUpdate();
            }

            // 3. Set selected request to 'accepted'
            try (PreparedStatement ps = con.prepareStatement(
                    "UPDATE writer_requests SET status = 'accepted' WHERE id = ?")) {
                ps.setInt(1, requestId);
                ps.executeUpdate();
            }

            // 4. Set all other requests for this assignment to 'rejected'
            try (PreparedStatement ps = con.prepareStatement(
                    "UPDATE writer_requests SET status = 'rejected' WHERE assignment_id = ? AND id != ?")) {
                ps.setInt(1, assignmentId);
                ps.setInt(2, requestId);
                ps.executeUpdate();
            }

            // ✅ Done. Redirect
            response.sendRedirect("user/view_assignments.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Error: " + e.getMessage());
        }
    }
}
