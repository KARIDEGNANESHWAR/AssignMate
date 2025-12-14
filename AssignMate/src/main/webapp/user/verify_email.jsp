<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
String email = (String) session.getAttribute("email");

    if (email == null) {
        response.sendRedirect("user_register.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Email Verification - AssignMate</title>
    <link rel="stylesheet" href="../css/login.css">
</head>
<body class="bg-img">
<div class="overlay">
    <div class="login-container">
        <h2 class="login-title">Verify Your Email</h2>

        <form action="../UserVerifyEmailServlet" method="post" class="form-grid">
            <input type="hidden" name="email" value="<%= email %>">

            <label>Enter the OTP sent to your email:</label>
            <input type="text" name="otp" required placeholder="Enter OTP">

            <button type="submit" class="full-btn">Verify</button>
        </form>

        <p class="bottom-link">
            Didn't receive OTP? <a href="user_register.jsp">Go back & Retry</a>
        </p>
    </div>
</div>
</body>
</html>
