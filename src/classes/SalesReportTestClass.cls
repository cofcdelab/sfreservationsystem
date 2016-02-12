@isTest(SeeAllData=true)
private class SalesReportTestClass {
    static testMethod void validate() {
    test.startTest();
    SalesReportController ticket= new SalesReportController(); 
     List<SalesReportController.OuterReportTable> outer_report;
     DateTime dt = DateTime.parse('12/1/2015 12:00 AM');
     DateTime dt1 = DateTime.parse('12/30/2015 12:00 AM');
     Ticket__c t= new Ticket__c();
     Ticket__c t1= new Ticket__c();
     Ticket__c t2= new Ticket__c();
     t.Date_Time__c=dt;
     t1.Date_Time__c=dt1;
     t2.Activity__c='a0061000003gmfw';     
     
        
     ticket.fromDateEvent=t;
     ticket.toDateEvent=t1;
     ticket.activity=t2;
          
     outer_report=new List<SalesReportController.OuterReportTable>();
     outer_report.add(new SalesReportController.OuterReportTable('Type',3, '30%', '$433'));
     SalesReportController.PriceTypeReportTable priceType_table= new SalesReportController.PriceTypeReportTable('Type',234.45,33,340.10,33,340.10);
     SalesReportController.PaymentReportTable sum = new SalesReportController.PaymentReportTable ('Method',435.67);   
        
        
    ticket.fetchReports();
    //System.Debug('test passed');
    test.stopTest();
             
            
    }
}