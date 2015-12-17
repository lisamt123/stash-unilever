public with sharing class AF_CloseAndRefresh {
	
	public boolean IsCloseAndRefresh {get;set;}
	public boolean IsError {get;set;}
	public string ErrorMessage {get;set;}	
	public boolean ShowStandardMessage {get;set;}
	public boolean ShowCustomMessage {get;set;}


	public AF_CloseAndRefresh()
	{
		try
		{
			if(ApexPages.currentPage().getParameters().get('IsError') != 'true')
        	{	
        		IsCloseAndRefresh = true;
        		IsError = false;
	        } 
	        else
	        {
	        	IsCloseAndRefresh = false;
	        	IsError = true;
	        	ShowStandardMessage = true;
	        	ShowCustomMessage = false;
	        	if(ApexPages.currentPage().getParameters().get('ErrorMessage') != null)
	        	{
	        		ErrorMessage = ApexPages.currentPage().getParameters().get('ErrorMessage');
	        		ShowStandardMessage = false;
	        		ShowCustomMessage = true;
	        	}	        	        	        	      	
	        }
			
		}
		catch(Exception ex)
		{
			ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),'AF_CloseAndRefresh','AF_CloseAndRefresh',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());

		}
		
		
	}
	
}