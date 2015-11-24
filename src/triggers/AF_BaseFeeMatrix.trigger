trigger AF_BaseFeeMatrix on AF_Agency_Estimate__c (before delete) {


Set<string> Compoundkey =new Set<string> ();
Set<Id> AgencyestimateId=new Set<Id>();
list<AF_Agency_Estimate__c> AgencyEstimatelist = new list<AF_Agency_Estimate__c>();
boolean errordisplay=false; 
Set<String> quarter = new Set<String>();
List<String> quarterList = new List<String>();
String quarterInfo='';
String brandEstimateName='';          
    for(AF_Agency_Estimate__c AgencyEst:trigger.old){
        if(AgencyEst.AF_Compound_Key__c!=null && AgencyEst.id!=null){
            AgencyestimateId.add(AgencyEst.Id);
            Compoundkey.add(AgencyEst.AF_Compound_Key__c);
            quarter.add(AgencyEst.AF_Mean_Quarter__c);
        }
     }
    quarterList.addAll(quarter);
    if(quarterList.size()>0){
    quarterInfo = quarterList[0];
    }
     system.debug(Compoundkey+'Compoundkey.............');
     
   AgencyEstimatelist =[select id, Name, AF_Adaptation__c, AF_Digital__c,Brand__c,Agency_Account_Id__c, AF_Agency_Entity__c, AF_Unilever_Entity__c, AF_Compound_Key__c, AF_Traditional__c,AF_Brand_Estimate__r.Name from AF_Agency_Estimate__c WHERE id NOT IN:AgencyestimateId and AF_Compound_Key__c IN:Compoundkey ]; 
     system.debug(AgencyEstimatelist+'AgencyEstimatelist..............');
      for(AF_Agency_Estimate__c  Agencylist:AgencyEstimatelist){
         brandEstimateName = Agencylist.AF_Brand_Estimate__r.Name;
         if(brandEstimateName.contains(quarterInfo) && (Agencylist.AF_Digital__c>0 || Agencylist.AF_Adaptation__c>0 ||  Agencylist.AF_Traditional__c>0 )){
            system.debug(Agencylist+'Agencylist..............');
            errordisplay=true;
         }
         brandEstimateName='';
      }
          
    for(AF_Agency_Estimate__c AgencyEstimateOldtrigger :trigger.old){
        If(errordisplay)
            AgencyEstimateOldtrigger.adderror('please check the base fees');
    } 
  
 }