/****************************************************************************************************************************
    @Description: Controller class for IPM_BETSuggestedMembers Visualforce page.
    @Author: Cognizant Technology
    @Date: Jan 2015
*/
public with sharing class IPM_BETSuggestedMembersController{

    public IPM_BETSuggestedMembersController(){
      //constructor
    }
    //Method to update bet on project
    public PageReference updateBETonProject(){
        Id projectId = Null;
		Id betId = null;
        if(ApexPages.currentPage().getParameters().get('id')!=null){
            projectId = ApexPages.currentPage().getParameters().get('id');
        }
		if(ApexPages.currentPage().getParameters().get('BETId')!=null){
			betId = ApexPages.currentPage().getParameters().get('BETId');
		}
        PageReference pageRef = new PageReference(System.label.IPM_ProjectOverview+'?id='+projectId+'&showMembers=true');
        IPM_Project__c project= [select id,bet__c from IPM_Project__c where id =: projectId];
        try{
            if(betId!=null && project.bet__c== null){
               project.bet__c = betId;
               update project;
            }
        }catch(Exception ex){
		  //Call future method in case there is an exception due to concurrent update
		  IPM_BETHelper.updateBETlinktoProject(betId,projectId);
        }
        return pageRef ;
    }
    public class IPM_CustomException extends Exception{
        // Custom Exception class
    }
    
}