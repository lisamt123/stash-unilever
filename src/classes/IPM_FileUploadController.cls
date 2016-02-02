/****************************************************************************************************************************
@Author: Cognizant
@Name: IPM_FileUploadController
@Created Date: 26/12/2014
@Description: This class is used for uploading file
@Version: 1.0
@Reference: IPM_ProjectDocumentSectionEditor Page
*/
public with sharing class IPM_FileUploadController {
    //For exception handler
    private static final String IPM_FILEUPLOADCONTROLLER_STR = IPM_FileUploadController.class.getName();
    private static final String SAVEDOC_STR='Savedoc';
    public Id parentId{get; set;} //Used to store current project document section id
    public Id projectId{get; set;} //Used to store current project id
    public string fileType{get; set;} //Used to store section type
    public transient Attachment myfile;//Used to attachment
    public Boolean isUpload{get; set;}
    public Attachment myfiles{ //Getter for the attachment
        get {
            if (myfiles== null){
                myfiles= new Attachment ();
		    }
            
            return myfiles;
        }
        set;
        
    }
    
    /************************************************************************************************************************
    *  Description Constructor Getting Project Id From Page URL Parameter
    *  @name IPM_FileUploadController
    */
    public IPM_FileUploadController(){
        IPM_IECompatible.ieFix();//For IE Compatibility
        projectId=ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_ID);
        parentId=ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_PROJ_DOC_SEC_ID);
        fileType=ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_SECTION_TYPE);
        isUpload=false;
    }

    /************************************************************************************************************************
    *  Description This method is used for saving document
    *  @name Savedoc
    *  @param none
    *  @return PageReference
    *  @throws dml exception
    */
    public PageReference saveDoc(){
        if(Schema.sObjectType.Attachment.isCreateable()){
            Attachment docAttachment = new Attachment();
            try{
                docAttachment.parentId = parentId;
                docAttachment.name=myfiles.name;
                docAttachment.body = myfiles.body;
                docAttachment.Description=fileType; 
                insert docAttachment;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.IPM_File_Uploaded_Successfully));
                isUpload=true;
                return null;
            }
            catch (DMLException ex) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_FILEUPLOADCONTROLLER_STR,
                    SAVEDOC_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
            }
            catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_FILEUPLOADCONTROLLER_STR,
                    SAVEDOC_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            }
            finally {          
                docAttachment.body = null;   
                myfiles.body = null;    
                docAttachment= new Attachment();        
            }        
        } 
        return null;
    }
}