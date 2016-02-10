trigger EnforceCapacity on Ticket__c (before insert, before update) {
    //for each ticket being inserted or updated
    for(Ticket__c t : Trigger.new){
        list<Event__c> e = [select name from Event__c where id = :t.events__c];

        integer cap = Capacity.checkCapacity(e[0], t.date_time__C);
		
        if(cap == null){
            t.adderror('Incorrect start time. Please see when tours start.');
        }
        else if((cap - t.quantity__c) < 0){
            t.adderror('Not enough capacity. Remaining capacity: ' +cap);
        }
        
    }

}