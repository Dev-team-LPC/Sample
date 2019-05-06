<%-- 
    Document   : addLearnerList
    Created on : 17 Oct 2018, 10:15:58 AM
    Author     : cyprian
--%>

<%@ page import="cc.littlepig.databases.Database"%>
<%@ page import="cc.littlepig.classes.Caps"%>
<%@ page import="cc.littlepig.classes.Foreword"%>
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
		<link rel="shortcut icon" href="http://www.littlepig.cc/wp-content/themes/littlepig/images/favicon.ico?var=xdv53">
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
        <main role="main" class="container" style="padding-top: 5%; width: 60%;">
            <div class="jumbotron">
                <div style=" padding-bottom: 3%"><h1><center> Confirm Changes </center></h1></div>
                            <%
                                String slaName = request.getParameter("slaName").trim();
                                String programmeType = request.getParameter("programmeType").trim();
                                String company = request.getParameter("company").trim();
                                String numOfLearners = request.getParameter("learnerNum").trim();
                                String startDate = request.getParameter("startDate").trim();
                                String endDate = request.getParameter("endDate").trim();
                                String disbursementAmount = request.getParameter("disbursementAmount").trim();
                                String disbursement1 = request.getParameter("disbursement1").trim();
                                String disbursement2 = request.getParameter("disbursement2").trim();
                                String disbursement3 = request.getParameter("disbursement3").trim();
                                String disbursement4 = request.getParameter("disbursement4").trim();
                            %>
                <table class="table table-sm table-hover" style="width:100%;">
                    <tr>
                        <td>
                            SLA Name
                        </td>
                        <td>
                            :   <strong><%=slaName%></strong>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Programme Type
                        </td>
                        <td>
                            :   <strong><%=programmeType%></strong>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Company
                        </td>
                        <td>
                            :   <strong><%=company%></strong>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Number of Learners
                        </td>
                        <td>
                            :   <strong><%=numOfLearners%></strong>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Start Date
                        </td>
                        <td>
                            :   <strong><%=startDate%></strong>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            End Date
                        </td>
                        <td>
                            :   <strong><%=endDate%></strong>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Disbursement Amount
                        </td>
                        <td>
                            :   <strong><%=disbursementAmount%></strong>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Disbursement 1
                        </td>
                        <td>
                            :   <strong><%=disbursement1%></strong>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Disbursement 2
                        </td>
                        <td>
                            :   <strong><%=disbursement2%></strong>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Disbursement 3
                        </td>
                        <td>
                            :   <strong><%=disbursement3%></strong>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Disbursement 4
                        </td>
                        <td>
                            :   <strong><%=disbursement4%></strong>
                        </td>
                    </tr>
                </table>
                <form action="AddProgrammeHandler" method="POST">
                <input name="slaName" type="hidden" value="<%=slaName%>">
                <input name="programmeType" type="hidden" value="<%=programmeType%>">
                <input name="company" type="hidden" value="<%=company%>">
                <input name="numOfLearners" type="hidden" value="<%=numOfLearners%>">
                <input name="startDate" type="hidden" value="<%=startDate%>">
                <input name="endDate" type="hidden" value="<%=endDate%>">
                <input name="disbursementAmount" type="hidden" value="<%=disbursementAmount%>">
                <input name="disbursement1" type="hidden" value="<%=disbursement1%>">
                <input name="disbursement2" type="hidden" value="<%=disbursement2%>">
                <input name="disbursement3" type="hidden" value="<%=disbursement3%>">
                <input name="disbursement4" type="hidden" value="<%=disbursement4%>">
                   <div class="text-center">
                        <button class="btn btn-secondary" onclick="window.history.go(-1);"><i class="fa fa-arrow-left"></i> back</button>
                        <button class="btn btn-md btn-outline-success" type="submit" onclick="return confirm('Are you sure you want to add this programme? Once done the action cannot be undone!')"><i class="fa fa-plus"></i> add programme</button>
                    </div>
                </form>
            </div>
        </main>
    </body>
</html>

