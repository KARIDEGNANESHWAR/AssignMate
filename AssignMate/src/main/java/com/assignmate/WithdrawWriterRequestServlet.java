package com.assignmate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/WithdrawWriterRequestServlet")
public class WithdrawWriterRequestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestIdStr = request.getParameter("request_id");

        if (requestIdStr == null) {
            response.getWriter().println("❌ Missing request_id");
            return;
        }

        int requestId = Integer.parseInt(requestIdStr);

        try (Connection con = DBConnection.getConnection()) {
            // Only delete if request is still pending
            String sql = "DELETE FROM writer_requests WHERE id = ? AND status = 'pending'";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, requestId);
                int rows = ps.executeUpdate();

                if (rows > 0) {
                    response.sendRedirect("writer/public_assignments.jsp");
                } else {
                    response.getWriter().println(" Cannot withdraw: already accepted or rejected.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Error: " + e.getMessage());
        }
    }
}
