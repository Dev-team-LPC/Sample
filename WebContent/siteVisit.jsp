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
        <!-- datepicker -->        
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>        
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css" />
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
        <link rel="stylesheet" href="css/reports-customstyle.css">
        <style>
			.carousel-indicators li {
			    background-color: black;
			}
			.carousel-indicators .active {
				color: yellow;
			    background-color: cyan;
			}        	
        </style>
    </head>
    <body>
        <%!public static String mentor, months, sla_id, creationDate, learnrCount = "", sla_name = "", companyName = "",
                    progType = "", managerName = "", managerSurname = "", managerTel = "", managerSign = "", sdlNum = "", agredidationNum = "",
                    startDate = "", endDate = "", logo = "", managerCell = "", managerMail = "", managerAddr = "";%>
        <%
            months = new Foreword().getString(request.getParameter("months"), " ");
            sla_id = new Foreword().getString(request.getParameter("sla"), ".");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM uuuu");
            DateTimeFormatter formatterSQL = DateTimeFormatter.ofPattern("uuuu-MM-dd");
            creationDate = formatter.format(LocalDate.parse(request.getParameter("creationDate")));

            try {
                Database DB = new Database();
                Connection con = DB.getCon1();
                Statement st = con.createStatement();
                st.executeQuery("SELECT t1.Name, t1.type, t1.number_of_learners, DATE_FORMAT(t1.start_date,'%d %M %Y') start_date, DATE_FORMAT(t1.end_date,'%d %M %Y') end_date, t2.company_name, t2.registration_number, t2.agredidation_number, t2.logo, t2.address, t2.representative_employer_name, t2.representative_employer_surname, t3.name, t3.surname, t3.cellphone, t3.telephone, t3.email FROM sla t1 INNER JOIN sla_company_details t2 ON t2.id = t1.company_id INNER JOIN sla_project_manager t3 ON t3.id = t2.project_manager_id WHERE t1.id = " + sla_id + ";");
                ResultSet rs = st.getResultSet();

                while (rs.next()) {
                    progType = (String) rs.getString("t1.type").trim().substring(0);
                    sla_name = (String) rs.getString("t1.Name").trim();
                    learnrCount = (String) rs.getString("t1.number_of_learners");
                    startDate = (String) rs.getString("start_date");
                    endDate = (String) rs.getString("end_date");
                    companyName = (String) rs.getString("t2.company_name");
                    logo = (String) rs.getString("t2.logo");
                    managerAddr = (String) rs.getString("t2.address");
                    sdlNum = (String) rs.getString("t2.registration_number");
                    agredidationNum = (String) rs.getString("t2.agredidation_number");
                    mentor = new Caps().toUpperCaseFirstLetter((String) rs.getString("t2.representative_employer_name") + " " + new Caps().toUpperCaseSurname((String) rs.getString("t2.representative_employer_surname")));
                    managerName = new Caps().toUpperCaseFirstLetter((String) rs.getString("t3.name"));
                    managerSurname = new Caps().toUpperCaseSurname((String) rs.getString("t3.surname"));
                    managerTel = (String) rs.getString("t3.telephone");
                    managerMail = (String) rs.getString("t3.email");
                    managerCell = (String) rs.getString("t3.cellphone");
                }
            } catch (SQLException e) {
                System.out.println(e);
            }
        %>
        <div class="d-flex" id="wrapper">
            <!-- Page Content -->
            <div id="page-content-wrapper">

                <nav class="navbar navbar-expand-md navbar-dark bg-dark">

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

                    <div id="myCatouselIndicator" class="carousel slide" data-ride="carousel" data-interval="false">
                        <ol class="carousel-indicators">
                            <li data-target="#myCatouselIndicator" data-slide-to="0" class="active"></li>
                            <li data-target="#myCatouselIndicator" data-slide-to="1"></li>
                            <li data-target="#myCatouselIndicator" data-slide-to="2"></li>
                            <li data-target="#myCatouselIndicator" data-slide-to="3"></li>
                            <li data-target="#myCatouselIndicator" data-slide-to="4"></li>
                        </ol>
                        <div class="carousel-inner">
                            <div class="carousel-item active">
                                <div class="jumbotron">
                                    <div class="row">
                                        <div class="col-lg-12">
			                            	<h3 class="float-left">SECTION A: LEARNERSHIP DETAILS</h3>
                                           	<div class="btn-group float-right">
                                            	<button role="button" type="button" class="btn btn-md btn-secondary" title="go to the previous section" onclick="$('.carousel').carousel('prev')"><i class="fa fa-chevron-left"></i> previous</button>
                                               	<button role="button" type="button" class="btn btn-md btn-info" title="go to the next section" onclick="$('.carousel').carousel('next')"><i class="fa fa-chevron-right"></i> next</button>
                                           </div>
                                    	</div>
                                    </div>                                    
                                    <hr class="my-9">
                                    <form action="#">
                                        <table class="table table-sm">
                                            <tr>
                                                <td>Programme</td>
                                                <td>: <input name="programme" type="text" value="<%=progType%>"></td>
                                            </tr>
                                            <tr>
                                                <td>SLA number</td>
                                                <td>: <input name="sla" type="text" value="<%=sla_name%>"></td>
                                            </tr>
                                            <tr>
                                                <td><%=new Caps().toUpperCaseFirstLetter(progType)%> NQF Level</td>
                                                <td>: <input name="nqf" type="text" value="Level 5"></td>
                                            </tr>
                                            <tr>
                                                <td>Report Period (Quarter)</td>
                                                <td>: <input name="quarter" type="text" value=""></td>
                                            </tr>
                                            <tr>
                                                <td>Employer’s Name</td>
                                                <td>: <input name="company" type="text" value="<%=companyName%>"></td>
                                            </tr>
                                            <tr>
                                                <td>Date of quarterly report</td>
                                                <td>: <input name="creationDate" type="date" value="<%=creationDate%>"></td>
                                            </tr>
                                            <tr>
                                                <td>Start date</td>
                                                <td>: <input name="startDate" type="date" value="<%=startDate%>"></td>
                                            </tr>
                                            <tr>
                                                <td>End date</td>
                                                <td>: <input name="endDate" type="date" value="<%=endDate%>"></td>
                                            </tr>
                                            <tr>
                                                <td>Project Manager Full Name</td>
                                                <td>: <input name="managerName" type="text" value="<%=managerName%>"></td>
                                            </tr>
                                            <tr>
                                                <td>Project Manager Surname</td>
                                                <td>: <input name="managerSurname" type="text" value="<%=managerSurname%>"></td>
                                            </tr>
                                            <tr>
                                                <td>Project manager telephone no.</td>
                                                <td>: <input name="managerTel" type="tel" value="<%=managerTel%>"></td>
                                            </tr>
                                            <tr>
                                                <td>Project manager cell</td>
                                                <td>: <input name="managerCell" type="tel" value="<%=managerCell%>"></td>
                                            </tr>
                                            <tr>
                                                <td>e-mail address</td>
                                                <td>: <input name="managerMail" type="text" value="<%=managerMail%>"></td>
                                            </tr>
                                            <tr>
                                                <td>Company’s Physical address</td>
                                                <td>: <input name="managerAddr" type="text" value="<%=managerAddr%>"></td>
                                            </tr>
                                        </table>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <button class="btn btn-secondary float-left" onclick="window.history.go(-1)"><i class="fa fa-arrow-left"></i>  back</button>
                                                <div class="btn-group float-right">
                                                    <button role="button" type="submit" class="btn btn-md btn-success " title="save current changes"><i class="fa fa-cog fa-save"></i> save</button>
                                                    <button role="button" type="button" class="btn btn-md btn-secondary" title="go to the previous section" onclick="$('.carousel').carousel('prev')"><i class="fa fa-chevron-left"></i> previous</button>
                                                    <button role="button" type="button" class="btn btn-md btn-info" title="go to the next section" onclick="$('.carousel').carousel('next')"><i class="fa fa-chevron-right"></i> next</button>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
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
                                    <form action="#">
                                        <h4>Introduction</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="introduction" id="introduction" class="form-control" minlength="30" maxlength="300" onkeyup="clean('introduction'), charCountr('textCountA', 'introduction')" onkeydown="clean('introduction')" rows="3" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300."
                                                      required>This report comprises the fourth and final report for <%=companyName%>’s internship programme on Contract Number: <%=sla_name%>. It reviews the outcomes of assignments that the interns had been working on.
                                            </textarea>
                                        </div>
                                        <div id="textCountA" style="font-size: small;"></div>

                                        <h4>Project Implementation Methodology</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="implementation" id="implementation" class="form-control" minlength="30" maxlength="300" onkeyup="clean('implementation'), charCountr('textCountB', 'implementation')" onkeydown="clean('implementation')" rows="3" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300."
                                                      required>The project implementation methodology adopted by <%=companyName%> is Scrum. It is a lightweight Agile project management framework that focuses on a collaborative, iterative and incremental approach for the development of a product or service.
                                            </textarea>
                                        </div>
                                        <div id="textCountB" style="font-size: small;"></div>

                                        <h4>Scrum Diagram</h4>
                                        <img src="Files/images/scrum_diagram.png" class="img-fluid"  alt="Scrum diagram">

                                        <h4>About Methodology</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="scrumValues" id="scrumValues" class="form-control" minlength="30" maxlength="300" onkeyup="clean('scrumValues'), charCountr('textCountC', 'scrumValues')" onkeydown="clean('scrumValues')" rows="30" cols="100" required  spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300."
                                                      required>The Scrum Framework implements the cornerstones defined by the Agile Manifesto which emphasises the value of:	
	* Individuals and interactions (communication) over processes and tools
	* Working software over comprehensive documentation
	* Customer collaboration over contract negotiation
	* Responding to change over following a plan

