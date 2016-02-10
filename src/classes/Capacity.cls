public class Capacity {
    public static integer checkCapacity(Event__c e, DateTime dt){
        
        string stime = String.valueOf(dt.Time()).substring(0,5); // value for comparing time of ticket and event
  
        //gets event schedules of the appropriate time and event.
        list<eventSchedule__c> es = [Select capacity__c, startdate__c, starttime__c, MondayAvailability__c, 
                                     TuesdayAvailability__c, WednesdayAvailability__c, ThursdayAvailability__c,
                                     FridayAvailability__c, SaturdayAvailability__c, SundayAvailability__c
                                     From eventSchedule__c 
                                     where (Event__c = :e.Id  AND starttime__c = :stime) Limit 1]; 
        
        //return null if no event schedule found
        if(es.size() == 0){
            return null;
        }
        
        integer cap = (integer) es[0].capacity__c; //Gets capacity of event.

        
        //Gets all tickets to event of any time
        list<Ticket__C> tix = [Select id, date_time__c, quantity__c from Ticket__c where Events__c = :e.id ];
        
        integer ticNum = 0;  //aggregator to count number of tickets at a certain time
        
        //if the ticket is the correct day for the event add to ticNum
        for(Ticket__C t : tix){
            if ( isCorrectDay(t.date_time__c, es[0]) && t.date_time__c == dt ){
                ticNum += (integer) t.quantity__c;
            }
        }
        //system.debug('ticNum = '+ticNum);
        
        return cap - ticNum; //return the total capacity minus the number of tixs for that event
    }
    
    public static boolean isCorrectDay(DateTime dt, EventSchedule__C es){
        String day = dt.format('EEEE');
        boolean retVal = false;
        
        if((es.MondayAvailability__c) && (day.equals('Monday'))){
                		retVal = true;
        }
        else if((es.TuesdayAvailability__c) && (day.equals('Tuesday'))){
            retVal = true;
        }
        else if((es.WednesdayAvailability__c) && (day.equals('Wednesday'))){
            retVal = true;
        }
		else if((es.ThursdayAvailability__c) && (day.equals('Thursday'))){
            retVal = true;
        }
        else if((es.FridayAvailability__c) && (day.equals('Friday'))){
            retVal = true;
        }
        else if((es.SaturdayAvailability__c) && (day.equals('Saturday'))){
            retVal = true;
        }
        else if((es.SundayAvailability__c) && (day.equals('Sunday'))){
            retVal = true;
        }

        return retVal;

    }
}    
    
/*

list<Event__c> e = [select id from Event__c where name = 'Battle Field Tour'];
list<Ticket__c> t = [select date_time__c from Ticket__c where events__C =:e[0].id];
//system.debug(e[0]);
system.debug('cap =  ' + Capacity.checkCapacity(e[0], t[0].date_time__c));
*/