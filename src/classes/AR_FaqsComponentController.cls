public with sharing class AR_FaqsComponentController {
    public List<Faq> cmsContent {get;set;}
    
    public class Faq {
        
        public ar_Agency_Portal_CMS__c cms {get;set;}
        public Faq(ar_Agency_Portal_CMS__c cms) {
            this.cms = cms;
        }
        public boolean getIsEven() {
            return math.mod(Integer.valueOf(cms.Order__c), 2) == 0;
        }
        public boolean getIsOdd() {
            return !getIsEven();
        }
        
    }
    
    public AR_FaqsComponentController() {
        this.cmsContent = new List<Faq>();
        for(ar_Agency_Portal_CMS__c cms : [
            select 
                title__c, 
                body__c,
                order__c
            from ar_Agency_Portal_CMS__c 
            where Type__c = 'FAQ' and Published__c = true order by Order__c]) {
                
            this.cmsContent.add(new Faq(cms));
        }
    }
    
}