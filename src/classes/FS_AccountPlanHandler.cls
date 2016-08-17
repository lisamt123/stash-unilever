/**********************************************************************
Purpose: Handler class is used to approve defined objective and opportunity based on account plan approval
History :
VERSION AUTHOR         DATE         DETAIL Description
1.0     Accenture    12/Jul/2016     Draft                     
***********************************************************************/
/* * Handler class FS_AccountPlanHandler for Account Plan trigger
*  @name FS_AccountPlanHandler
*  @param
*  @return 
*  @throws 
*/ 
public without sharing class FS_AccountPlanHandler{
 //New instance for Helper class
Private FS_AccountPlanHelper helper=new FS_AccountPlanHelper(); 
/* * accountPlanApproval Method to approve defined objective and opportunity on account plan approval
*  @name accountPlanApproval
*  @param List<FS_Account_Plan__c> newAccountPlanList,Map<id,FS_Account_Plan__c> newAccountPlanOldMap
*  @return 
*  @throws 
*/
    public void accountPlanApproval(List<FS_Account_Plan__c> newAccountPlanList,Map<id,FS_Account_Plan__c> newAccountPlanOldMap){
        try{
            //Call helper method for approval
            helper.approveDefinedObjective(newAccountPlanList,newAccountPlanOldMap);
            //Call helper method to approve opportunities
            helper.approveOpportunities(newAccountPlanList,newAccountPlanOldMap);
            //Call method for rejection
            helper.rejectDefinedObjective(newAccountPlanList,newAccountPlanOldMap);
            }
            Catch(DmlException e){
                System.debug( 'The following exception has occurred: '+e.getMessage() );
                ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'NAFS_AccountplanHandler', 'UpdateFieldOnApproval', e.getMessage(), e, null, null, null, 0,'Food Solution');
            }
        
    }  
}