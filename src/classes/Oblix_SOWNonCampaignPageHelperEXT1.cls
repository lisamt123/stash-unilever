public with sharing class Oblix_SOWNonCampaignPageHelperEXT1 extends Oblix_SOWNonCampaignPageHelperParent{

    public static Map<String, Oblix_BasketSectionWrapper> initBasketSections(Id sowId) {

        Map<String, Oblix_BasketSectionWrapper> basket = new Map<String, Oblix_BasketSectionWrapper>();

        List<Marketing_Basics__c> existingNonCampaigns = [SELECT   Id, Activities__c, Name, No_of_Hours_Required__c, 
                                                                    OblixCountry__c, OblixCountry__r.Name , Role_Title__c, 
                                                                    Agency_Department__c,OblixOtherItemFee__c, 
                                                                    Oblix_Hourly_Rate__c, RecordTypeId, Oblix_SOWMarketing__c, Description__c 
                                                             FROM 
                                                                    Marketing_Basics__c 
                                                             WHERE 
                                                                    Oblix_SOWMarketing__c =: sowId ];

        for (Marketing_Basics__c nonCampaignSObject : existingNonCampaigns) {

            Oblix_NonCampaignWrapper nonCampaignWrapper = new Oblix_NonCampaignWrapper(nonCampaignSObject);
            String basketSectionKey = nonCampaignWrapper.getBasketSectionKey();

            if (nonCampaignSObject.RecordTypeId == Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_ID) {
                if (!basket.containsKey(basketSectionKey)) {
                    Oblix_BasketSectionWrapper sectionWrapper = new Oblix_BasketSectionWrapper(sowId, basketSectionKey, 'Dedicated Resources', Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_DEV_NAME);
                    basket.put(basketSectionKey, sectionWrapper);
                }

            } else if (nonCampaignSObject.RecordTypeId == Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID && nonCampaignSObject.Activities__c != 'Other') {
                if (!basket.containsKey(basketSectionKey)) {
                    Oblix_BasketSectionWrapper sectionWrapper = new Oblix_BasketSectionWrapper(sowId, basketSectionKey, nonCampaignSObject.Activities__c, Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_DEV_NAME, nonCampaignSObject.Activities__c);
                    basket.put(basketSectionKey, sectionWrapper);
                }

            } else {
                if (!basket.containsKey(basketSectionKey)) {
                    Oblix_BasketSectionWrapper sectionWrapper = new Oblix_BasketSectionWrapper(sowId, basketSectionKey, nonCampaignSObject.Name, Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_DEV_NAME, nonCampaignSObject.Activities__c, nonCampaignSObject.Name);
                    basket.put(basketSectionKey, sectionWrapper);
                }
            }

            basket.get(basketSectionKey).add(nonCampaignWrapper);
        }

        return basket;

    }

}