The main components of Scrum Framework are:
	* The three roles: Scrum Product Owner, Scrum Master and the Scrum Team
	* A prioritized Backlog containing the end user requirements
	* Sprints
	* Scrum Events: Sprint Planning Meeting (WHAT-Meeting, HOW-Meeting), Daily Scrum Meeting, Sprint Review Meeting, Sprint Retrospective Meeting.

Important in all Scrum projects are self-organization and communication within the team. In the Scrum Framework the
Scrum Product Owner and the Scrum Master share the responsibilities that would otherwise be those of a project
manager in a classical sense.

However, in the end, the team decides what and how much they can do in a given Sprint, which typically is a period of
between 2 - 4 weeks. The importance of this is that it maximises release output, while making sure that errors are identified early enough for direction to be modified where deemed necessary.

Another cornerstone of the Scrum Framework is communication. To this effect, Scrum consists of a daily stand-up
meeting that is time-boxed to 15 minutes (Daily Scrum). In the meeting, each team member answers the following 3
questions:
	1. What they did the day before?
	2. What they plan to achieve today?
	3. Do they foresee any obstacles?
In the end, the Scrum Framework itself is very simple. It defines only some general guidelines with only a few rules,
roles, artifacts and events. However each of these components is important, it serves a specific purpose and is
essential for a successful usage of the framework.
                                            </textarea>
                                        </div>
                                        <div id="textCountD" style="font-size: small;"></div>

                                        <h4>Strategic Plan</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="plan" id="plan" class="form-control" minlength="30" maxlength="300" onkeyup="clean('plan'), charCountr('textCountE', 'plan')" onkeydown="clean('plan')" rows="10" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300."
                                                      required>
