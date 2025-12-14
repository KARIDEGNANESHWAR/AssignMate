package com.assignmate;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ConfirmAssignmentReceivedServlet")
public class ConfirmAssignmentReceivedServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("user_id") : null;

        if (userId == null) {
            response.sendRedirect("user_login.jsp");
            return;
        }

        String assignmentIdStr = request.getParameter("assignment_id");

        int assignmentId;
        try {
            assignmentId = Integer.parseInt(assignmentIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("user/accepted_writers.jsp");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE assignments SET user_received_assignment = TRUE WHERE id = ? AND user_id = ?")) {
            ps.setInt(1, assignmentId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("user/accepted_writers.jsp");
    }
}
