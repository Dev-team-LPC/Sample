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
 * Servlet implementation class SendEmailFormHandler
 */
@WebServlet("/SendEmailFormHandler")
public class SendEmailFormHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SendEmailFormHandler() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String applicant_id = request.getParameter("applicant_id");
        String experience = request.getParameter("experience");
        String feedback = request.getParameter("feedback");
        String highlights = request.getParameter("highlights");
        String challenges = request.getParameter("challenges");

        int isEmpty = 1;
        try {
            Database DB = new Database();
            Connection con = DB.getCon1();
            Statement st = con.createStatement();
            st.executeQuery("SELECT IF(SUM(ISNULL(learner_highlights)) >= 1 OR ISNULL(SUM(ISNULL(learner_highlights))) >= 1, 1, 0) learner_experience FROM sla_email WHERE applicant_id = " + applicant_id + " AND TIMESTAMPDIFF(DAY, email_date, NOW()) < 6;");
            ResultSet rs = st.getResultSet();
            if (rs.next()) {
                isEmpty = rs.getInt("learner_experience");
            }
            con.close();
        } catch (SQLException e) {
            request.setAttribute("message", "<script type=\"text/javascript\">"
                    + "alert('There was an error: " + e.getMessage() + "');"
                    + "location.replace(\"http://www.littlepig.cc\");</script>");
        }
        if (isEmpty == 1) {
            try {
            	Database DB1 = new Database();
                Connection con1 = DB1.getCon1();
                Statement st1 = con1.createStatement();
                st1.executeUpdate("UPDATE sla_email SET learner_experience =\"" + experience + "\", learner_feedback =\"" + feedback + "\", learner_highlights=\"" + highlights + "\", learner_challenges=\"" + challenges + "\" , form_date = NOW() WHERE applicant_id = " + applicant_id + " AND TIMESTAMPDIFF(DAY, email_date, NOW()) < 6;");
                con1.close();
                request.setAttribute("message", "<script type=\"text/javascript\">"
                        + "alert('Form submitted successfully. Thank you for your time!');"
                        + "location.replace(\"http://www.littlepig.cc\");</script>");
            } catch (SQLException e) {
                request.setAttribute("message", "<script type=\"text/javascript\">"
                        + "alert('There was an error: " + e.getMessage() + "');"
                        + "location.replace(\"http://www.littlepig.cc\");</script>");
            }
        } else {
            request.setAttribute("message", "<script type=\"text/javascript\">"
                    + "alert('Form already submitted!');"
                    + "location.replace(\"http://www.littlepig.cc\");</script>");

        }
        getServletContext().getRequestDispatcher("/SiteController?action=login").forward(request, response);
	}

}