The programme is in the XXXXX quarter so far it is going well. Of the original intake of 45 interns, XX interns have been employed somewhere else. And a replacement was taken on. All interns are working on various projects as mentioned in the work plan section below.

Evaluating and Monitoring the interns will continue to be a major aspect of <%=companyName%>’s contribution to their empowerment and preparation for meaningful employment, hopefully internally and definitely externally. The monthly assessments carried out ensure that the work and projects they have been engaged in are effective and of high quality. They also give the company, through mutual feedback, ideas on how to improve things for the current and prospective interns’ intake.
                                            </textarea>
                                        </div>
                                        <div id="textCountE" style="font-size: small;"></div>

                                        <h4>Work Placement</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="placement" id="placement" class="form-control" minlength="30" maxlength="300" onkeyup="clean('placement'), charCountr('textCountF', 'placement')" onkeydown="clean('placement')" rows="8" cols="100" spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300."
                                                      required>
Most of our interns are currently placed at different partner companies to broaden their skills and expertise in a different context. They are given different projects to work on and we monitor them every month by doing weekly reports, monthly assessments and we do site visits.

The company, through <%=companyName%> Recruitment Agency, is vigorously searching for job opportunities for, and encouraging the remaining interns to apply for those work openings that have been identified. The endeavour is ongoing.
                                            </textarea>
                                        </div>
                                        <div id="textCountF" style="font-size: small;"></div>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <button class="btn btn-secondary float-left" onclick="window.history.go(-1)"><i class="fa fa-arrow-left"></i>  back</button>
                                                <div class="btn-group float-right">
                                                    <button role="button" type="submit" class="btn btn-md btn-success " title="save current changes"><i class="fa fa-cog fa-save"></i> save</button>
                                                    <button role="button" type="button" class="btn btn-md btn-secondary" title="go to the previous section" onclick="$('.carousel').carousel('prev')"><i class="fa fa-chevron-left"></i> previous</button>
                                                    <button role="button" type="button" class="btn btn-md btn-info" title="go to the next section" onclick="$('.carousel').carousel('next')"><i class="fa fa-chevron-right"></i> next</button>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
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
                                    <p>	Activities which are undertaken for <b style="text-decoration: underline;">workplace</b> learning; when and how these were done in this quarter.</p>
                                    <hr class="my-9">
                                    <form action="#">
                                        <script>
                                            $(document).ready(function () {
                                                $("#activityTable").on('click', '#btnDelete', function () {
                                                    if (confirm("Are you sure you want to delete this row?")) {
                                                        $(this).closest('tr').remove();
                                                    }
                                                });
                                            });
                                        </script>
                                        <table
                                            class="table table-sm table-responsive table-dark table-hover" id="activityTable">
                                            <thead class="table-bordered" style="background-color: #d6d8d9; color: #1b1e21; border: 1px solid #c0c8ca;">
                                                <tr>
                                                    <th>Date<br> [name]</th>
                                                    <th>Activity</th>
                                                    <th>Learning Outcome</th>
                                                    <th>Mentor / Coach</th>
                                                    <th>Department</th>
                                                    <th>Action Required</th>
                                                    <th>Due Date <br>By When?</th>
                                                    <th>Remove Row</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    try {
                                                        String activityDate = "", activityName = "", learningOutcome = "Be able to / to do ", department = "ICT department", requiredAction = "", dueDate = "";
                                                        Database DB = new Database();
                                                        Connection con = DB.getCon1();
                                                        Statement st = con.createStatement();
                                                        st.executeQuery(
                                                                "SELECT applicant_personal_details.applicant_id, applicant_personal_details.First_Name, "
                                                                + "applicant_personal_details.Surname, applicants.id_number, tasks.Task_Name, tasks.Task_Percentage, "
                                                                + "DATE_FORMAT(reports.Report_Date,'%d/%m/%Y') as Report_Date, DATE_FORMAT(SUBDATE(reports.Report_Date, "
                                                                + "INTERVAL 4 DAY),'%d/%m/%Y') as Actual_Date FROM intern_sla "
                                                                + "INNER JOIN applicant_personal_details ON intern_sla.applicant_id = applicant_personal_details.applicant_id "
                                                                + "INNER JOIN applicants ON applicants.id = intern_sla.applicant_id "
                                                                + "INNER JOIN activity.users ON users.id_number = applicants.id_number "
                                                                + "INNER JOIN activity.reports ON reports.user_id = users.id "
                                                                + "INNER JOIN activity.tasks ON reports.id = tasks.report_id " + "WHERE sla_id = "
                                                                + sla_id + " AND TIMESTAMPDIFF(MONTH, reports.Report_Date, NOW()) <= " + months
                                                                + " AND Task_Percentage = 100 ORDER BY applicant_personal_details.applicant_id ASC;");
                                                        ResultSet rs = st.getResultSet();
                                                        int count = 0;
                                                        while (rs.next()) {
                                                            count++;
                                                            String name = new Caps().toUpperCaseFirstLetter(rs.getString("First_Name").trim());
                                                            String surname = new Caps().toUpperCaseSurname(rs.getString("Surname").trim());
                                                            name += " " + surname;
                                                            dueDate = rs.getString("Report_Date");
                                                            activityDate = rs.getString("Actual_Date");
                                                            activityName = rs.getString("tasks.Task_Name");
                                                            requiredAction = rs.getString("tasks.Task_Name");
                                                            out.print("<tr id='tr" + count + "'>");
                                                            out.print("<td><textarea id='txtAa" + count + "' rows='5' cols='10' required spellcheck='true'>" + count + " " + activityDate + "\n\n[" + name + "]</textarea></td>");
                                                            out.print("<td><textarea id='txtAb" + count + "' rows='5' cols='30' required spellcheck='true'>" + count + " " + activityName + "</textarea></td>");
                                                            out.print("<td><textarea id='txtAc" + count + "' rows='5' cols='30' required spellcheck='true'>" + count + " " + learningOutcome + activityName + "</textarea></td>");
                                                            out.print("<td><textarea id='txtAd" + count + "' rows='5' cols='15' required spellcheck='true'>" + count + " " + mentor + "</textarea></td>");
                                                            out.print("<td><textarea id='txtAe" + count + "' rows='5' cols='15' required spellcheck='true'>" + count + " " + department + "</textarea></td>");
                                                            out.print("<td><textarea id='txtAf" + count + "' rows='5' cols='20' required spellcheck='true'>" + count + " " + requiredAction + "</textarea></td>");
                                                            out.print("<td><textarea id='txtAg" + count + "' rows='5' cols='10' required spellcheck='true'>" + count + " " + dueDate + "</textarea></td>");
                                                            out.print("<td><button type='button' id='btnDelete' title='Remove row'><span aria-hidden='true'>&times;</span></button></td>");
                                                            out.print("</tr>");
                                                        }
                                                    } catch (SQLException e) {
                                                        out.println(e);
                                                    }
                                                %>
                                            </tbody>
                                        </table>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <button class="btn btn-secondary float-left" onclick="window.history.go(-1)"><i class="fa fa-arrow-left"></i>  back</button>
                                                <div class="btn-group float-right">
                                                    <button role="button" type="submit" class="btn btn-md btn-success " title="save current changes"><i class="fa fa-cog fa-save"></i> save</button>
                                                    <button role="button" type="button" class="btn btn-md btn-secondary" title="go to the previous section" onclick="$('.carousel').carousel('prev')"><i class="fa fa-chevron-left"></i> previous</button>
                                                    <button role="button" type="button" class="btn btn-md btn-info" title="go to the next section" onclick="$('.carousel').carousel('next')"><i class="fa fa-chevron-right"></i> next</button>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
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
                                    <form action="#">
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
                                            <tbody>
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
                                                            out.print("<td>"+count+"</td>");
                                                            out.print("<td><textarea id='txtBoxa" + count + "' rows='1' cols='10' required spellcheck='true'>" + name + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxb" + count + "' rows='1' cols='10' required spellcheck='true'>" + surname + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxc" + count + "' rows='1' cols='13' required spellcheck='true'>" + idnum + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxd" + count + "' rows='1' cols='13' required spellcheck='true'>" + progType + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxe" + count + "' rows='1' cols='13' required spellcheck='true'>" + entryDate + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxf" + count + "' rows='1' cols='13' required spellcheck='true'>" + startDate + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxg" + count + "' rows='1' cols='10' required spellcheck='true'>" + ofo + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxh" + count + "' rows='1' cols='10' required spellcheck='true'> Level " + nqf + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxi" + count + "' rows='1' cols='25' required spellcheck='true'>" + qualification + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxj" + count + "' rows='1' cols='10' required spellcheck='true'>" + companyName + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxk" + count + "' rows='1' cols='15' required spellcheck='true'>" + sdlNum + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxl" + count + "' rows='1' cols='10' required spellcheck='true'>" + managerTel + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxm" + count + "' rows='1' cols='10' required spellcheck='true'>" + trainer + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxn" + count + "' rows='1' cols='15' required spellcheck='true'>" + agredidationNum + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxo" + count + "' rows='1' cols='10' required spellcheck='true'>" + trainerContacts + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxp" + count + "' rows='1' cols='10' required spellcheck='true'>" + privacy + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxq" + count + "' rows='1' cols='10' required spellcheck='true'>" + province + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxr" + count + "' rows='1' cols='25' required spellcheck='true'>" + municipality + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxs" + count + "' rows='1' cols='10' required spellcheck='true'>" + area + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxt" + count + "' rows='1' cols='15' required spellcheck='true'>" + areaType + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxu" + count + "' rows='1' cols='10' required spellcheck='true'>" + race + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxv" + count + "' rows='1' cols='10' required spellcheck='true'>" + gender + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxw" + count + "' rows='1' cols='10' required spellcheck='true'>" + age + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxx" + count + "' rows='1' cols='10' required spellcheck='true'>" + disability + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxy" + count + "' rows='1' cols='10' required spellcheck='true'>" + youth + "</textarea></td>");
                                                            out.print("<td><textarea id='txtBoxz" + count + "' rows='1' cols='10' required spellcheck='true'>" + citizenship + "</textarea></td>");
                                                            out.print("</tr>");
                                                        }
                                                    } catch (SQLException e) {
                                                        out.println(e);
                                                    }
                                                %>
                                            </tbody>
                                        </table>

                                        <table class="table table-sm table-responsive table-light table-bordered table-hover" id="learnerCountTable">
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
                                                        st.executeQuery("SELECT SUM(IF(ISNULL(applicant_id) = 0 AND status_id = 1 AND (SELECT COUNT(t2.applicant_id) FROM intern_sla AS t2 WHERE t2.applicant_id=t1.applicant_id HAVING COUNT(t2.applicant_id) < 2) = 1, 1, 0)) iin, SUM(IF(ISNULL(applicant_id) = 0 AND status_id = 2 AND TIMESTAMPDIFF(MONTH, date, " + formatterSQL.format(LocalDate.parse(request.getParameter("creationDate"))) + ") <= " + months + ",1,0)) oout FROM intern_sla t1 WHERE sla_id = " + sla_id + ";");
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
                                                	<td><input name="in" type="number" min="0" max="250" value="<%=in%>"></td>
                                                	<td><input name="company" type="number" min="0" max="100" value="0"></td>
                                                	<td><input name="out" type="number" min="0" max="150" value="<%=outt%>"></td>                                               
                                                </tr>
                                            </tbody>
                                        </table>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <button class="btn btn-secondary float-left" onclick="window.history.go(-1)"><i class="fa fa-arrow-left"></i>  back</button>
                                                <div class="btn-group float-right">
                                                    <button role="button" type="submit" class="btn btn-md btn-success " title="save current changes"><i class="fa fa-cog fa-save"></i> save</button>
                                                    <button role="button" type="button" class="btn btn-md btn-secondary" title="go to the previous section" onclick="$('.carousel').carousel('prev')"><i class="fa fa-chevron-left"></i> previous</button>
                                                    <button role="button" type="button" class="btn btn-md btn-info" title="go to the next section" onclick="$('.carousel').carousel('next')"><i class="fa fa-chevron-right"></i> next</button>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
							<div class="carousel-item">
                                <div class="jumbotron">
                                    <div class="row">
                                        <div class="col-lg-12">
			                            	<h3 class="float-left">SECTION E: SIGNIFICANT ACHIEVEMENT THIS QUARTER</h3>
                                           	<div class="btn-group float-right">
                                            	<button role="button" type="button" class="btn btn-md btn-secondary" title="go to the previous section" onclick="$('.carousel').carousel('prev')"><i class="fa fa-chevron-left"></i> previous</button>
                                               	<button role="button" type="button" class="btn btn-md btn-info" title="go to the next section" onclick="$('.carousel').carousel('next')"><i class="fa fa-chevron-right"></i> next</button>
                                           </div>
                                    	</div>
                                    </div>                                    
                                    <hr class="my-9">
                                    <form action="#">
                                        <h4><b>Interns have achieved the following:</b></h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="achievements" id="achievements" class="form-control" minlength="30" maxlength="300" onkeyup="clean('achievements'), charCountr('tbA', 'achievements')" onkeydown="clean('achievements')" rows="6" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300."
                                                      required>Scrum Fundamental and scrum Master
