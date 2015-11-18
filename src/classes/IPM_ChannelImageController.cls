/****************************************************************************************************************************
   @Author: Cognizant
   @Name: IPM_ChannelImageController
   @Created Date: 2015/01/23
   @Description: To upload images for Customer Channels
   @Version: 1.0
   @Reference: IPM_ChannelImageUpload Page
*/
public with sharing class IPM_ChannelImageController {
    public Id parentId{get; set;} //used to fetch ParentContentId of the current page
    public Id projectId{get; set;} //used to fetch current projectId
    public Id projDocSectId{get; set;} //used to fetch projDocSecId of the current page
    public string channelType{get; set;} //used to fetch type of the channel name of the current page
    public transient Attachment myfile; //used to create new attachment
    public boolean isImageLoaded{get; set;} //For auto closing the popup
    public Boolean hideInfoMsg{get;set;}//For showing valid image formats 
    public IPM_Project_Document_Section_Content__c content{get; set;} //used to store a row of IPM_Project_Document_Section_Content__c object whose Id is equal to parentId
    //For creating a file of attachment type
    public Attachment getmyfile(){
        myfile = new Attachment();
        return myfile;
    }
    //For exception handler
    private static final String IPM_CHANNELIMAGECONTORLLER_STR = IPM_ChannelImageController.class.getName();
    private static final String SAVE_DOC_STR = 'Savedoc';
  
    /************************************************************************************************************************
    *  Description Constructor for the IPM_ChannelImageController class
    */
    public IPM_ChannelImageController(){
        IPM_IECompatible.ieFix();//For IE Compatibility
        projectId=ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_ID);
        projDocSectId=ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_PROJ_DOC_SEC_ID);
        parentId=ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_CONTENT_ID);
        channelType=ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_DESC);
        hideInfoMsg=false;
        isImageLoaded=false;
    }
    
    /************************************************************************************************************************
    *  Description For saving customer channel images
    *  @name Savedoc
    *  @param none
    *  @return void
    *  @throws exception
    */
    public PageReference Savedoc(){
        Attachment atth = new Attachment();
        try{
            if(myfile!=null){
                if(myfile.name.contains(IPM_ConstantUtils.FILE_TYPE_JPG) || 
                    myfile.name.contains(IPM_ConstantUtils.FILE_TYPE_JPEG)|| 
                    myfile.name.contains(IPM_ConstantUtils.FILE_TYPE_PNG)||
                    myfile.name.contains(IPM_ConstantUtils.FILE_TYPE_GIF)||
                    myfile.name.contains(IPM_ConstantUtils.FILE_TYPE_BMP)|| 
                    myfile.name.contains(IPM_ConstantUtils.FILE_TYPE_PDS)||
                    myfile.name.contains(IPM_ConstantUtils.FILE_TYPE_PSP)||
                    myfile.name.contains(IPM_ConstantUtils.FILE_TYPE_THM)||
                    myfile.name.contains(IPM_ConstantUtils.FILE_TYPE_TIF)||
                    myfile.name.contains(IPM_ConstantUtils.FILE_TYPE_YUV)){
                        hideInfoMsg=true;
                        atth.parentId = parentId;
                        atth.name=myfile.name;
                        atth.body = myfile.body;
                        atth.description=channelType;
                        /* insert the attachment */
                        if(atth != null){
                            insert atth;
                        }
                        content=[SELECT Id,IPM_Preposition_Image_1_Id__c,IPM_Preposition_Image_2_Id__c,
                                        IPM_Promotion_Image_1_Id__c,IPM_Promotion_Image_2_Id__c,IPM_Product_Image_1_Id__c,
                                        IPM_Product_Image_2_Id__c,IPM_Pack_Image_1_Id__c,IPM_Pack_Image_2_Id__c,IPM_Price_Image_1_Id__c,
                                        IPM_Price_Image_2_Id__c,IPM_Place_Image_1_Id__c,IPM_Place_Image_2_Id__c 
                                 FROM IPM_Project_Document_Section_Content__c 
                                 WHERE Id=:parentId];
                     
                        if(channelType==IPM_ConstantUtils.PREPOSITION_FIRST_IMAGE){
                            content.IPM_Preposition_Image_1_Id__c=atth.Id;
                        }
                        else if(channelType==IPM_ConstantUtils.PREPOSITION_SECOND_IMAGE){
                            content.IPM_Preposition_Image_2_Id__c=atth.Id;
                        }
                        else if(channelType==IPM_ConstantUtils.PROMOTION_FIRST_IMAGE){
                            content.IPM_Promotion_Image_1_Id__c=atth.Id;
                        }
                        else if(channelType==IPM_ConstantUtils.PROMOTION_SECOND_IMAGE){
                            content.IPM_Promotion_Image_2_Id__c=atth.Id;
                        }
                        else if(channelType==IPM_ConstantUtils.PRODUCT_FIRST_IMAGE){
                            content.IPM_Product_Image_1_Id__c=atth.Id;
                        }
                        else if(channelType==IPM_ConstantUtils.PRODUCT_SECOND_IMAGE){
                            content.IPM_Product_Image_2_Id__c=atth.Id;
                        }
                        else if(channelType==IPM_ConstantUtils.PACK_FIRST_IMAGE){
                            content.IPM_Pack_Image_1_Id__c=atth.Id;
                        }
                        else if(channelType==IPM_ConstantUtils.PACK_SECOND_IMAGE){
                            content.IPM_Pack_Image_2_Id__c=atth.Id;
                        }
                        else if(channelType==IPM_ConstantUtils.PRICE_FIRST_IMAGE){
                            content.IPM_Price_Image_1_Id__c=atth.Id;
                        }
                        else if(channelType==IPM_ConstantUtils.PRICE_SECOND_IMAGE){
                            content.IPM_Price_Image_2_Id__c=atth.Id;
                        }
                        else if(channelType==IPM_ConstantUtils.PLACE_FIRST_IMAGE){
                            content.IPM_Place_Image_1_Id__c=atth.Id;
                        }
                        else if(channelType==IPM_ConstantUtils.PLACE_SECOND_IMAGE){
                            content.IPM_Place_Image_2_Id__c =atth.Id;
                        }   
                        update content;
                        isImageLoaded=true;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.IPM_Image_uploaded_successfully));
                }
                else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.IPM_Upload_Valid_Image));
                }
                
            }
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.IPM_ImageRequired));
            }
            return null;
        }
        catch(DMLException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.IPM_ImageRequired));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CHANNELIMAGECONTORLLER_STR,
                        SAVE_DOC_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            return null;  
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.IPM_ImageRequired));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CHANNELIMAGECONTORLLER_STR,
                        SAVE_DOC_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            return null;  
        }
        finally{          
            atth.body = null; // clears the viewstate          
            atth= new Attachment();        
        }   
    }
}