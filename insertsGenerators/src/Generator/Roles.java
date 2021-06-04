package Generator;

import java.util.Random;

public class Roles {
    static int companies = 500;
    static int positions = 40;
    public static void main(String[] args) {
        int id = 0;
        Random r = new Random();
        for(int i=0;i<companies;i++){
            int pos_id = 1;
            while (true) {
                if(pos_id > positions) {
                    break;
                }
                int min = (75 + r.nextInt(150));
                int max = (int) (min * 1.5f) + r.nextInt(min+1)/2;

                int hours = 20;
                if(r.nextBoolean()) {
                    hours+=hours/2;
                }
                if (r.nextBoolean()) {
                    hours*=2;
                }
                min *= hours;
                max *= hours;
                id++;
                System.out.println("insert into roles (role_id, salary_range_min, salary_range_max, hours_per_week, company_id, position_id) " +
                        "values ( " + id + ", " + min + ", " + max + ", "  + hours + ", " + (i + 1) + ", " + pos_id + " );");
                pos_id += (r.nextInt(10) + 1);
            }
        }
    }
}
