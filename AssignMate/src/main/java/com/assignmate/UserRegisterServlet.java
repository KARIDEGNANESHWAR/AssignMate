package com.assignmate;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.assignmate.util.EmailSender; // You must create this utility class (explained below)

@WebServlet("/UserRegisterServlet")
public class UserRegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        String otp = String.valueOf((int)(Math.random() * 900000) + 100000); // 6-digit OTP

        try {
            // Send OTP via email
            EmailSender.sendVerificationEmail(email, otp);

            // Store user details and OTP temporarily in session
            HttpSession session = request.getSession();
            session.setAttribute("otp", otp);
            session.setAttribute("name", name);
            session.setAttribute("email", email);
            session.setAttribute("phone", phone);
            session.setAttribute("password", password);

            response.sendRedirect("user/verify_email.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user/user_register.jsp?error=server");
        }
    }
}
