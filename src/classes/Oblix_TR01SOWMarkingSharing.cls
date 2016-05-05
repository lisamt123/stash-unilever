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
    //list of MArketingShare to Delete First
    public static List<Marketing_SOW__Share> retrieveMarketingShare(List<Marketing_SOW__c> lstMarketingSow, set<Id> setOWnerdsIds){
        return [Select Id, ParentId from  Marketing_SOW__Share where ParentId in :lstMarketingSow and UserOrGroupId Not IN : setOWnerdsIds];
    }
    /*
    *    @Description : This method is used to return the list of SOW records to be shared with the corresponding users
    *    @Param : Sow, LstSow from Trigger
    *    @return : List<Marketing_SOW__Share>
    */
    public static List<Marketing_SOW__Share> sowMarketingSharing(Marketing_SOW__c sowTrig, List<Marketing_SOW__c> lstMarketingSow){
        //Select m.UserOrGroupId, m.RowCause, m.ParentId, m.Id From Marketing_SOW__Share m
        set<String> setBrandIds = new set<String>();
        set<String> setCategoryNames = new set<String>();
        List<User> lstUsers = new List<User>();
        List<MDO_BrandUser__c> lstBrandUsers = new List<MDO_BrandUser__c>();
        set<Id> setOWnerdsIds = new set<Id>();
        
        for(Marketing_SOW__c markSow : lstMarketingSow){
            if(sowTrig.Id == markSow.Id){
                if(markSow.OblixBrand__c != null){ setBrandIds.add(markSow.OblixBrand__c);}
                setOWnerdsIds.add(markSow.OwnerId);
            }
        }
        lstBrandUsers = [Select Id, Name, Brand__c, User__c, Level_of_Visibility__c from MDO_BrandUser__c where Brand__c in: setBrandIds];
        system.debug('###lstBrandUsers  : '+lstBrandUsers );
        List<Marketing_SOW__Share> lstMarketingShare = new List<Marketing_SOW__Share>();
        //Loop over SOW and get the corresponding user according to the brand, to be able to share it    
        for(Marketing_SOW__c marketingSow : lstMarketingSow){
            if(marketingSow.Id == sowTrig.Id){
                if(lstBrandUsers.size()>0){
                for(MDO_BrandUser__c userSow : lstBrandUsers){
                    if(marketingSow.OblixBrand__c != null && userSow.Brand__c == marketingSow.OblixBrand__c && marketingSow.OwnerId != userSow.User__c){
                        Marketing_SOW__Share marketingSowShare = new Marketing_SOW__Share();
                            marketingSowShare.ParentId = marketingSow.ID;
                            marketingSowShare.AccessLevel = (userSow.Level_of_Visibility__c !=null ? userSow.Level_of_Visibility__c : 'Read');
                            marketingSowShare.UserOrGroupId = userSow.User__c;
                            marketingSowShare.RowCause = 'Manual';//Schema.Marketing_SOW__Share.RowCause.SOW_sharing_by_brand__c;
                        lstMarketingShare.add(marketingSowShare);
                       
                   }
                }
            }
            }
            
        }
         system.debug('###lstMarketingShare : '+lstMarketingShare);
       
        return lstMarketingShare;
    }
}