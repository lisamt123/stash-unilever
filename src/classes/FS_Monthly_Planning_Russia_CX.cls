public class FS_Monthly_Planning_Russia_CX {
    Private List<FS_MonthlyPlanner> listMonthlyPlanner;
    Private List<User> listRussiaUsers;
    Private List<Event> listEvents;
    Private List<Event> tempEvents;
    Private date startdate;
    Private date endDate; 
    Private integer nonworkingDays {get;set;}
    Private integer weekend_Count {get;set;}
    Public Map<Id,List<Event>> userEventsMap=new Map<Id,List<Event>>();
    Public Map<Id,Set<String>> userActivityDateMap=new Map<Id,Set<String>>();
    Private FS_MonthlyPlanner monthly_Planner=new FS_MonthlyPlanner();
    Public Integer noofHolidays{get;set;}
    Public Integer noofWeekends{get;set;}
    Public Integer noofDays{get;set;}    
    Public Date monthStartDate{get;set;}
    Public Date monthEndDate{get;set;}
    Public Date dateName{get;set;}
    Public Integer workingDays{get;set;}
    Public Boolean isVisible{get;set;}
    Public Integer noofHolidaysTillDate{get;set;}
    Public integer i{get;set;}
    Public Integer workingDaysTillDate{get;set;}
    Public void FS_Monthly_Planning_Russia_CX(){
       isVisible=false; 
    }
    Public void setlistMonthlyPlanner(){}
    Public pagereference refreshPage(){
        nonworkingDays= 0;
        weekend_Count = 0;
        isVisible=true;        
        monthStartDate=dateName.toStartOfMonth();
        monthEndDate=monthStartDate.addDays(date.daysInMonth(dateName.year(),dateName.month())-1);
        BusinessHours temp = [SELECT ID, Name, IsDefault, IsActive From BusinessHours 
                                    WHERE name=:'Russia Business Hours'];
        Date txnDate = monthStartDate;
        BusinessHours bh=temp;
        While(txnDate!=monthEndDate){
        Datetime now = Datetime.newInstance(txnDate.year(), txnDate.month(), txnDate.day(), 0, 0, 0);        
        Boolean isHoliday = !BusinessHours.isWithin(bh.Id, now);
        System.debug('The value of now is : '+isHoliday);
        if (isHoliday) {
            weekend_Count++;
        }
        txnDate = txnDate.addDays(1);
        }
        //system.debug(weekend_Count);
        noofWeekends=weekend_Count;
        weekend_Count=0;
        txnDate = monthStartDate;
        bh=temp;
        While(txnDate!=dateName){
        Datetime now = Datetime.newInstance(txnDate.year(), txnDate.month(), txnDate.day(), 0, 0, 0);        
        Boolean isHoliday = !BusinessHours.isWithin(bh.Id, now);
        System.debug('The value of now is : '+isHoliday);
        if (isHoliday) {
            weekend_Count++;
        }
        txnDate = txnDate.addDays(1);
        }
        //system.debug(weekend_Count);
        noofHolidaysTillDate=weekend_Count;       
        noofDays=monthStartDate.daysBetween(monthEndDate)+1;
        workingDays=noofDays-noofWeekends;
        return page.FS_Monthly_Planning_Russia_Detail;
    }
    Public List<FS_MonthlyPlanner> getlistMonthlyPlanner(){       
       
       tempEvents=new List<Event>();
       listMonthlyPlanner=new List<FS_MonthlyPlanner>();         
       listRussiaUsers=[select id,name from user  where managerId=:userInfo.getUserId()];         
       listEvents=[select id,Ownerid,ActivityDate from event where Ownerid in : listRussiaUsers and ActivityDate>:monthStartDate and ActivityDate<:dateName]; // Need to put filter on StartDateTime  
       tempEvents=new List<Event>();
       //system.debug(listEvents);
       For(Event eventRecord : listEvents){
            tempEvents=new List<Event>();
            If(userEventsMap.containsKey(eventRecord.OwnerId)){
              tempEvents=userEventsMap.get(eventRecord.OwnerId);
            }
            tempEvents.add(eventRecord);
            userEventsMap.put(eventRecord.OwnerId, tempEvents);
        }
        Set<String> tempDates=new Set<String>();
        For(Event eventRecord : listEvents){
            tempDates=new Set<String>();
            If(userActivityDateMap.containsKey(eventRecord.OwnerId)){
              tempDates=userActivityDateMap.get(eventRecord.OwnerId);
            }
            tempDates.add(String.ValueOf(eventRecord.ActivityDate));
            userActivityDateMap.put(eventRecord.OwnerId, tempDates);
        }      
       For(User userRecord : listRussiaUsers){
            system.debug(userRecord);
            tempEvents=new list<Event>();
            tempDates=new Set<String>();
            monthly_Planner=new FS_MonthlyPlanner();
            If(userEventsMap.containsKey(userRecord.Id)){
               tempEvents=userEventsMap.get(userRecord.Id);              
            }
            If(userActivityDateMap.containsKey(userRecord.Id)){
               tempDates=userActivityDateMap.get(userRecord.Id);              
            }
            //Assign value to new monthly planned record            
            monthly_Planner.userName=userRecord.Name;           
            monthly_Planner.actual=tempEvents.size();
            i=monthStartDate.daysBetween(dateName)-noofHolidaysTillDate-tempDates.size()+1;
            workingDaysTillDate=monthStartDate.daysBetween(dateName)-noofHolidaysTillDate+1;            
            monthly_Planner.plan=workingDays*8;
            monthly_Planner.actualWorkingDays=tempDates.size();
            If(tempDates.size()>0){
              //monthly_Planner.average=(monthly_Planner.actual*100)/monthly_Planner.workingDaysTillDate;
              monthly_Planner.average=(monthly_Planner.actual*100)/tempDates.size();
              monthly_Planner.target=((tempDates.size()*100)/workingDaysTillDate);
              monthly_Planner.criticalTarget=monthly_Planner.target-10; 
            }           
            IF(monthly_Planner!=null){
            listMonthlyPlanner.add(monthly_Planner);
           }            
        }       
       return listMonthlyPlanner;
    }
}