/****************************************************************************************************************************
    @Author: Cognizant
    @Name: IPM_CustomerChannelContorller
    @Created Date: 03/01/2015
    @Description: Controller for the Customer Channels sections in Charter gate document
    @Version: 1.0
    @Reference: IPM_CustomerChannel component
*/
public with sharing class IPM_CustomerChannelController {
    public Id projectId { // to get-set the project id from the component attribute.
        get{
            return projectId ;// to get the project id from the component attribute.
        }
        set{
            projectId = value;// to set the project id from the component attribute.
        }
    } 
    public Id projDocSecId {// to get-set the project document section id from the component attribute.
        get{
            return projDocSecId;// to get the project document section id from the component attribute.
        }
        set{
            projDocSecId= value;// to set the project document section id from the component attribute.
            showSectionContent(); //callig the function to show the customer channel section
        }
    }
    public Id secConId{get; set;}// to store the section Content Id
    public string arrow{get; set;} // string to store the priority arrow
    public Integer priorityNumber{get; set;} // integer to store the priority Number
    public IPM_Project_Document_Section__c proDocSections{get; set;}//to store the project document section 
    public List<IPM_Project_Document_Section_Content__c> secConList{get; set;}//to store the project document section content list 
    public IPM_Project_Document_Section_Content__c secCon{get; set;}//to store the project document section cotent
    public Boolean show{get; set;}//boolean for displaying
    public String[] conName;//to get the content name from the UI(jQuery)
    public String channelName{get; set;}//string to store the channel name
    public String content{get; set;}//string to store the content
    public String channelType{get; set;}//string to get the channel type.
    public List<String> Names{get; set;}// list of customer channel names
    public Boolean isEditable{get;set;}// boolean to check if editable
    public Integer channelCount{get; set;}//boolean for count for number Customer channel selected
    public string channelInfo{get;set;}//string for channel Info
    //For deleting channel image
    public string imgId{get; set;}
    public string channelImage{get; set;}
    //For exception handler
    private static final String IPM_CUSTOMERCHANNELCONTORLLER_STR = IPM_CustomerChannelController.class.getName();
    private static final String CREATECHANNEL_STR = 'createChannel';
    private static final String DELETE_SECTION_CONTENT_STR = 'deleteSectionContent';
    private static final String CHANGE_PRIORITY_STR = 'changePriority';
    private static final String GET_SECTION_CONTENT_STR='getSectionContent';
    private static final String SHOW_SECTION_CONTENT_STR='showSectionContent';
    private static final String UPDATE_SECTION_CONTENT_STR='updateSectionContent';
    private static final String UPDATE_PRIORITY_STR='updatePriority';
    private static final String UPDATE_INFO='updateInfo';
    
    /************************************************************************************************************************
    * @Description: Constructor for the controller
    */
    public IPM_CustomerChannelController(){
        IPM_IECompatible.ieFix();//For IE Compatibility
        Names=new List<String>();
        Schema.DescribeFieldResult fieldResult = IPM_Project_Document_Section_Content__c.IPM_Customer_Channels__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();// to get the list of the Picklist values
        for( Schema.PicklistEntry f : ple){
            Names.add(f.getValue());
        }    
    }   
    
    /************************************************************************************************************************
    *  Description To retrieve customer channel contents
    *  @name getSectionContent
    *  @param none
    *  @return void
    *  @throws query exception
    */
    public void getSectionContent(){
        try{
            //Getting customer channel contents
            secConList=new List<IPM_Project_Document_Section_Content__c>();
            channelCount=[SELECT Count() FROM IPM_Project_Document_Section_Content__c WHERE IPM_Project_Document_Section__c=:projDocSecId AND IPM_Content_Type__c =: IPM_ConstantUtils.CUSTOMER_CHANNEL_SECTION]; 
            if(channelCount>0){
                secConList=[SELECT Id,IPM_Preposition__c,IPM_Customer_Channel_Priority__c,IPM_Customer_Channel_Priority_Order__c,IPM_Promotion__c,
                                   IPM_Pack__c,IPM_Place__c,IPM_Price__c,IPM_Product__c,IPM_Customer_Channels__c,IPM_Place_Image_2_Id__c,
                                   IPM_Project_Document_Section__c,IPM_Section_type__c,IPM_Preposition_Image_1_Id__c,IPM_Preposition_Image_2_Id__c,
                                   IPM_Promotion_Image_1_Id__c,IPM_Promotion_Image_2_Id__c,IPM_Product_Image_1_Id__c,IPM_Product_Image_2_Id__c,
                                   IPM_Pack_Image_1_Id__c,IPM_Pack_Image_2_Id__c,IPM_Price_Image_1_Id__c,IPM_Price_Image_2_Id__c,IPM_Place_Image_1_Id__c
                            FROM IPM_Project_Document_Section_Content__c 
                            WHERE IPM_Project_Document_Section__c=:projDocSecId AND IPM_Content_Type__c =: IPM_ConstantUtils.CUSTOMER_CHANNEL_SECTION ORDER BY IPM_Customer_Channel_Priority__c asc];
            }   
        }
        catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CUSTOMERCHANNELCONTORLLER_STR,
                GET_SECTION_CONTENT_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        
    }

    /************************************************************************************************************************
    *  Description To show the customer channel contents
    *  @name showSectionContent
    *  @param none
    *  @return void
    *  @throws exception
    */
    public void showSectionContent(){
        //For showing custom channel contents
        getSectionContent();
        if(channelCount>0){
            show=true;
        }
        try{
            proDocSections=[SELECT Id,IPM_Selected_Channel_Name__c,IPM_Customer_Channel_Info__c 
                 FROM IPM_Project_Document_Section__c 
                 WHERE Id=:projDocSecId];    
            if(proDocSections != null){
                channelName=proDocSections.IPM_Selected_Channel_Name__c;
                channelInfo=proDocSections.IPM_Customer_Channel_Info__c;
            }
        }
        catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CUSTOMERCHANNELCONTORLLER_STR,
                SHOW_SECTION_CONTENT_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    /************************************************************************************************************************
    *  Description To  delete the customer channel
    *  @name showSectionContent
    *  @param none
    *  @return void
    *  @throws dml exception
    */
    public void deleteSectionContent(){
        try{
            if(String.isNotBlank(secConId)){
                //Getting customer channel content
                secCon=[SELECT Id,IPM_Customer_Channels__c,IPM_Project_Document_Section__c FROM IPM_Project_Document_Section_Content__c WHERE Id=:secConId];
                if(secCon!=null){
                    //Getting project document section
                    proDocSections=[SELECT Id,IPM_Selected_Channel_Name__c,IPM_Customer_Channel_Info__c FROM IPM_Project_Document_Section__c WHERE Id=:secCon.IPM_Project_Document_Section__c];    
                }
                if(proDocSections!=null){
                    //Remove customer channel name to be deleted
                    if(proDocSections.IPM_Selected_Channel_Name__c.contains(IPM_ConstantUtils.COMMA+secCon.IPM_Customer_Channels__c)){
                        proDocSections.IPM_Selected_Channel_Name__c=proDocSections.IPM_Selected_Channel_Name__c.replaceAll(IPM_ConstantUtils.COMMA+secCon.IPM_Customer_Channels__c,'');
                    }
                    else if(proDocSections.IPM_Selected_Channel_Name__c.contains(secCon.IPM_Customer_Channels__c+IPM_ConstantUtils.COMMA)){
                        proDocSections.IPM_Selected_Channel_Name__c=proDocSections.IPM_Selected_Channel_Name__c.replace(secCon.IPM_Customer_Channels__c+IPM_ConstantUtils.COMMA,'');
                    }
                    else{
                        proDocSections.IPM_Selected_Channel_Name__c=proDocSections.IPM_Selected_Channel_Name__c.replace(secCon.IPM_Customer_Channels__c,'');
                    }
                        delete secCon;
                        update proDocSections;
                        channelName=proDocSections.IPM_Selected_Channel_Name__c;
                }
            }
            getSectionContent();
            //Updating channel priority
            if(secConList != null && !secConList.isEmpty()){
                updatePriority();
            }
        }
        
        catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CUSTOMERCHANNELCONTORLLER_STR,
                DELETE_SECTION_CONTENT_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    /************************************************************************************************************************
    *  Description To update the customer channel section content
    *  @name updateSectionContent
    *  @param none
    *  @return void
    *  @throws dml exception
    */
    public void updateSectionContent(){
        try{
            Boolean updateRec=true;
            if(String.isNotBlank(secConId)){
            //For updating customer channel content     
                secCon=new IPM_Project_Document_Section_Content__c();
                secCon.Id=secConId;
                if(channelType==IPM_ConstantUtils.PROPOSITION_TYPE){
                    secCon.IPM_Preposition__c=content;
                }
                else if(channelType==IPM_ConstantUtils.PROMOTION_TYPE){
                    secCon.IPM_Promotion__c=content;
                }
                else if(channelType==IPM_ConstantUtils.PACK_TYPE){
                    secCon.IPM_Pack__c=content;
                }
                else if(channelType==IPM_ConstantUtils.PLACE_TYPE){
                    secCon.IPM_Place__c=content;
                }
                else if(channelType==IPM_ConstantUtils.PRICE_TYPE){
                    secCon.IPM_Price__c=content;
                }
                else if(channelType==IPM_ConstantUtils.PRODUCT_TYPE){
                    secCon.IPM_Product__c=content;
                }
                else{
                    updateRec=false;
                }
                if(updateRec){
                    update secCon;
                }  
            }
        }
                      
        catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CUSTOMERCHANNELCONTORLLER_STR,
                UPDATE_SECTION_CONTENT_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    /************************************************************************************************************************
    *  Description To create the customer channel section content
    *  @name createChannel
    *  @param none
    *  @return void
    *  @throws dml exception
    */
    public void createChannel(){
        try{
            List<IPM_Project_Document_Section_Content__c> conList=new List<IPM_Project_Document_Section_Content__c>();// list of existing project documet section content 
            Set<String> availableChannel=new Set<String>();// available channel name
            Set<String> newChannel=new Set<String>();//new channel name
            Map<String,IPM_Customer_Channel_Priority_Order__c> channelPriority=IPM_Customer_Channel_Priority_Order__c.getAll(); //Getting channel priority order
            getSectionContent();
            if(proDocSections!=null){
                proDocSections.IPM_Selected_Channel_Name__c=channelName;
                update proDocSections;
            }
            
            conName=channelName.split(IPM_ConstantUtils.COMMA);
            if(secConList == null || secConList.isEmpty()){
                //Inserting customer channel
                for(Integer i=0;i<conName.size();i++){
                    
                    IPM_Project_Document_Section_Content__c con=new IPM_Project_Document_Section_Content__c();
                    con.IPM_Customer_Channels__c=conName[i];
                    con.IPM_Project_Document_Section__c=projDocSecId;
                    con.IPM_Content_Type__c= IPM_ConstantUtils.CUSTOMERCHANNELS_CONTENT_TYPE;
                    con.IPM_Customer_Channel_Priority_Order__c=Integer.valueOf(channelPriority.get(con.IPM_Customer_Channels__c).Priority_Order_Value__c);
                    conList.add(con);
                }
                if(conList != null && !conList.isEmpty()){
                    insert conList;
                }
            }
            else{
                for(IPM_Project_Document_Section_Content__c c:secConList){
                    availableChannel.add(c.IPM_Customer_Channels__c);
                }
                
                for(Integer i=0;i<conName.size();i++){
                    newChannel.add(conName[i]);
                }
                
                for(string s : newChannel){
                    if(!availableChannel.contains(s)){
                        IPM_Project_Document_Section_Content__c con=new IPM_Project_Document_Section_Content__c();
                        con.IPM_Customer_Channels__c=s;
                        con.IPM_Content_Type__c= IPM_ConstantUtils.CUSTOMERCHANNELS_CONTENT_TYPE;
                        con.IPM_Project_Document_Section__c=projDocSecId;
                        con.IPM_Customer_Channel_Priority_Order__c=Integer.valueOf(channelPriority.get(con.IPM_Customer_Channels__c).Priority_Order_Value__c);
                        conList.add(con);
                    }
                }
                
                if(conList != null && !conList.isEmpty()){
                    insert conList;
                }

                //To delete previously selected channels not been in use
                List<IPM_Project_Document_Section_Content__c> delChannel=new List<IPM_Project_Document_Section_Content__c>();
                delChannel=[SELECT Id,IPM_Customer_Channels__c FROM IPM_Project_Document_Section_Content__c WHERE IPM_Project_Document_Section__c=:projDocSecId AND IPM_Customer_Channels__c NOT In: newChannel];
                if(delChannel != null && !delChannel.isEmpty()){
                    delete delChannel;
                }
            }
            //Updating channel priority 
            updatePriority();
        }
        
        catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CUSTOMERCHANNELCONTORLLER_STR,
                CREATECHANNEL_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    /************************************************************************************************************************
    *  Description To update the customer channel section priority
    *  @name updatePriority
    *  @param none
    *  @return void
    *  @throws dml exception
    */
    public void updatePriority(){
        try{
            List<IPM_Project_Document_Section_Content__c> prioritiseContentList=new List<IPM_Project_Document_Section_Content__c>();
            prioritiseContentList=[SELECT Id,IPM_Customer_Channels__c,IPM_Customer_Channel_Priority_Order__c,IPM_Customer_Channel_Priority__c 
            FROM IPM_Project_Document_Section_Content__c 
            WHERE IPM_Project_Document_Section__c=:projDocSecId ORDER BY IPM_Customer_Channel_Priority_Order__c asc];
            Integer i=1;//initial priority
            for(IPM_Project_Document_Section_Content__c p:prioritiseContentList){
                p.IPM_Customer_Channel_Priority__c=i++;
            }
            if(prioritiseContentList!=null && !prioritiseContentList.isEmpty()){
                update prioritiseContentList;
            }
            //Getting updated priority customer channels
            getSectionContent();
        }
        
        catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CUSTOMERCHANNELCONTORLLER_STR,
                UPDATE_PRIORITY_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    /************************************************************************************************************************
    *  Description To change the customer channel section priority
    *  @name changePriority
    *  @param none
    *  @return void
    *  @throws dml exception
    */
    public void changePriority(){
        try{
            IPM_Project_Document_Section_Content__c newPriority=new IPM_Project_Document_Section_Content__c();
            IPM_Project_Document_Section_Content__c oldPriority=new IPM_Project_Document_Section_Content__c();
            
            newPriority=[SELECT Id,IPM_Customer_Channel_Priority_Order__c,IPM_Customer_Channel_Priority__c FROM IPM_Project_Document_Section_Content__c WHERE Id=:secConId];
            oldPriority=[SELECT Id,IPM_Customer_Channel_Priority_Order__c,IPM_Customer_Channel_Priority__c FROM IPM_Project_Document_Section_Content__c WHERE IPM_Project_Document_Section__c=:projDocSecId and IPM_Customer_Channel_Priority__c=:priorityNumber];
            
            if(newPriority.IPM_Customer_Channel_Priority__c==IPM_ConstantUtils.CHANNEL_PRIORITY_ONE && arrow==IPM_ConstantUtils.DOWN_ARROW){
                newPriority.IPM_Customer_Channel_Priority__c=IPM_ConstantUtils.CHANNEL_PRIORITY_TWO;
            }
            else if(newPriority.IPM_Customer_Channel_Priority__c==IPM_ConstantUtils.CHANNEL_PRIORITY_TWO && arrow==IPM_ConstantUtils.DOWN_ARROW){
                newPriority.IPM_Customer_Channel_Priority__c=IPM_ConstantUtils.CHANNEL_PRIORITY_THREE;
            }
            else if(newPriority.IPM_Customer_Channel_Priority__c==IPM_ConstantUtils.CHANNEL_PRIORITY_TWO && arrow==IPM_ConstantUtils.UP_ARROW){
                newPriority.IPM_Customer_Channel_Priority__c=IPM_ConstantUtils.CHANNEL_PRIORITY_ONE;   
            }
            else if(newPriority.IPM_Customer_Channel_Priority__c==IPM_ConstantUtils.CHANNEL_PRIORITY_THREE && arrow==IPM_ConstantUtils.UP_ARROW){
                newPriority.IPM_Customer_Channel_Priority__c=IPM_ConstantUtils.CHANNEL_PRIORITY_TWO;
            }
            
            if(newPriority!=null){
                update newPriority;//always 1 value expected since we are passing record id. Hence not in list
            }
            
            if(arrow==IPM_ConstantUtils.DOWN_ARROW){
                oldPriority.IPM_Customer_Channel_Priority__c=priorityNumber-1;
            }
            if(arrow==IPM_ConstantUtils.UP_ARROW){
                oldPriority.IPM_Customer_Channel_Priority__c=priorityNumber+1;
            }
            if(oldPriority!=null){
                update oldPriority;//always 1 value expected since we are passing record id. Hence not in list
            }
            //Getting updated priority customer channels
            getSectionContent();
        }
        
        catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CUSTOMERCHANNELCONTORLLER_STR,
                CHANGE_PRIORITY_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    /************************************************************************************************************************
    *  Description To update the Mission of the customer channel Info
    *  @name updateInfo
    *  @param none
    *  @return void
    *  @throws dml exception
    */
    public void updateInfo(){
        try{
            if(proDocSections!=null){
                proDocSections.IPM_Customer_Channel_Info__c=channelInfo;
                update proDocSections;
            }
        }
        catch (Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CUSTOMERCHANNELCONTORLLER_STR,
                UPDATE_INFO,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        } 
    }
    
    /************************************************************************************************************************
    *  Description To Delete Concept Image
    *  @name deleteImage
    *  @return void
    *  @throws dml exception
    */
    public void deleteImage(){ 
        //For Deleting Image of Channel
        try{
            if(String.isNotBlank(imgId) && String.isNotBlank(secConId)){
                Attachment att=new Attachment();
                att.Id=imgId;
                delete att;
                secCon=new IPM_Project_Document_Section_Content__c();
                secCon.Id=secConId;
                if(channelImage==IPM_ConstantUtils.PREPOSITION_FIRST_IMAGE){
                        secCon.IPM_Preposition_Image_1_Id__c=IPM_ConstantUtils.BLANK;
                }
                else if(channelImage==IPM_ConstantUtils.PREPOSITION_SECOND_IMAGE){
                    secCon.IPM_Preposition_Image_2_Id__c=IPM_ConstantUtils.BLANK;
                }
                else if(channelImage==IPM_ConstantUtils.PROMOTION_FIRST_IMAGE){
                    secCon.IPM_Promotion_Image_1_Id__c=IPM_ConstantUtils.BLANK;
                }
                else if(channelImage==IPM_ConstantUtils.PROMOTION_SECOND_IMAGE){
                    secCon.IPM_Promotion_Image_2_Id__c=IPM_ConstantUtils.BLANK;
                }
                else if(channelImage==IPM_ConstantUtils.PRODUCT_FIRST_IMAGE){
                    secCon.IPM_Product_Image_1_Id__c=IPM_ConstantUtils.BLANK;
                }
                else if(channelImage==IPM_ConstantUtils.PRODUCT_SECOND_IMAGE){
                    secCon.IPM_Product_Image_2_Id__c=IPM_ConstantUtils.BLANK;
                }
                else if(channelImage==IPM_ConstantUtils.PACK_FIRST_IMAGE){
                    secCon.IPM_Pack_Image_1_Id__c=IPM_ConstantUtils.BLANK;
                }
                else if(channelImage==IPM_ConstantUtils.PACK_SECOND_IMAGE){
                    secCon.IPM_Pack_Image_2_Id__c=IPM_ConstantUtils.BLANK;
                }
                else if(channelImage==IPM_ConstantUtils.PRICE_FIRST_IMAGE){
                    secCon.IPM_Price_Image_1_Id__c=IPM_ConstantUtils.BLANK;
                }
                else if(channelImage==IPM_ConstantUtils.PRICE_SECOND_IMAGE){
                    secCon.IPM_Price_Image_2_Id__c=IPM_ConstantUtils.BLANK;
                }
                else if(channelImage==IPM_ConstantUtils.PLACE_FIRST_IMAGE){
                    secCon.IPM_Place_Image_1_Id__c=IPM_ConstantUtils.BLANK;
                }
                else if(channelImage==IPM_ConstantUtils.PLACE_SECOND_IMAGE){
                    secCon.IPM_Place_Image_2_Id__c =IPM_ConstantUtils.BLANK;
                }   
                update secCon;
            }
        }
       
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CUSTOMERCHANNELCONTORLLER_STR,
                    IPM_ConstantUtils.DELETE_IMAGE_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }       
    }
}