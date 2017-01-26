public class UL_ComponentVisibility {
    public static List<MyPromotionRemoteActionExtension.EARUI> hideButtons(String salesOrg, String Status){
        List<MyPromotionRemoteActionExtension.EARUI> returnEARUIList = new List<MyPromotionRemoteActionExtension.EARUI>();
        List<UL_Component_Visibility__mdt> componentList = [SELECT Id, UL_Sales_Org__c, UL_Status__c, UL_Components__c, Common_for_Sales_Org__c, UL_Attribute__c 
                                                            FROM UL_Component_Visibility__mdt
                                                            WHERE UL_Sales_Org__c=:salesOrg AND UL_Attribute__c='UIElement'];
        for(UL_Component_Visibility__mdt component : componentList){
            if((component.UL_Status__c == Status || component.Common_for_Sales_Org__c) && component.UL_Components__c!=null){
                List<String> componentSplit = component.UL_Components__c.split(';');
                
                for(String name : componentSplit){
                    MyPromotionRemoteActionExtension.EARUI button = new MyPromotionRemoteActionExtension.EARUI();
                    button.Name = name;
                    button.Type = 'UIElement';
                    button.Visible = false;
                    
                    returnEARUIList.add(button);
                }
            }
        }
        return returnEARUIList;
    }
}