public with sharing class AR_FixedDescriptionsHandler {

	static List<AR_Fixed_Rate_Card_Questions__c> settings ;
    public static AR_FixedRateCardHelper getRateCardOptions(sObject p_cleanObjTask,sObject p_cleanObjArtwork) {
        system.debug(logginglevel.info, '### Loading Rate Cards options');
        Map<String,List<AR_SObjectHolder>> results = new Map<String,List<AR_SObjectHolder>>();
        // get all options
        //Map<String, AR_Fixed_Rate_Card_Questions__c> settings = AR_Fixed_Rate_Card_Questions__c.getAll();
        if(AR_FixedDescriptionsHandler.settings == null)
        {
       		 AR_FixedDescriptionsHandler.settings = [Select Name,Definition__c,Discipline__c,Material_Costs_Included__c,Order__c,Per_Item__c,Subject_to_Annual_Rebate_Scheme__c,Task_Group_short__c,Task_Group__c from AR_Fixed_Rate_Card_Questions__c ORDER BY Order__c];
        }
        
        AR_SObjectHolder rcc = new AR_SObjectHolder();
        rcc.obj = new ar_Fixed_Price_Rate_Card_Location__c();
        AR_FixedRateCardHelper tmphelper = new AR_FixedRateCardHelper(rcc);
        
        for(AR_Fixed_Rate_Card_Questions__c frc : settings) {//.values()
            // new rate card
            AR_SObjectHolder rc = new AR_SObjectHolder();
            if(frc.Task_Group_short__c != 'Artwork')
            {
                rc.obj = p_cleanObjTask.clone(false,true);
            }
            else
            {
                rc.obj = p_cleanObjArtwork.clone(false,true);
            }
            rc.obj.put('Name', frc.Name);
            rc.obj.put('Per_Item__c', frc.Per_Item__c);
            //rc.obj.put('Maximun_Allowable_Price__c', frc.Maximun_Allowable_Price__c);
            rc.obj.put('Definition__c', frc.Definition__c);
            rc.obj.put('Material_Costs_Included__c', frc.Material_Costs_Included__c);
            rc.obj.put('Subject_to_Annual_Rebate_Scheme__c', frc.Subject_to_Annual_Rebate_Scheme__c);
            rc.obj.put('Task_Group__c', frc.Task_Group__c);
            rc.obj.put('Task_Group_short__c', frc.Task_Group_short__c);
            rc.obj.put('Order__c', frc.Order__c);
            rc.setPrefilled(true);

            // group values
            tmphelper.addObjtoList(rc);
            
        }
        system.debug(logginglevel.info, 'Values loaded! ' + results);
        return tmphelper;
    }
    
    public static List<AR_SObjectHolder> getInsuranceOptions(sObject p_cleanObj) {
        system.debug(logginglevel.info, '### Loading Insurance options');
        List<AR_SObjectHolder> results = new List<AR_SObjectHolder>();
        // get all options
        Map<String, AR_Insurance_Policy__c> settingsInsurance = AR_Insurance_Policy__c.getAll();
        
        for(AR_Insurance_Policy__c insurance : settingsInsurance.values()) {
            if(insurance.Type__c == 'Insurance') {
                // new insurance
                AR_SObjectHolder i = new AR_SObjectHolder();
                i.obj = p_cleanObj.clone(false,true);
                i.obj.put('Insurance_Type__c', insurance.name);
                i.obj.put('Description__c', insurance.Description__c);
                i.obj.put('Custom_Setting_Data__c', true);
                i.setPrefilled(true);
                // add
                results.add(i);
            }
        }
        system.debug(logginglevel.info, 'Values loaded! ' + results);
        return results;
    }
    
    public static List<AR_SObjectHolder> getPolicies(sObject p_cleanObj) {
        system.debug(logginglevel.info, '### Loading Policies options');
        List<AR_SObjectHolder> results = new List<AR_SObjectHolder>();
        // get all options
        Map<String, AR_Insurance_Policy__c> settingsPolicy = AR_Insurance_Policy__c.getAll();
        
        for(AR_Insurance_Policy__c policy : settingsPolicy.values()) {
            if(policy.type__c == 'Policy') {
                // new insurance
                AR_SObjectHolder i = new AR_SObjectHolder();
                i.obj = p_cleanObj.clone(false,true);
                i.obj.put('Policy__c', policy.name);
                i.obj.put('Custom_Setting_Data__c', true);
                i.setPrefilled(true);
                // add
                results.add(i);
            }
        }
        system.debug(logginglevel.info, 'Values loaded! ' + results);
        return results;
    }
}