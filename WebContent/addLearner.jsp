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
        <link rel="shortcut icon" href="http://www.littlepig.cc/wp-content/themes/littlepig/images/favicon.ico?var=xdv53">
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
                    <div class="card mb-3">
                        <div class="card-header">
                            <ul class="nav nav-tabs card-header-tabs" id="pills-tab" role="tablist">
                                <li class="nav-item">
                                    <a class="nav-link active" id="pills-home-tab" data-toggle="pill" href="#pills-home" role="tab" aria-controls="pills-home" aria-selected="true"><i class="fa fa-user"></i> one learner</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="pills-profile-tab" data-toggle="pill" href="#pills-profile" role="tab" aria-controls="pills-profile" aria-selected="false"><i class="fa fa-users"></i> multiple learners</a>
                                </li>
                            </ul>
                        </div>
                        <div class="card-body">
                            <div class="tab-content" id="pills-tabContent">
                                <div class="tab-pane fade show active" id="pills-home" role="tabpanel" aria-labelledby="pills-home-tab">
                                    <h5 class="card-title">Fill The Following Fields To Add A Learner</h5>
                                    <form action="addLearnerConfirmation.jsp" method="POST">
                                        <div class="form-group">
                                            <label for="learnerName">Learner's Name: </label>
                                            <input name="learnerName" class="form-control" id="learnerName" placeholder="Nobuhle" minlength="2" maxlength="20" pattern="^[a-zA-Z]*$" required="true" title="A name that consists of letters (uppercase or lowercase) only. The number of characters should be at least greater or equal to 2 and also not exceed 20.">                         
                                        </div>
                                        <div class="form-group">
                                            <label for="learnerSurname">Learner's Surname: </label>
                                            <input name="learnerSurname" class="form-control" id="learnerSurname" placeholder="Silimela" minlength="2" maxlength="20" pattern="^[a-zA-Z]*$" required="true" title="A surname that consists of letters (uppercase or lowercase) only. The number of characters should be at least greater or equal to 2 and also not exceed 20.">
                                        </div>
                                        <div class="form-group">
                                            <label for="mictProgramme">MICT Learning Programme: </label>
                                            <script>
                                                $('#mictProgramme').selectpicker();
                                            </script>
                                            <select name="slaDropdown" id="mictProgramme" class="form-control selectpicker" data-dropup-auto="false" data-live-search="true" required>
                                                <option></option>
                                                <%
                                                    try {
                                                        Database DB = new Database();
                                                        Connection con = DB.getCon1();
                                                        Statement st = con.createStatement();
                                                        st.executeQuery("SELECT * FROM sla WHERE end_date >= NOW();");
                                                        ResultSet rs = st.getResultSet();
                                                        while (rs.next()) {
                                                            String sla = rs.getString("Name").trim();
                                                            String sla_id = rs.getString("id");
                                                            String sla_type = rs.getString("type");
                                                            String numOfLearners = rs.getString("number_of_learners");
                                                            out.println("<option>" + sla_id + ". " + sla + " - " + sla_type + " (" + numOfLearners + " learners)" + "</option>");
                                                        }
                                                        con.close();
                                                    } catch (SQLException e) {
                                                        System.out.println(e);
                                                    }
                                                %>
                                            </select>
                                        </div>
                                        <div class="form-row">
                                            <div class="col-6">
                                                <label for="ofo">Occupation: </label> 
                                                <script>
                                                    $('#ofos').selectpicker();
                                                </script>
                                                <select name="ofos" id="ofos" class="form-control selectpicker" data-dropup-auto="false" data-live-search="true" required>
                                                    <option></option>
                                                    <%
                                                        try {
                                                        	Database DB = new Database();
                                                            Connection con = DB.getCon1();
                                                            Statement st = con.createStatement();
                                                            st.executeQuery("SELECT * FROM sla_ofo_codes;");
                                                            ResultSet rs = st.getResultSet();
                                                            while (rs.next()) {
                                                                String num = rs.getString("id").trim();
                                                                String occupation = rs.getString("occupations").trim();
                                                                out.println("<option>" + num + ". " + occupation + "</option>");
                                                            }
                                                            con.close();
                                                        } catch (SQLException e) {
                                                            System.out.println(e);
                                                        }
                                                    %>
                                                </select>                                
                                            </div>
                                            <div class="col-auto">
                                                <label for="startDate">Learner's Start Date: </label>   
                                            	<input class="form-control" style="background-color:#fff;" id="startDate" type="text" name="startDate" required placeholder="YYYY-MM-DD" pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" title="The date should be in this format: YYYY-MM-DD">
                                            </div>
                                        </div>
                                        <div class="form-group" style="padding-top: 2%">
                                            <center>
                                                <button class="btn btn-md btn-outline-primary" type="submit">
                                                    <i class="fa fa-send" aria-hidden="true"></i> submit
                                                </button>
                                            </center>
                                        </div>
                                    </form>
                                </div>
                                <div class="tab-pane fade" id="pills-profile" role="tabpanel" aria-labelledby="pills-profile-tab">
                                    <h5 class="card-title">Upload a CSV File To Add Multiple Learners</h5>
                                    <p class="card-text">Please upload a csv file formatted in the table structure illustrated below and make sure of the following:</p>
                                    <ul>
                                        <li><b>Do not use any headers</b> <i>(The headers in the figure below are for illustration purposes)</i></li>
                                        <li><b>The date format should be: </b><i>YYYY-MM-DD</i></li>
                                        <li><b>Do not use SLA numbers that are not in the reference list </b><i>(they are inactive programmes)</i></li>
                                        <li><b>For the SLA # and Occupation columns, use the following:</b></li>
                                        <li type="circle" style="padding-right: 5px;">
                                            <div class="form-row">
                                                <div class="form-group col-auto">
                                                    <label>Occupations list: </label>
                                                </div>
                                                <div class="form-group col-md-3">
                                                    <script>
                                                        $('#ofos').selectpicker();
                                                    </script>
                                                    <select name="ofos" id="ofos" class="form-control selectpicker" data-dropup-auto="false" data-live-search="true" required title="click here to view list">
                                                        <option></option>
                                                        <%
                                                            try {
                                                            	Database DB = new Database();
                                                                Connection con = DB.getCon1();
                                                                Statement st = con.createStatement();
                                                                st.executeQuery("SELECT * FROM sla_ofo_codes;");
                                                                ResultSet rs = st.getResultSet();
                                                                while (rs.next()) {
                                                                    String num = rs.getString("id").trim();
                                                                    String occupation = rs.getString("occupations").trim();
                                                                    out.println("<option>" + num + " = " + occupation + "</option>");
                                                                }
                                                                con.close();
                                                            } catch (SQLException e) {
                                                                System.out.println(e);
                                                            }
                                                        %>
                                                    </select>
                                                </div>
                                                <div class="form-group col-auto">
                                                    <label>SLA No. list: </label>
                                                </div>
                                                <div class="form-group col-md-5">
                                                    <script>
                                                        $('#mictProgramme').selectpicker();
                                                    </script>
                                                    <select name="slaDropdownFR" id="mictProgramme" class="form-control selectpicker" data-dropup-auto="false" data-live-search="true" required title="click here to view list">
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
                                                                    out.println("<option>" + sla_id + " = " + sla + " - " + sla_type + " (" + numOfLearners + " learners)" + "</option>");
                                                                }
                                                                con.close();
                                                            } catch (SQLException e) {
                                                                System.out.println(e);
                                                            }
                                                        %>
                                                    </select>
                                                </div>
                                            </div>
                                        </li>
                                    </ul>
                                    <table id="example" class="table table-sm table-bordered">
                                        <thead class="thead-light">
                                            <tr>
                                                <th>ID NUMBER</th>
                                                <th>SLA No.</th>
                                                <th>OCCUPATION</th>
                                                <th>START DATE</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>9703216221082</td>
                                                <td>7</td>
                                                <td>11</td>
                                                <td>2019-01-15</td>
                                            </tr>
                                            <tr>
                                                <td>9305216221082</td>
                                                <td>7</td>
                                                <td>2</td>
                                                <td>2018-08-20</td>
                                            </tr>
                                            <tr>
                                                <td>9406165221082</td>
                                                <td>8</td>
                                                <td>402</td>
                                                <td>2017-05-08</td>
                                            </tr>
                                            <tr>
                                                <td>9903216221082</td>
                                                <td>9</td>
                                                <td>1</td>
                                                <td>2018-01-10</td>
                                            </tr>
                                            <tr>
                                                <td>9903216221082</td>
                                                <td>3</td>
                                                <td>11</td>
                                                <td>2018-01-10</td>
                                            </tr>
                                            <tr>
                                                <td>9903216221082</td>
                                                <td>2</td>
                                                <td>19</td>
                                                <td>2018-03-10</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <hr class="my-3">
                                    <form method="POST" action="AddBulkLearnersUploadHandler" enctype="multipart/form-data">
                                        <div class="form-row">
                                            <div class="col-auto">
                                                <label for="file4" style="font-size: x-large;">choose a file to upload: </label>
                                                <input class="form-control-file btn btn-sm btn-info btn-outline-dark" type="file" id="file4" name="file4" required="true"  pattern="^.+\.(([pP][dD][fF])|([jJ][pP][gG]))$" title="file must include .csv file extension"/>
                                            </div>
                                        </div>
                                        <div class="form-group" style="padding-top: 2%">
                                            <center>
                                                <button class="btn btn-md btn-outline-primary" type="submit" onclick="return confirm('Are you sure you want to upload the selected file to add multiple learners?')">
                                                    <i class="fa fa-upload" aria-hidden="true"></i> upload
                                                </button>
                                            </center>
                                        </div>
                                    </form>
                                </div>
                            </div>
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
			$('#startDate').datepicker({
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