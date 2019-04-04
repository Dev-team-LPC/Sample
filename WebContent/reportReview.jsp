<%-- 
    Document   : quarterlyReportReview
    Created on : 26 Oct 2018, 11:03:51 AM
    Author     : cyprian
--%>

<%@page import="java.time.LocalDate"%>
<%@ page import="cc.littlepig.classes.Caps"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Review Reports</title>
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link href="https://fonts.googleapis.com/css?family=Roboto|Varela+Round" rel="stylesheet">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css" />
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
        <link rel="stylesheet" href="css/reports-customstyle.css">    
    </head>
    <body>
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
                        <li class="breadcrumb-item"><a href="#" onclick="window.history.go(-1)"><%=request.getParameter("report_type")%> Reports</a></li>
                        <li class="breadcrumb-item active">Download-View Report</li>
                    </ol>
                <!-- generate report card-->
                <div class="card mb-4">
                    <div class="card-header">
                        <h4 class="display-9 card-text text-center">The <%=request.getParameter("report_type")%>  report was successfully retrieved!</h4>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-sm-4"></div>
                            <div class="col-sm-4 text-center">
                                <h6 class="card-title font-weight-bold text-primary">You can now download or view the report</h6>
                                <div class="form-row btn-group">
                                    <div class="text-center">
                                        <button class="btn btn-secondary" onclick="window.history.go(-1);"><i class="fa fa-arrow-left"></i> back</button>
                                        <a class="btn btn-success" role="button" href="view-generated-report?file=<%=request.getParameter("file")%>" target="_blank"><i class="fa fa-eye"></i> view</a>
                                        <a class="btn btn-primary" role="button" href="Download?file=<%=request.getParameter("file")%>"><i class="fa fa-download"></i> Download</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-4"></div>
                        </div>
                    </div>
                    <!-- Sticky Footer -->
                    <div class="card-footer">
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
        </div>
        <!-- /#page-content-wrapper -->
    </body>
</html>
