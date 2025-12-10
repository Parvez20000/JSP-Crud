<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>

<%
    // Insert logic
    if (request.getParameter("submit") != null) {
        String name   = request.getParameter("stname");
        String course = request.getParameter("course");
        String fee    = request.getParameter("fee");

        Connection con = null;
        PreparedStatement pst = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");     
            pst = con.prepareStatement("INSERT INTO pkrecord(stname, course, fee) VALUES (?, ?, ?)");
            pst.setString(1, name);
            pst.setString(2, course);
            pst.setString(3, fee);
            int row = pst.executeUpdate();
            if (row > 0) {
%>
<script>alert("Record Added Successfully!");</script>
<%
            } else {
%>
<script>alert("Record NOT added.");</script>
<%
            }
        } catch (Exception e) {
%>
<script>alert("Error: <%= e.getMessage().replace("\"","\\\"") %>");</script>
<%
        } finally {
            if (pst != null) try { pst.close(); } catch (SQLException ex) {}
            if (con != null) try { con.close(); } catch (SQLException ex) {}
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Registration CRUD - JSP + MySQL</title>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
</head>
<body>
    <div class="container mt-5">
        <h2>Student Registration System (JSP + MySQL)</h2>
        <hr>

        <div class="row">
            <!-- Form -->
            <div class="col-sm-4">
                <form method="POST" action="">
                    <div class="mb-3">
                        <label for="stname" class="form-label">Student Name</label>
                        <input type="text" class="form-control" name="stname" id="stname" placeholder="Enter Name" required>
                    </div>

                    <div class="mb-3">
                        <label for="course" class="form-label">Course</label>
                        <input type="text" class="form-control" name="course" id="course" placeholder="Enter Course" required>
                    </div>

                    <div class="mb-3">
                        <label for="fee" class="form-label">Fee</label>
                        <input type="text" class="form-control" name="fee" id="fee" placeholder="Enter Fee" required>
                    </div>

                    <div class="mb-3">
                        <input type="submit" name="submit" id="submit" value="Submit" class="btn btn-info">
                        <input type="reset" id="reset" value="Reset" class="btn btn-warning">
                    </div>
                </form>
            </div>

            <!-- Table -->
            <div class="col-sm-8">
                <div class="panel-body">
                    <table id="tbl-record" class="table table-bordered table-responsive" cellpadding="0" width="100%">
                        <thead>
                            <tr>
                                <th>Student Name</th>
                                <th>Course</th>
                                <th>Fee</th>
                                <th>Edit</th>
                                <th>Delete</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            Connection con2 = null;
                            PreparedStatement pst2 = null;
                            ResultSet rs2 = null;
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                con2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
                                pst2 = con2.prepareStatement("SELECT id, stname, course, fee FROM pkrecord");
                                rs2 = pst2.executeQuery();
                                while (rs2.next()) {
                                    int id     = rs2.getInt("id");
                                    String nm  = rs2.getString("stname");
                                    String cr  = rs2.getString("course");
                                    String fe  = rs2.getString("fee");
                        %>
                            <tr>
                                <td><%= nm %></td>
                                <td><%= cr %></td>
                                <td><%= fe %></td>
                                <td><a href="edit.jsp?id=<%= id %>">Edit</a></td>
                                <td><a href="delete.jsp?id=<%= id %>" onclick="return confirm('Are you sure?');">Delete</a></td>
                            </tr>
                        <%
                                }
                            } catch (Exception e) {
                        %>
                            <tr><td colspan="5">Error loading records: <%= e.getMessage() %></td></tr>
                        <%
                            } finally {
                                if (rs2   != null) try { rs2.close();   } catch(SQLException ex) {}
                                if (pst2  != null) try { pst2.close();  } catch(SQLException ex) {}
                                if (con2  != null) try { con2.close();  } catch(SQLException ex) {}
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>
</body>
</html>
