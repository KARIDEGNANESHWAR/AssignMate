<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = request.getParameter("error");
%>

<% if ("email_fail".equals(request.getParameter("error"))) { %>
    <div class="error-msg" style="color:#f87171; font-weight:bold; text-align:center;">
        ⚠️ We couldn’t send the OTP. Please check your Gmail address and try again.
    </div>
<% } %>

<!DOCTYPE html>
<html>
<head>
    <title>Writer Registration - AssignMate</title>
    <link rel="stylesheet" href="../css/register.css">
</head>
<body class="bg-img">
<div class="overlay">
    <div class="register-container">
        <h2 class="register-title">Writer Registration</h2>

        <% if ("duplicate".equals(error)) { %>
            <div class="error-box">
                This email is already registered as a writer.
                <a href="writer_login.jsp">Login here</a>.
            </div>
        <% } else if ("file".equals(error)) { %>
            <div class="error-box">
                Please upload a valid PDF or image file for handwriting sample.
            </div>
        <% } else if ("unknown".equals(error)) { %>
            <div class="error-box">
                Something went wrong. Please try again.
            </div>
        <% } %>

        <form action="../WriterRegisterServlet" method="post" enctype="multipart/form-data" class="form-grid">

            <label>Name:</label>
            <input type="text" name="name" required>

            <label>Email:</label>
            <input type="email" name="email" required>

            <label>Phone:</label>
            <input type="text" name="phone" required>

            <label>Password:</label>
<input type="password" name="password" id="passwordInput" required>

<!-- Show Password Option -->
<div style="margin: 6px 0 12px 0;">
    <label style="font-size: 14px;">
        <input type="checkbox" onclick="togglePassword()"> Show Password
    </label>
</div>


            

            <label>Assignment Rate per Page (₹):</label>
            <input type="number" name="rate_assignment_page" min="3" required>

            <label>Record Rate per Page (₹):</label>
            <input type="number" name="rate_record_page" min="3" required>

            <label>Rate per Diagram (₹):</label>
            <input type="number" name="rate_per_diagram" min="3" required>
            
            <label>Upload Handwriting Sample (PDF/Image):</label>
            <input type="file" name="sampleFile" accept="application/pdf,image/*" required>

            <div class="terms-line">
                <input type="checkbox" required>
                <label>I agree to the <a href="#" onclick="openTerms()">Terms and Conditions</a></label>
            </div>

            <button type="submit" class="full-btn">Register</button>
        </form>

        <p class="bottom-link">Already have an account?
            <a href="writer_login.jsp">Login here</a>
        </p>
    </div>
</div>

<!-- Modal for Writer Terms -->
<div id="termsModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeTerms()">x</span>
        <iframe src="terms_writer.jsp" width="100%" height="600px" style="border:none; background: transparent;"></iframe>
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
