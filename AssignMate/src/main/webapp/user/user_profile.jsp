<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Profile - AssignMate</title>
    <link rel="stylesheet" href="../css/profile.css">
</head>
<body class="bg-img">

<%
    String userName = (String) session.getAttribute("user_name");
    String userEmail = (String) session.getAttribute("user_email");
    String userPhone = (String) session.getAttribute("user_phone");

    if (userName == null) {
        response.sendRedirect("user_login.jsp");
        return;
    }
%>

<div class="overlay">
    <div class="dashboard-box">
        <h2 class="glow-title">User Profile</h2>

        <div class="profile-info">
            <p><strong>Name:</strong> <%= userName %></p>
            <p><strong>Email:</strong> <%= userEmail %></p>
            <p><strong>Phone:</strong> <%= userPhone %></p>
         </div>

            <div class="dashboard-grid">
                <a href="user_dashboard.jsp" class="logout-btn small-btn">Back to Dashboard</a>
            </div>
       
    </div>
</div>

</body>
</html>
