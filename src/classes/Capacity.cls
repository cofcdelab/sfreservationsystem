public class Capacity {
    public static integer checkCapacity(Activity__c e, DateTime dt){
        
        //strings for dynamic query
        string stime = String.valueOf(dt.Time()).substring(0,5); // value for comparing time of ticket and event
        string queryday = getQueryDay(dt);
        string eventid = String.valueOf(e.id);
  
        //gets event schedules of the appropriate time and event.
        list<activitySchedule__c> es = Database.query('Select capacity__c From activitySchedule__c where (Activity__c = :eventid  AND starttime__c = :stime AND '+queryDay+' = true) Limit 1');

        //return null if no event schedule found
        if(es.size() == 0){
            return null;
        }
        
        integer cap = (integer) es[0].capacity__c; //Gets capacity of event.

        aggregateresult tix = (aggregateresult) [Select SUM(quantity__c) from Ticket__c where (Activity__c = :e.id AND date_time__c = :dt)];
        
        double t = (double) tix.get('expr0');
        if(t == null) t = 0;
        if(cap == null) return null;
        
        return (integer) (cap - t); //return the total capacity minus the number of tixs for that event
        
        
    }
    
    public static string getQueryDay(DateTime dt){
        String day = dt.format('EEEE');
        day += 'Availability__c';
        return day;
    }
}