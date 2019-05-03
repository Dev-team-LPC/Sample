package cc.littlepig.servlets;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sendgrid.*;

import cc.littlepig.classes.Caps;
import cc.littlepig.classes.Foreword;
import cc.littlepig.classes.GlobalConstants;
import cc.littlepig.classes.SendEmailFormLink;
import cc.littlepig.databases.Database;

/**
 * Servlet implementation class SendEmail
 */
@WebServlet("/SendEmail")
public class SendEmail extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SendEmail() {
		super();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		//Declare recipient's & sender's e-mail id.
		String[] str = request.getParameterValues("emailListSelect");
		String[] recipientName = new String[str.length];
		String[] applicant_id = new String[str.length];
		String[] toEmail = new String[str.length];
		//Only take the emails address from str
		StringFinder sf = new StringFinder();
		Foreword fw = new Foreword();

		for (int j = 0; j < str.length; j++) {
			toEmail[j] = sf.getEmail(str[j]);
			recipientName[j] = sf.getName(str[j]);
			applicant_id[j] = fw.getString(str[j], ".");
		}

		String emailGroup = request.getParameter("emailGroup").trim();
		String emailHash = SendEmailFormLink.encryptedEmailHash(LocalDate.now(), emailGroup);

		for (int i = 0; i < toEmail.length; i++) {

			//unique email link
			String randStr = SendEmailFormLink.randomString(30);
			String link = GlobalConstants.EmailLink + "/Reports/Emails?action=email-form&applicant_id=" + applicant_id[i] + "&hash=" + randStr;
			String linkHash = SendEmailFormLink.encryptedLinkHash(applicant_id[i], toEmail[i], randStr);

			Email from = new Email("no-reply@littlepig.cc");
			String subject = "Site Visit Report Questionnaire";
			Email to = new Email(toEmail[i]);
			String contents = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n"
					+ "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n"
					+ "<head>\n"
					+ "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/>\n"
					+ "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"/>\n"
					+ "</head>\n"
					+ "<body style=\"font-size:15px;\" bgcolor=\"#D3D3D3\">\n"
					+ "<table bgcolor=\"#2E2E2E\" style=\"text-align:center;color:#46b2b3;\" align=\"center\" border=\"0\" cellpadding=\"4\" cellspacing=\"0\"  width=\"600\">\n"
					+ "<tr>\n"
					+ "<td>\n"
					+ "<img style=\"font-size:20px;text-align:center;color:#46b2b3;\" src=\"http://www.littlepig.cc/wp-content/themes/littlepig/images/logotop.png\" alt=\"lpc company logo\"/>\n"
					+ "</td>\n"
					+ "</tr>\n"
					+ "</table>\n"
					+ "<table bgcolor=\"#2E2E2E\" align=\"center\" border=\"1\" cellpadding=\"10\" cellspacing=\"0\" width=\"600\">\n"
					+ "<tr>\n"
					+ "<td bgcolor=\"#ffffff\" align=\"center\">\n"
					+ "<p bgcolor=\"#000\" style=\"font-size:20px;text-align:center;color:#46b2b3;\">\n"
					+ "Good Day " + new Caps().toUpperCaseFirstLetter(recipientName[i]) + "\n"
					+ "</p>\n"
					+ "<br/>\n"
					+ "You have been selected as one of the interns to be interviewed for this quarter's Site Visit Report. Please click the button below, fill and submit the form. <br/><br/>\n"
					+ "<a style=\"background-color:#46b2b3;color:white;text-align:center;border:none;padding:8px;text-decoration:none;display:inline-block;font-size:14px;border-radius:2px;\" href=\"" + link + "\"> questionnaire </a>\n"
					+ "<br/>"
					+ "<p> Alternatively click <a href=\"" + link + "\"> here </a></p>"
					+ "<br/><br/>\n"
					+ "</td>\n"
					+ "</tr>\n"
					+ "</table>\n"
					+ "<table bgcolor=\"#2E2E2E\" style=\"text-align:center;color:#46b2b3;\" align=\"center\" border=\"0\" cellpadding=\"4\" cellspacing=\"0\"  width=\"600\">\n"
					+ "<tr>\n"
					+ "<td>\n"
					+ "Little Pig Computing &amp; Consulting &copy;" + LocalDate.now().getYear() + " </b><br/>\n"
					+ "<a href=\"https://littlepig.cc\">Website</a>\n"
					+ "</td>\n"
					+ "</tr>\n"
					+ "</table>\n"
					+ "</body>\n"
					+ "</html>";
			Content content = new Content("text/html", contents);
			Mail mail = new Mail(from, subject, to, content);

			try {
				Database DB = new Database();
				Connection con = DB.getCon1();
				Statement st = con.createStatement();
				st.executeQuery("SELECT IF(SUM(ISNULL(created_at)) >= 1 OR ISNULL(SUM(ISNULL(created_at))) >= 1, 1, 0) email_date FROM sla_emails WHERE sla_id = "+emailGroup+" AND applicant_id = "+applicant_id[i]+" AND TIMESTAMPDIFF(DAY, created_at, NOW()) < 6;");
				ResultSet rs = st.getResultSet();
				int isEmpty = 0;
				if (rs.next()) {
					isEmpty = (int) rs.getInt("email_date");
				}
				if (isEmpty == 1) {
					//Send message
					SendGrid sg = new SendGrid("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");
					Request request1 = new Request();
					try {
						request1.setMethod(Method.POST);
						request1.setEndpoint("mail/send");
						request1.setBody(mail.build());
						Response response1 = sg.api(request1);
						System.out.println(response1.getStatusCode());
						System.out.println(response1.getBody());
						System.out.println(response1.getHeaders());
					} catch (IOException ex) {
						throw ex;
					}
					try {
						Database DB1 = new Database();
						Connection con1 = DB1.getCon1();
						Statement st1 = con1.createStatement();
						st1.executeUpdate("INSERT INTO sla_emails (sla_id, applicant_id, created_at, link_hash, email_hash) VALUES (" + emailGroup + "," + applicant_id[i] + ", NOW(), \"" + linkHash + "\", \""+emailHash+"\");");
						con.close();
						con1.close();
						String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>e-mail sent successfully!</b></div>";
						request.setAttribute("message", alert);
						getServletContext().getRequestDispatcher("/DashboardController?action=site-visit-reports").forward(request, response);
					} catch (SQLException e) {
						String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> There was an error: " + e.getMessage() + "!</div>";
						request.setAttribute("message", alert);
						getServletContext().getRequestDispatcher("/Emails?action=add-email-list&emailGroup="+emailGroup+"").forward(request, response);
					}
				} else {
					String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> There was an error: e-mail already sent to recipient(s)!</div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/Emails?action=add-email-list&emailGroup="+emailGroup+"").forward(request, response);
				}
				con.close();
			} catch (SQLException e) {
				String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> There was an error: " + e.getMessage() + "!</div>";
				request.setAttribute("message", alert);
				getServletContext().getRequestDispatcher("/Emails?action=add-email-list&emailGroup="+emailGroup+"").forward(request, response);
			}
		}
	}

	public class StringFinder {

		public String getEmail(String str) {
			for (int i = 0; i < str.length(); i++) {
				String letter = str.substring(i, i + 1);
				if (letter.equals("-")) {
					str = str.substring(i + 2, str.length());
				} else {
					continue;
				}
			}
			return str.trim();
		}

		public String getName(String str) {
			for (int i = 0, count = 0; i < str.length(); i++) {
				String letter = str.substring(i, i + 1);
				if (letter.equals(" ")) {
					count++;
					if (count == 1) {
						str = str.substring(i + 1, str.length());
					}
				} else {
					continue;
				}
			}
			Foreword fw = new Foreword();
			str = fw.getString(str, " ");
			return str.trim();
		}
	}
}

