<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="cc.littlepig.databases.Database"%>
<%@ page import="cc.littlepig.classes.Caps"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title> New SLA Programme </title>
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
                        <li class="breadcrumb-item active">Add Programme</li>
                    </ol>
                    ${message}
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- new sla card-->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h4 class="display-9">New SLA programme</h4>
                                </div>
                                <div class="card-body">
                                    <h6 class="card-title font-weight-bold text-secondary">Fill in all form fields to create a new SLA programme</h6>
                                    <form action="addProgrammeConfirmation.jsp" method="POST">
                                        <div class="form-group">
                                            <label for="slaName">SLA Name: </label>
                                            <input name="slaName" class="form-control" id="slaName" type="text" placeholder="MICT/NPVT/Intern/LOI/20172018/00252" minlength="20" maxlength="35" pattern="^[A-Za-z0-9/]*$" required="true" title="A name that consists of letters (uppercase or lowercase), numbers, and forward slashes. The number of characters should be at least greater or equal to 20 and also not exceed 35.">
                                        </div>
                                        <div class="form-group">
                                            <label for="programmeType">Programme Type: </label>
                                            <input name="programmeType" class="form-control" list="programmeList" id="programmeType" type="text" placeholder="Internship" pattern="^[A-Z]+[a-z]*$" required="true" title="A name that starts with a Capital letter (A-Z) followed by any number of Letters in lower case.">
                                            <datalist id="programmeList">
                                                <option>Bursary</option>
                                                <option>Internship</option>
                                                <option>Learnership</option>
                                                <option>Scholarship</option>
                                            </datalist>
                                        </div>
                                        <div class="form-group form-row">
                                            <div class="col-auto col-md-6">
                                                <label for="company">Company Name (if not listed, add a new one below): </label>
                                                <select name="company" class="form-control" id="company" type="text" required="true">
                                                    <option></option>
                                                    <%
                                                        try {
                                                            Database DB = new Database();
                                                            Connection con = DB.getCon1();
                                                            Statement st = con.createStatement();
                                                            st.executeQuery("SELECT * FROM sla_company_details;");
                                                            ResultSet rs = st.getResultSet();
                                                            while (rs.next()) {
                                                                String companyName = rs.getString("company_name").trim();
                                                                String company_id = rs.getString("id");
                                                                out.println("<option>" + company_id + ". " + companyName + "</option>");
                                                            }
                                                            con.close();
                                                        } catch (SQLException e) {
                                                            System.out.println(e);
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                            <div class="col-auto col-md-2">
                                                <label for="learnerNum">No. Of Learners: </label>   
                                                <input name="learnerNum" class="form-control" id="learnerNum" placeholder="35"  min="1" max="250" type="number" pattern="^[0-9]*$" required="true" title="Must have numbers only. minimum of 1 and a maximum of 250.">
                                            </div>
                                            <div class="col-auto col-md-4">
                                                <label for="disbursementAmount">Total Amount (R): </label>   
                                                <input name="disbursementAmount" class="form-control" id="disbursementAmount"  min="0" max="1000000000" placeholder="70000" type="number" step="1" min="0" max="1000000000" pattern="^[0-9]*$" required="true" title="Must have numbers only. minimum of R50 and a maximum of R1 000 000 000.">
                                            </div>
                                        </div>
                                        <div class="form-group form-row">
                                            <div class="col-md-6">
                                                <label for="startDate">Start Date: </label>
                                                <%-- <input id="startDate" class="form-control" type="date" name="startDate" min="<%=LocalDate.now().minusMonths(3)%>" max="<%=LocalDate.now().plusMonths(3)%>" required="true" pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" title="The date should be in this format: YYYY-MM-DD"> --%>
                                            	<input class="form-control" style="background-color:#fff;" id="startDate" type="text" name="startDate" required placeholder="YYYY-MM-DD" pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" title="The date should be in this format: YYYY-MM-DD">
                                            </div>
                                            <div class="col-md-6">
                                                <label for="endDate">End Date: </label>   
                                                <%-- <input id="endDate" class="form-control" type="date" name="endDate" min="<%=LocalDate.now().plusMonths(3)%>" max="<%=LocalDate.now().plusYears(2)%>" required="true" pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" title="The date should be in this format: YYYY-MM-DD"> --%>
                                            	<input class="form-control" style="background-color:#fff;" id="endDate" name="endDate" type="text" name="endDate" required placeholder="YYYY-MM-DD" pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" title="The date should be in this format: YYYY-MM-DD">
                                            </div>
                                        </div>
                                        <div class="form-group form-row">
                                            <div class="col-auto col-md-3">
                                                <label for="disbursement1" style="font-size: small">Disbursement 3 (%): </label>   
                                                <input name="disbursement1" class="form-control" id="disbursement1" type="number" step="1" min="0" max="100" placeholder="20" pattern="^[0-9]*$" required="true" title="Must have numbers only. minimum of 0% and a maximum of 100%.">
                                            </div>
                                            <div class="col-auto col-md-3">
                                                <label for="disbursement2" style="font-size: small">Disbursement 4 (%): </label>   
                                                <input name="disbursement2" class="form-control" id="disbursement2" type="number" step="1" min="0" max="100" placeholder="20" pattern="^[0-9]*$" required="true" title="Must have numbers only. minimum of 0% and a maximum of 100%.">
                                            </div>
                                            <div class="col-auto col-md-3">
                                                <label for="disbursement3" style="font-size: small">Disbursement 5 (%): </label>   
                                                <input name="disbursement3" class="form-control" id="disbursement3" type="number" step="1" min="0" max="100" placeholder="30" pattern="^[0-9]*$" required="true" title="Must have numbers only. minimum of 0% and a maximum of 100%.">
                                            </div>
                                            <div class="col-auto col-md-3">
                                                <label for="disbursement4" style="font-size: small">Disbursement 6 (%): </label>   
                                                <input name="disbursement4" class="form-control" id="disbursement4" placeholder="15" type="number" step="1" min="0" max="100" pattern="^[0-9]*$" title="Must have numbers only. minimum of 0% and a maximum of 100%.">
                                            </div>
                                        </div>
                                        <div class="btn-group-md">
                                            <div class="text-center">
                                                <button class="btn btn-md btn-outline-primary" type="submit">
                                                    <i class="fa fa-send" aria-hidden="true"></i> submit
                                                </button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- add company card-->
	                    <div class="row">
                            <div class="col-auto col-md-12">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h4 class="display-9">New Company</h4>
                                    </div>
                                    <div class="card-body">
                                        <h6 class="card-title font-weight-bold text-secondary">Fill in all form fields to add a new company name</h6>
                                        <form action="addCompanyConfirmation.jsp" method="POST">
                                            <div style="display:none;" id="myAlert">
                                                <div class="alert alert-warning alert-dismissable" id="myAlert2">
                                                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><b>Warning!</b> Please fill in all the form fields.
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="company">Company name: </label>
                                                <input name="company" id="company" class="form-control" type="text" placeholder="Little Pig CC" minlength="2" maxlength="50" pattern="^[A-Z]+[a-z ]*$" required="true" title="A name that starts with a Capital letter (A-Z) followed by any number of Letters in lower case.">
                                            </div>
                                            <div class="form-group">
                                                <label for="address">Physical Address (main address): </label>
                                                <input name="street" id="street" class="form-control" type="text" placeholder="Street" minlength="2" maxlength="30" pattern="^[a-zA-Z 0-9.]*$" required="true" title="A street name that consists of letters (uppercase or lowercase), a period (.), or numbers only. The number of characters should be at least greater or equal to 2 and also not exceed 30.">
                                                <input name="building" id="building" class="form-control" type="text" placeholder="Building" minlength="2" maxlength="30" pattern="^[a-zA-Z 0-9.]*$" title="A building name that consists of letters (uppercase or lowercase), a period (.), or numbers only. The number of characters should be at least greater or equal to 2 and also not exceed 30.">
                                                <input name="surbub" id="surbub" class="form-control" type="text" placeholder="Surbub" minlength="2" maxlength="30" pattern="^[a-zA-Z ]*$" required="true" title="A surbub name that consists of letters (uppercase or lowercase) only. The number of characters should be at least greater or equal to 2 and also not exceed 30.">
                                                <input name="town" id="town" class="form-control" type="text" placeholder="Town" minlength="2" maxlength="50" pattern="^[a-zA-Z ]*$" required="true" title="A town name that consists of letters (uppercase or lowercase) only. The number of characters should be at least greater or equal to 2 and also not exceed 50.">
                                                <input name="postal" id="postal" class="form-control" type="text" placeholder="Postal" minlength="4" maxlength="4" pattern="^[0-9]*$" required="true" title="A postal code must consists of only four digits.">
                                                <input name="address" id="address" type="hidden">
                                            </div>
                                            <div class="form-row">
                                                <div class="col-auto col-md-6">
                                                    <label for="regNumber">Registration Number: </label>
                                                    <input name="regNumber" class="form-control" id="regNumber" type="text" placeholder="L882788583" minlength="10" maxlength="20" pattern="^[A-Za-z0-9]*$" required="true" title="A registration number that consists of letters (uppercase or lowercase) and numbers. The number of characters should be at least greater or equal to 10 and also not exceed 20.">
                                                </div>
                                                <div class="col-auto col-md-6">
                                                    <label for="agredNumber">Agredidation Number: </label>   
                                                    <input name="agredNumber" class="form-control" id="agredNumber" type="text" placeholder="ACC/2014/02/0186" minlength="5" maxlength="25" pattern="^[A-Za-z0-9/]*$" required="true" title="An agredidation number that consists of letters (uppercase or lowercase), numbers, and forward slashes. The number of characters should be at least greater or equal to 5 and also not exceed 25.">
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="col-auto col-md-6">
                                                    <label for="repEmpName">Representative Employer First Name: </label>
                                                    <input name="repEmpName" class="form-control" id="repEmpName" type="text" placeholder="Employer Name" minlength="2" maxlength="30" pattern="^[A-Z]+[a-z]*$" required="true" title="A name that starts with a Capital letter (A-Z) followed by any number of Letters in lower case.">
                                                </div>
                                                <div class="col-auto col-md-6">
                                                    <label for="repEmpSurname">Representative Employer Last Name: </label>   
                                                    <input name="repEmpSurname" class="form-control" id="repEmpSurname" type="text" placeholder="Employer Surname" minlength="2" maxlength="30" pattern="^[A-Z]+[a-z]*$" required="true" title="A name that starts with a Capital letter (A-Z) followed by any number of Letters in lower case.">
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="col-auto col-md-6">
                                                    <label for="advisorName">SETA Advisor First Name: </label>
                                                    <input name="advisorName" class="form-control" id="advisorName" type="text" placeholder="SETA Advisor Name" minlength="2" maxlength="30" pattern="^[A-Z]+[a-z]*$" required="true" title="A name that starts with a Capital letter (A-Z) followed by any number of Letters in lower case.">
                                                </div>
                                                <div class="col-auto col-md-6">
                                                    <label for="advisorSurname">SETA Advisor Last Name: </label>   
                                                    <input name="advisorSurname" class="form-control" id="advisorSurname" type="text" placeholder="SETA Advisor Surname" minlength="2" maxlength="30" pattern="^[A-Z]+[a-z]*$" required="true" title="A name that starts with a Capital letter (A-Z) followed by any number of Letters in lower case.">
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="col-auto col-md-6">
                                                    <label for="managerName">Programme Manager First Name: </label>                                                
                                                    <input name="managerName" class="form-control" id="managerName" type="text" placeholder="Programme Manager Name" minlength="2" maxlength="30" pattern="^[A-Z]+[a-z]*$" required="true" title="A name that starts with a Capital letter (A-Z) followed by any number of Letters in lower case.">
                                                </div>
                                                <div class="col-auto col-md-6">
                                                    <label for="managerSurname">Programme Manager Last Name: </label>   
                                                    <input name="managerSurname" class="form-control" id="managerSurname" type="text" placeholder="Programme Manager Surname" minlength="2" maxlength="30" pattern="^[A-Z]+[a-z]*$" required="true" title="A name that starts with a Capital letter (A-Z) followed by any number of Letters in lower case.">
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="col-auto col-md-6">
                                                    <label for="projectManagerName">Project Manager First Name: </label>
                                                    <input name="projectManagerName" class="form-control" id="projectManagerName" type="text" placeholder="Project  Manager Name" minlength="2" maxlength="30" pattern="^[A-Z]+[a-z]*$" required="true" title="A name that starts with a Capital letter (A-Z) followed by any number of Letters in lower case.">
                                                </div>
                                                <div class="col-auto col-md-6">
                                                    <label for="projectManagerSurname">Project Manager Last Name: </label>   
                                                    <input name="projectManagerSurname" class="form-control" id="projectManagerSurname" type="text" placeholder="Project Manager Surname" minlength="2" maxlength="30" pattern="^[A-Z]+[a-z]*$" required="true" title="A name that starts with a Capital letter (A-Z) followed by any number of Letters in lower case.">
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="col-auto col-md-6">
                                                    <label for="projectManagerCell">Project Manager Cell: </label>
                                                    <input name="projectManagerCell" class="form-control" id="projectManagerCell" type="text" minlength="10" maxlength="30" placeholder="Project  Manager Mobile" pattern="^[0]+[0-9]*$" required="true" title="Any combination of ten digits or above that starts with the number zero.">
                                                </div>
                                                <div class="col-auto col-md-6">
                                                    <label for="projectManagerTel">Project Manager Tel: </label>   
                                                    <input name="projectManagerTel" class="form-control" id="projectManagerTel" type="text" minlength="10" maxlength="30" placeholder="Project  Manager Telephone" pattern="^[0]+[0-9]*$" required="true" title="Any combination of ten digits or above that starts with the number zero.">
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="col-auto col-md-6">
                                                    <label for="projectManagerMail">Project Manager Email: </label>
                                                    <input name="projectManagerMail" class="form-control" id="projectManagerMail" type="email" placeholder="Project  Manager Email" required="true">
                                                </div>
                                            </div>
                                            <div class="form-row">
                                            	<label for="up">Upload A Company Logo (if any) </label>
								                <!-- <form id="up" method="POST" action="#" target="_blank" enctype="multipart/form-data"> -->
								                    <div class="col-auto col-md-12">
								                        <label>Choose a file: </label>
								                        <input class="btn btn-sm btn-info btn-outline-secondary" type="file" name="file" required="false"/>
								                        <button class="btn btn-md btn-info btn-outline-secondary" type="button" name="file"">
								                            <i class="fa fa-upload" aria-hidden="true"></i> Upload
								                        </button>
								                    </div>
								                <!-- </form> -->
                                            </div>
                                            <br>
                                            <div class="form-row">
                                                <div class="col-auto col-md-12">
                                                    <div class="text-center">
                                                        <button class="btn btn-md btn-outline-primary" type="submit" onclick="addAddress()"><i class="fa fa-send"></i> submit</button>
                                                    </div>
                                                </div>
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
        	//address fields to one line
        	function addAddress(){
        		if ($('#building').val() != "") {
        		$("#address").val($('#street').val() +", "+ $('#building').val() +", "+ $('#surbub').val() +", "+ $('#town').val() +", "+ $('#postal').val());					
				} else {
        		$("#address").val($('#street').val() +", "+ $('#surbub').val() +", "+ $('#town').val() +", "+ $('#postal').val());										
				}
        	}
			//datepicker
			$('#startDate').datepicker({
				dateFormat : 'yy-mm-dd', minDate: "-3M", maxDate: "+3M"
			}).on('keypress', function(e){ e.preventDefault(); });
			$('#endDate').datepicker({
				dateFormat : 'yy-mm-dd', minDate: "+3M", maxDate: "+2Y"
			}).on('keypress', function(e){ e.preventDefault(); });
            //validate date input
            function clean(el) {
                var textfield = document.getElementById(el);
                var regex = /[^0-9\-]/g;
                if (textfield.value.search(regex) > -1) {
                    textfield.value = textfield.value.replace(regex, "");
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