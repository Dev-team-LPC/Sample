<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="cc.littlepig.databases.Database"%>
<%@ page import="cc.littlepig.classes.Foreword"%>
<%@ page import="cc.littlepig.classes.Caps"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.sql.*"%>     
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width">
        <title>Site Visit Reports - generation</title>
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
    	<%!public static String report_id, status, sla_id, managerQuestionnaire, mentorsFeedback, recommendations, conclusion, visit, creationDate, reportType, creationDateSQL; %>
        <%
        	report_id = request.getParameter("report_id");    
        	reportType = request.getParameter("report_type");    
        
            try {
                Database DB = new Database();
                Connection con = DB.getCon1();
                Statement st = con.createStatement();
                st.executeQuery("SELECT * FROM sla_reports_site_visit INNER JOIN sla_reports ON sla_reports.id = sla_reports_site_visit.report_id WHERE report_id = "+report_id+";");
                ResultSet rs = st.getResultSet();

                while (rs.next()) {
                    sla_id = (String) rs.getString("sla_id");
                    creationDate = (String) rs.getString("report_date").trim();
                    status = (String) rs.getString("report_status_id");
                    visit = (String) rs.getString("visit");
                    managerQuestionnaire = (String) rs.getString("project_manager_questionnaire");
                    mentorsFeedback = (String) rs.getString("mentors_feedback");
                    recommendations = (String) rs.getString("recommendations");
                    conclusion = (String) rs.getString("conclusion");
                }
            } catch (SQLException e) {
                System.out.println(e);
            }
        if(status.equals("2")){
        	getServletContext().getRequestDispatcher("/GenerateSiteVisitReport?report_id="+report_id+"&report_type="+reportType+"").forward(request, response);
        }            
        %>
        <div class="d-flex" id="wrapper">
            <!-- Page Content -->
            <div id="page-content-wrapper">

                <nav class="navbar navbar-expand-md navbar-dark bg-dark">
                    <a href="<%=request.getContextPath()%>/DashboardController?action=dashboard">
                        <img src="images/logotop.png" width="100" height="29"alt="lpc logo">
                    </a>
                    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav ml-auto mt-2 mt-lg-0">
                            <li class="nav-item dropdown">
                                <a class="btn btn-outline-info dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fa fa-user"></i> 
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
                                    <div class="dropdown-divider"></div>
                                    <a href="<%=request.getContextPath()%>/DashboardController?action=destroy" class="dropdown-item"><i class="fa fa-power-off"></i> Sign Out</a> 
                                </div>
                            </li>
                        </ul>
                    </div>
                </nav>
                <div class="container-fluid">
                    <br>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/DashboardController?action=dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/DashboardController?action=site-visit-reports">Site Visit Reports</a></li>
                        <li class="breadcrumb-item active"> Create Report</li>
                    </ol>
                    ${message}
                    <div class="jumbotron">
                        <h3 class="display-6">SITE VISIT REPORT UPDATE</h3>
                        <hr class="my-9">

                        <form action="<%=request.getContextPath()%>/DashboardController?action=save-site-visit-report" method="POST">
                            <input name="sla" type="hidden" value="<%=sla_id%>"/> 
                            <input name="visit" type="hidden" value="<%=visit%>"/>
                            <input name="report_id" type="hidden" value="<%=report_id%>"/>
                            <div class="form-row">
                                <div class="col-auto col-md-12">
                                    <label for="myDate">Report Date: </label>
                                    <input style="background-color:#fff;" id="myDate" type="text" name="creationDate" value="<%=creationDate%>" readonly required placeholder="YYYY-MM-DD" pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" title="The date should be in this format: YYYY-MM-DD">
                                </div>
                            </div>                                                
                            <h4>Project Manager/ SDF (Employer) Questionnaire</h4>
                            <div class="form-group shadow-textarea">
                                <textarea name="managerQuestionnaire" id="managerQuestionnaire" class="form-control" minlength="30" maxlength="300" onload="clean('managerQuestionnaire'), charCountr('textCountA', 'managerQuestionnaire')" onkeyup="clean('managerQuestionnaire'), charCountr('textCountA', 'managerQuestionnaire')" onkeydown="clean('managerQuestionnaire')" rows="3" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
