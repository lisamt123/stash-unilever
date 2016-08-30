/* * Extension class FS_CentrallyLedChildAccount_Picklist for Centrally Led visualforce page
*  @name FS_CentrallyLedChildAccount_Picklist
*  @param 
*  @return 
*  @throws 
*/
public without sharing class FS_CentrallyLedChildAccount_Picklist_CX {
   public list<string> centrallyLedList {get;set;}   
   public List<SelectOption> childAccList=new List<SelectOption>();
   private task centrallyledtask;
   //Getting task record on which the page is requested
/* * Constructor method FS_CentrallyLedChildAccount_Picklist
*  @name FS_CentrallyLedChildAccount_Picklist
*  @param
*  @return 
*  @throws 
*/
   public FS_CentrallyLedChildAccount_Picklist_CX (Apexpages.StandardController stdcontroller){
   centrallyledtask=(task)stdcontroller.getRecord();       
   }
   //Populating multiselect picklist options
   public List<SelectOption> ChildAccountList
    {
        get
           {
            task parentTask=[select id,accountid from task where id=:centrallyledtask.id limit 1];
            //Fetch all the child accounts
            list<account> childAccounts=[select id,name from account where parentid =:parentTask.AccountId limit 49999];  
            //system.debug(childAccounts);
            childAccList.clear();//Resetting child account list
            for(account acc : childAccounts){
                childAccList.add(new SelectOption(acc.id,acc.name));//Add child account to multi select picklist option
            }            
            return childAccList;          
           }
         set;
    }
     //Fetch all tasks which have already been created on child accounts for centrally led activities
     public List<Task> ChildAccountTaskList{
        get{
          task task2=[select id,accountid,subject from task where id=:centrallyledtask.id];
          list<account> childAccounts1=[select id,name from account where parentid =:task2.AccountId limit 49999];
          list<task> childtasklist=[select id,subject,accountid,account.name from task where subject=:task2.subject and accountid in: childAccounts1 limit 49999];
          return childtasklist;                
        }
        set;
    }
/* * createTask Method to create task for selected child accounts
*  @name createTask
*  @param
*  @return 
*  @throws 
*/   
    public pagereference createTask(){        
        List<task> tasktoinsert=new list<task>();        
        List<account> accList=[select id,name,ownerid from account where id in : centrallyLedList limit 49999];//Fetch all the selected accounts
        task parentTask=[select id,accountid,subject,status,activitydate from task where id=:centrallyledtask.id limit 49999];
        list<task> childtasklist=[select id,subject,accountid from task where subject=:parentTask.subject and accountid in: acclist limit 49999];
        set<id> childactivityset=new set<id>();
        //string existingaccountlist;        
        for(task childtask : [select id,subject,accountid from task where subject=:parentTask.subject and accountid in: acclist limit 49999]){
        childactivityset.add(childtask.accountid);            
        }        
        //system.debug(childtasklist);        
        for(account acc: accList){            
            if(!(childactivityset.contains(acc.id))){
                tasktoinsert.add(new Task(whatid=acc.id,ownerid=acc.ownerid,subject=parentTask.subject,status=parentTask.Status,activitydate=parentTask.ActivityDate));
            }
            //Add warning if task already created for any of the selected accounts
            if((childactivityset.contains(acc.id))){
              //ApexPages.Message MyMsg= new ApexPages.Message(ApexPages.Severity.Warning,'Task already created for one of the selected account');
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Task already created for one of the selected account'));
              //system.debug(MyMsg);
            } 
          }        
        //system.debug(tasktoinsert.size());
        //system.debug(tasktoinsert);
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