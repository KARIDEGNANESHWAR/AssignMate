package com.assignmate;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/WriterChatSendServlet")
public class WriterChatSendServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Integer writerId = (session != null) ? (Integer) session.getAttribute("writer_id") : null;

        if (writerId == null) {
            response.sendRedirect("writer_login.jsp");
            return;
        }

        int receiverId = Integer.parseInt(request.getParameter("receiver_id"));
        int assignmentId = Integer.parseInt(request.getParameter("assignment_id"));
        String message = request.getParameter("message");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "INSERT INTO messages (sender_id, receiver_id, sender_type, receiver_type, content, assignment_id) VALUES (?, ?, ?, ?, ?, ?)")) {

            ps.setInt(1, writerId);
            ps.setInt(2, receiverId);
            ps.setString(3, "writer");
            ps.setString(4, "user");
            ps.setString(5, message);
            ps.setInt(6, assignmentId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
