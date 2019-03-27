package cc.littlepig.servlets;

import java.io.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 * Servlet implementation class ViewReport
 */
@WebServlet("/view-generated-report")
public class ViewReport extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ViewReport() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// set response headers
		response.setHeader("Expires", "0");
		response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
		response.setHeader("Pragma", "public");
		response.setContentType("application/pdf");

		try (InputStream in = new FileInputStream(request.getParameter("file"))) {
			OutputStream out = response.getOutputStream();

			// Copy the bits from instream to outstream
			byte[] buf = new byte[4096];
			int len;
			while ((len = in.read(buf)) > 0) {
				out.write(buf, 0, len);
			}
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
