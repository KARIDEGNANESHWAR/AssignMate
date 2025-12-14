<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String writerName = (String) session.getAttribute("writer_name");
    Integer writerId = (Integer) session.getAttribute("writer_id");

    if (writerName == null || writerId == null) {
        response.sendRedirect("../writer_login.jsp");
        return;
    }

    int rateAssignmentPage = 0;
    int rateRecordPage = 0;
    int ratePerDiagram = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/assignmenthub", "root", "mysql");

        String sql = "SELECT rate_assignment_page, rate_record_page, rate_per_diagram FROM writers WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, writerId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            rateAssignmentPage = rs.getInt("rate_assignment_page");
            rateRecordPage = rs.getInt("rate_record_page");
            ratePerDiagram = rs.getInt("rate_per_diagram");
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Writer Dashboard - AssignMate</title>
    <link rel="stylesheet" href="../css/dashboard.css">
</head>
<body class="bg-img">
<div class="overlay">
    <div class="dashboard-box">
        <h2 class="glow-title">Welcome, <%= writerName %> </h2>

        

        <div class="dashboard-grid">
            <a href="writer_profile.jsp" class="dash-btn"> Profile</a>
            <a href="update_sample.jsp" class="dash-btn"> Upload Sample</a>
            <a href="set_rates.jsp" class="dash-btn"> Edit My Rates</a>
            <a href="public_assignments.jsp" class="dash-btn"> Public Assignments</a>
            <a href="accepted_assignments.jsp" class="dash-btn"> Accepted Assignments</a>
            <a href="history.jsp" class="dash-btn"> History</a>
            <a href="../LogoutServlet" class="logout-btn" onclick="return confirm('Are you sure you want to logout?');"> Logout</a>
        </div>
    </div>
</div>
</body>
</html>
