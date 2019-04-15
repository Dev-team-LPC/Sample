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
        try {
            Database DB = new Database();
            Connection con = DB.getCon1();
            Statement st = con.createStatement();
            st.executeQuery("SELECT IF(SUM(ISNULL(learner_experience)) >= 1 OR ISNULL(SUM(ISNULL(learner_experience))) >= 1, 1, 0) learner_experience, IF(SUM(ISNULL(findings)) >= 1 OR ISNULL(SUM(ISNULL(findings))) >= 1, 1, 0) findings FROM sla_email WHERE sla_id = " + sla + " AND TIMESTAMPDIFF(DAY, email_date, NOW()) < 6;");
            ResultSet rs = st.getResultSet();
            if (rs.next()) {
                isExpEmpty = rs.getInt("learner_experience");
                isFyndEmpty = rs.getInt("findings");
            }
            con.close();
        } catch (SQLException e) {
            System.out.println(e);
        }
        if (isExpEmpty == 1) {
            letter = 'a';
        } else if (isFyndEmpty == 1) {
            letter = 'b';
        } else {
            letter = 'c';
        }
        return letter;
    }
}
