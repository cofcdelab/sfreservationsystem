@isTest(SeeAllData=true)
private class SingleTicketTestClass {
    static testMethod void validate() {
    test.startTest();
    SingleTicketingReportController ticket= new SingleTicketingReportController(); 
     List<SingleTicketingReportController.InnerReportTable> inner_report;
     DateTime dt = DateTime.parse('12/1/2015 12:00 AM');
     DateTime dt1 = DateTime.parse('12/30/2015 12:00 AM');
     Ticket__c t= new Ticket__c();
     Ticket__c t1= new Ticket__c();
     t.Date_Time__c=dt;
     t1.Date_Time__c=dt1;     
     Payment__c p= new Payment__c();
     Payment__c p1= new Payment__c();
     p.TransactionDate__c=dt;
     p1.TransactionDate__c=dt1;
        
     ticket.fromDateEvent=t;
     ticket.toDateEvent=t1;
     ticket.fromDateTransaction=p;
     ticket.toDateTransaction=p1; 
          
     inner_report=new List<SingleTicketingReportController.InnerReportTable>();
     inner_report.add(new SingleTicketingReportController.InnerReportTable(1,'12/1/2015 12:00 AM','sale','User','status',100,'1200$'));
     SingleTicketingReportController.OuterReportTable outer_table= new SingleTicketingReportController.OuterReportTable('Name','322333443','BATTLEFIELD','12/1/2015 12:00 AM','hall1','area1',4,180,12.45,3,'COMP','cash',inner_report,true);
     SingleTicketingReportController.ReportSum sum = new SingleTicketingReportController.ReportSum('Total',12,'$23.43');   
        
        
    ticket.fetchReports();
    //System.Debug('test passed');
    test.stopTest();
             
            
    }
}