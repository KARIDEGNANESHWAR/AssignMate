package com.assignmate;

import com.assignmate.util.EmailSender;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/UserForgotPasswordServlet")
public class UserForgotPasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        String otp = String.valueOf((int) (Math.random() * 900000 + 100000)); // 6-digit OTP

        try (Connection conn = DBConnection.getConnection()) {
            // Check if email exists
            PreparedStatement checkStmt = conn.prepareStatement("SELECT id FROM users WHERE email = ?");
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();
            if (!rs.next()) {
                response.sendRedirect("user/forgot_password.jsp?error=not_found");
                return;
            }

            // Update OTP in DB
            PreparedStatement updateStmt = conn.prepareStatement("UPDATE users SET verification_code = ? WHERE email = ?");
            updateStmt.setString(1, otp);
            updateStmt.setString(2, email);
            updateStmt.executeUpdate();

            // Send OTP
            EmailSender.sendVerificationEmail(email, otp);

            // Store email in session
            HttpSession session = request.getSession();
            session.setAttribute("reset_user_email", email);
            response.sendRedirect("user/reset_password.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user/forgot_password.jsp?error=server");
        }
    }
}
