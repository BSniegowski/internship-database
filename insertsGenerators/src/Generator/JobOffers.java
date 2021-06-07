package Generator;

import java.util.Random;


public class JobOffers {
    static int MANY = 1000;
    public static void main(String[] args) {
        //System.out.println(citiesArray.length);
        for(int i=1;i<MANY;i++){
            Random random1 = new Random();

            int r1 = random1.nextInt(53) + 1;
            int year = random1.nextInt(6) + 2015;
            int month = random1.nextInt(12) + 1;
            int day = random1.nextInt(28) + 1;
            int end_year = year + random1.nextInt(3);
            int end_month = random1.nextInt(12) + 1;
            int end_day = random1.nextInt(28) + 1;
            String premium;
            boolean isNull = random1.nextBoolean();
            if(isNull){
                premium = "null";
            }
            else {
                premium = String.valueOf(100*(1 + random1.nextInt(50)));
            }
            if(end_year==year && ((end_month == month && end_day < day) || end_month < month) ) {
                int temp = month;
                month = end_month;
                end_month = temp;

                temp = day;
                day = end_day;
                end_day = temp;
            }


            System.out.println("insert into job_offers (id, role_id, start_of_search, end_of_search) " +
                    "values ( " + i +", "+ r1 + ", \'" + year + "-" + month  + "-" + day +
                    "\', \'" + end_year + "-" + end_month  + "-" + end_day  + "' );" );
        }
    }
}
