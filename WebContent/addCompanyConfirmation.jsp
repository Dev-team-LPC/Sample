<%@ page import="cc.littlepig.databases.Database"%>
<%@ page import="cc.littlepig.classes.Caps"%>
<%@ page import="cc.littlepig.classes.Foreword"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
		<title>Review Changes</title>
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link href="https://fonts.googleapis.com/css?family=Roboto|Varela+Round" rel="stylesheet">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link rel="shortcut icon" href="http://www.littlepig.cc/wp-content/themes/littlepig/images/favicon.ico?var=xdv53">
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css" />
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
        <link rel="stylesheet" href="css/reports-customstyle.css">
    </head>  
    <body>
        <header class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
            <a class="navbar-brand" href="<%=request.getContextPath()%>/DashboardController?action=dashboard">
                <img src="images/logotop.png" width="100" height="30" class="d-inline-block align-top" alt="lpc logo">
            </a>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="mr-auto">
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown open">
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
                            <a class="dropdown-item" href="#">Account </a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="logout.jsp">Sign Out</a>
                        </div>
                    </li>
                </ul> 
            </div>
        </header>
        <main role="main" class="container" style="padding-top: 5%; width: 60%;">
            <div class="jumbotron">
		<div style="padding-bottom: 3%">
			<div class="text-center">
				<h1>Confirm Changes</h1>
			</div>
		</div>
		<%
			String company = new Caps().toUpperCaseFirstLetter(request.getParameter("company").trim());
			String address = new Caps().toUpperCaseFirstLetter(request.getParameter("address").trim());
			String regNumber = request.getParameter("regNumber").trim();
			String agredNumber = request.getParameter("agredNumber").trim();
			String repEmpName = new Caps().toUpperCaseFirstLetter(request.getParameter("repEmpName").trim());
			String repEmpSurname = new Caps().toUpperCaseFirstLetter(request.getParameter("repEmpSurname").trim());
			String projectManagerName = new Caps().toUpperCaseFirstLetter(request.getParameter("projectManagerName").trim());
			String projectManagerSurname = new Caps().toUpperCaseFirstLetter(request.getParameter("projectManagerSurname").trim());
			String projectManagerCell = request.getParameter("projectManagerCell").trim();
			String projectManagerTel = request.getParameter("projectManagerTel").trim();
			String projectManagerMail = request.getParameter("projectManagerMail").trim();
			String advisorName = new Caps().toUpperCaseFirstLetter(request.getParameter("advisorName").trim());
			String advisorSurname = new Caps().toUpperCaseFirstLetter(request.getParameter("advisorSurname").trim());
			String managerName = new Caps().toUpperCaseFirstLetter(request.getParameter("managerName").trim());
			String managerSurname = new Caps().toUpperCaseFirstLetter(request.getParameter("managerSurname").trim());
		%>
                <table class="table table-sm table-hover" style="width:100%;">
                    <tr>
                        <td>Company Name</td><td>: <strong><%=company%></strong></td>
                    </tr>
                    <tr>
                        <td>Main Address</td><td>: <strong><%=address%></strong></td>
                    </tr>
                    <tr>
                        <td>Registration Number</td><td>: <strong><%=regNumber%></strong></td>
                    </tr>
                    <tr>
                        <td>Agredidation Number</td><td>: <strong><%=agredNumber%></strong></td>
                    </tr>
                    <tr>
                        <td>Representative Employer First Name</td><td>: <strong><%=repEmpName%></strong></td>
                    </tr>
                    <tr>
                        <td>Representative Employer Last Name</td><td>: <strong><%=repEmpSurname%></strong></td>
                    </tr>
                    <tr>
                        <td>Project Manager First Name</td><td>: <strong><%=projectManagerName%></strong></td>
                    </tr>
                    <tr>
                        <td>Project Manager Cell</td><td>: <strong><%=projectManagerCell%></strong></td>
                    </tr>
                    <tr>
                        <td>Project Manager Tel</td><td>: <strong><%=projectManagerTel%></strong></td>
                    </tr>
                    <tr>
                        <td>Project Manager Email</td><td>: <strong><%=projectManagerMail%></strong></td>
                    </tr>
                    <tr>
                        <td>Project Manager Last Name</td><td>: <strong><%=projectManagerSurname%></strong></td>
                    </tr>
                    <tr>
                        <td>SETA Advisor First Name</td><td>: <strong><%=advisorName%></strong></td>
                    </tr>
                    <tr>
                        <td>SETA Advisor Last Name</td><td>: <strong><%=advisorSurname%></strong></td>
                    </tr>
                    <tr>
                        <td>Programme Manager First Name</td><td>: <strong><%=managerName%></strong></td>
                    </tr>
                    <tr>
                        <td>Programme Manager Last Name</td><td>: <strong><%=managerSurname%></strong></td>
                    </tr>
                </table>
                <form action="AddCompanyHandler" method="POST">
                <input name="company" type="hidden" value="<%=company%>">
                <input name="address" type="hidden" value="<%=address%>">
                <input name="regNumber" type="hidden" value="<%=regNumber%>">
                <input name="agredNumber" type="hidden" value="<%=agredNumber%>">
                <input name="repEmpName" type="hidden" value="<%=repEmpName%>">
                <input name="repEmpSurname" type="hidden" value="<%=repEmpSurname%>">
                <input name="projectManagerName" type="hidden" value="<%=projectManagerName%>">
                <input name="projectManagerSurname" type="hidden" value="<%=projectManagerSurname%>">
                <input name="projectManagerCell" type="hidden" value="<%=projectManagerCell%>">
                <input name="projectManagerTel" type="hidden" value="<%=projectManagerTel%>">
                <input name="projectManagerMail" type="hidden" value="<%=projectManagerMail%>">
                <input name="advisorName" type="hidden" value="<%=advisorName%>">
                <input name="advisorSurname" type="hidden" value="<%=advisorSurname%>">
                <input name="managerName" type="hidden" value="<%=managerName%>">
                <input name="managerSurname" type="hidden" value="<%=managerSurname%>">
                   <div class="text-center">
                        <button class="btn btn-secondary" onclick="window.history.go(-1);"><i class="fa fa-arrow-left"></i> back</button>
                        <button class="btn btn-md btn-outline-success" type="submit" onclick="return confirm('Are you sure you want to add this company? Once done the action cannot be undone!')"><i class="fa fa-plus"></i> add company</button>
                    </div>
                </form>
            </div>
        </main>
    </body>
</html>