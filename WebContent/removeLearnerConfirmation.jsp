<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="cc.littlepig.databases.Database"%>
<%@ page import="cc.littlepig.classes.Caps"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Learner Removal</title>
        <link href="https://fonts.googleapis.com/css?family=Roboto|Varela+Round" rel="stylesheet">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css" />
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
        <link rel="stylesheet" href="css/reports-customstyle.css">
    </head>  
    <body>
        <header class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
            <a class="navbar-brand" href="main.jsp">
                <img src="images/logotop.png" width="100" height="30" class="d-inline-block align-top" alt="lpc logo">
            </a>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="mr-auto">
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown open">
                        <a class="btn btn-outline-info dropdown-toggle" href="#" id="navbarDropdown" 
                           role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fa fa-user"></i>
                                    <%
                                    	if (request.getSession().getAttribute("username") == null) {
                                    		response.sendRedirect(request.getContextPath() + "/DashboardController?action=destroy");
                                    	} else {
                                    		out.print(new Caps().toUpperCaseFirstLetter(request.getSession().getAttribute("First_Name").toString()));
                                    	}
                                    %>                                                 
                        </a>
                        <div class="dropdown-menu dropdown-menu-right">
                            <a class="dropdown-item" href="#">Account </a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="logout.jsp">Sign Out</a>
                        </div>
                    </li>
                </ul> 
            </div>
        </header>
        <main role="main" class="container" style="padding-top: 15%; width: 50%  ;">
            <div class="jumbotron">
                <div style=" padding-bottom: 3%"><h1><center> Confirm Changes </center></h1></div>
                            <%
                                String name = request.getParameter("internName");
                                String surname = request.getParameter("internSurname");
                                String sla = request.getParameter("slaDropdown");
                                String date = request.getParameter("resignDate");
                                session.setAttribute("internName", name);
                                session.setAttribute("internSurname", surname);
                                session.setAttribute("slaDropdown", sla);
                                session.setAttribute("resignDate", date);
                            %>
              <form action="removeLearnerSuccess.jsp" method="POST">                            
                <table class="table table-sm">
                    <tr>
                        <td>
                            Entered Name</label>
                        </td>
                        <td>
                            :   <strong><%=name + " " + surname%></strong>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            SLA Name</label>
                        </td>
                        <td>
                            :   <strong style="font-size: small"><%=sla%></strong>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Resignation Date</label>
                        </td>
                        <td>
                            :   <strong><%=date%></strong>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Confirm Learner </label>
                        </td>
                        <td>
                            <strong>
                                    <script>
                                        $('#internDropdown').selectpicker();
                                    </script>
                                    <select name="internDropdown" id="internDropdown" class="form-control selectpicker" data-dropup-auto="false" data-live-search="true" required>
                                        <option></option>
                                        <%
                                            String applicantId, firstName, lastName;
                                            try {
                                                Database DB = new Database();
                                                Connection con = DB.getCon1();
                                                Statement st = con.createStatement();
                                                st.executeQuery("SELECT applicant_id, First_Name, Surname FROM applicant_personal_details WHERE Surname LIKE '%" + surname + "%' OR First_Name LIKE '%" + name + "%';");
                                                ResultSet rs = st.getResultSet();

                                                while (rs.next()) {

                                                    applicantId = rs.getString("applicant_id");
                                                    firstName = rs.getString("First_Name").trim().substring(0, 1).toUpperCase() + rs.getString("First_Name").trim().toLowerCase().substring(1);
                                                    lastName = rs.getString("Surname").trim().substring(0, 1).toUpperCase() + rs.getString("Surname").trim().substring(1).toLowerCase();
                                                    out.println("<option>" + applicantId + " - " + firstName + " " + lastName + "</option>");
                                                }
                                                con.close();
                                            } catch (SQLException e) {
                                                System.out.println(e);
                                            }
                                        %>
                                    </select>
                            </strong>
                        </td>
                    </tr>
                </table>
                <center>
                    <button class="btn btn-outline-secondary" onclick="window.history.go(-1);"><i class="fa fa-arrow-left"></i> back</button>
                    <button class="btn btn-md btn-success btn-outline-success" type="submit" onclick="return confirm('Are you sure you want to remove this learner from the programme?')">
                        <i class="fa fa-user-times" aria-hidden="true"></i> remove learner
                    </button>
                </center>
                </form>
            </div>
        </main>
    </body>
</html>