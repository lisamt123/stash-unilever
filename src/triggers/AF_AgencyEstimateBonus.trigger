trigger AF_AgencyEstimateBonus on AF_Agency_Estimate__c(after update){
    Set<String> agencyEstimateUnique = new Set<String>();
    Set<Id> Agency = new Set<Id>();
    Set<Id> Brand = new Set<Id>();
    Set<String> Year = new Set<String>();
    Set<String> Country = new Set<String>();
    List<AF_Agency_Estimate__c> agencyEstimateRecords = new List<AF_Agency_Estimate__c>();
    map<String,map<String,Decimal>> countryTradDigitalMap = new map<String,map<String,Decimal>>();
    map<String,Decimal> tradDigitaltotals = new map<String,Decimal>();
    List<AF_Sub_Result__c> subResultRecords = new List<AF_Sub_Result__c>();
    Decimal TraditionalTotal = 0.0;
    Decimal DigitalTotal = 0.0;
    Decimal Total=0.0;
    Decimal TradAmount =0.0;
    Decimal DigitalAmount =0.0;
    Decimal TDTotal =0.0;
    for(AF_Agency_Estimate__c AgencyEst:Trigger.new){
        if(AgencyEst.AF_BrandEstimate_Active__c && (AgencyEst.AF_Traditional__c!= Trigger.oldMap.get(AgencyEst.Id).AF_Traditional__c || AgencyEst.AF_Digital__c!= Trigger.oldMap.get(AgencyEst.Id).AF_Digital__c)){
            agencyEstimateUnique.add(AgencyEst.AF_Bonus_Agency_Formula__c);
            Agency.add(AgencyEst.AF_AgencyEntityId__c);
            Brand.add(AgencyEst.AF_BrandIdunique__c);
            Country.add(AgencyEst.AF_UnileverCountryName__c);
            Year.add(AgencyEst.AF_Fiscal_Year__c);
        }
    }
    
    system.debug('agencyEstimateUnique...'+agencyEstimateUnique);
    system.debug('Agency...'+Agency);
    system.debug('Brand...'+Brand);
    system.debug('Country...'+Country);
    system.debug('Year...'+Year);
    
    agencyEstimateRecords = [select AF_Traditional__c,AF_Digital__c,AF_Bonus_Agency_Formula__c from AF_Agency_Estimate__c where AF_Bonus_Agency_Formula__c IN:agencyEstimateUnique and AF_BrandEstimate_Active__c=true];
    system.debug('agencyEstimateRecords...'+agencyEstimateRecords);
    if(agencyEstimateRecords.size()>0){
        for(AF_Agency_Estimate__c a:agencyEstimateRecords){
            if(!countryTradDigitalMap.containsKey(a.AF_Bonus_Agency_Formula__c)){
                TraditionalTotal =0.0;
                DigitalTotal = 0.0;
                TraditionalTotal = TraditionalTotal + a.AF_Traditional__c;
                DigitalTotal = DigitalTotal + a.AF_Digital__c;
                Total = TraditionalTotal + DigitalTotal;
                tradDigitaltotals.put('Trad',TraditionalTotal);
                tradDigitaltotals.put('Digital',DigitalTotal);
                tradDigitaltotals.put('TD',Total);
                countryTradDigitalMap.put(a.AF_Bonus_Agency_Formula__c,tradDigitaltotals);
            }
            else{
                TradAmount = tradDigitaltotals.get('Trad');
                DigitalAmount = tradDigitaltotals.get('Digital');
                TDTotal = tradDigitaltotals.get('TD');
                TradAmount = TradAmount + a.AF_Traditional__c;
                DigitalAmount = DigitalAmount + a.AF_Digital__c;
                TDTotal = TradAmount + DigitalAmount;
                tradDigitaltotals.put('Trad',TradAmount);
                tradDigitaltotals.put('Digital',DigitalAmount);
                tradDigitaltotals.put('TD',TDTotal);
                countryTradDigitalMap.put(a.AF_Bonus_Agency_Formula__c,tradDigitaltotals);
            }
            system.debug('countryTradDigitalMap...'+countryTradDigitalMap);
        }
    }
    
    subResultRecords = [select AF_Traditional__c,AF_Digital__c,AF_Bonusable_Fees__c,AF_Bonus_Threshold__c,AF_Bonus_Threshold__r.Agency_Name__c,AF_Bonus_Threshold__r.Brand_Name__c,AF_Bonus_Threshold__r.Country_Name__c,AF_Bonus_Threshold__r.Year__c from AF_Sub_Result__c where AF_Bonus_Threshold__r.Agency_Name__c IN:Agency 
                        and AF_Bonus_Threshold__r.Brand_Name__c IN:Brand and AF_Bonus_Threshold__r.Country_Name__c IN:Country and AF_Bonus_Threshold__r.Year__c IN:Year and AF_Locked__c=false and AF_Period__c!=null];
    if(subResultRecords.size()>0){
        Decimal TDBonusableFees=0.0;
        Decimal TBonusableFees=0.0;
        Decimal DBonusableFees=0.0;
        List<AF_Sub_Result__c> updatedSubResult = new List<AF_Sub_Result__c>();
        for(AF_Sub_Result__c sub:subResultRecords){
            String Uniquekey='';
            Uniquekey = sub.AF_Bonus_Threshold__r.Agency_Name__c+'::'+sub.AF_Bonus_Threshold__r.Brand_Name__c+'::'+sub.AF_Bonus_Threshold__r.Country_Name__c+'::'+sub.AF_Bonus_Threshold__r.Year__c;
            system.debug('Uniquekey...'+Uniquekey);
            if(sub.AF_Traditional__c && sub.AF_Digital__c){
                TDBonusableFees = countryTradDigitalMap.get(Uniquekey).get('TD');
                sub.AF_Bonusable_Fees__c = TDBonusableFees;
            }
            else if(sub.AF_Traditional__c){
            TBonusableFees =countryTradDigitalMap.get(Uniquekey).get('Trad');
            sub.AF_Bonusable_Fees__c = TBonusableFees;
            }
            else if(sub.AF_Digital__c){
            DBonusableFees = countryTradDigitalMap.get(Uniquekey).get('Digital');
            sub.AF_Bonusable_Fees__c = DBonusableFees;
            }
            updatedSubResult.add(sub);
        }
        if(updatedSubResult.size()>0){
            system.debug('updatedSubResult...'+updatedSubResult);
            update updatedSubResult;
        }
    }
    
}