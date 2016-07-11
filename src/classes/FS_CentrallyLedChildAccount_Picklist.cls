public class FS_CentrallyLedChildAccount_Picklist {
   //public list<selectoption> childaccountlist {get;set;}   
   public list<string> CentrallyLedList {get;set;}   
   public list<account> ChildAccounts=new list<account>();
   public List<SelectOption> ChildAccountList1=new List<SelectOption>();
   private task centrallyledtask;
   private task task1;
   private task task2;
   public FS_CentrallyLedChildAccount_Picklist(Apexpages.StandardController stdcontroller){
       centrallyledtask=(task)stdcontroller.getRecord();       
    }
    
    public List<SelectOption> ChildAccountList
    {
        get
        {
            task1=[select id,accountid from task where id=: centrallyledtask.id ];    
            system.debug('SOQL for child account');
            ChildAccounts=[select id,name from account where parentid =:task1.AccountId];
            system.debug(ChildAccounts);
            ChildAccountList1.clear();
            for(account acc : ChildAccounts){
                ChildAccountList1.add(new SelectOption(acc.id,acc.name));
            }            
            return ChildAccountList1;          
           }
        set;
    } 
    public pagereference CreateTask(){
        List<account> AccList=new List<account>();
        List<task> tasktoinsert=new list<task>();
        task2=[select id,accountid,subject,status,activitydate from task where id=: centrallyledtask.id ];  
        AccList=[select id,name,ownerid from account where id in : CentrallyLedList];
        list<task> childtasklist=new list<task>();
        childtasklist=[select id,subject,accountid from task where subject=:task2.subject and accountid in: acclist];
        system.debug(childtasklist);
        set<id> childactivityset=new set<id>();
        for(task childtask : childtasklist){
        childactivityset.add(childtask.accountid);            
        }        
        system.debug(childactivityset);
        for(account acc1: AccList){            
            if(!(childactivityset.contains(acc1.id))){
                tasktoinsert.add(new Task(whatid=acc1.id,ownerid=acc1.ownerid,subject=task2.subject,status=task2.Status,activitydate=task2.ActivityDate));
            }           
          }        
        system.debug(tasktoinsert.size());
        system.debug(tasktoinsert);
        try{
            if(!(tasktoinsert.isEmpty())){
               insert tasktoinsert;
              }
          }
          Catch(DmlException e){
              System.debug( 'The following exception has occurred: '+e.getMessage() );
              ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'CentralLedActivitiesTrigger', 'CreateTaskonChildAccount', e.getMessage(), e, null, null, null, 0,'Food Solution');
    }
        return null;
  }
}