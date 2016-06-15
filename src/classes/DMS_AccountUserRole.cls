/*********************************************************************
Name: DMS_AccountUserRole

Purpose: 
Class used by the Trigger when the Record is updated. 

History 

VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	CARLOS HENRIQUE  23/05/2016  INITIAL DEVELOPMENT.
***********************************************************************/
public class DMS_AccountUserRole 
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
            SYSTEM.debug(DMS_GlobalConstants.EXCEPTION_MESSAGE + e.getCause() + e.getMessage() + e.getLineNumber());
        }
    }
    
    /*
    * Purpose: Retrieve the information from the UserRole
    * Parameters: List<Id>
    * Returns: List<UserRole> 
    */
    private static List<UserRole> getUserRole(List<Id> id) 
    {
        List<UserRole> returnGetUserRole;
        try {
            returnGetUserRole = [SELECT Id, PortalAccountId FROM UserRole WHERE PortalAccountId =: id];    
        } catch(QueryException e) {
            SYSTEM.debug(DMS_GlobalConstants.ERROR_GET_USER_ROLE + e.getCause() + e.getMessage() + e.getLineNumber());
        }

            return returnGetUserRole;
    }
    
    /*
    * Purpose: Return the result from the Account, if is Partner or not.
    * Parameters: List<Id>
    * Returns: List<Account> 
    **/
    private static List<Account> getPartnerResult(List<Id> id) 
    {
        List<Account> returnGetPartnerResult;
        try {
            returnGetPartnerResult = [SELECT IsPartner FROM Account WHERE Id =: id];
        } catch(QueryException e) {
            SYSTEM.debug(DMS_GlobalConstants.ERROR_PARTNER_RESULT + e.getCause() + e.getMessage() + e.getLineNumber());
        }
        	return returnGetPartnerResult;
    }
}