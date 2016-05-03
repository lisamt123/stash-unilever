/*****************************************************************************************************************************
   @Author :Nandini KV
   @name : IPM_UploadBusinessCase
   @CreateDate : 17/Aug/2015
   @Description : This is a controller class for IPM_UploadBusinessCase Page, this upload the attached file 
   @              to project.
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/


public with sharing class IPM_UploadBusinessCase{
  public transient Attachment objAttachment {set;get;}// Attachment object for updating.
  public transient Blob filebody{get;set;}// Attachment content 
  public transient String fileName{get;set;}// Name of the attached file.
  public transient String projId; // to get the page parameter.
  public IPM_UploadBusinessCase() {
  }
  
  public pagereference saveBusinessCase(){
  	try{
	    objAttachment = new Attachment();
	    objAttachment.body = filebody;
	    objAttachment.Name = fileName;
	    projId = ApexPages.currentPage().getParameters().get('parentId'); // get the page parameter.
	    objAttachment.ParentId = projId;
	   if(objAttachment.body.size() < = IPM_ConstantUtils.fileSize){
	        insert objAttachment;
	        ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.Info, label.IPM_UpdateBusinessCase_MSG1);
	        ApexPages.addMessage(myMsg1);
	    }else{
	        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, label.IPM_UpdateBusinessCase_MSG2);
	        ApexPages.addMessage(myMsg);
	    }
  	}catch(Exception ex){
    		 ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),'IPM_UploadBusinessCase',
               'saveBusinessCase',ex.getMessage(),ex, IPM_ConstantUtils.ERROR,
                null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
    }
    return null;
  }

}