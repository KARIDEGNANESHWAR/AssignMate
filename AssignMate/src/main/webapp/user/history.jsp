<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("user_login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="refresh" content="30">  

    <meta charset="UTF-8">
    <title>Assignment History</title>
    <link rel="stylesheet" href="../css/history.css">
    
</head>
<body>

<h2> Assignment History</h2>

<%
try {
    con = com.assignmate.DBConnection.getConnection();

    String sql = "SELECT a.*, w.name AS writer_name, w.email AS writer_email, w.sample_file " +
                 "FROM assignments a " +
                 "JOIN writers w ON a.accepted_writer_id = w.id " +
                 "WHERE a.user_id = ? AND a.status = 'done' AND a.user_marked_done = 1 AND a.writer_marked_done = 1 " +
                 "ORDER BY a.done_at DESC";

    ps = con.prepareStatement(sql);
    ps.setInt(1, userId);
    rs = ps.executeQuery();

    boolean hasData = false;
    while (rs.next()) {
        hasData = true;
%>
    <div class="history-box">
        <p><strong>Description:</strong> <%= rs.getString("description") %></p>
        <p><strong>Deadline:</strong> <%= rs.getDate("deadline") %></p>
        <p><strong>Completed At:</strong> <%= rs.getTimestamp("done_at") %></p>

        <h4> Writer Info:</h4>
        <p>Name: <%= rs.getString("writer_name") %></p>
        <p>Email: <%= rs.getString("writer_email") %></p>
        <p>Sample:
<% 
    String sample = rs.getString("sample_file");
    if (sample != null && !sample.trim().isEmpty()) { 
%>
    <a href="<%= request.getContextPath() + "/uploads/" + sample %>" target="_blank" style="color:#00f2ff;">View Sample</a>
<% 
    } else { 
%>
    Not uploaded
<% 
    } 
%>
</p>

    </div>
<% }
    if (!hasData) {
%>
    <p style="text-align:center; color: black;">No completed assignments found in your history.</p>
<%
    }

} catch (Exception e) {
    out.println("Error: " + e.getMessage());
} finally {
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (ps != null) ps.close(); } catch (Exception e) {}
    try { if (con != null) con.close(); } catch (Exception e) {}
}
%>

<a href="user_dashboard.jsp" class="dashboard-btn"> Back to Dashboard</a>
</body>
</html>
