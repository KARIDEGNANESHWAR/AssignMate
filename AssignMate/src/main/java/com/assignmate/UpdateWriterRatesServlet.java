package com.assignmate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/UpdateWriterRatesServlet")
public class UpdateWriterRatesServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer writerId = (Integer) session.getAttribute("writer_id");

        if (writerId == null) {
            response.sendRedirect("writer/writer_login.jsp");
            return;
        }

        int rateAssignment = Integer.parseInt(request.getParameter("rate_assignment_page"));
        int rateRecord = Integer.parseInt(request.getParameter("rate_record_page"));
        int rateDiagram = Integer.parseInt(request.getParameter("rate_per_diagram"));

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE writers SET rate_assignment_page = ?, rate_record_page = ?, rate_per_diagram = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, rateAssignment);
            stmt.setInt(2, rateRecord);
            stmt.setInt(3, rateDiagram);
            stmt.setInt(4, writerId);

            stmt.executeUpdate();
            response.sendRedirect("writer/set_rates.jsp?msg=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("writer/set_rates.jsp?msg=error");
        }
    }
}
