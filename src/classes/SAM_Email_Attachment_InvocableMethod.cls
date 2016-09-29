/*******************************************************************
    Purpose: Send email with attachment
    Parameters: List of SAM_Request__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
public with sharing Class SAM_Email_Attachment_InvocableMethod
{
@InvocableMethod
public static void SendEmailWithAttachment(List<SendEmailClassVariable> inputs)
{
    map<ID,set<ID>> mapreqIDQLI = new map<ID,set<ID>>();
    set<string> setrequID = new set<string>();
    set<ID> setQLI = new set<ID>();
    map<ID,string> mapIDEmail = new map<ID,string>();
    map<ID,string> mapIDEmailAssign = new map<ID,string>();
    map<ID,ID> mapIDCreatedById = new map<ID,ID>();
    map<string,ID> mapIDemailTem = new map<string,ID>();      
    for(SendEmailClassVariable var : inputs)
    {
        setrequID.add(var.recordId);
    }
    for(SAM_request__c req:[select id,CreatedById,createdby.email,lkp_Assign_To__r.email,(select id,pkl_Charging_Type__c,pkl_Line_Status__c from Quote_Line_Items__r) from SAM_request__c where id in :setrequID]){       
        set<ID> setrelatedQLI = new set<ID>();
        mapIDEmail.put(req.id,req.createdby.email);
        mapIDEmailAssign.put(req.id,req.lkp_Assign_To__r.email);
        mapIDCreatedById.put(req.id,req.CreatedById);
        for(SAM_Quote_Line_Item__c QLI:req.Quote_Line_Items__r){
            setrelatedQLI.add(QLI.id);
            if(QLI.pkl_Charging_Type__c == SAM_Constants.DO_PO_APPLICABLE && QLI.pkl_Line_Status__c == SAM_Constants.COMPLETED){
                setQLI.add(QLI.id);
            }
        }
        mapreqIDQLI.put(req.id,setrelatedQLI);
    }
    OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where DisplayName =:label.SAM_from_address_display_name and Address =:label.SAM_from_address limit 1];
    List<Attachment> attList = [SELECT id, Name, body, ContentType,ParentId FROM Attachment WHERE ParentId =: setQLI and name LIKE 'Quotation%'];
    List<EmailTemplate> availableEmailTemplate = [select Id,developerName from EmailTemplate where developerName IN ('SAM_FinalQuoteReSubmitted_To_Requester','SAM_FinalQuoteProvided_By_SAMT','SAM_DraftQuote_By_SAMT_To_Requester')];
    for(EmailTemplate emailTem:availableEmailTemplate){
        mapIDemailTem.put(emailTem.developerName,emailTem.Id);
    }
    for(SendEmailClassVariable var : inputs){
        List<Messaging.EmailFileAttachment> efaList = new List<Messaging.EmailFileAttachment>();
        if(attList != null && attList.size()>0){
            for(Attachment att : attList)
            {
                if(mapreqIDQLI.size() >0 && mapreqIDQLI.get(var.recordId).contains(att.ParentId)){
                    // Create the emessage attachment
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName(att.Name);
                    efa.setBody(att.body);
                    efa.setContentType(att.ContentType);
                    efa.setInline(false);
                    efaList.add(efa);
                }
                
            }
        }
        if( mapIDemailTem.get(var.templateDeveloperName) != null &&
            mapIDEmail.get(var.recordId) != null &&
            mapIDEmailAssign.get(var.recordId) != null &&
            var != null &&
            mapIDCreatedById.get(var.recordId) != null && 
            owa != null &&
            mapIDEmail.get(var.recordId) != null &&
            label.SAM_from_address != null            
            ){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {mapIDEmail.get(var.recordId),mapIDEmailAssign.get(var.recordId)};
            message.setTemplateId(mapIDemailTem.get(var.templateDeveloperName));
            message.setWhatId(var.recordId);
            message.setTargetObjectId(mapIDCreatedById.get(var.recordId));
            message.setOrgWideEmailAddressId(owa.id);
            //message.setCcAddresses = new String[] {mapIDEmail.get(var.recordId)};
            String[] CCEmails = new String[]{label.SAM_from_address};
            if(CCEmails != null ) {message.setCCAddresses(CCEmails);}
            //message.setReplyTo(label.SAM_from_address);
            //message.setSenderDisplayName(label.SAM_from_address_display_name);
            message.setTreatTargetObjectAsRecipient(false);
            message.setFileAttachments(efaList);
            if(!Test.isRunningTest()){
                Messaging.SendEmail(new Messaging.SingleEmailMessage[]{message});
            }
        }
    }
}

public class SendEmailClassVariable
{
@InvocableVariable
public string recordId;

@InvocableVariable
public string templateDeveloperName;
}
}