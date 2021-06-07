
import java.util.Random;


public class JobOffers {
    static int MANY = 1000;
    static int roles = 3991;
    public static void main(String[] args) {
        //System.out.println(citiesArray.length);
        for(int i=0;i<MANY;i++){
            Random random1 = new Random();

            int role_id = random1.nextInt(roles) + 1;
            int minus = random1.nextInt(3);

            int year = random1.nextInt(6) + 2016;
            int month = random1.nextInt(12) + 1;
            int day = random1.nextInt(28) + 1;
            int end_year = year + random1.nextInt(3);
            int end_month = random1.nextInt(12) + 1;
            int end_day = random1.nextInt(28) + 1;

            if(end_year==year && ((end_month == month && end_day < day) || end_month < month) ) {
                int temp = month;
                month = end_month;
                end_month = temp;

                temp = day;
                day = end_day;
                end_day = temp;
            }


            System.out.println("insert into job_offers (id, role_id, work_place_id, start_of_search, end_of_search) " +
                    "values ( " + (i+1) +", "+ role_id + ", 3*companyOfRole(" + role_id + ") - " + minus  + ", '" + year + "-" + month  + "-" + day +
                    "\', \'" + end_year + "-" + end_month  + "-" + end_day  + "' );" );
        }
    }
}
