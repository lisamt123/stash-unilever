/****************************************************************************
@Description : This class is used for uploading an image
@Created Date: March 2015
@Author: Cognizant
@Referenced: IPM_ImageUpload page
*****************************************************************************/

public with sharing class IPM_ImageUploadController {
    //*@Description: Used to store project name
    public String project {get; set;} 
    
    public String isFromEditPage {get; set;} 
    
    //*@Description: Used to store project id
    public String projectId {get; set;} 
    
    //*@Description:True if any error,while uploading image
    public boolean isError{get;set;} 
    
    //*@Description:True if image inserted
    public boolean isInserted{get;set;} 
    
    //*@Description:used to referring bosscard
    public IPM_Bosscard__c bosscard {get; set;}
    
    //*@Description:Used to store image url 
    public string imgurl{get;set;}
    
    //*@Description: Used to referring projects
    public IPM_Project__c projects {get; set;}
    //*@Description: Used to referring projects
    public Boolean hideInfoMsg{get;set;}
    //*@Description:Used to store image id
    public String imgid{get;set;} 
    
    
        
    /****************************************************************************
    @Description : Initialization of the constructor and reading the page Parameters
    *****************************************************************************/
   
    public IPM_ImageUploadController(){
        IPM_IECompatible.ieFix();
        hideInfoMsg=false;
        imgid='';
        isError=false;
        isInserted = false;
        bosscard=new IPM_Bosscard__c ();
        projects=new IPM_Project__c();
        imgurl=IPM_ConstantUtils.IMAGE_URL;
        project =ApexPages.currentPage().getParameters().get('isProject');
        projectId =ApexPages.currentPage().getParameters().get('id');
        isFromEditPage =ApexPages.currentPage().getParameters().get('isEdit');
        system.debug('isFromEditPage>>>***'+isFromEditPage );
        
    } 
    
    /****************************************************************************
    @Description : Getter Setter for the document.
    @Return: Document
    *****************************************************************************/
    public Document document {
        get {
            if (document == null)
                document = new Document();
            
            return document;
        }
        set;
    }
    
    /****************************************************************************
    @Description : This method is used for uploading the image
    @Return: Page Reference
    *****************************************************************************/

    public PageReference upload(){
        ValidateFile();
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = UserInfo.getUserId(); // put it in running user's folder
        Savepoint sp = Database.setSavepoint();//setting the save point
        
        try {
            if(isError){
                insert document;
                 
                imgid=document.Id;
                if(project=='true'){
                    projects.id=projectId;
                    projects.IPM_Project_Logo__c='<img src='+imgurl + IPM_ConstantUtils.SERVLET_URL +document.Id+'>';
                    projects.IPM_Project_Logo_Id__c=imgid;
                    update projects;
                    isInserted = true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.IPM_File_Uploaded_Successfully));
                }
                else{
                    bosscard.id=projectId;
                    bosscard.IPM_Bosscard_Logo__c='<img src='+imgurl + IPM_ConstantUtils.SERVLET_URL +document.Id+'>';
                    bosscard.IPM_Bosscard_Logo_Id__c=imgid;
                    update bosscard;
                    isInserted = true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.IPM_File_Uploaded_Successfully));
                }  
            } 
            return null;
        }
       
        catch (Exception ex) {
            isError=false;
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),'IPM_ImageUploadController',
                        'upload',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            
            // Rollback to the previous  values
            Database.rollback(sp);
            
            return null;
        } 
        
        finally {
            document.body = null; 
            document = new Document();
        }
           
        
    }
    public void ValidateFile(){
        boolean fileError=false;
        if(document.name!=null){
            if(document.name.contains(IPM_ConstantUtils.FILE_TYPE_JPG) || document.name.contains(IPM_ConstantUtils.FILE_TYPE_JPEG) || document.name.contains(IPM_ConstantUtils.FILE_TYPE_PNG) || document.name.contains(IPM_ConstantUtils.FILE_TYPE_GIF) ||
               document.name.contains(IPM_ConstantUtils.FILE_TYPE_BMP) || document.name.contains(IPM_ConstantUtils.FILE_TYPE_PDS) || document.name.contains(IPM_ConstantUtils.FILE_TYPE_PSP) || document.name.contains(IPM_ConstantUtils.FILE_TYPE_THM) ||
               document.name.contains(IPM_ConstantUtils.FILE_TYPE_TIF) || document.name.contains(IPM_ConstantUtils.FILE_TYPE_YUV)){
                   isError=true;
                   hideInfoMsg=true;
               }else{
                   isError=false;
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.IPM_ImageFormat));
               }
        }
        List<ApexPages.Message> msgList = ApexPages.getMessages();
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
             if(String.Valueof(msg).Contains(IPM_ConstantUtils.FILESIZE_LIMIT)){
                 fileError=true;
             }
             
        }
      if(document.body==null && !fileError){
            isError=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.IPM_ImageRequired));
            
        }
        
    }
}