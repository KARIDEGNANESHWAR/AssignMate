package com.assignmate.model;

import java.io.Serializable;

public class Writer implements Serializable {
    private int id;
    private String name;
    private String email;
    private String phone;
    private String password;         // (Optional) In real apps, store hashed password
    private String sampleFilePath;  // Path to handwriting sample file (PDF/image)
    private int rateAssignmentPage;
    private int rateRecordPage;
    private int ratePerDiagram;

    public Writer() {
        // Default constructor
    }

    // Getters and Setters

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }

    public String getSampleFilePath() {
        return sampleFilePath;
    }
    public void setSampleFilePath(String sampleFilePath) {
        this.sampleFilePath = sampleFilePath;
    }
    
 // Setters
    public void setRateAssignmentPage(int rateAssignmentPage) {
        this.rateAssignmentPage = rateAssignmentPage;
    }

    public void setRateRecordPage(int rateRecordPage) {
        this.rateRecordPage = rateRecordPage;
    }

    public void setRatePerDiagram(int ratePerDiagram) {
        this.ratePerDiagram = ratePerDiagram;
    }
}
