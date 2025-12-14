<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String email = (String) session.getAttribute("writer_email"); // ✅ fixed key
    if (email == null) {
        response.sendRedirect("writer_register.jsp");
        return;
    }

    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Email Verification - Writer</title>
    <link rel="stylesheet" href="../css/login.css">
</head>
<body class="bg-img">
<div class="overlay">
    <div class="login-container">
        <h2 class="login-title">Verify Your Email</h2>

        <% if ("invalid".equals(error)) { %>
            <div class="error-msg" style="color:#f87171; font-weight:bold; text-align:center;">
                 Invalid OTP. Please try again.
            </div>
        <% } else if ("server".equals(error)) { %>
            <div class="error-msg" style="color:#f87171; font-weight:bold; text-align:center;">
                 Server error occurred. Please try again.
            </div>
        <% } %>

        <form action="../WriterVerifyEmailServlet" method="post" class="form-grid">
            <input type="hidden" name="email" value="<%= email %>">

            <label>Enter the OTP sent to your email:</label>
            <input type="text" name="otp" required placeholder="Enter OTP">

            <button type="submit" class="full-btn">Verify</button>
        </form>

        <p class="bottom-link">
            Didn't receive the OTP? <a href="writer_register.jsp">Go back & Retry</a>
        </p>
    </div>
</div>
</body>
</html>
