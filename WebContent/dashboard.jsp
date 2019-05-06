<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="cc.littlepig.databases.Database"%>
<%@ page import="cc.littlepig.classes.Caps"%>
<%@page import="java.time.LocalDate"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray" %>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title> Dashboard </title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/reports-customstyle.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Roboto|Varela+Round" rel="stylesheet">
        <link href="https://cdn.datatables.net/1.10.19/css/dataTables.bootstrap4.min.css" rel="stylesheet"/>
        <link rel="shortcut icon" href="http://www.littlepig.cc/wp-content/themes/littlepig/images/favicon.ico?var=xdv53">
        <script src="https://code.jquery.com/jquery-3.3.1.js"></script>
        <!--<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" sintegrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>-->
        <script src="js/bootstrap.js"></script>
        <script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js "></script>
        <script src="https://cdn.datatables.net/1.10.19/js/dataTables.bootstrap4.min.js"></script>
    </head>  
    <body>
        <div class="d-flex" id="wrapper">
            <!-- Sidebar -->
            <div class="bg-light" id="sidebar-wrapper">
                <div class="sidebar-heading bg-dark">
                    <a href="<%=request.getContextPath()%>/DashboardController?action=dashboard">
                        <img src="images/logotop.png" width="100" height="29"alt="lpc logo">
                    </a>
                </div>
                <div class="list-group list-group-flush">
                    <a href="<%=request.getContextPath()%>/DashboardController?action=dashboard" class="list-group-item list-group-item-action bg-light"><i class="fa fa-home"></i> Dashboard</a>
                    <a class="dropdown-btn list-group-item list-group-item-action bg-light" href="#">                            
                        <i class="fa fa-file-text"></i> Reports
                        <i class="fa fa-caret-down" style="position: absolute; left: 90%;"></i></a>
                    <div class="dropdown-container">
                        <a href="<%=request.getContextPath()%>/DashboardController?action=quarterly-reports" class="list-group-item list-group-item-action bg-light"><i class="fa fa-file-text-o"></i> Quarterly Report</a>
                        <a href="<%=request.getContextPath()%>/DashboardController?action=site-visit-reports" class="list-group-item list-group-item-action bg-light"><i class="fa fa-file-text-o"></i> Site Visit Reports</a>
                        <a href="<%=request.getContextPath()%>/DashboardController?action=final-reports" class="list-group-item list-group-item-action bg-light"><i class="fa fa-file-text-o"></i> Final Report</a>
                    </div>
                    <a class="dropdown-btn list-group-item list-group-item-action bg-light" href="#">
                        <i class="fa fa-cog"></i> Options 
                        <i class="fa fa-caret-down" style="position: absolute; left: 90%;"></i></a>
                    <div class="dropdown-container">
                        <a href="addLearner.jsp" class="list-group-item list-group-item-action bg-light"><i class="fa fa-user-plus"></i> Add Learners</a>
                        <a href="removeLearner.jsp" class="list-group-item list-group-item-action bg-light"><i class="fa fa-user-times"></i> Remove Learners</a>
                        <a href="addProgramme.jsp" class="list-group-item list-group-item-action bg-light"><i class="fa fa-tasks"></i> Add Programmes</a>
                    </div>
                    <a href="<%=request.getContextPath()%>/DashboardController?action=destroy" class="list-group-item list-group-item-action bg-light"><i class="fa fa-power-off"></i> Sign Out</a>
                </div>
            </div>
            <!-- /#sidebar-wrapper -->

            <!-- Page Content -->
            <div id="page-content-wrapper">

                <nav class="navbar navbar-expand-md navbar-dark bg-dark">
                    <a href="#" class="btn btn-outline-info" id="menu-toggle"><i class="fa fa-align-left"></i> menu</a>
                    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>

                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav ml-auto mt-2 mt-lg-0">
                            <li class="nav-item dropdown">
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
                                    <a class="dropdown-item" href="#"><i class="fa fa-wrench"></i> Account </a>
                                    <div class="dropdown-divider">
                                </div>
									<a href="<%=request.getContextPath()%>/DashboardController?action=destroy" class="dropdown-item"><i class="fa fa-power-off"></i> Sign Out</a>
                                </div>
                            </li>
                        </ul>
                    </div>
                </nav>

                <div class="container-fluid">
                    <br>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item active">Home</li>
                    </ol>
                    <div class="jumbotron">
                        <h1 class="display-6">SLA INFORMATION</h1>
                        <p> Below is a list of all companies and their programmes </p>
                        <hr class="my-9">
                        <div class="accordion" id="accordionOne">
                            <%
                                try {
                                    Database DB = new Database();
                                    Connection con = DB.getCon1();
                                    Statement st = con.createStatement();
                                    st.executeQuery("SELECT DISTINCT sla.company_id, sla_company_details.company_name FROM sla INNER JOIN sla_company_details ON sla_company_details.id = sla.company_id;");
                                    ResultSet rs = st.getResultSet();

                                    while (rs.next()) {
                                        String companyId = rs.getString("company_id");
                                        String companyName = rs.getString("sla_company_details.company_name");
                            %>
                            <div class="card">
                                <div class="card-header" id="heading<%=companyId%>">
                                    <h5 class="mb-0">
                                        <button class="btn btn-link collapsed" type="button" data-toggle="collapse" data-target="#collapse<%=companyId%>" aria-expanded="true" aria-controls="collapse<%=companyId%>" style="font-size: 1.5rem;">
                                            <i class="fa fa-building-o fa-lg"></i> <%=companyName%>
                                        </button>
                                    </h5>
                                </div>
                                <div id="collapse<%=companyId%>" class="collapse" aria-labelledby="heading<%=companyId%>" data-parent="#accordionOne">
                                    <div class="card-body">
                                        <div id="faq" role="tablist" aria-multiselectable="true">

                                            <div class="card mb-3">
                                                <div class="card-header">
                                                    <ul class="nav nav-tabs card-header-tabs" id="pills-tab<%=companyId%>" role="tablist">
                                                        <li class="nav-item">
                                                            <a class="nav-link active" id="pills-home-tab<%=companyId%>" data-toggle="pill" href="#pills-home<%=companyId%>" role="tab" aria-controls="pills-home<%=companyId%>" aria-selected="true"><i class="fa fa-spinner"></i> acitve programmes</a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a class="nav-link" id="pills-profile-tab" data-toggle="pill" href="#pills-profile<%=companyId%>" role="tab" aria-controls="pills-profile<%=companyId%>" aria-selected="false"><i class="fa fa-tasks"></i> inactive programmes</a>
                                                        </li>
                                                    </ul>
                                                </div>
                                                <div class="card-body">
                                                    <div class="tab-content" id="pills-tab<%=companyId%>Content">
                                                        <div class="tab-pane fade show active" id="pills-home<%=companyId%>" role="tabpanel" aria-labelledby="pills-home-tab<%=companyId%>">
                                                            <h5 class="card-title">SLA programmes in progress:</h5>
                                                            <%
                                                                try {
                                                                    String sla_id, sla, sla_type, numOfLearners, start_date, end_date;
                                                                    Database DB3 = new Database();
                                                                    Connection con3 = DB3.getCon1();
                                                                    Statement st3 = con3.createStatement();
                                                                    st3.executeQuery("SELECT Name, id, type, Number_of_learners, DATE_FORMAT(start_date, '%d/%b/%y') start_date, DATE_FORMAT(end_date, '%d/%b/%y') end_date FROM sla WHERE company_id = " + companyId + " AND end_date >= NOW();");
                                                                    ResultSet rs3 = st3.getResultSet();
                                                                    while (rs3.next()) {

                                                                        sla = rs3.getString("Name").trim();
                                                                        sla_id = rs3.getString("id");
                                                                        sla_type = rs3.getString("type");
                                                                        numOfLearners = rs3.getString("number_of_learners");
                                                                        start_date = rs3.getString("start_date");
                                                                        end_date = rs3.getString("end_date");
                                                            %>
                                                            <div class="card" style="font-size: 1rem;">
                                                                <div class="card-header" role="tab" id="question<%=sla_id%>">
                                                                    <h5 class="card-title">
                                                                        <a data-toggle="collapse" data-parent="#faq" href="#answer<%=sla_id%>" aria-expanded="false" aria-controls="answer<%=sla_id%>" style="font-size: 1.05rem;">
                                                                            <%=sla_id + ". " + sla + ": " + sla_type + " (" + numOfLearners + " learners) | INTERVAL [" + start_date + " - " + end_date + " ]"%> 
                                                                        </a>
                                                                    </h5>
                                                                </div>
                                                                <div id="answer<%=sla_id%>" class="collapse" role="tabcard" aria-labelledby="question<%=sla_id%>">
                                                                    <div class="card-body">
                                                                        <script type="text/javascript" charset="utf-8">
                                                                            $(document).ready(function () {
                                                                                $('#example<%=sla_id%>').DataTable({
                                                                                    "processing": false,
                                                                                    "serverSide": false,
                                                                                    "ajax": "<%=request.getContextPath()%>/DataTableServlet?id=<%=sla_id%>",
                                                                                    "columns": [
                                                                                        {"data": "count"},
                                                                                        {"data": "applicantId"},
                                                                                        {"data": "surname"},
                                                                                        {"data": "name"},
                                                                                        {"data": "gender"},
                                                                                        {"data": "race"},
                                                                                        {"data": "disability"},
                                                                                        {"data": "occupation"}
                                                                                    ] 
                                                                                });
                                                                            });
                                                                        </script>
                                                                        <table id="example<%=sla_id%>" class="table table-hover table-sm table-responsive text-nowrap" style="width: 100%;">
                                                                            <thead class="thead-light">
                                                                                <tr>
                                                                                    <th>No.</th>
                                                                                    <th>Applicant ID</th>
                                                                                    <th>Last Name</th>
                                                                                    <th>First Name</th>
                                                                                    <th>Gender</th>
                                                                                    <th>Race</th>
                                                                                    <th>Disability</th>
                                                                                    <th>Occupation</th>
                                                                                </tr>
                                                                            </thead>
                                                                        </table>                           
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <%
                                                                    }
                                                                    con3.close();
                                                                } catch (SQLException e) {
                                                                    System.out.println(e);
                                                                }
                                                            %>
                                                        </div>
                                                        <div class="tab-pane fade" id="pills-profile<%=companyId%>" role="tabpanel" aria-labelledby="pills-profile-tab">
                                                            <h5 class="card-title">SLA programmes completed:</h5>
                                                            <%
                                                                try {
                                                                    String sla_id, sla, sla_type, numOfLearners, start_date, end_date;
                                                                    Database DB3 = new Database();
                                                                    Connection con3 = DB3.getCon1();
                                                                    Statement st3 = con3.createStatement();
                                                                    st3.executeQuery("SELECT Name, id, type, Number_of_learners, DATE_FORMAT(start_date, '%d/%b/%y') start_date, DATE_FORMAT(end_date, '%d/%b/%y') end_date FROM sla WHERE company_id = " + companyId + " AND end_date <= NOW();");
                                                                    ResultSet rs3 = st3.getResultSet();

                                                                    while (rs3.next()) {

                                                                        sla = rs3.getString("Name").trim();
                                                                        sla_id = rs3.getString("id");
                                                                        sla_type = rs3.getString("type");
                                                                        numOfLearners = rs3.getString("number_of_learners");
                                                                        start_date = rs3.getString("start_date");
                                                                        end_date = rs3.getString("end_date");
                                                            %>
                                                            <div class="card">
                                                                <div class="card-header" role="tab" id="question<%=sla_id%>">
                                                                    <h5 class="card-title">
                                                                        <a data-toggle="collapse" data-parent="#faq" href="#answer<%=sla_id%>" aria-expanded="false" aria-controls="answer<%=sla_id%>" style="font-size: 1.05rem;">
                                                                            <%=sla_id + ". " + sla + ": " + sla_type + " (" + numOfLearners + " learners) | INTERVAL [" + start_date + " - " + end_date + " ]"%> 
                                                                        </a>
                                                                    </h5>
                                                                </div>
                                                                <div id="answer<%=sla_id%>" class="collapse" role="tabcard" aria-labelledby="question<%=sla_id%>">
                                                                    <div class="card-body">
                                                                        <script type="text/javascript" charset="utf-8">
                                                                            $(document).ready(function () {
                                                                                $('#example<%=sla_id%>').DataTable({
                                                                                	"processing": false,
                                                                                    "serverSide": false,
                                                                                    "ajax": "<%=request.getContextPath()%>/DataTableServlet?id=<%=sla_id%>",
                                                                                    "columns": [
                                                                                        {"data": "count"},
                                                                                        {"data": "applicantId"},
                                                                                        {"data": "surname"},
                                                                                        {"data": "name"},
                                                                                        {"data": "gender"},
                                                                                        {"data": "race"},
                                                                                        {"data": "disability"},
                                                                                        {"data": "occupation"}
                                                                                    ] 
                                                                                });
                                                                            });
                                                                        </script>
                                                                        <table id="example<%=sla_id%>" class="table table-hover table-sm table-responsive text-nowrap" style="width: 100%;">
                                                                            <thead class="thead-light">
                                                                                <tr>
                                                                                    <th>No.</th>
                                                                                    <th>Applicant ID</th>
                                                                                    <th>Last Name</th>
                                                                                    <th>First Name</th>
                                                                                    <th>Gender</th>
                                                                                    <th>Race</th>
                                                                                    <th>Disability</th>
                                                                                    <th>Occupation</th>
                                                                                </tr>
                                                                            </thead>
                                                                        </table>                           
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <%
                                                                    }
                                                                    con3.close();
                                                                } catch (SQLException e) {
                                                                    System.out.println(e);
                                                                }
                                                            %>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                                    }
                                    con.close();
                                } catch (SQLException e) {
                                    System.out.println(e);
                                }
                            %>
                        </div>
                    </div>
                    <!-- Sticky Footer -->
                    <footer class="sticky-footer">
                        <div class="container my-auto">
                            <div class="copyright text-center">
                                <span>Copyright © Little Pig <%=LocalDate.now().getYear()%></span>
                            </div>
                        </div>
                    </footer>
                </div>
            </div>
        </div>
        <script>
            var dropdown = document.getElementsByClassName("dropdown-btn");
            var i;
            for (i = 0; i < dropdown.length; i++) {
                dropdown[i].addEventListener("click", function () {
                    this.classList.toggle("active");
                    var dropdownContent = this.nextElementSibling;
                    if (dropdownContent.style.display === "block") {
                        dropdownContent.style.display = "none";
                    } else {
                        dropdownContent.style.display = "block";
                    }
                });
            }
            $("#menu-toggle").click(function (e) {
                e.preventDefault();
                $("#wrapper").toggleClass("toggled");
            });
        </script>
    </body>
</html>
