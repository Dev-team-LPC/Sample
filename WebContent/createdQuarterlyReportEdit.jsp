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
        <title>Quarterly Reports - generation</title>
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
        <%!public static String mentor, months, sla_id, creationDate, learnrCount = "", sla_name = "", reportType = "",
                    companyName = "", progType = "", managerName = "", managerSurname = "", managerTel = "", managerSign = "",
                    sdlNum = "", agredidationNum = "", startDate = "", endDate = "", logo = "", managerCell = "",
                    managerMail = "", managerAddr = "", introduction = "", implementation = "", implementationDesc = "",
                    plan = "", placement = "", achievements = "", activity_date = "", activity_due_date = "",
                    activity_name = "", activity_outcome = "", activity_action_required = "", quarter = "", status;%>
        <%
            String report_id = request.getParameter("report_id");
            sla_id = request.getParameter("sla_id");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM uuuu");

            try {
                Database DB = new Database();
                Connection con = DB.getCon1();
                Statement st = con.createStatement();
                st.executeQuery("SELECT sla.id, sla.Name, sla.type, sla.start_date, sla.end_date, sla_company_details.company_name, sla_company_details.address, CONCAT(sla_company_details.representative_employer_name,' ', sla_company_details.representative_employer_surname) mentor, sla_project_manager.name, sla_project_manager.surname, sla_project_manager.cellphone, sla_project_manager.email, sla_project_manager.telephone, sla_reports.report_date, sla_reports.report_status_id, sla_report_type.type, sla_reports_quarterly.month_limit, sla_reports_quarterly.introduction, sla_reports_quarterly.methodology, sla_reports_quarterly.methodology_details, sla_reports_quarterly.strategic_plan, sla_reports_quarterly.work_placement, sla_reports_quarterly.achievements, if(NOW() <= DATE_ADD(start_date, INTERVAL 3 MONTH), 'First Quarter', if(NOW() <= DATE_ADD(start_date, INTERVAL 6 MONTH), 'Second Quarter', If(NOW() <= DATE_ADD(start_date, INTERVAL 9 MONTH), 'Third Quarter', if(NOW() <= DATE_ADD(start_date, INTERVAL 12 MONTH), 'Fourth Quarter', 'null')))) quarter FROM sla_reports INNER JOIN sla ON sla.id = sla_reports.sla_id INNER JOIN sla_company_details ON sla_company_details.id = sla.company_id INNER JOIN sla_project_manager ON sla_project_manager.id = sla_company_details.project_manager_id INNER JOIN sla_report_type ON sla_report_type.id = sla_reports.report_type_id INNER JOIN sla_report_status ON sla_report_status.id = sla_reports.report_status_id INNER JOIN sla_reports_quarterly ON sla_reports_quarterly.report_id = sla_reports.id WHERE sla_reports.id = "+report_id+";");
                ResultSet rs = st.getResultSet();

                while (rs.next()) {
                	quarter = (String) rs.getString("quarter");
                    sla_id = (String) rs.getString("sla.id");
                    progType = (String) rs.getString("sla.type");
                    sla_name = (String) rs.getString("sla.Name");
                    startDate = (String) rs.getString("sla.start_date");
                    endDate = (String) rs.getString("sla.end_date");
                    companyName = (String) rs.getString("sla_company_details.company_name");
                    managerAddr = (String) rs.getString("sla_company_details.address");
                    managerName = (String) rs.getString("sla_project_manager.name");
                    managerSurname = (String) rs.getString("sla_project_manager.surname");
                    managerCell = (String) rs.getString("sla_project_manager.cellphone");
                    managerTel = (String) rs.getString("sla_project_manager.telephone");
                    managerMail = (String) rs.getString("sla_project_manager.email");
                    creationDate = (String) rs.getString("sla_reports.report_date");
                    months = (String) rs.getString("sla_reports_quarterly.month_limit");
                    introduction = (String) rs.getString("sla_reports_quarterly.introduction");
                    implementation = (String) rs.getString("sla_reports_quarterly.methodology");
                    implementationDesc = (String) rs.getString("sla_reports_quarterly.methodology_details");
                    plan = (String) rs.getString("sla_reports_quarterly.strategic_plan");
                    placement = (String) rs.getString("sla_reports_quarterly.work_placement");
                    achievements = (String) rs.getString("sla_reports_quarterly.achievements");
                    status = (String) rs.getString("sla_reports.report_status_id");
                    reportType = (String) rs.getString("sla_report_type.type");
                    mentor = (String) rs.getString("mentor");
                }
            } catch (SQLException e) {
                System.out.println(e);
            }
        if(status.equals("2")){
        	getServletContext().getRequestDispatcher("/GenerateQuarterlyReport?report_id="+report_id+"&report_type="+reportType+"").forward(request, response);
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
                        <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/DashboardController?action=quarterly-reports">Quarterly Reports</a></li>
                        <li class="breadcrumb-item active"> Create Report</li>
                    </ol>
                    ${message}
                    <div id="myCatouselIndicator" class="carousel slide" data-ride="carousel" data-interval="false">
                        <ol class="carousel-indicators">
                            <li data-target="#myCatouselIndicator" data-slide-to="0" class="active"></li>
                            <li data-target="#myCatouselIndicator" data-slide-to="1"></li>
                            <li data-target="#myCatouselIndicator" data-slide-to="2"></li>
                            <li data-target="#myCatouselIndicator" data-slide-to="3"></li>
                            <li data-target="#myCatouselIndicator" data-slide-to="4"></li>
                        </ol>
                        <div class="carousel-inner">
                            <form action="<%=request.getContextPath()%>/DashboardController?action=save-quarterly-report" method="POST">
                                <input name="sla" type="hidden" value="<%=sla_id%>"/> 
                                <input name="months" type="hidden" value="<%=months%>"/>
                                <input name="report_id" type="hidden" value="<%=report_id%>"/>
                                <div class="carousel-item active">
                                    <div class="jumbotron">
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <h3 class="float-left">SECTION A: LEARNERSHIP DETAILS</h3>
                                                <div class="btn-group float-right">
                                                    <button role="button" type="button" class="btn btn-md btn-info" title="go to the next section" onclick="$('.carousel').carousel('next')"><i class="fa fa-chevron-right"></i> next</button>
                                                </div>
                                            </div>
                                        </div>                                    
                                        <hr class="my-9">
                                        <table class="table table-sm">
                                            <tr>
                                                <td>Programme</td>
                                                <td>: <%=progType%></td>
                                            </tr>
                                            <tr>
                                                <td>SLA number</td>
                                                <td>: <%=sla_name%></td>
                                            </tr>
                                            <tr>
                                                <td><%=new Caps().toUpperCaseFirstLetter(progType)%> NQF Level</td>
                                                <td>: Level 5</td>
                                            </tr>
                                            <tr>
                                                <td>Report Period (Quarter)</td>
                                                <td>: <%=quarter%></td>
                                            </tr>
                                            <tr>
                                                <td>Employer’s Name</td>
                                                <td>: <%=companyName%></td>
                                            </tr>
                                            <tr>
                                                <td>Date of quarterly report</td>
                                                <td>: <input style="background-color:#fff;" id="myDate" type="text" name="creationDate" value="<%=creationDate%>" readonly onchange="setDateSame()" required placeholder="YYYY-MM-DD" pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" title="The date should be in this format: YYYY-MM-DD"></td>                                            
                                            </tr>
                                            <tr>
                                                <td>Start date</td>
                                                <td>: <%=formatter.format(LocalDate.parse(startDate))%></td>
                                            </tr>
                                            <tr>
                                                <td>End date</td>
                                                <td>: <%=formatter.format(LocalDate.parse(endDate))%></td>
                                            </tr>
                                            <tr>
                                                <td>Project Manager Full Name</td>
                                                <td>: <%=managerName%></td>
                                            </tr>
                                            <tr>
                                                <td>Project Manager Surname</td>
                                                <td>: <%=managerSurname%></td>
                                            </tr>
                                            <tr>
                                                <td>Project manager telephone no.</td>
                                                <td>: <%=managerTel%></td>
                                            </tr>
                                            <tr>
                                                <td>Project manager cell</td>
                                                <td>: <%=managerCell%></td>
                                            </tr>
                                            <tr>
                                                <td>e-mail address</td>
                                                <td>: <%=managerMail%></td>
                                            </tr>
                                            <tr>
                                                <td>Company’s Physical address</td>
                                                <td>: <%=managerAddr%></td>
                                            </tr>
                                        </table>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <a class="btn btn-secondary float-left" role="button" href="<%=request.getContextPath()%>/DashboardController?action=quarterly-reports"><i class="fa fa-arrow-left"></i>  back</a>
                                                <div class="btn-group float-right">
                                                    <button role="button" type="button" class="btn btn-md btn-info" title="go to the next section" onclick="$('.carousel').carousel('next')"><i class="fa fa-chevron-right"></i> next</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="carousel-item">
                                    <div class="jumbotron">
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <h3 class="float-left">SECTION B: LEARNERSHIP QUARTER OVERVIEW</h3>
                                                <div class="btn-group float-right">
                                                    <button role="button" type="button" class="btn btn-md btn-secondary" title="go to the previous section" onclick="$('.carousel').carousel('prev')"><i class="fa fa-chevron-left"></i> previous</button>
                                                    <button role="button" type="button" class="btn btn-md btn-info" title="go to the next section" onclick="$('.carousel').carousel('next')"><i class="fa fa-chevron-right"></i> next</button>
                                                </div>
                                            </div>
                                        </div>                                    
                                        <hr class="my-9">
                                        <%if (companyName.equalsIgnoreCase("Little Pig CC") && progType.equalsIgnoreCase("Internship")) {%>
                                        <h4>Introduction</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="introduction" id="introduction" class="form-control" minlength="30" maxlength="400" onload="clean('introduction'), charCountr('textCountA', 'introduction')" onkeyup="clean('introduction'), charCountr('textCountA', 'introduction')" onkeydown="clean('introduction')" rows="3" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
<%=introduction%></textarea>
                                        </div>
                                        <div id="textCountA" style="font-size: small;"></div>

                                        <h4>Project Implementation Methodology</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="implementation" id="implementation" class="form-control" minlength="30" maxlength="400" onload="clean('implementation'), charCountr('textCountB', 'implementation')" onkeyup="clean('implementation'), charCountr('textCountB', 'implementation')" onkeydown="clean('implementation')" rows="3" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
<%=implementation%></textarea>
                                        </div>
                                        <div id="textCountB" style="font-size: small;"></div>

                                        <h4>Methodology Diagram <i style="font-size: small;">(optional)</i></h4>
                                        <img src="images/scrum_diagram.png" class="img-fluid" style="width:100%" alt="Scrum diagram">

                                        <h4>About Methodology</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="implementationDetails" id="implementationDetails" class="form-control" minlength="30" maxlength="2000" onload="clean('implementationDetails'), charCountr('textCountC', 'implementationDetails')" onkeyup="clean('implementationDetails'), charCountr('textCountC', 'implementationDetails')" onkeydown="clean('implementationDetails')" rows="30" cols="100" required  spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
<%=implementationDesc%></textarea>
                                        </div>
                                        <div id="textCountC" style="font-size: small;"></div>

                                        <h4>Strategic Plan</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="plan" id="plan" class="form-control" minlength="30" maxlength="1000" onload="clean('plan'), charCountr('textCountD', 'plan')" onkeyup="clean('plan'), charCountr('textCountD', 'plan')" onkeydown="clean('plan')" rows="10" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
<%=plan%></textarea>
                                        </div>
                                        <div id="textCountD" style="font-size: small;"></div>

                                        <h4>Work Placement</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="placement" id="placement" class="form-control" minlength="30" maxlength="1000" onload="clean('placement'), charCountr('textCountE', 'placement')" onkeyup="clean('placement'), charCountr('textCountE', 'placement')" onkeydown="clean('placement')" rows="8" cols="100" spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
<%=placement%></textarea>
                                        </div>
                                        <div id="textCountE" style="font-size: small;"></div>
                                        <%
                                        } else if (companyName.equalsIgnoreCase("Border ICT & Cabling Service") && progType.equalsIgnoreCase("internship")) {
                                        %>
                                        <h4>Introduction</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="introduction" id="introduction" class="form-control" minlength="30" maxlength="400" onload="clean('introduction'), charCountr('textCountA', 'introduction')" onkeyup="clean('introduction'), charCountr('textCountA', 'introduction')" onkeydown="clean('introduction')" rows="3" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
<%=introduction%></textarea>
                                        </div>
                                        <div id="textCountA" style="font-size: small;"></div>

                                        <h4>Project Implementation Methodology</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="implementation" id="implementation" class="form-control" minlength="30" maxlength="400" onload="clean('implementation'), charCountr('textCountB', 'implementation')" onkeyup="clean('implementation'), charCountr('textCountB', 'implementation')" onkeydown="clean('implementation')" rows="4" cols="100" required  spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
<%=implementation%></textarea>
                                        </div>
                                        <div id="textCountB" style="font-size: small;"></div>

                                        <h4>Strategic Plan</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="plan" id="plan" class="form-control" minlength="30" maxlength="1000" onload="clean('plan'), charCountr('textCountD', 'plan')" onkeyup="clean('plan'), charCountr('textCountD', 'plan')" onkeydown="clean('plan')" rows="4" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
<%=plan%></textarea>
                                        </div>
                                        <div id="textCountD" style="font-size: small;"></div>

                                        <h4>Work Placement</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="placement" id="placement" class="form-control" minlength="30" maxlength="1000" onload="clean('placement'), charCountr('textCountE', 'placement')" onkeyup="clean('placement'), charCountr('textCountE', 'placement')" onkeydown="clean('placement')" rows="4" cols="100" spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
<%=placement%></textarea>
                                        </div>
                                        <div id="textCountE" style="font-size: small;"></div>
                                        <%} else {%>
                                        <h4>Introduction</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="introduction" id="introduction" class="form-control" minlength="30" maxlength="400" onload="clean('introduction'), charCountr('textCountA', 'introduction')" onkeyup="clean('introduction'), charCountr('textCountA', 'introduction')" onkeydown="clean('introduction')" rows="3" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
<%=introduction%></textarea>
                                        </div>
                                        <div id="textCountA" style="font-size: small;"></div>

                                        <h4>Project Implementation Methodology</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="implementation" id="implementation" class="form-control" minlength="30" maxlength="400" onload="clean('implementation'), charCountr('textCountB', 'implementation')" onkeyup="clean('implementation'), charCountr('textCountB', 'implementation')" onkeydown="clean('implementation')" rows="3" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
<%=implementation%></textarea>
                                        </div>
                                        <div id="textCountB" style="font-size: small;"></div>

                                        <h4>Strategic Plan</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="plan" id="plan" class="form-control" minlength="30" maxlength="1000" onload="clean('plan'), charCountr('textCountD', 'plan')" onkeyup="clean('plan'), charCountr('textCountD', 'plan')" onkeydown="clean('plan')" rows="6" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
<%=plan%></textarea>
                                        </div>
                                        <div id="textCountD" style="font-size: small;"></div>

                                        <h4>Work Placement</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="placement" id="placement" class="form-control" minlength="30" maxlength="1000" onload="clean('placement'), charCountr('textCountE', 'placement')" onkeyup="clean('placement'), charCountr('textCountE', 'placement')" onkeydown="clean('placement')" rows="4" cols="100" spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
<%=placement%></textarea>
                                        </div>
                                        <div id="textCountE" style="font-size: small;"></div>
                                        <%}%>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <a class="btn btn-secondary float-left" role="button" href="<%=request.getContextPath()%>/DashboardController?action=quarterly-reports"><i class="fa fa-arrow-left"></i>  back</a>
                                                <div class="btn-group float-right">
                                                    <button role="button" type="button" class="btn btn-md btn-secondary" title="go to the previous section" onclick="$('.carousel').carousel('prev')"><i class="fa fa-chevron-left"></i> previous</button>
                                                    <button role="button" type="button" class="btn btn-md btn-info" title="go to the next section" onclick="$('.carousel').carousel('next')"><i class="fa fa-chevron-right"></i> next</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="carousel-item">
                                    <div class="jumbotron">
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <h3 class="float-left">SECTION C: LESSON PLAN TIME SCHEDULE</h3>
                                                <div class="btn-group float-right">
                                                    <button role="button" type="button" class="btn btn-md btn-secondary" title="go to the previous section" onclick="$('.carousel').carousel('prev')"><i class="fa fa-chevron-left"></i> previous</button>
                                                    <button role="button" type="button" class="btn btn-md btn-info" title="go to the next section" onclick="$('.carousel').carousel('next')"><i class="fa fa-chevron-right"></i> next</button>
                                                </div>
                                            </div>
                                        </div>                                     
                                        <p>Activities which are undertaken for <b style="text-decoration: underline;">workplace</b> learning; when and how these were done in this quarter.</p>
                                        <hr class="my-9">
                                        <table
                                            class="table table-sm table-responsive table-light table-hover table-bordered" id="activityTable">
                                            <thead style="background-color: #d6d8d9; color: #1b1e21; border: 1px solid #c0c8ca;">
                                                <tr>
                                                    <th>No.</th>
                                                    <th id="activityDate">Date<br> [name]</th>
                                                    <th id="activity">Activity</th>
                                                    <th id="outcome">Learning Outcome</th>
                                                    <th>Mentor / Coach</th>
                                                    <th>Department</th>
                                                    <th id="axnRequired">Action Required</th>
                                                    <th id="activityDueDate">Due Date <br>By When?</th>
                                                    <th>Remove Row</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                try {
                                        			Database DB = new Database();
                                        			Connection con = DB.getCon1();
                                        			Statement st = con.createStatement();
                                        			st.executeQuery("SELECT task_name, task_outcome, task_date, task_due_date, task_action_required FROM sla_reports INNER JOIN sla_reports_learner_tasks ON sla_reports_learner_tasks.report_id = sla_reports.id WHERE sla_reports.id ="+report_id+";");
                                        			ResultSet rs = st.getResultSet();
                                        			String department = "ICT department";
                                        			String [] dueDate = null;
                                        			String [] activityDate = null;
                                        			String [] activityName = null;
                                        			String [] activityOutcome = null;
                                        			String [] requiredAction = null;
                                        			
                                        			while(rs.next()) {
	                                                    dueDate = rs.getString("task_due_date").split("::");
	                                                    activityDate = rs.getString("task_date").split("::");
	                                                    activityName = rs.getString("task_name").split("::");
	                                                    activityOutcome = rs.getString("task_outcome").split("::");
	                                                    requiredAction = rs.getString("task_action_required").split("::");
                                        			}
                                        			for(int i = 0; i < dueDate.length; i++){
                                                        out.print("<tr>");
                                                        out.print("<td>" + (i+1) + "</td>");
                                                        out.print("<td>" + activityDate[i] + "</td>");
                                                        out.print("<td id='actvty" + i + "' contenteditable='true' onload=\"clean('actvty" + i + "')\" onkeydown=\"clean('actvty" + i + "')\" onkeyup=\"clean('actvty" + i + "')\">" + activityName[i] + "</td>");
                                                        out.print("<td id='actvtOutcome" + i + "' contenteditable='true' onload=\"clean('actvtOutcome" + i + "')\" onkeydown=\"clean('actvtOutcome" + i + "')\" onkeyup=\"clean('actvtOutcome" + i + "')\">" + activityOutcome[i] + "</td>");
                                                        out.print("<td>" + mentor + "</td>");
                                                        out.print("<td>" + department + "</td>");
                                                        out.print("<td id='axnReq" + i + "' contenteditable='true' onload=\"clean('axnReq" + i + "')\" onkeydown=\"clean('axnReq" + i + "')\" onkeyup=\"clean('axnReq" + i + "')\">" + requiredAction[i] + "</td>");
                                                        out.print("<td>" + dueDate[i] + "</td>");
                                                        out.print("<td><button class='btn btn-danger btn-circle' type='button' id='btnDelete' title='Remove row'><i class='fa fa-trash' aria-hidden='true'></i></button></td>");
                                                        out.print("</tr>");
                                                    }
                                        		} catch (SQLException e) {
                                        			System.out.println(e);
                                        		}
                                                %>
                                            </tbody>
                                        </table>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <a class="btn btn-secondary float-left" role="button" href="<%=request.getContextPath()%>/DashboardController?action=quarterly-reports"><i class="fa fa-arrow-left"></i>  back</a>
                                                <div class="btn-group float-right">
                                                    <button role="button" type="button" class="btn btn-md btn-secondary" title="go to the previous section" onclick="$('.carousel').carousel('prev')"><i class="fa fa-chevron-left"></i> previous</button>
                                                    <button role="button" type="button" class="btn btn-md btn-info" title="go to the next section" onclick="$('.carousel').carousel('next')"><i class="fa fa-chevron-right"></i> next</button>
                                                </div>
                                            </div>
                                        </div>
                                        <input type="hidden" id="array1" name="array1"/><br>
                                        <input type="hidden" id="array2" name="array2"/><br>
                                        <input type="hidden" id="array3" name="array3"/>
                                        <input type="hidden" id="array4" name="array4"/>
                                        <input type="hidden" id="array5" name="array5"/>                                       
                                    </div>
                                </div>
                                <div class="carousel-item">
                                    <div class="jumbotron">
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <h3 class="float-left">SECTION D: LEARNER DETAILS</h3>
                                                <div class="btn-group float-right">
                                                    <button role="button" type="button" class="btn btn-md btn-secondary" title="go to the previous section" onclick="$('.carousel').carousel('prev')"><i class="fa fa-chevron-left"></i> previous</button>
                                                    <button role="button" type="button" class="btn btn-md btn-info" title="go to the next section" onclick="$('.carousel').carousel('next')"><i class="fa fa-chevron-right"></i> next</button>
                                                </div>
                                            </div>
                                        </div>                                   
                                        <hr class="my-9">
                                        <table class="table table-sm table-responsive table-light table-hover" id="detailsTable">
                                            <thead class="table-bordered" style="background-color: #d6d8d9; color: #1b1e21; border: 1px solid #c0c8ca;">
                                                <tr><th colspan="27" scope="colgroup">OUTCOME 3.3: INCREASED ACESS TO OCCUPATIONALLY DIRECTED LEARNING PROGRAMMES WITHIN THE MICT SECTOR</th></tr>
                                                <tr>
                                                    <th>No.</th>
                                                    <th>NAMES OF THE LEARNER</th>
                                                    <th>SURNAME OF THE LEARNER</th>
                                                    <th>ID NUMBER OF THE LEARNER</th>
                                                    <th>TYPE OF LEARNING PROGRAMME (LEARNERSHIP)</th>
                                                    <th>DATE THE LEARNER  ENTERED THE LEARNING  PROGRAMMME</th>
                                                    <th>ACTUAL START DATE OF THE LEARNING PROGRAMME</th>
                                                    <th>OFO CODE VERSION 2012</th>
                                                    <th>NQF LEVEL (NQF ACT)</th>
                                                    <th>QUALIFICATION  AS PER OFO CODE/DESCRIPTION OF THE QUALIFICATION</th>
                                                    <th>NAME OF THE EMPLOYER</th>
                                                    <th>EMPLOYER REGISTRATION/SDL NUMBER</th>
                                                    <th>EMPLOYER CONTACT DETAILS</th>
                                                    <th>NAME OF THE TRAINING PROVIDER</th>
                                                    <th>TRAINING PROVIDER AGREDITATION NUMBER</th>
                                                    <th>TRAININING PROVIDER CONTACT DETAILS</th>
                                                    <th>IS TRAINING PROVIDER PRIVATE /PUBLIC (YES/NO)</th>
                                                    <th>LEARNER PROVINCE</th>
                                                    <th>LEARNER LOCAL/DISTRICT MUNICIPALITY</th>
                                                    <th>SPECIFY LEARNER RESIDENTIAL  AREA</th>
                                                    <th>IS THE LEARNER RESIDENTIAL AREA URBAN / RURAL(YES/NO)</th>
                                                    <th colspan="6">KEY DEVELOPMENT AND TRANSFORMATION IMPERATIVES</th>
                                                </tr>
                                                <tr>
                                                    <th colspan="21"></th>
                                                    <th>RACE</th>
                                                    <th>GENDER</th>
                                                    <th>AGE</th>
                                                    <th>DISABILITY</th>
                                                    <th>YOUTH</th>
                                                    <th>NON-RSA CITIZEN</th>
                                                </tr>
                                            </thead>
                                            <tbody class="text-nowrap">
                                                <%
                                                    String name = "", surname = "", idnum = "", entryDate = "", ofo = "", nqf = "", qualification = "", trainer = companyName,
                                                            privacy = "private", province = "Eastern Cape", municipality = "Amathole District Municipality", area = "East London", areaType = "Urban",
                                                            trainerContacts = managerTel, race = "", gender = "", citizenship = "", age = "", youth = "", disability = "";
                                                    try {
                                                        Database DB = new Database();
                                                        Connection con = DB.getCon1();
                                                        Statement st = con.createStatement();
                                                        st.executeQuery("SELECT DISTINCT (SELECT MAX(applicant_nqf_qualifications.applicant_nqf_level_id) FROM intern_sla AS t3 INNER JOIN applicant_person_qualification_field_of_studies ON applicant_person_qualification_field_of_studies.applicant_id = t3.applicant_id INNER JOIN applicant_nqf_qualifications ON applicant_person_qualification_field_of_studies.applicant_nqf_qualification_id = applicant_nqf_qualifications.id WHERE t3.applicant_id = t1.applicant_id) as nqf, t1.applicant_id, applicant_personal_details.First_Name ,applicant_personal_details.Surname, applicants.id_number, sla.type, (SELECT sla_company_details.company_name FROM sla INNER JOIN sla_company_details ON sla_company_details.id = sla.company_id WHERE sla.id = t1.sla_id) AS company, (SELECT DATE_FORMAT(t4.date,'%d-%b-%y') FROM intern_sla AS t4 WHERE t4.applicant_id = t1.applicant_id AND status_id = 1) AS entryDate, DATE_FORMAT(sla.start_date,'%d-%b-%y') AS start_Date, ofo_code, occupations, IF(applicant_personal_details.applicant_race_id = 1, \"Black\", IF(applicant_personal_details.applicant_race_id = 2,\"Coloured\", IF(applicant_personal_details.applicant_race_id = 3,\"Indian\", IF(applicant_personal_details.applicant_race_id = 4,\"Asian\",\"White\")))) AS race, IF(applicant_personal_details.applicant_gender_id = 1, \"Female\",\"Male\") AS gender, IF(SUBSTR(applicants.id_number,11,1) = 0, \"RSA Citizen\", \"Non-RSA Citizen\") AS citizenship, TIMESTAMPDIFF(YEAR,STR_TO_DATE(SUBSTR(applicants.id_number,1,6),'%y%m%d%'),CURDATE()) AS age , IF(TIMESTAMPDIFF(YEAR,STR_TO_DATE(SUBSTR(applicants.id_number,1,6),'%y%m%d%'),CURDATE()) < 36,\"Yes\",\"No\") AS youth, IF(applicant_disability_types.applicant_disability_id = 2,\"Yes\",\"No\") AS disability,  applicant_qual_status_id as qualStatus FROM intern_sla AS t1 INNER JOIN sla ON t1.sla_id = sla.id INNER JOIN applicants ON t1.applicant_id = applicants.id INNER JOIN sla_ofo_codes ON t1.ofo_code_id = sla_ofo_codes.id INNER JOIN applicant_personal_details ON applicant_personal_details.applicant_id = t1.applicant_id INNER JOIN applicant_disability_types ON applicant_personal_details.applicant_id = applicant_disability_types.applicant_id  INNER JOIN applicant_person_qualification_field_of_studies ON applicant_person_qualification_field_of_studies.applicant_id = t1.applicant_id INNER JOIN applicant_nqf_qualifications ON applicant_person_qualification_field_of_studies.applicant_nqf_qualification_id = applicant_nqf_qualifications.id WHERE sla_id = " + sla_id + " AND (SELECT COUNT(t2.applicant_id) FROM intern_sla AS t2 WHERE t2.applicant_id=t1.applicant_id HAVING COUNT(t2.applicant_id) < 2) = 1 AND applicant_qual_status_id = 1 ORDER BY Surname ASC;");
                                                        ResultSet rs = st.getResultSet();
                                                        int count = 0;

                                                        while (rs.next()) {
                                                            count++;
                                                            name = rs.getString(new Caps().toUpperCaseFirstLetter("applicant_personal_details.First_Name"));
                                                            surname = rs.getString(new Caps().toUpperCaseSurname("applicant_personal_details.Surname"));
                                                            idnum = rs.getString("applicants.id_number");
                                                            entryDate = rs.getString("entryDate");
                                                            startDate = rs.getString("start_Date");
                                                            ofo = rs.getString("ofo_code");
                                                            nqf = rs.getString("nqf");
                                                            qualification = rs.getString("occupations").trim();
                                                            race = rs.getString("race");
                                                            gender = rs.getString("gender");
                                                            age = rs.getString("age");
                                                            youth = rs.getString("youth");
                                                            disability = rs.getString("disability");
                                                            citizenship = rs.getString("citizenship");
                                                            if (companyName.equalsIgnoreCase("Border ICT & Cabling Service")) {
                                                                privacy = "";
                                                                agredidationNum = "";
                                                                trainerContacts = "";
                                                                trainer = "";
                                                            }
                                                            out.print("<tr>");
                                                            out.print("<td>" + count + "</td>");
                                                            out.print("<td>" + name + "</td>");
                                                            out.print("<td>" + surname + "</td>");
                                                            out.print("<td>" + idnum + "</td>");
                                                            out.print("<td>" + progType + "</td>");
                                                            out.print("<td>" + entryDate + "</td>");
                                                            out.print("<td>" + startDate + "</td>");
                                                            out.print("<td>" + ofo + "</td>");
                                                            out.print("<td> Level " + nqf + "</td>");
                                                            out.print("<td>" + qualification + "</td>");
                                                            out.print("<td>" + companyName + "</td>");
                                                            out.print("<td>" + sdlNum + "</td>");
                                                            out.print("<td>" + managerTel + "</td>");
                                                            out.print("<td>" + trainer + "</td>");
                                                            out.print("<td>" + agredidationNum + "</td>");
                                                            out.print("<td>" + trainerContacts + "</td>");
                                                            out.print("<td>" + privacy + "</td>");
                                                            out.print("<td>" + province + "</td>");
                                                            out.print("<td>" + municipality + "</td>");
                                                            out.print("<td>" + area + "</td>");
                                                            out.print("<td>" + areaType + "</td>");
                                                            out.print("<td>" + race + "</td>");
                                                            out.print("<td>" + gender + "</td>");
                                                            out.print("<td>" + age + "</td>");
                                                            out.print("<td>" + disability + "</td>");
                                                            out.print("<td>" + youth + "</td>");
                                                            out.print("<td>" + citizenship + "</td>");
                                                            out.print("</tr>");
                                                        }
                                                    } catch (SQLException e) {
                                                        out.println(e);
                                                    }
                                                %>
                                            </tbody>
                                        </table>

                                        <table class="table table-sm table-light table-bordered" id="learnerCountTable">
                                            <thead style="background-color: #d6d8d9; color: #1b1e21; border: 1px solid #c0c8ca;">
                                                <tr>
                                                    <th>No. of learners attended All lectures</th>
                                                    <th>No. of learners absent</th>
                                                    <th>No. of learners absconded /resigned/dropped</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    int in = 0, outt = 0;
                                                    try {
                                                        Database DB = new Database();
                                                        Connection con = DB.getCon1();
                                                        Statement st = con.createStatement();
                                                        st.executeQuery("SELECT SUM(IF(ISNULL(applicant_id) = 0 AND status_id = 1 AND (SELECT COUNT(t2.applicant_id) FROM intern_sla AS t2 WHERE t2.applicant_id=t1.applicant_id HAVING COUNT(t2.applicant_id) < 2) = 1, 1, 0)) iin, SUM(IF(ISNULL(applicant_id) = 0 AND status_id = 2 AND TIMESTAMPDIFF(MONTH, date, " + creationDate + ") <= " + months + ",1,0)) oout FROM intern_sla t1 WHERE sla_id = " + sla_id + ";");
                                                        ResultSet rs = st.getResultSet();
                                                        while (rs.next()) {
                                                            in = rs.getInt("iin");
                                                            outt = rs.getInt("oout");
                                                        }
                                                        con.close();
                                                    } catch (SQLException e) {
                                                        out.println(e);
                                                    }
                                                %>

                                                <tr>
                                                    <td><%=in%></td>
                                                    <td>0</td>
                                                    <td><%=outt%></td>                                               
                                                </tr>
                                            </tbody>
                                        </table>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <a class="btn btn-secondary float-left" role="button" href="<%=request.getContextPath()%>/DashboardController?action=quarterly-reports"><i class="fa fa-arrow-left"></i>  back</a>
                                                <div class="btn-group float-right">
                                                    <button role="button" type="button" class="btn btn-md btn-secondary" title="go to the previous section" onclick="$('.carousel').carousel('prev')"><i class="fa fa-chevron-left"></i> previous</button>
                                                    <button role="button" type="button" class="btn btn-md btn-info" title="go to the next section" onclick="$('.carousel').carousel('next')"><i class="fa fa-chevron-right"></i> next</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="carousel-item">
                                    <div class="jumbotron">
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <h3 class="float-left">SECTION E: SIGNIFICANT ACHIEVEMENT THIS QUARTER</h3>
                                                <div class="btn-group float-right">
                                                    <button role="button" type="button" class="btn btn-md btn-secondary" title="go to the previous section" onclick="$('.carousel').carousel('prev')"><i class="fa fa-chevron-left"></i> previous</button>
                                                </div>
                                            </div>
                                        </div>                                    
                                        <hr class="my-9">
                                        <h4>learners have achieved the following:</h4>
                                        <%if (companyName.equalsIgnoreCase("Border ICT & Cabling Service") && progType.equalsIgnoreCase("internship")) {%>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="achievements" id="achievements" class="form-control" minlength="30" maxlength="400" onload="clean('achievements'), charCountr('tbA', 'achievements')" onkeyup="clean('achievements'), charCountr('tbA', 'achievements')" onkeydown="clean('achievements')" rows="6" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
<%=achievements%></textarea>
                                        </div>
                                        <div id="tbA" style="font-size: small;"></div>
                                        <%} else {%>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="achievements" id="achievements" class="form-control" minlength="30" maxlength="400" onload="clean('achievements'), charCountr('tbA', 'achievements')" onkeyup="clean('achievements'), charCountr('tbA', 'achievements')" onkeydown="clean('achievements')" rows="6" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
<%=achievements%></textarea>
                                        </div>
                                        <div id="tbA" style="font-size: small;"></div>
                                        <%}%>
                                        <table class="table table-sm table-borderless">
                                            <tr>
                                                <td>Compiled By</td>
                                                <td>: <%=managerName + " " + managerSurname%></td>
                                            </tr>
                                            <tr>
                                                <td>Date</td>
                                                <td id="compylDate">: <%=creationDate%></td>
                                            </tr>
                                        </table>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <div class="btn-group checkbox float-right" data-toggle="tooltip" data-placement="top" title="If this button is checked, this report will be saved as a PDF document">
                                                    <label> <input type="checkbox" name="status" value="2">
                                                        confirm submission
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <a class="btn btn-secondary float-left" role="button" href="<%=request.getContextPath()%>/DashboardController?action=quarterly-reports"><i class="fa fa-arrow-left"></i> back</a>	
                                                <div class="btn-group float-right">
                                                    <button role="button" type="submit" class="btn btn-md btn-primary" onclick="saveTableData()" title="If you plan on editing later"><i class="fa fa-save"></i> update report</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
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
        </div>
        <script type="text/javascript">
			//table row delete
	    	$(document).ready(function () {
	            $("#activityTable").on('click', '#btnDelete', function () {
	                if (confirm("Are you sure you want to delete this row, Once done this action cannot be undone?")) {
	                    $(this).closest('tr').remove();
	                }
	            });
	        });        
			//toggle tooltip
	    	$(document).ready(function(){
			  $('[data-toggle="tooltip"]').tooltip();   
			});        
            //table data storage
            function saveTableData() {
                var myTab = document.getElementById('activityTable');
                var index = document.getElementById("activity").cellIndex;
                var index1 = document.getElementById("outcome").cellIndex;
                var index2 = document.getElementById("axnRequired").cellIndex;
                var index3 = document.getElementById("activityDate").cellIndex;
                var index4 = document.getElementById("activityDueDate").cellIndex;
                var arr = [], arr1 = [], arr2 = [], arr3 = [], arr4 = [];

                for (i = 1; i < myTab.rows.length; i++) {
                    var objCells = myTab.rows.item(i).cells;

                    for (var j = index, k = index1, l = index2, m = index3, n = index4; j <= index; j++, k++, l++, m++, n++) {
                        arr.push(objCells.item(j).innerHTML);
                        arr1.push(objCells.item(k).innerHTML);
                        arr2.push(objCells.item(l).innerHTML);
                        arr3.push(objCells.item(m).innerHTML);
                        arr4.push(objCells.item(n).innerHTML);
                    }
                    document.getElementById("array1").value = arr.join("::");
                    document.getElementById("array2").value = arr1.join("::");
                    document.getElementById("array3").value = arr2.join("::");
                    document.getElementById("array4").value = arr3.join("::");
                    document.getElementById("array5").value = arr4.join("::");
                }
            }
            //datepicker
            $('#myDate').datepicker({
                dateFormat: 'yy-mm-dd',
                minDate: "-3M",
                maxDate: 0
            }).on('keypress', function (e) {
                e.preventDefault();
            });
            //set date to be same
            function setDateSame() {
                $("#compylDate").html(": " + $('#myDate').val());
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