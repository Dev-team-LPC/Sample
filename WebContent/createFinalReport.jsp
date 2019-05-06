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
        <title>Final Reports - generation</title>
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
        <%!public static String mentor, months, sla_id, creationDate, creationDateSQL, learnrCount = "", sla_name = "", companyName = "",
                    progType = "", managerName = "", managerSurname = "", managerTel = "", managerSign = "", sdlNum = "", agredidationNum = "",
                    startDate = "", endDate = "", logo = "", managerCell = "", managerMail = "", managerAddr = "", quarter="";%>
        <%
            months = new Foreword().getString(request.getParameter("months"), " ");
            sla_id = new Foreword().getString(request.getParameter("sla"), ".");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM uuuu");
            DateTimeFormatter formatterSQL = DateTimeFormatter.ofPattern("uuuu-MM-dd");
            creationDate = formatter.format(LocalDate.parse(request.getParameter("creationDate")));
            creationDateSQL = formatterSQL.format(LocalDate.parse(request.getParameter("creationDate")));

            try {
                Database DB = new Database();
                Connection con = DB.getCon1();
                Statement st = con.createStatement();
                st.executeQuery("SELECT t1.Name, t1.type, t1.number_of_learners, DATE_FORMAT(t1.start_date,'%d %M %Y') start_date, DATE_FORMAT(t1.end_date,'%d %M %Y') end_date, if(NOW() <= DATE_ADD(start_date, INTERVAL 3 MONTH), 'First Quarter', if(NOW() <= DATE_ADD(start_date, INTERVAL 6 MONTH), 'Second Quarter', If(NOW() <= DATE_ADD(start_date, INTERVAL 9 MONTH), 'Third Quarter', if(NOW() <= DATE_ADD(start_date, INTERVAL 12 MONTH), 'Fourth Quarter', 'null')))) quarter, t2.company_name, t2.registration_number, t2.agredidation_number, t2.logo, t2.address, t2.representative_employer_name, t2.representative_employer_surname, t3.name, t3.surname, t3.cellphone, t3.telephone, t3.email FROM sla t1 INNER JOIN sla_company_details t2 ON t2.id = t1.company_id INNER JOIN sla_project_manager t3 ON t3.id = t2.project_manager_id WHERE t1.id = " + sla_id + ";");
                ResultSet rs = st.getResultSet();

                while (rs.next()) {
                	quarter = (String) rs.getString("quarter");
                    progType = (String) rs.getString("t1.type");
                    sla_name = (String) rs.getString("t1.Name");
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
                        <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/DashboardController?action=final-reports">Final Reports</a></li>
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
                            <form action="<%=request.getContextPath()%>/DashboardController?action=save-final-report" method="POST">
                                <input name="sla" type="hidden" value="<%=sla_id%>"/> 
                                <input name="months" type="hidden" value="<%=months%>"/>
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
                                                <td>Date of final report</td>
                                                <td>: <input style="background-color:#fff;" id="myDate" type="text" name="creationDate" value="<%=creationDateSQL%>" readonly onchange="setDateSame()" required placeholder="YYYY-MM-DD" pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" title="The date should be in this format: YYYY-MM-DD"></td>                                            
                                            </tr>
                                            <tr>
                                                <td>Start date</td>
                                                <td>: <%=startDate%></td>
                                            </tr>
                                            <tr>
                                                <td>End date</td>
                                                <td>: <%=endDate%></td>
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
                                                <a class="btn btn-secondary float-left" role="button" href="<%=request.getContextPath()%>/DashboardController?action=final-reports"><i class="fa fa-arrow-left"></i> back</a>
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
This report comprises the fourth and final report for <%=companyName%>’s internship programme on Contract Number: <%=sla_name%>. It reviews the outcomes of assignments that the interns had been working on.</textarea>
                                        </div>
                                        <div id="textCountA" style="font-size: small;"></div>

                                        <h4>Project Implementation Methodology</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="implementation" id="implementation" class="form-control" minlength="30" maxlength="400" onload="clean('implementation'), charCountr('textCountB', 'implementation')" onkeyup="clean('implementation'), charCountr('textCountB', 'implementation')" onkeydown="clean('implementation')" rows="3" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
The project implementation methodology adopted by <%=companyName%> is Scrum. It is a lightweight Agile project management framework that focuses on a collaborative, iterative and incremental approach for the development of a product or service.</textarea>
                                        </div>
                                        <div id="textCountB" style="font-size: small;"></div>

                                        <h4>Methodology Diagram</h4>
                                        <img src="images/scrum_diagram_1.png" class="img-fluid" style="width:100%" alt="Scrum diagram">

                                        <h4>About Methodology</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="implementationDetails" id="implementationDetails" class="form-control" minlength="30" maxlength="2000" onload="clean('implementationDetails'), charCountr('textCountC', 'implementationDetails')" onkeyup="clean('implementationDetails'), charCountr('textCountC', 'implementationDetails')" onkeydown="clean('implementationDetails')" rows="30" cols="100" required  spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
The Scrum Framework implements the cornerstones defined by the Agile Manifesto which emphasises the value of:	
    * Individuals and interactions (communication) over processes and tools
    * Working software over comprehensive documentation
    * Customer collaboration over contract negotiation
    * Responding to change over following a plan

The main components of Scrum Framework are:
    * The three roles: Scrum Product Owner, Scrum Master and the Scrum Team
    * A prioritized Backlog containing the end user requirements
    * Sprints
    * Scrum Events: Sprint Planning Meeting (WHAT-Meeting, HOW-Meeting), Daily Scrum Meeting, Sprint Review Meeting, Sprint Retrospective Meeting.

Important in all Scrum projects are self-organization and communication within the team. In the Scrum Framework the Scrum Product Owner and the Scrum Master share the responsibilities that would otherwise be those of a project manager in a classical sense.

However, in the end, the team decides what and how much they can do in a given Sprint, which typically is a period of between 2 - 4 weeks. The importance of this is that it maximises release output, while making sure that errors are identified early enough for direction to be modified where deemed necessary.

Another cornerstone of the Scrum Framework is communication. To this effect, Scrum consists of a daily stand-up meeting that is time-boxed to 15 minutes (Daily Scrum). In the meeting, each team member answers the following 3 questions:
    1. What they did the day before?
    2. What they plan to achieve today?
    3. Do they foresee any obstacles?
In the end, the Scrum Framework itself is very simple. It defines only some general guidelines with only a few rules, roles, artifacts and events. However each of these components is important, it serves a specific purpose and is essential for a successful usage of the framework.</textarea>
                                        </div>
                                        <div id="textCountC" style="font-size: small;"></div>

                                        <h4>Strategic Plan</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="plan" id="plan" class="form-control" minlength="30" maxlength="1000" onload="clean('plan'), charCountr('textCountD', 'plan')" onkeyup="clean('plan'), charCountr('textCountD', 'plan')" onkeydown="clean('plan')" rows="10" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
The programme is in the <%=quarter.toLowerCase()%> so far it is going well. Of the original intake of 45 interns, XX interns have been employed somewhere else. And a replacement was taken on. All interns are working on various projects as mentioned in the work plan section below.

Evaluating and Monitoring the interns will continue to be a major aspect of <%=companyName%>’s contribution to their empowerment and preparation for meaningful employment, hopefully internally and definitely externally. The monthly assessments carried out ensure that the work and projects they have been engaged in are effective and of high quality. They also give the company, through mutual feedback, ideas on how to improve things for the current and prospective interns’ intake.</textarea>
                                        </div>
                                        <div id="textCountD" style="font-size: small;"></div>

                                        <h4>Work Placement</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="placement" id="placement" class="form-control" minlength="30" maxlength="1000" onload="clean('placement'), charCountr('textCountE', 'placement')" onkeyup="clean('placement'), charCountr('textCountE', 'placement')" onkeydown="clean('placement')" rows="8" cols="100" spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
Most of our interns are currently placed at different partner companies to broaden their skills and expertise in a different context. They are given different projects to work on and we monitor them every month by doing weekly reports, monthly assessments and we do site visits.

The company, through <%=companyName%> Recruitment Agency, is vigorously searching for job opportunities for, and encouraging the remaining interns to apply for those work openings that have been identified. The endeavour is ongoing.</textarea>
                                        </div>
                                        <div id="textCountE" style="font-size: small;"></div>
                                        <%
                                        } else if (companyName.equalsIgnoreCase("Border ICT & Cabling Service") && progType.equalsIgnoreCase("internship")) {
                                        %>
                                        <h4>Introduction</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="introduction" id="introduction" class="form-control" minlength="30" maxlength="400" onload="clean('introduction'), charCountr('textCountA', 'introduction')" onkeyup="clean('introduction'), charCountr('textCountA', 'introduction')" onkeydown="clean('introduction')" rows="3" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
All our interns seem to be working well considering this their first work experience. They have shown great interest and enthusiasm, and the response we get from them and their mentors show that they are getting the required experience.</textarea>
                                        </div>
                                        <div id="textCountA" style="font-size: small;"></div>

                                        <h4>Project Implementation Methodology</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="implementation" id="implementation" class="form-control" minlength="30" maxlength="400" onload="clean('implementation'), charCountr('textCountB', 'implementation')" onkeyup="clean('implementation'), charCountr('textCountB', 'implementation')" onkeydown="clean('implementation')" rows="4" cols="100" required  spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
Through the use of Scrum project management methodology, learners complete detailed description on how everything will be done, what they have done, what they are planning to do on their projects, and their obstacles. We have chosen this methodology because the interns will work independently and also in teams to provide to them the best outcome for allocated projects. This will help them know the best solutions needed for the problems presented to them.</textarea>
                                        </div>
                                        <div id="textCountB" style="font-size: small;"></div>

                                        <h4>Strategic Plan</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="plan" id="plan" class="form-control" minlength="30" maxlength="1000" onload="clean('plan'), charCountr('textCountD', 'plan')" onkeyup="clean('plan'), charCountr('textCountD', 'plan')" onkeydown="clean('plan')" rows="4" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
To have a sustainable internship programs, the learners are given tasks or project that will give them the required experience and to enhance their ICT/Marketing skills. These tasks are rotated so all interns can have the knowledge required at the end of the program. Each intern will be given a chance to meet or work with our clients in order to assist them and provide live environment experience in dealing with real time issues.</textarea>
                                        </div>
                                        <div id="textCountD" style="font-size: small;"></div>

                                        <h4>Work Placement</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="placement" id="placement" class="form-control" minlength="30" maxlength="1000" onload="clean('placement'), charCountr('textCountE', 'placement')" onkeyup="clean('placement'), charCountr('textCountE', 'placement')" onkeydown="clean('placement')" rows="4" cols="100" spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
Interns are placed at partner companies where they are given individual and group projects. As Border ICT and Cabling Service we follow up on how they are progressing, and also assist with any issues that might require our intervention when problems arise which might cause setbacks on their work. Every Fridays all our interns are required to submit full report detailing all the tasks completed, including problems encountered. They are also required to submit monthly assessments.</textarea>
                                        </div>
                                        <div id="textCountE" style="font-size: small;"></div>
                                        <%} else {%>
                                        <h4>Introduction</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="introduction" id="introduction" class="form-control" minlength="30" maxlength="400" onload="clean('introduction'), charCountr('textCountA', 'introduction')" onkeyup="clean('introduction'), charCountr('textCountA', 'introduction')" onkeydown="clean('introduction')" rows="3" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
The purpose of this qualification may be stated as:
To develop learners with the requisite competencies against the skills profile for the systems support career path (The overarching aim being to develop a broader base of skilled ICT professionals to underpin economic growth)</textarea>
                                        </div>
                                        <div id="textCountA" style="font-size: small;"></div>

                                        <h4>Project Implementation Methodology</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="implementation" id="implementation" class="form-control" minlength="10" maxlength="400" onload="clean('implementation'), charCountr('textCountB', 'implementation')" onkeyup="clean('implementation'), charCountr('textCountB', 'implementation')" onkeydown="clean('implementation')" rows="3" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
Outcomes based.</textarea>
                                        </div>
                                        <div id="textCountB" style="font-size: small;"></div>

                                        <h4>Strategic Plan</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="plan" id="plan" class="form-control" minlength="30" maxlength="1000" onload="clean('plan'), charCountr('textCountD', 'plan')" onkeyup="clean('plan'), charCountr('textCountD', 'plan')" onkeydown="clean('plan')" rows="6" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
* Provide qualified learners with an undergraduate entry into the field of networking/systems support, earning credits towards tertiary offerings in the fields of Computer Studies or Computer Science.
* Prepare qualified learners for initial employment in the computer industry.
* Allow the credits achieved in the National Certificates relating to Information Technology at NQF level 4 to be used as prior learning for this qualification.
* Allow many of the unit standards listed in this qualification, to be used in Learnership Schemes in the Information
* Systems and Technology sector, as well as other sectors where Information Technology is a key requirement.</textarea>
                                        </div>
                                        <div id="textCountD" style="font-size: small;"></div>

                                        <h4>Work Placement</h4>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="placement" id="placement" class="form-control" minlength="30" maxlength="1000" onload="clean('placement'), charCountr('textCountE', 'placement')" onkeyup="clean('placement'), charCountr('textCountE', 'placement')" onkeydown="clean('placement')" rows="4" cols="100" spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
* Little Pig will endeavour to employ 70% of the learners, should they show commitment within the 12 months of their learnership.</textarea>
                                        </div>
                                        <div id="textCountE" style="font-size: small;"></div>
                                        <%}%>
                                        <table class="table table-sm table-light table-hover table-bordered" id="placementTable">
                                            <thead style="background-color: #d6d8d9; color: #1b1e21; border: 1px solid #c0c8ca;">
                                                <tr>
                                                    <th>No.</th>
                                                    <th>Surname</th>
                                                    <th>Name</th>
                                                    <th>Identity Number</th>
                                                    <th>Gender</th>
                                                    <th id="location">Placement</th>
                                                    <th>Employer</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    try {
                                                        Database DB = new Database();
                                                        Connection con = DB.getCon1();
                                                        Statement st = con.createStatement();
                                                        st.executeQuery("SELECT Surname, First_Name, id_number, IF(applicant_gender_id = 1, \"Female\", \"Male\") gender, (SELECT company_name FROM sla INNER JOIN sla_company_details ON sla_company_details.id = sla.company_id WHERE sla.id = t1.sla_id) company FROM intern_sla t1 INNER JOIN applicant_personal_details ON applicant_personal_details.applicant_id = t1.applicant_id INNER JOIN applicants ON applicants.id = t1.applicant_id INNER JOIN sla ON t1.sla_id = sla.id WHERE sla_id = " + sla_id + " AND t1.status_id = 1 AND (SELECT COUNT(t2.applicant_id) FROM intern_sla AS t2 WHERE t2.applicant_id = t1.applicant_id AND t2.sla_id = " + sla_id + " HAVING COUNT(t2.applicant_id) < 2) = 1 ORDER BY Surname ASC;");
                                                        ResultSet rs = st.getResultSet();
                                                        int count = 0;
                                                        while (rs.next()) {
                                                            count++;
                                                            String surname = new Caps().toUpperCaseSurname(rs.getString("Surname").trim());
                                                            String name = new Caps().toUpperCaseFirstLetter(rs.getString("First_Name").trim());
                                                            String id = rs.getString("id_number");
                                                            String gender = rs.getString("gender");
                                                            String company = rs.getString("company");
                                                            String location = "Currently at";
                                                            out.print("<tr>");
                                                            out.print("<td>" + count + "</td>");
                                                            out.print("<td>" + surname + "</td>");
                                                            out.print("<td>" + name + "</td>");
                                                            out.print("<td>" + id + "</td>");
                                                            out.print("<td>" + gender + "</td>");
                                                            out.print("<td id='loc8xn" + count + "' contenteditable='true' onload=\"clean('loc8xn" + count + "')\" onkeydown=\"clean('loc8xn" + count + "')\" onkeyup=\"clean('loc8xn" + count + "')\">" + location + "</td>");
                                                            out.print("<td>" + company + "</td>");
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
                                                <a class="btn btn-secondary float-left" role="button" href="<%=request.getContextPath()%>/DashboardController?action=final-reports"><i class="fa fa-arrow-left"></i> back</a>
                                                <div class="btn-group float-right">
                                                    <button role="button" type="button" class="btn btn-md btn-secondary" title="go to the previous section" onclick="$('.carousel').carousel('prev')"><i class="fa fa-chevron-left"></i> previous</button>
                                                    <button role="button" type="button" class="btn btn-md btn-info" title="go to the next section" onclick="$('.carousel').carousel('next')"><i class="fa fa-chevron-right"></i> next</button>
                                                </div>
                                            </div>
                                        </div>
                                        <input type="hidden" id="array6" name="array6"/>
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
                                                        String activityDate = "", activityName = "", learningOutcome = "Be able to / to do ", department = "ICT department", requiredAction = "", dueDate = "";
                                                        Database DB = new Database();
                                                        Connection con = DB.getCon1();
                                                        Statement st = con.createStatement();
                                                        st.executeQuery("SELECT applicant_personal_details.applicant_id, applicant_personal_details.First_Name, "
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
                                                            out.print("<tr>");
                                                            out.print("<td>" + count + "</td>");
                                                            out.print("<td>" + activityDate + "\n[" + name + "]</td>");
                                                            out.print("<td id='actvty" + count + "' contenteditable='true' onload=\"clean('actvty" + count + "')\" onkeydown=\"clean('actvty" + count + "')\" onkeyup=\"clean('actvty" + count + "')\">" + activityName + "</td>");
                                                            out.print("<td id='actvtOutcome" + count + "' contenteditable='true' onload=\"clean('actvtOutcome" + count + "')\" onkeydown=\"clean('actvtOutcome" + count + "')\" onkeyup=\"clean('actvtOutcome" + count + "')\">" + learningOutcome + activityName + "</td>");
                                                            out.print("<td>" + mentor + "</td>");
                                                            out.print("<td>" + department + "</td>");
                                                            out.print("<td id='axnReq" + count + "' contenteditable='true' onload=\"clean('axnReq" + count + "')\" onkeydown=\"clean('axnReq" + count + "')\" onkeyup=\"clean('axnReq" + count + "')\">" + requiredAction + "</td>");
                                                            out.print("<td>" + dueDate + "</td>");
                                                            out.print("<td><button class='btn btn-danger btn-circle' type='button' id='btnDelete' title='Remove row'><i class='fa fa-trash' aria-hidden='true'></i></button></td>");
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
                                                <a class="btn btn-secondary float-left" role="button" href="<%=request.getContextPath()%>/DashboardController?action=final-reports"><i class="fa fa-arrow-left"></i> back</a>
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
                                                    <td><%=in%></td>
                                                    <td>0</td>
                                                    <td><%=outt%></td>                                               
                                                </tr>
                                            </tbody>
                                        </table>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <a class="btn btn-secondary float-left" role="button" href="<%=request.getContextPath()%>/DashboardController?action=final-reports"><i class="fa fa-arrow-left"></i> back</a>
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
* Scrum Fundamental and scrum Master
* Newsletters for previous months
* Installation of Oracle Virtual Box machine
* Installation of Statistical Package for the Social Sciences (SPSS) on student computers</textarea>
                                        </div>
                                        <div id="tbA" style="font-size: small;"></div>
                                        <%} else {%>
                                        <div class="form-group shadow-textarea">
                                            <textarea name="achievements" id="achievements" class="form-control" minlength="30" maxlength="400" onload="clean('achievements'), charCountr('tbA', 'achievements')" onkeyup="clean('achievements'), charCountr('tbA', 'achievements')" onkeydown="clean('achievements')" rows="6" cols="100" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300.">
The learners have learnt to work on their own and also in teams. They Have also obtained 2 scrum certificates, Scrum Fundamentals and Scrum Master.</textarea>
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
                                                <td id="compylDate">: <%=creationDateSQL%></td>
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
                                                <a class="btn btn-secondary float-left" role="button" href="<%=request.getContextPath()%>/DashboardController?action=final-reports"><i class="fa fa-arrow-left"></i> back</a>	
                                                <div class="btn-group float-right">
                                                    <button role="button" type="submit" class="btn btn-md btn-primary" onclick="saveTableData()" data-toggle="tooltip" data-placement="bottom" title="If you plan on editing later"><i class="fa fa-save"></i> save report</button>
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
                var myTab1 = document.getElementById('placementTable');
                var index = document.getElementById("activity").cellIndex;
                var index1 = document.getElementById("outcome").cellIndex;
                var index2 = document.getElementById("axnRequired").cellIndex;
                var index3 = document.getElementById("activityDate").cellIndex;
                var index4 = document.getElementById("activityDueDate").cellIndex;
                var index5 = document.getElementById("location").cellIndex;
                var arr = [], arr1 = [], arr2 = [], arr3 = [], arr4 = [], arr5 =[];

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
                
                for (i = 1; i < myTab1.rows.length; i++) {
                    var objCells1 = myTab1.rows.item(i).cells;

                    for (var j = index5; j <= index5; j++) {
                        arr5.push(objCells1.item(j).innerHTML);
                    }
                    document.getElementById("array6").value = arr5.join("::");
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