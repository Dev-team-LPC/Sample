package cc.littlepig.servlets;

import java.io.*;
import java.sql.*;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import cc.littlepig.classes.GlobalConstants;
import cc.littlepig.databases.Database;

/**
 * Servlet implementation class AddBulkLearnersUploadHandler
 */
@WebServlet("/AddBulkLearnersUploadHandler")
public class AddBulkLearnersUploadHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddBulkLearnersUploadHandler() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (ServletFileUpload.isMultipartContent(request)) {

            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setSizeThreshold(GlobalConstants.MEMORY_THRESHOLD);
            factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setFileSizeMax(GlobalConstants.MAX_FILE_SIZE);
            upload.setSizeMax(GlobalConstants.MAX_REQUEST_SIZE);
            String uploadPath = GlobalConstants.ADD_LEARNERS_UPLOAD_DIRECTORY;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            try {
                List<FileItem> formItems = upload.parseRequest(request);
                if (formItems != null && formItems.size() > 0) {
                    for (FileItem item : formItems) {
                        if (!item.isFormField()) {
                            String fileName = new File(item.getName()).getName();
                            String fileType = item.getContentType();
                            String filePath = uploadPath + File.separator + fileName;
                            File storeFile = new File(filePath);
                            if (fileType.equals("text/csv") || fileType.equals("application/vnd.ms-excel")) {
                                item.write(storeFile);
                                System.out.println(filePath);
                                insertToDb(filePath, request, response);
                            } else {
                    			String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> Uploaded file is not a CSV!</div>";
                    			request.setAttribute("message", alert);
                    			getServletContext().getRequestDispatcher("/addLearner.jsp#pills-profile").forward(request, response);
                            }
                        }
                    }
                }
            } catch (Exception ex) {
    			String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> There was an error: " + ex.getMessage() + "</div>";
    			request.setAttribute("message", alert);
    			getServletContext().getRequestDispatcher("/addLearner.jsp#pills-profile").forward(request, response);
            }
        }
	}
	
    public HttpServletRequest insertToDb(String filePath, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String line;
            try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
                String[] arr = new String[1000];
                String[] id_nums = new String[1000];
                String s = "", t = "", applicantId = "";
                for (int i = 0; (line = br.readLine()) != null; i++) {
                    String[] value = line.split(",");
                    try {
                        Database db = new Database();
                        Connection con = db.getCon1();
                        Statement st = con.createStatement();
                        st.executeQuery("SELECT id FROM applicants WHERE id_number = " + value[0] + ";");
                        ResultSet rs = st.getResultSet();
                        if (rs.next()) {
                            applicantId = rs.getString("id");
                        }
                        con.close();
                    } catch (SQLException e) {
                        System.err.println(e.getMessage());
            			String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> There was an error: " + e.getMessage() + "</div>";
            			request.setAttribute("message", alert);
            			getServletContext().getRequestDispatcher("/addLearner.jsp#pills-profile").forward(request, response);
                    }
                    if (!applicantId.isEmpty()) {
                        try {
                            Database db = new Database();
                            Connection con = db.getCon1();
                            Statement st = con.createStatement();
                            st.executeUpdate("INSERT INTO intern_sla (applicant_id, sla_id, ofo_code_id, date, status_id) VALUES (" + applicantId + "," + value[1] + "," + value[2] + ",'" + value[3] + "', 1);");
                        } catch (SQLException e) {
                            arr[i] = e.getMessage();
                        }
                        if (!arr[i].isEmpty()) {
                            s += arr[i].concat(". ");
                        }
                    } else {
                        id_nums[i] = value[0];
                        t += id_nums[i].concat(", ");
                    }
                }
                if (!s.isEmpty()) {
                    System.err.println("array: " + s);
        			String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> There was an error: " + s + "</div>";
        			request.setAttribute("message", alert);
        			getServletContext().getRequestDispatcher("/addLearner.jsp#pills-profile").forward(request, response);
                } else if (!t.isEmpty()) {
                    System.err.println("The details of the learner(s) with ID number, " + t + " could not be found. Please make sure the learner is registered on the Apply-once system.");
        			String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> The details of the learner(s) with ID number, " + t + " could not be found. Please make sure the learner is registered on the Apply-once system.</div>";
        			request.setAttribute("message", alert);
        			getServletContext().getRequestDispatcher("/addLearner.jsp#pills-profile").forward(request, response);
                } else {
					String alert = "<div class='alert alert-success alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Learners were successfully added!</b></div>";
					request.setAttribute("message", alert);
					getServletContext().getRequestDispatcher("/addLearner.jsp#pills-profile").forward(request, response);
                }
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
			String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> There was an error: " + e.getMessage() + "</div>";
			request.setAttribute("message", alert);
			getServletContext().getRequestDispatcher("/addLearner.jsp#pills-profile").forward(request, response);
        }
        return request;
    }

}
