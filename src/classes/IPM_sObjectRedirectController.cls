/****************************************************************************************************************************
	@Author Cognizant
	@name IPM_ProjectHelper
	@CreateDate 07/02/2017
	@Description 	Generic Component used to handle access related security in Standard Salesforce. 
					Makes use of Custom Permissions to identify DML Actions.
	@Version 1.0
*/

public with sharing class IPM_sObjectRedirectController {
    public List<String> DMLActionList {get;set;}  
    public String viewActionPermission {get;set;}
    public String newActionPermission {get;set;}
    public String fullPermission {get;set;}
    
    public String selectedSObjectType{get;set;}
    public String selectedSObjectId{get;set;}
    public String sObjectPrefix{get;set;}
    public String unAuthorizedAccessMessage{get;set;}
    
    public Map<String,String> objectActionsToPermissions{get;set;} 

    public IPM_sObjectRedirectController()  
    { 
        objectActionsToPermissions = new Map<String,String>();
        DMLActionList = new List<String>();
        sObjectPrefix  = unAuthorizedAccessMessage = IPM_ConstantUtils.BLANK;      
    }
    
    /* Method to create Permission Name Convention and Validate against current User*/
    
    public void getSetUp() 
    {
        sObjectPrefix = selectedSObjectType.remove(IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);    
        unAuthorizedAccessMessage = Label.IPM_UNAUTHORIZED;   
        
        newActionPermission = sObjectPrefix+IPM_ConstantUtils.NEW_ACCESS; 
        viewActionPermission = sObjectPrefix + IPM_ConstantUtils.VIEW_ACCESS;
        fullPermission =  sObjectPrefix + IPM_ConstantUtils.FULL_ACCESS;

        DMLActionList = new List<String>{IPM_ConstantUtils.EDIT_ACCESS,IPM_ConstantUtils.DELETE_ACCESS}; 
        for(String action : DMLActionList)
        {
            objectActionsToPermissions.put(action,sObjectPrefix+action);  
        }
    } 
}