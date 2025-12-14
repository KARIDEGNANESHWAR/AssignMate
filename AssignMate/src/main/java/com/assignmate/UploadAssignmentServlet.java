package com.assignmate;

import java.io.*;
import java.nio.file.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UploadAssignmentServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,  // 1MB
    maxFileSize = 10 * 1024 * 1024,   // 10MB
    maxRequestSize = 15 * 1024 * 1024 // 15MB
)
public class UploadAssignmentServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("user_login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        String description = request.getParameter("description");
        String deadline = request.getParameter("deadline");
        Part filePart = request.getPart("assignmentFile");

        String errorMessage = null;

        // Description is optional, trim to null if empty
        if (description != null) {
            description = description.trim();
            if (description.isEmpty()) {
                description = null;
            }
        }

        // Validate deadline and file
        if (deadline == null || deadline.trim().isEmpty()) {
            errorMessage = "Deadline is required.";
        } else if (filePart == null || filePart.getSize() == 0) {
            errorMessage = "Assignment file is required.";
        } else {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String ext = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
            if (!ext.equals("pdf") && !ext.matches("jpg|jpeg|png|gif|bmp")) {
                errorMessage = "Only PDF or image files are allowed.";
            }
        }

        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("user/upload_assignment.jsp").forward(request, response);
            return;
        }

        // Save uploaded file to disk
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String savedFileName = userId + "_" + System.currentTimeMillis() + "_" + originalFileName;
        String filePath = UPLOAD_DIR + "/" + savedFileName;

        try {
            filePart.write(uploadPath + File.separator + savedFileName);

            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/assignmate", "root", "mysql")) {

                String sql = "INSERT INTO assignments (user_id, description, deadline, file_path, status) " +
                             "VALUES (?, ?, ?, ?, 'public')";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, userId);
                    if (description != null) {
                        stmt.setString(2, description);
                    } else {
                        stmt.setNull(2, Types.LONGVARCHAR);
                    }
                    stmt.setDate(3, java.sql.Date.valueOf(deadline));
                    stmt.setString(4, filePath);

                    stmt.executeUpdate();
                }
            }

            response.sendRedirect("user/upload_assignment.jsp?msg=Assignment uploaded successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error uploading assignment: " + e.getMessage());
            request.getRequestDispatcher("user/upload_assignment.jsp").forward(request, response);
        }
    }
}
