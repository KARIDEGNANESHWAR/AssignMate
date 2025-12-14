<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer writerId = (Integer) session.getAttribute("writer_id");
    if (writerId == null) {
        response.sendRedirect("../writer_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="30">  
    
    <title>Accepted Assignments</title>
    <link rel="stylesheet" href="../css/accepted_assignments.css">
    <script>
        function validateBeforeDone(writerConfirmed, userConfirmed) {
            if (!writerConfirmed) {
                alert("Please confirm you received payment before marking as done.");
                return false;
            }
            if (!userConfirmed) {
                alert("User has not confirmed assignment received yet.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body class="bg-img">
<div class="overlay">
<div class="container-box">
<h2 class="glow-title">Accepted Assignments</h2>

<%
Connection conn = null;
PreparedStatement ps = null, psUser = null;
ResultSet rs = null, rsUser = null;

try {
    conn = com.assignmate.DBConnection.getConnection();
    String sql = "SELECT id, description, deadline, file_path, user_id, user_received_assignment, writer_received_payment, user_marked_done FROM assignments WHERE accepted_writer_id = ? AND writer_marked_done = 0";
    ps = conn.prepareStatement(sql);
    ps.setInt(1, writerId);
    rs = ps.executeQuery();

    boolean hasAssignments = false;
    while (rs.next()) {
        hasAssignments = true;

        int assignmentId = rs.getInt("id");
        String description = rs.getString("description");
        Date deadline = rs.getDate("deadline");
        String filePath = rs.getString("file_path");
        int userId = rs.getInt("user_id");
        boolean userConfirmed = rs.getBoolean("user_received_assignment");
        boolean writerConfirmed = rs.getBoolean("writer_received_payment");
        boolean userMarkedDone = rs.getBoolean("user_marked_done");

        String userName = "";
        psUser = conn.prepareStatement("SELECT name FROM users WHERE id = ?");
        psUser.setInt(1, userId);
        rsUser = psUser.executeQuery();
        if (rsUser.next()) {
            userName = rsUser.getString("name");
        }
%>
<div class="assignment-box">
    <p><strong>Description:</strong> <%= description %></p>
    <p><strong>Deadline:</strong> <%= deadline %></p>
    <p><strong>User:</strong> <%= userName %></p>
    <p><strong>File:</strong>
        <% if (filePath != null && !filePath.isEmpty()) { %>
            <a href="../uploads/<%= filePath %>" download class="file-link">Download</a>
        <% } else { %>
            Not uploaded
        <% } %>
    </p>

    <!-- Chat -->
    <form action="chat_writer.jsp" method="get">
        <input type="hidden" name="assignmentId" value="<%= assignmentId %>">
        <input type="hidden" name="receiverId" value="<%= userId %>">
        <button type="submit" class="action-btn green-btn">Chat</button>
    </form>

    <!-- Confirm Payment Received -->
    <% if (!writerConfirmed) { %>
    <form action="../ConfirmPaymentReceivedServlet" method="post"
          onsubmit="return confirm('Are you sure you received the payment?');">
        <input type="hidden" name="assignment_id" value="<%= assignmentId %>">
        <input type="hidden" name="payment_received" value="yes">
        <input type="submit" value="I received payment" class="action-btn red-btn">
    </form>
    <% } else { %>
    <p class="success-msg">Payment confirmed</p>
    <% } %>

    <!-- Mark as Done -->
    <form action="../WriterMarkAsDoneServlet" method="post"
          onsubmit="return validateBeforeDone(<%= writerConfirmed %>, <%= userConfirmed %>)">
        <input type="hidden" name="assignment_id" value="<%= assignmentId %>">
        <input type="hidden" name="user_id" value="<%= userId %>">
        <input type="submit" value="Mark as Done" class="action-btn red-btn">
    </form>
</div>
<%
        if (rsUser != null) rsUser.close();
        if (psUser != null) psUser.close();
    }
    if (!hasAssignments) {
%>
    <p class="no-data">No accepted assignments found.</p>
<%
    }
} catch (Exception e) {
%>
    <p class="error-msg">Error: <%= e.getMessage() %></p>
<%
} finally {
    try { if (rsUser != null) rsUser.close(); } catch (Exception ignored) {}
    try { if (psUser != null) psUser.close(); } catch (Exception ignored) {}
    try { if (rs != null) rs.close(); } catch (Exception ignored) {}
    try { if (ps != null) ps.close(); } catch (Exception ignored) {}
    try { if (conn != null) conn.close(); } catch (Exception ignored) {}
}
%>
<br>
<div style="text-align:center;">
    <a href="writer_dashboard.jsp" class="dashboard-btn">Back to Dashboard</a>
</div>
</div>
</div>
</body>
</html>
