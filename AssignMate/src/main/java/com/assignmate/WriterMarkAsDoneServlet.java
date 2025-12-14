package com.assignmate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/WriterMarkAsDoneServlet")
public class WriterMarkAsDoneServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int assignmentId = Integer.parseInt(request.getParameter("assignment_id"));

        HttpSession session = request.getSession();
        Integer writerId = (Integer) session.getAttribute("writer_id");
        if (writerId == null) {
            response.sendRedirect("../writer_login.jsp");
            return;
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            boolean userConfirmed = false;
            boolean writerAlreadyDone = false;

            try (PreparedStatement check = con.prepareStatement(
                    "SELECT user_received_assignment, user_marked_done, writer_marked_done FROM assignments WHERE id = ? AND accepted_writer_id = ?")) {
                check.setInt(1, assignmentId);
                check.setInt(2, writerId);
                ResultSet rs = check.executeQuery();
                if (rs.next()) {
                    userConfirmed = rs.getBoolean("user_received_assignment");
                    boolean userDone = rs.getBoolean("user_marked_done");
                    writerAlreadyDone = rs.getBoolean("writer_marked_done");

                    if (!userConfirmed) {
                        response.sendRedirect("writer/accepted_assignments.jsp");
                        return;
                    }

                    // If already marked done, don't mark again
                    if (writerAlreadyDone) {
                        response.sendRedirect("writer/accepted_assignments.jsp");
                        return;
                    }

                    // Mark writer as done
                    try (PreparedStatement update = con.prepareStatement(
                            "UPDATE assignments SET writer_received_payment = 1, writer_marked_done = 1 WHERE id = ?")) {
                        update.setInt(1, assignmentId);
                        update.executeUpdate();
                    }

                    // If user already marked done, mark assignment status as done
                    if (userDone) {
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

        response.sendRedirect("writer/accepted_assignments.jsp");
    }
}