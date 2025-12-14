package com.assignmate;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.assignmate.util.EmailSender;

@WebServlet("/WriterRegisterServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 10 * 1024 * 1024,
    maxRequestSize = 15 * 1024 * 1024
)
public class WriterRegisterServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email").toLowerCase();
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        int rateAssignment = Integer.parseInt(request.getParameter("rate_assignment_page"));
        int rateRecord = Integer.parseInt(request.getParameter("rate_record_page"));
        int rateDiagram = Integer.parseInt(request.getParameter("rate_per_diagram"));

        Part samplePart = request.getPart("sampleFile");

        if (samplePart == null || samplePart.getSize() == 0) {
            response.sendRedirect("writer/writer_register.jsp?error=file");
            return;
        }

        String fileName = Paths.get(samplePart.getSubmittedFileName()).getFileName().toString().toLowerCase();
        if (!(fileName.endsWith(".pdf") || fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")
                || fileName.endsWith(".png") || fileName.endsWith(".gif") || fileName.endsWith(".bmp"))) {
            response.sendRedirect("writer/writer_register.jsp?error=file");
            return;
        }

        String uploadPath = request.getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String savedFileName = System.currentTimeMillis() + "_" + fileName;
        samplePart.write(uploadPath + File.separator + savedFileName);

        String otp = String.valueOf((int) (Math.random() * 900000) + 100000);

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement checkStmt = conn.prepareStatement("SELECT id FROM writers WHERE email = ?");
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                response.sendRedirect("writer/writer_register.jsp?error=duplicate");
                return;
            }

            // Store data in session instead of DB
            HttpSession session = request.getSession();
            session.setAttribute("otp", otp);
            session.setAttribute("writer_name", name);
            session.setAttribute("writer_email", email);  
            session.setAttribute("writer_phone", phone);
            session.setAttribute("writer_password", password);
            session.setAttribute("writer_sample_file", savedFileName);
            session.setAttribute("rate_assignment", rateAssignment);
            session.setAttribute("rate_record", rateRecord);
            session.setAttribute("rate_diagram", rateDiagram);

            EmailSender.sendVerificationEmail(email, otp);
            response.sendRedirect("writer/verify_email.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("writer/writer_register.jsp?error=server");
        }
    }
}
