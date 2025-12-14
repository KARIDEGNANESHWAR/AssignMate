<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session != null && (session.getAttribute("user_id") != null || session.getAttribute("writer_id") != null)) {
        response.sendRedirect("LogoutServlet");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>AssignMate - Home</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&family=Roboto&display=swap" rel="stylesheet">

    <!-- External CSS -->
    <link rel="stylesheet" type="text/css" href="css/style_home.css">
</head>
<body>

    <div class="overlay">
        <div class="home-container">
            <h1 class="title">Welcome to <span>AssignMate</span></h1>

            <div class="description">
                <p>
                    <strong>AssignMate</strong> is a platform where students (users) can upload their handwritten assignment requirements, and writers can request to complete them offline. 
                    Users can browse handwriting samples, choose writers based on quality and budget, chat in real time, track the progress of their work, and give feedback after completion.
                </p>

                <p>
                    This application is currently designed for a specific location, making it ideal for regional academic collaboration. 
                    As the platform grows and gains success, we plan to introduce location-based features where users can find nearby writers based on their address.
                </p>

                <p>
                    In future updates, we aim to add smart writer suggestions, delivery tracking, performance ratings, and more tools to improve speed and transparency. 
                    AssignMate is committed to building a secure and efficient environment for academic assistance.
                </p>
            </div>

            <div class="role-boxes">
                <div class="box user-box">
                    <h3>Are you a User?</h3>
                    <div class=btn-group>
                    <a href="user/user_register.jsp" class="btn">Register as User</a>
                    <a href="user/user_login.jsp" class="btn">Login as User</a>
                    </div>
                </div>

                <div class="box writer-box">
                    <h3>Are you a Writer?</h3>
                    <div class=btn-group>
                    <a href="writer/writer_register.jsp" class="btn">Register as Writer</a>
                    <a href="writer/writer_login.jsp" class="btn">Login as Writer</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