<%=managerQuestionnaire%></textarea>
                            </div>
                            <div id="textCountA" style="font-size: small;"></div>

                            <h4>Feedback From Mentor</h4>
                            <div class="form-group shadow-textarea">
                                <textarea name="mentorFeedback" id="mentorFeedback" class="form-control" minlength="10" maxlength="300" onload="clean('mentorFeedback'), charCountr('textCountD', 'mentorFeedback')" onkeyup="clean('mentorFeedback'), charCountr('textCountD', 'mentorFeedback')" onkeydown="clean('mentorFeedback')" rows="3" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 10 and not exceed 300.">
<%=mentorsFeedback%></textarea>
                            </div>
                            <div id="textCountD" style="font-size: small;"></div>
                            
                            <h4>Recommendations/ Remedial actions/ Developmental Plans</h4>
                            <div class="form-group shadow-textarea">
                                <textarea name="recommendations" id="recommendations" class="form-control" minlength="4" maxlength="300" onload="clean('recommendations'), charCountr('textCountB', 'recommendations')" onkeyup="clean('recommendations'), charCountr('textCountB', 'recommendations')" onkeydown="clean('recommendations')" rows="3" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 4 and not exceed 300.">
<%=recommendations%></textarea>
                            </div>
                            <div id="textCountB" style="font-size: small;"></div>

                            <h4>Conclusion</h4>
                            <div class="form-group shadow-textarea">
                                <textarea name="conclusion" id="conclusion" class="form-control" minlength="30" maxlength="300" onload="clean('conclusion'), charCountr('textCountC', 'conclusion')" onkeyup="clean('conclusion'), charCountr('textCountC', 'conclusion')" onkeydown="clean('conclusion')" rows="3" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
<%=conclusion%></textarea>
                            </div>
                            <div id="textCountC" style="font-size: small;"></div>

                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="btn-group checkbox float-right" data-toggle="tooltip" data-placement="top" title="If checked, this report will be saved & generated as a PDF document">
                                        <label> <input type="checkbox" name="status" value="2">
                                            confirm submission
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="btn-group float-left">
                                        <a class="btn btn-md btn-dark btn-outline-dark" href="<%=request.getContextPath()%>/DashboardController?action=site-visit-reports" role="button"><i class="fa fa-arrow-circle-left"></i> back</a>
                                    </div>                                
                                    <div class="btn-group float-right">
                                        <button role="button" type="submit" class="btn btn-md btn-primary"><i class="fa fa-save"></i> update report</button>
                                    </div>
                                </div>
                            </div>
                        </form>
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
        <script type="text/javascript">
            //toggle tooltip
            $(document).ready(function () {
                $('[data-toggle="tooltip"]').tooltip();
            });
            //datepicker
            $('#myDate').datepicker({
                dateFormat: 'yy-mm-dd',
                minDate: "-3M",
                maxDate: 0
            }).on('keypress', function (e) {
                e.preventDefault();
            });
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
            //validate textarea input
            function clean(el) {
                var textfield = document.getElementById(el);
                var regex = /[^a-z 0-9?!.,%*()'/\-\n]/gi;
                if (textfield.value.search(regex) > -1) {
                    textfield.value = textfield.value.replace(regex, "");
                }
            }
            //count remaining characters
            function charCountr(display, textbox) {
                var text_max = document.getElementById(textbox).maxLength;
                $('#' + display).html(text_max + ' remaining');
                $('#' + textbox).keyup(function () {
                    var text_length = $('#' + textbox).val().length;
                    var text_remaining = text_max - text_length;
                    $('#' + display).html(text_remaining + ' remaining');
                });
            }
        </script>
    </body>
</html>