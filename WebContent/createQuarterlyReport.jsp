<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="cc.littlepig.databases.Database"%>
<%@ page import="cc.littlepig.classes.Foreword"%>
<%@ page import="cc.littlepig.classes.Caps"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.time.LocalDate"%>
<%@page import="java.sql.*"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quarterly Report Generation</title>
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link href="https://fonts.googleapis.com/css?family=Roboto|Varela+Round" rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css" />
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
<link rel="stylesheet" href="css/reports-customstyle.css">
</head>
<body>
<%!public static String mentor, months, sla_id, creationDate, learnrCount = "", sla_name = "", companyName = "", 
progType = "", managerName = "", managerSurname = "", managerTel = "", managerSign = "", sdlNum = "", agredidationNum = "", 
startDate = "", endDate = "", logo = "", managerCell = "", managerMail = "", managerAddr = ""; %>
<%
months = new Foreword().getString(request.getParameter("months"), " ");
sla_id = new Foreword().getString(request.getParameter("sla"), ".");
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM uuuu");
creationDate = formatter.format(LocalDate.parse(request.getParameter("creationDate")));

try {
    Database DB = new Database();
    Connection con = DB.getCon1();
    Statement st = con.createStatement();
    st.executeQuery("SELECT t1.Name, t1.type, t1.number_of_learners, DATE_FORMAT(t1.start_date,'%d %M %Y') start_date, DATE_FORMAT(t1.end_date,'%d %M %Y') end_date, t2.company_name, t2.registration_number, t2.agredidation_number, t2.logo, t2.address, t2.representative_employer_name, t2.representative_employer_surname, t3.name, t3.surname, t3.cellphone, t3.telephone, t3.email FROM sla t1 INNER JOIN sla_company_details t2 ON t2.id = t1.company_id INNER JOIN sla_project_manager t3 ON t3.id = t2.project_manager_id WHERE t1.id = " + sla_id + ";");
    ResultSet rs = st.getResultSet();

    while (rs.next()) {
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
%>
<h1>SECTION A: LEARNERSHIP DETAILS</h1><br>
	<table class="table table-sm">
		<tr>
			<td>Programme</td>
			<td>: <input name="programme" type="text" value="<%=progType%>"></td>
		</tr>
		<tr>
			<td>SLA number</td>
			<td>: <input name="sla" type="text" value="<%=sla_name%>"></td>
		</tr>
		<tr>
			<td><%=new Caps().toUpperCaseFirstLetter(progType)%> NQF Level</td>
			<td>: <input name="nqf" type="text" value="Level 5"></td>
		</tr>
		<tr>
			<td>Report Period (Quarter)</td>
			<td>: <input name="quarter" type="text" value=""></td>
		</tr>
		<tr>
			<td>Employer’s Name</td>
			<td>: <input name="company" type="text" value="<%=companyName%>"></td>
		</tr>
		<tr>
			<td>Date of quarterly report</td>
			<td>: <input name="creationDate" type="date" value="<%=creationDate%>"></td>
		</tr>
		<tr>
			<td>Start date</td>
			<td>: <input name="startDate" type="date" value="<%=startDate%>"></td>
		</tr>
		<tr>
			<td>End date</td>
			<td>: <input name="endDate" type="date" value="<%=endDate%>"></td>
		</tr>
	</table>
	
	<table class="table table-sm">
		<tr>
			<td>Project Manager Full Name</td>
			<td>: <input name="managerName" type="text" value="<%=managerName%>"></td>
		</tr>
		<tr>
			<td>Project Manager Surname</td>
			<td>: <input name="managerSurname" type="text" value="<%=managerSurname%>"></td>
		</tr>		
	</table>
	
	<table class="table table-sm">
		<tr>
			<td>Project manager telephone no.</td>
			<td>: <input name="managerTel" type="tel" value="<%=managerTel%>"></td>
		</tr>
		<tr>
			<td>Project manager cell</td>
			<td>: <input name="managerCell" type="tel" value="<%=managerCell%>"></td>
		</tr>
		<tr>
			<td>e-mail address</td>
			<td>: <input name="managerMail" type="text" value="<%=managerMail%>"></td>
		</tr>
		<tr>
			<td>Company’s Physical address</td>
			<td>: <input name="managerAddr" type="text" value="<%=managerAddr%>"></td>
		</tr>
	</table>
	<br>
	<h1>SECTION B: LEARNERSHIP QUARTER OVERVIEW</h1><br/>
	<h4>Introduction</h4>
	<div class="form-group shadow-textarea">
		<textarea name="introduction" id="introduction" class="form-control" minlength="30"
			maxlength="300" onkeyup="clean('introduction'), charCountr('textCountB', 'introduction')"
			onkeydown="clean('introduction')" rows="4" cols="100" required spellcheck="true"
			title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300."
			required>This report comprises the fourth and final report for <%=companyName%>’s internship programme on Contract Number: <%=sla_name%>. It reviews the outcomes of assignments that the interns had been working on.
		</textarea>
	</div>
	<i><div id="textCountB" style="font-size: small;"></div></i>
	
	<h4>Project Implementation Methodology</h4>
	<div class="form-group shadow-textarea">
		<textarea name="introduction" id="introduction" class="form-control" minlength="30"
			maxlength="300" onkeyup="clean('introduction'), charCountr('textCountB', 'introduction')"
			onkeydown="clean('introduction')" rows="2" cols="100" required spellcheck="true"
			title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300."
			required>The project implementation methodology adopted by <%=companyName%> is Scrum. It is a lightweight Agile project management framework that focuses on a collaborative, iterative and incremental approach for the development of a product or service.
		</textarea>
	</div>
	<i><div id="textCountB" style="font-size: small;"></div></i>

	<h4>Scrum Diagram</h4>
		*scrum diagram here*
		
	<h4>The Scrum Framework implements the cornerstones defined by the Agile Manifesto which emphasises the value of:</h4>
	<div class="form-group shadow-textarea">
		<textarea name="introduction" id="introduction" class="form-control" minlength="30"
			maxlength="300" onkeyup="clean('introduction'), charCountr('textCountB', 'introduction')"
			onkeydown="clean('introduction')" rows="5" cols="100" required spellcheck="true"
			title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300."
			required>• Individuals and interactions (communication) over processes and tools
• Working software over comprehensive documentation
• Customer collaboration over contract negotiation
• Responding to change over following a plan
		</textarea>
	</div>
	<i><div id="textCountB" style="font-size: small;"></div></i>
		<h4>The main components of Scrum Framework are:</h4>
	<div class="form-group shadow-textarea">
		<textarea name="introduction" id="introduction" class="form-control" minlength="30"
			maxlength="300" onkeyup="clean('introduction'), charCountr('textCountB', 'introduction')"
			onkeydown="clean('introduction')" rows="5" cols="100" required spellcheck="true"
			title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300."
			required>• The three roles: Scrum Product Owner, Scrum Master and the Scrum Team
• A prioritized Backlog containing the end user requirements
• Sprints
• Scrum Events: Sprint Planning Meeting (WHAT-Meeting, HOW-Meeting), Daily Scrum Meeting, Sprint Review Meeting, Sprint Retrospective Meeting.
		</textarea>
	</div>
	<i><div id="textCountB" style="font-size: small;"></div></i>
	<br>
		<div class="form-group shadow-textarea">
		<textarea name="introduction" id="introduction" class="form-control" minlength="30"
			maxlength="300" onkeyup="clean('introduction'), charCountr('textCountB', 'introduction')"
			onkeydown="clean('introduction')" rows="20" cols="100" required spellcheck="true"
			title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300."
			required>Important in all Scrum projects are self-organization and communication within the team. In the Scrum Framework the
Scrum Product Owner and the Scrum Master share the responsibilities that would otherwise be those of a project
manager in a classical sense.

However, in the end, the team decides what and how much they can do in a given Sprint, which typically is a period of
between 2 - 4 weeks. The importance of this is that it maximises release output, while making sure that errors are identified early enough for direction to be modified where deemed necessary.

Another cornerstone of the Scrum Framework is communication. To this effect, Scrum consists of a daily stand-up
meeting that is time-boxed to 15 minutes (Daily Scrum). In the meeting, each team member answers the following 3
questions:
	1. What they did the day before?
	2. What they plan to achieve today?
	3. Do they foresee any obstacles?
In the end, the Scrum Framework itself is very simple. It defines only some general guidelines with only a few rules,
roles, artifacts and events. However each of these components is important, it serves a specific purpose and is
essential for a successful usage of the framework.
		</textarea>
	</div>
	<i><div id="textCountB" style="font-size: small;"></div></i>
	
	<h4>Strategic Plan</h4>
		<div class="form-group shadow-textarea">
		<textarea name="introduction" id="introduction" class="form-control" minlength="30"
			maxlength="300" onkeyup="clean('introduction'), charCountr('textCountB', 'introduction')"
			onkeydown="clean('introduction')" rows="10" cols="100" required spellcheck="true"
			title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300."
			required>
The programme is in the XXXXX quarter so far it is going well. Of the original intake of 45 interns, XX interns have been employed somewhere else. And a replacement was taken on. All interns are working on various projects as mentioned in the work plan section below.

Evaluating and Monitoring the interns will continue to be a major aspect of <%=companyName%>’s contribution to their empowerment and preparation for meaningful employment, hopefully internally and definitely externally. The monthly assessments carried out ensure that the work and projects they have been engaged in are effective and of high quality. They also give the company, through mutual feedback, ideas on how to improve things for the current and prospective interns’ intake.
		</textarea>
	</div>
	<i><div id="textCountB" style="font-size: small;"></div></i>
		<h4>Work Placement</h4>
		<div class="form-group shadow-textarea">
		<textarea name="introduction" id="introduction" class="form-control" minlength="30"
			maxlength="300" onkeyup="clean('introduction'), charCountr('textCountB', 'introduction')"
			onkeydown="clean('introduction')" rows="8" cols="100" spellcheck="true"
			title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 30 and not exceed 300."
			required>
Most of our interns are currently placed at different partner companies to broaden their skills and expertise in a different context. They are given different projects to work on and we monitor them every month by doing weekly reports, monthly assessments and we do site visits.

The company, through <%=companyName%> Recruitment Agency, is vigorously searching for job opportunities for, and encouraging the remaining interns to apply for those work openings that have been identified. The endeavour is ongoing.		</textarea>
	</div>
	<i><div id="textCountB" style="font-size: small;"></div></i>
	<br>
	<h2>SECTION C:  LESSON PLAN TIME SCHEDULE</h2>
	<p>Activities which are undertaken for <u><b>workplace</b></u> learning; when and how these were done in this quarter.</p>
	<script>
		$(document).ready(function() {
			$("#activityTable").on('click', '.btnDelete', function() {
				if (confirm("Are you sure you want to delete this row?")) {
					$(this).closest('tr').remove();
				}
			});
		});
	</script>
	<table class="table table-sm table-responsive table-light table-hover" id="activityTable">
		<thead class="table-bordered" style="background-color: #d6d8d9; color: #1b1e21; border: 1px solid #c0c8ca;">
			<tr>
				<th>Date
				[name]</th>
				<th>Activity</th>
				<th>Learning Outcome</th>
				<th>Mentor / Coach</th>
				<th>Department</th>
				<th>Action Required</th>
				<th>Due Date <br>By When?</th>
				<th>Remove Row</th>
			</tr>
		</thead>
		<tbody>
	<%
		String activityDate = "", activityName = "", learningOutcome = "Be able to / to do ", department = "ICT department", requiredAction = "", dueDate = "";
			try {
		Database DB = new Database();
		Connection con = DB.getCon1();
		Statement st = con.createStatement();
		st.executeQuery("SELECT applicant_personal_details.applicant_id, applicant_personal_details.First_Name, "
						+ "applicant_personal_details.Surname, applicants.id_number, tasks.Task_Name, tasks.Task_Percentage, "
						+ "DATE_FORMAT(reports.Report_Date,'%d/%m/%Y') as Report_Date, DATE_FORMAT(SUBDATE(reports.Report_Date, "
						+ "INTERVAL 4 DAY),'%d/%m/%Y') as Actual_Date FROM intern_sla "
						+ "INNER JOIN applicant_personal_details ON intern_sla.applicant_id = applicant_personal_details.applicant_id "
						+ "INNER JOIN applicants ON applicants.id = intern_sla.applicant_id "
						+ "INNER JOIN activity.users ON users.id_number = applicants.id_number "
						+ "INNER JOIN activity.reports ON reports.user_id = users.id "
						+ "INNER JOIN activity.tasks ON reports.id = tasks.report_id " + "WHERE sla_id = "
						+ sla_id + " AND TIMESTAMPDIFF(MONTH, reports.Report_Date, NOW()) <= " + months
						+ " AND Task_Percentage = 100 ORDER BY applicant_personal_details.applicant_id ASC;");
		ResultSet rs = st.getResultSet();
		int count = 0;
		while (rs.next()) {
			count++;
			String name = new Caps().toUpperCaseFirstLetter(rs.getString("First_Name").trim());
			String surname = new Caps().toUpperCaseSurname(rs.getString("Surname").trim());
			name += " " + surname;
			dueDate = rs.getString("Report_Date");
			activityDate = rs.getString("Actual_Date");
			activityName = rs.getString("tasks.Task_Name");
			requiredAction = rs.getString("tasks.Task_Name");
				out.print("<tr id='tr"+count+"'>");
				out.print("<td><textarea id='txtAa"+count+"' rows='5' cols='10' required spellcheck='true'>" +count +" " + activityDate + "\n\n[" + name + "]</textarea></td>");
				out.print("<td><textarea id='txtAb"+count+"' rows='5' cols='30' required spellcheck='true'>" +count +" " + activityName + "</textarea></td>");
				out.print("<td><textarea id='txtAc"+count+"' rows='5' cols='30' required spellcheck='true'>" +count +" " + learningOutcome + activityName + "</textarea></td>");
				out.print("<td><textarea id='txtAd"+count+"' rows='5' cols='15' required spellcheck='true'>" +count +" " + mentor + "</textarea></td>");
				out.print("<td><textarea id='txtAe"+count+"' rows='5' cols='15' required spellcheck='true'>" +count +" " + department + "</textarea></td>");
				out.print("<td><textarea id='txtAf"+count+"' rows='5' cols='20' required spellcheck='true'>" +count +" " + requiredAction + "</textarea></td>");
				out.print("<td><textarea id='txtAg"+count+"' rows='5' cols='10' required spellcheck='true'>" +count +" " + dueDate + "</textarea></td>");
				out.print("<td><button class='btnDelete'>delete</button></td>");
				out.print("</tr>");
			}
		} catch (SQLException e) {
			out.println(e);
		}
	%>
		</tbody>
	</table>

	<br>
	<button onclick="window.history.go(-1);">back</button>
</body>
</html>