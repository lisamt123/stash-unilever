trigger AF_updateBonusThreshold on AF_Sub_Result__c (after update, after insert){
    
       
    set<id> bonusthreshold=new set<id>();
    list<AF_Sub_Result__c> SubBonusQuarterlyList=new list<AF_Sub_Result__c>();
    list<AF_Sub_Result__c> Subresultold=new list<AF_Sub_Result__c>(); 
    list<AF_Sub_Result__c>  Subresultupdate= new list<AF_Sub_Result__c>();
    list<AF_Sub_Result__c>  SubresultTriggerNew= new list<AF_Sub_Result__c>();
    list<AF_Sub_Result__c>  subresultinsert=new list<AF_Sub_Result__c>();
    Set<Id> AgencyName = new set<id>();
    Set<Id> BrandName = new set<id>();
    Set<String> year = new set<String>();
    list<AF_Sub_Result__c>  bonusThrehsoldList= new list<AF_Sub_Result__c>();
    
    if(checkRecursiveBonusQuarterly.run){
    checkRecursiveBonusQuarterly.run=false;
    for(AF_Sub_Result__c SubResList : trigger.new){
        if(SubResList.AF_Bonus_Threshold__c!=null ){
            bonusthreshold.add(SubResList.AF_Bonus_Threshold__c);
            
        }
        SubresultTriggerNew.add(SubResList);
    }
    system.debug('SubresultTriggerNew...'+SubresultTriggerNew);
    
        if(Trigger.isInsert){
        bonusThrehsoldList = [select AF_Bonus_Threshold__r.Agency_Name__c,AF_Bonus_Threshold__r.Brand_Name__c,AF_Bonus_Threshold__r.Year__c from AF_Sub_Result__c where AF_Bonus_Threshold__c IN:bonusthreshold];
        system.debug('bonusThrehsoldList...'+bonusThrehsoldList);
        if(bonusThrehsoldList.size()>0){
            for(AF_Sub_Result__c subBonusRes:bonusThrehsoldList){
                
                AgencyName.add(subBonusRes.AF_Bonus_Threshold__r.Agency_Name__c);
                BrandName.add(subBonusRes.AF_Bonus_Threshold__r.Brand_Name__c);
                year.add(subBonusRes.AF_Bonus_Threshold__r.Year__c);
            }
        }
        system.debug('AgencyName...'+AgencyName);
        system.debug('BrandName...'+BrandName);
        system.debug('year...'+year);
      }
    if(bonusthreshold != null && !bonusthreshold.isempty() ){
        system.debug(bonusthreshold +'bonusthreshold ......');
        if(Trigger.isUpdate){
            SubBonusQuarterlyList=[select id,AF_Minimum__c,AF_Outstanding__c, AF_Stretching__c,AF_country__c,AF_Traditional__c,AF_Digital__c,Bonus_Measure__c,AF_deletion_key__c,AF_Bonus_Threshold__c,Sub_Result_AnnualID__c from AF_Sub_Result__c where (AF_Period__c='Q1' or AF_Period__c='Q2' or AF_Period__c='Q3') and AF_Status__c='Draft' and AF_Bonus_Threshold__c IN:bonusthreshold ];
            if(SubBonusQuarterlyList.size()>0){
            for(AF_Sub_Result__c subnew: SubBonusQuarterlyList){
                for(AF_Sub_Result__c s:trigger.new){
                    //AF_Sub_Result__c subQuartSingleRecord=new AF_Sub_Result__c();
                    //if(subnew.Sub_Result_AnnualID__c !=null){
                    system.debug('Sub_Result_AnnualID__c...'+subnew.Sub_Result_AnnualID__c);
                    system.debug('s.Id...'+s.Id);
                    system.debug('subnew.AF_deletion_key__c...'+subnew.AF_deletion_key__c);
                    system.debug('s.AF_deletion_key__c...'+s.AF_deletion_key__c);
                    system.debug('s.AF_Period__c...'+s.AF_Period__c);
                        if(subnew.Sub_Result_AnnualID__c==s.Id && subnew.Sub_Result_AnnualID__c!=null){                  
                            system.debug('inside if....');
                            subnew.AF_Minimum__c=s.AF_Minimum__c;
                            subnew.AF_Outstanding__c=s.AF_Outstanding__c;
                            subnew.AF_Stretching__c=s.AF_Stretching__c;
                            subnew.AF_country__c=s.AF_country__c;
                            subnew.Bonus_Measure__c=s.Bonus_Measure__c;
                            subnew.AF_Traditional__c=s.AF_Traditional__c;
                            subnew.AF_Digital__c=s.AF_Digital__c;
                            Subresultupdate.add(subnew);
                            
                        }
                        else if((subnew.AF_deletion_key__c==s.AF_deletion_key__c) && s.AF_Period__c==null){
                            system.debug('inside the else...');
                            subnew.AF_Minimum__c=s.AF_Minimum__c;
                            subnew.AF_Outstanding__c=s.AF_Outstanding__c;
                            subnew.AF_Stretching__c=s.AF_Stretching__c;
                            subnew.AF_country__c=s.AF_country__c;
                            subnew.Bonus_Measure__c=s.Bonus_Measure__c;
                            subnew.AF_Traditional__c=s.AF_Traditional__c;
                            subnew.AF_Digital__c=s.AF_Digital__c;
                            subnew.Sub_Result_AnnualID__c = s.Id;
                            Subresultupdate.add(subnew);
                        }
                        
                   // }
                }
            }
            
        }
        if(Subresultupdate != null && !Subresultupdate.isEmpty()){
        try{
            update Subresultupdate;
        }catch(exception e){
            system.debug('exception message--->'+e.getMessage());
        }
    }
        }
        }
        
        if(Trigger.isInsert){
        Set<String> QuarterInfo = new Set<String>();
            SubBonusQuarterlyList=[select id,AF_Minimum__c,AF_Outstanding__c, AF_Stretching__c,AF_country__c,AF_Traditional__c,AF_Digital__c,Bonus_Measure__c,AF_deletion_key__c,AF_Bonus_Threshold__c,Sub_Result_AnnualID__c,AF_Period__c from AF_Sub_Result__c where (AF_Period__c='Q1' or AF_Period__c='Q2' or AF_Period__c='Q3') and AF_Status__c='Draft' and AF_Bonus_Threshold__r.Agency_Name__c IN:AgencyName and AF_Bonus_Threshold__r.Brand_Name__c IN:BrandName and AF_Bonus_Threshold__r.Year__c IN:year and AF_Class_code__c=false];
        
        system.debug('SubBonusQuarterlyList...'+SubBonusQuarterlyList);
        
        if(SubBonusQuarterlyList.size()>0){
            for(AF_Sub_Result__c s:SubBonusQuarterlyList){
                QuarterInfo.add(s.AF_Period__c);
        }
        }
        if(SubBonusQuarterlyList.size()>0){
            for(String subnew: QuarterInfo){
                for(AF_Sub_Result__c s:trigger.new){
                    AF_Sub_Result__c subQuartSingleRecord=new AF_Sub_Result__c();
                    if(subnew=='Q1'){
                                     subQuartSingleRecord.AF_Period__c = 'Q1';
                                 }
                                 else if(subnew=='Q2'){
                                     subQuartSingleRecord.AF_Period__c = 'Q2';
                                 }
                                 else if(subnew=='Q3'){
                                     subQuartSingleRecord.AF_Period__c = 'Q3';
                                 }
                                 subQuartSingleRecord.AF_Minimum__c=s.AF_Minimum__c;
                                 subQuartSingleRecord.AF_Outstanding__c=s.AF_Outstanding__c;
                                 subQuartSingleRecord.AF_Stretching__c=s.AF_Stretching__c;
                                 subQuartSingleRecord.AF_country__c=s.AF_country__c;
                                 subQuartSingleRecord.Bonus_Measure__c=s.Bonus_Measure__c;
                                 subQuartSingleRecord.AF_Traditional__c=s.AF_Traditional__c;
                                 subQuartSingleRecord.AF_Digital__c=s.AF_Digital__c;
                                 subQuartSingleRecord.AF_Bonus_Threshold__c = s.AF_Bonus_Threshold__c;
                                 subQuartSingleRecord.Af_status__c = 'Draft';
                                 subQuartSingleRecord.Sub_Result_AnnualID__c=s.Id;
                                 subresultinsert.add(subQuartSingleRecord);
                                 system.debug('subresultinsert.........77777.....'+subresultinsert);
                }
            }
            
        }
        
        
    if(subresultinsert.size()>0){
        try{
            system.debug('subresultinsert.........******.....'+subresultinsert);
            upsert subresultinsert;
        }catch(exception e){
            system.debug('exception message--->'+e.getMessage());
        }
    }
    }
    }
}