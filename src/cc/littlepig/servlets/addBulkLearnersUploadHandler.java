package cc.littlepig.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.List;
import java.util.logging.*;
import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import cc.littlepig.classes.GlobalConstants;
import cc.littlepig.databases.Database;

/**
 *
 * @author cyprian
 */
@WebServlet(name = "addBulkLearnersUploadHandler", urlPatterns = {"/addBulkLearnersUploadHandler"})
public class addBulkLearnersUploadHandler extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    public static final String UPLOAD_DIRECTORY = "csv";
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        response.setContentType("text/html;charset=UTF-8");
        if (ServletFileUpload.isMultipartContent(request)) {

            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setSizeThreshold(GlobalConstants.MEMORY_THRESHOLD);
            factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setFileSizeMax(GlobalConstants.MAX_FILE_SIZE);
            upload.setSizeMax(GlobalConstants.MAX_REQUEST_SIZE);
            String uploadPath = "/home/cyprian/eclipse-workspace/Reports/Files/" + UPLOAD_DIRECTORY;
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
                                insertToDb(filePath, request);
                            } else {
                                request.setAttribute("message", "<script type=\"text/javascript\">"
                                        + "alert('Uploaded file is not a CSV!');"
                                        + "location='addLearner.jsp#pills-profile';</script>");
                            }
                        }
                    }
                }
            } catch (FileUploadException ex) {
                request.setAttribute("message", "<script type=\"text/javascript\">"
                        + "alert('There was an error: " + ex.getMessage() + "');"
                        + "location='addLearner.jsp#pills-profile';</script>");
            }
            getServletContext().getRequestDispatcher("/addLearner.jsp").forward(request, response);
        }
    }

    public HttpServletRequest insertToDb(String filePath, HttpServletRequest request) {
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
                        request.setAttribute("message", "<script type=\"text/javascript\">"
                                + "alert('There was an error: " + e.getMessage() + "');"
                                + "location='addLearner.jsp#pills-profile';</script>");
                    }
                    if (!applicantId.isEmpty()) {
                        try {
                            Database db = new Database();
                            Connection con = db.getCon1();
                            Statement st = con.createStatement();
                            st.executeUpdate("INSERT INTO intern_sla (applicant_id, sla_id, ofo_code_id, date, status_id) VALUES (" + applicantId + "," + value[1] + "," + value[2] + ",'" + value[3] + "', 1);");
                            request.setAttribute("message", "<script type=\"text/javascript\">"
                                    + "alert('Learners were successfully added!');"
                                    + "location='addLearner.jsp#pills-profile';</script>");

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
                    request.setAttribute("message", "<script type=\"text/javascript\">"
                            + "alert(\"There was an error: " + s + " Please fix these issues and try again.\");"
                            + "location='addLearner.jsp#pills-profile';</script>");
                } else if (!t.isEmpty()) {
                    System.err.println("ID Numbers: " + t);
                    request.setAttribute("message", "<script type=\"text/javascript\">"
                            + "alert(\"The details of the learner(s) with ID number, " + t + " could not be found. Please make sure the learner is registered to the Apply-once system.\");"
                            + "location='addLearner.jsp#pills-profile';</script>");
                }
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
            request.setAttribute("message", "<script type=\"text/javascript\">"
                    + "alert('There was an error: " + e.getMessage() + "');"
                    + "location='addLearner.jsp#pills-profile';</script>");
        }
        return request;
    }

// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(addBulkLearnersUploadHandler.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(addBulkLearnersUploadHandler.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
