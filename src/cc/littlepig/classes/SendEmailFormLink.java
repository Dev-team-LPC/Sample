package cc.littlepig.classes;

import java.util.Random;

import org.springframework.security.crypto.bcrypt.BCrypt;

public class SendEmailFormLink {
	private static final char[] symbols;

	static {
		StringBuilder tmp = new StringBuilder();
		for (char ch = '0'; ch <= '9'; ++ch) {
			tmp.append(ch);
		}
		for (char ch = 'a'; ch <= 'z'; ++ch) {
			tmp.append(ch);
		}
		symbols = tmp.toString().toCharArray();
	}

	private static final Random random = new Random();

	public static String randomString(int len) {
		char[] buf = new char[len];
		for (int idx = 0; idx < buf.length; ++idx) {
			buf[idx] = symbols[random.nextInt(symbols.length)];
		}
		return new String(buf);
	}

	public static String encryptedHash(String applicant_id, String email, String randomString) {
		email = email + applicant_id + randomString;
		String hash = BCrypt.hashpw(email, GlobalConstants.SALT);
		return hash;
	}
}
