package cc.littlepig.servlets;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cc.littlepig.databases.Database;

/**
 * Servlet implementation class DashboardController
 */
@WebServlet("/DashboardController")
public class DashboardController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public DashboardController() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		switch (action) {
		case "destroy":
			request.getSession().invalidate();		
			response.sendRedirect(request.getContextPath()+"/SiteController?action=login");
			break;
		case "dashboard":
			request.getRequestDispatcher("dashboard.jsp").forward(request, response);
			break;
		case "quarterly-reports":
			request.getRequestDispatcher("quarterly.jsp").forward(request, response);
			break;
		case "site-visit-reports":
			request.getRequestDispatcher("siteVisit.jsp").forward(request, response);
			break;
		case "final-reports":
			request.getRequestDispatcher("final.jsp").forward(request, response);
			break;
		case "generate-quarterly-reports":
			request.getRequestDispatcher("createQuarterlyReport.jsp").forward(request, response);
			break;
		case "generate-final-reports":
			request.getRequestDispatcher("createFinalReport.jsp").forward(request, response);
			break;
		case "edit-quarterly-reports":
			request.getRequestDispatcher("createdQuarterlyReportEdit.jsp").forward(request, response);
			break;
		case "edit-final-reports":
			request.getRequestDispatcher("createdFinalReportEdit.jsp").forward(request, response);
			break;
		default:		
			request.getRequestDispatcher("urlUnknown.jsp").forward(request, response);
			break;
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		switch (action) {
		case "generate-quarterly-reports":
			request.getRequestDispatcher("createQuarterlyReport.jsp").forward(request, response);
			break;
		case "generate-site-visit-reports":
			request.getRequestDispatcher("createSiteVisitReport.jsp").forward(request, response);
			break;
		case "generate-final-reports":
			request.getRequestDispatcher("createFinalReport.jsp").forward(request, response);
			break;
		case "save-quarterly-report":
			saveQuarterlyReport(request, response);
			break;
		case "save-final-report":
			saveFinalReport(request, response);
			break;
		default:		
			request.getRequestDispatcher("urlUnknown.jsp").forward(request, response);
			break;
		}
	}

	private void saveFinalReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		String user_id = (String) session.getAttribute("id");
		String report_id = request.getParameter("report_id");
		String status = request.getParameter("status");
		String sla_id = request.getParameter("sla").trim();
		String date = request.getParameter("creationDate").trim();
		String months = request.getParameter("months").trim();
		String intro = request.getParameter("introduction");
		String methodology = request.getParameter("implementation");
		String methodologyDesc = request.getParameter("implementationDetails");
		String plan = request.getParameter("plan");
		String placement = request.getParameter("placement");
		String achievements = request.getParameter("achievements");

		String activity = request.getParameter("array1").replace("\"", "'");
		String outcome = request.getParameter("array2").replace("\"", "'");
		String requiredAxn = request.getParameter("array3").replace("\"", "'");
		String activityDate = request.getParameter("array4").replace("\"", "'");
		String activityDueDate = request.getParameter("array5").replace("\"", "'");
		String location = request.getParameter("array6").replace("\"", "'");

		if (report_id == null) {
			if (status == null) {
				try {
					Database DB = new Database();
					Connection con = DB.getCon1();
					Statement st = con.createStatement();
					st.executeUpdate("INSERT INTO sla_report (sla_id, user_id, created_at, creation_date, project_manager_id, company_details_id, report_status_id, report_type_id, months, introduction, methodology, methodology_details, plan, placement, placement_location, achievements, activity_date, activity_due_date, activity_name, activity_outcome, activity_action_required) VALUES ("+ sla_id+ ", "+user_id+", NOW(), '"+date+"',(SELECT project_manager_id FROM sla INNER JOIN sla_company_details ON sla.company_id = sla_company_details.id where sla.id = "+ sla_id +"),(SELECT company_id FROM sla WHERE id = "+ sla_id +"),1,3, "+months+",\""+intro+"\",\""+methodology+"\",\""+methodologyDesc+"\",\""+plan+"\",\""+placement+"\", \""+location+"\" ,\""+achievements+"\",\""+activityDate+"\",\""+activityDueDate+"\",\""+activity+"\",\""+outcome+"\",\""+requiredAxn+"\");");
					con.close();
					String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Report saved successfully!</b></div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/final.jsp").forward(request, response);
				} catch (SQLException e) {
					String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Warning!</b> Your changes could not be saved, there was an error: " + e.getMessage() + "</div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/DashboardController?action=generate-final-reports&sla="+ sla_id +"&months="+ months +"&creationDate="+ date +"").forward(request, response);
				}
			} else {
				try {
					Database DB = new Database();
					Connection con = DB.getCon1();
					Statement st = con.createStatement();
					st.executeUpdate("INSERT INTO sla_report (sla_id, user_id, created_at, creation_date, project_manager_id, company_details_id, report_status_id, report_type_id, months, introduction, methodology, methodology_details, plan, placement, placement_location, achievements, activity_date, activity_due_date, activity_name, activity_outcome, activity_action_required) VALUES ("+ sla_id+ ", "+user_id+", NOW(), '"+date+"',(SELECT project_manager_id FROM sla INNER JOIN sla_company_details ON sla.company_id = sla_company_details.id where sla.id = "+ sla_id +"),(SELECT company_id FROM sla WHERE id = "+ sla_id +"),2,3, "+months+",\""+intro+"\",\""+methodology+"\",\""+methodologyDesc+"\",\""+plan+"\",\""+placement+"\", \""+location+"\" ,\""+achievements+"\",\""+activityDate+"\",\""+activityDueDate+"\",\""+activity+"\",\""+outcome+"\",\""+requiredAxn+"\");");
					con.close();
					String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Report generated successfully!</b></div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/GenerateFinalReport?sla="+sla_id+"&months="+months+"&date="+date+"").forward(request, response);
				} catch (SQLException e) {
					String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Warning!</b> Your changes could not be saved, there was an error: " + e.getMessage() + "</div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/DashboardController?action=generate-final-reports&sla="+ sla_id +"&months="+ months +"&creationDate="+ date +"").forward(request, response);
				}
			}
		} else {
			if (status == null) {
				try {
					Database DB = new Database();
					Connection con = DB.getCon1();
					Statement st = con.createStatement();
					st.executeUpdate("UPDATE sla_report SET user_id = "+user_id+", creation_date = '"+date+"', report_status_id = 1, introduction = \""+intro+"\", methodology = \""+methodology+"\", methodology_details = \""+methodologyDesc+"\", plan = \""+plan+"\", placement = \""+placement+"\", placement_location = \""+location+"\", achievements = \""+achievements+"\", activity_date = \""+activityDate+"\", activity_due_date = \""+activityDueDate+"\", activity_name = \""+activity+"\", activity_outcome = \""+outcome+"\", activity_action_required = \""+requiredAxn+"\" WHERE id = "+report_id+";");
					con.close();
					String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Report saved successfully!</b></div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/final.jsp").forward(request, response);
				} catch (SQLException e) {
					String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Warning!</b> Report could not be created, there was an error: " + e.getMessage() + "</div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/DashboardController?action=generate-final-reports&sla="+ sla_id +"&months="+ months +"&creationDate="+ date +"").forward(request, response);
				}
			} else {
				try {
					Database DB = new Database();
					Connection con = DB.getCon1();
					Statement st = con.createStatement();
					st.executeUpdate("UPDATE sla_report SET user_id = "+user_id+", creation_date = '"+date+"', report_status_id = 2, introduction = \""+intro+"\", methodology = \""+methodology+"\", methodology_details = \""+methodologyDesc+"\", plan = \""+plan+"\", placement = \""+placement+"\", placement_location = \""+location+"\", achievements = \""+achievements+"\", activity_date = \""+activityDate+"\", activity_due_date = \""+activityDueDate+"\", activity_name = \""+activity+"\", activity_outcome = \""+outcome+"\", activity_action_required = \""+requiredAxn+"\" WHERE id = "+report_id+";");
					con.close();
					String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Report generated successfully!</b></div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/GenerateFinalReport?sla="+sla_id+"&months="+months+"&date="+date+"&report_id="+report_id+"").forward(request, response);
				} catch (SQLException e) {
					String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Warning!</b> Report could not be created, there was an error: " + e.getMessage() + "</div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/DashboardController?action=generate-final-reports&sla="+ sla_id +"&months="+ months +"&creationDate="+ date +"").forward(request, response);
				}
			}
		}
	}

	private void saveQuarterlyReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		String user_id = (String) session.getAttribute("id");
		String report_id = request.getParameter("report_id");
		String status = request.getParameter("status");
		String sla_id = request.getParameter("sla").trim();
		String date = request.getParameter("creationDate").trim();
		String months = request.getParameter("months").trim();
		String intro = request.getParameter("introduction");
		String methodology = request.getParameter("implementation");
		String methodologyDesc = request.getParameter("implementationDetails");
		String plan = request.getParameter("plan");
		String placement = request.getParameter("placement");
		String achievements = request.getParameter("achievements");

		String activity = request.getParameter("array1").replace("\"", "'");
		String outcome = request.getParameter("array2").replace("\"", "'");
		String requiredAxn = request.getParameter("array3").replace("\"", "'");
		String activityDate = request.getParameter("array4").replace("\"", "'");
		String activityDueDate = request.getParameter("array5").replace("\"", "'");

		if (report_id == null) {
			if (status == null) {
				try {
					Database DB = new Database();
					Connection con = DB.getCon1();
					Statement st = con.createStatement();
					st.executeUpdate("INSERT INTO sla_report (sla_id, user_id, created_at, creation_date, project_manager_id, company_details_id, report_status_id, report_type_id, months, introduction, methodology, methodology_details, plan, placement, achievements, activity_date, activity_due_date, activity_name, activity_outcome, activity_action_required) VALUES ("+ sla_id+ ", "+user_id+", NOW(), '"+date+"',(SELECT project_manager_id FROM sla INNER JOIN sla_company_details ON sla.company_id = sla_company_details.id where sla.id = "+ sla_id +"),(SELECT company_id FROM sla WHERE id = "+ sla_id +"),1,1, "+months+",\""+intro+"\",\""+methodology+"\",\""+methodologyDesc+"\",\""+plan+"\",\""+placement+"\",\""+achievements+"\",\""+activityDate+"\",\""+activityDueDate+"\",\""+activity+"\",\""+outcome+"\",\""+requiredAxn+"\");");
					con.close();
					String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Report saved successfully!</b></div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/quarterly.jsp").forward(request, response);
				} catch (SQLException e) {
					String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Warning!</b> Your changes could not be saved, there was an error: " + e.getMessage() + "</div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/DashboardController?action=generate-quarterly-reports&sla="+ sla_id +"&months="+ months +"&creationDate="+ date +"").forward(request, response);
				}
			} else {
				try {
					Database DB = new Database();
					Connection con = DB.getCon1();
					Statement st = con.createStatement();
					st.executeUpdate("INSERT INTO sla_report (sla_id, user_id, created_at, creation_date, project_manager_id, company_details_id, report_status_id, report_type_id, months, introduction, methodology, methodology_details, plan, placement, achievements, activity_date, activity_due_date, activity_name, activity_outcome, activity_action_required) VALUES ("+ sla_id+ ", "+user_id+", NOW(), '"+date+"',(SELECT project_manager_id FROM sla INNER JOIN sla_company_details ON sla.company_id = sla_company_details.id where sla.id = "+ sla_id +"),(SELECT company_id FROM sla WHERE id = "+ sla_id +"),2,1, "+months+",\""+intro+"\",\""+methodology+"\",\""+methodologyDesc+"\",\""+plan+"\",\""+placement+"\",\""+achievements+"\",\""+activityDate+"\",\""+activityDueDate+"\",\""+activity+"\",\""+outcome+"\",\""+requiredAxn+"\");");
					con.close();
					String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Report generated successfully!</b></div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/GenerateQuarterlyReport?sla="+sla_id+"&months="+months+"&date="+date+"").forward(request, response);
				} catch (SQLException e) {
					String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Warning!</b> Your changes could not be saved, there was an error: " + e.getMessage() + "</div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/DashboardController?action=generate-quarterly-reports&sla="+ sla_id +"&months="+ months +"&creationDate="+ date +"").forward(request, response);
				}
			}
		} else {
			if (status == null) {
				try {
					Database DB = new Database();
					Connection con = DB.getCon1();
					Statement st = con.createStatement();
					st.executeUpdate("UPDATE sla_report SET user_id = "+user_id+", creation_date = '"+date+"', report_status_id = 1, introduction = \""+intro+"\", methodology = \""+methodology+"\", methodology_details = \""+methodologyDesc+"\", plan = \""+plan+"\", placement = \""+placement+"\", achievements = \""+achievements+"\", activity_date = \""+activityDate+"\", activity_due_date = \""+activityDueDate+"\", activity_name = \""+activity+"\", activity_outcome = \""+outcome+"\", activity_action_required = \""+requiredAxn+"\" WHERE id = "+report_id+";");
					con.close();
					String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Report saved successfully!</b></div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/quarterly.jsp").forward(request, response);
				} catch (SQLException e) {
					String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Warning!</b> Report could not be created, there was an error: " + e.getMessage() + "</div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/DashboardController?action=generate-quarterly-reports&sla="+ sla_id +"&months="+ months +"&creationDate="+ date +"").forward(request, response);
				}
			} else {
				try {
					Database DB = new Database();
					Connection con = DB.getCon1();
					Statement st = con.createStatement();
					st.executeUpdate("UPDATE sla_report SET user_id = "+user_id+", creation_date = '"+date+"', report_status_id = 2, introduction = \""+intro+"\", methodology = \""+methodology+"\", methodology_details = \""+methodologyDesc+"\", plan = \""+plan+"\", placement = \""+placement+"\", achievements = \""+achievements+"\", activity_date = \""+activityDate+"\", activity_due_date = \""+activityDueDate+"\", activity_name = \""+activity+"\", activity_outcome = \""+outcome+"\", activity_action_required = \""+requiredAxn+"\" WHERE id = "+report_id+";");
					con.close();
					String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Report generated successfully!</b></div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/GenerateQuarterlyReport?sla="+sla_id+"&months="+months+"&date="+date+"&report_id="+report_id+"").forward(request, response);
				} catch (SQLException e) {
					String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Warning!</b> Report could not be created, there was an error: " + e.getMessage() + "</div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/DashboardController?action=generate-quarterly-reports&sla="+ sla_id +"&months="+ months +"&creationDate="+ date +"").forward(request, response);
				}
			}
		}
	}
}
