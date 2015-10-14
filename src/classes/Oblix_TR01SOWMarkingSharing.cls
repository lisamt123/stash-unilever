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
public without sharing class Oblix_TR01SOWMarkingSharing {
    
    public static void sowMarketingSharing(List<Marketing_SOW__c> lstMarketingSow){
        //Select m.UserOrGroupId, m.RowCause, m.ParentId, m.Id From Marketing_SOW__Share m
        set<String> setBrandIds = new set<String>();
        set<String> setCategoryNames = new set<String>();
        List<User> lstUsers = new List<User>();
        List<MDO_BrandUser__c> lstBrandUsers = new List<MDO_BrandUser__c>();
        
        for(Marketing_SOW__c markSow : lstMarketingSow){
           	if(markSow.OblixBrand__c != null) setBrandIds.add(markSow.OblixBrand__c);
        }
        lstBrandUsers = [Select Id, Name, Brand__c, User__c from MDO_BrandUser__c where Brand__c in: setBrandIds];
        
        List<Marketing_SOW__Share> lstMarketingShare = new List<Marketing_SOW__Share>();
             
        for(Marketing_SOW__c marketingSow : lstMarketingSow){
            if(lstBrandUsers.size()>0){
                for(MDO_BrandUser__c userSow : lstBrandUsers){
                    if(marketingSow.OblixBrand__c != null && userSow.Brand__c == marketingSow.OblixBrand__c){
                        Marketing_SOW__Share marketingSowShare = new Marketing_SOW__Share();
                            marketingSowShare.ParentId = marketingSow.ID;
                            marketingSowShare.AccessLevel = 'Edit';
                            marketingSowShare.UserOrGroupId = userSow.Id;
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