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
        String experience = request.getParameter("experience").trim().replace("'", "\'");
        String feedback = request.getParameter("feedback").trim().replace("'", "\'");
        String highlights = request.getParameter("highlights").trim().replace("'", "\'");
        String challenges = request.getParameter("challenges").trim().replace("'", "\'");

        int isEmpty = 1;
        try {
            Database DB = new Database();
            Connection con = DB.getCon1();
            Statement st = con.createStatement();
            st.executeQuery("SELECT IF(SUM(ISNULL(learner_experience)) >= 1 OR ISNULL(SUM(ISNULL(learner_experience))) >= 1, 1, 0) learner_experience FROM sla_emails WHERE applicant_id = "+applicant_id+" AND TIMESTAMPDIFF(DAY, created_at, NOW()) < 6;");
            ResultSet rs = st.getResultSet();
            if (rs.next()) {
                isEmpty = rs.getInt("learner_experience");
            }
            con.close();
        } catch (SQLException e) {
            request.setAttribute("message", "<script type=\"text/javascript\">"
                    + "alert('There was an error: " + e.getMessage() + "');"
                    + "location.replace(\"http://www.littlepig.cc\");</script>");
            getServletContext().getRequestDispatcher("/SiteController?action=login").forward(request, response);
        }
        if (isEmpty == 1) {
            try {
            	Database DB1 = new Database();
                Connection con1 = DB1.getCon1();
                Statement st1 = con1.createStatement();
                st1.executeUpdate("UPDATE sla_emails SET form_date = NOW(), learner_experience = \""+experience+"\", learner_feedback = \""+feedback+"\", learner_highlights = \""+highlights+"\", learner_challenges = \""+challenges+"\" WHERE applicant_id = "+applicant_id+" AND TIMESTAMPDIFF(DAY, created_at, NOW()) < 6;");
                con1.close();
                request.setAttribute("message", "<script type=\"text/javascript\">"
                        + "alert('Form submitted successfully. Thank you for your time!');"
                        + "location.replace(\"http://www.littlepig.cc\");</script>");
                getServletContext().getRequestDispatcher("/SiteController?action=login").forward(request, response);
            } catch (SQLException e) {
                request.setAttribute("message", "<script type=\"text/javascript\">"
                        + "alert('There was an error: " + e.getMessage() + "');"
                        + "location.replace(\"http://www.littlepig.cc\");</script>");
                getServletContext().getRequestDispatcher("/SiteController?action=login").forward(request, response);
            }
        } else {
            request.setAttribute("message", "<script type=\"text/javascript\">"
                    + "alert('Form already submitted!');"
                    + "location.replace(\"http://www.littlepig.cc\");</script>");
            getServletContext().getRequestDispatcher("/SiteController?action=login").forward(request, response);

        }
	}

}
