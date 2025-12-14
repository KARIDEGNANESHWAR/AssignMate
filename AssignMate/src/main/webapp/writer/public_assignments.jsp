<%@ page import="java.sql.*" %>
<%@ page session="true" %>

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
    <meta http-equiv="refresh" content="10">  
    
    <title>Public Assignments - AssignMate</title>
    <link rel="stylesheet" href="../css/public_assignments.css">
    


</head>
<body class="bg-img">
<div class="overlay">
    <div class="register-container">
        <h2 class="glow-title">Public Assignments</h2>

        <table class="assign-table">
            <tr>
                <th>Description</th>
                <th>Deadline</th>
                <th>Action</th>
            </tr>
<%
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
boolean hasResults = false;

try {
    conn = com.assignmate.DBConnection.getConnection();

    String sql = "SELECT * FROM assignments a " +
                 "WHERE a.status = 'public' AND NOT EXISTS (" +
                 "SELECT 1 FROM writer_requests wr " +
                 "WHERE wr.assignment_id = a.id AND wr.status = 'accepted')";
    ps = conn.prepareStatement(sql);
    rs = ps.executeQuery();

    while(rs.next()) {
        hasResults = true;
        int assignmentId = rs.getInt("id");
        String description = rs.getString("description");
        java.sql.Date deadline = rs.getDate("deadline");

        String checkReqSql = "SELECT COUNT(*) FROM writer_requests WHERE writer_id = ? AND assignment_id = ?";
        try (PreparedStatement psCheck = conn.prepareStatement(checkReqSql)) {
            psCheck.setInt(1, writerId);
            psCheck.setInt(2, assignmentId);
            try (ResultSet rsCheck = psCheck.executeQuery()) {
                boolean alreadyRequested = false;
                if(rsCheck.next()) {
                    alreadyRequested = rsCheck.getInt(1) > 0;
                }
%>
            <tr>
                <td><%= description %></td>
                <td><%= deadline %></td>
                <td>
                    <%
                    if (alreadyRequested) {
                        String getReqIdSql = "SELECT id FROM writer_requests WHERE writer_id = ? AND assignment_id = ? AND status = 'pending'";
                        try (PreparedStatement psReqId = conn.prepareStatement(getReqIdSql)) {
                            psReqId.setInt(1, writerId);
                            psReqId.setInt(2, assignmentId);
                            try (ResultSet rsReqId = psReqId.executeQuery()) {
                                if (rsReqId.next()) {
                                    int requestId = rsReqId.getInt("id");
                    %>
                        <form action="../WithdrawWriterRequestServlet" method="post" style="margin:0;">
                            <input type="hidden" name="request_id" value="<%= requestId %>" />
                            <input type="submit" class="action-btn" value="Withdraw"
                                   onclick="return confirm('Are you sure you want to withdraw this request?');" />
                        </form>
                    <%
                                } else {
                    %>
                        Requested (Cannot Withdraw)
                    <%
                                }
                            }
                        }
                    } else {
                    %>
                        <form action="RequestAssignmentServlet" method="post" style="margin:0;">
                            <input type="hidden" name="assignmentId" value="<%= assignmentId %>" />
                            <input type="submit" value="Request to Work" class="action-btn" />
                        </form>
                    <%
                    }
                    %>
                </td>
            </tr>
<%
                }
            }
        }

        if (!hasResults) {
%>
            <tr><td colspan="3">No assignments available at the moment.</td></tr>
<%
        }

    } catch(Exception e) {
        out.println("<tr><td colspan='3'>Error: " + e.getMessage() + "</td></tr>");
    } finally {
        try { if(rs != null) rs.close(); } catch(Exception e) {}
        try { if(ps != null) ps.close(); } catch(Exception e) {}
        try { if(conn != null) conn.close(); } catch(Exception e) {}
    }
%>
        </table>

        <div style="text-align:center;">
            <a href="writer_dashboard.jsp" class="back-link">Back to Dashboard</a>
        </div>
    </div>
</div>
</body>
</html>
