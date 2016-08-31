public class FS_Monthly_Planning_Russia_CX {
    Private List<FS_MonthlyPlanner> listMonthlyPlanner;
    Private List<User> listRussiaUsers;
    Private List<Event> listEvents;
    Private List<Event> tempEvents;
    Private date startdate;
    Private date endDate;    
    Public Map<Id,List<Event>> userEventsMap=new Map<Id,List<Event>>();  
    Private FS_MonthlyPlanner monthly_Planner=new FS_MonthlyPlanner();    
    Public void setlistMonthlyPlanner(){}
    Public List<FS_MonthlyPlanner> getlistMonthlyPlanner(){
       //listRussiaUsers=[select id,name from user limit 10];
       //listEvents=[select id,Ownerid from event where Ownerid in : listRussiaUsers];
       Integer holidaysCount = 0;
       BusinessHours temp = [SELECT ID, Name, IsDefault, IsActive From BusinessHours 
                                    WHERE name=:'Russia Business Hours'];
       startDate=System.today().toStartOfMonth();
       endDate=startdate.addDays(date.daysInMonth(System.today().year(),System.today().month())-1); 
       Date txnDate = startDate;
       BusinessHours bh=temp;
       While(txnDate!=endDate){
       Datetime now = Datetime.newInstance(txnDate.year(), txnDate.month(), txnDate.day(), 0, 0, 0);        
       Boolean isHoliday = !BusinessHours.isWithin(bh.Id, now);
       System.debug('The value of isHoliday is : '+isHoliday);
       if (isHoliday) {
            holidaysCount++;
        }
        txnDate = txnDate.addDays(1);
        }
        system.debug(holidaysCount);
       tempEvents=new List<Event>();
       listMonthlyPlanner=new List<FS_MonthlyPlanner>();
       Id userId='005E000000473oY';       
       listRussiaUsers=[select id,name from user where id=:userId];            
       listEvents=[select id,Ownerid from event where Ownerid in : listRussiaUsers and ActivityDate>:startDate and ActivityDate<:endDate]; // Need to put filter on StartDateTime  
       tempEvents=new List<Event>();
       system.debug(listEvents);
       For(Event eventRecord : listEvents){
            If(userEventsMap.containsKey(eventRecord.OwnerId)){
              tempEvents=userEventsMap.get(eventRecord.OwnerId);
            }
            tempEvents.add(eventRecord);
            userEventsMap.put(eventRecord.OwnerId, tempEvents);
        }           
       For(User userRecord : listRussiaUsers){
            system.debug(userRecord);           
            monthly_Planner=new FS_MonthlyPlanner();
            If(userEventsMap.containsKey(userRecord.Id)){
               tempEvents=userEventsMap.get(userRecord.Id);
               system.debug(tempEvents);
            }
         // List<Holiday> listHoliday=[select id, ActivityDate, RecurrenceStartDate from holiday where ActivityDate>:startDate and ActivityDate<:endDate];  
         List<AggregateResult> listHoliday=[select Count(id) from holiday where ActivityDate>:startDate and ActivityDate<=:endDate];
           listHoliday.size();
           System.debug('------------' +listHoliday);
           startDate=System.today().toStartOfMonth();
           endDate=startdate.addDays(date.daysInMonth(System.today().year(),System.today().month())-1);
            //Assign value to new monthly planned record            
            monthly_Planner.userName=userRecord.Name;
            monthly_Planner.monthStartDate=startDate;
            monthly_Planner.monthEndDate=endDate;
            monthly_Planner.WorkingDays=startDate.daysBetween(endDate)-holidaysCount+1;
            monthly_Planner.actual=tempEvents.size();
            monthly_Planner.plan=monthly_Planner.WorkingDays*8;
            system.debug(monthly_Planner);
            monthly_Planner.average=monthly_Planner.actual/monthly_Planner.WorkingDays;
           IF(monthly_Planner!=null){
             listMonthlyPlanner.add(monthly_Planner);
               
               //list<Holiday> h1=[select id, ActivityDate, RecurrenceStartDate from holiday where ActivityDate >THIS_MONTH 
           }            
        }       
       return listMonthlyPlanner;
    }
}