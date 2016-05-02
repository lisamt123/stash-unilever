/**********************************************************************
 Name:  CEC_UserTriggerHelper()
 Copyright ? 2013  Unilever
======================================================================
======================================================================
Purpose:  Trigger Helper Class                                                
1. To populate the Language_Skills_List__c and Product_Category_Skills_List__c fields.                               
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION   AUTHOR       DATE                DETAIL                  Description
  1.0 -  Koti Mule    09/03/2015       INITIAL DEVELOPMENT      User Field Population 
  
****************************************************************************/

public with sharing class CEC_UserTriggerHelper {

    // Populate the Language_Skills_List__c field from Language__c field.
    public void updateLanguageSkillSet(List<User> userList,Map<Id, User> oldUserMap){
        for(User userRecord: userList){//old mapoldUserMap
            if(userRecord.Language__c !=oldUserMap.get(userRecord.Id).Language__c){
                if(userRecord.Language__c == null || userRecord.Language__c == ''){
                    userRecord.Language_Skills_List__c= userRecord.Language__c;
                }
                else if(userRecord.Language__c.length()>255){
                    userRecord.Language_Skills_List__c = userRecord.Language__c.substring(0, 255);
                }
                else{
                    userRecord.Language_Skills_List__c= userRecord.Language__c;
                }

            }
        }

    }

    // Populate the Product_Category_Skills_List__c field from Product_Category__cfield.
    public void updateProductCategorySkillSet(List<User> userList,Map<Id, User> oldUserMap){
        for(User userRecord: userList){
            if(userRecord.Product_Category__c!=oldUserMap.get(userRecord.Id).Product_Category__c){
                            
                if(userRecord.Product_Category__c == null || userRecord.Product_Category__c == ''){
                    userRecord.Product_Category_Skills_List__c= userRecord.Product_Category__c ;
                }
                else if(userRecord.Product_Category__c.length()>255){
                    userRecord.Product_Category_Skills_List__c= userRecord.Product_Category__c.substring(0, 255);
                    userRecord.Product_Category_Skills_List2__c = userRecord.Product_Category__c.substring(255);
                }
                else{
                    userRecord.Product_Category_Skills_List__c= userRecord.Product_Category__c ;
                }
                
            }
        }
    }
}