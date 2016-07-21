trigger validationOnAmounts on AF_Sub_Result__c (before insert,before update,after update) {
Set<Id> BonusThresholdId = new Set<Id>();
Set<Id>  BonusAnnualSubResult = new Set<Id>();
Map<Id,String> BonusQuarterlySubResultMap = new Map<Id,String>();
Set<Id>  BonusQuarterlySubResult = new Set<Id>();
List<AF_Sub_Result__c> triggerList = new List<AF_Sub_Result__c>();
if(Trigger.isBefore){
    for(AF_Sub_Result__c b:trigger.new){
        
        if(b.AF_Minimum__c!=0){ 
        if((b.AF_Minimum__c >= b.AF_Stretching__c || b.AF_Minimum__c >= b.AF_Outstanding__c )){
        b.addError('Please ensure the values entered in the target threshold fields are ascending from minimum to outstanding');
        }
        else if((b.AF_Stretching__c  >= b.AF_Outstanding__c || b.AF_Stretching__c <=b.AF_Minimum__c )){
           b.addError('Please ensure the values entered in the target threshold fields are ascending from minimum to outstanding');
        }
         else if((b.AF_Outstanding__c  <= b.AF_Minimum__c || b.AF_Outstanding__c <=b.AF_Stretching__c )){
           b.addError('Please ensure the values entered in the target threshold fields are ascending from minimum to outstanding');
        }
        }
        
        else if(b.AF_Minimum__c==0 && b.AF_Stretching__c!=0 && b.AF_Outstanding__c!=0){
            if((b.AF_Minimum__c >= b.AF_Stretching__c || b.AF_Minimum__c >= b.AF_Outstanding__c )){
                b.addError('Please ensure the values entered in the target threshold fields are ascending from minimum to outstanding');
            }
            else if((b.AF_Stretching__c  >= b.AF_Outstanding__c || b.AF_Stretching__c <=b.AF_Minimum__c )){
                b.addError('Please ensure the values entered in the target threshold fields are ascending from minimum to outstanding');
            }
            else if((b.AF_Outstanding__c  <= b.AF_Minimum__c || b.AF_Outstanding__c <=b.AF_Stretching__c )){
                b.addError('Please ensure the values entered in the target threshold fields are ascending from minimum to outstanding');
            }
        }
        
    }
    }
    if(Trigger.isAfter){
        Map<Id,String> status = new Map<Id,String>();
        Map<Id,Boolean> Lock = new Map<Id,Boolean>();
        for(AF_Sub_Result__c b:trigger.new){
            BonusThresholdId.add(b.AF_Bonus_Threshold__c);
            triggerList.add(b);
            status.put(b.AF_Bonus_Threshold__c,b.AF_Status__c);
            Lock.put(b.AF_Bonus_Threshold__c,b.AF_Locked__c);
        }
        //List<AF_Sub_Result__c> subResult = new List<AF_Sub_Result__c>();
        List<AF_Bonus_Results__c> bonusResultList = new List<AF_Bonus_Results__c>();
        List<AF_Bonus_Results__c> bonusResultQuartList = new List<AF_Bonus_Results__c>();
        
        
        Decimal BonusableFeesQuarterly=0;
        List<AF_Sub_Result__c> queryListofSubResult= new List<AF_Sub_Result__c>();
        try{
        queryListofSubResult = [select AF_Bonusable_Fees__c,AF_Bonus_Threshold__c,AF_Total_Bonus_Value__c,AF_Qual_Bonus_Value__c,AF_Quant_Bonus_Value__c,AF_Period__c from AF_Sub_Result__c where AF_Bonus_Threshold__c IN :BonusThresholdId];
        }
        catch(Exception e){
            system.debug(e);
        }
        
        
        Decimal QuantBonusQuarterly=0;
        String Quarter ;
        Set<String> QuaterSet = new Set<String>();
        Map<Id,Decimal> bonusfeesAnnualMap = new Map<Id,Decimal>();
        Map<Id,Decimal> quantBonusAnnualMap = new Map<Id,Decimal>();
        Map<Id,Decimal> totalBonusAnnualMap = new Map<Id,Decimal>();
        Map<Id,Decimal> QualBonusAnnualMap = new Map<Id,Decimal>();
          for(AF_Sub_Result__c subResult:queryListofSubResult){
            if(subResult.AF_Period__c == null){
                Decimal BonusableFeesAnnual=0;
                if(subResult.AF_Bonusable_Fees__c!=null){
                if(!bonusfeesAnnualMap.containsKey(subResult.AF_Bonus_Threshold__c)){
                    
                    BonusableFeesAnnual = BonusableFeesAnnual + subResult.AF_Bonusable_Fees__c;
                    bonusfeesAnnualMap.put(subResult.AF_Bonus_Threshold__c,BonusableFeesAnnual);
                }
                else{
                   BonusableFeesAnnual = bonusfeesAnnualMap.get(subResult.AF_Bonus_Threshold__c);
                   BonusableFeesAnnual = BonusableFeesAnnual + subResult.AF_Bonusable_Fees__c;
                   bonusfeesAnnualMap.put(subResult.AF_Bonus_Threshold__c,BonusableFeesAnnual);
                }
                }
                Decimal totalBonusValue=0;
                if(subResult.AF_Total_Bonus_Value__c!=null){
                if(!totalBonusAnnualMap.containsKey(subResult.AF_Bonus_Threshold__c)){
                    totalBonusValue = totalBonusValue + subResult.AF_Total_Bonus_Value__c;
                    totalBonusAnnualMap.put(subResult.AF_Bonus_Threshold__c,totalBonusValue);
                }
                else{
                   totalBonusValue = totalBonusAnnualMap.get(subResult.AF_Bonus_Threshold__c);
                   totalBonusValue = totalBonusValue + subResult.AF_Total_Bonus_Value__c;
                   totalBonusAnnualMap.put(subResult.AF_Bonus_Threshold__c,totalBonusValue);
                }
                }
                Decimal QualBonus=0;
                if(subResult.AF_Qual_Bonus_Value__c!=null){
                if(!QualBonusAnnualMap.containsKey(subResult.AF_Bonus_Threshold__c)){
                    QualBonus = QualBonus + subResult.AF_Qual_Bonus_Value__c;
                    QualBonusAnnualMap.put(subResult.AF_Bonus_Threshold__c,QualBonus);
                }
                else{
                   QualBonus = QualBonusAnnualMap.get(subResult.AF_Bonus_Threshold__c);
                   QualBonus = QualBonus + subResult.AF_Qual_Bonus_Value__c;
                   QualBonusAnnualMap.put(subResult.AF_Bonus_Threshold__c,QualBonus);
                }
                }
                Decimal QuantBonusAnnual=0;
                if(subResult.AF_Quant_Bonus_Value__c!=null){
                if(!quantBonusAnnualMap.containsKey(subResult.AF_Bonus_Threshold__c)){
                    QuantBonusAnnual = QuantBonusAnnual + subResult.AF_Quant_Bonus_Value__c;
                    quantBonusAnnualMap.put(subResult.AF_Bonus_Threshold__c,QuantBonusAnnual);
                }
                else{
                   QuantBonusAnnual = quantBonusAnnualMap.get(subResult.AF_Bonus_Threshold__c);
                   QuantBonusAnnual = QuantBonusAnnual + subResult.AF_Quant_Bonus_Value__c;
                   quantBonusAnnualMap.put(subResult.AF_Bonus_Threshold__c,QuantBonusAnnual);
                }
                }
                
            }
            }
            
            
            
        
        Map<Id,Decimal> bonusfeesQ1 = new Map<Id,Decimal>();
        Map<Id,Decimal> bonusfeesQ2 = new Map<Id,Decimal>();
        Map<Id,Decimal> bonusfeesQ3 = new Map<Id,Decimal>();
        Map<Id,Decimal> quantBonusQ1 = new Map<Id,Decimal>();
        Map<Id,Decimal> quantBonusQ2 = new Map<Id,Decimal>();
        Map<Id,Decimal> quantBonusQ3 = new Map<Id,Decimal>();
        
        for(AF_Sub_Result__c c:queryListofSubResult){
            Decimal countBonusfees =0;
            if(c.AF_Period__c != null){
                if(c.AF_Bonusable_Fees__c!=null){
                if(c.AF_Period__c=='Q1'){
                if(!bonusfeesQ1.containsKey(c.AF_Bonus_Threshold__c)){
                    countBonusfees = countBonusfees+c.AF_Bonusable_Fees__c;
                    bonusfeesQ1.put(c.AF_Bonus_Threshold__c,countBonusfees);
                }
                else{
                   countBonusfees = bonusfeesQ1.get(c.AF_Bonus_Threshold__c);
                   countBonusfees = countBonusfees + c.AF_Bonusable_Fees__c;
                   bonusfeesQ1.put(c.AF_Bonus_Threshold__c,countBonusfees);
                }
                }
                else if(c.AF_Period__c=='Q2'){
                    if(!bonusfeesQ2.containsKey(c.AF_Bonus_Threshold__c)){
                        countBonusfees = countBonusfees+c.AF_Bonusable_Fees__c;
                        bonusfeesQ2.put(c.AF_Bonus_Threshold__c,countBonusfees);
                    }
                    else{
                        countBonusfees = bonusfeesQ2.get(c.AF_Bonus_Threshold__c);
                        countBonusfees = countBonusfees + c.AF_Bonusable_Fees__c;
                        bonusfeesQ2.put(c.AF_Bonus_Threshold__c,countBonusfees);
                    }
                }
                else if(c.AF_Period__c=='Q3'){
                    if(!bonusfeesQ3.containsKey(c.AF_Bonus_Threshold__c)){
                        countBonusfees = countBonusfees+c.AF_Bonusable_Fees__c;
                        bonusfeesQ3.put(c.AF_Bonus_Threshold__c,countBonusfees);
                    }
                    else{
                        countBonusfees = bonusfeesQ3.get(c.AF_Bonus_Threshold__c);
                        countBonusfees = countBonusfees + c.AF_Bonusable_Fees__c;
                        bonusfeesQ3.put(c.AF_Bonus_Threshold__c,countBonusfees);
                    }
                }
                }
                Decimal countquantBonus =0;
                 if(c.AF_Quant_Bonus_Value__c!=null){
                    if(c.AF_Period__c=='Q1'){
                        if(!quantBonusQ1.containsKey(c.AF_Bonus_Threshold__c)){
                            countquantBonus = countquantBonus+c.AF_Quant_Bonus_Value__c;
                            quantBonusQ1.put(c.AF_Bonus_Threshold__c,countquantBonus);
                        }
                        else{
                            countquantBonus = quantBonusQ1.get(c.AF_Bonus_Threshold__c);
                            countquantBonus = countquantBonus + c.AF_Quant_Bonus_Value__c;
                            quantBonusQ1.put(c.AF_Bonus_Threshold__c,countquantBonus);
                        }
                    }
                    else if(c.AF_Period__c=='Q2'){
                        if(!quantBonusQ2.containsKey(c.AF_Bonus_Threshold__c)){
                            countquantBonus = countquantBonus+c.AF_Quant_Bonus_Value__c;
                            quantBonusQ2.put(c.AF_Bonus_Threshold__c,countquantBonus);
                        }
                        else{
                            countquantBonus = quantBonusQ2.get(c.AF_Bonus_Threshold__c);
                            countquantBonus = countquantBonus + c.AF_Quant_Bonus_Value__c;
                            quantBonusQ2.put(c.AF_Bonus_Threshold__c,countquantBonus);
                        }
                    }
                    else if(c.AF_Period__c=='Q3'){
                        if(!quantBonusQ3.containsKey(c.AF_Bonus_Threshold__c)){
                            countquantBonus = countquantBonus+c.AF_Quant_Bonus_Value__c;
                            quantBonusQ3.put(c.AF_Bonus_Threshold__c,countquantBonus);
                        }
                        else{
                            countquantBonus = quantBonusQ3.get(c.AF_Bonus_Threshold__c);
                            countquantBonus = countquantBonus + c.AF_Quant_Bonus_Value__c;
                            quantBonusQ3.put(c.AF_Bonus_Threshold__c,countquantBonus);
                        }
                    }
                }
            }
        }
        for(AF_Sub_Result__c b:trigger.new){
            if(b.AF_Period__c == null){
                BonusAnnualSubResult.add(b.AF_Bonus_Threshold__c);
            }
            if(b.AF_Period__c != null){
                BonusQuarterlySubResultMap.put(b.AF_Bonus_Threshold__c,b.AF_Period__c);
                BonusQuarterlySubResult.add(b.AF_Bonus_Threshold__c);
                QuaterSet.add(b.AF_Period__c);
            }
        }
        if(BonusAnnualSubResult.size()>0){
        for(AF_Bonus_Results__c bonusResult : [select AF_Bonus_Thresholds__c,AF_Bonusable_Fees__c,AF_Status__c,AF_Locked__c,AF_Total_Bonus_Value__c,AF_Qual_Bonus_Value__c,AF_Quant_Bonus_Value__c from AF_Bonus_Results__c where AF_Bonus_Thresholds__c IN :BonusAnnualSubResult and RecordTypeId = : Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get('Bonus Annual').getRecordTypeId()]){
            bonusResult.AF_Bonusable_Fees__c = bonusfeesAnnualMap.get(bonusResult.AF_Bonus_Thresholds__c);
            bonusResult.AF_Total_Bonus_Value__c = totalBonusAnnualMap.get(bonusResult.AF_Bonus_Thresholds__c);
            bonusResult.AF_Qual_Bonus_Value__c = QualBonusAnnualMap.get(bonusResult.AF_Bonus_Thresholds__c);
            bonusResult.AF_Quant_Bonus_Value__c = quantBonusAnnualMap.get(bonusResult.AF_Bonus_Thresholds__c);
            bonusResult.AF_Status__c = status.get(bonusResult.AF_Bonus_Thresholds__c);
            bonusResult.AF_Locked__c = Lock.get(bonusResult.AF_Bonus_Thresholds__c);
            bonusResultList.add(bonusResult);
        }
        }
        Integer counter =0;
        Set<Id> bonusResultCreated = new Set<Id>();
        if(BonusQuarterlySubResult.size()>0){
            system.debug('inside the loop of bonus quarterly..');
            List<AF_Bonus_Results__c> tempBonusResult = new List<AF_Bonus_Results__c>();
            try{
            tempBonusResult = [select AF_Bonus_Thresholds__c,AF_Bonusable_Fees__c,AF_Period__c,AF_Status__c,AF_Locked__c,AF_Total_Bonus_Value__c,AF_Qual_Bonus_Value__c,AF_Quant_Bonus_Value__c from AF_Bonus_Results__c where AF_Bonus_Thresholds__c IN :BonusQuarterlySubResult and RecordTypeId = : Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get('Bonus Quarterly').getRecordTypeId() and AF_Period__c IN:QuaterSet];
            
            }
            catch(Exception e){
                system.debug(e);
            }
            if(tempBonusResult.size()!=BonusQuarterlySubResult.size()){
                counter=1;
            }
            for(AF_Bonus_Results__c bonusResult : tempBonusResult){
                bonusResultCreated.add(bonusResult.AF_Bonus_Thresholds__c);
                if(bonusResult.AF_Period__c=='Q1'){
                
                    bonusResult.AF_Bonusable_Fees__c = bonusfeesQ1.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Quant_Bonus_Value__c = quantBonusQ1.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Status__c = status.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Locked__c = Lock.get(bonusResult.AF_Bonus_Thresholds__c);
                }
                else if(bonusResult.AF_Period__c=='Q2'){
                    bonusResult.AF_Bonusable_Fees__c = bonusfeesQ2.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Quant_Bonus_Value__c = quantBonusQ2.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Status__c = status.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Locked__c = Lock.get(bonusResult.AF_Bonus_Thresholds__c);
                }
                else if(bonusResult.AF_Period__c=='Q3'){
                    bonusResult.AF_Bonusable_Fees__c = bonusfeesQ3.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Quant_Bonus_Value__c = quantBonusQ3.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Status__c = status.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Locked__c = Lock.get(bonusResult.AF_Bonus_Thresholds__c);
                }
                
                bonusResultQuartList.add(bonusResult);
                
            }
        }
        if(counter ==1){
        system.debug('inside counter0..');
        //system.debug('bonusfees...****'+bonusfees);
        List<AF_Bonus_Results__c> bonusquart = new List<AF_Bonus_Results__c>();
         for(Id bt:BonusQuarterlySubResultMap.keySet()){
            if(!bonusResultCreated.contains(bt)){
            AF_Bonus_Results__c b = new AF_Bonus_Results__c();
            if(BonusQuarterlySubResultMap.get(bt)=='Q1'){
            b.AF_Bonusable_Fees__c = bonusfeesQ1.get(bt);
            b.AF_Quant_Bonus_Value__c = quantBonusQ1.get(bt);
            b.AF_Bonus_Thresholds__c = bt;
            b.AF_Status__c = 'Draft';
            b.AF_Period__c = BonusQuarterlySubResultMap.get(bt);
            
            b.RecordTypeId=Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get('Bonus Quarterly').getRecordTypeId();
            bonusquart.add(b);
            }
            else if(BonusQuarterlySubResultMap.get(bt)=='Q2'){
            b.AF_Bonusable_Fees__c = bonusfeesQ2.get(bt);
            b.AF_Quant_Bonus_Value__c = quantBonusQ2.get(bt);
            b.AF_Bonus_Thresholds__c = bt;
            b.AF_Status__c = 'Draft';
            b.AF_Period__c = BonusQuarterlySubResultMap.get(bt);
            b.RecordTypeId=Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get('Bonus Quarterly').getRecordTypeId();
            bonusquart.add(b);
            }
            else if(BonusQuarterlySubResultMap.get(bt)=='Q3'){
            b.AF_Bonusable_Fees__c = bonusfeesQ3.get(bt);
            b.AF_Quant_Bonus_Value__c = quantBonusQ3.get(bt);
            b.AF_Bonus_Thresholds__c = bt;
            b.AF_Status__c = 'Draft';
            b.AF_Period__c = BonusQuarterlySubResultMap.get(bt);
            b.RecordTypeId=Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get('Bonus Quarterly').getRecordTypeId();
            bonusquart.add(b);
            }
            }
            }
            if(bonusquart.size()>0){
                upsert bonusquart;
            }
        } 
        if(bonusResultList.size()>0){
            upsert bonusResultList;
        }
        if(bonusResultQuartList.size()>0){
            upsert bonusResultQuartList;
        }
    }
}