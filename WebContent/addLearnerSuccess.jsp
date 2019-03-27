<%-- 
    Document   : addLearnerSuccess
    Created on : 17 Oct 2018, 11:52:54 AM
    Author     : cyprian
--%>

<%@ page import="cc.littlepig.databases.Database"%>
<%@ page import="cc.littlepig.classes.Caps"%>
<%@ page import="cc.littlepig.classes.Foreword"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Learner Replacement</title>
        <style>
            body, html {
                height: 100%;
                margin: 0;
            }

            .bg {
                background-image: url("images/Black-Galaxy-Wallpapers-HD.jpg");
                height: 100%;
                background-position: center;
                background-repeat: no-repeat;
                background-size: cover;
            }
        </style>
    </head>
    <body class="bg">
        <%
            if (request.getSession().getAttribute("username") == null) {
                response.sendRedirect(request.getContextPath() + "/DashboardController?action=destroy");
            }
            String date = String.valueOf(session.getAttribute("startDate"));
            String applicantId = new Foreword().getString(request.getParameter("learnerDropdown"), " ");
            String occupations = new Foreword().getString(String.valueOf(session.getAttribute("ofos")), ".");
            String sla = new Foreword().getString(String.valueOf(session.getAttribute("slaDropdown")), ".");

            int duples = 0;
            try {
                Database db = new Database();
                Connection con = db.getCon1();
                Statement st = con.createStatement();
                st.executeQuery("SELECT COUNT(*) dups FROM intern_sla WHERE sla_id = " + sla + " AND applicant_id = " + applicantId + " AND status_id = 1;");
                ResultSet rs = st.getResultSet();
                if (rs.next()) {
                    duples = rs.getInt("dups");
                }
                con.close();
            } catch (SQLException e) {
                System.out.println(e);
            }
            if (duples == 0) {
                try {
                    Database db = new Database();
                    Connection con = db.getCon1();
                    Statement st = con.createStatement();
                    st.executeUpdate("INSERT INTO intern_sla (applicant_id, sla_id, ofo_code_id, date, status_id) VALUES (" + applicantId + "," + sla + "," + occupations + ",'" + date + "', 1);");
                    con.close();
                } catch (SQLException e) {
                    System.out.println(e);
                }
        %>
        <script>
            alert("Learner successfully added to the SLA programme!");
            location.replace("addLearner.jsp");
        </script>
        <%
        } else if (duples == 1) {
        %>
        <script>
            alert("Learner already added to the SLA programme!");
            location.replace("addLearner.jsp");
        </script>
        <%
        } else if (duples > 1) {
        %>
        <script>
            alert("More than one records of this action exist in the database!");
            location.replace("addLearner.jsp");
        </script>
        <%
        } else {
        %>
        <script>
            alert("An unknown error has occured!");
            location.replace("addLearner.jsp");
        </script>
        <%
            }
        %>
    </body>
</html>
