package cc.littlepig.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.crypto.bcrypt.BCrypt;

import cc.littlepig.databases.Database;

/**
 * Servlet implementation class SiteController
 */
@WebServlet("/SiteController")
public class SiteController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SiteController() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		switch (action) {
		case "login":
			request.getRequestDispatcher("login.jsp").forward(request, response);
			break;
		default:
			break;
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		switch (action) {
		case "loginVerify":
			authenticate(request, response);
			break;

		default:
			break;
		}
	}

	private void authenticate(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String firstName = null;
		String lastName = null;
		String encryptedPassword = null;		
		String pw_hash = null;

		try {
			Database DB = new Database();
			Connection con = DB.getCon1();
			Statement st = con.createStatement();
			st.executeQuery("SELECT * FROM applicants "
					+ "INNER JOIN applicant_personal_details ON applicants.id = applicant_personal_details.applicant_id "
					+ "WHERE email ='" + username + "';");
			ResultSet rs = st.getResultSet();        
			if (rs.next()) {
				firstName = rs.getString("First_Name");
				lastName = rs.getString("Surname");
				encryptedPassword = (String) rs.getString("encrypted_password");
				pw_hash = BCrypt.hashpw(password, encryptedPassword);
			}
			con.close();
		} catch (Exception e) {
			System.out.println(e);
		}


		if (username.equals("siphesihlepangumso@gmail.com") || username.equals("nsilimela94@gmail.com") || username.equals("simamkele@borderict.co.za")) {
			if(encryptedPassword.equals(pw_hash)) {
			//Invalidating session if any
			request.getSession().invalidate();
			HttpSession session = request.getSession(true);
			session.setMaxInactiveInterval(18000);
			session.setAttribute("username", username);
			session.setAttribute("First_Name", firstName);
			session.setAttribute("Surname", lastName);
			String encode = response.encodeURL(request.getContextPath());
			response.sendRedirect(encode+"/DashboardController?action=dashboard");
			} else {
				String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Warning!</b> incorrect password</div>";
				request.setAttribute("message", alert);				
				request.getRequestDispatcher("login.jsp").forward(request, response);

			}
		} else {
			String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert'  aria-hidden='true'>&times;</button> <b>Warning!</b> email address unknown</div>";
			request.setAttribute("message", alert);
			request.getRequestDispatcher("login.jsp").forward(request, response);
		}
	}
}
