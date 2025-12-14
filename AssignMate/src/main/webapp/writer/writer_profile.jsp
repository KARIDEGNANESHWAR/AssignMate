<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String name = (String) session.getAttribute("writer_name");
    String email = (String) session.getAttribute("writer_email");
    Integer writerId = (Integer) session.getAttribute("writer_id");

    if (name == null || writerId == null) {
        response.sendRedirect("writer_login.jsp");
        return;
    }

    Double feedbackRating = null;
    int rateAssignmentPage = 0;
    int rateRecordPage = 0;
    int ratePerDiagram = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/assignmate", "root", "mysql");

        String ratingSql = "SELECT ROUND(AVG(rating), 2) AS avg_rating FROM feedback WHERE writer_id = ?";
        PreparedStatement ratingPs = conn.prepareStatement(ratingSql);
        ratingPs.setInt(1, writerId);
        ResultSet ratingRs = ratingPs.executeQuery();
        if (ratingRs.next()) {
            feedbackRating = ratingRs.getDouble("avg_rating");
            if (ratingRs.wasNull()) feedbackRating = null;
        }
        ratingRs.close();
        ratingPs.close();

        String rateSql = "SELECT rate_assignment_page, rate_record_page, rate_per_diagram FROM writers WHERE id = ?";
        PreparedStatement ratePs = conn.prepareStatement(rateSql);
        ratePs.setInt(1, writerId);
        ResultSet rateRs = ratePs.executeQuery();
        if (rateRs.next()) {
            rateAssignmentPage = rateRs.getInt("rate_assignment_page");
            rateRecordPage = rateRs.getInt("rate_record_page");
            ratePerDiagram = rateRs.getInt("rate_per_diagram");
        }
        rateRs.close();
        ratePs.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Writer Profile - AssignMate</title>
    <link rel="stylesheet" href="../css/profile.css">
</head>
<body class="bg-img">
<div class="overlay">
    <div class="dashboard-box">
        <h2 class="glow-title">Writer Profile</h2>

        <div class="profile-info">
            <p><strong>Name:</strong> <%= name %></p>
            <p><strong>Email:</strong> <%= email %></p>
            <p><strong>Feedback Rating:</strong>
                <%= (feedbackRating != null) ? feedbackRating + " / 5.0" : "No rating yet" %>
            </p>
            
            <p><strong>Assignment Rate/Page:</strong> ₹<%= rateAssignmentPage %></p>
            <p><strong>Record Rate/Page:</strong> ₹<%= rateRecordPage %></p>
            <p><strong>Rate/Diagram:</strong> ₹<%= ratePerDiagram %></p>
            
        </div>

            <div class="button-center">
    <a href="set_rates.jsp" class="dash-btn small-btn">Edit My Rates</a>
    <a href="writer_dashboard.jsp" class="logout-btn small-btn">Back to Dashboard</a>
</div>


        
    </div>
</div>
</body>
</html>
