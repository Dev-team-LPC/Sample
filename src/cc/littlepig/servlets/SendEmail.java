package cc.littlepig.servlets;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.util.Properties;

import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cc.littlepig.classes.Caps;
import cc.littlepig.classes.Foreword;
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
		// TODO Auto-generated constructor stub
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

		//username and password - configuration
		final String username = "no-reply@littlepig.cc";
		final String password = "tiny.little.pigs@lpc1";

		//Set properties and their values
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.ssl.enable", "true");
		props.put("mail.smtp.host", "mail.littlepig.cc");
		props.put("mail.smtp.port", "465");

		//Create a Session object & authenticate uid and password
		Session session1 = Session.getInstance(props, new javax.mail.Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		});

		try {
			//Create MimeMessage object & set values
			for (int i = 0; i < toEmail.length; i++) {

				//unique email link
				String randStr = SendEmailFormLink.randomString(30);
				String hash = SendEmailFormLink.encryptedHash(applicant_id[i], toEmail[i], randStr);
				String link = "http://192.168.0.61:8080/Reports/Emails?action=email-form&applicant_id=" + applicant_id[i] + "&hash=" + randStr;

				Message message = new MimeMessage(session1);
				message.setFrom(new InternetAddress(username));
				message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail[i]));
				message.setSubject("Site Visit Report Questionnaire");
				String content = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n"
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
				message.setContent(content, "text/html");

				try {
					Database DB = new Database();
					Connection con = DB.getCon1();
					Statement st = con.createStatement();
					st.executeQuery("SELECT IF(SUM(ISNULL(email_date)) >= 1 OR ISNULL(SUM(ISNULL(email_date))) >= 1, 1, 0) email_date FROM sla_email WHERE sla_id = " + emailGroup + " AND applicant_id = " + applicant_id[i] + "  AND TIMESTAMPDIFF(DAY, email_date, NOW()) < 6;");
					ResultSet rs = st.getResultSet();
					int isEmpty = 0;
					if (rs.next()) {
						isEmpty = (int) rs.getInt("email_date");
					}
					if (isEmpty == 1) {
						//Send message
						Transport.send(message);
						try {
							Database DB1 = new Database();
							Connection con1 = DB1.getCon1();
							Statement st1 = con1.createStatement();
							st1.executeUpdate("INSERT INTO sla_email (applicant_id, sla_id, email_date, email_link_hash) VALUES (" + applicant_id[i] + "," + emailGroup + ", NOW(), \"" + hash + "\");");
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
				} catch (SQLException e) {
					String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> There was an error: " + e.getMessage() + "!</div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/Emails?action=add-email-list&emailGroup="+emailGroup+"").forward(request, response);
				}
			}
		} catch (MessagingException exp) {
			throw new RuntimeException(exp);
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

