package cc.littlepig.databases;

import java.sql.*;
import java.util.logging.*;

public class Database {

    Connection con;

    public Connection getCon1() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/applicant_v2_production", "root", "gr00t@MySQL");
//            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/applicant_v2_production", "monwabisi", "littlepig123");
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(Database.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println(ex);
            System.err.println("Cannot connect to server");
        }
        return con;
    }

    public Connection getCon2() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/activity", "root", "gr00t@MySQL");
//            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/activity", "monwabisi", "littlepig123");
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(Database.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println(ex);
            System.err.println("Cannot connect to server");

        }
        return con;
    }
}

