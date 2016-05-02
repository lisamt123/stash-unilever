public with sharing class AR_FixedRateCardHelper {
    public AR_SObjectHolder RateCardCountry {get;set;}
    public List<AR_SObjectHolder> fixRateCardObjectListArtwork {get;set;}
    public Map<String,List<AR_SObjectHolder>>  fixRateCardObjectListTask {get;set;}
    public boolean remove = false;
    
    public AR_FixedRateCardHelper()
    {
        fixRateCardObjectListArtwork = new List<AR_SObjectHolder>();
        fixRateCardObjectListTask = new Map<String,List<AR_SObjectHolder>> ();
        RateCardCountry = new AR_SObjectHolder();
        RateCardCountry.obj = new ar_Fixed_Price_Rate_Card_Location__c();
    }
    
    
    public AR_FixedRateCardHelper(AR_SObjectHolder p_RateCardCountry)
    {
        fixRateCardObjectListArtwork = new List<AR_SObjectHolder>();
        fixRateCardObjectListTask = new Map<String,List<AR_SObjectHolder>> (); 
        RateCardCountry = p_RateCardCountry;
    }
   
    public void addObjtoList(AR_SObjectHolder p_obj)
    {
        if((String) p_obj.obj.get('Task_Group_short__c') == 'ArtworkCustom')
        {
            fixRateCardObjectListArtwork.add(p_obj);
        }
        else 
        {
            if(!fixRateCardObjectListTask.containskey((String)p_obj.obj.get('Task_Group_short__c')))
                fixRateCardObjectListTask.put((String)p_obj.obj.get('Task_Group_short__c'), new List<AR_SObjectHolder>());
            // add
            fixRateCardObjectListTask.get((String)p_obj.obj.get('Task_Group_short__c')).add(p_obj);
        }
    } 
    
    public List<ar_Fixed_Price_Rate_Card__c> returnRateCardstoInsert()
    {
        if(HasToBeInsered())
        {
            List<ar_Fixed_Price_Rate_Card__c> toUpsert = new List<ar_Fixed_Price_Rate_Card__c>();
            
            for(AR_SObjectHolder rateCard : fixRateCardObjectListArtwork) {
                toUpsert.add((ar_Fixed_Price_Rate_Card__c)rateCard.obj);
            }
            for(List<AR_SObjectHolder> ListRC:fixRateCardObjectListTask.values()) {
                for(AR_SObjectHolder rateCard:ListRC) {
                    toUpsert.add((ar_Fixed_Price_Rate_Card__c)rateCard.obj);
                }
            }
            for(ar_Fixed_Price_Rate_Card__c rc:toUpsert)
            {
                rc.FRC_Country__c = (ID)RateCardCountry.obj.get('Id');
            }
            return toUpsert;
        }
        return new List<ar_Fixed_Price_Rate_Card__c>();
    }
    
    public List<ar_Fixed_Price_Rate_Card__c> returnRateCardstoDelete()
    {
        List<ar_Fixed_Price_Rate_Card__c> toDelete = new List<ar_Fixed_Price_Rate_Card__c>();
            
        for(AR_SObjectHolder rateCard : fixRateCardObjectListArtwork) {
                toDelete.add((ar_Fixed_Price_Rate_Card__c)rateCard.obj);
        }
        for(List<AR_SObjectHolder> ListRC:fixRateCardObjectListTask.values()) {
                for(AR_SObjectHolder rateCard:ListRC) {
                    toDelete.add((ar_Fixed_Price_Rate_Card__c)rateCard.obj);
                }
        }
        return toDelete;
    }
    public void removerow()
    {
        remove = true;
    }
    
    public Boolean HasToBeInsered()
    {
        Boolean tmp_insert = false;
        if(RateCardCountry.obj.get('Name') != null && RateCardCountry.obj.get('Name') != '' )
        {
            tmp_insert = true;
        }
        if(RateCardCountry.obj.get('Country__c') != null && RateCardCountry.obj.get('Country__c') != '')
        {
            tmp_insert = true;
        }
        for(AR_SObjectHolder rateCard : fixRateCardObjectListArtwork) {
                if((double)rateCard.obj.get('Maximum_Allowable_Price__c') != null && (double)rateCard.obj.get('Maximum_Allowable_Price__c') != 0)
                {
                    tmp_insert = true;
                }
        }
        for(List<AR_SObjectHolder> ListRC:fixRateCardObjectListTask.values()) {
            for(AR_SObjectHolder rateCard:ListRC) {
                if((double)rateCard.obj.get('Maximum_Allowable_Price__c') != null && (double)rateCard.obj.get('Maximum_Allowable_Price__c') != 0)
                {
                    tmp_insert = true;
                }
            }
        }
        return tmp_insert;
    }
}