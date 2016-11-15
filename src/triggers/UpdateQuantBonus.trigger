trigger UpdateQuantBonus on AF_Sub_Result__c (before delete) {
    
    list<AF_Sub_Result__c> SubResult=new list<AF_Sub_Result__c>();
    set<id>BonusThershold=new set<id>();
    set<string> Uniquekey=new set<string>();
    list<AF_Bonus_Results__c> UpdateBonus =new list<AF_Bonus_Results__c>();
    list<AF_Bonus_Results__c> BonusList=new list<AF_Bonus_Results__c>();
    Set<String> quarter = new Set<String>();
    for(AF_Sub_Result__c Sub:trigger.old){
        BonusThershold.add(Sub.AF_Bonus_Threshold__c);
        quarter.add(Sub.AF_Period__c);
        Uniquekey.add(Sub.AF_Unique_Key__c);
    }
    system.debug(BonusThershold+'BonusThershold........');
    
    
    list<AF_Sub_Result__c> UpdateSubResult = new list<AF_Sub_Result__c>();
    try{
    BonusList=[select id , AF_Bonus_Thresholds__c, AF_Qual_Bonus_Value__c, AF_Period__c,AF_Bonusable_Fees__c, AF_Quant_Bonus_Value__c from AF_Bonus_Results__c where AF_Bonus_Thresholds__c IN:BonusThershold and RecordTypeId = : Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get('Bonus Quarterly').getRecordTypeId() and AF_Period__c IN:quarter];
    SubResult=[select id, AF_Bonus_Threshold__c,AF_Bonusable_Fees__c, AF_Result_type__c,  AF_Qual_Bonus_Value__c, AF_Period__c, AF_Unique_Key__c, AF_deletion_key__c from AF_Sub_Result__c where AF_Bonus_Threshold__c IN:BonusThershold and AF_Unique_Key__c IN:Uniquekey and AF_Result_type__c='Quarterly' and AF_Status__c='Draft'];
    system.debug('BonusList...'+BonusList);
    system.debug('SubResult...'+SubResult);
    }
    catch(Exception e){
        system.debug(e);
    }
    Integer countQ1=0;
    Integer countQ2=0;
    Integer countQ3=0;
    for(AF_Sub_Result__c s:SubResult){
        if(s.AF_Period__c=='Q1'){
            countQ1++;
        }
        else if(s.AF_Period__c=='Q2'){
            countQ2++;
        }
        else if(s.AF_Period__c=='Q3'){
            countQ3++;
        }
    }
    system.debug('countQ1...'+countQ1);
    system.debug('countQ2...'+countQ2);
    system.debug('countQ3...'+countQ3);
        for(AF_Sub_Result__c Sub:SubResult){
            for(AF_Bonus_Results__c Bonus:BonusList){
                    if(countQ1==2 && Sub.AF_Period__c=='Q1' && Sub.AF_Period__c==Bonus.AF_Period__c){
                        system.debug('inside the Q1 loop...');
                        Sub.AF_Bonusable_Fees__c=Bonus.AF_Bonusable_Fees__c;
                        UpdateSubResult.add(Sub);
                    }
                    else if(countQ2==2 && Sub.AF_Period__c=='Q2' && Sub.AF_Period__c==Bonus.AF_Period__c){
                        system.debug('inside the Q2 loop...');
                        Sub.AF_Bonusable_Fees__c=Bonus.AF_Bonusable_Fees__c;
                        UpdateSubResult.add(Sub);
                    }
                    else if(countQ3==2 && Sub.AF_Period__c=='Q3' && Sub.AF_Period__c==Bonus.AF_Period__c){
                        system.debug('inside the Q3 loop...');
                        Sub.AF_Bonusable_Fees__c=Bonus.AF_Bonusable_Fees__c;
                        UpdateSubResult.add(Sub);
                    }
                    
                    
                    system.debug(UpdateSubResult+'UpdateSubResult.........');
                }       
            
        }
    if(UpdateSubResult.size()>0){
    try{
    update UpdateSubResult;
    }
    catch(Exception e){
        system.debug(e);
    }
    }
    
    
    try{
    BonusList=[select id , AF_Bonus_Thresholds__c, AF_Qual_Bonus_Value__c, AF_Period__c,AF_Quant_Bonus_Value__c from AF_Bonus_Results__c where AF_Bonus_Thresholds__c IN:BonusThershold and RecordTypeId = : Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get('Bonus Quarterly').getRecordTypeId() and AF_Period__c IN:quarter];
    }
    catch(Exception e){
        system.debug(e);
    }
    system.debug(BonusList+'BonusList........');
    for(AF_Bonus_Results__c  Bonus:BonusList){
        for(AF_Sub_Result__c Sub:trigger.old){
            if(Sub.AF_Period__c!=null){
                Decimal Amt=0;
                system.debug('Sub.AF_Period__c...'+Sub.AF_Period__c);
                if(Sub.AF_Period__c=='Q1' && Bonus.AF_Period__c=='Q1'){
                   if(Bonus.AF_Quant_Bonus_Value__c!=null && Sub.AF_Quant_Bonus_Value__c!=null){
                    Amt = Bonus.AF_Quant_Bonus_Value__c-Sub.AF_Quant_Bonus_Value__c;
                    system.debug('Amt..'+Amt);
                    Bonus.AF_Quant_Bonus_Value__c = Amt;
                    UpdateBonus.add(Bonus);
                    }
                }
                else if(Sub.AF_Period__c=='Q2' && Bonus.AF_Period__c=='Q2'){
                 if(Bonus.AF_Quant_Bonus_Value__c!=null && Sub.AF_Quant_Bonus_Value__c!=null){
                    Amt=Bonus.AF_Quant_Bonus_Value__c-Sub.AF_Quant_Bonus_Value__c;
                    system.debug('Amt..'+Amt);
                    Bonus.AF_Quant_Bonus_Value__c = Amt;
                    UpdateBonus.add(Bonus);
                    }
                }
                else if(Sub.AF_Period__c=='Q3' && Bonus.AF_Period__c=='Q3'){
                     if(Bonus.AF_Quant_Bonus_Value__c!=null && Sub.AF_Quant_Bonus_Value__c!=null){
                    Amt=Bonus.AF_Quant_Bonus_Value__c-Sub.AF_Quant_Bonus_Value__c;
                    system.debug('Amt..'+Amt);
                    Bonus.AF_Quant_Bonus_Value__c = Amt;
                    UpdateBonus.add(Bonus);
                    }
                }
                
            }
        }
    }
    
    if(UpdateBonus.size()>0){
    try{
    update UpdateBonus;
    }
    catch(Exception e){
        system.debug(e);
    }
    }
    
    
    
}