public class FS_AccountPlanHandler {
    
    public void updateDefinedObjectiveonapproval (List<FS_Account_Plan__c> newAccountPlanList,Map<id,FS_Account_Plan__c> newAccountPlanOldMap){
        FS_AccountPlanHelper.approveDefinedObjective(newAccountPlanList,newAccountPlanOldMap);
        FS_AccountPlanHelper.rejectDefinedObjective(newAccountPlanList,newAccountPlanOldMap);
    }
}