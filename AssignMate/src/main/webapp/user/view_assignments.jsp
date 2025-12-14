<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("user_login.jsp");
        return;
    }

    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="refresh" content="15">  

    <title>My Uploaded Assignments</title>
    <link rel="stylesheet" href="../css/uploaded_assignments.css">
</head>
<body class="bg-img">
<div class="overlay">
    <div class="assign-container">
        <h2 class="glow-title">My Uploaded Assignments</h2>

        <% if (success != null) { %>
            <div class="success-msg"><%= success %></div>
        <% } %>
        <% if (error != null) { %>
            <div class="error-msg"><%= error %></div>
        <% } %>

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AssignMate", "root", "mysql");
        String sql = "SELECT * FROM assignments WHERE user_id = ? AND status = 'public'";
        ps = con.prepareStatement(sql);
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        boolean hasAssignments = false;
        while (rs.next()) {
            hasAssignments = true;
%>
        <div class="assignment-box">
            <p><strong>ID:</strong> <%= rs.getInt("id") %></p>
            <p><strong>Description:</strong> <%= rs.getString("description") %></p>
            <p><strong>Deadline:</strong> <%= rs.getString("deadline") %></p>
            <p><strong>Status:</strong> <%= rs.getString("status") %></p>

            <form action="../DeleteAssignmentServlet" method="post">
                <input type="hidden" name="assignment_id" value="<%= rs.getInt("id") %>">
                <button type="submit" class="danger-btn" onclick="return confirm('Delete this assignment?');">Delete</button>
            </form>

            <h4>Writer Requests:</h4>
<%
            PreparedStatement ps2 = con.prepareStatement(
                "SELECT wr.id AS request_id, wr.status, w.id AS writer_id, w.name, w.sample_file, " +
                "w.rate_assignment_page, w.rate_record_page, w.rate_per_diagram " +
                "FROM writer_requests wr JOIN writers w ON wr.writer_id = w.id " +
                "WHERE wr.assignment_id = ?"
            );
            ps2.setInt(1, rs.getInt("id"));
            ResultSet rs2 = ps2.executeQuery();
            boolean hasRequests = false;

            while (rs2.next()) {
                hasRequests = true;
%>
            <div class="writer-box">
                <p><strong>Writer:</strong> <%= rs2.getString("name") %></p>
                <p><strong>Sample:</strong>
                    <% String sample = rs2.getString("sample_file"); %>
                    <% if (sample != null && !sample.isEmpty()) { %>
                        <a href="<%= request.getContextPath() %>/uploads/<%= sample %>" target="_blank">View</a>
                    <% } else { %>
                        Not uploaded
                    <% } %>
                </p>
                <ul>
                    <li>Assignment/Page: ₹<%= rs2.getInt("rate_assignment_page") %></li>
                    <li>Record/Page: ₹<%= rs2.getInt("rate_record_page") %></li>
                    <li>Per Diagram: ₹<%= rs2.getInt("rate_per_diagram") %></li>
                </ul>
                <strong>Average Rating:</strong>
<ul>
<%
    int writerId = rs2.getInt("writer_id");

    PreparedStatement avgPs = con.prepareStatement("SELECT AVG(rating) AS avg_rating FROM feedback WHERE writer_id = ?");
    avgPs.setInt(1, writerId);
    ResultSet avgRs = avgPs.executeQuery();

    if (avgRs.next() && avgRs.getDouble("avg_rating") > 0) {
        double avgRating = avgRs.getDouble("avg_rating");
%>
        <li>⭐ <%= String.format("%.2f", avgRating) %>/5</li>
<%
    } else {
%>
        <li>No ratings yet</li>
<%
    }
    avgRs.close();
    avgPs.close();
%>
</ul>


               
                <form action="../AcceptWriterRequestServlet" method="post">
                    <input type="hidden" name="request_id" value="<%= rs2.getInt("request_id") %>">
                    <button type="submit" class="success-btn" onclick="return confirm('Accept this writer?');">Accept Writer</button>
                </form>
            </div>
<%
            }
            if (!hasRequests) { %><p>No requests yet.</p><% }

            rs2.close(); ps2.close();
%>
        </div>
<%
        }

        if (!hasAssignments) {
%>
        <p>No uploaded assignments yet.</p>
<%
        }

        rs.close(); ps.close(); con.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>

        <div style="text-align:center; margin-top: 30px;">
            <a href="user_dashboard.jsp" class="primary-btn">Back to Dashboard</a>
        </div>
    </div>
</div>
</body>
</html>
