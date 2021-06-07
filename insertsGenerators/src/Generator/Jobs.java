import java.util.Random;

public class Jobs {
    static int MANY = 10000;
    static int roles = 3991;
    static int people = 5000;
    public static void main(String[] args) {


        for(int i=0;i<MANY;i++){
            Random r = new Random();

            int person_id = r.nextInt(people) + 1;
            int role_id = r.nextInt(roles) + 1;
            int minus = r.nextInt(3);

            int year = r.nextInt(6) + 2015;
            int month = r.nextInt(12) + 1;
            int day = r.nextInt(28) + 1;
            int end_year = year + r.nextInt(3);
            int end_month = r.nextInt(12) + 1;
            int end_day = r.nextInt(28) + 1;
            double factor = r.nextDouble();

            if(end_year==year && ((end_month == month && end_day < day) || end_month < month) ) {
                int temp = month;
                month = end_month;
                end_month = temp;

                temp = day;
                day = end_day;
                end_day = temp;
            }


                System.out.println("insert into jobs (job_id, role_id, employee, location_id, starting_date, ending_date,salary) " +
                        "values ( " + (i+1) + ", " + role_id + ", " + person_id + ", " + "3*companyOfRole(" + role_id + ") - " + minus  + ", '"
                        + year + "-" + month  + "-" + day + "', '" + end_year + "-" + end_month  + "-" + end_day
                        +  "', " + factor + " * minRangeForRole(" + role_id + ")" + " + " + (1-factor) + " * maxRangeForRole(" + role_id + ") );");
            }
        }
}
