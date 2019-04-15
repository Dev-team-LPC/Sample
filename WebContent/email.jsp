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
                        <li class="breadcrumb-item active"> Send e-mail</li>
                    </ol>
                    ${message}
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- list generated reports card-->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h4 class="display-9">Send Email</h4>
                                </div>
                                <div class="card-body">
                                    <h6 class="card-title font-weight-bold text-secondary">List of all learners in <%=request.getParameter("emailGroup").substring(2)%></h6>
                                    <table class="table table-bordered table-condensed text-nowrap table-sm table-hover">
                                        <thead class="thead-light">
                                            <tr>
                                                <th>Name</th>
                                                <th>Surname</th>
                                                <th>e-mail</th>
                                                <th>Add to list</th>
                                            </tr>
                                        </thead>
                                        <%
                                            String sla_id = new Foreword().getString(request.getParameter("emailGroup"), ".");
                                            try {
                                                Database DB = new Database();
                                                Connection con = DB.getCon1();
                                                Statement st = con.createStatement();
                                                st.executeQuery("SELECT t1.applicant_id, Surname, First_Name, email FROM intern_sla t1 INNER JOIN applicant_personal_details ON applicant_personal_details.applicant_id = t1.applicant_id INNER JOIN applicants ON applicants.id = applicant_personal_details.applicant_id WHERE t1.sla_id = "+sla_id+" AND (SELECT COUNT(t2.applicant_id) FROM intern_sla t2 WHERE t2.applicant_id = t1.applicant_id AND t2.sla_id = "+sla_id+" HAVING COUNT(t2.applicant_id) < 2) = 1;");
                                                ResultSet rs = st.getResultSet();
                                                String applicant_id, name, surname, email;

                                                while (rs.next()) {
                                                    applicant_id = (String) rs.getString("t1.applicant_id");
                                                    surname = new Caps().toUpperCaseSurname((String) rs.getString("Surname").trim());
                                                    name = new Caps().toUpperCaseFirstLetter((String) rs.getString("First_name").trim());
                                                    email = (String) rs.getString("email").trim();
                                        %>
                                        <tr>
                                            <td hidden="true"><%=applicant_id%></td>
                                            <td data-toggle="tooltip" data-placement="top" title="Select learner(s) via the right most column"><%=surname%></td>
                                            <td data-toggle="tooltip" data-placement="top" title="Select learner(s) via the right most column"><%=name%></td>
                                            <td data-toggle="tooltip" data-placement="top" title="Select learner(s) via the right most column"><%=email%></td>
                                            <td data-toggle="tooltip" data-placement="top" title="If checked, the learner will be in the email list"><input type="checkbox" class="cb btn" value="<%=applicant_id +". "+ name + " " + surname + " - " + email%>"></td>
                                        </tr>
                                        <%
                                                }
                                            } catch (SQLException e) {
                                                System.out.println(e);
                                            }
                                        %>
                                    </table>
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <button class="btn btn-md btn-secondary float-left" onclick="window.history.go(-1);"><i class="fa fa-arrow-left"></i> back</button>
                                            <button class="btn btn-md btn-primary float-right" type="button" onclick="if($('#emailList').is(':empty')){alert('No learner selected!');} else {$('#sendEmailModal').modal();}"><i class="fa fa-arrow-right"></i> forward</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Site Visit Report Modal -->
                    <div class="modal fade" id="sendEmailModal" tabindex="-1" role="dialog" aria-labelledby="sendEmailModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <form action="<%=request.getContextPath()%>/Emails?action=send-email" method="POST">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="sendEmailModalLabel"> E-mail List</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <ol id="emailList"></ol>
                                        <input type="hidden" name="emailGroup" value="<%=sla_id%>">
                                        <select hidden="true" name="emailListSelect" id="emailListSelect"></select>                                        
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-md btn-secondary" data-dismiss="modal">close</button>
                                        <button type="submit" class="btn btn-md btn-primary" onclick="return confirm('Are you sure you want to send an email to the selected leaner(s)? Once done, this action cannot be undone.')"><i class="fa fa-send"></i> send e-mail</button>
                                    </div>
                                </form>
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
            //add learners to email list
                $('.cb').click(function () {
                    $('#emailList').html("");
                    $('#emailListSelect').html("");
                    $(".cb").each(function () {
                        if ($(this).is(":checked")) {
                            $('#emailList').append('<li>' + $(this).val().split('. ').pop() + '</li>');
                            $('#emailListSelect').append('<option>' + $(this).val() + '</option>');
                        }
                    });
                });
            //toggle tooltip
            $(document).ready(function () {
                $('[data-toggle="tooltip"]').tooltip();
            });
        </script>
    </body>
</html>