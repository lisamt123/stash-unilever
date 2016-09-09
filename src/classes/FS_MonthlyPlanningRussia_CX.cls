/**********************************************************************
Purpose: FS_Monthly_Planning_Russia_CX is used for generating monthly report for Russia team
History :
VERSION AUTHOR         DATE         DETAIL Description
1.0     Accenture    01/Sep/2016     Draft                     
***********************************************************************/

public with sharing class FS_MonthlyPlanningRussia_CX {
    Private List<FS_MonthlyPlanner> listMonthlyPlanner;
    Private List<User> listRussiaUsers;
    Private List<Event> listEvents;
    Private List<Event> tempEvents;
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
    // Get working hour details for selected month
    Public pagereference refreshPage(){
        weekend_Count = 0;
        noofHolidaysTillDate=0;
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
        //System.debug('The value of now is : '+isHoliday);
        if (isHoliday) {
            weekend_Count++;
            if(txnDate<=dateName)
            {
            noofHolidaysTillDate++;
            }
        }
        txnDate = txnDate.addDays(1);
        }
        //system.debug(weekend_Count);
        noofWeekends=weekend_Count;
        weekend_Count=0;
        txnDate = monthStartDate;
        bh=temp;       
        noofDays=monthStartDate.daysBetween(monthEndDate)+1;
        workingDays=noofDays-noofWeekends;
        return page.FS_MonthlyPlanningRussiaDetail;
    }
    // Get details of monthly activites for subordinators of currently logged in user
    Public List<FS_MonthlyPlanner> getlistMonthlyPlanner(){       
       tempEvents=new List<Event>();
       listMonthlyPlanner=new List<FS_MonthlyPlanner>();         
       listRussiaUsers=[select id,name from user  where managerId=:userInfo.getUserId()];
       
       listEvents=[select id,Ownerid,ActivityDate from event where Ownerid in : listRussiaUsers and ActivityDate>=:monthStartDate and ActivityDate<=:dateName];  
       tempEvents=new List<Event>();
       Set<String> tempDates=new Set<String>();
       
       //system.debug(listEvents);
       For(Event eventRecord : listEvents){
            tempEvents=new List<Event>();
            If(userEventsMap.containsKey(eventRecord.OwnerId)){
              tempEvents=userEventsMap.get(eventRecord.OwnerId);
            }
            tempEvents.add(eventRecord);
            userEventsMap.put(eventRecord.OwnerId, tempEvents);
            
             tempDates=new Set<String>();
            If(userActivityDateMap.containsKey(eventRecord.OwnerId)){
              tempDates=userActivityDateMap.get(eventRecord.OwnerId);
            }
            tempDates.add(String.ValueOf(eventRecord.ActivityDate));
            userActivityDateMap.put(eventRecord.OwnerId, tempDates);
        }
       For(User userRecord : listRussiaUsers){
            //system.debug(userRecord);
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
              monthly_Planner.average=(Decimal.valueOf(monthly_Planner.actual)/tempDates.size()).setScale(2);
              monthly_Planner.target=((Decimal.valueOf(tempDates.size())*100)/workingDays).setScale(2);
             // system.debug(monthly_Planner.target);
              monthly_Planner.criticalTarget=monthly_Planner.target-10;
            }           
            IF(monthly_Planner!=null){
            listMonthlyPlanner.add(monthly_Planner);
           }            
        }       
       return listMonthlyPlanner;
    }
}