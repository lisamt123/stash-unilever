trigger AA_AddCompetitorName on aa_Agent_App_Brand_Category__c (before insert, before update) {

  set<ID> BrandId=new set<ID>();
  //get recordtype Id for Competitor Brand
  Schema.DescribeSObjectResult R = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
  Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
  Id recTypeId = (RT.get('Competitor Brand')).getRecordTypeId();
  
  for(aa_Agent_App_Brand_Category__c BrandCategory:Trigger.new){
    
  //system.debug('before insert object'+BrandCategory.Brand_Id__c);
    if(BrandCategory.Brand_Id__c != null){
    BrandId.add(BrandCategory.Brand_Id__c);
    }
  }
  
   if(BrandId.size()>0){ 
    
    List<aa_Agent_App_Competitor_Brand__c> compbrand=[Select Id,Competitor__c from aa_Agent_App_Competitor_Brand__c where Id IN:BrandId AND RecordTypeId=:recTypeId];
    Map<ID,ID> compmap=new Map<ID,ID>();
    if(compbrand.size()>0){
    for(aa_Agent_App_Competitor_Brand__c comp :compbrand){
        system.debug('comp1232========>'+comp);
    compmap.put(comp.id,comp.Competitor__c);
    }
    }
    system.debug('map of brand & competitor name'+compmap);
        
    for(aa_Agent_App_Brand_Category__c BrandCategory:Trigger.new){
    if(compmap.get(BrandCategory.Brand_Id__c)!=null){
    BrandCategory.Agent_Competitor_Id__c=compmap.get(BrandCategory.Brand_Id__c);
    }
    System.debug('competiror final object===>'+BrandCategory);   
    }
   }
}