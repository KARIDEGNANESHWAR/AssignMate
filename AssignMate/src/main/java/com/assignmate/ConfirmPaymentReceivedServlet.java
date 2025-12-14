package com.assignmate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ConfirmPaymentReceivedServlet")
public class ConfirmPaymentReceivedServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Integer writerId = (session != null) ? (Integer) session.getAttribute("writer_id") : null;

        if (writerId == null) {
            response.sendRedirect("writer_login.jsp");
            return;
        }

        String paymentChoice = request.getParameter("payment_received");
        if (paymentChoice == null || !paymentChoice.equals("yes")) {
            // User selected "No" or did not select anything → don't update
            response.sendRedirect("writer/accepted_assignments.jsp");
            return;
        }

        int assignmentId;
        try {
            assignmentId = Integer.parseInt(request.getParameter("assignment_id"));
        } catch (NumberFormatException e) {
            response.sendRedirect("writer/accepted_assignments.jsp");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE assignments SET writer_received_payment = TRUE " +
                 "WHERE id = ? AND accepted_writer_id = ? AND status = 'accepted'"
             )) {
            ps.setInt(1, assignmentId);
            ps.setInt(2, writerId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("writer/accepted_assignments.jsp");
    }
}
