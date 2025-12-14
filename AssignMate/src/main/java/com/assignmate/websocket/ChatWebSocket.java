package com.assignmate.websocket;

import org.json.JSONObject;
import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.sql.*;
import java.util.*;

import com.assignmate.DBConnection;

@ServerEndpoint("/chat/{assignmentId}/{senderId}/{senderType}")
public class ChatWebSocket {

    private static final Map<String, Set<Session>> chatRooms = new HashMap<>();

    @OnOpen
    public void onOpen(Session session,
                       @PathParam("assignmentId") String assignmentId) {
        chatRooms.computeIfAbsent(assignmentId, k -> new HashSet<>()).add(session);
    }

    @OnMessage
    public void onMessage(String messageJson, Session session) {
        try {
            JSONObject json = new JSONObject(messageJson);

            String senderId = json.getString("senderId");
            String receiverId = json.getString("receiverId");
            String assignmentId = json.getString("assignmentId");
            String senderType = json.getString("senderType");
            String receiverType = json.getString("receiverType");
            String content = json.getString("content");
            String timestamp = json.getString("timestamp");

            // Save to DB
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO messages (sender_id, receiver_id, sender_type, receiver_type, assignment_id, content, timestamp) VALUES (?, ?, ?, ?, ?, ?, ?)"
            );
            ps.setInt(1, Integer.parseInt(senderId));
            ps.setInt(2, Integer.parseInt(receiverId));
            ps.setString(3, senderType);
            ps.setString(4, receiverType);
            ps.setInt(5, Integer.parseInt(assignmentId));
            ps.setString(6, content);
            ps.setString(7, timestamp);
            ps.executeUpdate();
            ps.close();
            con.close();

            // Broadcast
            for (Session s : chatRooms.get(assignmentId)) {
                if (s.isOpen()) {
                    s.getBasicRemote().sendText(messageJson);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session,
                        @PathParam("assignmentId") String assignmentId) {
        if (chatRooms.containsKey(assignmentId)) {
            chatRooms.get(assignmentId).remove(session);
        }
    }
}
