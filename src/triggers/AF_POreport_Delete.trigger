trigger AF_POreport_Delete on AF_Brand_Estimate__c (before delete,after update) {
    Set<String> BrandEstids = new Set<String>();
    List<AF_Agency_Estimate__c> agencyEstRecordList = new List<AF_Agency_Estimate__c>();
    List<AF_Brand_Estimate__c> brandEstRecordList = new List<AF_Brand_Estimate__c>();
    if(Trigger.isDelete){
        for(AF_Brand_Estimate__c  eachRecord:Trigger.old){
            BrandEstids.add(eachRecord.Id);
        }
        system.debug('BrandEstids....'+BrandEstids);
        if(!BrandEstids.isEmpty()){
            try{
            agencyEstRecordList = [select Id from AF_Agency_Estimate__c where AF_Brand_Estimate__c IN :BrandEstids];
            }
            catch(Exception e){
                system.debug(e);
            }
        }
        if(!agencyEstRecordList.isEmpty()){
            system.debug('agencyEstRecordList....'+agencyEstRecordList);
            delete agencyEstRecordList;
        }
    }
    else if(Trigger.isUpdate){
        for(AF_Brand_Estimate__c  eachRecord:Trigger.New){
            if((eachRecord.AF_Dont_Show_on_Report__c==false && Trigger.oldMap.get(eachRecord.Id).AF_Dont_Show_on_Report__c==true && 
            eachRecord.AF_Active__c==true && Trigger.oldMap.get(eachRecord.Id).AF_Active__c==false)||(eachRecord.AF_Basefee_Estimate_Initial_Quarter__c!=Trigger.oldMap.get(eachRecord.Id).AF_Basefee_Estimate_Initial_Quarter__c)){
                BrandEstids.add(eachRecord.Id);
            }
        }
        if(!BrandEstids.isEmpty()){
            try{
            agencyEstRecordList = [select Id from AF_Agency_Estimate__c where AF_Brand_Estimate__c IN :BrandEstids];
            }
            catch(Exception e){
                system.debug(e);
            }
        }
        if(!agencyEstRecordList.isEmpty()){
            system.debug('agencyEstRecordList...update.'+agencyEstRecordList);
            update agencyEstRecordList;
        }
    }
}