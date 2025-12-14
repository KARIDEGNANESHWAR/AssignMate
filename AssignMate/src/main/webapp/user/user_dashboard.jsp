<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String userName = (String) session.getAttribute("user_name");
    if (userName == null) {
        response.sendRedirect("user_login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard - AssignMate</title>
    <link rel="stylesheet" href="../css/dashboard.css"> <!-- Use the same dashboard.css -->
</head>
<body class="bg-img">
<div class="overlay">
    <div class="dashboard-box">
        <h2 class="glow-title">Welcome, <%= userName %></h2>

        <div class="dashboard-grid">
            <a href="user_profile.jsp" class="dash-btn">View Profile</a>
            <a href="upload_assignment.jsp" class="dash-btn">Upload Assignment</a>
            <a href="view_assignments.jsp" class="dash-btn">My Assignment Requests</a>
            <a href="accepted_writers.jsp" class="dash-btn">Accepted Writers</a>
            <a href="history.jsp" class="dash-btn">History</a>
            <a href="../LogoutServlet" class="logout-btn" onclick="return confirm('Are you sure you want to logout?');">Logout</a>
        </div>
    </div>
</div>
</body>
</html>
