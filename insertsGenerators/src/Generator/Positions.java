package Generator;

public class Positions {
    static String [] positions = new String[] {"Software Engineer Intern", "Junior Software Engineer", "Middle Software Engineer", "Senior Software Engineer", "Tech Lead", "Team Lead", "Product Manager", "Analytic-Programmer", "Research Intern", "CEO", "CFO", "COO", "Department Manager", "Manager", "Clerk", "HR Manager", "IT Recruiter", "Working Student", "Junior Algorithm Assistant", "Algorithm Engineer", "ML Engineer", "Data Scientist", "Mobile Engineer", "Frontend Engineer", "Backend Engineer", "Janitor", "Barista", "Waiter", "Cashier", "Marketer", "Analytic", "Full-Stack web developer", "DevOps Engineer", "System Administrator", "Delivery person", "Personal Assistant", "Software Engineer Intern in Test", "Test Engineer", "Group Lead", "Department Lead" };
    static int MANY = positions.length;
    public static void main(String[] args) {
        for(int i=0;i<MANY;i++) {
            System.out.println("insert into positions (id,name) values ( " + (i+1) + ", '" + positions[i] + "' );");
        }
    }
}
