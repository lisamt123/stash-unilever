/**********************************************************************
Purpose: Helper Class used to approve defined objective and opportunities based on account plan approval.
History :
VERSION AUTHOR         DATE         DETAIL Description
1.0     Accenture    12/Jul/2016     Draft                     
***********************************************************************/
public with sharing class FS_AccountPlanHelper {
    
/* * approveDefinedObjective Method for approve defined objective
*  @name approveDefinedObjective
*  @param List<FS_Account_Plan__c> accountPlanList,Map<Id, FS_Account_Plan__c> accountplanOldMap
*  @return 
*  @throws 
*/
 Private static final string STATUS_APPROVED='Approved';
 Private static final string STATUS_APPROVAL_REQUESTED='Approval Requested';
 Private static final string STATUS_PLANNING='Planning'; 
 public void approveDefinedObjective(List<FS_Account_Plan__c> accountPlanList,Map<Id, FS_Account_Plan__c> accountplanOldMap){
            //List<FS_Defined_Objective__C> objList=new List<FS_Defined_Objective__C>();
            List<FS_Defined_Objective__C> objToUpdate=new List<FS_Defined_Objective__C>();
            //To get all the defined objectives where corresponding account plan is approved    
            //objList=[select id,FS_account_plan__C,FS_approved__C,FS_status__c from FS_Defined_Objective__C where FS_account_plan__C in : accountPlanList];
            Map<Id,List<Fs_Defined_Objective__c>> mapAccPlanObj=new Map<Id,List<FS_Defined_Objective__c>>();
            List<Fs_Defined_Objective__c> definedObjList=new List<FS_Defined_Objective__C>();
         for(FS_Defined_Objective__C obj : [select id,FS_account_plan__C,FS_approved__C,FS_status__c
                                        from FS_Defined_Objective__C
                                        where FS_account_plan__C in : accountPlanList limit 49999]){
         definedObjList=new List<FS_Defined_Objective__c>();
         If(mapAccPlanObj.containsKey(obj.FS_Account_Plan__c)){
            definedObjList=MapAccPlanObj.get(obj.FS_Account_Plan__c);
         }
         definedObjList.add(obj);
         mapAccPlanObj.put(obj.FS_Account_Plan__c,definedObjList);
     }                
                for (FS_Account_Plan__C accPlan : accountPlanList){
                //Execute only when the account plan status got changed to approved
                    if (accPlan.fs_status__C != accountplanOldMap.get(accPlan.Id).fs_status__C && accPlan.fs_status__c.equals(STATUS_APPROVED) && mapAccPlanObj.containsKey(accPlan.Id)){
                    definedObjList=new List<FS_Defined_Objective__c>();
                    definedObjList=mapAccPlanObj.get(accPlan.Id);
                    for(FS_Defined_Objective__C obj : definedObjList){                                      
                                obj.FS_approved__c=true;
                                obj.FS_status__C=STATUS_APPROVED;
                                objToUpdate.add(Obj); 
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
                ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'NAFS_AccountplanHelper', 'UpdateObjField', e.getMessage(), e, null, null, null, 0,'Food Solution');
            }
 }
 
/* * rejectDefinedObjective Method for reject defined objective
*  @name rejectDefinedObjective
*  @param List<FS_Account_Plan__c> accountPlanList,Map<Id, FS_Account_Plan__c> accountplanOldMap
*  @return 
*  @throws 
*/ 
     public void rejectDefinedObjective(List<FS_Account_Plan__c> accountPlanList,Map<Id, FS_Account_Plan__c> accountplanOldMap){
            //List<FS_Defined_Objective__C> objList=new List<FS_Defined_Objective__C>();
            List<FS_Defined_Objective__C> objToUpdate=new List<FS_Defined_Objective__C>();
            //To get all the defined objectives where corresponding account plan is approved    
            //objList=[select id,FS_account_plan__C,FS_approved__C,FS_status__c from FS_Defined_Objective__C where FS_account_plan__C in : accountPlanList];
            Map<Id,List<Fs_Defined_Objective__c>> mapAccPlanObj=new Map<Id,List<FS_Defined_Objective__c>>();
            List<Fs_Defined_Objective__c> definedObjList=new List<FS_Defined_Objective__C>();
     for(FS_Defined_Objective__C obj : [select id,FS_account_plan__C,FS_approved__C,FS_status__c 
                                        from FS_Defined_Objective__C
                                        where FS_account_plan__C in : accountPlanList limit 49999]){
         definedObjList=new List<FS_Defined_Objective__c>();
         If(mapAccPlanObj.containsKey(obj.FS_Account_Plan__c)){
            definedObjList=mapAccPlanObj.get(obj.FS_Account_Plan__c);
         }
         definedObjList.add(obj);
         mapAccPlanObj.put(obj.FS_Account_Plan__c,definedObjList);
     }
            for (FS_Account_Plan__C accPlan : accountPlanList){
                //Execute only when the account plan status got declined
                if (accPlan.fs_status__C != accountplanOldMap.get(accPlan.Id).fs_status__C && accPlan.fs_status__c.equals(STATUS_PLANNING) && accountplanOldMap.get(accPlan.Id).fs_status__C.equals(STATUS_APPROVAL_REQUESTED) && mapAccPlanObj.containsKey(accPlan.Id)) { 
                    definedObjList=new List<FS_Defined_Objective__c>();
                    definedObjList=mapAccPlanObj.get(accPlan.Id);
                    for(FS_Defined_Objective__C obj : definedObjList){                           
                                obj.FS_status__C=STATUS_PLANNING;
                                objToUpdate.add(obj);  
                            }
                        }                        
                    }        
                //}            
            try{
                if(!objToUpdate.isEmpty()){
                    Update objToUpdate;
                }
            }
            Catch(DmlException e){
                System.debug( 'The following exception has occurred: '+e.getMessage() );
                ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'NAFS_AccountplanHelper', 'UpdateObjField', e.getMessage(), e, null, null, null, 0,'Food Solution');
            }
}
}