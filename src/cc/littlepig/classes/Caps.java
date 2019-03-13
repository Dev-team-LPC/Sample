package cc.littlepig.classes;

public class Caps {
	public String toUpperCaseFirstLetter(String string) {
		string = string.substring(0, 1).toUpperCase() + string.substring(1).toLowerCase();
		return string;
	}

	//capitalise last word on surnames with two/more words
	public String toUpperCaseSurname(String string) {
		int letterCount = 0, pos;
		String letter, surname1 = "";

		for (int i = 0; i < string.length(); i++) {
			letter = string.substring(i, i + 1);
			if (letter.equals(" ")) {
				letterCount++;
				pos = i + 2;
				surname1 = string.substring(0, i + 1) + string.substring(pos - 1, pos).toUpperCase() + string.substring(pos);
			}
		}
		if (letterCount == 0) {
			surname1 = string.substring(0, 1).toUpperCase() + string.substring(1);
		}
		return surname1;
	}
}
