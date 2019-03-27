<%-- 
    Document   : RemoveLearnerPermanently
    Created on : 24 Jan 2019, 6:27:34 PM
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
        <title>Learner Removed</title>
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link href="https://fonts.googleapis.com/css?family=Roboto|Varela+Round" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
        <script src="js/bootstrap.js"></script>
    </head>
    <body>
        <%
        if (request.getSession().getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/DashboardController?action=destroy");
        }
            String applicantId = new Foreword().getString(String.valueOf(session.getAttribute("internDropdown")), " ");
            String sla = new Foreword().getString(String.valueOf(session.getAttribute("slaDropdown")), ".");

            int applicant = 0;
            Database db = new Database();
            Connection con = db.getCon1();
            Statement st = con.createStatement();
            try {
                st.executeQuery("SELECT ISNULL(SUM(ISNULL(applicant_id))) applicant FROM intern_sla WHERE applicant_id = " + applicantId + " AND sla_id = " + sla + ";");
                ResultSet rs = st.getResultSet();
                if (rs.next()) {
                    applicant = rs.getInt("applicant");
                }
            } catch (SQLException e) {
                System.out.println(e);
            }
            if (applicant == 0) {
                try {
                    st.executeUpdate("DELETE FROM intern_sla WHERE sla_id = " + sla + " AND applicant_id = " + applicantId + ";");
                    con.close();
                } catch (SQLException e) {
                    System.out.println(e);
                }
        %>
        <script>
            alert("Learner successfully removed from the SLA database!");
            location.replace("removeLearner.jsp");
        </script>   
        <%
        } else {
        %>
        <script>
            alert("An unknown error has occured...check the system error log!");
            location.replace("removeLearner.jsp");
        </script>
        <%
            }
        %>
    </body>
</html>
