import java.util.Random;

public class Hours {
    static String[] open = new String[] {"6:00", "6:30", "7:00", "7:15", "7:30", "7:45", "8:00", "8:00", "8:00", "8:15", "8:20", "8:30", "8:30", "9:00", "10:00"};
    static String[] close = new String[] {"15:00", "16:00", "17:00", "17:15", "17:30", "17:30", "17:45", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30", "21:00", "22:00", "23:00"};

    public static int workPlaces = 1500;
    public static int MANY = workPlaces;
    public static void main(String[] args) {
        for(int i=0;i<MANY;i++) {
            Random r = new Random();
            int [] openHours = new int[7];
            int [] closeHours = new int[7];
            for(int j=0;j<7;j++) {
                openHours[j] = r.nextInt(open.length);
                closeHours[j] = r.nextInt(closeHours.length);
            }
            System.out.print("insert into open_close_hours values ( " + (i+1) + ", ");
            for(int j=0;j<7;j++) {
                System.out.print("'" + open[openHours[j]] + "', ");
            }
            for(int j=0;j<7;j++) {
                if(j != 6) {
                    System.out.print("'" + close[closeHours[j]] + "', ");
                }
                else {
                    System.out.print("'" + close[closeHours[j]] + "' ");
                }
            }
            System.out.println(");");
        }
    }
}
