/**********************************************************************
Name: DMS_AccountUserRole
ConfigureOpportunity() Copyright © 2016 Salesforce
====================================================== 
====================================================== 
Purpose: 
Class used by the Trigger when the Record is updated. 
====================================================== 
======================================================
History 

VERSION AUTHOR DATE DETAIL Description
1.0 	CHACL  23/05/2016  INITIAL DEVELOPMENT.
***********************************************************************/
public class DMS_AccountUserRole_CC 
{
    
    /*******************************************************************
    * Purpose: Create a Partner User when the option "Enable as Partner" is configured
    * on the Account Object
    * Parameters: AccountId
    * Returns: void 
    ********************************************************************/
    @Future
    public static void createPartner(List<Id> idAccount) 
    {
        try 
        {
            Boolean isPartner = false;
            List<UserRole> userRole = new List<UserRole>();
            List<UserRole> userAccount = getUserRole(idAccount);
            List<Account> listAccount = getPartnerResult(idAccount);
            
            for(Account vAccounts : listAccount) 
            {
                isPartner = vAccounts.IsPartner;
                
                if(isPartner && userAccount.size() < 3) 
                {
                    for (Integer quantity = userAccount.size(); quantity < 3; quantity++) 
                    {    
                        UserRole role = new UserRole();
                        role.portalType = DMS_GlobalConstants.USER_PORTAL_TYPE; // use 'CustomerPortal' for customer portal roles
                        role.PortalAccountId = vAccounts.Id;
                        role.CaseAccessForAccountOwner = DMS_GlobalConstants.EDIT; //Modify as needed
                        role.OpportunityAccessForAccountOwner = DMS_GlobalConstants.READ; //Modify as needed
                        userRole.add(role);
                    }      
                }
            }
            insert(userRole);
        } 
        catch (Exception e)  
        {
            SYSTEM.debug('Exception occured on the code: ' + e.getMessage());
        }
    }
    
    /*******************************************************************
    * Purpose: Retrieve the information from the UserRole
    * Parameters: List<Id>
    * Returns: List<UserRole> 
    ********************************************************************/
    private static List<UserRole> getUserRole(List<Id> id) 
    {
        return [SELECT Id, PortalAccountId FROM UserRole WHERE PortalAccountId =: id];
    }
    
    /*******************************************************************
    * Purpose: Return the result from the Account, if is Partner or not.
    * Parameters: List<Id>
    * Returns: List<Account> 
    ********************************************************************/
    private static List<Account> getPartnerResult(List<Id> id) 
    {
        return [SELECT IsPartner FROM Account WHERE Id =: id];
    }
}