Newsletters for previous months
Installation of Oracle Virtual Box machine
Installation of Statistical Package for the Social Sciences (SPSS) on student computers
											</textarea>
										</div>
                                        <div id="tbA" style="font-size: small;"></div>

                                        <table class="table table-sm table-borderless">
                                            <tr>
                                                <td>Compiled By</td>
                                                <td>: <input name="compiler" type="text" value="<%=managerName + " " + managerSurname%>"></td>
                                            </tr>
                                            <tr>
                                                <td>Date</td>
                                                <td>: <input name="date" type="text" value="<%=creationDate%>"></td>
                                            </tr>
                                        </table>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <button class="btn btn-secondary float-left" onclick="window.history.go(-1)"><i class="fa fa-arrow-left"></i>  back</button>
                                                <div class="btn-group float-right">
                                                    <button role="button" type="submit" class="btn btn-md btn-success " title="save current changes"><i class="fa fa-cog fa-save"></i> save</button>
                                                    <button role="button" type="button" class="btn btn-md btn-secondary" title="go to the previous section" onclick="$('.carousel').carousel('prev')"><i class="fa fa-chevron-left"></i> previous</button>
                                                    <button role="button" type="button" class="btn btn-md btn-info" title="go to the next section" onclick="$('.carousel').carousel('next')"><i class="fa fa-chevron-right"></i> next</button>
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
        </div>
        <script type="text/javascript">
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
                var regex = /[^a-z 0-9?!.,#%&()"':/\-\n]/gi;
                if (textfield.value.search(regex) > -1) {
                    textfield.value = textfield.value.replace(regex, "");
                }
            }
            //count remaining characters
            function charCountr(display, textbox) {
                var text_max = 300;
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