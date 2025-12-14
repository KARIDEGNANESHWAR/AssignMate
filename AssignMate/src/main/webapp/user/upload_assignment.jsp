<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Upload Assignment - AssignMate</title>
    <link rel="stylesheet" href="../css/upload_assign.css"> <!-- Your new glowing style -->
</head>
<body class="bg-img">

<%
    String userName = (String) session.getAttribute("user_name");
    if (userName == null) {
        response.sendRedirect("user_login.jsp");
        return;
    }

    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = request.getParameter("msg");
%>

<div class="overlay">
    <div class="upload-box">
        <h2 class="glow-title">Upload Assignment</h2>

        <% if (errorMessage != null) { %>
            <div style="color: #f87171; font-weight: bold; text-align:center;"><%= errorMessage %></div>
        <% } %>

        <% if (successMessage != null) { %>
            <div style="color: #34d399; font-weight: bold; text-align:center;"><%= successMessage %></div>
        <% } %>

        <form action="../UploadAssignmentServlet" method="post" enctype="multipart/form-data" style="margin-top: 20px;">

            <label>Description (Optional):</label>
            <textarea name="description" rows="1.9" class="form-input"></textarea>

            <label>Deadline (YYYY-MM-DD):</label>
            <input type="date" name="deadline" required class="form-input">

            <label>Upload Assignment File (PDF/Image):</label>
            <input type="file" name="assignmentFile" accept="application/pdf,image/*" required class="form-input">

            <div class="button-center">
                <button type="submit" class="dash-btn small-btn">Upload Assignment</button>
                <a href="user_dashboard.jsp" class="logout-btn small-btn">Back to Dashboard</a>
            </div>
        </form>
    </div>
</div>

</body>
</html>
