public class FS_CentrallyLedChildAccount_Picklist {
   //public list<selectoption> childaccountlist {get;set;}   
   public list<string> CentrallyLedList {get;set;}   
   //public list<account> ChildAccounts=new list<account>();
   public List<SelectOption> ChildAccountList1=new List<SelectOption>();
   private task centrallyledtask;
   //private task task1;   
   public FS_CentrallyLedChildAccount_Picklist(Apexpages.StandardController stdcontroller){
   centrallyledtask=(task)stdcontroller.getRecord();       
    }    
   public List<SelectOption> ChildAccountList
    {
        get
           {
            task task1=[select id,accountid from task where id=:centrallyledtask.id]; 
            list<account> ChildAccounts=[select id,name from account where parentid =:task1.AccountId];  
            system.debug(ChildAccounts);
            ChildAccountList1.clear();
            for(account acc : ChildAccounts){
                ChildAccountList1.add(new SelectOption(acc.id,acc.name));
            }            
            return ChildAccountList1;          
           }
        set;
    }
        
    //List<task> ChildaccountTaskList1;          
    //system.debug(childactivityset);
    public List<Task> ChildAccountTaskList
    {
        get{
          task task2=[select id,accountid,subject from task where id=:centrallyledtask.id];
          list<account> ChildAccounts1=[select id,name from account where parentid =:task2.AccountId];
          list<task> childtasklist=[select id,subject,accountid,account.name from task where subject=:task2.subject and accountid in: ChildAccounts1];
          return childtasklist;                
        }
        set;
    }
    public pagereference CreateTask(){
        
        List<task> tasktoinsert=new list<task>();        
        List<account> AccList=[select id,name,ownerid from account where id in : CentrallyLedList];
        task task1=[select id,accountid,subject,status,activitydate from task where id=:centrallyledtask.id];
        list<task> childtasklist=[select id,subject,accountid from task where subject=:task1.subject and accountid in: acclist];
        set<id> childactivityset=new set<id>();
        string existingaccountlist;
        for(task childtask : childtasklist){
        childactivityset.add(childtask.accountid);            
        }        
        system.debug(childtasklist);        
        for(account acc1: AccList){            
            if(!(childactivityset.contains(acc1.id))){
                tasktoinsert.add(new Task(whatid=acc1.id,ownerid=acc1.ownerid,subject=task1.subject,status=task1.Status,activitydate=task1.ActivityDate));
            }
            if((childactivityset.contains(acc1.id))){
              ApexPages.Message MyMsg= new ApexPages.Message(ApexPages.Severity.Warning,'Task already created for one of the selected account');
              ApexPages.addMessage(MyMsg);
              system.debug(MyMsg);
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