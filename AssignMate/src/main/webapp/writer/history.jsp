<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    Integer writerId = (Integer) session.getAttribute("writer_id");
    if (writerId == null) {
        response.sendRedirect("../writer_login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="30"> 
    
    <title>Completed Assignments - Writer History</title>
    <link rel="stylesheet" href="../css/history.css">
    
</head>
<body>

<h2> Completed Assignments</h2>

<%
try {
    con = com.assignmate.DBConnection.getConnection();

    String sql = "SELECT a.*, u.name AS user_name " +
                 "FROM assignments a " +
                 "JOIN users u ON a.user_id = u.id " +
                 "WHERE a.accepted_writer_id = ? AND a.status = 'done' AND a.writer_marked_done = 1 " +
                 "ORDER BY a.done_at DESC";

    ps = con.prepareStatement(sql);
    ps.setInt(1, writerId);
    rs = ps.executeQuery();

    boolean hasData = false;
    while (rs.next()) {
        hasData = true;
%>
    <div class="history-box">
        <p><strong>Description:</strong> <%= rs.getString("description") %></p>
        <p><strong>Deadline:</strong> <%= rs.getDate("deadline") %></p>
        <p><strong>Marked Done On:</strong> <%= rs.getTimestamp("done_at") %></p>
        <p><strong>User:</strong> <%= rs.getString("user_name") %></p>
    </div>
<%
    }

    if (!hasData) {
%>
    <p style="text-align:center; color:black;">No completed assignments found yet.</p>
<%
    }

} catch (Exception e) {
%>
    <p style="color:red;">Error: <%= e.getMessage() %></p>
<%
} finally {
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (ps != null) ps.close(); } catch (Exception e) {}
    try { if (con != null) con.close(); } catch (Exception e) {}
}
%>

<a href="writer_dashboard.jsp" class="dashboard-btn"> Back to Dashboard</a>

</body>
</html>
