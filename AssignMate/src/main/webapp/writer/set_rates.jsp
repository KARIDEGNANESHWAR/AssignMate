<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    Integer writerId = (Integer) session.getAttribute("writer_id");
    if (writerId == null) {
        response.sendRedirect("../writer_login.jsp");
        return;
    }

    String msg = request.getParameter("msg");

    // Default values in case DB has nulls
    int rateAssignment = 3;
    int rateRecord = 3;
    int rateDiagram = 3;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/assignMate", "root", "mysql"
        );

        String sql = "SELECT rate_assignment_page, rate_record_page, rate_per_diagram FROM writers WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, writerId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            String ra = rs.getString("rate_assignment_page");
            String rr = rs.getString("rate_record_page");
            String rd = rs.getString("rate_per_diagram");
            
            out.println("DB values: " + ra + ", " + rr + ", " + rd);

            // Parse to int
            rateAssignment = Integer.parseInt(ra);
            rateRecord = Integer.parseInt(rr);
            rateDiagram = Integer.parseInt(rd);
        }


        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Set My Rates - AssignMate</title>
    <link rel="stylesheet" href="../css/set_rates.css">
</head>
<body class="bg-img">
    <div class="overlay">
        <div class="dashboard-box">
            <h2 class="glow-title">Update Your Writing Rates</h2>

            <% if ("success".equals(msg)) { %>
                <p class="msg success">Rates updated successfully!</p>
            <% } else if ("error".equals(msg)) { %>
                <p class="msg error">Failed to update rates. Please try again.</p>
            <% } %>

            <form action="../UpdateWriterRatesServlet" method="post" class="rates-form">
                <label>Assignment Rate/Page (₹):</label>
                <input type="number" name="rate_assignment_page" min="3" value="<%= rateAssignment %>" required>

                <label>Record Rate/Page (₹):</label>
                <input type="number" name="rate_record_page" min="3" value="<%= rateRecord %>" required>

                <label>Rate per Diagram (₹):</label>
                <input type="number" name="rate_per_diagram" min="3" value="<%= rateDiagram %>" required>

                <div class="button-center">
                    <input type="submit" value="Update Rates" class="dash-btn small-btn">
                    <a href="writer_dashboard.jsp" class="logout-btn small-btn">Back to Dashboard</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
