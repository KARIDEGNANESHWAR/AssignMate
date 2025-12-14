package com.assignmate;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/WriterLoginServlet")
public class WriterLoginServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("writer/writer_login.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "SELECT * FROM writers WHERE email = ? AND password = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, email);
                    stmt.setString(2, password);

                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            HttpSession session = request.getSession();
                            session.setAttribute("writer_id", rs.getInt("id"));
                            session.setAttribute("writer_name", rs.getString("name"));
                            session.setAttribute("writer_email", rs.getString("email"));
                            session.setAttribute("writer_phone", rs.getString("phone"));
                            session.setAttribute("type", "writer");

                            response.sendRedirect("writer/writer_dashboard.jsp");
                        } else {
                            response.sendRedirect("writer/writer_login.jsp?error=1");
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("writer/writer_login.jsp?error=1");
        }
    }
}
