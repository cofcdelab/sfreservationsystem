public class SingleTicketingReportController {

public List<Payment__c> getPayments {get;set;}
public Payment__c getTickets {get;set;}
public List<Payment__c> TransactionNo{get;set;}
public List<Payment__c> Ticket{get;set;}
public List<Payment__c> Payment_Tickets {get;set;}
public List<Integer> Unique_TransactionNo {get;set;}
public List<String> Unique_Ticket {get;set;}
public Ticket__c fromDateEvent{get;set;}
public Ticket__c toDateEvent{get;set;}
public Payment__c fromDateTransaction{get;set;}
public Payment__c toDateTransaction{get;set;}
public Ticket__c status{get;set;}

public List<ReportSum> sums { get; set; }
public class ReportSum {   
 public String Type { get; set; }
  public Integer Tickets_sum { get; set; }
  public String Amount_sum { get; set; }
 
   
 public reportSum(String Type1,Integer Tickets_sum1,String Amount_sum1)    
{      Tickets_sum=Tickets_sum1;
      Amount_sum=Amount_sum1;
      Type=Type1; 
  
}}

//Report wrapper class

  public List<OuterReportTable> outer_report { get; set; }
  public class OuterReportTable {
    public String FullName { get; set; }
    public String Phone { get; set; }
    public String Event { get; set; }
    public String eventDate { get; set; }
    public String Hall{ get; set; }
    public String Area{ get; set; }
    public Integer Row{ get; set; }
    public Integer Seats {get; set;}
    public Decimal Price {get; set;}
    public Integer PriceLevel {get; set;}
    public String PriceTypes {get; set;}
    public String PaymentMethod {get; set;}
    public List<InnerReportTable> innerTable {get; set;}
    Public Boolean flag {get; set;}
    
    public OuterReportTable(String FullName1,String Phone1,String Event1,String eventDate1,String Hall1,String Area1,Integer Row1,Integer Seats1,Decimal Price1,Integer PriceLevel1,String PriceTypes1,String PaymentMethod1,List<InnerReportTable> innerTable1,Boolean flag1) {
        FullName=FullName1;
        Phone=Phone1;
        Event=Event1;
        eventDate=eventDate1;
        Hall=Hall1;
        Area=Area1;
        Row=Row1;
        Seats=Seats1;
        Price=Price1;
        PriceLevel=PriceLevel1;
        PriceTypes=PriceTypes1;
        PaymentMethod=PaymentMethod1;
        innerTable=innerTable1;
        flag=flag1;

     }
  }
  
  
  public List<InnerReportTable> inner_report { get; set; }
  public class InnerReportTable {
    public Integer TransactionNumber {get; set;}
    public String TransactionDate {get; set;}
    public String TransactionType {get; set;}
    public String UserName{get; set;}
    public String Status {get; set;}
    public Integer NumberOfTickets{get; set;}
    public String TotalAmount{get; set;}
     
    public InnerReportTable(Integer TransactionNumber1,String TransactionDate1,String TransactionType1,String UserName1,String Status1,Integer NumberOfTickets1,String TotalAmount1) {
        TransactionNumber=TransactionNumber1;
        TransactionDate=TransactionDate1;
        TransactionType=TransactionType1;
        UserName=UserName1;
        Status=Status1 ;
        NumberOfTickets=NumberOfTickets1;
        TotalAmount=TotalAmount1;

     }
  }
  
  //Report class contructor
  
  public  SingleTicketingReportController() {
        fromDateEvent= new Ticket__c();
        toDateEvent= new Ticket__c();
        fromDateTransaction=new Payment__c();
        toDateTransaction=new Payment__c();
        status=new Ticket__c();
        
 }
 
 
 public void fetchReports()
{
Integer Transaction_no=0,quantity=0,quantity_sum=0;
String Transaction_Date,Transaction_type,uname,status,amount,name_ticket;
Decimal amount_sum=0.0,price=0.0;
outer_report = new List<OuterReportTable>();
sums= new List<ReportSum>();
TransactionNo=[Select Transaction_Number__c from Payment__c]; 
Map<Integer,Payment__c> mapTransactionNo=new Map<Integer,Payment__c>();

for(Payment__c t_no:TransactionNo){
 mapTransactionNo.put(Integer.valueOf(t_no.Transaction_Number__c),t_no);//map will always have unique values 
}
Unique_TransactionNo = new List<Integer>(mapTransactionNo.keySet());

for (Integer j=0; j<Unique_TransactionNo.size(); j++) {

AggregateResult[] Payments = [Select sum(Amount__c) from Payment__c where Transaction_Number__c=:Unique_TransactionNo.get(j) and TransactionDate__c>=:fromDateTransaction.TransactionDate__c and TransactionDate__c<=:toDateTransaction.TransactionDate__c and Ticket__r.Date_Time__c<=:toDateEvent.Date_Time__c and Ticket__r.Date_Time__c>=:fromDateEvent.Date_Time__c];
for (AggregateResult ar : Payments)  {
//amount=String.valueOf(ar.get('expr0'));
price=(Decimal)ar.get('expr0');}
amount=String.valueOf(price);
amount_sum=amount_sum+price;
Payment_Tickets = [Select Transaction_Number__c,TransactionDate__c,Mode__c,Ticket__r.User__c,Ticket__r.Status__c,Ticket__r.Quantity__c from Payment__c where Transaction_Number__c=:Decimal.valueOf(Unique_TransactionNo.get(j)) and TransactionDate__c>=:fromDateTransaction.TransactionDate__c and TransactionDate__c<=:toDateTransaction.TransactionDate__c and Ticket__r.Date_Time__c<=:toDateEvent.Date_Time__c and Ticket__r.Date_Time__c>=:fromDateEvent.Date_Time__c order by TransactionDate__c ASC];
for(Integer i=0;i<Payment_Tickets.size();i++)
{ 
Transaction_no=Integer.valueOf(Payment_Tickets.get(i).Transaction_Number__c);
Transaction_Date=String.valueOf(Payment_Tickets.get(i).TransactionDate__c);
Transaction_type=String.valueOf(Payment_Tickets.get(i).Mode__c);
uname=Payment_Tickets.get(i).Ticket__r.User__c;
status=Payment_Tickets.get(i).Ticket__r.Status__c;
quantity=Integer.valueOf(Payment_Tickets.get(i).Ticket__r.Quantity__c);
}
quantity_sum=quantity_sum+quantity;
inner_report = new List<InnerReportTable>();
inner_report.add(new InnerReportTable(Transaction_no,Transaction_Date,Transaction_type,uname,status,quantity,'$'+amount)); 

Ticket=[Select Ticket__r.Name from Payment__c where Transaction_Number__c=:Unique_TransactionNo.get(j)]; 
Map<String,Payment__c> mapTicket=new Map<String,Payment__c>();

for(Payment__c ticket:Ticket){
 mapTicket.put(String.valueOf(ticket.Ticket__r.Name),ticket);//This is map and hence it will always have unique values 
}
Unique_Ticket  = new List<String>(mapTicket.keySet());
System.debug(Unique_Ticket);
Boolean flag=false;
for (Integer k=0; k<Unique_Ticket.size(); k++) {
if(k>0){flag=true;}
getTickets= [Select Ticket__r.Contact__r.Name,Ticket__r.Contact__r.Phone,Ticket__r.Activity__r.Name,Ticket__r.Date_Time__c,Ticket__r.Location__c,Ticket__r.Price__c,Ticket__r.PriceType__r.Name,Type__c from Payment__c where Ticket__r.Name=:Unique_Ticket.get(k) and TransactionDate__c>=:fromDateTransaction.TransactionDate__c and TransactionDate__c<=:toDateTransaction.TransactionDate__c and Ticket__r.Date_Time__c<=:toDateEvent.Date_Time__c and Ticket__r.Date_Time__c>=:fromDateEvent.Date_Time__c order by TransactionDate__c ASC];
System.debug(getTickets);
name_ticket=getTickets.Ticket__r.Contact__r.Name;
String phone_ticket=getTickets.Ticket__r.Contact__r.Phone;
String event_ticket=getTickets.Ticket__r.Activity__r.Name;
String eventDate_ticket=String.valueOf(getTickets.Ticket__r.Date_Time__c);
String location_ticket=getTickets.Ticket__r.Location__c;
Decimal price_ticket=getTickets.Ticket__r.Price__c;
String priceType_ticket=getTickets.Ticket__r.PriceType__r.Name;
String paymentMethods_ticket=getTickets.Type__c;

outer_report.add(new OuterReportTable(name_ticket,phone_ticket,event_ticket,eventDate_ticket,'',location_ticket,0,0,price_ticket,0,priceType_ticket,paymentMethods_ticket,inner_report,flag));
}

}
sums.add(new ReportSum('Total for Report',quantity_sum,String.valueOf(amount_sum)));
}
 
   }