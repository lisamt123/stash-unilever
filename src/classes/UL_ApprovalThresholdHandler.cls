Public Class UL_ApprovalThresholdHandler{
    public static void CareerLevel(list<UL_Approval_Threshold__c> CareerLevelList){
//Assumption - Always a single record shall be created from the UI.

        List<UL_Approval_Threshold__c> ApprovalThresholdList = [SELECT Id FROM UL_Approval_Threshold__c WHERE UL_Career_Level__c=:CareerLevelList[0].UL_Career_Level__c AND UL_Sales_Organization__c =:CareerLevelList[0].UL_Sales_Organization__c];
        If(ApprovalThresholdList.size() > 0){
            CareerLevelList[0].addError('The Career Level for this Sales Org already Exists'); 
        } 
    }
}