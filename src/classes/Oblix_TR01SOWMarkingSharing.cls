/**
    About
    -----
    Description: Class Oblix_TR01SOWMarkingSharing
    Created for: Oblix Unilever Project
    Create date: 09/ 2015
    Created by Jamal Rida
    Author : @Jamal
    Details
    -------
    This class is  : used as a fired class from Trigger "AfterInsert" "After Update" on SOW Marketing object, to share records
                     
            Functionnalities : 
                    
    Update History
    --------------    
*/ 
public with sharing class Oblix_TR01SOWMarkingSharing {
    
    public static void sowMarketingSharing(List<Marketing_SOW__c> lstMarketingSow){
        //Select m.UserOrGroupId, m.RowCause, m.ParentId, m.Id From Marketing_SOW__Share m
        set<String> setBrandIds = new set<String>();
        set<String> setCategoryNames = new set<String>();
        List<User> lstUsers = new List<User>();
        List<MDO_BrandUser__c> lstBrandUsers = new List<MDO_BrandUser__c>();
        set<Id> setOWnerdsIds = new set<Id>();
        
        for(Marketing_SOW__c markSow : lstMarketingSow){
           	if(markSow.OblixBrand__c != null) setBrandIds.add(markSow.OblixBrand__c);
           	setOWnerdsIds.add(markSow.OwnerId);
        }
        lstBrandUsers = [Select Id, Name, Brand__c, User__c, Level_of_Visibility__c from MDO_BrandUser__c where Brand__c in: setBrandIds];
        
        List<Marketing_SOW__Share> lstMarketingShare = new List<Marketing_SOW__Share>();
        List<Marketing_SOW__Share> lstMarketingShareToDelete = new List<Marketing_SOW__Share>();     
        	lstMarketingShareToDelete = [Select Id, ParentId from  Marketing_SOW__Share where ParentId in :lstMarketingSow and UserOrGroupId Not IN : setOWnerdsIds];
        	if(!lstMarketingShareToDelete.isEmpty()){ delete lstMarketingShareToDelete;}
        	
        for(Marketing_SOW__c marketingSow : lstMarketingSow){
            if(lstBrandUsers.size()>0){
                for(MDO_BrandUser__c userSow : lstBrandUsers){
                    if(marketingSow.OblixBrand__c != null && userSow.Brand__c == marketingSow.OblixBrand__c && marketingSow.OwnerId != userSow.User__c){
                        Marketing_SOW__Share marketingSowShare = new Marketing_SOW__Share();
                            marketingSowShare.ParentId = marketingSow.ID;
                            marketingSowShare.AccessLevel = (userSow.Level_of_Visibility__c !=null ? userSow.Level_of_Visibility__c : 'Read');
                            marketingSowShare.UserOrGroupId = userSow.User__c;
                        lstMarketingShare.add(marketingSowShare);
                   }
                }
            }
        }
        if(lstMarketingShare.size()>0){
            insert lstMarketingShare;
            System.debug('###lstMArketingShare : '+lstMarketingShare);
        }
    }
}