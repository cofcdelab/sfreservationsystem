@isTest(SeeAllData=true)
private class EMSTestClass {
    static testMethod void validate() {
    test.startTest();
    ESMReportController ticket= new ESMReportController(); 
     List<ESMReportController.ReportTable> report;
     DateTime dt = DateTime.parse('12/1/2015 12:00 AM');
     DateTime dt1 = DateTime.parse('12/30/2015 12:00 AM');
     Ticket__c t= new Ticket__c();
     Ticket__c t1= new Ticket__c();
     t.Date_Time__c=dt;
     t1.Date_Time__c=dt1;     
     Ticket__c p= new Ticket__c();
     Ticket__c p1= new Ticket__c();
     p.Sale_Date__c=dt;
     p1.Sale_Date__c=dt1;
        
     ticket.fromDateEvent=t;
     ticket.toDateEvent=t1;
     ticket.fromDateSales=p;
     ticket.toDateSales=p1; 
          
     report=new List<ESMReportController.ReportTable>();
     report.add(new ESMReportController.ReportTable('12/02/2015 4:30 AM','12/06/2015 4:30 AM','8:30 AM','Venue1','show1',200,20,100,20,'10%',2000.00,20,2000.00,0,180));
     
        
    ticket.fetchReports();
    //System.Debug('test passed');
    test.stopTest();
             
            
    }
}