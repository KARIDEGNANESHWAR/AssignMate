package com.assignmate;
import java.lang.InterruptedException;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class CleanupListener implements ServletContextListener {
	@Override
	public void contextDestroyed(ServletContextEvent sce) {
	    try {
	        AbandonedConnectionCleanupThread.checkedShutdown(); // newer version
	    } catch (Throwable t) {
	        // fallback or log error
	        System.err.println("MySQL cleanup thread shutdown failed:");
	        t.printStackTrace();
	    }
	}



    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // No action needed on startup
        System.out.println("✅ ServletContext initialized.");
    }
}
