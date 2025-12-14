package com.assignmate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/UserChatFetchServlet")
public class UserChatFetchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int assignmentId = Integer.parseInt(request.getParameter("assignment_id"));
        response.setContentType("application/json");
        JSONArray messages = new JSONArray();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM messages WHERE assignment_id = ? ORDER BY timestamp ASC")) {
            ps.setInt(1, assignmentId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                JSONObject msg = new JSONObject();
                msg.put("sender_type", rs.getString("sender_type"));
                msg.put("content", rs.getString("content"));
                msg.put("timestamp", rs.getString("timestamp"));
                messages.put(msg);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        PrintWriter out = response.getWriter();
        out.print(messages);
        out.flush();
    }
}
