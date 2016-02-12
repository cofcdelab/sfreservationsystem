public class ESMReportController {

public Ticket__c fromDateEvent{get;set;}
public Ticket__c toDateEvent{get;set;}
public Ticket__c fromDateSales{get;set;}
public Ticket__c toDateSales{get;set;}
public List<Ticket__c> ticketObject{get;set;}
public List<Ticket__c> ticket {get;set;}
public List<Ticket__c> getDates {get;set;}
public List<DateTime> listStrings {get;set;}
public List<String> listStrings2 {get;set;}
public List<String> listRecords {get;set;}
public List<String> listHistory {get;set;}
public List<sObject> reportList {get;set;}
public List<List<sObject>> finalReportList {get;set;}
public List<Ticket__c> CapacityTickets {get;set;}




//- wrapper class

  public List<ReportTable> report { get; set; }
  public class ReportTable {
    public String Day { get; set; }
    public String Times { get; set; }
    public String eventDate { get; set; }
    public String Venue{ get; set; }
    public String Show{ get; set; }
    public Integer Capacity{ get; set; }
    public Integer Sold {get; set;}
    public Integer Comp {get; set;}
    public Integer Issued {get; set;}
    public String Percent {get; set;}
    public Decimal Value {get; set;}
    public Integer Esm {get; set;}
    public Decimal Esm_Value {get; set;}
    public Integer Lock {get; set;}
    public Integer Available{get; set;}
  
 
    
    public reportTable(String day1,String dates1,String time1,String venue1,String show1,Integer capacity1,Integer sold1,Integer comp1,Integer issued1,String percent1,Decimal value1,Integer esm1,Decimal esm_Value1,Integer lock1,Integer available1) {
      Day=day1;
      Times=time1;
      eventDate =dates1;
      Venue=venue1;
      Show=show1;
      Capacity=capacity1;
      Sold=sold1;
      Comp=comp1;
      Issued=issued1;
      Percent=percent1;
      Value=value1;
      Esm=esm1;
      Esm_Value=esm_Value1;
      Lock=lock1;
      Available=available1;
      
     }
  }


public  ESMReportController() {
        fromDateEvent= new Ticket__c();
        toDateEvent= new Ticket__c();
        fromDateSales=new Ticket__c();
        toDateSales=new Ticket__c();
        
 }
 
 
 
 public Integer getCapacity(String activity,DateTime eventDateTime)
{
Integer capacity_result=0;
Date activityDate = date.newinstance(eventDateTime.year(), eventDateTime.month(), eventDateTime.day());
String newDate = eventDateTime.hour()+':'+eventDateTime.minute();
AggregateResult[] capacity= [Select max(Capacity__c) from ActivitySchedule__c where Activity__c=:activity and StartDate__c<=:activityDate and EndDate__c>=:activityDate and StartTime__c=:newDate];
for (AggregateResult ar_capacity : capacity)  
  {
    if(ar_capacity.get('expr0')==null)
     {capacity_result=0;
     }
    else{capacity_result=Integer.valueOf(ar_capacity.get('expr0'));
    }
  }
return capacity_result;
}
   

public void fetchReports()
{
Decimal Value_sold=0, Value_esm=0,per=0,esm_ValueSum=0,valueSum=0;
Integer esm=0,cap_value=0,capacity,comp,sold,issued=0,capacitySum=0,soldSum=0,compSum=0,issuedSum=0,esmSums=0,availableSum=0,locksum=0;
String percent,percentSum='';
CapacityTickets =new List<Ticket__c>();
report = new List<ReportTable>();
getDates = [Select Date_Time__c from Ticket__c where Date_Time__c >=:fromDateEvent.Date_Time__c and Date_Time__c<=:toDateEvent.Date_Time__c order by Date_Time__c ASC];
Map<DateTime,Ticket__c> mapDate=new Map<DateTime,Ticket__c>();

for(Ticket__c date_Event:getDates){
 mapDate.put(date_Event.Date_Time__c,date_Event);//This is map and hence it will always have unique values 
}
listStrings = new List<DateTime>(mapDate.keySet());
for (Integer i=0; i<listStrings.size(); i++) {
ticketObject=[SELECT Activity__c from Ticket__c where Date_Time__c=:listStrings.get(i)];
System.debug(ticketObject);
Map<String,Ticket__c> mapEvent=new Map<String,Ticket__c>();
for(Ticket__c Event:ticketObject){
 mapEvent.put(Event.Activity__c,Event);//This is map and hence it will always have unique values 
}
listStrings2 = new List<String>(mapEvent.keySet());
for (Integer j=0; j<listStrings2.size(); j++) {
AggregateResult[] sum=[SELECT sum(Price__c),sum(Quantity__c) from Ticket__c where PriceType__r.Name!='COMP' and Date_Time__c=:listStrings.get(i) and Activity__c=:listStrings2.get(j)];
Date myDate = date.newinstance(listStrings.get(i).year(),listStrings.get(i).month(),listStrings.get(i).day());
System.debug(myDate);
//get capacity

if(getCapacity(listStrings2.get(j),listStrings.get(i))!=null)
{
cap_value= getCapacity(listStrings2.get(j),listStrings.get(i));}
else{cap_value=0;}

/*
List<ActivitySchedule__c> eventSchedule_capacity=[SELECT Capacity__c from ActivitySchedule__c where StartDate__c=:myDate and Activity__c=:listStrings2.get(j)];
if(!eventSchedule_capacity.isEmpty()) {
   capacity = (Integer)eventSchedule_capacity[0].Capacity__c;
}*/

AggregateResult[] sum_comp=[SELECT sum(Quantity__c) from Ticket__c where PriceType__r.Name='COMP' and Date_Time__c=:listStrings.get(i) and Activity__c=:listStrings2.get(j)];
AggregateResult[] esm_sum=[SELECT sum(Price__c),sum(Quantity__c) from Ticket__c where PriceType__r.Name!='COMP' and Date_Time__c=:listStrings.get(i) and Activity__c=:listStrings2.get(j) and Sale_Date__c>=:fromDateSales.Sale_Date__c and Sale_Date__c<=:toDateSales.Sale_Date__c];


for (AggregateResult ar1 : esm_sum) 
{
if(ar1.get('expr0')==null) {Value_esm=0;}
else{Value_esm=(Decimal)(ar1.get('expr0'));}
if(ar1.get('expr1')==null) {esm=0;}
else{
esm=Integer.ValueOf(ar1.get('expr1'));}
}
for (AggregateResult ar2 : sum_comp)  
{
if(ar2.get('expr0')==null)
 {comp=0;}
 else
{ comp=Integer.valueOf(ar2.get('expr0'));}
}
for (AggregateResult ar : sum)  
{
if(ar.get('expr1')==null)
 {sold=0;}
else{sold=Integer.valueOf(ar.get('expr1'));
Value_sold=(Decimal)(ar.get('expr0'));}
   
}
issued=sold+comp;
System.debug('issued'+ issued);
if(cap_value==0){per= 0.0;}
else{per=(((Decimal)issued/(Decimal)cap_value)*100).setScale(0);}
percent=(String.valueOf(per))+'%';
System.debug('percent'+ percent);
Datetime dt = (DateTime)listStrings.get(i);
String dayOfWeek = dt.format('EEEE');
String dayString = dt.format('MM/dd/yyyy');
String time_event=dt.format('hh:mm a');
Activity__c event=[SELECT name from Activity__c where id=:listStrings2.get(j)];

report.add(new ReportTable(dayOfWeek,dayString,time_event,'loc1',String.valueOf(event.get('Name')),cap_value,sold,comp,issued,percent,Value_sold,esm,Value_esm,0,(cap_value-issued)));  
  
  
}

capacitySum=capacitySum+cap_value;
soldSum=soldSum+sold;
compSum=compSum+comp;
issuedSum=issuedSum+issued;
esmSums=esmSums+esm;
esm_ValueSum=esm_ValueSum+Value_esm; 
locksum=0;
availableSum=availableSum+(cap_value-issued);
percentSum=String.valueOf((((Decimal)issuedSum/(Decimal)capacitySum)*100).setScale(0))+'%';
valueSum=valueSum+Value_sold;

 if(i==listStrings.size()-1)
  {report.add(new ReportTable('Report Totals',null,null,null,null,capacitySum,soldSum,compSum,issuedSum,percentSum,valueSum,esmSums,esm_ValueSum,0,availableSum));}
}


}
}