package com.assignmate;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Paths;
import java.sql.*;

@WebServlet("/UpdateSampleServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,  // 1MB
        maxFileSize = 10 * 1024 * 1024,   // 10MB
        maxRequestSize = 15 * 1024 * 1024 // 15MB
)
public class UpdateSampleServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer writerId = (Integer) session.getAttribute("writer_id");

        if (writerId == null) {
            response.sendRedirect("writer_login.jsp");
            return;
        }

        Part samplePart = request.getPart("sampleFile");
        if (samplePart == null || samplePart.getSize() == 0) {
            response.sendRedirect("writer/update_sample.jsp?message=Please upload a file.");
            return;
        }

        String fileName = Paths.get(samplePart.getSubmittedFileName()).getFileName().toString().toLowerCase();
        if (!(fileName.endsWith(".pdf") || fileName.endsWith(".jpg") || fileName.endsWith(".jpeg") || fileName.endsWith(".png"))) {
            response.sendRedirect("writer/update_sample.jsp?message=Invalid file type.");
            return;
        }

        // Save file in the uploads folder inside webapp
        String appPath = request.getServletContext().getRealPath("");
        File uploadDir = new File(appPath, UPLOAD_DIR);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String savedFileName = System.currentTimeMillis() + "_" + fileName; // unique filename

        try {
            samplePart.write(uploadDir.getAbsolutePath() + File.separator + savedFileName);

            // Save only the filename in the DB
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "UPDATE writers SET sample_file = ? WHERE id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, savedFileName); // store only filename
                    stmt.setInt(2, writerId);
                    int rows = stmt.executeUpdate();
                    if (rows > 0) {
                        response.sendRedirect("writer/update_sample.jsp?message=Updated successfully.");
                    } else {
                        response.sendRedirect("writer/update_sample.jsp?message=Update failed.");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("writer/update_sample.jsp?message=Error occurred.");
        }
    }
}
