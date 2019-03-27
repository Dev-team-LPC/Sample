package cc.littlepig.servlets;

import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import cc.littlepig.databases.Database;

/**
 *
 * @author cyprian
 */
@WebServlet(name = "AddProgrammeCompanyHandler", urlPatterns = {"/AddProgrammeCompanyHandler"})
public class AddProgrammeCompanyHandler extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String companyName = request.getParameter("companyName").trim();
            try {
                Database db = new Database();
                Connection con = db.getCon1();
                Statement st = con.createStatement();
                st.executeQuery("SELECT * FROM sla_company_details;");
                ResultSet rs = st.getResultSet();
                int count = 0;
                while (rs.next()) {
                    if (companyName.equalsIgnoreCase((String) rs.getString("company_name"))) {
                        count++;
                    }
                }
                if (count == 0) {
                    try {
                    	Database db1 = new Database();
                        Connection con1 = db1.getCon1();
                        Statement st1 = con1.createStatement();
                        st1.executeUpdate("INSERT INTO sla_company_details (company_name) VALUES (\"" + companyName + "\");");
                        con.close();
                        con.close();
                    } catch (SQLException e) {
                        System.out.println(e);
                    }
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Company name added successfully!');");
                    out.println("location='addProgramme.jsp';");
                    out.println("</script>");
                } else {
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Inserted name " + companyName + " already exists!');");
                    out.println("location='addProgramme.jsp';");
                    out.println("</script>");
                }
            } catch (SQLException e) {
                System.out.println(e);
            }
        }
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
        processRequest(request, response);
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
        processRequest(request, response);
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
