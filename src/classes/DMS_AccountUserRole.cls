/*********************************************************************
Name: DMS_AccountUserRole

Purpose: 
Class used by the Trigger when the Record is updated. 

History 

VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	CARLOS HENRIQUE  23/05/2016  INITIAL DEVELOPMENT.
***********************************************************************/
public with sharing class DMS_AccountUserRole 
{ 
    
    /*
* Purpose: Create a Partner User when the option "Enable as Partner" is configured
* on the Account Object
* Parameters: AccountId
* Returns: void 
*/
    @Future
    public static void createPartner(List<Id> idAccount) 
    {
        try 
        {
            Boolean isPartner = false;
            List<UserRole> userRole = new List<UserRole>();
            List<UserRole> userAccount = [SELECT Id, PortalAccountId FROM UserRole WHERE PortalAccountId =: idAccount];  
            List<Account> listAccount = [SELECT id, IsPartner FROM Account WHERE Id =: idAccount];
            
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
            SYSTEM.debug(DMS_GlobalConstants.EXCEPTION_MESSAGE + e.getCause() + e.getMessage() + e.getLineNumber());
        }
    }           
}