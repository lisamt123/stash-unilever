@isTest
public class UL_PromotionTemplateTestFactory{
    public static ACCL__Promotion_Template__c createPromotionTemplate(Integer suffix, Boolean active, String anchorType) {
            ACCL__Promotion_Template__c template = new ACCL__Promotion_Template__c();
            template.Name = 'PromotionTemplateName_' + suffix;
            template.ACCL__Description_Language_1__c = 'Description_Language_1_' + suffix;
            template.ACCL__Active__c = active;
            template.ACCL__Promotion_Type__c = 'Promotion';
            template.ACCL__Creation_Platform__c = 'Both';
            template.ACCL__Anchor_Type__c = anchorType;
            return template;
        }
    
    
}