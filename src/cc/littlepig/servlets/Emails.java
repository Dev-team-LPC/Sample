package cc.littlepig.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Emails
 */
@WebServlet("/Emails")
public class Emails extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Emails() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		switch (action) {
		case "email-form":
			request.getRequestDispatcher("emailForm.jsp").forward(request, response);
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
		case "add-email-list":
			request.getRequestDispatcher("email.jsp").forward(request, response);
			break;
		case "send-email":
			request.getRequestDispatcher("SendEmail").forward(request, response);
			break;
		case "email-replies":
			request.getRequestDispatcher("emailReplies.jsp").forward(request, response);
			break;
		case "email-reply-update":
			request.getRequestDispatcher("SendEmailResponse").forward(request, response);
			break;
		case "email-form-response":
			request.getRequestDispatcher("SendEmailFormHandler").forward(request, response);
			break;
		default:	
			request.getRequestDispatcher("urlUnknown.jsp").forward(request, response);
			break;
		}
	}

}
