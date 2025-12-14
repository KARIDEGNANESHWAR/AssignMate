<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%@ page import="com.assignmate.DBConnection" %>

<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("../user_login.jsp");
        return;
    }
    int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
    int receiverId = Integer.parseInt(request.getParameter("receiverId"));
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
     
    
    <title>Chat with Writer</title>
    <link rel="stylesheet" href="../css/chat_style.css">
    <script>
        let socket;

        function getMySQLTimestamp() {
            const now = new Date();
            return now.getFullYear() + '-' +
                String(now.getMonth() + 1).padStart(2, '0') + '-' +
                String(now.getDate()).padStart(2, '0') + ' ' +
                String(now.getHours()).padStart(2, '0') + ':' +
                String(now.getMinutes()).padStart(2, '0') + ':' +
                String(now.getSeconds()).padStart(2, '0');
        }

        function connectSocket() {
            const userId = "<%= userId %>";
            const assignmentId = "<%= assignmentId %>";
            const socketUrl = "ws://" + window.location.host + "/AssignMate/chat/" + assignmentId + "/" + userId + "/user";

            socket = new WebSocket(socketUrl);

            socket.onmessage = function (event) {
                const data = JSON.parse(event.data);
                appendMessage(data.content, data.senderType, data.timestamp);
            };

            socket.onopen = function () {
                console.log("WebSocket Connected.");
            };

            socket.onerror = function (err) {
                console.error("WebSocket error: ", err);
            };
        }

        function sendMessage() {
            const input = document.getElementById("message");
            const msg = input.value.trim();
            if (!msg) return;

            const data = {
                content: msg,
                senderId: "<%= userId %>",
                receiverId: "<%= receiverId %>",
                assignmentId: "<%= assignmentId %>",
                senderType: "user",
                receiverType: "writer",
                timestamp: getMySQLTimestamp()
            };

            socket.send(JSON.stringify(data));
            input.value = "";
        }

        function appendMessage(msg, senderType, time) {
            const div = document.createElement("div");
            div.className = "message " + (senderType === "user" ? "right" : "left");
            div.innerHTML = msg + "<span class='timestamp'>" + time + "</span>";
            const box = document.getElementById("chat-box");
            box.appendChild(div);
            box.scrollTop = box.scrollHeight;
        }

        function loadOldMessages() {
            const xhr = new XMLHttpRequest();
            xhr.open("GET", "../UserChatFetchServlet?assignment_id=<%= assignmentId %>", true);
            xhr.onload = function () {
                const messages = JSON.parse(this.responseText);
                messages.forEach(msg => {
                    appendMessage(msg.content, msg.sender_type, msg.timestamp);
                });
            };
            xhr.send();
        }

        window.onload = function () {
            loadOldMessages();
            connectSocket();
        };
    </script>
</head>
<body>
    <h2>Chat with Writer</h2>
    <div id="chat-box"></div>
    <textarea id="message" placeholder="Type your message..." onkeydown="if(event.key==='Enter'){ sendMessage(); return false;}"></textarea>
    <button onclick="sendMessage()">Send</button>
</body>
</html>
