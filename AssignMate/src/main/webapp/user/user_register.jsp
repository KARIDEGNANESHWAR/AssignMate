<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Registration - AssignMate</title>
    <link rel="stylesheet" href="../css/register.css">
</head>
<body class="bg-img">
<div class="overlay">
    <div class="register-container">
        <h2 class="register-title">Register as User</h2>

        <% if (error != null) { %>
            <div class="error-box">
                <% if ("duplicate".equals(error)) { %>
                    Already registered with this email. 
                    <a href="user_login.jsp" class="text-link">Login here</a>.
                <% } else { %>
                    Something went wrong. Please try again.
                <% } %>
            </div>
        <% } %>

        <form action="../UserRegisterServlet" method="post" class="form-grid">
            <label>Name</label>
            <input type="text" name="name" required>

            <label>Email</label>
            <input type="email" name="email" required>

            <label>Phone</label>
            <input type="text" name="phone" required>

            <label>Password:</label>
<input type="password" name="password" id="passwordInput" required>

<!-- Show Password Option -->
<div style="margin: 6px 0 12px 0;">
    <label style="font-size: 14px;">
        <input type="checkbox" onclick="togglePassword()"> Show Password
    </label>
</div>


            <div class="terms-line">
                <input type="checkbox" id="agree" required>
                <label for="agree">
                    I agree to the <a href="#" onclick="openTerms()">Terms & Conditions</a>
                </label>
            </div>

            <button type="submit" class="btn full-btn">Register</button>
        </form>

        <p class="login-note">Already have an account?
            <a href="user_login.jsp" class="text-link">Login here</a>
        </p>
    </div>
</div>

<!-- Modal -->
<div id="termsModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeTerms()">×</span>
        <iframe src="terms_user.jsp" width="100%" height="600px" style="border:none; background: transparent;"></iframe>

    </div>
</div>

<script>

function togglePassword() {
    const passwordField = document.getElementById("passwordInput");
    passwordField.type = passwordField.type === "password" ? "text" : "password";
}

    function openTerms() {
        document.getElementById("termsModal").style.display = "block";
    }
    function closeTerms() {
        document.getElementById("termsModal").style.display = "none";
    }
    
</script>
</body>
</html>
