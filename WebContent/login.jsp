<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.time.LocalDate"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Login</title>
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link href="https://fonts.googleapis.com/css?family=Roboto|Varela+Round" rel="stylesheet">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
        <link rel="shortcut icon" href="http://www.littlepig.cc/wp-content/themes/littlepig/images/favicon.ico?var=xdv53">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css" />
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
        <link rel="stylesheet" href="css/reports-customstyle.css">
    </head>
    <body>
        <div class="container" style="padding-top: 10%;">
            <div class="row justify-content-center">
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <form class="form-signin" action="<%=request.getContextPath()%>/SiteController" method="POST">
                                <div class="text-center mb-4">
                                    <h1 class="h3 mb-3 font-weight-normal">Reports Login </h1>
                                </div>
								
								${message}
								<span id="loader"></span>	
															
                                <div class="form-label-group">
                                    <i class="fa fa-user"></i> <label for="email">Email address</label>
                                    <input type="email" id="email" name="username" class="form-control" placeholder="Email address" required autofocus pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$">
                                </div>

                                <div class="form-label-group">
                                    <i class="fa fa-lock"></i> <label for="password">Password</label>
                                    <input type="password" id="password" name="password" class="form-control" placeholder="Password" required>
                                </div>
                                <input name="action" value="loginVerify" hidden="true"><br>
                                <button class="btn btn-lg btn-primary btn-block" type="submit" onclick="processing()">Sign in</button>
                            </form>
                        </div>
                        <div class="card-footer">         
                            <!-- Sticky Footer -->
                            <footer class="sticky-footer">
                                <div class="copyright text-center">
                                    <span>Copyright © Little Pig <%=LocalDate.now().getYear()%></span>
                                </div>
                            </footer>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
        function processing() {
	        $('#loader').html("<div class='text-center'><span class='spinner-border text-primary' role='status'></span><div>");			
		}	
        </script>
    </body>
</html>