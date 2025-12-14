package com.assignmate;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UserLoginServlet")
public class UserLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to login page if GET request
        response.sendRedirect(request.getContextPath() + "/user/user_login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DBConnection.getConnection()) {

                String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, email);
                    stmt.setString(2, password);

                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            //  No is_verified check here
                            HttpSession session = request.getSession();
                            session.setAttribute("user_id", rs.getInt("id"));
                            session.setAttribute("user_name", rs.getString("name"));
                            session.setAttribute("user_email", rs.getString("email"));
                            session.setAttribute("user_phone", rs.getString("phone"));
                            session.setAttribute("type", "user");

                            response.sendRedirect(request.getContextPath() + "/user/user_dashboard.jsp");
                            return;
                        }
                    }
                }
            }

            // Invalid credentials
            response.sendRedirect(request.getContextPath() + "/user/user_login.jsp?error=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/user_login.jsp?error=1");
        }
    }
}
