package com.assignmate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/UserVerifyEmailServlet")
public class UserVerifyEmailServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");

        String enteredOtp = request.getParameter("otp");

        HttpSession session = request.getSession();
        String sessionOtp = (String) session.getAttribute("otp");

        if (enteredOtp == null || sessionOtp == null) {
            response.sendRedirect("user/verify_email.jsp?error=missing");
            return;
        }

        if (!enteredOtp.equals(sessionOtp)) {
            response.sendRedirect("user/verify_email.jsp?error=invalid");
            return;
        }

        // OTP is valid — insert into DB
        String name = (String) session.getAttribute("name");
        String email = (String) session.getAttribute("email");
        String phone = (String) session.getAttribute("phone");
        String password = (String) session.getAttribute("password");

        try (Connection conn = DBConnection.getConnection()) {
            // Check if user already exists (optional safety)
            PreparedStatement checkStmt = conn.prepareStatement("SELECT id FROM users WHERE email = ?");
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                response.sendRedirect("user/user_login.jsp?msg=already_registered");
                return;
            }

            // Insert now
            String sql = "INSERT INTO users (name, email, phone, password, is_verified) VALUES (?, ?, ?, ?, true)";
            PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, password);
            stmt.executeUpdate();

            ResultSet generatedKeys = stmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                int userId = generatedKeys.getInt(1);

                // Start session
                session.setAttribute("user_id", userId);
                session.setAttribute("user_name", name);
            }

            // Cleanup
            session.removeAttribute("otp");
            session.removeAttribute("name");
            session.removeAttribute("email");
            session.removeAttribute("phone");
            session.removeAttribute("password");

            response.sendRedirect("user/user_login.jsp?msg=verified");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user/verify_email.jsp?error=server");
        }
    }
}
