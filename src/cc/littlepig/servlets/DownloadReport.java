package cc.littlepig.servlets;

import java.io.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 * Servlet implementation class DownloadReport
 */
@WebServlet("/Download")
public class DownloadReport extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DownloadReport() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String filename = request.getParameter("file");
        response.setContentType("text/plain");
        response.setHeader("Content-disposition", "attachment; filename=" + filename.substring(filename.lastIndexOf(File.separator) + 1));

        File my_file = new File(request.getParameter("file"));
        OutputStream out = response.getOutputStream();
        try (FileInputStream in = new FileInputStream(my_file)) {
            byte[] buffer = new byte[4096];
            int length;
            while ((length = in.read(buffer)) > 0) {
                out.write(buffer, 0, length);
            }
        }
        out.flush();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
