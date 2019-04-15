<%@ page import="cc.littlepig.databases.Database"%>
<%@ page import="cc.littlepig.classes.VerifyEmailLinkHash"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.sql.*"%>
<%
    String applicant_id = request.getParameter("applicant_id");
    String randomString = request.getParameter("hash");
    VerifyEmailLinkHash velh = new VerifyEmailLinkHash();
    if (velh.isEmailLinkValid(applicant_id, randomString)) {
        int isEmpty = 1;
        try {
            Database DB = new Database();
            Connection con = DB.getCon1();
            Statement st = con.createStatement();
            st.executeQuery("SELECT IF(SUM(ISNULL(learner_highlights)) >= 1 OR ISNULL(SUM(ISNULL(learner_highlights))) >= 1, 1, 0) learner_experience FROM sla_email WHERE applicant_id = " + applicant_id + " AND TIMESTAMPDIFF(DAY, email_date, NOW()) < 6;");
            ResultSet rs = st.getResultSet();
            if (rs.next()) {
                isEmpty = rs.getInt("learner_experience");
            }
            con.close();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        if (isEmpty == 1) {
%>
<!DOCTYPE html>
<html>
    <head>
        <title> Questionnaire - Site Visit Report </title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width">
        <title>E-mail Responses</title>
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">  		
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link href="https://fonts.googleapis.com/css?family=Roboto|Varela+Round" rel="stylesheet">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
        <!-- datepicker -->        
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>        
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css" />
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
        <link rel="stylesheet" href="css/reports-customstyle.css">
    </head>
    <body class="bg">
        <header class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
            <a class="navbar-brand" href="http://www.littlepig.cc">
                <img src="images/logotop.png" width="100" height="30" class="d-inline-block align-top">
            </a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
        </header>
        <main role="main" class="container" style="padding-top: 9%; width: inherit;">
            <div class="jumbotron">
                <div>
                    <h1 class="display-6">Questionnaire</h1>
                    <p style="color: grey;"> Please fill all the form fields below to submit the form</p>
                    <hr class="my-9">
                </div>  
                <form method="POST" action="<%=request.getContextPath()%>/Emails?action=email-form-response">
                    <script>
                        //validate textarea input
                        function clean(el) {
                            var textfield = document.getElementById(el);
                            var regex = /[^a-z 0-9?!.,#%&()"':/\-]/gi;
                            if (textfield.value.search(regex) > -1) {
                                textfield.value = textfield.value.replace(regex, "");
                            }
                        }
                        //count remaining characters
                        function charCountr(display, textbox) {
                            var text_max = 300;
                            $('#' + display).html(text_max + ' remaining');
                            $('#' + textbox).keyup(function () {
                                var text_length = $('#' + textbox).val().length;
                                var text_remaining = text_max - text_length;
                                $('#' + display).html(text_remaining + ' remaining');
                            });
                        }
                    </script>
                    <input type="hidden" name="applicant_id" value="<%=applicant_id%>">
                    <div class="form-group shadow-textarea">
                        <label for="experience">What major activities have you done in the last 3 months and what tools/software have you used?</label>
                        <textarea name="experience" class="form-control" minlength="50" maxlength="300" id="experience" onkeyup="clean('experience'), charCountr('textCountB', 'experience')" onkeydown="clean('experience')" rows="4" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 50 and not exceed 300." 
                                  placeholder="I created online surveys using SurveyMonkey, worked on tender applications and submissions, research and presentations, and got a scrum certification."></textarea>
                        <div id="textCountB" style="font-size: small;"></div>
                    </div>
                    <div class="form-group shadow-textarea">
                        <label for="feedback">What skills do you think you have acquired and/or what have you achieved?</label>
                        <textarea name="feedback" class="form-control" minlength="50" maxlength="300" id="feedback" onkeyup="clean('experience'), charCountr('textCountA', 'feedback')" onkeydown="clean('experience')" rows="4" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 50 and not exceed 300." 
                                  placeholder="I learnt how to use SurveyMonkey and create online surveys. I also attained a Scrum fundamentals and Scrum Master certification."></textarea>
                        <div id="textCountA" style="font-size: small;"></div>
                    </div>
                    <div class="form-group shadow-textarea">
                        <label for="highlights">Can you list the outstanding parts (highlights) of the activities you did/were part of this in the last 3 months</label>
                        <textarea name="highlights" class="form-control" minlength="50" maxlength="300" id="highlights" onkeyup="clean('highlights'), charCountr('textCountC', 'highlights')" onkeydown="clean('highlights')" rows="4" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 50 and not exceed 300."  
                                  placeholder="Passed scrum 3 (scrum master certification). Did presentations on AI, Google Services, and Computer chips. Published newsletters"></textarea>
                        <div id="textCountC" style="font-size: small;"></div>
                    </div>
                    <div class="form-group shadow-textarea">
                        <label for="challenges">What challenges have you faced while doing your activities and why?</label>
                        <textarea name="challenges" class="form-control" minlength="50" maxlength="300" id="challenges" onkeyup="clean('challenges'), charCountr('textCountD', 'challenges')" onkeydown="clean('challenges')" rows="4" required spellcheck="true" title="Only letters [A to z], numbers [0 to 9] and special characters ? !  . ) , # ( % & : ' - / can be used. The number of characters should be at least 50 and not exceed 300." 
                                  placeholder="Researching and learning about computer chips was troubling because I did not get enough information. Learning scrum was difficult because I had to also focus on other tasks, there was too much pressure"></textarea>
                        <div id="textCountD" style="font-size: small;"></div>
                    </div>
                    <div class="text-center">
                    	<button class=" btn btn-md btn-success btn-outline-success" type="submit" onclick="return confirm('Are you sure you want to submit your answers?')">
                        	<i class="fa fa-send"></i> submit
                 	    </button>
                    </div>
                </form>
            </div>
    </main>
</body>
</html>
<%} else {%>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <title>link expired</title>
        <link rel="stylesheet" href="css/reports-customstyle.css">
    </head>  
    <body class="bg">
        <nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
            <a class="navbar-dark">
                <img src="images/logotop.png" width="100" height="30" class="d-inline-block align-top" alt="">
            </a>
        </nav>
        <script>
            alert('Form already submitted!');
            location.replace("http://www.littlepig.cc/");
        </script>
    </body>
</html>
<%
    }
} else {%>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <title>link expired</title>
		<link rel="stylesheet" href="css/reports-customstyle.css">
    </head>  
    <body class="bg">
        <nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
            <a class="navbar-dark">
                <img src="images/logotop.png" width="100" height="30" class="d-inline-block align-top" alt="">
            </a>
        </nav>
        <script>
            alert('The e-mail link you are trying to access has expired or is invalid!');
            location.replace("http://www.littlepig.cc/");
        </script>
    </body>
</html>
<%}%>