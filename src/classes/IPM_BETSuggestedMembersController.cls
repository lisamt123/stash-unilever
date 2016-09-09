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
        if(ApexPages.currentPage().getParameters().get('id')!=null){
            projectId = ApexPages.currentPage().getParameters().get('id');
        }
        PageReference pageRef = new PageReference(System.label.IPM_ProjectOverview+'?id='+projectId+'&showMembers=true');
        IPM_Project__c project= [select id,bet__c from IPM_Project__c where id =: projectId];
        try{
            if(ApexPages.currentPage().getParameters().get('BETId')!=null && project.bet__c== null){
               project.bet__c = ApexPages.currentPage().getParameters().get('BETId');
               update project;
            }
        }catch(Exception ex){
<<<<<<< HEAD
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
          ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_BETSuggestedMembersController.class.getName(),'updateBETonProject',ex.getMessage(), Ex,IPM_ConstantUtils.ERROR, null, ex.getStackTraceString(), null, null) ;
            throw new IPM_CustomException(System.Label.IPM_BET_BETUpdate_failure_ErrMsg);  
        }
=======
		  //Enqueue IPM_UpdateBETOnProject_Queueable class  in case there is an exception due to concurrent update
		  IPM_UpdateBETOnProject_Queueable updateBETOnProjectQ = new IPM_UpdateBETOnProject_Queueable(); 
          updateBETOnProjectQ.betId =betId;
          updateBETOnProjectQ.projectId =projectId; 
          System.enqueueJob(updateBETOnProjectQ);  
        } 
>>>>>>> e7762774510a0def457f22eaa4caec8bb9c29733
        return pageRef ;
    }
    public class IPM_CustomException extends Exception{
        // Custom Exception class
    }
    
}