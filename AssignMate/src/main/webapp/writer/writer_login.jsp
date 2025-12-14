<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Writer Login - AssignMate</title>
    <link rel="stylesheet" href="../css/login.css">
</head>
<body class="bg-img">
<div class="overlay">
    <div class="login-container">
        <h2 class="login-title">Writer Login</h2>

        <% if ("reset_success".equals(msg)) { %>
        <div class="success-box">
            Your password has been reset successfully. Please login with your new password.
        </div>
        <% } %>

        <% if (error != null) { %>
        <div class="error-box">
            Invalid email or password. Please try again.
        </div>
        <% } %>

        <form action="../WriterLoginServlet" method="post" class="form-grid">

            <label>Email:</label>
            <input type="email" name="email" required>

            <label>Password:</label>
<input type="password" name="password" id="passwordField" required>

<!-- Show Password Checkbox -->
<div style="margin: 6px 0 12px 0;">
    <label style="font-size: 14px;">
        <input type="checkbox" onclick="togglePassword()"> Show Password
    </label>
</div>


            <div class="forgot-link">
                <a href="forgot_password.jsp">Forgot Password?</a>
            </div>

            <button type="submit" class="full-btn">Login</button>
        </form>

        <p class="bottom-link">New writer? <a href="writer_register.jsp">Register here</a></p>
    </div>
</div>

<script>
    function togglePassword() {
        const field = document.getElementById("passwordField");
        field.type = (field.type === "password") ? "text" : "password";
    }
</script>

</body>
</html>
