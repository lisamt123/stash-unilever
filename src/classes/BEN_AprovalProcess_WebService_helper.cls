/**********************************************************************
Name: BEN_AprovalProcess_WebService_helper Copyright © 2016 Salesforce 
======================================================
======================================================
Purpose: The class used as helper class in Approval process, it have method to check loggedIn user is Approver or not
======================================================
======================================================
History
-------
VERSION     AUTHOR        DATE            DETAIL Description
V1.0         Mahesh         12/01/2017    Helper class for Approval Process for Category Details
***********************************************************************/

global with sharing class BEN_AprovalProcess_WebService_helper {
  
    // method to check loggedIn user is Approver or not
   webservice static String userIsApprover(String userId) {
       String result = 'false';
            
       Id users_Id = ID.valueOf(userId);
       User ApprovalSubUser = [Select Id, UserName from User where ID=:users_Id];
       List< PermissionSet>  permSets = [Select ID, Name from PermissionSet where Name Like '%Approver%'];
       List<PermissionSetAssignment> permsAssigns = [SELECT Id, AssigneeId, PermissionSet.Name FROM PermissionSetAssignment WHERE PermissionSetId IN :permSets];
       for(PermissionSetAssignment psa : permsAssigns){
           if(psa.AssigneeId == ApprovalSubUser.ID){
               result = 'true';  break;
           }  
       }
       return result;
   }

}