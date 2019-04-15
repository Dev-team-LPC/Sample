package cc.littlepig.servlets;

import java.io.*;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.json.JSONArray;
import org.json.JSONObject;

import cc.littlepig.classes.Caps;
import cc.littlepig.databases.Database;

/**
 * Servlet implementation class DataTableServlet
 */
@WebServlet("/DataTableServlet")
public class DataTableServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public DataTableServlet() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		processRequest(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		processRequest(request, response);
	}

	private void processRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setContentType("application/json");
		try (PrintWriter out = response.getWriter()) {
			String sla_id = request.getParameter("id");
            JSONArray jArray = new JSONArray();
            int count = 0;
            try {
                Database db = new Database();
                Connection con = db.getCon1();
                Statement st = con.createStatement();
                st.executeQuery("SELECT t1.applicant_id, Surname, First_Name, IF(applicant_gender_id = 1, \"Female\",\"Male\") gender, IF(applicant_race_id = 1, \"African\", IF (applicant_race_id = 2, \"Coloured\",IF (applicant_race_id in (3,4), \"Asian\", IF (applicant_race_id = 5, \"White\", \"Unknown\")))) race, IF (applicant_disability_id = 2, \"Yes\", \"No\") disability, sla_ofo_codes.occupations FROM intern_sla t1 INNER JOIN applicant_personal_details ON applicant_personal_details.applicant_id = t1.applicant_id INNER JOIN applicant_disability_types ON t1.applicant_id = applicant_disability_types.applicant_id INNER JOIN sla_ofo_codes ON t1.ofo_code_id = sla_ofo_codes.id WHERE t1.sla_id = " + sla_id + " AND (SELECT COUNT(t2.applicant_id) FROM intern_sla t2 WHERE t2.applicant_id = t1.applicant_id AND t2.sla_id = " + sla_id + " HAVING COUNT(t2.applicant_id) < 2) = 1;");
                ResultSet rs = st.getResultSet();
                while (rs.next()) {
                    count++;
                    String applicantId = rs.getString("t1.applicant_id").trim();
                    String name = rs.getString("First_Name").trim().toLowerCase();
                    String surname = rs.getString("Surname").trim().toLowerCase();
                    String gender = rs.getString("gender");
                    String race = rs.getString("race");
                    String disability = rs.getString("disability");
                    String occupation = rs.getString("sla_ofo_codes.occupations");
                    JSONObject obj = new JSONObject();
                    obj.put("count", count);
                    obj.put("applicantId", applicantId);
                    obj.put("name", new Caps().toUpperCaseFirstLetter(name));
                    obj.put("surname", new Caps().toUpperCaseSurname(surname));
                    obj.put("gender", gender);
                    obj.put("race", race);
                    obj.put("disability", disability);
                    obj.put("occupation", occupation);
                    jArray.put(obj);
                }
                con.close();
            } catch (SQLException e) {
                out.println(e.getMessage());
            }
            JSONObject jObj = new JSONObject();
            jObj.put("data", jArray);
            out.print(jObj);
            out.flush();
            out.close();
		}
		
	}

}
