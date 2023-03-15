<%@ page language="java" import="java.sql.*"
	contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Your Movie Results</title>
<link href="./css/searchResults.css" rel="stylesheet" type="text/css"/>
</head>
<body>
	<h1 align="center"> Movie Result</h1>
	<%!String keyword;%>
	<%!String name;%>
	<%!String year; %>
	<%!String desc; %>
	<%!int updateQuery; %>
	<%keyword = request.getParameter("keyword");
	  name = request.getParameter("name");
	  year = request.getParameter("year");
	  desc = request.getParameter("desc");
	  updateQuery = 0;

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			System.out.println("Where is your MySQL JDBC Driver?");
			e.printStackTrace();	
		}

		System.out.println("MySQL JDBC Driver Registered!");
		Connection connection = null;

		try {
			connection = DriverManager.getConnection("jdbc:mysql://ec2-54-157-167-254.compute-1.amazonaws.com:3306/movieDB?useSSL=false", "newmysqlremoteuser", "mypassword");
		} catch (SQLException e) {
			System.out.println("Connection Failed! Check output console");
			e.printStackTrace();	
		}


		PreparedStatement selectStmt = null;
		PreparedStatement insertStmt = null;

		try {

			if((name != null) && (year != null) && (desc != null)) {
				if(name!="" && year!="" && desc!="") {
					try {
						String insertSQL = "INSERT INTO movies(name, year, description) VALUES (?, ?, ?)";
						insertStmt = connection.prepareStatement(insertSQL);
						insertStmt.setString(1, name);
						insertStmt.setString(2, year);
						insertStmt.setString(3, desc);
						updateQuery = insertStmt.executeUpdate();
						
						
						if(updateQuery == 0) {
							System.out.println("Insert into table couldn't be completed.");
						}
						
					} catch(Exception e) {
						e.printStackTrace();
					}
				}
		
			}
			
			if((keyword == null)) {
				String selectSQL = "SELECT * FROM movies";
				selectStmt = connection.prepareStatement(selectSQL);
			} else if (keyword.isEmpty()) {
				String selectSQL = "SELECT * FROM movies";
				selectStmt = connection.prepareStatement(selectSQL);
			} else {
				String selectSQL = "SELECT * FROM movies WHERE name LIKE ?";
				String theMovie = "%" + keyword + "%";
				selectStmt = connection.prepareStatement(selectSQL);
				selectStmt.setString(1, theMovie);
			}
			
			ResultSet rs = selectStmt.executeQuery();
			
				if(rs.next()==false) {
					System.out.println("No records found in the tables");
				} else {%>
					<table>
						<tr>
							<th>Movie Name</th>
							<th>Year</th>
							<th>Description</th>
						</tr>
						<% do { %>
						<tr>
							<td><%= rs.getString("name") %></td>
							<td><%= rs.getString("year") %></td>
							<td><%= rs.getString("description") %></td>
						</tr>
					<% } while(rs.next()); %>
					</table> 
		<% }} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (selectStmt != null) {
					selectStmt.close();
				}
				if (insertStmt != null) {
					insertStmt.close();
				}
				if (connection != null) {
					connection.close();
				}
			} catch(SQLException e) {
				e.printStackTrace();
			}
		}%>

	<a href=/webprojectCSCI4830-TProj-dubas/searchJSP.html>Search Data</a> <br>
</body>
</html>