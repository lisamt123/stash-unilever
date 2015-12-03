/****************************************************************************************************************************
   @Author: Cognizant
   @Name: IPM_ConsumerImageUploadController
   @Created Date: 25/06/2015
   @Description: This class is used for uploading an image for Consumer Evidence Concept
   @Version: 1.0 
   @Reference: IPM_Consumer_Evidence Component
*/
public with sharing class IPM_ConsumerImageUploadController {
    
    public String projId {get; set;} //Used to store project id
    public String projDocSecId {get; set;} //Used to store Project Document Section id
    public String projDocSecConId {get; set;} //Used to store Project Document Section Content id
    public String imgid{get;set;} //Used to store image id
    public boolean isError{get;set;} //True if any error,while uploading image
    public IPM_Project_Document_Section_Content__c projDocSecCon {get; set;} //For getting content record
    public string imgurl{get;set;} //Used to store image url 
    public Document document { //Getter Setter for the document
        get {
            if (document == null){
                document = new Document();
            }
            return document;
        }
        set;
    }
    //For exception handler
    private static final String IPM_CONSUMERIMAGEUPLOADCONTROLLER_STR = IPM_ConsumerImageUploadController.class.getName();
    private static final String UPLOAD_STR = 'upload';
    
    /************************************************************************************************************************
    *  Description Initialization of the constructor and reading the page Parameters
    *************************************************************************************************************************/
    public IPM_ConsumerImageUploadController (){
        IPM_IECompatible.ieFix();//For IE Compatibility
        imgid=IPM_ConstantUtils.BLANK;
        isError=true;
        projDocSecCon=new IPM_Project_Document_Section_Content__c();
        imgurl=IPM_ConstantUtils.IMAGE_URL;
        projId=ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_ID);
        projDocSecId=ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_PROJ_DOC_SEC_ID);
        projDocSecConId=ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_PROJ_DOC_SEC_CON_ID);
    } 

    /************************************************************************************************************************
    *  Description This method is used for uploading the image
    *  @name upload
    *  @param none
    *  @return PageReference
    *  @throws dml exception
    */
    public PageReference upload(){
        Document doc;
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = UserInfo.getUserId(); // put it in running user's folder
        
        try {
            if(document.name.contains(IPM_ConstantUtils.FILE_TYPE_JPG) || document.name.contains(IPM_ConstantUtils.FILE_TYPE_JPEG) || document.name.contains(IPM_ConstantUtils.FILE_TYPE_PNG) || document.name.contains(IPM_ConstantUtils.FILE_TYPE_GIF) ||
               document.name.contains(IPM_ConstantUtils.FILE_TYPE_BMP) || document.name.contains(IPM_ConstantUtils.FILE_TYPE_PDS) || document.name.contains(IPM_ConstantUtils.FILE_TYPE_PSP) || document.name.contains(IPM_ConstantUtils.FILE_TYPE_THM) ||
               document.name.contains(IPM_ConstantUtils.FILE_TYPE_TIF) || document.name.contains(IPM_ConstantUtils.FILE_TYPE_YUV)){
                insert document;
                doc = [SELECT id, name, description FROM Document WHERE Id=:document.Id];
                imgid=doc.Id;
                if(!String.isBlank(projDocSecConId)){
                    projDocSecCon.id=projDocSecConId;
                    projDocSecCon.IPM_Consumer_Evidence_Image__c='<img src='+imgurl + IPM_ConstantUtils.SERVLET_URL +doc.Id+'>';
                    projDocSecCon.IPM_Consumer_Evidence_Logo_Id__c=imgid;
                    update projDocSecCon;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.IPM_File_Uploaded_Successfully));
                    isError=false;
                }
                return null;
            } 
            else{
                isError=true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.IPM_ImageFormat));
                return null;
            }  
             
        }
        catch (DMLException ex) {
            isError=true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.IPM_ImageRequired));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CONSUMERIMAGEUPLOADCONTROLLER_STR,
                        UPLOAD_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            return null;
        } 
        catch (Exception ex) {
            isError=true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.IPM_ImageRequired));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CONSUMERIMAGEUPLOADCONTROLLER_STR,
                        UPLOAD_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            return null;
        } 
        finally {
            document.body = null; 
            document = new Document();
        }
    }
}