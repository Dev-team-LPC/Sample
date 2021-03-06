package cc.littlepig.servlets;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.sql.*;
import java.text.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.itextpdf.forms.PdfAcroForm;
import com.itextpdf.io.font.FontConstants;
import com.itextpdf.io.image.ImageDataFactory;
import static com.itextpdf.kernel.colors.ColorConstants.LIGHT_GRAY;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.Border;
import com.itextpdf.layout.element.*;
import com.itextpdf.layout.property.*;

import cc.littlepig.classes.Caps;
import cc.littlepig.classes.Footer;
import cc.littlepig.classes.GlobalConstants;
import cc.littlepig.databases.Database;

/**
 * Servlet implementation class GenerateFinalReport
 */
@WebServlet("/GenerateFinalReport")
public class GenerateFinalReport extends HttpServlet {
	private static final long serialVersionUID = 1L;
	public static String mentor, months, sla_id, creationDate, learnrCount = "", sla_name = "", companyName = "", progType = "", managerName = "",
			managerSurname = "", managerTel = "", sdlNum = "", agredidationNum = "",user_id = "", DEST, introduction = "", implementation = "", location = "",  
			implementationDesc = "", plan = "", placement = "", achievements = "", myDate = "", myDateSQL = "", report_id = "", quarter = "", reportType = "";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public GenerateFinalReport() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		report_id = request.getParameter("report_id");
		reportType = request.getParameter("report_type");
		DEST = GlobalConstants.DEST + File.separator + "final reports" + File.separator + "Final Report ["+report_id+"].pdf";
		File file = new File(DEST);
		if (file.exists() && !file.isDirectory()) {
			response.sendRedirect("reportReview.jsp?file=" + DEST +"&report_type="+reportType+"");
		} else {
			file.getParentFile().mkdirs();
			try {
				new GenerateFinalReport().createReport(DEST, request);
//				new Footer().addFooter(DEST, reportType);
			} catch (Exception e) {
				e.printStackTrace();
			}
			response.sendRedirect("reportReview.jsp?file=" + DEST +"&report_type="+reportType+"");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

	protected void createReport(String dest, HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession(true);
		user_id = (String) session.getAttribute("id");
		//convert the date format to the required
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM uuuu");
		DateTimeFormatter formatterSQL = DateTimeFormatter.ofPattern("uuuu-MM-dd");
		try {
			Database DB = new Database();
			Connection con = DB.getCon1();
			Statement st = con.createStatement();
			st.executeQuery("SELECT sla_id, report_date, introduction, methodology, methodology_details, strategic_plan, work_placement, achievements, sla_reports_learner_placement.placement FROM sla_reports INNER JOIN sla_reports_final ON sla_reports_final.report_id = sla_reports.id INNER JOIN sla_reports_learner_tasks ON sla_reports_learner_tasks.report_id = sla_reports.id INNER JOIN sla_reports_learner_placement ON sla_reports_learner_placement.final_report_id = sla_reports_final.id WHERE sla_reports.id ="+report_id+";");
			ResultSet rs = st.getResultSet();

			while (rs.next()) {
				introduction = (String) rs.getString("introduction").trim().substring(0);
				implementation = (String) rs.getString("methodology").trim();
				implementationDesc = (String) rs.getString("methodology_details");
				plan = (String) rs.getString("strategic_plan");
				placement = (String) rs.getString("work_placement");
				achievements = (String) rs.getString("achievements");
				sla_id = (String) rs.getString("sla_id");
				creationDate = (String) rs.getString("report_date");
				location = (String) rs.getString("sla_reports_learner_placement.placement");

			}
		} catch (SQLException e) {
			System.out.println(e);
		}
		myDate = formatter.format(LocalDate.parse(creationDate));
		myDateSQL = formatterSQL.format(LocalDate.parse(creationDate));

		PdfDocument pdf = new PdfDocument(new PdfWriter(DEST));
		pdf.getDocumentInfo().setTitle("Final Report");
		pdf.getDocumentInfo().setAuthor("Siphesihle Pangumso");
		pdf.getDocumentInfo().setMoreInfo(pdf.getDocumentInfo().getTitle(), pdf.getDocumentInfo().getAuthor());
		pdf.setDefaultPageSize(PageSize.A4);
		try (Document document = new Document(pdf)) {
			GenerateFinalReport.addSectionOne(document);
			GenerateFinalReport.addSectionTwo(document);
			GenerateFinalReport.addSectionThree(document);
			GenerateFinalReport.addSectionFour(document);
			GenerateFinalReport.addSectionFive(document);
			document.close();
		}
	}

	// <editor-fold defaultstate="collapsed" desc="section A">
	public static PdfAcroForm addSectionOne(Document doc)
			throws MalformedURLException, SQLException, IOException, ParseException, ServletException {
		PdfFont font = PdfFontFactory.createFont(FontConstants.HELVETICA);
		PdfFont bold = PdfFontFactory.createFont(FontConstants.HELVETICA_BOLD);
		PdfAcroForm form = PdfAcroForm.getAcroForm(doc.getPdfDocument(), true);

		String query = "SELECT t1.Name, t1.type, t1.number_of_learners, DATE_FORMAT(t1.start_date,'%d %M %Y') start_date, "
				+ "if(NOW() <= DATE_ADD(start_date, INTERVAL 3 MONTH), 'First Quarter', if(NOW() <= DATE_ADD(start_date, INTERVAL 6 MONTH), 'Second Quarter', "
				+ "if(NOW() <= DATE_ADD(start_date, INTERVAL 9 MONTH), 'Third Quarter', if(NOW() <= DATE_ADD(start_date, INTERVAL 12 MONTH), 'Fourth Quarter', 'null')))) quarter,"
				+ "DATE_FORMAT(t1.end_date,'%d %M %Y') end_date, t2.company_name, t2.registration_number, t2.agredidation_number, "
				+ "t2.logo, t2.address, t2.representative_employer_name, t2.representative_employer_surname, t3.name, t3.surname, t3.cellphone, "
				+ "t3.telephone, t3.email FROM sla t1 INNER JOIN sla_company_details t2 ON t2.id = t1.company_id INNER JOIN sla_project_manager t3 ON t3.id = t2.project_manager_id WHERE t1.id = " + sla_id + ";";
		String startDate = "", endDate = "", logo = "", managerCell = "", managerMail = "", managerAddr = "";
		try {
			Database DB = new Database();
			Connection con = DB.getCon1();
			Statement st = con.createStatement();
			st.executeQuery(query);
			ResultSet rs = st.getResultSet();

			while (rs.next()) {
				quarter = (String) rs.getString("quarter");
				progType = (String) rs.getString("t1.type").trim().substring(0);
				sla_name = (String) rs.getString("t1.Name").trim();
				learnrCount = (String) rs.getString("t1.number_of_learners");
				startDate = (String) rs.getString("start_date");
				endDate = (String) rs.getString("end_date");
				companyName = (String) rs.getString("t2.company_name");
				logo = (String) rs.getString("t2.logo");
				managerAddr = (String) rs.getString("t2.address");
				sdlNum = (String) rs.getString("t2.registration_number");
				agredidationNum = (String) rs.getString("t2.agredidation_number");
				mentor = new Caps().toUpperCaseFirstLetter((String) rs.getString("t2.representative_employer_name") + " " + new Caps().toUpperCaseSurname((String) rs.getString("t2.representative_employer_surname")));
				managerName = new Caps().toUpperCaseFirstLetter((String) rs.getString("t3.name"));
				managerSurname = new Caps().toUpperCaseSurname((String) rs.getString("t3.surname"));
				managerTel = (String) rs.getString("t3.telephone");
				managerMail = (String) rs.getString("t3.email");
				managerCell = (String) rs.getString("t3.cellphone");
			}
		} catch (SQLException e) {
			System.out.println(e);
		}
		doc.getPdfDocument().getDocumentInfo().setSubject(companyName + " " + progType + " (" + sla_name + ")");
		if (!logo.equals("null")) {
			Image logos = new Image(ImageDataFactory.create(logo));
			logos.scaleAbsolute(170, 70);
			doc.add(logos);
		}
		Image seta = new Image(ImageDataFactory.create(GlobalConstants.IMAGE_SETA));
		seta.scaleAbsolute(225, 85).setFixedPosition(410, 730);
		doc.add(seta);

		doc.add(new Paragraph(progType.toUpperCase() + " PROGRESS REPORT").setTextAlignment(TextAlignment.CENTER).setFontSize(12).setFont(bold).setPaddingTop(60));
		doc.add(new Paragraph("SECTION A:  " + progType.toUpperCase() + " DETAILS").setTextAlignment(TextAlignment.LEFT).setFontSize(12).setFont(bold).setPaddingTop(40));

		Table table1 = new Table(2).setWidth(520).setFontSize(10).setMarginTop(5).setFixedLayout();

		String[] entry1 = {"Programme", progType + " Programme", "SLA number", sla_name, new Caps().toUpperCaseFirstLetter(progType) + " NQF Level",
				"Level 5", "Report Period (Quarter)", quarter, "Employer’s Name", companyName, "Date of final report", myDate, "Start date", startDate,
				"End date", endDate};

		for (int i = 0; i < entry1.length; i++) {
			if (i % 2 == 0) {
				Cell c10 = new Cell().add(new Paragraph(entry1[i]));
				c10.setBackgroundColor(LIGHT_GRAY).setFont(bold);
				table1.addCell(c10);
			} else {
				Cell c10 = new Cell().setFont(font).setFontSize(10).add(new Paragraph(entry1[i]));
				table1.addCell(c10);
			}
		}
		doc.add(table1);

		Paragraph p2 = new Paragraph("Project Manager’s Details").setTextAlignment(TextAlignment.LEFT).setFontSize(10).setFont(bold).setPaddingTop(10);
		doc.add(p2);

		Table table2 = new Table(2).setWidth(520).setFontSize(10).setFixedLayout();
		String[] entry2 = {"Project Manager Full Name", managerName, "Project Manager Surname", managerSurname};
		for (int i = 0; i < entry2.length; i++) {
			if (i % 2 == 0) {
				Cell c10 = new Cell().add(new Paragraph(entry2[i]));
				c10.setBackgroundColor(LIGHT_GRAY).setFont(bold);
				table2.addCell(c10);
			} else {
				Cell c10 = new Cell().setFont(font).setFontSize(10).add(new Paragraph(entry2[i]));
				table2.addCell(c10);
			}
		}

		doc.add(table2);
		Paragraph p3 = new Paragraph("Contact Details").setTextAlignment(TextAlignment.LEFT).setFontSize(10).setFont(bold).setPaddingTop(10);
		doc.add(p3);

		Table table3 = new Table(2).setWidth(520).setFontSize(10).setFixedLayout();
		String[] entry3 = {"Project manager telephone no.", managerTel, "Project manager cell", managerCell, "e-mail address", managerMail, "Company’s Physical address", managerAddr};
		for (int i = 0; i < entry3.length; i++) {
			if (i % 2 == 0) {
				Cell c10 = new Cell().add(new Paragraph(entry3[i]));
				c10.setBackgroundColor(LIGHT_GRAY).setFont(bold);
				table3.addCell(c10);
			} else {
				Cell c10 = new Cell().setFontSize(10).add(new Paragraph(entry3[i]));
				table3.addCell(c10);
			}
		}

		doc.add(table3);
		return form;
	}// </editor-fold>

	// <editor-fold defaultstate="collapsed" desc="section B">
	public static PdfAcroForm addSectionTwo(Document doc)
			throws MalformedURLException, SQLException, IOException, ParseException, ServletException {
		PdfFont font = PdfFontFactory.createFont(FontConstants.HELVETICA);
		PdfFont bold = PdfFontFactory.createFont(FontConstants.HELVETICA_BOLD);
		PdfAcroForm form = PdfAcroForm.getAcroForm(doc.getPdfDocument(), true);

		doc.add(new AreaBreak());//new page
		if (companyName.equalsIgnoreCase("Little Pig CC") && progType.equalsIgnoreCase("Internship")) {
			Paragraph p4 = new Paragraph("SECTION B: " + progType.toUpperCase() + " QUARTER OVERVIEW").setTextAlignment(TextAlignment.LEFT).setFontSize(12).setFont(bold);
			doc.add(p4);
			Paragraph p5 = new Paragraph("Introduction\n").setFont(bold).setFontSize(10).setTextAlignment(TextAlignment.LEFT).setKeepWithNext(true);
			doc.add(p5);
			doc.add(new Paragraph(introduction).setFont(font).setFontSize(10));
			Paragraph p6 = new Paragraph("Project Implementation Methodology").setTextAlignment(TextAlignment.LEFT).setFontSize(10).setFont(bold).setKeepWithNext(true);
			doc.add(p6);
			doc.add(new Paragraph(implementation).setFont(font).setFontSize(10));
			Paragraph p8 = new Paragraph("Scrum Diagram").setTextAlignment(TextAlignment.CENTER).setFont(bold).setFontSize(10);
			doc.add(p8);
			Image scrumDiagram = new Image(ImageDataFactory.create(GlobalConstants.IMAGE_SCRUM1));
			Cell cell2 = new Cell();
			cell2.add(scrumDiagram.scaleAbsolute(519, 150));
			doc.add(cell2);
			//			Paragraph p9 = new Paragraph("The Scrum Framework implements the cornerstones defined by the Agile Manifesto which emphasises the value of:\n");
			//			doc.add(p9.setFontSize(10).setFont(bold));
			//			List list = new List().setListSymbol("• \t");
			//			if (implementationDesc.contains("*")) {
			//				String [] parts = implementationDesc.split(Pattern.quote("*"));
			//				for (String str : parts) {
			//					list.add(new ListItem(str));
			//				}
			//			}
			//			doc.add(list.setPaddingLeft(15).setFontSize(10).setFont(font));
			doc.add(new Paragraph(implementationDesc).setFont(font).setFontSize(10));
			Paragraph p11 = new Paragraph("Strategic Plan\n");
			doc.add(p11.setFont(bold).setFontSize(10).setKeepWithNext(true));
			doc.add(new Paragraph(plan).setFont(font).setFontSize(10));
			Paragraph p12 = new Paragraph("Work Placement\n").setKeepWithNext(true);
			doc.add(p12.setFont(bold).setFontSize(10));
			doc.add(new Paragraph(placement).setFont(font).setFontSize(10));
		} else if (companyName.equalsIgnoreCase("Border ICT & Cabling Service") && progType.equalsIgnoreCase("internship")) {
			Paragraph p4 = new Paragraph("SECTION B: " + progType.toUpperCase() + " QUARTER OVERVIEW").setTextAlignment(TextAlignment.LEFT).setFontSize(12).setFont(bold);
			doc.add(p4);
			Paragraph p5 = new Paragraph("Introduction\n").setFont(bold).setFontSize(10).setTextAlignment(TextAlignment.LEFT).setKeepWithNext(true);
			doc.add(p5);
			doc.add(new Paragraph(introduction).setFont(font).setFontSize(10));
			Paragraph p6 = new Paragraph("Project Implementation Methodology").setTextAlignment(TextAlignment.LEFT).setFontSize(10).setFont(bold).setKeepWithNext(true);
			doc.add(p6);
			doc.add(new Paragraph(implementation).setFont(font).setFontSize(10));
			Paragraph p11 = new Paragraph("Strategic Plan\n");
			doc.add(p11.setFont(bold).setFontSize(10).setKeepWithNext(true));
			doc.add(new Paragraph(plan).setFont(font).setFontSize(10));
			Paragraph p12 = new Paragraph("Work Placement\n").setKeepWithNext(true);
			doc.add(p12.setFont(bold).setFontSize(10));
			doc.add(new Paragraph(placement).setFont(font).setFontSize(10));
		} else {
			Paragraph p4 = new Paragraph("SECTION B: " + progType.toUpperCase() + " QUARTER OVERVIEW").setTextAlignment(TextAlignment.LEFT).setFontSize(12).setFont(bold);
			doc.add(p4);
			Paragraph p5 = new Paragraph("Introduction\n").setFont(bold).setFontSize(10).setTextAlignment(TextAlignment.LEFT).setKeepWithNext(true);
			doc.add(p5);
			doc.add(new Paragraph(introduction).setFont(font).setFontSize(10));
			Paragraph p6 = new Paragraph("Project Implementation Methodology").setTextAlignment(TextAlignment.LEFT).setFontSize(10).setFont(bold).setKeepWithNext(true);
			doc.add(p6);
			doc.add(new Paragraph(implementation).setFont(font).setFontSize(10));
			Paragraph p11 = new Paragraph("Strategic Plan\n");
			doc.add(p11.setFont(bold).setFontSize(10).setKeepWithNext(true));
			//			List list = new List().setListSymbol("• \t");
			//			if (plan.contains("*")) {
			//				String [] parts = plan.split(Pattern.quote("*"));
			//				for (String str : parts) {
			//					list.add(new ListItem(str));
			//				}
			//			}
			//			doc.add(list.setPaddingLeft(15).setFontSize(10).setFont(font));
			doc.add(new Paragraph(plan).setFont(font).setFontSize(10));
			Paragraph p12 = new Paragraph("Work Placement\n").setKeepWithNext(true);
			doc.add(p12.setFont(bold).setFontSize(10));
			//			List list1 = new List().setListSymbol("• \t");
			//			if (placement.contains("*")) {
			//				String [] parts = placement.split(Pattern.quote("*"));
			//				for (String str : parts) {
			//					list1.add(new ListItem(str));
			//				}
			//				doc.add(list1.setPaddingLeft(15).setFontSize(10).setFont(font));			
			//			} else {
			doc.add(new Paragraph(placement).setFont(font).setFontSize(10));
			//			}
		}

		Table table = new Table(6).setWidth(520).setFontSize(8).setFixedLayout();
		String[] arr = {"Surname", "Name", "Identity Number", "Gender", "Placement", "Employer"};

		for (String arr1 : arr) {
			Cell c7 = new Cell().add(new Paragraph(arr1)).setBackgroundColor(LIGHT_GRAY).setFont(bold).setFontSize(10);
			table.addCell(c7);
		}
		try {
			Database DB = new Database();
			Connection con = DB.getCon1();
			Statement st = con.createStatement();
			st.executeQuery("SELECT Surname, First_Name, id_number, IF(applicant_gender_id = 1, \"Female\", \"Male\") gender, (SELECT company_name FROM sla INNER JOIN sla_company_details ON sla_company_details.id = sla.company_id WHERE sla.id = t1.sla_id) company FROM intern_sla t1 INNER JOIN applicant_personal_details ON applicant_personal_details.applicant_id = t1.applicant_id INNER JOIN applicants ON applicants.id = t1.applicant_id INNER JOIN sla ON t1.sla_id = sla.id WHERE sla_id = " + sla_id + " AND t1.status_id = 1 AND (SELECT COUNT(t2.applicant_id) FROM intern_sla AS t2 WHERE t2.applicant_id=t1.applicant_id HAVING COUNT(t2.applicant_id) < 2) = 1 ORDER BY Surname ASC;");
			ResultSet rs = st.getResultSet();
			String [] locaxn = location.split("::");
			for (int j = 0; j < locaxn.length && rs.next(); j++) {
				String surname = new Caps().toUpperCaseSurname(rs.getString("Surname").trim());
				String name = new Caps().toUpperCaseFirstLetter(rs.getString("First_Name").trim());
				String id = rs.getString("id_number");
				String gender = rs.getString("gender");
				String company = rs.getString("company");
				String[] array = {surname, name, id, gender, locaxn[j], company};
				for (int i = 0; i < array.length; i++) {
					Cell c = new Cell().add(new Paragraph(array[i]).setFont(font).setFontSize(10).setTextAlignment(TextAlignment.LEFT));
					table.addCell(c);
				}
			}
			con.close();
		} catch (SQLException e) {
			System.out.println(e);
		}
		doc.add(table);

		return form;
	}// </editor-fold>

	// <editor-fold defaultstate="collapsed" desc="section C">
	public static PdfAcroForm addSectionThree(Document doc)
			throws MalformedURLException, SQLException, IOException, ParseException, ServletException {

		PdfFont font = PdfFontFactory.createFont(FontConstants.HELVETICA);
		PdfFont bold = PdfFontFactory.createFont(FontConstants.HELVETICA_BOLD);
		PdfAcroForm form = PdfAcroForm.getAcroForm(doc.getPdfDocument(), true);

		doc.add(new AreaBreak());//new page
		Paragraph p15 = new Paragraph("SECTION C:  LESSON PLAN TIME SCHEDULE").setTextAlignment(TextAlignment.LEFT).setFontSize(12).setFont(bold);
		doc.add(p15);
		Text text2 = new Text("workplace");
		text2.setFont(bold).setFontSize(10).setUnderline();
		Paragraph p16 = new Paragraph("Activities which are undertaken for ").add(text2)
				.add(" learning; when and how these were done in this quarter.").setFont(font).setFontSize(10);
		doc.add(p16);

		Table table4 = new Table(7).setWidth(520).setFontSize(8).setMarginTop(5).setFixedLayout();
		String[] entry3 = {"Date", "Activity", "Learning Outcome", "Mentor / Coach", "Department", "Action Required", "Due Date",
				"[name]", "", "", "", "", "", "By When?"};
		for (int i = 0; i < entry3.length; i++) {
			if (i < 7) {
				Cell c10 = new Cell().add(new Paragraph(entry3[i]));
				c10.setTextAlignment(TextAlignment.CENTER).setBackgroundColor(LIGHT_GRAY).setFont(bold).setBorderBottom(Border.NO_BORDER);
				table4.addCell(c10);
			} else if (i == 13) {
				Cell c10 = new Cell().add(new Paragraph(entry3[i]));
				c10.setTextAlignment(TextAlignment.CENTER).setBackgroundColor(LIGHT_GRAY).setFont(bold);
				table4.addCell(c10);
			} else {
				Cell c10 = new Cell().add(new Paragraph(entry3[i]));
				c10.setTextAlignment(TextAlignment.CENTER).setBackgroundColor(LIGHT_GRAY).setFont(bold).setBorderTop(Border.NO_BORDER);
				table4.addCell(c10);
			}
		}

		try {
			Database DB = new Database();
			Connection con = DB.getCon1();
			Statement st = con.createStatement();
			st.executeQuery("SELECT task_name, task_outcome, task_date, task_due_date, task_action_required FROM sla_reports INNER JOIN sla_reports_learner_tasks ON sla_reports_learner_tasks.report_id = sla_reports.id WHERE sla_reports.id ="+report_id+";");
			ResultSet rs = st.getResultSet();
			String [] activity_date = null;
			String [] activity_due_date = null;
			String [] activity_name = null;
			String [] activity_outcome = null;
			String [] activity_action_required = null;
			String department = "ICT department";

			while (rs.next()) {
				activity_date = rs.getString("task_date").split("::");
				activity_due_date = rs.getString("task_due_date").split("::");
				activity_name = rs.getString("task_name").split("::");
				activity_outcome = rs.getString("task_outcome").split("::");
				activity_action_required = rs.getString("task_action_required").split("::");
			}
			for (int j = 0; j < activity_action_required.length; j++) {
				String[] array = {activity_date[j], activity_name[j], activity_outcome[j], mentor, department, activity_action_required[j], activity_due_date[j]};
				for (int i = 0; i < array.length; i++) {
					Cell c19 = new Cell().add(new Paragraph(array[i])).setKeepTogether(true);
					table4.addCell(c19);
				}
			}
			doc.add(table4);
		} catch (SQLException e) {
			System.out.println(e);
		}
		return form;
	}// </editor-fold>

	// <editor-fold defaultstate="collapsed" desc="section D">
	public static PdfAcroForm addSectionFour(Document doc)
			throws MalformedURLException, SQLException, IOException, ParseException, ServletException {

		PdfFont font = PdfFontFactory.createFont(FontConstants.HELVETICA);
		PdfFont bold = PdfFontFactory.createFont(FontConstants.HELVETICA_BOLD);
		PdfAcroForm form = PdfAcroForm.getAcroForm(doc.getPdfDocument(), true);

		doc.add(new AreaBreak(PageSize.A2));
		Paragraph p17 = new Paragraph("SECTION D: LEARNER DETAILS").setTextAlignment(TextAlignment.LEFT).setFontSize(12).setFont(bold);
		doc.add(p17);

		Table table = new Table(26).setFixedLayout();
		table.setFontSize(5);

		String name = "", surname = "", idnum = "", entryDate = "", startDate = "", ofo = "", nqf = "", qualification = "", trainer = companyName,
				privacy = "private", province = "Eastern Cape", municipality = "Amathole District Municipality", area = "East London", areaType = "Urban",
				trainerContacts = managerTel, race = "", gender = "", citizenship = "", age = "", youth = "", disability = "";

		//header columns
		String[] heading = {"OUTCOME  3.3:  INCREASED ACESS TO OCCUPATIONALLY DIRECTED LEARNING PROGRAMMES WITHIN THE MICT SECTOR", "NAMES OF THE LEARNER", "SURNAME OF THE LEARNER", "ID NUMBER OF THE LEARNER", "TYPE OF LEARNING PROGRAMME (LEARNERSHIP)", "DATE THE LEARNER  ENTERED THE LEARNING  PROGRAMMME", "ACTUAL START DATE OF THE LEARNING PROGRAMME", "OFO CODE VERSION 2012", "NQF LEVEL (NQF ACT)", "QUALIFICATION  AS PER OFO CODE/DESCRIPTION OF THE QUALIFICATION", "NAME OF THE EMPLOYER", "EMPLOYER REGISTRATION/SDL NUMBER", "EMPLOYER CONTACT DETAILS", "NAME OF THE TRAINING PROVIDER", "TRAINING PROVIDER AGREDITATION NUMBER", "TRAININING PROVIDER CONTACT DETAILS", "IS TRAINING PROVIDER PRIVATE /PUBLIC (YES/NO)", "LEARNER PROVINCE", "LEARNER LOCAL/DISTRICT MUNICIPALITY", "SPECIFY LEARNER RESIDENTIAL  AREA", "IS THE LEARNER RESIDENTIAL AREA URBAN / RURAL(YES/NO)", "KEY DEVELOPMENT AND TRANSFORMATION IMPERATIVES",
				"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "RACE", "GENDER", "AGE", "DISABILITY", "YOUTH", "NON-RSA CITIZEN"};
		for (int i = 0; i < heading.length; i++) {
			if (i == 0) {
				Cell c10 = new Cell(1, 26).add(new Paragraph(heading[i]));
				c10.setBackgroundColor(LIGHT_GRAY).setFont(bold);
				table.addCell(c10);
			} else if (i == 21) {
				Cell c10 = new Cell(1, 6).add(new Paragraph(heading[i]));
				table.addCell(c10.setBackgroundColor(LIGHT_GRAY).setFont(bold));
			} else {
				Cell c10 = new Cell().add(new Paragraph(heading[i]));
				table.addCell(c10.setBackgroundColor(LIGHT_GRAY).setFont(bold));
			}
		}

		try {
			Database DB = new Database();
			Connection con = DB.getCon1();
			Statement st = con.createStatement();
			st.executeQuery("SELECT DISTINCT (SELECT MAX(applicant_nqf_qualifications.applicant_nqf_level_id) FROM intern_sla AS t3 INNER JOIN applicant_person_qualification_field_of_studies ON applicant_person_qualification_field_of_studies.applicant_id = t3.applicant_id INNER JOIN applicant_nqf_qualifications ON applicant_person_qualification_field_of_studies.applicant_nqf_qualification_id = applicant_nqf_qualifications.id WHERE t3.applicant_id = t1.applicant_id) as nqf, t1.applicant_id, applicant_personal_details.First_Name ,applicant_personal_details.Surname, applicants.id_number, sla.type, (SELECT sla_company_details.company_name FROM sla INNER JOIN sla_company_details ON sla_company_details.id = sla.company_id WHERE sla.id = t1.sla_id) AS company, (SELECT DATE_FORMAT(t4.date,'%d-%b-%y') FROM intern_sla AS t4 WHERE t4.applicant_id = t1.applicant_id AND status_id = 1) AS entryDate, DATE_FORMAT(sla.start_date,'%d-%b-%y') AS start_Date, ofo_code, occupations, IF(applicant_personal_details.applicant_race_id = 1, \"Black\", IF(applicant_personal_details.applicant_race_id = 2,\"Coloured\", IF(applicant_personal_details.applicant_race_id = 3,\"Indian\", IF(applicant_personal_details.applicant_race_id = 4,\"Asian\",\"White\")))) AS race, IF(applicant_personal_details.applicant_gender_id = 1, \"Female\",\"Male\") AS gender, IF(SUBSTR(applicants.id_number,11,1) = 0, \"RSA Citizen\", \"Non-RSA Citizen\") AS citizenship, TIMESTAMPDIFF(YEAR,STR_TO_DATE(SUBSTR(applicants.id_number,1,6),'%y%m%d%'),CURDATE()) AS age , IF(TIMESTAMPDIFF(YEAR,STR_TO_DATE(SUBSTR(applicants.id_number,1,6),'%y%m%d%'),CURDATE()) < 36,\"Yes\",\"No\") AS youth, IF(applicant_disability_types.applicant_disability_id = 2,\"Yes\",\"No\") AS disability,  applicant_qual_status_id as qualStatus FROM intern_sla AS t1 INNER JOIN sla ON t1.sla_id = sla.id INNER JOIN applicants ON t1.applicant_id = applicants.id INNER JOIN sla_ofo_codes ON t1.ofo_code_id = sla_ofo_codes.id INNER JOIN applicant_personal_details ON applicant_personal_details.applicant_id = t1.applicant_id INNER JOIN applicant_disability_types ON applicant_personal_details.applicant_id = applicant_disability_types.applicant_id  INNER JOIN applicant_person_qualification_field_of_studies ON applicant_person_qualification_field_of_studies.applicant_id = t1.applicant_id INNER JOIN applicant_nqf_qualifications ON applicant_person_qualification_field_of_studies.applicant_nqf_qualification_id = applicant_nqf_qualifications.id WHERE sla_id = " + sla_id + " AND (SELECT COUNT(t2.applicant_id) FROM intern_sla AS t2 WHERE t2.applicant_id=t1.applicant_id HAVING COUNT(t2.applicant_id) < 2) = 1 AND applicant_qual_status_id = 1 ORDER BY Surname ASC;");
			ResultSet rs = st.getResultSet();

			while(rs.next()) {
				name = rs.getString("applicant_personal_details.First_Name").trim();
				surname = rs.getString("applicant_personal_details.Surname").trim();
				idnum = rs.getString("applicants.id_number");
				entryDate = rs.getString("entryDate");
				startDate = rs.getString("start_Date");
				ofo = rs.getString("ofo_code");
				nqf = rs.getString("nqf");
				qualification = rs.getString("occupations").trim();
				race = rs.getString("race");
				gender = rs.getString("gender");
				age = rs.getString("age");
				youth = rs.getString("youth");
				disability = rs.getString("disability");
				citizenship = rs.getString("citizenship");
				if (companyName.equalsIgnoreCase("Border ICT & Cabling Service")) {
					privacy = "";
					agredidationNum = "";
					trainerContacts = "";
					trainer = "";
				}
				String[] arr = {new Caps().toUpperCaseFirstLetter(name), new Caps().toUpperCaseSurname(surname),
						idnum, progType, entryDate, startDate, ofo, "Level " + nqf, qualification, companyName, sdlNum, managerTel,
						trainer, agredidationNum, trainerContacts, privacy, province, municipality, area, areaType, race, gender, age, disability, youth, citizenship};
				for (int i = 0; i < arr.length; i++) {
					Cell c1 = new Cell().add(new Paragraph(arr[i]));
					table.addCell(c1);
				}
			}
			doc.add(table);
		} catch (SQLException e) {
			System.out.println(e);
		}
		//learners dropped out
		int in = 0, out = 0;
		try {
			Database DB = new Database();
			Connection con = DB.getCon1();
			Statement st = con.createStatement();
			st.executeQuery("SELECT SUM(IF(ISNULL(applicant_id) = 0 AND status_id = 1 AND (SELECT COUNT(t2.applicant_id) FROM intern_sla AS t2 WHERE t2.applicant_id=t1.applicant_id HAVING COUNT(t2.applicant_id) < 2) = 1, 1, 0)) iin, SUM(IF(ISNULL(applicant_id) = 0 AND status_id = 2 AND TIMESTAMPDIFF(MONTH, date, " + creationDate + ") <= " + months + ",1,0)) oout FROM intern_sla t1 WHERE sla_id = " + sla_id + ";");
			ResultSet rs = st.getResultSet();
			while (rs.next()) {
				in = rs.getInt("iin");
				out = rs.getInt("oout");
			}
			con.close();
		} catch (SQLException e) {
			System.out.println(e);
		}

		String[] array = {"No. of learners attended All lectures", "No. of learners absent", "No. of learners "
				+ "absconded /resigned/dropped", "" + in, "0", "" + out};
		Table table1 = new Table(3).setMarginTop(10).setAutoLayout();
		for (int i = 0; i < array.length; i++) {
			if (i < 3) {
				Cell c1 = new Cell().add(new Paragraph(array[i]));
				c1.setBackgroundColor(LIGHT_GRAY).setFont(bold).setFontSize(10);
				table1.addCell(c1);
			} else {
				Cell c1 = new Cell().add(new Paragraph(array[i] + ""));
				c1.setFont(font).setTextAlignment(TextAlignment.CENTER).setFontSize(8);
				table1.addCell(c1);
			}
		}
		doc.add(table1);
		return form;
	}// </editor-fold>

	// <editor-fold defaultstate="collapsed" desc="section E">
	public static PdfAcroForm addSectionFive(Document doc)
			throws MalformedURLException, SQLException, IOException, ParseException, ServletException {

		PdfFont font = PdfFontFactory.createFont(FontConstants.HELVETICA);
		PdfFont bold = PdfFontFactory.createFont(FontConstants.HELVETICA_BOLD);
		PdfAcroForm form = PdfAcroForm.getAcroForm(doc.getPdfDocument(), true);

		doc.add(new AreaBreak());//new page

		Paragraph p17 = new Paragraph("SECTION E: SIGNIFICANT ACHIEVEMENT THIS QUARTER")
				.setTextAlignment(TextAlignment.LEFT).setFontSize(12).setFont(bold);
		doc.add(p17);

		Paragraph p18 = new Paragraph("Learners have achieved the following:\n").setFontSize(10).setFont(bold);
		List list = new List().setListSymbol("• \t");
		doc.add(p18);
		//		if (achievements.contains("*")) {
		//			String [] parts = achievements.split(Pattern.quote("*"));
		//			for (String str : parts) {
		//				list.add(new ListItem(str));
		//			}
		//			p18.add(list.setPaddingLeft(15).setFontSize(10).setFont(font));
		//		}else {
		doc.add(new Paragraph(achievements).setFont(font).setFontSize(10));
		//		}

		Table table1 = new Table(2).setWidth(320).setHeight(80).setFontSize(10).setMarginTop(50).setAutoLayout();
		String[] entry1 = {"Compiled By", ": " + managerName + " " + managerSurname, "Date", ":  " + myDate, "", "", "Signature",
		": ................................................................."};
		for (int i = 0; i < entry1.length; i++) {
			if (i % 2 != 0) {
				Cell c10 = new Cell().add(new Paragraph(entry1[i])).setFont(font).setBorder(Border.NO_BORDER);
				table1.addCell(c10);
			} else {
				Cell c10 = new Cell().add(new Paragraph(entry1[i])).setFont(font).setWidth(70).setBorder(Border.NO_BORDER);
				table1.addCell(c10);
			}
		}
		doc.add(table1);
		return form;
	}// </editor-fold>

}
