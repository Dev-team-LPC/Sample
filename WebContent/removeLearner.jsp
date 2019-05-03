<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="cc.littlepig.databases.Database"%>
<%@ page import="cc.littlepig.classes.Caps"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title> Replacements </title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">  		
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link href="https://fonts.googleapis.com/css?family=Roboto|Varela+Round" rel="stylesheet">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
        <!-- datepicker -->        
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  		<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>        
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css" />
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
        <link rel="stylesheet" href="css/reports-customstyle.css">
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
                    <a href="#" class="list-group-item list-group-item-action bg-light">Overview</a>
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
                        <li class="breadcrumb-item">
                            <a href="main.jsp">Home</a>
                        </li>
                        <li class="breadcrumb-item active">Add Learner</li>
                    </ol>
                    ${message}
                    <!-- resignations card-->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h4 class="display-9">Learner Resignation</h4>
                        </div>
                        <div class="card-body">
                            <h6 class="card-title font-weight-bold text-secondary">Fill in all form fields to remove a learner (repeat this action to remove a learner permanently)</h6>
                            <form action="removeLearnerConfirmation.jsp" method="POST">
                                <div class="form-row">
                                    <div class="form-group col-md-6"> 
                                        <label for="internName">Learner's Name: </label>
                                        <input name="internName" class="form-control" id="internName" placeholder="Zusiphe" minlength="2" maxlength="20" pattern="^[a-zA-Z]*$" required="true" title="A name that consists of letters (uppercase or lowercase) only. The number of characters should be at least greater or equal to 2 and also not exceed 20.">                                
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="internSurname">Learner's Surname: </label>
                                        <input name="internSurname" class="form-control" id="internSurname" placeholder="Peza" minlength="2" maxlength="20" pattern="^[a-zA-Z]*$" required="true" title="A surname that consists of letters (uppercase or lowercase) only. The number of characters should be at least greater or equal to 2 and also not exceed 20.">
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="col-auto col-md-6">
                                        <label for="mictProgramme">MICT Learning Programme: </label>
                                        <script>
                                            $('#mictProgramme').selectpicker();
                                        </script>
                                        <select name="slaDropdown" id="mictProgramme" class="form-control selectpicker" data-dropup-auto="false" data-live-search="true" required>
                                            <option></option>
                                            <%
                                                String sla_id, sla, sla_type, numOfLearners;
                                                try {
                                                    Connection con = new Database().getCon1();
                                                    Statement st = con.createStatement();
                                                    st.executeQuery("SELECT * FROM sla WHERE end_date >= NOW();");
                                                    ResultSet rs = st.getResultSet();
                                                    while (rs.next()) {
                                                        sla = rs.getString("Name").trim();
                                                        sla_id = rs.getString("id");
                                                        sla_type = rs.getString("type");
                                                        numOfLearners = rs.getString("number_of_learners");
                                                        out.println("<option>" + sla_id + ". " + sla + " - " + sla_type + " (" + numOfLearners + " learners)" + "</option>");
                                                    }
                                                    con.close();
                                                } catch (SQLException e) {
                                                    System.out.println(e);
                                                }
                                            %>
                                        </select>
                                    </div>
                                    <div class="col-auto col-md-6">
                                        <label for="resignDate">Learner's Resignation Date: </label>   
                                    	<input class="form-control" style="background-color:#fff;" id="resignDate" type="text" name="resignDate" required placeholder="YYYY-MM-DD" pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" title="The date should be in this format: YYYY-MM-DD">
                                    </div>
                                </div>
                                <div class="col-auto col-md-12" style="padding-top: 2%">
                                    <center>
                                        <button class="btn btn-md btn-outline-primary" type="submit">
                                            <i class="fa fa-send" aria-hidden="true"></i> submit
                                        </button>
                                    </center>
                                </div>
                            </form>
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
            <!-- /#page-content-wrapper -->
        </div>
        <!-- /#wrapper -->

        <script>
			//datepicker
			$('#resignDate').datepicker({
				dateFormat : 'yy-mm-dd', minDate: "-6M", maxDate: "+6M"
			}).on('keypress', function(e){ e.preventDefault(); });
            //validate form input
            function generateReport() {
                var x = document.forms["myform"]["slasDropdownQR"].value;
                var y = document.forms["myform"]["numOfMonths"].value;
                var z = document.forms["myform"]["date"].value;
                if (z !== "" && y !== "" && x !== "") {
                    $("#sla").val($('#mictProgramme').val());
                    $("#months").val($('#numOfMonths').val() + " before the date below");
                    $("#creationDate").val($('#date').val());
                    document.getElementById('sla').title = $('#mictProgramme').val();
                    $('#quarterlyReportModal').modal();
                } else {
                    if ($("#myAlert").find("div#myAlert2").length === 0) {
                        $("#myAlert").append("<div class='alert alert-warning alert-dismissable' id='myAlert2'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Warning!</b> Please fill in all the form fields.</div>");
                    }
                    $("#myAlert").css("display", "");
                }
            }
            //Sidebar dropdown
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
            //toggle sidebar on-off
            $("#menu-toggle").click(function (e) {
                e.preventDefault();
                $("#wrapper").toggleClass("toggled");
            });
        </script>
    </body>
</html>