/****************************************************************************
 * ClassName: SendEmail_Custom
 * Description: Class is Invoked when custom send Email button is clicked
 *              
 * Author: Accenture Offshore Team
 * *************************************************************************/
public with sharing  class FAU_SendEmail_Custom{

    


 @testvisible private ApexPages.StandardSetController standardController;

    public String ProgramId {get; set; } 
    public String ToFieldId { get; set; }
    public String ToField { get; set; }
    public String ToFieldEmail{get; set;}
    public Boolean ShowAttchPopUp{get;set;}
    public String FromAddresses{get; set;}
  ////  public String RelatedToValue{get;set;}
  ////  public String SelectedRetaedTovalue { get; set; }
    public Id RelatedToFieldId;
    //public Quote q;
  ////  public String RelatedToField { get; set; }
    public String ShowAdditionalFieldValue { get; set; }
    public String AdditionalToFieldValue { get; set; }
    public String CcIdFieldValue { get; set; }
    public String CcFieldValue { get; set; }
 ////   public String BCcIdFieldValue { get; set; }
    public String BCcFieldValue { get; set; }
    public String subjectLine { get; set; }
    public String BodyHiddenContentvalue { get; set; }
    public String BodyContent { get; set; }
////    public string quoteName{get; set;}
    //public List<notesAndAttachments> attachments{get;set;}
    public List<Attachment> selList{get; set;}
   // public List<Attachment> lstUpAttch{get; set;}
    public Map<Id,Attachment> selectedList{get; set;}
    public String deleteId{get;set;}
    public list<String> toEmailAddress= new list<string>();
    Public list<string> AdditionalToSave = new list<string>();
    public string templateId{get; set;}
    public Boolean ShowTemplatepopup{get; set;}
    public String folderName;
    public List<EmailTemplate> Templatelist { get; set; }
    public Map<Id,EmailTemplate> templateMap = new Map<Id,EmailTemplate>();
    public FAU_Email__c emailsave {get;set;}
    public Date date_time { get; set; }

    PRIVATE STATIC FINAL String ADDITIONALTO1='Additional To: ';
    PRIVATE STATIC FINAL String CC = '\nCC: '; 
    PRIVATE STATIC FINAL String BCC = '\nBCC: ';  
    PRIVATE STATIC FINAL String ATTACHMENT ='\nAttachment';   
    PRIVATE STATIC FINAL String SUBJECT = '\n\nSubject: ';  
    PRIVATE STATIC FINAL String BODY = '\nBody:\n';
    PRIVATE STATIC FINAL String STR = 's';
    PRIVATE STATIC FINAL String STR1 = '';
    PRIVATE STATIC FINAL String STR2 = ': ';
    PRIVATE STATIC FINAL String ID = 'Id';
    PRIVATE STATIC FINAL String SEPARATOR = '/';
    PRIVATE STATIC FINAL String EMAILSPLIT = ',';
    PRIVATE STATIC FINAL String BODYCONTENT1 = '<table';
    PRIVATE STATIC FINAL String BODYCONTENT2 = '<body style=" background-color:#CCCCCC;"><center >';
    PRIVATE STATIC FINAL String BODYCONTENT3 = '</center>';
    PRIVATE STATIC FINAL String TASKSTATUS = 'Completed';
    PRIVATE STATIC FINAL String TEMPLATETYPE = 'HTML';
    PRIVATE STATIC FINAL String TOERROR = 'Select at least one contact from either of To or Additional To Lookup';
    //PRIVATE STATIC FINAL String TOERROR1 = 'Please Enter Proper Contact Mail Id';
    PRIVATE STATIC FINAL String TOERROR1 = 'Please SELECT ATLEAST ONE PARTICIPANT FROM LOOK UP';
    PRIVATE STATIC FINAL String SUBJECTERROR = 'Please Enter Subject Line';
    PRIVATE STATIC FINAL String SENDERROR = 'Error in Sending Email';
    PRIVATE STATIC FINAL String TASKERROR = 'ERROR in Creating Activity History';
    
    
    /***********************************************************************
     * MethodName: SendEmail_Custom
     * ReturnType: 
     * param: 
     * Description: This is a Constructor method where Fields Initialization
     *              is happening.
     **********************************************************************/

    public FAU_SendEmail_Custom(ApexPages.StandardSetController standardController ) {
    
     emailsave=new FAU_Email__c();
    //   this.standardController= standardController ;

        //addFieldsTo(standardController);
        
    //  List<SObject> selectedObjects = (List<SObject>) standardController.getSelected();
    //Fetching the Id from the Url Parameter
        ProgramId = ApexPages.currentPage().getParameters().get(id);
        //FromAddresses = UserInfo.getUserEmail();
        //FromAddresses = 'Chief.Learning.Officer@unilever.com';
        FromAddresses = 'Chief.Learning.Officer@unilever.com';
        ToFieldId = STR1;
        ToFieldEmail = STR1;
        ShowAttchPopUp = false;
        ShowTemplatepopup = false;
      
        //attachments = new List<notesAndAttachments>();
        selList = new List<Attachment>();
        selectedList = new Map<Id,Attachment>();
        //Folder name from where the Email Templates must be fetched
        folderName = system.Label.FAU_Program_Protected;
        //attachmentsList(quoteId);
        templates();
        /*
        List<FAU_Participant__c> participants = [select id, FAU_User__r.Email,name from FAU_Participant__c where FAU_Program_Wave__c = :ProgramId];
               
                for(FAU_Participant__c par : participants){
                    if(String.isblank(ToField))
                     ToField = par.FAU_User__r.Email;
                     else
                    ToField = ToField+';'+par.FAU_User__r.Email;
                }*/
        

    }

    /***********************************************************************
     * MethodName: attachmentsList
     * ReturnType: Void
     * param: Quote Id
     * Description: This method takes the input of Quote Id and fetches
     *              the related Attachments and Quote related Information.
     **********************************************************************/ 
   /* public void attachmentsList(Id quoteId){
        
        for(Attachment a: [select id,Name,ParentId,OwnerId,Body,BodyLength from Attachment where ParentId =:quoteId limit 999]){
            
            attachments.add(new notesAndAttachments(a,false));
        }
        
        q = [Select Id,Name,QuoteNumber from Quote Where Id = :quoteId LIMIT 1];
        RelatedToFieldId = q.Id;
        RelatedToValue = q.getSObjectType().getDescribe().getName();
        quoteName = q.Name;
    } */
    
    /***********************************************************************
     * MethodName: templates
     * ReturnType: Void
     * param: void
     * Description: This method is used to fetch the Templates from 
     *              Email Template from the mentioned folder name.
     **********************************************************************/ 
    public void templates(){

         Templatelist = new list<EmailTemplate>();
               
         for(EmailTemplate et:[ SELECT Id,Name,Body,subject,FolderId,HtmlValue,Encoding,TemplateType,Description  FROM EmailTemplate where Folder.Name = :folderName LIMIT 100])
          {
              Templatelist.add(et); 
              templateMap.put(et.Id,et);  
          }  
    }
    
    /***********************************************************************
     * MethodName: cancel
     * ReturnType: pageReference
     * param: void
     * Description: This method is Invoked when Cancel button is clicked.
     *              Page is redirected to Quote page from where the the
     *              send Email button is clicked.
     **********************************************************************/
    public pageReference cancel(){
        PageReference ref;
        try{
           
            ref=new pagereference(SEPARATOR+ProgramId);
            ref.setRedirect(true);
               
        }catch(Exception ex){
           // system.debug(ex.getMessage());
           return null;
        }
        return ref;
    }   
    
    /**************************************************************************
     * MethodName: OpenAttachmentPopup
     * ReturnType: Void
     * param: void
     * Description: This method is used to set the Open Attachment Popup
     *              Condition as true
     **************************************************************************/
    public void OpenAttachmentPopup() {
      
        ShowAttchPopUp=true;
    }
    
    /**************************************************************************
     * MethodName: openTemplatePopup
     * ReturnType: Void
     * param: void
     * Description: This method is used to set the Open Template Popup
     *              Condition as true
     **************************************************************************/
    public void openTemplatePopup(){
        ShowTemplatepopup = true;
    }
    

    
    /**************************************************************************
     * MethodName: closeTemplatePopup
     * ReturnType: Void
     * param: void
     * Description: This method is used to set the close the Template Popup.
     **************************************************************************/
    public PageReference closeTemplatePopup(){
        ShowTemplatepopup = false;
        return null;
    }
   
     /**************************************************************************
     * MethodName: SelectTemplate
     * ReturnType: void
     * param: void
     * Description: This method is invoked when a template record is clicked
     *              from the template popup, From the selected template fields
     *              are merged and the same are inserted into subjectLine and 
     *              email body.
     **************************************************************************/
    public void SelectTemplate() {
       
        EmailTemplate t = templateMap.get(templateId);
         //Merging the fields in template using logged in user details and Quote Id        
         Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(templateId, UserInfo.getUserId(), RelatedToFieldId);
          //After merging the fields showing the template inside the body Body of the email field.
          if(t.TemplateType.equalsIgnoreCase(TEMPLATETYPE) || t.TemplateType.equalsIgnoreCase('CUSTOM')){ 
             BodyContent=email.gethtmlbody();
           }
        else{
             BodyContent= email.getPlaintextBody();      
        }
       
        //showing the subject after merging the fields
        subjectLine = email.getSubject();
        ShowTemplatepopup = false;
    }    
    
     /*****************************************************************************
     * MethodName: updateAttachmentList
     * ReturnType: void
     * param: void
     * Description: This method is invoked when 'Del' command link is clicked from
     *              Attachments list to remove the record from the Attachment list.
     ******************************************************************************/
    public void updateAttachmentList(){
        
        //Removing the Id from the Selected list
        for(Integer i=0;i<selList.size();i++){
            if(selList[i].Id.equals(deleteId)){
                selList.remove(i);
                selectedList.remove(deleteId);
                break;
            }
        }
        //Updating the deleted records in the attachments list to false
      /*  for(Integer i=0;i<attachments.size();i++){
            if(attachments[i].att.Id.equals(deleteId)){
                attachments[i].check = false;
                break;
            }
        } */
    }   
    
     /**************************************************************************
     * MethodName: clearToField
     * ReturnType: Void
     * param: void
     * Description: This method is used to Clear the To Fields.
     ***************************** G*********************************************/ 
     public void clearToField(){
        ToFieldId = STR1;
        ToField = STR1;
        ToFieldEmail = STR1;
    }
    
    /**************************************************************************
     * MethodName: Save Template
     * ReturnType: Void
     * param: void
     * Description: This method is used to Clear the To Fields.
     **************************************************************************/ 
     public PageReference Save(){
          system.debug('++++++++++++++Date iss+++++++++'+emailsave.FAU_Email_Start_Date__c);
          
           date_time = emailsave.FAU_Email_Start_Date__c;
        //emailsave = new FAU_Email__c();
         pagereference PageRef1;
         String AddtionalToEmail;
          system.debug('***templateId==>'+templateId);
          system.debug('***AddtionalToEmail==>'+AddtionalToEmail);
          system.debug('@@: '+ToField);
          system.debug('***CcFieldValue==>'+CcFieldValue);
          system.debug('*****ToField='+ToField+'*****subjectLine=='+subjectLine);
        if((!String.isBlank(subjectLine) &&(!String.isBlank(templateId))))
         { 
             set<String> TempToEmails= new  set<string>();
            
             if(ShowAdditionalFieldValue.length()>0){
             AddtionalToEmail = ShowAdditionalFieldValue;
             }
         
             system.debug('++++++++++++++Additional TO +++++++++++++++++++'+TempToEmails);
             
             emailsave.FAU_To_Address__c = ToField;
             emailsave.FAU_Additional_To__c = AddtionalToEmail;
             emailsave.FAU_CC__c = CcFieldValue;
             if(date_time!=null)
             {
             emailsave.FAU_Email_Start_Date__c=date_time;
             }
             emailsave.FAU_Subject__c = subjectLine;
             emailsave.From_Address__c = FromAddresses;
             emailsave.FAU_Program__c = ProgramId;
             system.debug('++++++++++++++Template Id is +++++++++'+templateId);
             emailsave.FAU_Email_Template_Id__c = templateId;
             system.debug('++++++++++++++Email Template Id is +++++++++'+emailsave.FAU_Email_Template_Id__c);
             emailsave.FAU_Email_Start_Date__c = date_time;
             if(BodyContent.contains(BODYCONTENT1)){
               
                BodyContent = BODYCONTENT2+BodyContent+BODYCONTENT3;
                emailsave.FAU_Body__c = BodyContent;
                system.debug('++++++++++++++BODYCONTENT2+BodyContent+BODYCONTENT3 +++++++++'+BodyContent);
                //message.setHtmlBody(BodyContent); 
            }  
            else {
                //message.setHtmlBody(BodyContent); 
                emailsave.FAU_Body__c = BodyContent;
           }
           
           //  system.debug('++++++++++++++BodyContent+++++++++'+BodyContent);
                 insert emailsave;
             
             system.debug('++++++++++++++emailsave+++++++++'+emailsave.id);
             PageRef1 = new pagereference(SEPARATOR+ProgramId);
             PageRef1.setRedirect(true);
             return PageRef1;
            
         }
         else{
             ApexPages.Message myMsgsave = new ApexPages.Message(ApexPages.Severity.ERROR, TOERROR1);
              ApexPages.addMessage(myMsgsave); 
              return null;
        
         }
       
    }
     /**************************************************************************
     * MethodName: SendEmail
     * ReturnType: PageReference
     * param: void
     * Description: This method is used to Send the email based on the ToAddress
     *               CC/Bcc and Template Selected.
     **************************************************************************/ 
        public PageReference SendEmail() {
          emailsave.FAU_Email_Start_Date__c=null;
       // try{
            Messaging.SingleEmailMessage message;
            
          //**********************  Adding Custom message if there is no subject with the email. ******************
         
         if((String.isBlank(subjectLine))&&(String.isBlank(templateId)))
         {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, SUBJECTERROR);
              ApexPages.addMessage(myMsg); 
              return null;
         }  

         if(String.isNotBlank(templateId)){
             //Merging the fields from the selected templates    
             message = Messaging.renderStoredEmailTemplate(templateId, UserInfo.getUserId(), RelatedToFieldId);  
         }
         else{
              
             message = new Messaging.SingleEmailMessage();
         }
         
       
         toEmailAddress= new list<string>();
         list<String> AdditionalTo= new list<String>();
         //**********************  Setting TO Address . ************************************
         
         set<String> TempToEmails= new  set<string>();
            
         if(ShowAdditionalFieldValue.length()>0)
         {
              AdditionalTo= ShowAdditionalFieldValue.split(EMAILSPLIT);
              if(AdditionalTo.size()>0){
                  TempToEmails.addAll(AdditionalTo);
              }
              toEmailAddress.AddAll(TempToEmails);
             
         }
         
        //if(String.isBlank(ToFieldId) && String.isNotBlank(ToField)){
       /* if(String.isNotBlank(ToField)){
            List<User> c = [Select Id from User where Email=:ToField Limit 1];
            if(c.size()== 0){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, TOERROR1);
                ApexPages.addMessage(myMsg); 
                return null;    
            }
            else{
                 ToFieldId=c[0].Id;   
            }
        }        
          
         if(String.isBlank(ToField))
         { 
            ToFieldId=STR1;
         } 
         else{
                toEmailAddress.add(ToField);  
         }*/
         
         if(String.isBlank(ToField))
         { 
            ToFieldId=STR1;
         } 
         else{
             system.debug('+++++++ToField++++++++++'+ToField);
             system.debug('+++++++templateId++++++++++'+templateId);
             List<String> toStrList = new List<string>();
             
             toStrList = ToField.Split('\\,');
             
             for( String s :toStrList){
                 toEmailAddress.add(s);
             }
         }
         //if(String.isBlank(ToFieldId) && AdditionalTo.isEmpty()){
         if(String.isBlank(ToField)){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, TOERROR);
              ApexPages.addMessage(myMsg); 
              return null;
         
         }  
          System.debug('----------toEmailAddress---------> 1-->'+toEmailAddress);
         message.setToAddresses(toEmailAddress);         
        /*  //**********************  Setting BCC Address . ************************************
         
         if(BCcFieldValue.length()>0)
             {
                list<String> BCCField=BCcFieldValue.split(EMAILSPLIT);
                if(BCCField.size()>0){  
                        message.setBccAddresses(BCCField);
                  }
              }*/
   //**********************  Setting CC Address . ************************************
               
         if( CcFieldValue!=null && CcFieldValue.length()>0)
             {
               list<String> CCField=CcFieldValue.split(EMAILSPLIT);
               if(CCField.size()>0){
                       message.setCcAddresses(CCField);
                   }
             }   
        
        
   
   //***************** Setting From Address ************************
   
        if(String.isNotBlank(FromAddresses)){
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: FromAddresses];
         
            if ( owea.size() > 0 ) {
                message.setOrgWideEmailAddressId(owea.get(0).Id);
            }
        } 
           EmailTemplate t = templateMap.get(templateId);   
            
           message.setSubject(subjectLine);     
           
            
            if(BodyContent.contains(BODYCONTENT1)){
               
                BodyContent = BODYCONTENT2+BodyContent+BODYCONTENT3;
                message.setHtmlBody(BodyContent); 
            }  
            else {
                message.setHtmlBody(BodyContent); 
            }
           
        
         //**********************  adding attachments to the email ***********************************
       /* List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        for(Attachment a:selList )
        {
            // Add to attachment file list
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(a.Name);
            efa.setBody(a.Body);
            fileAttachments.add(efa);
                       
        }
         
  
        message.setFileAttachments(fileAttachments);    */
        //sending the email    
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            For(Messaging.SendEmailResult rl: r){
                if(rl.issuccess()){
                    date_time = null;
                save();  
                }
            }
       
                      
        pagereference PageRef = new pagereference(SEPARATOR+ProgramId);
        PageRef.setRedirect(true);
        return PageRef;  
        //}
       /* catch(Exception e){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, SENDERROR+ e.getCause());
             ApexPages.addMessage(myMsg);
             return null;
        }*/    
     }

 }