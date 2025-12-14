<h1 align="center">🧾 AssignMate</h1>

<p align="center">
  <b>A Java-Based Web Application for Academic Assignment Outsourcing</b><br>
  Connecting students and writers through transparent workflow, real-time chat, and secure offline confirmation.
</p>

<hr>

<h2>🌟 Overview</h2>

<p>
  <b>AssignMate</b> is a Java web application that simplifies academic assignment outsourcing. 
  It connects students and writers through a single platform, offering assignment posting, 
  writer selection, real-time chat, and offline task confirmation — all with a smooth and secure user experience.
</p>

<blockquote>
💡 <i>Work happens offline — coordination happens online.</i>
</blockquote>

<hr>

<h2>🚀 Features</h2>

<h3>👩‍🎓 For Students / Users</h3>
<ul>
  <li>🔐 <b>Register, verify email, and log in</b> securely</li>
  <li>📝 <b>Post assignments</b> and upload documents (PDF/DOCX)</li>
  <li>👀 <b>Explore writer requests</b> and choose writers based on <b>ratings, reviews, and handwriting samples</b></li>
  <li>💬 <b>Chat in real time</b> with selected writers using WebSocket</li>
  <li>📆 <b>Set deadlines</b> and track assignment progress</li>
  <li>🔁 <b>Re-upload assignments</b> or update details when needed</li>
  <li>✅ <b>Confirm task completion</b> and manage offline payments</li>
  <li>⭐ <b>Rate and review writers</b> after assignment delivery</li>
</ul>

<h3>✍️ For Writers</h3>
<ul>
  <li>🔐 <b>Register, verify email, and log in</b></li>
  <li>📸 <b>Upload handwriting samples</b> to attract students</li>
  <li>📢 <b>Request public assignments</b> from available listings</li>
  <li>📥 <b>View, accept, and manage assigned tasks</b></li>
  <li>💬 <b>Communicate instantly</b> with students for clarifications</li>
  <li>✅ <b>Confirm task completion</b> and coordinate offline delivery & payments</li>
  <li>📊 <b>Analyze performance</b> using assignment history and reviews</li>
</ul>

<hr>

<h2>🧩 Tech Stack</h2>

<table>
  <tr><td><b>Frontend</b></td><td>JSP, HTML5, CSS3, JavaScript</td></tr>
  <tr><td><b>Backend</b></td><td>Java Servlets, WebSocket API</td></tr>
  <tr><td><b>Server</b></td><td>Apache Tomcat 9+</td></tr>
  <tr><td><b>Database</b></td><td>MySQL</td></tr>
  <tr><td><b>Architecture</b></td><td>MVC (Model–View–Controller)</td></tr>
  <tr><td><b>Tools Used</b></td><td>Eclipse IDE, JDBC</td></tr>
</table>


<h2>🎨 UI Highlights</h2>
<ul>
  <li>🧭 <b>Role-based dashboards</b> for Students and Writers</li>
  <li>💬 <b>Modern chat interface</b> with real-time WebSocket messaging</li>
  <li>📁 <b>Clean and minimal assignment upload UI</b></li>
  <li>🟢 <b>Responsive layout</b> with CSS-based design</li>
  <li>🔒 <b>Secure navigation</b> with email verification and session management</li>
</ul>

<hr>

<h2>⚙️ Project Structure</h2>

<pre>
AssignMate/
├── src/main/java/com/
│   ├── assignmate/
│   │   ├── (All Servlets like UserLoginServlet, WriterRegisterServlet, DBConnection.java, etc.)
│   │
│   ├── model/
│   │   ├── User.java
│   │   └── Writer.java
│   │
│   ├── util/
│   │   └── EmailSender.java
│   │
│   └── websocket/
│       └── ChatWebSocket.java
│
└── webapp/
    ├── css/ → Styling files (dashboard.css, chat_style.css, upload_assign.css, etc.)
    ├── user/ → JSP pages for users (upload_assignment.jsp, user_dashboard.jsp, chat_user.jsp, etc.)
    ├── writer/ → JSP pages for writers (writer_dashboard.jsp, update_sample.jsp, chat_writer.jsp, etc.)
    ├── WEB-INF/ → web.xml (deployment descriptor)
    └── index.jsp → Home page
</pre>

<hr>

<h2>⚡ How It Works</h2>
<ol>
  <li>📤 User posts an assignment and sets a deadline.</li>
  <li>📝 Writers request or are selected based on samples and reviews.</li>
  <li>💬 Both communicate instantly via real-time chat.</li>
  <li>🤝 Assignment is completed offline, payment handled manually.</li>
  <li>✅ Both confirm completion — system updates progress and records feedback.</li>
</ol>

<hr>

<h2>🧭 Future Enhancements</h2>

<ul>
  <li>📱 <b>Mobile-responsive interface</b> for seamless access on all devices</li>
  <li>💳 <b>Integrated payment gateway</b> for secure online transactions</li>
  <li>📩 <b>Email & SMS notifications</b> for task updates and reminders</li>
  <li>🧮 <b>Admin panel</b> for managing assignments, users, and reports</li>
  <li>📍 <b>Location-based writer suggestions</b> to connect nearby users and writers for faster offline delivery</li>
</ul>


<hr>

<h2>👨‍💻 Author</h2>

<p>
  <b>Karide Gnaneshwar</b><br>
  📧 <a href="mailto:karidegnaneshwar@gmail.com">karidegnaneshwar@gmail.com</a><br>
  🌐 <a href="https://github.com/karidegnaneshwar" target="_blank">github.com/karidegnaneshwar</a>
</p>

<hr>

<p align="center">
  ⭐ <b>If you found this project useful, please give it a star — it helps others discover it!</b> ⭐
</p>
