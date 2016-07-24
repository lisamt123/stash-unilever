/**********************************************************************
Purpose: Helper Class used to calculate TPR.
History :
VERSION AUTHOR         DATE         DETAIL Description
1.0     Accenture    12/Jul/2016     Draft                     
***********************************************************************/
public class FS_AccountPlanHelper {
 public static void approveDefinedObjective(List<FS_Account_Plan__c> accountPlanList,Map<Id, FS_Account_Plan__c> accountplanOldMap){
     List<FS_Defined_Objective__C> ObjList=new List<FS_Defined_Objective__C>();
            List<FS_Defined_Objective__C> ObjToUpdate=new List<FS_Defined_Objective__C>();
            //To get all the defined objectives where corresponding account plan is approved    
            ObjList=[select id,FS_account_plan__C,FS_approved__C,FS_status__c from FS_Defined_Objective__C where FS_account_plan__C in : Trigger.new];
            
            for (FS_Account_Plan__C AccPlan : accountPlanList){
                //Execute only when the account plan status got changed
                if (AccPlan.fs_status__C != accountplanOldMap.get(AccPlan.Id).fs_status__C) {          
                    for(FS_Defined_Objective__C Obj : ObjList){
                        if(Obj.FS_account_plan__C==AccPlan.id){
                            //If account plan gets approved then update status of the associated objective as Approved
                            if(AccPlan.fs_status__c=='Approved'){
                                //Change approved and status on defined objective             
                                Obj.FS_approved__c=true;
                                Obj.FS_status__C='Approved';
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
     public static void rejectDefinedObjective(List<FS_Account_Plan__c> accountPlanList,Map<Id, FS_Account_Plan__c> accountplanOldMap){
     List<FS_Defined_Objective__C> ObjList=new List<FS_Defined_Objective__C>();
            List<FS_Defined_Objective__C> ObjToUpdate=new List<FS_Defined_Objective__C>();
            //To get all the defined objectives where corresponding account plan is approved    
            ObjList=[select id,FS_account_plan__C,FS_approved__C,FS_status__c from FS_Defined_Objective__C where FS_account_plan__C in : Trigger.new];
            
            for (FS_Account_Plan__C AccPlan : accountPlanList){
                //Execute only when the account plan status got changed
                if (AccPlan.fs_status__C != accountplanOldMap.get(AccPlan.Id).fs_status__C) {          
                    for(FS_Defined_Objective__C Obj : ObjList){
                        if(Obj.FS_account_plan__C==AccPlan.id){                            
                            //If account plan gets declined then update status of the associated objective as Declined
                            if(AccPlan.fs_status__c=='Planning' &&	accountplanOldMap.get(AccPlan.Id).fs_status__C=='Approval Requested'){
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