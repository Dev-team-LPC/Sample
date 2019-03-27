<%-- 
    Document   : addLearnerList
    Created on : 17 Oct 2018, 10:15:58 AM
    Author     : cyprian
--%>

<%@ page import="cc.littlepig.databases.Database"%>
<%@ page import="cc.littlepig.classes.Caps"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link href="https://fonts.googleapis.com/css?family=Roboto|Varela+Round" rel="stylesheet">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
        <!--<script src="js/bootstrap.js"></script>-->

        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css" />
        <!--<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>-->
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
        <main role="main" class="container" style="padding-top: 10%; width: 50%;">
            <div class="jumbotron">
                <div style=" padding-bottom: 2%"><h1><center> Confirm Changes </center></h1></div>
                            <%
                                String name = request.getParameter("learnerName");
                                String surname = request.getParameter("learnerSurname");
                                String sla = request.getParameter("slaDropdown");
                                String date = request.getParameter("startDate");
                                String occupation = request.getParameter("ofos");
                                session.setAttribute("learnerName", name);
                                session.setAttribute("learnerSurname", surname);
                                session.setAttribute("slaDropdown", sla);
                                session.setAttribute("startDate", date);
                                session.setAttribute("ofos", occupation);
                            %>
                <form action="addLearnerSuccess.jsp" method="POST">
                    <table class="table table-sm">
                        <tr>
                            <td>
                                Name
                            </td>
                            <td>
                                :   <strong><%=name + " " + surname%></strong>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                SLA Name
                            </td>
                            <td>
                                :   <strong><%=sla%></strong>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Start Date
                            </td>
                            <td>
                                :   <strong><%=date%></strong>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Confirm Learner
                            </td>
                            <td>
                                <script>
                                    $('#learnerDropdown').selectpicker();
                                </script>
                                <select name="learnerDropdown" id="learnerDropdown" class="form-control selectpicker" data-dropup-auto="false" data-live-search="true" required>
                                    <option></option>
                                    <%
                                        String applicantId, firstName = "", lastName = "";
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
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Occupation
                            </td>
                            <td>
                                :   <strong><%= occupation%></strong>
                            </td>
                        </tr>
                    </table>
                    <center>
                        <button class="btn btn-secondary" onclick="window.history.go(-1);"><i class="fa fa-arrow-left"></i> back</button>
                        <button class="btn btn-md btn-success btn-outline-success" type="submit" onclick="return confirm('Are you sure you want to add this learner to the programme?')">
                            <i class="fa fa-user-plus"></i> add learner
                        </button>
                    </center>
                </form>
            </div>
        </main>
    </body>
</html>

