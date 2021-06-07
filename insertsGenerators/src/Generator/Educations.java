
import java.util.ArrayList;
import java.util.Random;

public class Educations {
    static int people = 5000;
    static int majors = 860;
    public static void main(String[] args) {
        int id = 0;
        Random r = new Random();
        for(int i=0;i<people;i++) {
            ArrayList<Integer> noDuplicates = new ArrayList<>();
            while (true) {
                int major = r.nextInt(majors) + 1;
                while (noDuplicates.contains(major)) {
                    major = r.nextInt(majors) + 1;
                }
                noDuplicates.add(major);
                int r2 = r.nextInt(10);
                String degree;
                if(r2 < 3) {
                    degree = "none";
                }else if(r2 < 5) {
                    degree = "bachelor";
                }else if(r2 < 9) {
                    degree = "master";
                }else {
                    degree = "PhD";
                }
                System.out.println("insert into educations (student_id, major_id, degree) " +
                        "values ( " + (i + 1) + ", " + major + ", '" + degree + "' );");
                if(r.nextBoolean()) {
                    break;
                }
            }
        }
    }
}
