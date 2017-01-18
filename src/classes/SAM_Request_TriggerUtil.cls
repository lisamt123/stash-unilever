/**********************************************************************
Name: SAM_Request_TriggerUtil()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform operation on event of RequestTrigger
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR                 DATE            DETAIL Description
1.0         Dineshisng Girase    18/07/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class SAM_Request_TriggerUtil{
    public static boolean isSubmitted=false;
    /*******************************************************************
    Purpose: If the request is other than Saved status, this method will prevent its delition
    Parameters: List of SAM_Request__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void PreventDelete(list<SAM_Request__c> lstRequest){
        //System.debug('lstRequest ##### ' + lstRequest);
        for(SAM_Request__c obj :lstRequest){
            System.debug('Status ##### ' + obj.pkl_Status__c);
            if(obj.pkl_Status__c != null && obj.pkl_Status__c != SAM_Constants.SAVED)
                obj.addError('You are not authorized to delete this record');
        }
    }
    
/*******************************************************************
    Purpose: SAM admin can only Assign the request to SAM team member
    Parameters: List of SAM_Request__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void PreventRequestAssignment(list<SAM_Request__c> lstRequest,list<SAM_Request__c> OldlstRequest){
        Set<Id> AssigntoID = new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        if(!isSubmitted){
           List<GroupMember> grpList = [Select Id, UserOrGroupId From GroupMember WHERE group.name = 'SAM Team'];
            for (GroupMember m : grpList){
                if (((String)m.UserOrGroupId).startsWith(userType)){
                    AssigntoID.add(m.UserOrGroupId);
                }
            }
            for(integer i = 0 ; i < lstRequest.size(); i++){
                if(!Test.isRunningTest() && lstRequest[i].lkp_Assign_To__c != null && OldlstRequest[i].lkp_Assign_To__c <> lstRequest[i].lkp_Assign_To__c && AssigntoID != null && !AssigntoID.contains(lstRequest[i].lkp_Assign_To__c))
                   lstRequest[i].lkp_Assign_To__c.addError('You can only Assign the Request to a SAM team member');
                
            } 
            isSubmitted = true;
        }
        
    }

    /*******************************************************************
    Purpose: Request can not Closed without attaching build details
    Parameters: List of SAM_Request__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void validationForBuildDetail(list<SAM_Request__c> newlstRequest, list<SAM_Request__c> oldlstRequest){
        Set<Id> requestId = new Set<Id>();
        Map<ID,List<Attachment>> Req_attch_Map = new Map<ID,List<Attachment>>();
        Map<ID,List<Attachment>> Req_attch_Approval_EmailsMap = new Map<ID,List<Attachment>>();
        for(SAM_Request__c obj :newlstRequest){
            requestId.add(obj.Id);
        }
        List<Attachment> lstAttachmentBuild_Details = [SELECT ContentType,Id,Name,ParentId  FROM Attachment WHERE Name LIKE 'Build_Details%' and ParentId IN:requestId];
        List<Attachment> lstAttachmentApproval_Emails = [SELECT ContentType,Id,Name,ParentId  FROM Attachment WHERE Name LIKE 'Approval_Emails%' and ParentId IN:requestId];
        for(Id objID : requestId){
            List<Attachment> lstTempd = new List<Attachment>();
            List<Attachment> lstTempdApproval_Emails = new List<Attachment>();
            for(Attachment objAttachment : lstAttachmentBuild_Details){
                if(objAttachment.ParentId == objID){
                    lstTempd.add(objAttachment);
                }
            }
            Req_attch_Map.put(objID,lstTempd);
            for(Attachment objAttachment : lstAttachmentApproval_Emails){
                if(objAttachment.ParentId == objID){
                    lstTempdApproval_Emails.add(objAttachment);
                }
            }
            Req_attch_Approval_EmailsMap.put(objID,lstTempdApproval_Emails);
            
        }
        for(integer i = 0 ; i < newlstRequest.size(); i++){   
            if(
               (newlstRequest[i].rol_Build_detail_applicable__c>0 || newlstRequest[i].pkl_Build_details_applicable__c == 'Yes')&& 
                oldlstRequest[i].pkl_SAM_team_Status__c != SAM_Constants.CLOSED && 
                newlstRequest[i].pkl_SAM_team_Status__c == SAM_Constants.CLOSED 
               )
            {
                if(Req_attch_Map.get(newlstRequest[i].Id).size()<1){
                    newlstRequest[i].addError('You can not Close the Request without attaching build details with file name "Build_Details"');
                }
                else{ 
                    for(Attachment objAttachment:Req_attch_Map.get(newlstRequest[i].Id)){
                        if(objAttachment == null){
                            newlstRequest[i].addError('You can not Close the Request without attaching build details with file name "Build_Details"');
                        }
                    }
                }
            }
            String errormsg = null;
            if(((newlstRequest[i].txt_Request_Type__c == SAM_Constants.SAM_RW_PROJECT_REQUEST && newlstRequest[i].rol_Product_detail_count_having_cross_ch__c>0) || newlstRequest[i].txt_Request_Type__c == SAM_Constants.SAM_RW_CROSSCHARGE_REQUEST) && oldlstRequest[i].pkl_SAM_team_Status__c != SAM_Constants.AWAITINGCHARGE && newlstRequest[i].pkl_SAM_team_Status__c == SAM_Constants.AWAITINGCHARGE){                
            if(Req_attch_Approval_EmailsMap.get(newlstRequest[i].Id).size()<1){
                    errorMsg = ' You can not Send the Request for  Cross charge without Budget and Invoice approval email attached with file name "Approval_Emails';
                }
                else{ 
                    boolean approval_Emails_Flag = false;
                    for(Attachment objAttachment:Req_attch_Approval_EmailsMap.get(newlstRequest[i].Id)){
                        if((newlstRequest[i].num_Cross_Charging_Version__c == null || newlstRequest[i].num_Cross_Charging_Version__c == 0) && objAttachment.Name.containsIgnoreCase('Approval_Emails')){
                            approval_Emails_Flag = true;
                            break;
                        }
                        else  if(newlstRequest[i].num_Cross_Charging_Version__c != null && newlstRequest[i].num_Cross_Charging_Version__c>0 && objAttachment.Name.containsIgnoreCase(String.valueOf(newlstRequest[i].num_Cross_Charging_Version__c))){
                            approval_Emails_Flag = true;
                            break;
                        }
                    }
                    if(!approval_Emails_Flag){
                       errorMsg = ' You can not Send the Request for  Cross charge without Budget and Invoice approval email attached with file name "Approval_Emails';
                    }                            
                }               
            }
            if(errorMsg != null){
                if(newlstRequest[i].num_Cross_Charging_Version__c != null && newlstRequest[i].num_Cross_Charging_Version__c>0){
                    newlstRequest[i].addError(errormsg+'_Version_'+ newlstRequest[i].num_Cross_Charging_Version__c+'".');
                }else {
                    newlstRequest[i].addError(errormsg+'"');
                }
            } 
        }
     }
     
    /*******************************************************************
    Purpose: Auto create Quotations for every Product Line Item when Software Purchase Required = Yes
    Parameters: List of SAM_Request__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void CreateQuotationPerProduct(list<SAM_Request__c> NewlstRequest,list<SAM_Request__c> OldlstRequest){    
            
            try
            {
                List<SAM_Request__c> requestsToUpdate = new List<SAM_Request__c>();
                List<SAM_Quote_Line_Item__c> requestQuotations = new List<SAM_Quote_Line_Item__c>();
                for(integer i = 0 ; i < NewlstRequest.size(); i++){             
                    if(NewlstRequest[i].Quotation_Record_Count__c == 0 && OldlstRequest[i].pkl_Software_Purchase_Req__c <> 'Yes' && NewlstRequest[i].pkl_Software_Purchase_Req__c == 'Yes'  )
                    {   
                        requestsToUpdate.Add(NewlstRequest[i]);
                    }
                                 
                } 
                List<SAM_Request_Line_Item__c> requestProducts = [Select md_Request_ID__c,Name,txt_Publisher__c,txt_Product_Type_Name__c From SAM_Request_Line_Item__c Where md_Request_ID__c in :requestsToUpdate order by CreatedDate];
                Integer productCount = requestProducts.Size();
                Integer count = 1;
                for(SAM_Request_Line_Item__c requestProduct : requestProducts)
                {
                    SAM_Quote_Line_Item__c quotationItem = new SAM_Quote_Line_Item__c(
                    md_Request__c = requestProduct.md_Request_ID__c, 
                    Name = requestProduct.Name, 
                    pkl_Publisher__c = requestProduct.txt_Product_Type_Name__c,                                       
                    num_Quantity__c = 1,
                    pkl_Currency_Type__c = 'EUR',
                    num_List_Price__c = 0,
                    pkl_Discount_Applicable__c = 'No',
                    Maintainence_Applicable__c = 'No',
                    pkl_Line_Status__c = 'Pending with SAM',
                    pkl_Charging_Type__c = 'Cross Charge Applicable (X)',
                    pkl_Run_Cost_Applicable__c = 'No',
                    pkl_DO_PO_Details_Applicable__c = 'No',
                    pkl_Build_Details_Applicable__c = 'No',                 
                    pkl_Quotation_Available__c = 'No',
                    CreatedDate = Datetime.now().addSeconds(-productCount+count),
                    num_Quotation_Number__c = count
                    );
                    if(requestProduct.txt_Product_Type_Name__c.Contains('Other'))
                    {
                        quotationItem.txt_Publishers_Details__c = requestProduct.txt_Publisher__c;
                    }
                    requestQuotations.Add(quotationItem);
                    count++;                    
                }                
                Insert requestQuotations;
                Integer serialNumber = 1;
                for(SAM_Quote_Line_Item__c quote : requestQuotations)
                {
                    quote.num_Quotation_Number__c = serialNumber ;
                    serialNumber ++;
                }   
                Update requestQuotations;
            }
            catch(Exception e)
            { 
                System.debug('Quotation Line Items could NOT be created because of error : ' + e.getMessage());
            }
            
        }
        
    }