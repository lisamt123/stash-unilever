/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_CloseAndRefresh
@CreateDate : 8/7/2014
@Description : This is a controller class is used to display the error message, 
@			  
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_CloseAndRefresh {
	public boolean IsCloseAndRefresh {get;set;}
	public boolean IsError {get;set;}
	public string ErrorMessage {get;set;}	
	public boolean ShowStandardMessage {get;set;}
	public boolean ShowCustomMessage {get;set;}
	private static string className_STR=AF_CloseAndRefresh.class.getName();
	/**********************************************************************
*  @Description: Contructor method is used to display the error message 
*  @name : AF_CloseAndRefresh
*  @param : none
*  @return : none
*************************************************************************/    
	public AF_CloseAndRefresh()
	{
		try
		{
			if(ApexPages.currentPage().getParameters().get(AF_Constants.IS_ERROR) != 'true')
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
				if(ApexPages.currentPage().getParameters().get(AF_Constants.ERRORMESSAGE) != null)
				{
					ErrorMessage = ApexPages.currentPage().getParameters().get(AF_Constants.ERRORMESSAGE);
					ShowStandardMessage = false;
					ShowCustomMessage = true;
				}	        	        	        	      	
			}
		}
		catch(Exception ex)
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'AF_CloseAndRefresh',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
		}
	}
}