/**********************************************************************
Name: SAM_QLITrigger_Util()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform operation on before update event of QuatationTrigger
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR                 DATE            DETAIL Description
1.0      Pooja Kanani            28/07/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class SAM_QLITrigger_Util{

    /*******************************************************************
    Purpose: This method bring the currency conversion rate
    Parameters: List of SAM_Quote_Line_Item__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void currencyConversionRate(list<SAM_Quote_Line_Item__c> lstQuote){
        map<string,Decimal>mapIsoCodeConversionRate = new map<string,Decimal>();
            for(CurrencyType currencyRate : [Select IsoCode, ConversionRate from CurrencyType where IsoCode IN ('GBP','USD')]){
                mapIsoCodeConversionRate.put(currencyRate.IsoCode,currencyRate.ConversionRate);
            }
        for(SAM_Quote_Line_Item__c obj :lstQuote){
            obj.num_GBP_EUR__c = mapIsoCodeConversionRate.get(SAM_Constants.GBP);
            obj.num_USD_EUR__c = mapIsoCodeConversionRate.get(SAM_Constants.USD);   
        }
    }
   /*******************************************************************
    Purpose: If the Quote_Line_Item is other than Saved status, this method will prevent its deletion
    Parameters: List of SAM_Quote_Line_Item__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void PreventDelete(list<SAM_Quote_Line_Item__c> lstRequest){
        for(SAM_Quote_Line_Item__c obj :lstRequest){
            if(obj.pkl_Request_status__c != null && obj.pkl_Request_status__c != SAM_Constants.SAVED && obj.pkl_Request_status__c != SAM_Constants.OPEN && obj.pkl_Request_status__c != SAM_Constants.INPROGRESS && obj.pkl_Request_status__c != SAM_Constants.DRAFT_QUOTE_PROVIDED && obj.pkl_Request_status__c != SAM_Constants.QUOTE_REJECTED && obj.pkl_Request_status__c != SAM_Constants.INFORMATION_PROVIDED && obj.pkl_Request_status__c != SAM_Constants.ON_HOLD){
                obj.addError('You are not authorized to delete this record');
            }
        }
    } 
    /*******************************************************************
    Purpose: This will reassign the Quotation number to all the remaining quotation line items
    Parameters: List of SAM_Quote_Line_Item__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void ReNumberQuotationLineItems(list<SAM_Quote_Line_Item__c> deletedQLIs){
        List<SAM_Quote_Line_Item__c> QLIstoUpdate = new List<SAM_Quote_Line_Item__c>();
        List<Id> requestIds = new List<Id>();
        for(SAM_Quote_Line_Item__c deletedQLI : deletedQLIs)
        {
            requestIds.Add(deletedQLI.md_Request__c);
        }
        List<SAM_Request__c> requests = [Select Id,(SELECT CreatedDate,Id,num_Quotation_Number__c FROM Quote_Line_Items__r ORDER BY CreatedDate ASC) FROM SAM_Request__c where Id in :requestIds];
        for(SAM_Request__c request : requests)
        {
            List<SAM_Quote_Line_Item__c> requestQLIs = request.Quote_Line_Items__r;
            for(integer i = 1;i<=requestQLIs.Size();i++)
            {
                requestQLIs[i-1].num_Quotation_Number__c = i;        
            }
            QLIstoUpdate.AddAll(requestQLIs);
        }
        Update QLIstoUpdate;
    }
 
    
    /*******************************************************************
    Purpose: If the Request_Line_Item is other than Saved status, this method will prevent its new Product insert
    Parameters: List of SAM_Quote_Line_Item__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void PreventNewRecord(list<SAM_Quote_Line_Item__c> lstRequest){
        //21/08 Dinesh - Commented below variable to avoid below SonarQube issue
        //Avoid unused local variables such as 'ProfileName'.
        //Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
        //if(ProfileName.Name != SAM_Constants.SYSTEM_ADMINISTRATOR){
            Set<Id> ReqID = new Set<Id>(); 
            Map<ID,SAM_Request__c> mapReqIDRecord = new Map<ID,SAM_Request__c>();
            for(SAM_Quote_Line_Item__c obj :lstRequest){
                ReqID.add(obj.md_Request__c);
            }
            List<SAM_Request__c> ReqList = [Select id,pkl_Status__c from SAM_Request__c where id=:ReqID];
            for(SAM_Request__c req:ReqList ){
                mapReqIDRecord.put(req.Id,req);
            }
            Set<Id> AssigntoID = new Set<Id>();
            String userType = Schema.SObjectType.User.getKeyPrefix();

            for (GroupMember m : [Select Id, UserOrGroupId From GroupMember WHERE group.name = 'SAM Team']){
                if (((String)m.UserOrGroupId).startsWith(userType)){
                    AssigntoID.add(m.UserOrGroupId);
                }
            }
            for(SAM_Quote_Line_Item__c obj :lstRequest){
                 SAM_Request__c requestRec = mapReqIDRecord.get(obj.md_Request__c);
                if(!Test.isRunningTest() && Userinfo.getUserId() != null && AssigntoID != null && (!AssigntoID.contains(Userinfo.getUserId()) || (requestRec.pkl_Status__c != SAM_Constants.INPROGRESS && requestRec.pkl_Status__c != SAM_Constants.INFORMATION_PROVIDED && requestRec.pkl_Status__c != SAM_Constants.DRAFT_QUOTE_PROVIDED && requestRec.pkl_Status__c != SAM_Constants.QUOTE_REJECTED ))){
                    obj.addError('You are not authorized to create Quote at this status.');
                }
            }
        //}
    }
}