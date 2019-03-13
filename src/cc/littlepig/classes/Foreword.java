package cc.littlepig.classes;

public class Foreword {
    public String getString(String str,String character) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < str.length(); i++) {
            String letter = str.substring(i, i + 1);
            char[] arrayName = str.toCharArray();
            if (!letter.equals(character)) {
                sb.append(arrayName[i]);
            } else {
                break;
            }
        }
        return String.valueOf(sb);
    }
}
