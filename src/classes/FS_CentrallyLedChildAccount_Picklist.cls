public with sharing class FS_CentrallyLedChildAccount_Picklist {
/*   public list<string> CentrallyLedList {get;set;}   
   public List<SelectOption> ChildAccList=new List<SelectOption>();
   private task centrallyledtask;
   //Getting task record on which the page is requested  
   public FS_CentrallyLedChildAccount_Picklist(Apexpages.StandardController stdcontroller){
   centrallyledtask=(task)stdcontroller.getRecord();       
   }
   //Populating multiselect picklist options
   public List<SelectOption> ChildAccountList
    {
        get
           {
            task ParentTask=[select id,accountid from task where id=:centrallyledtask.id];
            //Fetch all the child accounts
            list<account> ChildAccounts=[select id,name from account where parentid =:ParentTask.AccountId];  
            system.debug(ChildAccounts);
            ChildAccList.clear();//Resetting child account list
            for(account acc : ChildAccounts){
                ChildAccList.add(new SelectOption(acc.id,acc.name));//Add child account to multi select picklist option
            }            
            return ChildAccList;          
           }
         set;
    }
     //Fetch all tasks which have already been created on child accounts for centrally led activities
     public List<Task> ChildAccountTaskList{
        get{
          task task2=[select id,accountid,subject from task where id=:centrallyledtask.id];
          list<account> ChildAccounts1=[select id,name from account where parentid =:task2.AccountId];
          list<task> childtasklist=[select id,subject,accountid,account.name from task where subject=:task2.subject and accountid in: ChildAccounts1];
          return childtasklist;                
        }
        set;
    }
    //Created task on child accounst which have been choosen for centrally led activities
    public pagereference CreateTask(){        
        List<task> tasktoinsert=new list<task>();        
        List<account> AccList=[select id,name,ownerid from account where id in : CentrallyLedList];//Fetch all the selected accounts
        task ParentTask=[select id,accountid,subject,status,activitydate from task where id=:centrallyledtask.id];
        list<task> childtasklist=[select id,subject,accountid from task where subject=:ParentTask.subject and accountid in: acclist];
        set<id> childactivityset=new set<id>();
        string existingaccountlist;
        for(task childtask : childtasklist){
        childactivityset.add(childtask.accountid);            
        }        
        system.debug(childtasklist);        
        for(account acc: AccList){            
            if(!(childactivityset.contains(acc.id))){
                tasktoinsert.add(new Task(whatid=acc.id,ownerid=acc.ownerid,subject=ParentTask.subject,status=ParentTask.Status,activitydate=ParentTask.ActivityDate));
            }
            //Add warning if task already created for any of the selected accounts
            if((childactivityset.contains(acc.id))){
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
  }*/
}