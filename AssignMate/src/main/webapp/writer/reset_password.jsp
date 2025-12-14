<%@ page session="true" %>
<%
    String email = (String) session.getAttribute("reset_writer_email");
    if (email == null) {
        response.sendRedirect("forgot_password.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Reset Password - User</title>
    <link rel="stylesheet" href="../css/login.css">
</head>
<body class="bg-img">
<div class="overlay">
    <div class="login-container">
        <h2 class="login-title">Reset Your Password</h2>
        
        <% String error = request.getParameter("error"); %>
<% if ("invalid".equals(error)) { %>
    <div class="error-box">Invalid OTP. Please check and try again.</div>
<% } else if ("server".equals(error)) { %>
    <div class="error-box">Something went wrong. Please try again later.</div>
<% } %>
        

        <form action="../WriterResetPasswordServlet" method="post" class="form-grid">
            <input type="hidden" name="email" value="<%= email %>">

            <label>Enter OTP:</label>
            <input type="text" name="otp" required>

            <label>Enter New Password:</label>
            <input type="password" name="new_password" required>

            <button type="submit" class="full-btn">Reset Password</button>
        </form>

        <p class="bottom-link">
            Didn't receive OTP? <a href="forgot_password.jsp">Try again</a>
        </p>
    </div>
</div>
</body>
</html>
