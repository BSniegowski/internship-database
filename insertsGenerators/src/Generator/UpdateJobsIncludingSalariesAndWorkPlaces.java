import java.util.Random;

public class UpdateJobsIncludingSalariesAndWorkPlaces {
    public static int MANY = 1000;
    public static int jobs = 2000;
    public static void main(String[] args) {


        for(int i=1;i<MANY;i++){
            Random r = new Random();
            double factor = r.nextDouble();
            int changed = r.nextInt(jobs) + 1;
            System.out.println("update jobs");
            System.out.println("set salary = " + factor + " * minRangeForRole(role_id)" + " + " + (1-factor) + " * maxRangeForRole(role_id)" );
            System.out.println("where employee = " + changed);
        }
        for(int i=1;i<MANY;i++){
            Random r = new Random();
            int changed = r.nextInt(jobs) + 1;
            int minus = r.nextInt(3);
            System.out.println("update jobs");
            System.out.println("set location_id = 3*((location_id+2)/3) - " + minus);
            System.out.println("where employee = " + changed);
        }
    }
}
