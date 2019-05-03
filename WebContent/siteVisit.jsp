<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="cc.littlepig.databases.Database"%>
<%@ page import="cc.littlepig.classes.Caps"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.sql.*"%> 
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title> Site Visit Reports </title>        
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
                            <a href="<%=request.getContextPath()%>/DashboardController?action=dashboard">Dashboard</a>
                        </li>
                        <li class="breadcrumb-item active">Site Visit Reports</li>
                    </ol>
                    ${message}
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- emails card-->
                            <div class="card mb-3">
                                <div class="card-header">
                                    <ul class="nav nav-tabs card-header-tabs" id="pills-tab" role="tablist">
                                        <li class="nav-item">
                                            <a class="nav-link active" id="pills-home-tab" data-toggle="pill" href="#pills-home" role="tab" aria-controls="pills-home" aria-selected="true"><i class="fa fa-send"></i> send email</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" id="pills-profile-tab" data-toggle="pill" href="#pills-profile" role="tab" aria-controls="pills-profile" aria-selected="false"><i class="fa fa-info-circle"></i> check replies</a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="card-body">
                                    <div class="tab-content" id="pills-tabContent">
                                        <div class="tab-pane fade show active" id="pills-home" role="tabpanel" aria-labelledby="pills-home-tab">
                                            <h5 class="card-title font-weight-bold text-secondary">Send e-mails</h5>
                                            <form method="POST" action="<%=request.getContextPath()%>/Emails?action=add-email-list">
                                                <div class="form-label-group form-row">
                                                    <label for="emailGroup">Learning Programme: </label>
                                                    <script>
                                                        $('#emailGroup').selectpicker();
                                                    </script>
                                                    <select name="emailGroup" id="emailGroup" class="form-control selectpicker" data-dropup-auto="false" data-live-search="true" required>                            
                                                        <option></option>
                                                        <%
                                                            try {
                                                                String sla_id, sla, sla_type, numOfLearners;
                                                                Database DB = new Database();
                                                                Connection con = DB.getCon1();
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
                                                <br>
                                                <div class="text-center">
                                                    <div class="btn-group">
                                                        <button type="submit" class="btn btn-outline-primary"><i class="fa fa-send"></i> submit</button>
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                        <div class="tab-pane fade" id="pills-profile" role="tabpanel" aria-labelledby="pills-profile-tab">
                                            <h5 class="card-title font-weight-bold text-secondary">Check e-mail responses</h5>
                                            <p class="alert alert-primary small" style="padding: .25rem 0.25rem;"><i class="fa fa-exclamation-triangle"></i> Before checking replies, you need to have sent an email first!</p>
                                            <form method="post" action="<%=request.getContextPath()%>/Emails?action=email-replies">
                                                <div class="form-row">
                                                    <div class="col-auto col-md-12">
                                                        <label for="replyGroup">learning programme: </label>
                                                        <script>
                                                            $('#replyGroup').selectpicker();
                                                        </script>
                                                        <select name="replyGroup" id="replyGroup" class="form-control selectpicker" data-dropup-auto="false" data-live-search="true" required>
                                                            <option></option>
                                                            <%
                                                                try {
                                                                    String sla_id, sla, sla_type, numOfLearners;
                                                                    Database DB = new Database();
                                                                    Connection con = DB.getCon1();
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
                                                </div>
                                                <br>
                                                <div class="text-center">
                                                    <div class="btn-group">
                                                        <button type="submit" class="btn btn-outline-primary"><i class="fa fa-send"></i> submit</button>
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- generate report card-->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h4 class="display-9">Generate Site Visit Report</h4>
                                </div>
                                <div class="card-body">
                                    <h5 class="card-title font-weight-bold text-secondary">Fill in all form fields to generate a report</h5>
                                    <p class="alert alert-primary small" style="padding: .25rem 0.25rem;"><i class="fa fa-exclamation-triangle"></i> Before creating a site visit report, you need to have sent an email first!</p>
                                    <form name="myform" action="#" method="post">
                                        <div style="display:none;" id="myAlert">
                                            <div class="alert alert-warning alert-dismissable" id="myAlert2">
                                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                                <b>Warning!</b> Please fill in all the form fields.
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <label for="mictProgramme">Learning Programme: </label>
                                            <script>
                                                $('#mictProgramme').selectpicker();
                                            </script>
                                            <select name="slasDropdownQR" id="mictProgramme" class="form-control selectpicker" data-dropup-auto="false" data-live-search="true" required>
                                                <option></option>
                                                <%
                                                    try {
                                                        Database DB = new Database();
                                                        Connection con = DB.getCon1();
                                                        Statement st = con.createStatement();
                                                        st.executeQuery("SELECT * FROM sla WHERE end_date >= NOW();");
                                                        ResultSet rs = st.getResultSet();
                                                        String sla_id, sla, sla_type, numOfLearners;
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
                                        <div class="form-row">
                                            <div class="col-auto col-md-6">
                                                <label for="numOfVisit">Visit #</label>
                                                <script>
                                                    $('#numOfVisit').selectpicker();
                                                </script>
                                                <select name="numOfVisit" id="numOfVisit" class="form-control selectpicker" data-dropup-auto="false" data-live-search="true" required>
                                                    <option></option>
                                                    <option>1</option>
                                                    <option>2</option>
                                                    <option>3</option>
                                                    <option>4</option>
                                                </select>
                                            </div>
                                            <div class="col-auto col-md-6">
                                                <label for="myDate">Creation Date: </label>   
                                                <input class="form-control" style="background-color:#fff;" id="myDate" name="myDate" type="text" readonly name="creationDateQR" required placeholder="YYYY-MM-DD" pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" title="The date should be in this format: YYYY-MM-DD">
                                            </div>
                                        </div>
                                        <br>
                                        <div class="text-center">
                                            <div class="btn-group">
                                                <input class="btn btn-outline-primary" onclick="generateReport()" value="submit" type="button">
                                            </div>
                                        </div>                                        
                                    </form>
                                </div>
                            </div>
                            <!-- Site Visit Report Modal -->
                            <div class="modal fade" id="siteVisitReportModal" tabindex="-1" role="dialog" aria-labelledby="siteVisitReportModalTitle" aria-hidden="true">
                                <div class="modal-dialog" role="document">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h1 class="modal-title h3 mb-3 font-weight-normal" id="siteVisitReportModalTitle"> Review Changes </h1>
                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                        <form action="<%=request.getContextPath()%>/DashboardController?action=generate-site-visit-reports" method="POST">
                                            <div class="modal-body">
                                                <div class="form-label-group">
                                                    <i class="fa fa-tasks"></i> <label for="sla">Learning Programme:</label>
                                                    <input class="form-control" id="sla" name="sla" required type="text" readonly>
                                                </div>

                                                <div class="form-label-group">
                                                    <i class="fa fa-clock-o"></i> <label for="visit">Visit #:</label>
                                                    <input class="form-control" id="visit" name="visit" required type="text" readonly>
                                                </div>

                                                <div class="form-label-group">
                                                    <i class="fa fa-calendar"></i> <label for="creationDate">Creation Date:</label>
                                                    <input class="form-control" id="creationDate" name="creationDate" readonly title="The date should be in this format: YYYY-MM-DD">
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-md btn-secondary" data-dismiss="modal">cancel</button>
                                                <button role="button" type="submit" class="btn btn-md btn-success">forward</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- list generated reports card-->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h4 class="display-9">Site Visit Reports</h4>
                                </div>
                                <div class="card-body">
                                    <h5 class="card-title font-weight-bold text-secondary">List of all created reports</h5>
                                    <table class="table table-bordered table-condensed table-responsive text-nowrap table-sm table-hover">
                                        <thead class="thead-light">
                                            <tr>
                                                <th>Status</th>
                                                <th>SLA Programme</th>
                                                <th>Date Created</th>
                                                <th>Programme Type</th>
                                                <th>Report Date</th>
                                                <th>Created By</th>
                                                <th>Report Type</th>
                                            </tr>
                                        </thead>
                                        <%
                                            String report_id = "", sla_name = "", creator = "", date_created = "", report_type = "", report_status = "",
                                                    report_date = "", learners = "", progType = "", sla_id;
                                            try {
                                                Database DB = new Database();
                                                Connection con = DB.getCon1();
                                                Statement st = con.createStatement();
                                                st.executeQuery("SELECT sla_reports.id, sla_id, sla.type, sla.Name, sla.number_of_learners, CONCAT(First_Name,' ',Surname) creator, report_date, sla_reports.created_at, sla_report_type.type , sla_report_status.status FROM sla_reports INNER JOIN sla_report_type ON sla_report_type.id = sla_reports.report_type_id INNER JOIN sla_report_status ON sla_report_status.id = sla_reports.report_status_id INNER JOIN sla ON sla.id = sla_reports.sla_id INNER JOIN applicant_personal_details ON applicant_personal_details.applicant_id = sla_reports.user_id WHERE report_type_id = 2 ORDER BY sla_report_status.status ASC, sla_reports.updated_at DESC, sla_reports.created_at DESC;");
                                                ResultSet rs = st.getResultSet();

                                                while (rs.next()) {
                                                    report_id = (String) rs.getString("sla_reports.id").trim().substring(0);
                                                    sla_name = (String) rs.getString("sla.Name").trim();
                                                    creator = (String) rs.getString("creator");
                                                    date_created = (String) rs.getString("sla_reports.created_at");
                                                    report_type = (String) rs.getString("sla_report_type.type");
                                                    report_status = (String) rs.getString("sla_report_status.status");
                                                    report_date = (String) rs.getString("report_date");
                                                    progType = (String) rs.getString("sla.type");
                                                    sla_id = (String) rs.getString("sla_id");
                                                    learners = (String) rs.getString("sla.number_of_learners");
                                        %>
                                        <tr class='clickable-row' data-href='<%=request.getContextPath()%>/DashboardController?action=edit-site-visit-reports&report_id=<%=report_id%>&report_type=<%=report_type%>' data-toggle="tooltip" data-placement="top" title="click to open report">
                                            <td><%=report_status%></td>
                                            <td><%=sla_name%></td>
                                            <td><%=date_created%></td>
                                            <td><%=new Caps().toUpperCaseFirstLetter(progType)%></td>
                                            <td><%=report_date%></td>
                                            <td><%=creator%></td>
                                            <td><%=report_type%></td>
                                        </tr>
                                        <%
                                                }
                                            } catch (SQLException e) {
                                                System.out.println(e);
                                            }
                                        %>
                                    </table>
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
            //toggle tooltip
            $(document).ready(function () {
                $('[data-toggle="tooltip"]').tooltip();
            });
            //make table row clickable
            $(".clickable-row").click(function () {
                window.location = $(this).data("href");
            });
            //datepicker
            $('#myDate').datepicker({
                dateFormat: 'yy-mm-dd', minDate: "-3M", maxDate: 0
            }).on('keypress', function (e) {
                e.preventDefault();
            });
            //validate form input
            function generateReport() {
                var x = document.forms["myform"]["slasDropdownQR"].value;
                var y = document.forms["myform"]["numOfVisit"].value;
                var z = document.forms["myform"]["myDate"].value;
                if (z !== "" && y !== "" && x !== "") {
                    $("#sla").val($('#mictProgramme').val());
                    $("#visit").val($('#numOfVisit').val());
                    $("#creationDate").val($('#myDate').val());
                    document.getElementById('sla').title = $('#mictProgramme').val();
                    $('#siteVisitReportModal').modal();
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