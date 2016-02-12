@isTest(SeeAllData=true)
private class CloseDrawerTestClass {
    static testMethod void validate() {
    test.startTest();
    CloseDrawerController ticket= new CloseDrawerController(); 
     List<CloseDrawerController.PaymentsTable> payment_report;
     DateTime dt = DateTime.parse('12/1/2015 12:00 AM');
     DateTime dt1 = DateTime.parse('12/30/2015 12:00 AM');
     Payment__c t= new Payment__c();
     Payment__c t1= new Payment__c();
     t.TransactionDate__c=dt;
     t1.TransactionDate__c=dt1;          
        
     ticket.fromOpenDate=t;
     ticket.toOpenDate=t1;
               
     payment_report=new List<CloseDrawerController.PaymentsTable>();
     payment_report.add(new CloseDrawerController.PaymentsTable('method',23.45, 10.45, 13.00));
     CloseDrawerController.SalesTable sales_table= new CloseDrawerController.SalesTable('t-001',5,0,5,50.00,0.0,50.00);
    
        
        
    ticket.fetchReports();
    //System.Debug('test passed');
    test.stopTest();
             
            
    }
}