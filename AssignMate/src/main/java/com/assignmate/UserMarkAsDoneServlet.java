package com.assignmate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/UserMarkAsDoneServlet")
public class UserMarkAsDoneServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int assignmentId = Integer.parseInt(request.getParameter("assignment_id"));
        int writerId = Integer.parseInt(request.getParameter("writer_id"));
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("../user_login.jsp");
            return;
        }

        if (ratingStr == null || ratingStr.isEmpty()) {
            response.sendRedirect("user/accepted_writers.jsp");
            return;
        }

        int rating = Integer.parseInt(ratingStr);

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            boolean writerConfirmed = false;
            boolean userAlreadyDone = false;

            try (PreparedStatement check = con.prepareStatement(
                    "SELECT writer_marked_done, writer_received_payment, user_marked_done, user_received_assignment FROM assignments WHERE id = ? AND user_id = ?")) {
                check.setInt(1, assignmentId);
                check.setInt(2, userId);
                ResultSet rs = check.executeQuery();
                if (rs.next()) {
                    writerConfirmed = rs.getBoolean("writer_received_payment");
                    boolean writerDone = rs.getBoolean("writer_marked_done");
                    userAlreadyDone = rs.getBoolean("user_marked_done");
                    boolean userReceived = rs.getBoolean("user_received_assignment");

                    if (!writerConfirmed || !userReceived) {
                        response.sendRedirect("user/accepted_writers.jsp");
                        return;
                    }

                    if (userAlreadyDone) {
                        response.sendRedirect("user/accepted_writers.jsp");
                        return;
                    }

                    // Step 1: Insert feedback
                    try (PreparedStatement feedback = con.prepareStatement(
                            "INSERT INTO feedback (assignment_id, writer_id, rating, comment) VALUES (?, ?, ?, ?)");) {
                        feedback.setInt(1, assignmentId);
                        feedback.setInt(2, writerId);
                        feedback.setInt(3, rating);
                        feedback.setString(4, comment != null ? comment.trim() : "");
                        feedback.executeUpdate();
                    }

                    // Step 2: Mark user done
                    try (PreparedStatement update = con.prepareStatement(
                            "UPDATE assignments SET user_marked_done = 1 WHERE id = ?")) {
                        update.setInt(1, assignmentId);
                        update.executeUpdate();
                    }

                    // Step 3: If writer already done, update status
                    if (writerDone) {
                        try (PreparedStatement updateStatus = con.prepareStatement(
                                "UPDATE assignments SET status = 'done', done_at = NOW() WHERE id = ?")) {
                            updateStatus.setInt(1, assignmentId);
                            updateStatus.executeUpdate();
                        }
                    }
                }
            }

            con.commit();
        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
        } finally {
            if (con != null) try { con.close(); } catch (Exception ignored) {}
        }

        response.sendRedirect("user/accepted_writers.jsp");
    }
}
