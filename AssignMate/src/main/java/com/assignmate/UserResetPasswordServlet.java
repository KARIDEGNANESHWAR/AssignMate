package com.assignmate;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/UserResetPasswordServlet")
public class UserResetPasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("new_password");

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT verification_code FROM users WHERE email = ?");
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String correctOtp = rs.getString("verification_code");
                if (otp.equals(correctOtp)) {
                    // Update password
                    PreparedStatement updateStmt = conn.prepareStatement("UPDATE users SET password = ? WHERE email = ?");
                    updateStmt.setString(1, newPassword);
                    updateStmt.setString(2, email);
                    updateStmt.executeUpdate();

                    // Clear session
                    request.getSession().removeAttribute("reset_user_email");
                    response.sendRedirect("user/user_login.jsp?msg=reset_success");
                } else {
                    response.sendRedirect("user/reset_password.jsp?error=invalid");
                }
            } else {
                response.sendRedirect("user/reset_password.jsp?error=not_found");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user/reset_password.jsp?error=server");
        }
    }
}
