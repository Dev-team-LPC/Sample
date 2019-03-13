package cc.littlepig.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
		// TODO Auto-generated constructor stub
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
			request.getRequestDispatcher("siteVisit.jsp").forward(request, response);
			break;
		case "generate-final-reports":
			request.getRequestDispatcher("final.jsp").forward(request, response);
			break;
		default:		
			request.getRequestDispatcher("urlUnknown.jsp").forward(request, response);
			break;
		}
	}



}
