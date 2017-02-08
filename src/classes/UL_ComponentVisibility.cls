/***************************************************************
Name: UL_ComponentVisibility
Copyright © 2016 Salesforce
======================================================
Purpose:
Hide or visible Buttons in smart UI based on salesorg
======================================================
History
-------
VERSION     AUTHOR             DATE              DETAIL            Description
1.0         Abhishek Bansal    01/12/2016        INITIAL DEV       Hide or visible Buttons in smart UI
*****************************************************************/
public without sharing class UL_ComponentVisibility {
/*******************************************************************
    Purpose: Hide or visible Buttons in smart UI based on salesorg 
    Version: 1.0
    Parameters: String salesOrg, String Status, boolean isChildPromotion
    Returns: List<MyPromotionRemoteActionExtension.EARUI>
    Throws N/A
    ********************************************************************/
    public static List<MyPromotionRemoteActionExtension.EARUI> hideButtons(String salesOrg, String Status, boolean isChildPromotion){
        
        List<MyPromotionRemoteActionExtension.EARUI> returnEARUIList = new List<MyPromotionRemoteActionExtension.EARUI>();
        try{
        List<UL_Component_Visibility__mdt> componentList  = new List<UL_Component_Visibility__mdt>();
    
        for(UL_Component_Visibility__mdt component : [SELECT Id,UL_Visible_Components__c, UL_Sales_Org__c, UL_Status__c, UL_Components__c, Common_for_Sales_Org__c, UL_Attribute__c, UL_is_Child_Promotion__c 
                                                            FROM UL_Component_Visibility__mdt
                                                            WHERE UL_Sales_Org__c=:UL_Sales_Org_Mapping__c.getValues(salesOrg).UL_Sales_Org__c AND UL_Attribute__c=:ul_utility.UIElement LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())]){
            if(component.UL_Status__c == Status || component.Common_for_Sales_Org__c || (isChildPromotion && component.UL_is_Child_Promotion__c)){
                if(component.UL_Components__c!=null){                
                List<String> componentSplit = component.UL_Components__c.split(ul_utility.semiColon);
                
                for(String name : componentSplit){
                    MyPromotionRemoteActionExtension.EARUI button = new MyPromotionRemoteActionExtension.EARUI();
                    button.Name = name;
                    button.Type = ul_utility.UIElement;
                    button.Visible = false;
                    
                    returnEARUIList.add(button);
                }
               }
                if(component.UL_Visible_Components__c!=null){                
                List<String> componentSplit = component.UL_Visible_Components__c.split(ul_utility.semiColon);
                
                for(String name : componentSplit){
                    MyPromotionRemoteActionExtension.EARUI button = new MyPromotionRemoteActionExtension.EARUI();
                    button.Name = name;
                    button.Type = ul_utility.UIElement;
                    button.Visible = true;
                    returnEARUIList.add(button);
                }
                
               }
               
            }
        }
        }
        Catch(exception ex){
        throw ex;
        }
        return returnEARUIList;
    }
}