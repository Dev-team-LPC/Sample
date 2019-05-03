package cc.littlepig.classes;

import java.sql.*;
import java.util.logging.*;

import org.springframework.security.crypto.bcrypt.BCrypt;

import cc.littlepig.databases.Database;
import cc.littlepig.servlets.SendEmail;

public class VerifyEmailLinkHash {
	public boolean isEmailHashValid(String applicant_id, String hash) {
        boolean verified = false;
        try {
            Database DB = new Database();
            Connection con = DB.getCon1();
            Statement st = con.createStatement();
            st.executeQuery("SELECT * FROM sla_emails WHERE applicant_id = "+applicant_id+" AND TIMESTAMPDIFF(DAY, created_at, NOW()) < 6;");
            ResultSet rs = st.getResultSet();
            while (rs.next()) {
                if (rs.getString("link_hash").equals(hash)) {
                    verified = true;
                }
            }
            con.close();
        } catch (SQLException ex) {
            Logger.getLogger(SendEmail.class.getName()).log(Level.SEVERE, null, ex);
        }
        return verified;
    }

    public boolean isEmailLinkValid(String applicant_id, String randomString) {
        // get applicant Id and email random code  
        String email = null;
        boolean verified = false;
        try {
            Database DB = new Database();
            Connection con = DB.getCon1();
            Statement st = con.createStatement();
            st.executeQuery("SELECT email FROM applicants WHERE id = " + applicant_id + ";");
            ResultSet rs = st.getResultSet();
            while (rs.next()) {
                email = rs.getString("email").trim();
            }
            con.close();
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        email = email + applicant_id + randomString;
        String hash = BCrypt.hashpw(email, GlobalConstants.SALT);

        // verify with database
        if (isEmailHashValid(applicant_id, hash)) {
            verified = true;
        }
        return verified;
    }
}
