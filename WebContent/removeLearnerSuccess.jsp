<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="cc.littlepig.databases.Database"%>
<%@ page import="cc.littlepig.classes.Foreword"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Learner Removal</title>
	<link href="https://fonts.googleapis.com/css?family=Roboto|Varela+Round" rel="stylesheet">
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css" />
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
	<link rel="stylesheet" href="css/reports-customstyle.css">
</head>
<body>
<%
	String uname = (String) session.getAttribute("uname");
	if (request.getSession().getAttribute("username") == null) {
		response.sendRedirect(request.getContextPath() + "/DashboardController?action=destroy");
	}
	String applicantId = new Foreword().getString(request.getParameter("internDropdown"), " ");
	String sla = new Foreword().getString(String.valueOf(session.getAttribute("slaDropdown")), ".");
	String date = String.valueOf(session.getAttribute("resignDate"));
	session.setAttribute("internDropdown", applicantId);

	int duples = 0, applicant = 0;
	Connection con = new Database().getCon1();
	Statement st = con.createStatement();
	try {
		st.executeQuery("SELECT COUNT(*) dups FROM intern_sla WHERE sla_id = " + sla + " AND applicant_id = "
				+ applicantId + " AND status_id = 2;");
		ResultSet rs = st.getResultSet();
		if (rs.next()) {
			duples = rs.getInt("dups");
		}
	} catch (SQLException e) {
		System.out.println(e);
		String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> There was an error: " + e.getMessage() + "/div>";
		request.setAttribute("message", alert);
		getServletContext().getRequestDispatcher("/removeLearner.jsp").forward(request, response);
	}
	try {
		st.executeQuery(
				"SELECT ISNULL(SUM(ISNULL(applicant_id))) applicant FROM intern_sla WHERE applicant_id = "
						+ applicantId + " AND sla_id = " + sla + ";");
		ResultSet rs = st.getResultSet();
		if (rs.next()) {
			applicant = rs.getInt("applicant");
		}
	} catch (SQLException e) {
		System.out.println(e);
		String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> There was an error: " + e.getMessage() + "/div>";
		request.setAttribute("message", alert);
		getServletContext().getRequestDispatcher("/removeLearner.jsp").forward(request, response);
	}
	if (duples == 0 && applicant == 0) {
		try {
			st.executeUpdate(
					"INSERT INTO intern_sla (applicant_id, sla_id, ofo_code_id, date, status_id) VALUES ("
							+ applicantId + "," + sla
							+ ",(SELECT t1.ofo_code_id FROM intern_sla AS t1 WHERE applicant_id = "
							+ applicantId + " AND status_id = 1 AND sla_id = " + sla + "),'" + date + "', 2);");
			con.close();
		} catch (SQLException e) {
			System.out.println(e);
			String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> There was an error: " + e.getMessage() + "/div>";
			request.setAttribute("message", alert);
			getServletContext().getRequestDispatcher("/removeLearner.jsp").forward(request, response);
		}
		String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Learner successfully removed from the SLA programme!</b></div>";
		request.setAttribute("message", alert);
		getServletContext().getRequestDispatcher("/removeLearner.jsp").forward(request, response);
	} else if (duples == 1) {
%>
        <script>
            if (confirm("The learner has already been removed from the programme!\n\tDo you want to permanently remove the learner?")) {
                location.replace("removeLearnerPermanently.jsp");
            } else {
                location.replace("removeLearner.jsp");
            }
        </script>
        <%
        	} else if (applicant == 1) {
        		String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> Learner not found in the SLA programme!</div>";
        		request.setAttribute("message", alert);
        		getServletContext().getRequestDispatcher("/removeLearner.jsp").forward(request, response);
        	} else {
        		if (duples > 1) {
        			String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> More than one records of this action exist in the database!</div>";
        			request.setAttribute("message", alert);
        			getServletContext().getRequestDispatcher("/removeLearner.jsp").forward(request, response);
        		} else {
        			String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> An unknown error has occured...</div>";
        			request.setAttribute("message", alert);
        			getServletContext().getRequestDispatcher("/removeLearner.jsp").forward(request, response);
        		}
        	}
        %>
</body>
</html>