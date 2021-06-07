
import java.util.Random;

public class Majors {
    static int unis = 100;
    static int fields = 25;
    public static void main(String[] args) {
        int id = 0;
        Random r = new Random();
        for(int i=1;i<unis;i++){
            int field_id = 1;
            while (true) {
                if(field_id > fields) {
                    break;
                }
                id++;
                System.out.println("insert into majors (id, university_id, field_id) " +
                        "values ( " + id + ", " + (i + 1) + ", " + field_id + " );");
                field_id += (r.nextInt(5) + 1);
            }
        }
    }
}
