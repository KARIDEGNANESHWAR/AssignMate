package com.assignmate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/WriterVerifyEmailServlet")
public class WriterVerifyEmailServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");

        String enteredOtp = request.getParameter("otp");

        HttpSession session = request.getSession();
        String sessionOtp = (String) session.getAttribute("otp");

        if (enteredOtp == null || sessionOtp == null || !enteredOtp.equals(sessionOtp)) {
            response.sendRedirect("writer/verify_email.jsp?error=invalid");
            return;
        }

        // Fetch stored data
        String name = (String) session.getAttribute("writer_name");
        String email = (String) session.getAttribute("writer_email");
        String phone = (String) session.getAttribute("writer_phone");
        String password = (String) session.getAttribute("writer_password");
        String sampleFile = (String) session.getAttribute("writer_sample_file");
        int rateAssignment = (int) session.getAttribute("rate_assignment");
        int rateRecord = (int) session.getAttribute("rate_record");
        int rateDiagram = (int) session.getAttribute("rate_diagram");

        try (Connection conn = DBConnection.getConnection()) {
            // Final insert
            String sql = "INSERT INTO writers (name, email, phone, password, sample_file, is_verified, rate_assignment_page, rate_record_page, rate_per_diagram) VALUES (?, ?, ?, ?, ?, TRUE, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, password);
            stmt.setString(5, sampleFile);
            stmt.setInt(6, rateAssignment);
            stmt.setInt(7, rateRecord);
            stmt.setInt(8, rateDiagram);
            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                int writerId = rs.getInt(1);
                session.setAttribute("writer_id", writerId);
                session.setAttribute("writer_name", name);
            }

            // Cleanup
            session.removeAttribute("otp");
            session.removeAttribute("writer_name");
            session.removeAttribute("writer_email");
            session.removeAttribute("writer_phone");
            session.removeAttribute("writer_password");
            session.removeAttribute("writer_sample_file");
            session.removeAttribute("rate_assignment");
            session.removeAttribute("rate_record");
            session.removeAttribute("rate_diagram");

            response.sendRedirect("writer/writer_login.jsp?msg=verified");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("writer/verify_email.jsp?error=server");
        }
    }
}
