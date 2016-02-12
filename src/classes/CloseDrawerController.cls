public class CloseDrawerController {

public Payment__c fromOpenDate{get;set;}
public Payment__c toOpenDate{get;set;}
public List<Payment__c> paymentTypes {get;set;}
public List<Payment__c> ticket{get;set;}
public List<PaymentsTable> payments_report { get; set; }
public class PaymentsTable{
    public String Method{ get; set; }
    public Decimal Credit{ get; set; }
    public Decimal Debit{ get; set; }
    public Decimal Net{ get; set; }   
    
    public PaymentsTable(String Method1,Decimal Credit1, Decimal Debit1, Decimal Net1) {
        Method=Method1;
        Credit=Credit1;
        Debit=Debit1;
        Net=Net1;
     }
  }

public List<SalesTable> sales_report { get; set; }
public class SalesTable{
    public String Tickets{ get; set; }
    public Integer Quantity{ get; set; }
    public Integer Returned{ get; set; }
    public Integer Net{ get; set; }
    public Decimal TotalSale{ get; set; }
    public Decimal Fee{ get; set; }
    public Decimal Total{ get; set; }
    
    public SalesTable(String Tickets1,Integer Quantity1,Integer Returned1,Integer Net1,Decimal TotalSale1,Decimal Fee1,Decimal Total1) {
        Tickets=Tickets1;
        Quantity=Quantity1;
        Returned=Returned1;
        Net=Net1;
        TotalSale=TotalSale1;
        Fee=Fee1;
        Total=Total1;
      }
  }

public  CloseDrawerController() {
        fromOpenDate= new Payment__c();
        toOpenDate= new Payment__c();
      
 } 
 
 
public void fetchReports()
{
Decimal creditAmount=0.0,debitAmount=0.0,netAmount=0.0;
Decimal credit_sum=0.0,debit_sum=0.0,net_sum=0.0;
List<String> Unique_PaymentType = new List<String>();
paymentTypes = new List<Payment__c>();
payments_report =new List<PaymentsTable>();
paymentTypes =[Select Type__c from Payment__c];
Map<String,Payment__c> mapPaymentType=new Map<String,Payment__c>();
for(Payment__c payment_no:paymentTypes){
 mapPaymentType.put(String.valueOf(payment_no.Type__c),payment_no);//map will always have unique values 
}
Unique_PaymentType = new List<String>(mapPaymentType.keySet());
for(Integer j=0;j<Unique_PaymentType.size();j++)
{
AggregateResult[] credit=[Select sum(Amount__c) from Payment__c where TransactionDate__c>=:fromOpenDate.TransactionDate__c and TransactionDate__c<=:toOpenDate.TransactionDate__c and Type__c=:Unique_PaymentType.get(j) and Mode__c=:'Receipt'];
for (AggregateResult ar : credit)  {
if(ar.get('expr0')==null){creditAmount=0.0;}
else{creditAmount=(Decimal)ar.get('expr0');}}
AggregateResult[] debit=[Select sum(Amount__c) from Payment__c where TransactionDate__c>=:fromOpenDate.TransactionDate__c and TransactionDate__c<=:toOpenDate.TransactionDate__c and Type__c=:Unique_PaymentType.get(j) and Mode__c=:'Refund'];
for (AggregateResult ar2 : debit)  {
if(ar2.get('expr0')==null){debitAmount=0.0;}
else{debitAmount=(Decimal)ar2.get('expr0');}}
netAmount=(Decimal)creditAmount-(Decimal)debitAmount;
credit_sum=credit_sum+creditAmount;
debit_sum=debit_sum+debitAmount;
net_sum=net_sum+netAmount;
payments_report.add(new PaymentsTable(Unique_PaymentType.get(j),creditAmount,debitAmount,netAmount));
}
payments_report.add(new PaymentsTable('Total',credit_sum,debit_sum,net_sum));
//Sale Table
Decimal total_sale_sum=0.0,fee_sum=0.0,total_sum=0.0;
Integer quantity_sum=0,returned_sum=0,net_ticket_sum=0;
sales_report=new List<SalesTable>();
ticket=new List<Payment__c>();
ticket= [Select Ticket__c,Ticket__r.name,Ticket__r.Price__c,Ticket__r.Quantity__c,Ticket__r.Status__c from Payment__c where TransactionDate__c>=:fromOpenDate.TransactionDate__c and TransactionDate__c<=:toOpenDate.TransactionDate__c];
for(Integer k=0;k<ticket.size();k++)
{
Decimal total=(Decimal)(ticket.get(k).Ticket__r.Quantity__c)*(Decimal)(ticket.get(k).Ticket__r.Price__c);
if(ticket.get(k).Ticket__r.Status__c=='Sale')
{
 sales_report.add(new SalesTable(ticket.get(k).Ticket__r.name,Integer.valueOf(ticket.get(k).Ticket__r.Quantity__c),0,Integer.valueOf(ticket.get(k).Ticket__r.Quantity__c),total,0.0,total)); 
 quantity_sum=quantity_sum+Integer.valueOf(ticket.get(k).Ticket__r.Quantity__c);
 returned_sum=returned_sum+0;
 net_ticket_sum=net_ticket_sum+Integer.valueOf(ticket.get(k).Ticket__r.Quantity__c);
}
else if(ticket.get(k).Ticket__r.Status__c=='Return')
{sales_report.add(new SalesTable(ticket.get(k).Ticket__r.name,0,Integer.valueOf(ticket.get(k).Ticket__r.Quantity__c),Integer.valueOf(ticket.get(k).Ticket__r.Quantity__c),total,0.0,total));
 quantity_sum=quantity_sum+0;
 returned_sum=returned_sum+Integer.valueOf(ticket.get(k).Ticket__r.Quantity__c);
 net_ticket_sum=net_ticket_sum+Integer.valueOf(ticket.get(k).Ticket__r.Quantity__c);
 }
 total_sale_sum=total_sale_sum+total;
 fee_sum=fee_sum+0.0;
 total_sum=total_sum+total;
}
sales_report.add(new SalesTable('Total',quantity_sum,returned_sum,net_ticket_sum,total_sale_sum,fee_sum,total_sum));
}

}