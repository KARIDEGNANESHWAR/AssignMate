<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password - User</title>
    <link rel="stylesheet" href="../css/login.css">
</head>
<body class="bg-img">
<div class="overlay">
    <div class="login-container">
        <h2 class="login-title">Forgot Password - User</h2>

        <% String error = request.getParameter("error"); %>
        <% if ("not_found".equals(error)) { %>
            <div class="error-box">This email is not registered. Please check and try again.</div>
        <% } else if ("server".equals(error)) { %>
            <div class="error-box">Something went wrong. Please try again later.</div>
        <% } %>

        <form action="../UserForgotPasswordServlet" method="post" class="form-grid">
            <label>Enter your registered email:</label>
            <input type="email" name="email" required>

            <button type="submit" class="full-btn">Send OTP</button>
        </form>

        <p class="bottom-link">
            Remembered your password? <a href="user_login.jsp">Go back to login</a>
        </p>
    </div>
</div>
</body>
</html>
