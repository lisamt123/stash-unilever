// /*************************************************************************************
*@Description:use for security to get permission assigned to current logged in user
*@Author: Cognizant
*@Created Date: 07/09/2015 
*@Copyright 2015  Unilever  
*******************************************************************************************/

public with sharing class IPM_CustomPermission {

    private Set<String> customPermissionNames;

    private Set<String> customPermissionsForCurrentUser;

    
    public Boolean hasPermission(String customPermissionName) {
        // Demand load the custom permissions from the database     
        if(customPermissionNames==null){
            init();
        }
            
        // Has this user been assigned this custom permission?
        return customPermissionsForCurrentUser.contains(customPermissionName);
    }

    /*
    *@Description:Loads Custom Permissions sets
     
    */
    private void init() {

        customPermissionNames = new Set<String>();
        customPermissionsForCurrentUser = new Set<String>();
        
        List<IPM_User_Profile__c>userProfileList=new List<IPM_User_Profile__c>();
        userProfileList=[SELECT ID FROM IPM_User_Profile__c WHERE IPM_User__c=:UserInfo.getUserId() 
                         AND (IPM_Central_Team__c=true OR IPM_User_Function__c=:IPM_ConstantUtils.PERMISSION_USER_ROLE_DEPUTY_BUSINESS_PARTNER) LIMIT 1];
        List<IPM_Company_Card__c>companyCardList=new List<IPM_Company_Card__c>();
        companyCardList=[SELECT ID FROM IPM_Company_Card__c WHERE IPM_Business_Partner__c=:UserInfo.getUserId() LIMIT 1];
        if(!userProfileList.isEmpty() || !companyCardList.isEmpty()){
            // Query the full set of Custom Permissions for the given namespace
            Map<Id, String> customPermissionNamesById = new Map<Id, String>();
            List<CustomPermission> customPermissions = 
                [SELECT Id, DeveloperName FROM CustomPermission LIMIT 500];
            for(CustomPermission customPermission : customPermissions) {
                customPermissionNames.add(customPermission.DeveloperName);
                customPermissionNamesById.put(customPermission.Id, customPermission.DeveloperName);
            }

            // Query to determine which of these custome settings are assigned to this user
            List<SetupEntityAccess> setupEntities = 
                [SELECT SetupEntityId
                    FROM SetupEntityAccess
                    WHERE SetupEntityId in :customPermissionNamesById.keySet() AND
                          ParentId
                            IN (SELECT PermissionSetId 
                                FROM PermissionSetAssignment
                                WHERE AssigneeId = :UserInfo.getUserId()) LIMIT 10];  
            for(SetupEntityAccess setupEntity : setupEntities) {
                customPermissionsForCurrentUser.add(customPermissionNamesById.get(setupEntity.SetupEntityId));
            } 
        }
    }

}