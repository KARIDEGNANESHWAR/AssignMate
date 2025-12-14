<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("user_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="30"> 
    
    <title>Accepted Writers</title>
    <link rel="stylesheet" href="../css/accepted_assignments.css">
    <script>
        function validateBeforeDone(userConfirmed, writerPaid) {
            if (!userConfirmed) {
                alert("Please confirm that you received the assignment before marking it as done.");
                return false;
            }
            if (!writerPaid) {
                alert("Writer has not confirmed payment yet.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body class="bg-img">
<div class="overlay">
<div class="container-box">
<h2 class="glow-title">Accepted Writers</h2>

<%
Connection con = null;
PreparedStatement ps = null, ps2 = null;
ResultSet rs = null, rs2 = null;
boolean hasAccepted = false;

try {
    con = com.assignmate.DBConnection.getConnection();
    String sql = "SELECT * FROM assignments WHERE user_id = ? AND user_marked_done = 0";
    ps = con.prepareStatement(sql);
    ps.setInt(1, userId);
    rs = ps.executeQuery();

    while (rs.next()) {
        hasAccepted = true;
        int assignmentId = rs.getInt("id");
        String description = rs.getString("description");
        String deadline = rs.getString("deadline");
        int writerId = rs.getInt("accepted_writer_id");

        boolean writerDone = rs.getBoolean("writer_marked_done");
        boolean writerPaid = rs.getBoolean("writer_received_payment");
        boolean userReceived = rs.getBoolean("user_received_assignment");

        ps2 = con.prepareStatement("SELECT * FROM writers WHERE id = ?");
        ps2.setInt(1, writerId);
        rs2 = ps2.executeQuery();

        if (rs2.next()) {
%>
<div class="assignment-box">
    <p><strong>Description:</strong> <%= description %></p>
    <p><strong>Deadline:</strong> <%= deadline %></p>
    <p><strong>Writer:</strong> <%= rs2.getString("name") %></p>

    <!-- Chat -->
    <form action="chat_user.jsp" method="get">
        <input type="hidden" name="assignmentId" value="<%= assignmentId %>">
        <input type="hidden" name="receiverId" value="<%= writerId %>">
        <button type="submit" class="action-btn green-btn">Chat</button>
    </form>

    <!-- Confirm Assignment Received -->
    <% if (!userReceived) { %>
    <form action="../ConfirmAssignmentReceivedServlet" method="post" onsubmit="return confirm('Are you sure you received the assignment?');">
        <input type="hidden" name="assignment_id" value="<%= assignmentId %>">
        <input type="submit" value="I received assignment" class="action-btn red-btn">
    </form>
    <% } else { %>
    <p class="success-msg">Assignment confirmed received.</p>
    <% } %>

    <!-- Mark as Done -->
    <form action="../UserMarkAsDoneServlet" method="post"
          onsubmit="return validateBeforeDone(<%= userReceived %>, <%= writerPaid %>)">
        <input type="hidden" name="assignment_id" value="<%= assignmentId %>">
        <input type="hidden" name="writer_id" value="<%= writerId %>">
        <label class="form-label">Rating:
            <select name="rating" required class="rating-select">
                <option value="">Select</option>
                <option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>
            </select>
        </label><br>
        <label class="form-label">Feedback:<br>
            <textarea name="comment" rows="1.8" cols="40" class="form-textarea"></textarea>
        </label><br>
        <input type="submit" value="Mark as Done" class="action-btn red-btn">
    </form>
    
    <!-- Reopen Assignment -->
<form action="../ReopenAssignmentServlet" method="post"
      onsubmit="return confirm('Are you sure you want to reopen this assignment? Writer will be notified.');">
    <input type="hidden" name="assignment_id" value="<%= assignmentId %>">
    <button type="submit" class="action-btn green-btn">Reopen Assignment</button>
</form>
    
</div>
<%
        }
        rs2.close();
        ps2.close();
    }
    if (!hasAccepted) {
%>
    <p class="no-data">No accepted writers found.</p>
<%
    }
} catch (Exception e) {
%>
    <p class="error-msg">Error: <%= e.getMessage() %></p>
<%
} finally {
    try { if (rs != null) rs.close(); } catch (Exception ignored) {}
    try { if (ps != null) ps.close(); } catch (Exception ignored) {}
    try { if (con != null) con.close(); } catch (Exception ignored) {}
}
%>
<br><br>
<div style="text-align:center;">
    <a href="user_dashboard.jsp" class="dashboard-btn">Back to Dashboard</a>
</div>
</div>
</div>
</body>
</html>
