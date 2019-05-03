package cc.littlepig.classes;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import cc.littlepig.databases.Database;

public class EmptyChecker {

	public char isEmailsEmpty(String sla) {
        char letter;
        int isExpEmpty = 1;
        int isFyndEmpty = 1;
        int emailCount = 0;
        try {
            Database DB = new Database();
            Connection con = DB.getCon1();
            Statement st = con.createStatement();
            st.executeQuery("SELECT IF(SUM(ISNULL(learner_experience)) >= 1 OR ISNULL(SUM(ISNULL(learner_experience))) >= 1, 1, 0) learner_experience, IF(SUM(ISNULL(findings)) >= 1 OR ISNULL(SUM(ISNULL(findings))) >= 1, 1, 0) findings, COUNT(*) emailCount FROM sla_emails WHERE sla_id = "+sla+" AND TIMESTAMPDIFF(DAY, created_at, NOW()) < 6;");
            ResultSet rs = st.getResultSet();
            if (rs.next()) {
                isExpEmpty = rs.getInt("learner_experience");
                isFyndEmpty = rs.getInt("findings");
                emailCount = rs.getInt("emailCount");
            }
            con.close();
        } catch (SQLException e) {
            System.out.println(e);
        }
        if (isExpEmpty == 1 && isFyndEmpty == 1 && emailCount == 0) {
        	letter = 'd';
        } else if(emailCount == 1 && isExpEmpty == 1 && isFyndEmpty == 1) {
            letter = 'e';
        } else if(isExpEmpty == 1 && emailCount > 1) {
        	letter = 'a';
        } else if (isFyndEmpty == 1 && isExpEmpty == 0 && emailCount > 1) {
            letter = 'b';
        } else {
            letter = 'c';
        }
        return letter;
    }
}
