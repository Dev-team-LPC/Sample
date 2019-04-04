package cc.littlepig.servlets;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
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
		String report_id =  request.getParameter("report_id");
		String status = request.getParameter("status");
		String sla_id = request.getParameter("sla").trim();
		String date = request.getParameter("creationDate").trim();
		String months = request.getParameter("months").trim();
		String intro = request.getParameter("introduction");
		String methodology = request.getParameter("implementation");
		String methodologyDesc = request.getParameter("implementationDetails");
		String methodologyDiagram = request.getParameter("implementationDiagram");
		String plan = request.getParameter("plan");
		String placement = request.getParameter("placement");
		String achievements = request.getParameter("achievements");

		String activity = request.getParameter("array1").replace("\"", "'");
		String outcome = request.getParameter("array2").replace("\"", "'");
		String requiredAxn = request.getParameter("array3").replace("\"", "'");
		String activityDate = request.getParameter("array4").replace("\"", "'");
		String activityDueDate = request.getParameter("array5").replace("\"", "'");
		String location = request.getParameter("array6").replace("\"", "'");

		if (status == null) {
			if (report_id == null) {						
				try {
					Database DB = new Database();
					Connection con = DB.getCon1();
					Statement st = con.createStatement();
					con.setAutoCommit(false);
					st.addBatch("BEGIN;");
					st.addBatch("INSERT INTO sla_reports (user_id, sla_id, created_at, report_date, report_status_id, report_type_id) VALUES ("+user_id+", "+sla_id+", NOW(), '"+date+"', 1, 3);");					
					st.addBatch("SET @myId := LAST_INSERT_ID();");
					st.addBatch("INSERT INTO sla_reports_final (report_id, month_limit, introduction, methodology, methodology_details, methodology_diagram, strategic_plan, work_placement, achievements) VALUES (@myId, "+months+", \""+intro+"\", \""+methodology+"\", \""+methodologyDesc+"\", \""+methodologyDiagram+"\", \""+plan+"\", \""+placement+"\", \""+achievements+"\");");
					st.addBatch("INSERT INTO sla_reports_learner_placement (final_report_id, placement) VALUES (LAST_INSERT_ID(), \""+location+"\");");
					st.addBatch("INSERT INTO sla_reports_learner_tasks (report_id, task_name, task_outcome, task_action_required, task_date, task_due_date) VALUES (@myId, \""+activity+"\", \""+outcome+"\", \""+requiredAxn+"\", \""+activityDate+"\", \""+activityDueDate+"\");");
					st.executeBatch();
					con.commit();
					con.close();
					String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Report saved successfully!</b></div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/final.jsp").forward(request, response);
				} catch (SQLException e) {
					String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> Your changes could not be saved, there was an error: " + e.getMessage() + "</div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/DashboardController?action=generate-final-reports&sla="+ sla_id +"&months="+ months +"&creationDate="+ date +"").forward(request, response);
				}
			} else {
				try {
					Database DB = new Database();
					Connection con = DB.getCon1();
					Statement st = con.createStatement();
					con.setAutoCommit(false);
					st.addBatch("BEGIN;");
					st.addBatch("UPDATE sla_reports SET user_id = "+user_id+", report_date = '"+date+"', updated_at = NOW() WHERE id = "+report_id+";");					
					st.addBatch("UPDATE sla_reports_final SET introduction = \""+intro+"\", methodology = \""+methodology+"\", methodology_details = \""+methodologyDesc+"\", methodology_diagram = \""+methodologyDiagram+"\", strategic_plan = \""+plan+"\", work_placement = \""+placement+"\", achievements = \""+achievements+"\" WHERE report_id = "+report_id+";");
					st.addBatch("UPDATE sla_reports_learner_placement SET placement = \""+location+"\" WHERE final_report_id = (SELECT id FROM sla_reports_final WHERE report_id = "+report_id+");");
					st.addBatch("UPDATE sla_reports_learner_tasks SET task_name = \""+activity+"\", task_outcome = \""+outcome+"\", task_action_required = \""+requiredAxn+"\", task_date = \""+activityDate+"\", task_due_date = \""+activityDueDate+"\" WHERE report_id = "+report_id+";");
					st.executeBatch();
					con.commit();
					con.close();
					String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Report updated successfully!</b></div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/final.jsp").forward(request, response);
				} catch (SQLException e) {
					String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> Your changes could not be saved, there was an error: " + e.getMessage() + "</div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/DashboardController?action=edit-final-reports&sla="+ sla_id +"&months="+ months +"&creationDate="+ date +"").forward(request, response);
				}
			}
		} else {
			try {
				Database DB = new Database();
				Connection con = DB.getCon1();
				Statement st = con.createStatement();
				con.setAutoCommit(false);
				st.addBatch("BEGIN;");
				st.addBatch("INSERT INTO sla_reports (user_id, sla_id, created_at, report_date, report_status_id, report_type_id) VALUES ("+user_id+", "+sla_id+", NOW(), '"+date+"', 2, 3);");					
				st.addBatch("SET @myId := LAST_INSERT_ID();");
				st.addBatch("INSERT INTO sla_reports_final (report_id, month_limit, introduction, methodology, methodology_details, methodology_diagram, strategic_plan, work_placement, achievements) VALUES (@myId, "+months+", \""+intro+"\", \""+methodology+"\", \""+methodologyDesc+"\", \""+methodologyDiagram+"\", \""+plan+"\", \""+placement+"\", \""+achievements+"\");");
				st.addBatch("INSERT INTO sla_reports_learner_placement (final_report_id, placement) VALUES (LAST_INSERT_ID(), \""+location+"\");");
				st.addBatch("INSERT INTO sla_reports_learner_tasks (report_id, task_name, task_outcome, task_action_required, task_date, task_due_date) VALUES (@myId, \""+activity+"\", \""+outcome+"\", \""+requiredAxn+"\", \""+activityDate+"\", \""+activityDueDate+"\");");
				st.executeBatch();
				con.commit();
				con.close();
				String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Report generated successfully!</b></div>";
				request.setAttribute("message", alert);
				getServletContext().getRequestDispatcher("/final.jsp").forward(request, response);
			} catch (SQLException e) {
				String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> Your changes could not be saved, there was an error: " + e.getMessage() + "</div>";
				request.setAttribute("message", alert);
				getServletContext().getRequestDispatcher("/DashboardController?action=generate-final-reports&sla="+ sla_id +"&months="+ months +"&creationDate="+ date +"").forward(request, response);
			}
		}
	}

	private void saveQuarterlyReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		String user_id = (String) session.getAttribute("id");
		String report_id =  request.getParameter("report_id");
		String status = request.getParameter("status");
		String sla_id = request.getParameter("sla").trim();
		String date = request.getParameter("creationDate").trim();
		String months = request.getParameter("months").trim();
		String intro = request.getParameter("introduction");
		String methodology = request.getParameter("implementation");
		String methodologyDesc = request.getParameter("implementationDetails");
		String methodologyDiagram = request.getParameter("implementationDiagram");
		String plan = request.getParameter("plan");
		String placement = request.getParameter("placement");
		String achievements = request.getParameter("achievements");

		String activity = request.getParameter("array1").replace("\"", "'");
		String outcome = request.getParameter("array2").replace("\"", "'");
		String requiredAxn = request.getParameter("array3").replace("\"", "'");
		String activityDate = request.getParameter("array4").replace("\"", "'");
		String activityDueDate = request.getParameter("array5").replace("\"", "'");

		if (status == null) {
			if (report_id == null) {						
				try {
					Database DB = new Database();
					Connection con = DB.getCon1();
					Statement st = con.createStatement();
					con.setAutoCommit(false);
					st.addBatch("BEGIN;");
					st.addBatch("INSERT INTO sla_reports (user_id, sla_id, created_at, report_date, report_status_id, report_type_id) VALUES ("+user_id+", "+sla_id+", NOW(), '"+date+"', 1, 1);");					
					st.addBatch("SET @myId := LAST_INSERT_ID();");
					st.addBatch("INSERT INTO sla_reports_quarterly (report_id, month_limit, introduction, methodology, methodology_details, methodology_diagram, strategic_plan, work_placement, achievements) VALUES (@myId, "+months+", \""+intro+"\", \""+methodology+"\", \""+methodologyDesc+"\", \""+methodologyDiagram+"\", \""+plan+"\", \""+placement+"\", \""+achievements+"\");");
					st.addBatch("INSERT INTO sla_reports_learner_tasks (report_id, task_name, task_outcome, task_action_required, task_date, task_due_date) VALUES (@myId, \""+activity+"\", \""+outcome+"\", \""+requiredAxn+"\", \""+activityDate+"\", \""+activityDueDate+"\");");
					st.executeBatch();
					con.commit();
					con.close();
					String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Report saved successfully!</b></div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/quarterly.jsp").forward(request, response);
				} catch (SQLException e) {
					String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> Your changes could not be saved, there was an error: " + e.getMessage() + "</div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/DashboardController?action=generate-quarterly-reports&sla="+ sla_id +"&months="+ months +"&creationDate="+ date +"").forward(request, response);
				}
			} else {
				try {
					Database DB = new Database();
					Connection con = DB.getCon1();
					Statement st = con.createStatement();
					con.setAutoCommit(false);
					st.addBatch("BEGIN;");
					st.addBatch("UPDATE sla_reports SET user_id = "+user_id+", report_date = '"+date+"', updated_at = NOW() WHERE id = "+report_id+";");					
					st.addBatch("UPDATE sla_reports_quarterly SET introduction = \""+intro+"\", methodology = \""+methodology+"\", methodology_details = \""+methodologyDesc+"\", methodology_diagram = \""+methodologyDiagram+"\", strategic_plan = \""+plan+"\", work_placement = \""+placement+"\", achievements = \""+achievements+"\" WHERE report_id = "+report_id+";");
					st.addBatch("UPDATE sla_reports_learner_tasks SET task_name = \""+activity+"\", task_outcome = \""+outcome+"\", task_action_required = \""+requiredAxn+"\", task_date = \""+activityDate+"\", task_due_date = \""+activityDueDate+"\" WHERE report_id = "+report_id+";");
					st.executeBatch();
					con.commit();
					con.close();
					String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Report updated successfully!</b></div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/quarterly.jsp").forward(request, response);
				} catch (SQLException e) {
					String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> Your changes could not be saved, there was an error: " + e.getMessage() + "</div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/DashboardController?action=update-quarterly-reports&sla="+ sla_id +"&months="+ months +"&creationDate="+ date +"").forward(request, response);
				}
			}
		} else {
			try {
				Database DB = new Database();
				Connection con = DB.getCon1();
				Statement st = con.createStatement();
				con.setAutoCommit(false);
				st.addBatch("BEGIN;");
				st.addBatch("INSERT INTO sla_reports (user_id, sla_id, created_at, report_date, report_status_id, report_type_id) VALUES ("+user_id+", "+sla_id+", NOW(), '"+date+"', 2, 1);");					
				st.addBatch("SET @myId := LAST_INSERT_ID();");
				st.addBatch("INSERT INTO sla_reports_quarterly (report_id, month_limit, introduction, methodology, methodology_details, methodology_diagram, strategic_plan, work_placement, achievements) VALUES (@myId, "+months+", \""+intro+"\", \""+methodology+"\", \""+methodologyDesc+"\", \""+methodologyDiagram+"\", \""+plan+"\", \""+placement+"\", \""+achievements+"\");");
				st.addBatch("INSERT INTO sla_reports_learner_tasks (report_id, task_name, task_outcome, task_action_required, task_date, task_due_date) VALUES (@myId, \""+activity+"\", \""+outcome+"\", \""+requiredAxn+"\", \""+activityDate+"\", \""+activityDueDate+"\");");
				st.executeBatch();
				con.commit();
				con.close();
				String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Report generated successfully!</b></div>";
				request.setAttribute("message", alert);
				getServletContext().getRequestDispatcher("/quarterly.jsp").forward(request, response);
			} catch (SQLException e) {
				String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> Your changes could not be saved, there was an error: " + e.getMessage() + "</div>";
				request.setAttribute("message", alert);
				getServletContext().getRequestDispatcher("/DashboardController?action=generate-quarterly-reports&sla="+ sla_id +"&months="+ months +"&creationDate="+ date +"").forward(request, response);
			}
		}
	}
}
