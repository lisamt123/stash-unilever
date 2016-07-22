trigger AccountPlanTrigger on FS_Account_Plan__c (after insert, after update, before insert, before update) {
    //Update approved and status on defined objective after account plan record is modified
    if(trigger.isAfter && trigger.isUpdate){
    if(FS_Utility.runOnce()){
    List<FS_Defined_Objective__C> ObjList=new List<FS_Defined_Objective__C>();
    List<FS_Defined_Objective__C> ObjToUpdate=new List<FS_Defined_Objective__C>();
    //To get all the defined objectives where corresponding account plan is approved    
    ObjList=[select id,FS_account_plan__C,FS_approved__C,FS_status__c from FS_Defined_Objective__C where FS_account_plan__C in : Trigger.new];
        
     for (FS_Account_Plan__C AccPlan : Trigger.new){
     //Execute only when the account plan status got changed
     if (AccPlan.fs_status__C != Trigger.oldMap.get(AccPlan.Id).fs_status__C) {          
     for(FS_Defined_Objective__C Obj : ObjList){
            if(Obj.FS_account_plan__C==AccPlan.id){
                //If account plan gets approved then update status of the associated objective as Approved
                if(AccPlan.fs_status__c=='Approved'){
                //Change approved and status on defined objective             
                Obj.FS_approved__c=true;
                Obj.FS_status__C='Approved';
                ObjToUpdate.add(Obj); 
                }
                //If account plan gets declined then update status of the associated objective as Declined
                if(AccPlan.fs_status__c=='Planning' &&	Trigger.oldMap.get(AccPlan.Id).fs_status__C=='Approval Requested'){
                Obj.FS_status__C='Planning';
                ObjToUpdate.add(Obj);  
                }
            }
         
        }        
    }
     }
        try{
              if(!ObjToUpdate.isEmpty()){
                  Update ObjToUpdate;
              }
          }
          Catch(DmlException e){
              System.debug( 'The following exception has occurred: '+e.getMessage() );
              ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'NAFS_OpportunityHelper', 'UpdateOppField', e.getMessage(), e, null, null, null, 0,'Food Solution');
          }
   
    }
    }
}