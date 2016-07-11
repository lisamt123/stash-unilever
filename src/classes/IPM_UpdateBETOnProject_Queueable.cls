/*
    @Description: This class is to update BET on project in case there is an exception due to record lock while updating BET on project 
    after creating a new BET through 'Create new BET ' pop up during phase change from Ideas to Feasibility.
    @Author: Cognizant Technology
    @Date: July 2016
*/
public with sharing class IPM_UpdateBETOnProject_Queueable implements Queueable {  
	
	public Id betId ; //BET Id to be updated on the  project 
	
	public Id projectId ; // project Id of the  project to be updated with BET
	
			  
	public void execute(QueueableContext qContext) 
    {
        try 
        {
			IPM_Project__c projTobeLinked = new IPM_Project__c();
			projTobeLinked = [select bet__c,id from IPM_Project__c where id = :projectId  LIMIT 1  FOR UPDATE];
			
			if(betId!=null) 
			{
				projTobeLinked.BET__c = betId; 
				update projTobeLinked;
			}
		
        }
        catch(Exception ex)
        {
         	/*Retry logic on unable to lock row - Record currently unavailable errors
         	  UNABLE_TO_LOCK_ROW
              Record Currently Unavailable
              Unable to obtain exclusive access to this record. */ 
            
         	if(ex.getMessage().contains('UNABLE_TO_LOCK_ROW') ||ex.getMessage().contains('Record Currently Unavailable') ||ex.getMessage().contains('Unable to obtain exclusive access to this record'))
         	{         	
         		IPM_UpdateBETOnProject_Queueable updateBETOnProjectQ = new IPM_UpdateBETOnProject_Queueable(); 
                updateBETOnProjectQ.betId =betId;
                updateBETOnProjectQ.projectId =projectId; 
                System.enqueueJob(updateBETOnProjectQ);
         	}
         	else
         	{
         		ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_UpdateBETOnProject_Queueable.class.getName(),'IPM_UpdateBETOnProject_Queueable.execute',ex.getMessage(), Ex,IPM_ConstantUtils.ERROR, null, ex.getStackTraceString(), null, null) ;	
         	}
        } 
    }
    
}