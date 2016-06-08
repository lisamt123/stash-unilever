/****************************************************************************************************************************
@Author Cognizant
@name IPM_ProjectDocSecContentTriggerHandler
@CreateDate 28/11/2015
@Description Trigger Handler for the IPM_Project_Document_Section_Content__c SObject.
@Version 1.0
@reference  
*/

public with sharing class IPM_ProjectDocSecContentTriggerHandler {
	
	public static String CLASS_NAME = IPM_ProjectDocumentSectionContentHandler.class.getName();		    
    /********************************************************************************
    **@Description: Trigger context of BulkBefore Update
    **@param1 - list of IPM_Project_Document_Section_Content__c object records
    **********************************************************************************/
    
    public void UpdateRecordOwner(list<IPM_Project_Document_Section_Content__c> newprojDocSecConList, list<id>projDocSecIdList){
    	
    	map<id,IPM_Project_Document_Section__c> projDocSecmap;
    	
    	try{
    		projDocSecmap = new map<id,IPM_Project_Document_Section__c>([SELECT Id, IPM_Project_Document__r.IPM_Project__r.ownerid FROM IPM_Project_Document_Section__c where id IN: projDocSecIdList]);
    	}catch(Exception ex)
        {
           ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,'query',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null,null,null,null); 
        }	
    	
    	if(!projDocSecmap.isEmpty()){ 
	    	for(IPM_Project_Document_Section_Content__c seccon:newprojDocSecConList){
	    		if(projDocSecmap.containskey(seccon.IPM_Project_Document_Section__c)){
	    			seccon.ownerid= projDocSecmap.get(seccon.IPM_Project_Document_Section__c).IPM_Project_Document__r.IPM_Project__r.ownerid;
	    			system.debug('@@ Owner Id Updated ' + seccon.ownerid + ' @@ Project Owner Id  ' + projDocSecmap.get(seccon.IPM_Project_Document_Section__c).IPM_Project_Document__r.IPM_Project__r.ownerid );   			
	    		}	 	
	    	}
    	}
    }

}