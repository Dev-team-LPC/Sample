<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="cc.littlepig.databases.Database"%>
<%@ page import="cc.littlepig.classes.EmptyChecker"%>
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
        <title>e-mails - send</title>
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
    <%
    String replyGroup = new Foreword().getString((request.getParameter("replyGroup").trim()), ".");    
    EmptyChecker empty = new EmptyChecker();
    if (empty.isEmailsEmpty(replyGroup) == 'd'){
    	String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> Before checking replies, you need to have sent an email first</div>";
		request.setAttribute("message", alert);
		getServletContext().getRequestDispatcher("/DashboardController?action=site-visit-reports").forward(request, response);
    } else if (empty.isEmailsEmpty(replyGroup) == 'e'){
    	String alert = "<div class='alert alert-info alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>NOTE!</b> No learner has responded to the email yet</div>";
		request.setAttribute("message", alert);
		getServletContext().getRequestDispatcher("/DashboardController?action=site-visit-reports").forward(request, response);
    } else {
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
                                    <a class="dropdown-item" href="#"><i class="fa fa-wrench"></i> Account</a>
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
                        <li class="breadcrumb-item active"> E-mail Replies</li>
                    </ol>
                    ${message}
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- list generated reports card-->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h4 class="display-9">E-mail Replies</h4>
                                </div>
                                <div class="card-body">
                                    <h6 class="card-title alert alert-dark">Learners with a checked square in the status column have replied and those not checked have not submitted their answers.<br>
                                        To generate a site visit report, review all the feedback of learners and fill the form fields below the table.<br>
                                        <i class="fa fa-exclamation-triangle"></i> Please note that email replies are expected within <b>5 days</b> after the email link has been sent!</h6>
                                    <hr class="my-3">
                                    <button class="btn btn-sm btn-info btn-outline-info" onclick="myFunction()"><i class="fa fa-refresh"></i> refresh</button>
                                    <form method="POST" action="<%=request.getContextPath()%>/Emails?action=email-reply-update">
                    <div style="padding-top:2%;">
                        <table class="table table-bordered table-responsive table-sm table-hover">
                            <thead class="thead-light">
                                <tr>
                                    <th>No.</th>
                                    <th>Status</th>
                                    <th>Name</th>
                                    <th>Surname</th>
                                    <th class="text-nowrap">e-mail Address</th>
                                    <th style="width: 50%">Date Sent</th>
                                    <th style="width: 50%">Date Replied</th>
                                    <th>Learner's Experience</th>
                                    <th>Learner's Personal Feedback</th>
                                    <th>Learner's Highlights</th>
                                    <th>Learner's Challenges</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int countReply = 0, count = 0;
                                    Foreword fw = new Foreword();
                                    try {
                                        Caps cap = new Caps();
                                        Database DB1 = new Database();
                                        Connection con1 = DB1.getCon1();
                                        Statement st1 = con1.createStatement();
                                        st1.executeQuery("SELECT sla_emails.applicant_id, First_Name, Surname, email, DATE_FORMAT(sla_emails.created_at,'%d %b %Y %H:%i') AS email_date, IF(learner_experience IS NULL,\" \",learner_experience) AS learner_experience, IF(learner_feedback IS NULL,\" \",learner_feedback) AS learner_feedback, IF(learner_highlights IS NULL,\" \",learner_highlights) AS learner_highlights, IF(learner_challenges IS NULL,\" \",learner_challenges) AS learner_challenges, IF(form_date IS NULL, \" \",DATE_FORMAT(form_date,'%d %b %Y %H:%i')) as form_date, IF(learner_experience IS NULL OR learner_feedback IS NULL, 0, 1) as status FROM sla_emails INNER JOIN applicant_personal_details ON applicant_personal_details.applicant_id = sla_emails.applicant_id INNER JOIN applicants ON applicants.id = sla_emails.applicant_id WHERE sla_id = "+replyGroup+" AND TIMESTAMPDIFF(DAY, sla_emails.created_at, NOW()) < 6;");
                                        ResultSet rs1 = st1.getResultSet();
                                        while (rs1.next()) {
                                            count++;
                                            String status = rs1.getString("status").trim();
                                            String name = rs1.getString("First_Name").trim().toLowerCase();
                                            String surname = rs1.getString("Surname").trim().toLowerCase();
                                            String email = rs1.getString("email");
                                            String dateSent = rs1.getString("email_date");
                                            String dateReplied = rs1.getString("form_date");
                                            String experience = rs1.getString("learner_experience");
                                            String feedback = rs1.getString("learner_feedback");
                                            String highlights = rs1.getString("learner_highlights");
                                            String challenges = rs1.getString("learner_challenges");
                                            if (status.equals("1")) {
                                                status = "<i class=\"fa fa-lg fa-check-square-o\"></i>";
                                            } else {
                                                countReply++;
                                                status = "<i class=\"fa fa-lg fa-square-o\"></i>";
                                            }
                                            out.println("<tr>");
                                            out.println("<td><center>" + count + "</center></td>");
                                            out.println("<td><center>" + status + "</center></td>");
                                            out.println("<td>" + cap.toUpperCaseFirstLetter(name) + "</td>");
                                            out.println("<td>" + cap.toUpperCaseFirstLetter(surname) + "</td>");
                                            out.println("<td>" + email + "</td>");
                                            out.println("<td>" + dateSent + "</td>");
                                            out.println("<td>" + dateReplied + "</td>");
                                            out.println("<td>" + experience + "</td>");
                                            out.println("<td>" + feedback + "</td>");
                                            out.println("<td>" + highlights + "</td>");
                                            out.println("<td>" + challenges + "</td>");
                                            out.println("</tr>");
                                        }
                                        con1.close();
                                    } catch (SQLException e) {
                                        System.out.println(e);
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                    <%
                        String dis = "";
                        if (countReply == 0) {
                            dis = "";
                            if (count == 0) {
                                dis = "disabled";
                            }
                        } else {
                            dis = "disabled";
                        }

                        int DBfindings = 1;
                        try {
                            Database DB = new Database();
                            Connection con = DB.getCon1();
                            Statement st = con.createStatement();
                            st.executeQuery("SELECT IF(SUM(ISNULL(findings)) >= 1 OR ISNULL(SUM(ISNULL(findings))) >= 1, 1, 0) findings FROM sla_emails WHERE sla_id = " + replyGroup + " AND TIMESTAMPDIFF(DAY, created_at, NOW()) < 6;");
                            ResultSet rs = st.getResultSet();
                            if (rs.next()) {
                                DBfindings = rs.getInt("findings");
                            }
                            con.close();
                        } catch (SQLException e) {
                            System.out.println(e);
                        }
                        if (DBfindings == 0) {
                            String a = "", b = "";
                            try {
                                Database DB = new Database();
                                Connection con = DB.getCon1();
                                Statement st = con.createStatement();
                                st.executeQuery("SELECT DISTINCT findings, exposure FROM sla_emails WHERE sla_id = " + replyGroup + " AND TIMESTAMPDIFF(DAY, created_at, NOW()) < 6;");
                                ResultSet rs = st.getResultSet();
                                while (rs.next()) {
                                    a = rs.getString("findings");
                                    b = rs.getString("exposure");
                                }
                                if (a.equals(null) || b.equals(null)) {
                                    a = "nothing found";
                                    b = "nothing found";
                                }
                    %>
                    <h1 style="font-size: large">
                        <b>The comments below have already been submitted</b>
                    </h1>
                    <hr class="my-3"> 
                    <div>
                        <label for="find"><b>Findings:</b></label>
                        <textarea name="find" class="form-control" style="background-color: #FFF;" readonly rows="4"><%=a%></textarea>
                    </div>
                    <div>
                        <label for="expo"><b>Areas interns were exposed to:</b></label>
                        <textarea name="expo" class="form-control" style="background-color: #FFF;" readonly rows="4"><%=b%></textarea>
                    </div>
                    <%
                            con.close();
                        } catch (SQLException e) {
                            System.out.println(e);
                        }
                    %>
                    <div style="padding-top: 20px;">
                        <a class="btn btn-md btn-dark btn-outline-dark" href="<%=request.getContextPath()%>/DashboardController?action=site-visit-reports" role="button"><i class="fa fa-arrow-circle-left"></i> back</a>
                        <button class="btn btn-md btn-danger btn-outline-danger"  type="button" onclick="conf()"> 
                            <i class="fa fa-exchange"></i> replace
                        </button>
                        <script>
                            function conf() {
                                if (confirm("Do you really want to overwrite these comments?")) {
                                    $("#commentsModal").modal();
                                } else {
                                    $('.close').alert("close");
                                }
                            }
                        </script>
                    </div>
                    <!-- Overwrite comments Modal -->
                    <div class="modal fade" id="commentsModal" tabindex="-1" role="dialog" aria-labelledby="commentsModalTitle" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="commentsModalTitle">comment re-submission</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <form method="post" action="<%=request.getContextPath()%>/Emails?action=email-reply-update">
                                    <div class="modal-body">
                                        <div class="alert alert-info alert-dismissible">
                                            <button type="button" class="close" data-dismiss="alert">&times;</button>
                                            <strong>Please use &crarr; to start a new sentence.</strong>
                                        </div>
                                        <div class="form-group shadow-textarea">
                                            <label for="findings"><b>Findings:</b></label>
                                            <textarea name="findings" class="form-control" minlength="30" maxlength="300" id="findings" onkeyup="clean('findings'), charCountr('textCountB', 'findings')" onkeydown="clean('findings')" rows="4" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300." 
                                                      required <%=dis%> 
                                                      placeholder="This was the second visit
They are being developed by means of training (KEMP, Trello, Asana and CISCO training)
Three interns dropped out and were replaced
. . ."></textarea>
                                            <i><div id="textCountB" style="font-size: small;"></div></i>
                                        </div>
                                        <div class="form-group shadow-textarea">
                                            <label for="exposure"><b>Areas interns were exposed to:</b></label>
                                            <textarea style="text-align: left;" name="exposure" class="form-control" minlength="30" maxlength="300" id="exposure" onkeyup="clean('exposure'), charCountr('textCountA', 'exposure')" onkeydown="clean('exposure')" rows="4" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300." 
                                                      required <%=dis%> 
                                                      placeholder="KEMP training for all interns
CISCO
Learning UX/UI
Software and database..."></textarea>
                                            <i><div id="textCountA" style="font-size: small;"></div></i>
                                        </div>
                                        <div>
                                            <input name="slaId" type="text" hidden value="<%=replyGroup%>"></input>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                        <button type="submit" class="btn btn-primary" <%=dis%> onclick="return confirm('Are you sure you want to submit these comments?')" title="overwrite the existing comments">Submit</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <%
                    } else {
                    %>
                    <hr class="my-3"> 
                    <div class="alert alert-primary alert-dismissible">
                        <button type="button" class="close" data-dismiss="alert">&times;</button>
                        <i class="fa fa-exclamation-triangle"></i> Please use &crarr; to start a new sentence
                    </div>
                    <div class="form-group shadow-textarea">
                        <label for="findings"><b>Findings:</b></label>
                        <textarea name="findings" class="form-control" maxlength="300" id="findings" rows="4" minlength="20" maxlength="300" id="findings" onkeyup="clean('findings'), charCountr('textCountB', 'findings')" onkeydown="clean('findings')" rows="4" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 20 and not exceed 300." 
                                  required <%=dis%> 
                                  placeholder="This was the second visit
They are being developed by means of training (KEMP, Trello, Asana and CISCO training)
Three interns dropped out and were replaced"></textarea>
                        <i><div id="textCountB" style="font-size: small;"></div></i>
                    </div>
                    <div class="form-group shadow-textarea">
                        <label for="exposure"><b>Areas interns were exposed to:</b></label>
                        <textarea style="text-align: left;" name="exposure" class="form-control"  minlength="20" maxlength="300" id="exposure" onkeyup="clean('exposure'), charCountr('textCountA', 'exposure')" onkeydown="clean('exposure')" rows="4" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 20 and not exceed 300."  
                                  required <%=dis%> 
                                  placeholder="KEMP training for all interns
CISCO
Learning UX/UI
Software and database"></textarea>
                        <i><div id="textCountA" style="font-size: small;"></div></i>
                    </div>
                    <div>
                        <input name="slaId" type="hidden" value="<%=replyGroup%>"></input>
                    </div>
                    <div class="text-center">
                        <a class="btn btn-md btn-dark btn-outline-dark" href="<%=request.getContextPath()%>/DashboardController?action=site-visit-reports" role="button"><i class="fa fa-arrow-circle-left"></i> back</a>
                        <button class="btn btn-md btn-outline-success" type="submit" <%=dis%> onclick="return confirm('Are you sure you want to submit these comments?')"><i class="fa fa-send"></i> submit</button>
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
        <%}%>
        <script type="text/javascript">
            //page refresh
            function myFunction() {
                location.reload();
            }
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
            //toggle tooltip
            $(document).ready(function () {
                $('[data-toggle="tooltip"]').tooltip();
            });
        </script>
        <%}%>        
    </body>
</html>