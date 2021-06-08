import java.util.Random;

public class Recommendations {
    public static int MANY = 2000;
    public static int companies = 500;
    public static int people = 5000;
    public static void main(String[] args) {
        Random r = new Random();
        for(int i=0;i<MANY;i++) {
            int company = r.nextInt(companies) + 1;
            int recommended = r.nextInt(people) + 1;

            int year = r.nextInt(6) + 2016;
            int month = r.nextInt(12) + 1;
            int day = r.nextInt(28) + 1;


            String date = "'" + year + "-" + month  + "-" + day + "'";

            System.out.println("insert into recommendations (recommender,recommended,role_id,time_of_recommendation) values ( "
            + "randomEmployee(" + company + ", " + date + "), " + recommended + ", " + "randomRole(" + company + ", " + date + ")" + ", " + date + " );");
        }
    }
}
