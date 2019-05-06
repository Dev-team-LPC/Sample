package cc.littlepig.servlets;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.sql.*;
import java.text.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.itextpdf.forms.PdfAcroForm;
import com.itextpdf.forms.fields.PdfButtonFormField;
import com.itextpdf.forms.fields.PdfFormField;
import com.itextpdf.io.font.FontConstants;
import com.itextpdf.io.image.ImageDataFactory;
import static com.itextpdf.kernel.colors.ColorConstants.GREEN;
import static com.itextpdf.kernel.colors.ColorConstants.LIGHT_GRAY;
import static com.itextpdf.kernel.colors.ColorConstants.RED;
import static com.itextpdf.kernel.colors.ColorConstants.YELLOW;
import com.itextpdf.kernel.font.*;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.geom.Rectangle;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.Border;
import com.itextpdf.layout.element.*;
import com.itextpdf.layout.property.TextAlignment;
import com.itextpdf.layout.renderer.CellRenderer;
import com.itextpdf.layout.renderer.DrawContext;

import cc.littlepig.classes.Caps;
import cc.littlepig.classes.Footer;
import cc.littlepig.classes.GlobalConstants;
import cc.littlepig.databases.Database;

/**
 * Servlet implementation class GenerateSiteVisitReport
 */
@WebServlet("/GenerateSiteVisitReport")
public class GenerateSiteVisitReport extends HttpServlet {
	private static final long serialVersionUID = 1L;
	public static String report_id, reportType, DEST, creationDate, myDate, myDateSQL, sla_id, managerQuestionnaire, mentorFeedback, recommendations, conclusion ;
	public static int visit;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public GenerateSiteVisitReport() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		report_id = request.getParameter("report_id");
		reportType = request.getParameter("report_type");
		DEST = GlobalConstants.DEST + File.separator + "site visit reports" + File.separator + "Site Visit Report ["+report_id+"].pdf";
		File file = new File(DEST);
		if (file.exists() && !file.isDirectory()) {
			response.sendRedirect("reportReview.jsp?file=" + DEST + "&report_type="+reportType+"");
		} else {
			file.getParentFile().mkdirs();
			try {
				new GenerateSiteVisitReport().createReport(DEST, request);
//				new Footer().addFooter(DEST, reportType);
			} catch (Exception e) {
				e.printStackTrace();
			}
			response.sendRedirect("reportReview.jsp?file=" + DEST + "&report_type="+reportType+"");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

	protected void createReport(String dest, HttpServletRequest request) throws Exception {
		PdfDocument pdf = new PdfDocument(new PdfWriter(DEST));
		pdf.getDocumentInfo().setTitle("Site Visit Report");
		pdf.getDocumentInfo().setAuthor("Siphesihle Pangumso");
		pdf.getDocumentInfo().setMoreInfo(pdf.getDocumentInfo().getTitle(), pdf.getDocumentInfo().getAuthor());
		pdf.setDefaultPageSize(PageSize.A4);
		try (Document document = new Document(pdf)) {
			GenerateSiteVisitReport.addAcroForm(document);
			document.close();
		}
	}

	public static PdfAcroForm addAcroForm(Document doc)
			throws MalformedURLException, SQLException, IOException, ParseException, ServletException {
		PdfFont small = PdfFontFactory.createFont(FontConstants.HELVETICA);//superscript
		PdfFont font = PdfFontFactory.createFont(FontConstants.HELVETICA);
		PdfFont bold = PdfFontFactory.createFont(FontConstants.HELVETICA_BOLD);
		PdfAcroForm form = PdfAcroForm.getAcroForm(doc.getPdfDocument(), true);

		Image gov = new Image(ImageDataFactory.create(GlobalConstants.IMAGE_GOV));
		gov.scaleAbsolute(200, 80);
		doc.add(gov);
		Image seta = new Image(ImageDataFactory.create(GlobalConstants.IMAGE_SETA));
		seta.scaleAbsolute(225, 85).setFixedPosition(410, 730);
		doc.add(seta);

		Paragraph p = new Paragraph("SITE VISIT REPORT").setTextAlignment(TextAlignment.CENTER).setFontSize(10).setFont(bold);
		doc.add(p);

		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM uuuu");
		DateTimeFormatter formatterSQL = DateTimeFormatter.ofPattern("uuuu-MM-dd");
		try {
			Database DB = new Database();
			Connection con = DB.getCon1();
			Statement st = con.createStatement();
			st.executeQuery("SELECT * FROM sla_reports_site_visit INNER JOIN sla_reports ON sla_reports.id = sla_reports_site_visit.report_id WHERE report_id = "+report_id+";");
			ResultSet rs = st.getResultSet();

			while (rs.next()) {
				sla_id = (String) rs.getString("sla_id");
				creationDate = (String) rs.getString("report_date").trim();
				visit = (int) rs.getInt("visit");
				managerQuestionnaire = (String) rs.getString("project_manager_questionnaire");
				mentorFeedback = (String) rs.getString("mentors_feedback");
				recommendations = (String) rs.getString("recommendations");
				conclusion = (String) rs.getString("conclusion");
			}
		} catch (SQLException e) {
			System.out.println(e);
		}
		myDate = formatter.format(LocalDate.parse(creationDate));
		myDateSQL = formatterSQL.format(LocalDate.parse(creationDate));

		String sla = "", company = "";
		String query = "SELECT t1.applicant_id, applicant_personal_details.Surname, First_Name, applicant_disability_types.applicant_disability_id, sla.Name, sla.type, company_name, sla_project_manager.name, sla_project_manager.surname, sla_project_manager.telephone, sla_project_manager.email, representative_employer_name, representative_employer_surname, seta_advisor_name, seta_advisor_surname,programme_manager_name, programme_manager_surname, sla.number_of_learners, DATE_FORMAT(sla.start_date,'%d %M %Y') AS start_date, DATE_FORMAT(sla.end_date,'%d %M %Y') AS end_date, TIMESTAMPDIFF(MONTH, start_date, (end_date + 1)) AS dateDiff, IF(applicant_personal_details.applicant_gender_id = 1, \"Female\",\"Male\") AS gender, Sum(IF (applicant_gender_id = 2, IF (applicant_race_id = 1, 1, 0), 0)) as AfMCount, Sum(IF (applicant_gender_id = 1, IF (applicant_race_id = 1, 1, 0), 0)) as AfFCount, Sum(IF (applicant_gender_id = 2, IF (applicant_race_id = 2, 1, 0), 0)) as CMCount, Sum(IF (applicant_gender_id = 1, IF (applicant_race_id = 2, 1, 0), 0)) as CFCount, Sum(IF (applicant_gender_id = 2, IF (applicant_race_id in (3,4), 1, 0), 0)) as AsMCount, Sum(IF (applicant_gender_id = 1, IF (applicant_race_id in (3,4), 1, 0), 0)) as AsFCount, Sum(IF (applicant_gender_id = 2, IF (applicant_race_id = 5, 1, 0), 0)) as WMCount, Sum(IF (applicant_gender_id = 1, IF (applicant_race_id = 5, 1, 0), 0)) as WFCount, Sum(IF (applicant_gender_id = 2, 1, 0)) as totMCount, Sum(IF (applicant_gender_id = 1, 1, 0)) as totFCount, Sum(IF (applicant_gender_id = 2, IF (applicant_disability_id = 2, 1, 0), 0)) as totDMCount, Sum(IF (applicant_gender_id = 1, IF (applicant_disability_id = 2, 1, 0), 0)) as totDFCount FROM intern_sla AS t1 INNER JOIN applicant_disability_types ON t1.applicant_id = applicant_disability_types.applicant_id INNER JOIN applicant_personal_details ON t1.applicant_id = applicant_personal_details.applicant_id INNER JOIN sla ON t1.sla_id =  sla.id INNER JOIN sla_company_details ON sla_company_details.id = sla.company_id INNER JOIN sla_project_manager ON sla_project_manager.id = sla_company_details.project_manager_id WHERE sla_id = "+sla_id+" AND (SELECT COUNT(t2.applicant_id) FROM intern_sla AS t2 WHERE t2.applicant_id = t1.applicant_id  AND t2.sla_id = "+sla_id+" HAVING COUNT(t2.applicant_id) < 2) = 1 GROUP BY applicant_personal_details.applicant_id, applicant_personal_details.Surname, First_Name, company_name, applicant_disability_types.applicant_disability_id, sla.Name, sla.type, sla.number_of_learners, sla.start_date, sla.end_date, applicant_personal_details.applicant_gender_id;";

		int count = 0;
		String learnrCount = "", startDate = "", endDate = "", dateDiff = "", progType = "", contactPerson = "", telephone = "", email = "", employer_name = "", advisor_name = "", manager_name = "";
		try {
			Database DB = new Database();
			Connection con = DB.getCon1();
			Statement st = con.createStatement();
			st.executeQuery(query);
			ResultSet rs = st.getResultSet();

			while (rs.next()) {
				progType = (String) rs.getString("sla.type").trim().substring(0);
				sla = (String) rs.getString("sla.Name").trim();
				learnrCount = (String) rs.getString("sla.number_of_learners");
				startDate = (String) rs.getString("start_date");
				endDate = (String) rs.getString("end_date");
				dateDiff = (String) rs.getString("dateDiff");
				company = (String) rs.getString("company_name");
				employer_name = new Caps().toUpperCaseFirstLetter((String) rs.getString("representative_employer_name")) + " " + new Caps().toUpperCaseSurname((String) rs.getString("representative_employer_surname"));
				advisor_name = new Caps().toUpperCaseFirstLetter((String) rs.getString("seta_advisor_name")) + " " + new Caps().toUpperCaseSurname((String) rs.getString("seta_advisor_surname"));
				manager_name = new Caps().toUpperCaseFirstLetter((String) rs.getString("programme_manager_name")) + " " + new Caps().toUpperCaseSurname((String) rs.getString("programme_manager_surname"));
				contactPerson = new Caps().toUpperCaseFirstLetter((String) rs.getString("sla_project_manager.name")) + " " + new Caps().toUpperCaseSurname((String) rs.getString("sla_project_manager.surname"));
				telephone = (String) rs.getString("sla_project_manager.telephone");
				email = (String) rs.getString("sla_project_manager.email");
				count++;
			}
			con.close();
		} catch (SQLException e) {
			System.out.println(e);
		}
		doc.getPdfDocument().getDocumentInfo().setSubject(company + " " + progType + " (" + sla + ")");
		Table table = new Table(5).setWidth(520).setFontSize(8);
		String[] arr = {progType.toUpperCase() + " PROGRAMME", "", "", "Date", myDate};
		for (int a = 0; a < arr.length; a++) {
			if (a == 2) {
				Cell c1 = new Cell().add(new Paragraph(arr[a]));
				table.addCell(c1.setWidth(190).setBorder(Border.NO_BORDER));
			} else if (a == 3) {
				Cell c1 = new Cell().add(new Paragraph(arr[a]));
				c1.setBackgroundColor(LIGHT_GRAY).setFont(bold);
				table.addCell(c1.setWidth(50).setTextAlignment(TextAlignment.CENTER));
			} else if (a == 4) {
				Cell c1 = new Cell().add(new Paragraph(arr[a]));
				table.addCell(c1.setFont(font));
			} else if (a == 1) {
				Cell c1 = new Cell().setFont(font);
				if (progType.equalsIgnoreCase("Internship")) {
					c1.setNextRenderer(new CheckboxCellRenderer(c1, "cb1" + a, "On"));					
				}
				c1.setNextRenderer(new CheckboxCellRenderer(c1, "cb1" + a, "Off"));					
				table.addCell(c1.setBorder(Border.NO_BORDER));
			} else {
				Cell c1 = new Cell().add(new Paragraph(arr[a]));
				table.addCell(c1.setFont(bold).setBorder(Border.NO_BORDER));
			}
		}
		doc.add(table);

		Paragraph p1 = new Paragraph("ADMINISTRATION INFORMATION").setTextAlignment(TextAlignment.CENTER).setFontSize(10).setFont(bold);
		doc.add(p1);

		//superscripts for numbering
		Paragraph first = new Paragraph().add("1").add(new Text("st").setFont(small).setTextRise(3).setFontSize(6)).add(" Site Visit");
		Paragraph second = new Paragraph().add("2").add(new Text("nd").setFont(small).setTextRise(3).setFontSize(6)).add(" Site Visit");
		Paragraph third = new Paragraph().add("3").add(new Text("rd").setFont(small).setTextRise(3).setFontSize(6)).add(" Site Visit");
		Paragraph fourth = new Paragraph().add("4").add(new Text("th").setFont(small).setTextRise(3).setFontSize(6)).add(" Site Visit");

		Table table1 = new Table(12).setWidth(520).setFontSize(9).setTextAlignment(TextAlignment.CENTER);
		Paragraph[] arr1 = {first, second, third, fourth};
		for (int a = 0; a < arr1.length; a++) {
			String value = "Off";
			if (visit == (a+1)) {
				value = "On";
			}
			if (a != 0) {
				Cell c1 = new Cell().add(arr1[a]);
				c1.setBorderRight(Border.NO_BORDER).setBorderLeft(Border.NO_BORDER);
				table1.addCell(c1);
				Cell c2 = new Cell();
				c2.setBorderRight(Border.NO_BORDER).setBorderLeft(Border.NO_BORDER);
				c2.setNextRenderer(new CheckboxCellRenderer(c2, "cb2" + a, value));
				table1.addCell(c2.setPaddingRight(20));
			} else {
				Cell c1 = new Cell().add(arr1[a]);
				c1.setBorderRight(Border.NO_BORDER);
				table1.addCell(c1);
				Cell c2 = new Cell();
				c2.setBorderRight(Border.NO_BORDER).setBorderLeft(Border.NO_BORDER);
				c2.setNextRenderer(new CheckboxCellRenderer(c2, "cb2" + a, value));
				table1.addCell(c2.setPaddingRight(20));
			}
		}

		Cell c3 = new Cell().add(new Paragraph("Final Site Visit"));
		c3.setBorderRight(Border.NO_BORDER).setBorderLeft(Border.NO_BORDER);
		table1.addCell(c3);
		Cell c4 = new Cell().setBorderRight(Border.NO_BORDER).setBorderLeft(Border.NO_BORDER);
		c4.setNextRenderer(new CheckboxCellRenderer(c4, "cb4", "Off"));
		table1.addCell(c4.setPaddingRight(20));
		Cell c5 = new Cell().add(new Paragraph("Follow-up"));
		c5.setBorderRight(Border.NO_BORDER).setBorderLeft(Border.NO_BORDER);
		table1.addCell(c5);
		Cell c6 = new Cell().setBorderLeft(Border.NO_BORDER);
		c6.setNextRenderer(new CheckboxCellRenderer(c6, "cb5", "Off"));
		table1.addCell(c6.setPaddingRight(20));
		doc.add(table1);

		Table table2 = new Table(2).setWidth(520).setFontSize(8).setMarginTop(5).setFixedLayout();
		String[] arr2 = {"Name of Lead Employer", company, "Contact Person", contactPerson, "Telephone", telephone, "Email Address",
				email, "Name of Hosting Employer and Number of Learners Hosted", company + " – " + learnrCount + " Learners",
				"Services Level Agreement Number", sla, "Learning Programme Intervention", progType + " Programme"};

		for (int ok = 0; ok < arr2.length; ok++) {
			if (ok % 2 == 0) {
				Cell c7 = new Cell().add(new Paragraph(arr2[ok]));
				c7.setBackgroundColor(LIGHT_GRAY).setFont(bold);
				table2.addCell(c7);
			} else {
				table2.addCell(new Paragraph(arr2[ok]));
			}
		}
		doc.add(table2);

		Table table3 = new Table(2).setWidth(520).setFontSize(8).setMarginTop(5).setFixedLayout();
		Cell c8 = new Cell().add(new Paragraph("Select Province  & Provide Programme Geographic Location:"));
		c8.setBackgroundColor(LIGHT_GRAY).setFont(bold);
		table3.addCell(c8);
		Cell c9 = new Cell().add(new Paragraph("Eastern Cape"));
		table3.addCell(c9);
		doc.add(table3);

		//Programme Duration and Status
		Paragraph red = new Paragraph("RED\n").setFontColor(RED).setFont(bold);
		Paragraph yellow = new Paragraph("YELLOW\n").setFontColor(YELLOW).setFont(bold);
		Paragraph green = new Paragraph("GREEN").setFontColor(GREEN).setFont(bold);
		String[] arr3 = {"Duration of Programme", dateDiff + " months", "Start Date",
				startDate, "Termination Date", endDate, "Current Programme\n" + "Status:", "", ""};
		Table table4 = new Table(6).setWidth(520).setFontSize(8).setMarginTop(5);
		for (int a = 0; a < arr3.length; a++) {
			if (a == 8) {
				Cell c10 = new Cell(1, 4).add(new Paragraph(arr3[a]));
				table4.addCell(c10);
			} else if (a == 7) {
				Cell c10 = new Cell();
				c10.add(red).add(yellow).add(green);
				table4.addCell(c10);
			} else if (a % 2 == 0) {
				Cell c10 = new Cell().add(new Paragraph(arr3[a]));
				c10.setBackgroundColor(LIGHT_GRAY).setFont(bold);
				table4.addCell(c10);
			} else {
				Cell c10 = new Cell().add(new Paragraph(arr3[a]));
				table4.addCell(c10);
			}
		}
		doc.add(table4);

		//Checkboxes - Programme Duration and Status
		for (int b = 443; b < 475; b += 12) {
			String value = "On";
			if (b > 450) {
				value = "Off";
			}
			PdfButtonFormField checkbox = PdfFormField.createCheckBox(doc.getPdfDocument(),
					new Rectangle(246, b, 10, 10), "cb6" + b, value, PdfFormField.TYPE_CROSS);
			form.addField(checkbox.setBorderWidth(1).setVisibility(PdfFormField.VISIBLE));
		}

		int afMCount = 0, afFCount = 0, cMCount = 0, cFCount = 0, asMCount = 0, asFCount = 0, wMCount = 0, wFCount = 0,
				afMDOCount = 0, afFDOCount = 0, cMDOCount = 0, cFDOCount = 0, asMDOCount = 0, asFDOCount = 0, wMDOCount = 0, wFDOCount = 0,
				afMRepCount = 0, afFRepCount = 0, cMRepCount = 0, cFRepCount = 0, asMRepCount = 0, asFRepCount = 0, wMRepCount = 0, wFRepCount = 0,
				disabledMale = 0, disabledFemale = 0, disabledMaleDO = 0, disabledFemaleDO = 0, disabledMaleRep = 0, disabledFemaleRep = 0;
		//learners in progress
		try {
			Database DB = new Database();
			Connection con = DB.getCon1();
			Statement st = con.createStatement();
			st.executeQuery(query);
			ResultSet rs = st.getResultSet();

			while (rs.next()) {
				int afMales = rs.getInt("AfMCount");
				afMCount += afMales;
				int afFemales = rs.getInt("AfFCount");
				afFCount += afFemales;
				int cMales = rs.getInt("CMCount");
				cMCount += cMales;
				int cFemales = rs.getInt("CFCount");
				cFCount += cFemales;
				int asMales = rs.getInt("AsMCount");
				asMCount += asMales;
				int asFemales = rs.getInt("AsFCount");
				asFCount += asFemales;
				int wMales = rs.getInt("WMCount");
				wMCount += wMales;
				int wFemales = rs.getInt("WFCount");
				wFCount += wFemales;
				int disMales = rs.getInt("totDMCount");
				disabledMale += disMales;
				int disFemales = rs.getInt("totDFCount");
				disabledFemale += disFemales;
			}
			con.close();
		} catch (SQLException e) {
			System.out.println(e);
		}

		//learners dropped out
		try {
			Database DB = new Database();
			Connection con = DB.getCon1();
			Statement st = con.createStatement();
			st.executeQuery("SELECT applicant_personal_details.applicant_id, applicant_personal_details.Surname, "
					+ "applicant_personal_details.First_Name, applicant_disability_types.applicant_disability_id, "
					+ "TIMESTAMPDIFF(MONTH, intern_sla.date, '" + myDateSQL + "') AS dateDiff, "
					+ "Sum(IF (applicant_gender_id = 2, IF (applicant_race_id = 1, 1, 0), 0)) as AfMCount, "
					+ "Sum(IF (applicant_gender_id = 1, IF (applicant_race_id = 1, 1, 0), 0)) as AfFCount , "
					+ "Sum(IF (applicant_gender_id = 2, IF (applicant_race_id = 2, 1, 0), 0)) as CMCount , "
					+ "Sum(IF (applicant_gender_id = 1, IF (applicant_race_id = 2, 1, 0), 0)) as CFCount , "
					+ "Sum(IF (applicant_gender_id = 2, IF (applicant_race_id in (3,4), 1, 0), 0)) as AsMCount, "
					+ "Sum(IF (applicant_gender_id = 1, IF (applicant_race_id in (3,4), 1, 0), 0)) as AsFCount , "
					+ "Sum(IF (applicant_gender_id = 2, IF (applicant_race_id = 5, 1, 0), 0)) as WMCount , "
					+ "Sum(IF (applicant_gender_id = 1, IF (applicant_race_id = 5, 1, 0), 0)) as WFCount , "
					+ "Sum(IF (applicant_gender_id = 2, 1, 0)) as totMCount, "
					+ "Sum(IF (applicant_gender_id = 1, 1, 0)) as totFCount, "
					+ "Sum(IF (applicant_gender_id = 2, IF (applicant_disability_id = 2, 1, 0), 0)) as totDMCount, "
					+ "Sum(IF (applicant_gender_id = 1, IF (applicant_disability_id = 2, 1, 0), 0)) as totDFCount "
					+ "FROM applicant_personal_details "
					+ "INNER JOIN applicant_disability_types ON applicant_personal_details.applicant_id = applicant_disability_types.applicant_id "
					+ "INNER JOIN intern_sla ON intern_sla.applicant_id = applicant_personal_details.applicant_id "
					+ "INNER JOIN sla ON intern_sla.sla_id =  sla.id "
					+ "WHERE intern_sla.status_id = 2 AND TIMESTAMPDIFF(MONTH, intern_sla.date, '" + myDateSQL + "') <= 3 AND applicant_personal_details.applicant_id "
					+ "IN (SELECT intern_sla.applicant_id FROM intern_sla WHERE sla_id = " + sla_id + ") "
					+ "GROUP BY applicant_personal_details.applicant_id, applicant_personal_details.Surname, applicant_personal_details.First_Name, "
					+ "applicant_disability_types.applicant_disability_id, intern_sla.date;");
			ResultSet rs = st.getResultSet();

			while (rs.next()) {
				int afMales = rs.getInt("AfMCount");
				afMDOCount += afMales;
				int afFemales = rs.getInt("AfFCount");
				afFDOCount += afFemales;
				int cMales = rs.getInt("CMCount");
				cMDOCount += cMales;
				int cFemales = rs.getInt("CFCount");
				cFDOCount += cFemales;
				int asMales = rs.getInt("AsMCount");
				asMDOCount += asMales;
				int asFemales = rs.getInt("AsFCount");
				asFDOCount += asFemales;
				int wMales = rs.getInt("WMCount");
				wMDOCount += wMales;
				int wFemales = rs.getInt("WFCount");
				wFDOCount += wFemales;
				int disMales = rs.getInt("totDMCount");
				disabledMaleDO += disMales;
				int disFemales = rs.getInt("totDFCount");
				disabledFemaleDO += disFemales;
			}
			con.close();
		} catch (SQLException e) {
			System.out.println(e);
		}
		//replacement learners
		try {
			Database DB = new Database();
			Connection con = DB.getCon1();
			Statement st = con.createStatement();
			if (visit == 1) {
				st.executeQuery("SELECT applicant_personal_details.applicant_id, applicant_personal_details.Surname, "
						+ "applicant_personal_details.First_Name, applicant_disability_types.applicant_disability_id, "
						+ "Sum(IF (applicant_gender_id = 2, IF (applicant_race_id = 1, 1, 0), 0)) as AfMCount, "
						+ "Sum(IF (applicant_gender_id = 1, IF (applicant_race_id = 1, 1, 0), 0)) as AfFCount , "
						+ "Sum(IF (applicant_gender_id = 2, IF (applicant_race_id = 2, 1, 0), 0)) as CMCount , "
						+ "Sum(IF (applicant_gender_id = 1, IF (applicant_race_id = 2, 1, 0), 0)) as CFCount , "
						+ "Sum(IF (applicant_gender_id = 2, IF (applicant_race_id in (3,4), 1, 0), 0)) as AsMCount, "
						+ "Sum(IF (applicant_gender_id = 1, IF (applicant_race_id in (3,4), 1, 0), 0)) as AsFCount , "
						+ "Sum(IF (applicant_gender_id = 2, IF (applicant_race_id = 5, 1, 0), 0)) as WMCount , "
						+ "Sum(IF (applicant_gender_id = 1, IF (applicant_race_id = 5, 1, 0), 0)) as WFCount , "
						+ "Sum(IF (applicant_gender_id = 2, 1, 0)) as totMCount, "
						+ "Sum(IF (applicant_gender_id = 1, 1, 0)) as totFCount, "
						+ "Sum(IF (applicant_gender_id = 2, IF (applicant_disability_id = 2, 1, 0), 0)) as totDMCount, "
						+ "Sum(IF (applicant_gender_id = 1, IF (applicant_disability_id = 2, 1, 0), 0)) as totDFCount "
						+ "FROM applicant_personal_details "
						+ "INNER JOIN applicant_disability_types ON applicant_personal_details.applicant_id = applicant_disability_types.applicant_id "
						+ "INNER JOIN intern_sla ON intern_sla.applicant_id = applicant_personal_details.applicant_id "
						+ "INNER JOIN sla ON intern_sla.sla_id =  sla.id "
						+ "WHERE intern_sla.status_id = 1 AND intern_sla.date > sla.start_date AND applicant_personal_details.applicant_id "
						+ "IN (SELECT intern_sla.applicant_id FROM intern_sla WHERE sla_id = " + sla_id + ") "
						+ "GROUP BY applicant_personal_details.applicant_id, applicant_personal_details.Surname, applicant_personal_details.First_Name, "
						+ "applicant_disability_types.applicant_disability_id, sla.start_date;");
			} else {
				st.executeQuery("SELECT applicant_personal_details.applicant_id, applicant_personal_details.Surname, applicant_personal_details.First_Name, "
						+ "applicant_disability_types.applicant_disability_id, "
						+ "Sum(IF (applicant_gender_id = 2, IF (applicant_race_id = 1, 1, 0), 0)) as AfMCount, "
						+ "Sum(IF (applicant_gender_id = 1, IF (applicant_race_id = 1, 1, 0), 0)) as AfFCount , "
						+ "Sum(IF (applicant_gender_id = 2, IF (applicant_race_id = 2, 1, 0), 0)) as CMCount , "
						+ "Sum(IF (applicant_gender_id = 1, IF (applicant_race_id = 2, 1, 0), 0)) as CFCount , "
						+ "Sum(IF (applicant_gender_id = 2, IF (applicant_race_id in (3,4), 1, 0), 0)) as AsMCount, "
						+ "Sum(IF (applicant_gender_id = 1, IF (applicant_race_id in (3,4), 1, 0), 0)) as AsFCount , "
						+ "Sum(IF (applicant_gender_id = 2, IF (applicant_race_id = 5, 1, 0), 0)) as WMCount , "
						+ "Sum(IF (applicant_gender_id = 1, IF (applicant_race_id = 5, 1, 0), 0)) as WFCount , "
						+ "Sum(IF (applicant_gender_id = 2, 1, 0)) as totMCount, "
						+ "Sum(IF (applicant_gender_id = 1, 1, 0)) as totFCount, "
						+ "Sum(IF (applicant_gender_id = 2, IF (applicant_disability_id = 2, 1, 0), 0)) as totDMCount, "
						+ "Sum(IF (applicant_gender_id = 1, IF (applicant_disability_id = 2, 1, 0), 0)) as totDFCount "
						+ "FROM applicant_personal_details "
						+ "INNER JOIN applicant_disability_types ON applicant_personal_details.applicant_id = applicant_disability_types.applicant_id "
						+ "INNER JOIN intern_sla ON intern_sla.applicant_id = applicant_personal_details.applicant_id "
						+ "INNER JOIN sla ON intern_sla.sla_id =  sla.id "
						+ "WHERE intern_sla.status_id = 1 AND TIMESTAMPDIFF(MONTH, intern_sla.date, '" + myDateSQL + "') <= 3 AND applicant_personal_details.applicant_id "
						+ "IN (SELECT intern_sla.applicant_id FROM intern_sla WHERE sla_id = " + sla_id + ") "
						+ "GROUP BY applicant_personal_details.applicant_id, applicant_personal_details.Surname, applicant_personal_details.First_Name, "
						+ "applicant_disability_types.applicant_disability_id, sla.start_date;");
			}
			ResultSet rs = st.getResultSet();

			while (rs.next()) {
				int afMales = rs.getInt("AfMCount");
				afMRepCount += afMales;
				int afFemales = rs.getInt("AfFCount");
				afFRepCount += afFemales;
				int cMales = rs.getInt("CMCount");
				cMRepCount += cMales;
				int cFemales = rs.getInt("CFCount");
				cFRepCount += cFemales;
				int asMales = rs.getInt("AsMCount");
				asMRepCount += asMales;
				int asFemales = rs.getInt("AsFCount");
				asFRepCount += asFemales;
				int wMales = rs.getInt("WMCount");
				wMRepCount += wMales;
				int wFemales = rs.getInt("WFCount");
				wFRepCount += wFemales;
				int disMales = rs.getInt("totDMCount");
				disabledMaleRep += disMales;
				int disFemales = rs.getInt("totDFCount");
				disabledFemaleRep += disFemales;
			}
			con.close();
		} catch (SQLException e) {
			System.out.println(e);
		}

		Table table5 = new Table(13).setWidth(520).setFontSize(8).setMarginTop(5);
		String[] arr4 = {"Number of Learners in Programme During this Quarter: " + learnrCount, "Age Group", "African",
				"Coloured", "Asian", "White", "Total", "Of Whom\n" + "disabled", "M", "F", "M", "F", "M", "F", "M", "F",
				"M", "F", "M", "F", "Number of Learners in progress", "" + afMCount, "" + afFCount, "" + cMCount, "" + cFCount,
				"" + asMCount, "" + asFCount, "" + wMCount, "" + wFCount, "" + (afMCount + cMCount + asMCount + wMCount), ""
						+ (afFCount + cFCount + asFCount + wFCount), "" + disabledMale, "" + disabledFemale,
						"Number of Learners Dropped Out", "" + afMDOCount, "" + afFDOCount, "" + cMDOCount, "" + cFDOCount,
						"" + asMDOCount, "" + asFDOCount, "" + wMDOCount, "" + wFDOCount, "" + (afMDOCount + cMDOCount + asMDOCount + wMDOCount),
						"" + (afFDOCount + cFDOCount + asFDOCount + wFDOCount), "" + disabledMaleDO, "" + disabledFemaleDO,
						"Learners Replaced", "" + afMRepCount, "" + afFRepCount, "" + cMRepCount, "" + cFRepCount,
						"" + asMRepCount, "" + asFRepCount, "" + wMRepCount, "" + wFRepCount, "" + (afMRepCount + cMRepCount + asMRepCount + wMRepCount),
						"" + (afFRepCount + cFRepCount + asFRepCount + wFRepCount), "" + disabledMaleRep, "" + disabledFemaleRep,
						"TOTAL", "" + afMCount, "" + afFCount, "" + cMCount, "" + cFCount, "" + asMCount, "" + asFCount, "" + wMCount, "" + wFCount, ""
								+ (afMCount + cMCount + asMCount + wMCount), "" + (afFCount + cFCount + asFCount + wFCount), "" + disabledMale, "" + disabledFemale};

		for (int c = 0; c < arr4.length; c++) {
			if (c == 0) {
				Cell c10 = new Cell(1, 13).add(new Paragraph(arr4[c]));
				c10.setTextAlignment(TextAlignment.CENTER).setBackgroundColor(LIGHT_GRAY).setFont(bold);
				table5.addCell(c10);
			} else if (c == 1) {
				Cell c10 = new Cell(2, 1).add(new Paragraph(arr4[c]));
				c10.setBackgroundColor(LIGHT_GRAY).setTextAlignment(TextAlignment.CENTER).setFont(bold);
				table5.addCell(c10);
			} else if (c > 1 && c < 8) {
				Cell c10 = new Cell(1, 2).add(new Paragraph(arr4[c]));
				c10.setBackgroundColor(LIGHT_GRAY).setTextAlignment(TextAlignment.CENTER).setFont(bold);
				table5.addCell(c10);
			} else if (c > 7 && c < 20) {
				Cell c10 = new Cell().add(new Paragraph(arr4[c]));
				c10.setBackgroundColor(LIGHT_GRAY).setTextAlignment(TextAlignment.CENTER).setFont(bold);
				table5.addCell(c10);
			} else if (c == 20 || c == 33 || c == 46 || c == 59) {
				Cell c10 = new Cell().add(new Paragraph(arr4[c]));
				c10.setBackgroundColor(LIGHT_GRAY).setFont(bold);
				table5.addCell(c10);
			} else {
				Cell c10 = new Cell().add(new Paragraph(arr4[c]));
				c10.setTextAlignment(TextAlignment.CENTER);
				table5.addCell(c10);
			}
		}
		doc.add(table5);

		Paragraph p2 = new Paragraph("SELECTED LEARNERS FOR INTERVIEW DURING SITE VISIT")
				.setTextAlignment(TextAlignment.CENTER).setFontSize(10).setFont(bold);
		doc.add(p2);

		Table table6 = new Table(3).setWidth(520).setFontSize(8).setHeight(16).setFont(bold).setTextAlignment(TextAlignment.CENTER);
		Cell c10 = new Cell().add(new Paragraph("Context"));
		c10.setBackgroundColor(LIGHT_GRAY);
		table6.addCell(c10);
		Cell c13 = new Cell().add(new Paragraph("On Site"));
		c13.setBorderRight(Border.NO_BORDER).setBorderLeft(Border.NO_BORDER);
		table6.addCell(c13);
		Cell c14 = new Cell().add(new Paragraph("Off–Site"));
		c14.setBorderLeft(Border.NO_BORDER);
		table6.addCell(c14);
		doc.add(table6);

		for (int d = 330; d < 550; d += 170) {
			String value = "On";
			if (d > 400) {
				value = "Off";
			}
			PdfButtonFormField checkbox8 = PdfFormField.createCheckBox(doc.getPdfDocument(),
					new Rectangle(d, 270, 10, 10), "cb7" + d, value, PdfFormField.TYPE_CROSS);
			form.addField(checkbox8.setBorderWidth(1).setVisibility(PdfFormField.VISIBLE));
		}
		String query1 = "SELECT applicant_personal_details.Surname, applicant_personal_details.First_Name, sla.Name, sla.type, sla.number_of_learners, sla.start_date, sla.end_date, COUNT(intern_sla.applicant_id) as applicantCount, intern_sla.applicant_id, applicant_disability_types.applicant_disability_id, IF(applicant_personal_details.applicant_gender_id = 1, \"Female\",\"Male\") AS gender, Sum(IF (applicant_gender_id = 2, IF (applicant_race_id = 1, 1, 0), 0)) as AfMCount, Sum(IF (applicant_gender_id = 1, IF (applicant_race_id = 1, 1, 0), 0)) as AfFCount , Sum(IF (applicant_gender_id = 2, IF (applicant_race_id = 2, 1, 0), 0)) as CMCount , Sum(IF (applicant_gender_id = 1, IF (applicant_race_id = 2, 1, 0), 0)) as CFCount , Sum(IF (applicant_gender_id = 2, IF (applicant_race_id in (3,4), 1, 0), 0)) as AsMCount, Sum(IF (applicant_gender_id = 1, IF (applicant_race_id in (3,4), 1, 0), 0)) as AsFCount , Sum(IF (applicant_gender_id = 2, IF (applicant_race_id = 5, 1, 0), 0)) as WMCount , Sum(IF (applicant_gender_id = 1, IF (applicant_race_id = 5, 1, 0), 0)) as WFCount , Sum(IF (applicant_gender_id = 2, 1, 0)) as totMCount, Sum(IF (applicant_gender_id = 1, 1, 0)) as totFCount, Sum(IF (applicant_gender_id = 2, IF (applicant_disability_id = 2, 1, 0), 0)) as totDMCount, Sum(IF (applicant_gender_id = 1, IF (applicant_disability_id = 2, 1, 0), 0)) as totDFCount  FROM  intern_sla INNER JOIN applicant_personal_details on intern_sla.applicant_id = applicant_personal_details.applicant_id  JOIN applicant_disability_types  ON applicant_personal_details.applicant_id = applicant_disability_types.applicant_id JOIN sla ON intern_sla.sla_id =  sla.id WHERE intern_sla.sla_id = " + sla_id + " GROUP BY intern_sla.applicant_id, applicant_personal_details.Surname, applicant_personal_details.First_Name, applicant_personal_details.applicant_gender_id, applicant_disability_types.applicant_disability_id, sla.Name, sla.type, sla.number_of_learners, sla.start_date, sla.end_date HAVING COUNT(intern_sla.applicant_id) < 2;";
		try {
			Database DB = new Database();
			Connection con = DB.getCon1();
			Statement st = con.createStatement();
			st.executeQuery(query1);
			ResultSet rs = st.getResultSet();
			Table table7 = new Table(4).setWidth(520).setMarginTop(5).setFontSize(8).setTextAlignment(TextAlignment.CENTER);
			for (int i = 0; i < table7.getNumberOfColumns(); i++) {
				Cell c15 = new Cell().add(new Paragraph("Name and Surname"));
				c15.setBackgroundColor(LIGHT_GRAY).setFont(bold);
				table7.addCell(c15);
			}

			while (rs.next()) {
				String name = (String) rs.getString("applicant_personal_details.First_Name").trim().toLowerCase();
				String surname = (String) rs.getString("Surname").trim().toLowerCase();
				String gender = (String) rs.getString("gender").trim();
				Paragraph p3 = new Paragraph(new Caps().toUpperCaseFirstLetter(name) + " " + new Caps().toUpperCaseSurname(surname) + " (" + gender + ")");
				Cell c19 = new Cell().add(p3);
				table7.addCell(c19);
			}
			doc.add(table7);
			con.close();
		} catch (SQLException e) {
			System.out.println(e);
		}

		doc.add(new AreaBreak());//new page

		Paragraph p3 = new Paragraph("1. Introduction");
		p3.setFontSize(10).setFont(bold);
		doc.add(p3);

		Text text = new Text(sla).setUnderline().setFont(bold);
		Paragraph p4 = new Paragraph("We have recently completed the site visit on behalf of the MICT Seta at your company. "
				+ "The site visit was based on the SLA number ").add(text).add(". Enclosed for your information is our report in respect of this site visit.");
		p4.setFontSize(10).setMarginTop(10).setPaddingLeft(15).setFont(font);
		doc.add(p4);

		Paragraph p5 = new Paragraph("2. Site Visit Objective");
		p5.setFontSize(10).setFont(bold);
		doc.add(p5);

		String str1 = "The objective of the site visit was to assess and evaluate compliance with the requirements of"
				+ " the SLA and Approved Learning Programme and where appropriate, to make recommendations for effective (functioning"
				+ " as intended) implementation of the approved MICT Learning Programme(s).";
		doc.add(new Paragraph(str1).setFontSize(10).setPaddingLeft(15).setFont(font));

		Paragraph p6 = new Paragraph("3. Learner interviews").setFontSize(10).setFont(bold);
		doc.add(p6);

		try {
			Database DB = new Database();
			Connection con = DB.getCon1();
			Statement st = con.createStatement();
			st.executeQuery("SELECT sla_emails.applicant_id, First_Name, Surname, sla_ofo_codes.occupations, learner_experience, learner_feedback, learner_highlights, learner_challenges FROM sla_emails INNER JOIN applicant_personal_details ON sla_emails.applicant_id = applicant_personal_details.applicant_id INNER JOIN intern_sla ON intern_sla.applicant_id = sla_emails.applicant_id INNER JOIN sla_ofo_codes ON intern_sla.ofo_code_id = sla_ofo_codes.id WHERE intern_sla.sla_id = "+sla_id+" AND TIMESTAMPDIFF(DAY, sla_emails.created_at, NOW()) < 6;");
			ResultSet rs = st.getResultSet();

			Paragraph p8 = new Paragraph("Learner’s experience attending the programme:\n");
			Paragraph p9 = new Paragraph("Personal feedback from interns:\n");
			Paragraph p10 = new Paragraph("Highlights:\n");
			Paragraph p11 = new Paragraph("Challenges:\n");
			List list = new List().setListSymbol("• \t");
			List list1 = new List().setListSymbol("• \t");
			List list2 = new List().setListSymbol("• \t");
			List list3 = new List().setListSymbol("• \t");
			while (rs.next()) {
				String name = (String) rs.getString("First_Name").trim();
				String surname = (String) rs.getString("Surname").trim();
				name = new Caps().toUpperCaseFirstLetter(name) + " " + new Caps().toUpperCaseSurname(surname);
				String title = (String) rs.getString("sla_ofo_codes.occupations").trim();
				String experience = (String) rs.getString("learner_experience").trim();
				String feedback = (String) rs.getString("learner_feedback").trim();
				String highlights = (String) rs.getString("learner_highlights").trim();
				String challenges = (String) rs.getString("learner_challenges").trim();
				list.add(new ListItem(name + " (" + title + "): " + experience));
				list1.add(new ListItem(name + " (" + title + "): " + feedback));
				list2.add(new ListItem(name + " (" + title + "): " + highlights));
				list3.add(new ListItem(name + " (" + title + "): " + challenges));
			}
			p8.setPaddingLeft(15).setFontSize(10).setFont(font).add(list);
			doc.add(p8);
			p9.setPaddingLeft(15).setFontSize(10).setFont(font).add(list1);
			doc.add(p9);
			p10.setPaddingLeft(15).setFontSize(10).setFont(font).add(list2);
			doc.add(p10);
			p11.setPaddingLeft(15).setFontSize(10).setFont(font).add(list3);
			doc.add(p11);
			con.close();
		} catch (SQLException e) {
			System.out.println(e);
		}

		doc.add(new Paragraph("4. Project Manager/ SDF (Employer) Questionnaire").setTextAlignment(TextAlignment.LEFT).setFontSize(10).setFont(bold).setKeepWithNext(true));

		doc.add(new Paragraph(managerQuestionnaire).setFontSize(10).setPaddingLeft(15).setFont(font));

		try {
			Database DB = new Database();
			Connection con = DB.getCon1();
			Statement st = con.createStatement();
			st.executeQuery("SELECT DISTINCT findings, exposure FROM sla_emails WHERE sla_emails.sla_id = " + sla_id + " AND TIMESTAMPDIFF(DAY, created_at, NOW()) < 6;");
			ResultSet rs = st.getResultSet();

			Paragraph p10 = new Paragraph("5. Findings:\n").setTextAlignment(TextAlignment.LEFT).setFontSize(10).setFont(bold);
			Paragraph p11 = new Paragraph("Areas interns were exposed to:\n").setFontSize(10).setFont(font);
			List list = new List().setListSymbol("• \t");
			List list1 = new List().setListSymbol("• \t");
			while (rs.next()) {
				String findings = (String) rs.getString("findings").trim();
				String exposure = (String) rs.getString("exposure").trim();
				if (findings.contains("\n") || exposure.contains("\n")) {
					String[] fParts = findings.split(Pattern.quote("\n"));
					for (String fPart : fParts) {
						list.add(new ListItem(fPart));
					}
					String[] eParts = exposure.split(Pattern.quote("\n"));
					for (String ePart : eParts) {
						list1.add(new ListItem(ePart));
					}
				} else {
					list1.add(new ListItem(findings));
					list1.add(new ListItem(exposure));
				}
			}
			p10.add(list.setPaddingLeft(15).setFontSize(10).setFont(font));
			doc.add(p10);
			p11.add(list1.setPaddingLeft(15).setFontSize(10).setFont(font));
			doc.add(p11);
			con.close();
		} catch (SQLException e) {
			System.out.println(e);
		}

		doc.add(new Paragraph("Feedback from mentors:\n" + employer_name + ": Mentor for all interns\n").setFontSize(10).setFont(font));
		doc.add(new Paragraph(mentorFeedback).setFontSize(10).setPaddingLeft(15).setFont(font));

		doc.add(new Paragraph("6. Recommendations/ Remedial actions/ Developmental Plans").setFontSize(10).setFont(bold));
		doc.add(new Paragraph(recommendations).setFontSize(10).setPaddingLeft(15).setFont(font));

		doc.add(new Paragraph("7. Conclusion").setFontSize(10).setFont(bold));
		doc.add(new Paragraph(conclusion).setFontSize(10).setPaddingLeft(15).setFont(font));

		doc.add(new AreaBreak());//new page

		doc.add(new Paragraph("OFFICE USE\n").setFontColor(RED).setFontSize(10).setFont(bold));

		double disbursementAmount = 0, disbursement1 = 0, disbursement2 = 0, disbursement3 = 0, disbursement4 = 0;
		try {
			Database DB = new Database();
			Connection con = DB.getCon1();
			Statement st = con.createStatement();
			st.executeQuery("SELECT * FROM sla_disbursements WHERE sla_id = " + sla_id + ";");
			ResultSet rs = st.getResultSet();
			while (rs.next()) {
				disbursementAmount = (double) rs.getDouble("amount");
				disbursement1 = ((double) rs.getDouble("disbursement1")) / 100;
				disbursement2 = ((double) rs.getDouble("disbursement2")) / 100;
				disbursement3 = ((double) rs.getDouble("disbursement3")) / 100;
				disbursement4 = ((double) rs.getDouble("disbursement4")) / 100;
			}
			con.close();
		} catch (SQLException e) {
			System.out.println(e);
		}
		double[] amount = {count * (disbursement1 * disbursementAmount),
				count * (disbursement2 * disbursementAmount),
				count * (disbursement3 * disbursementAmount), 0};
		if (disbursement4 > 0) {
			amount[3] = count * (disbursement4 * disbursementAmount);
		}

		String d1 = "", m1 = "", y1 = "", d2 = "", m2 = "", y2 = "", d3 = "", m3 = "", y3 = "", d4 = "", m4 = "", y4 = "";
		try {
			Database DB = new Database();
			Connection con = DB.getCon1();
			Statement st = con.createStatement();
			st.executeQuery("SELECT DAY(LAST_DAY(DATE_ADD(start_date, INTERVAL 2 MONTH))) AS d1, MONTHNAME(DATE_ADD(start_date, INTERVAL 2 MONTH)) AS m1, YEAR(DATE_ADD(start_date, INTERVAL 2 MONTH)) as y1, DAY(LAST_DAY(DATE_ADD(start_date, INTERVAL 5 MONTH))) AS d2, MONTHNAME(DATE_ADD(start_date, INTERVAL 5 MONTH)) AS m2, YEAR(DATE_ADD(start_date, INTERVAL 5 MONTH)) as y2, DAY(LAST_DAY(DATE_ADD(start_date, INTERVAL 8 MONTH))) AS d3, MONTHNAME(DATE_ADD(start_date, INTERVAL 8 MONTH)) AS m3, YEAR(DATE_ADD(start_date, INTERVAL 8 MONTH)) as y3, DAY(LAST_DAY(DATE_ADD(start_date, INTERVAL 11 MONTH))) AS d4, MONTHNAME(DATE_ADD(start_date, INTERVAL 11 MONTH)) AS m4, YEAR(DATE_ADD(start_date, INTERVAL 11 MONTH)) as y4 FROM sla WHERE id = " + sla_id + ";");
			ResultSet rs = st.getResultSet();
			while (rs.next()) {
				d1 = rs.getString("d1");
				m1 = rs.getString("m1");
				y1 = rs.getString("y1");
				d2 = rs.getString("d2");
				m2 = rs.getString("m2");
				y2 = rs.getString("y2");
				d3 = rs.getString("d3");
				m3 = rs.getString("m3");
				y3 = rs.getString("y3");
				d4 = rs.getString("d4");
				m4 = rs.getString("m4");
				y4 = rs.getString("y4");
			}
			con.close();
		} catch (SQLException e) {
			System.out.println(e);
		}
		if (visit == 4 && disbursement4 > 0) {
			visit = 3;
		}
		//Due Date
		String[] dueD = {d1, d2, d3, d4}, dueM = {m1, m2, m3, m4}, dueY = {y1, y2, y3, y4};
		Paragraph p12 = new Paragraph(advisor_name).setFont(bold).setUnderline().setWidth(110);
		Paragraph p13 = new Paragraph(NumberFormat.getCurrencyInstance().format(amount[visit - 1])).setUnderline().setFont(bold);
		Paragraph p14;

		if (dueD[visit - 1].equals("31")) {
			p14 = new Paragraph(dueD[visit - 1]).setFont(bold).setUnderline().setFontSize(10).add(new Text("st").setFont(small).setTextRise(6).setFontSize(6));
		} else {
			p14 = new Paragraph(dueD[visit - 1]).setFont(bold).setUnderline().setFontSize(10).add(new Text("th").setFont(small).setTextRise(3).setFontSize(6));
		}
		Paragraph p15 = new Paragraph(dueM[visit - 1]).setFont(bold).setUnderline().setFontSize(10);
		Paragraph p16 = new Paragraph(dueY[visit - 1]).setFont(bold).setUnderline().setFontSize(10);

		doc.add(new Paragraph("The employer is complying with the SLA requirements: \n"
				+ "\n"
				+ " I ").setFontSize(10).setFont(font).setKeepTogether(true).add(p12).add(" hereby confirm that all is in order. I therefore recommend\t\t or not recommend\t\t that the "
						+ "employer be granted disbursement amount of ").setKeepTogether(true).add(p13.setKeepTogether(true)).add(" that is due on the ").setKeepTogether(true).add(p14).add("  Month ")
				.add(p15).add(" Year (").add(p16).add(")\n"));
		doc.add(new Paragraph("Signature of:\n").setFont(bold).setFontSize(10));
		doc.add(new Paragraph("The Employer and MICT SETA representative both signed the final outcome giving commitment of correct implementation"
				+ " as per SLA. ").setFontSize(10).setFont(font));

		for (int f = 415; f < 550; f += 105) {
			String value = "On";
			if (f > 420) {
				value = "Off";
			}
			PdfButtonFormField checkbox8 = PdfFormField.createCheckBox(doc.getPdfDocument(),
					new Rectangle(f, 733, 10, 10), "checkbox8.2" + f, value, PdfFormField.TYPE_CROSS);
			form.addField(checkbox8.setBorderWidth(1).setVisibility(PdfFormField.VISIBLE));
		}

		Table table13 = new Table(4).setWidth(520).setFontSize(8).setMarginTop(5);

		String[] entry = {"Employer Representative:", "MICT Seta Advisor:", "Full Name", employer_name, "Full Name", advisor_name, "Capacity",
				"Managing Member", "Capacity", "Regional Advisor", "Signature", "", "Signature", "", "Date", myDate, "Date", myDate};

		for (int g = 0; g < entry.length; g++) {
			if (g == 0 || g == 1) {
				Cell c15 = new Cell(1, 2).add(new Paragraph(entry[g]));
				c15.setBackgroundColor(LIGHT_GRAY).setTextAlignment(TextAlignment.CENTER).setFont(bold);
				table13.addCell(c15);
			} else if (g % 2 == 0) {
				Cell c15 = new Cell().add(new Paragraph(entry[g]));
				c15.setBackgroundColor(LIGHT_GRAY).setFont(bold);
				table13.addCell(c15);
			} else if (g == 11 || g == 13) {
				Cell c15 = new Cell().add(new Paragraph(entry[g])).setHeight(45);
				table13.addCell(c15);
			} else {
				Cell c15 = new Cell().add(new Paragraph(entry[g]));
				table13.addCell(c15);
			}
		}
		doc.add(table13);

		Paragraph p20 = new Paragraph("Report Verified by");

		p20.setFontSize(10).setFont(bold);
		doc.add(p20);

		Table table14 = new Table(4).setWidth(520).setFontSize(8).setFixedLayout();

		String[] entry1 = {"Learning Programme Manager :", "Full Name", manager_name, "Signature", "", "Date", myDate};

		for (int h = 0; h < entry1.length; h++) {
			if (h == 0) {
				Cell c15 = new Cell(1, 4).add(new Paragraph(entry1[h]));
				c15.setBackgroundColor(LIGHT_GRAY).setTextAlignment(TextAlignment.CENTER).setFont(bold);
				table14.addCell(c15);
			} else if (h % 2 != 0) {
				Cell c15 = new Cell().add(new Paragraph(entry1[h]));
				c15.setBackgroundColor(LIGHT_GRAY).setFont(bold);
				table14.addCell(c15);
			} else if (h == 4) {
				Cell c15 = new Cell(1, 3).add(new Paragraph(entry1[h])).setHeight(45);
				table14.addCell(c15);
			} else {
				Cell c15 = new Cell(1, 3).add(new Paragraph(entry1[h]));
				table14.addCell(c15);
			}
		}
		doc.add(table14);

		return form;
	}

	private static class CheckboxCellRenderer extends CellRenderer {

		protected String name;
		protected String value;

		public CheckboxCellRenderer(Cell modelElement, String name, String value) {
			super(modelElement);
			this.name = name;
			this.value = value;
		}

		@Override
		public void draw(DrawContext drawContext) {
			float x = (getOccupiedAreaBBox().getLeft() + getOccupiedAreaBBox().getRight()) / 2;
			float y = (getOccupiedAreaBBox().getTop() + getOccupiedAreaBBox().getBottom()) / 2;
			Rectangle rect = new Rectangle(x - 5, y - 5, 10, 10);
			PdfButtonFormField checkBox = PdfFormField.createCheckBox(drawContext.getDocument(), rect, name, value, PdfFormField.TYPE_CROSS);
			PdfAcroForm.getAcroForm(drawContext.getDocument(), true).addField(checkBox.setBorderWidth(1).setVisibility(PdfFormField.VISIBLE));
		}
	}
}
