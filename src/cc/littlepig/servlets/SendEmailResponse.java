package cc.littlepig.servlets;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cc.littlepig.databases.Database;

/**
 * Servlet implementation class SendEmailResponse
 */
@WebServlet("/SendEmailResponse")
public class SendEmailResponse extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SendEmailResponse() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sla_id = request.getParameter("slaId");
        String findings = request.getParameter("findings");
        String exposure = request.getParameter("exposure");

        try {
            Database DB1 = new Database();
            Connection con1 = DB1.getCon1();
            Statement st1 = con1.createStatement();
            st1.executeUpdate("UPDATE sla_emails SET findings =\"" + findings + "\", exposure =\" " + exposure + "\" WHERE sla_id = " + sla_id + " AND TIMESTAMPDIFF(DAY, created_at, NOW()) < 6;");
            con1.close();
            String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Comments submitted successfully!</b></div>";
			request.setAttribute("message", alert);
			getServletContext().getRequestDispatcher("/DashboardController?action=site-visit-reports").forward(request, response);
        } catch (SQLException e) {
        	String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> There was an error: " + e.getMessage() + "!</div>";
			request.setAttribute("message", alert);
			getServletContext().getRequestDispatcher("/Emails?action=email-reply-update&replyGroup="+sla_id+"").forward(request, response);
        }
    }
}
