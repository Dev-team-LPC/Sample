package cc.littlepig.servlets;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.itextpdf.layout.element.Cell;

import cc.littlepig.classes.Foreword;
import cc.littlepig.classes.GlobalConstants;
import cc.littlepig.databases.Database;

/**
 * Servlet implementation class AddCompanyHandler
 */
@WebServlet("/AddCompanyHandler")
public class AddCompanyHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddCompanyHandler() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String company = request.getParameter("company").trim();
		String address = request.getParameter("address").trim();
		String regNumber = request.getParameter("regNumber").trim();
		String agredNumber = request.getParameter("agredNumber").trim();
		String repEmpName = request.getParameter("repEmpName").trim();
		String repEmpSurname = request.getParameter("repEmpSurname").trim();
		String projectManagerName = request.getParameter("projectManagerName").trim();
		String projectManagerSurname = request.getParameter("projectManagerSurname").trim();
		String projectManagerCell = request.getParameter("projectManagerCell").trim();
		String projectManagerTel = request.getParameter("projectManagerTel").trim();
		String projectManagerMail = request.getParameter("projectManagerMail").trim();		
		String advisorName = request.getParameter("advisorName").trim();
		String advisorSurname = request.getParameter("advisorSurname").trim();
		String managerName = request.getParameter("managerName").trim();
		String managerSurname = request.getParameter("managerSurname").trim();
		String logo = GlobalConstants.COMPANY_LOGO + File.separator + "little_pig_logo_white.jpg";
		
        try {
        	Database DB = new Database();
            Connection con = DB.getCon1();
            Statement st = con.createStatement();
            st.executeQuery("SELECT * FROM sla_company_details;");
            ResultSet rs = st.getResultSet();
            int count = 0;
            while (rs.next()) {
                if (company.equalsIgnoreCase((String) rs.getString("company_name"))) {
                    count++;
                }
            }
            if (count == 0) {
                try {
                	Database DB1 = new Database();
                    Connection con1 = DB1.getCon1();
                    Statement st1 = con1.createStatement();
					con1.setAutoCommit(false);
					st1.addBatch("BEGIN;");
                    st1.addBatch("INSERT INTO sla_project_manager (name, surname, cellphone, telephone, email) VALUES (\"" + projectManagerName + "\",\""+projectManagerSurname+"\",\""+projectManagerCell+"\", \""+projectManagerTel+"\",\""+projectManagerMail+"\");");
                    st1.addBatch("INSERT INTO sla_company_details (company_name, address, registration_number, agredidation_number, project_manager_id, logo, representative_employer_name, representative_employer_surname, seta_advisor_name, seta_advisor_surname, programme_manager_name, programme_manager_surname) "
                            + "VALUES (\"" + company + "\",\"" + address+ "\", \"" + regNumber + "\", \"" + agredNumber + "\", LAST_INSERT_ID(), \"" + logo + "\", \"" + repEmpName + "\",\"" + repEmpSurname + "\",\"" + advisorName + "\",\"" + advisorSurname + "\",\"" + managerName + "\",\"" + managerSurname + "\");");
					st1.addBatch("COMMIT");
					st1.executeBatch();
					con1.commit();
                    con.close();
                    con1.close();
                } catch (SQLException e) {
            		String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> There was an error: " + e.getMessage() + "</div>";
            		request.setAttribute("message", alert);
            		getServletContext().getRequestDispatcher("/addProgramme.jsp").forward(request, response);
                }
            } else {
        		String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> The company name " + company + " already exist!</div>";
        		request.setAttribute("message", alert);
        		getServletContext().getRequestDispatcher("/addProgramme.jsp").forward(request, response);
            }
        } catch (SQLException e) {
    		String alert = "<div class='alert alert-warning alert-dismissable'> <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> <b>Warning!</b> There was an error: " + e.getMessage() + "</div>";
    		request.setAttribute("message", alert);
    		getServletContext().getRequestDispatcher("/addProgramme.jsp").forward(request, response);
        }
	}

}
