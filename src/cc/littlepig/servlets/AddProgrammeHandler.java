package cc.littlepig.servlets;

import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import cc.littlepig.classes.Foreword;
import cc.littlepig.databases.Database;

/**
 *
 * @author cyprian
 */
@WebServlet(name = "AddProgrammeHandler", urlPatterns = {"/AddProgrammeHandler"})
public class AddProgrammeHandler extends HttpServlet {

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
            String slaName = request.getParameter("slaName").trim();
            String programmeType = request.getParameter("programmeType").trim();
            String company = new Foreword().getString(request.getParameter("company").trim(), ".");
            String numOfLearners = request.getParameter("numOfLearners").trim();
            String startDate = request.getParameter("startDate").trim();
            String endDate = request.getParameter("endDate").trim();
            String disbursementAmount = request.getParameter("disbursementAmount").trim();
            String disbursement1 = request.getParameter("disbursement1").trim();
            String disbursement2 = request.getParameter("disbursement2").trim();
            String disbursement3 = request.getParameter("disbursement3").trim();
            String disbursement4 = request.getParameter("disbursement4").trim();
            if (disbursement4.equals("") || disbursement4.equals("0")) {
                disbursement4 = "NULL";
            }
            try {
            	Database DB = new Database();
                Connection con = DB.getCon1();
                Statement st = con.createStatement();
                st.executeQuery("SELECT * FROM sla;");
                ResultSet rs = st.getResultSet();
                int count = 0;
                while (rs.next()) {
                    if (slaName.equalsIgnoreCase((String) rs.getString("Name"))) {
                        count++;
                    }
                }
                if (count == 0) {
                    try {
                    	Database DB1 = new Database();
                        Connection con1 = DB1.getCon1();
                        Statement st1 = con1.createStatement();
                        st1.executeUpdate("INSERT INTO sla (Name, type, company_id, number_of_learners, start_date, end_date) "
                                + "VALUES (\"" + slaName + "\",\"" + programmeType + "\"," + company + "," + numOfLearners + ",\"" + startDate + "\",\"" + endDate + "\");");
                        con.close();
                        con1.close();
                    } catch (SQLException e) {
                        request.setAttribute("message", "<script type=\"text/javascript\">"
                                + "alert('There was an error: " + e.getMessage() + "');"
                                + "location='addProgramme.jsp';</script>");
                    }
                    try {
                    	Database DB1 = new Database();
                        Connection con1 = DB1.getCon1();
                        Statement st1 = con1.createStatement();
                        st1.executeQuery("SELECT * FROM sla;");
                        ResultSet rs1 = st1.getResultSet();
                        int count1 = 0;
                        int sla_id = 0;
                        while (rs1.next()) {
                            if (slaName.equalsIgnoreCase((String) rs1.getString("Name"))) {
                                sla_id = (int) rs1.getInt("id");
                                count1++;
                            }
                        }
                        if (count1 != 0 && sla_id != 0) {
                            try {
                                Database DB2 = new Database();
                                Connection con2 = DB2.getCon1();
                                Statement st2 = con2.createStatement();
                                st2.executeUpdate("INSERT INTO sla_disbursements (sla_id, amount, disbursement1, disbursement2, disbursement3, disbursement4) "
                                        + "VALUES (" + sla_id + "," + disbursementAmount + "," + disbursement1 + "," + disbursement2 + "," + disbursement3 + "," + disbursement4 + ");");
                                request.setAttribute("message", "<script type=\"text/javascript\">"
                                        + "alert('SLA programme added successfully!');"
                                        + "location='addProgramme.jsp';</script>");
                                con.close();
                            } catch (SQLException e) {
                                request.setAttribute("message", "<script type=\"text/javascript\">"
                                        + "alert('There was an error: " + e.getMessage() + "');"
                                        + "location='addProgramme.jsp';</script>");
                            }
                        } else {
                            request.setAttribute("message", "<script type=\"text/javascript\">"
                                    + "alert('The was an error retrieving the new company name's data...');"
                                    + "location='addProgramme.jsp';</script>");
                        }
                        con.close();
                    } catch (SQLException e) {
                        request.setAttribute("message", "<script type=\"text/javascript\">"
                                + "alert('There was an error: " + e.getMessage() + "');"
                                + "location='addProgramme.jsp';</script>");
                    }
                } else {
                    request.setAttribute("message", "<script type=\"text/javascript\">"
                            + "alert('The SLA name \"" + slaName + "\" already exist!');"
                            + "location='addProgramme.jsp';</script>");
                }
            } catch (SQLException e) {
                request.setAttribute("message", "<script type=\"text/javascript\">"
                        + "alert('There was an error: " + e.getMessage() + "');"
                        + "location='addProgramme.jsp';</script>");
            }
            getServletContext().getRequestDispatcher("/result.jsp").forward(request, response);
        
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
