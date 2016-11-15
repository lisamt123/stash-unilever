trigger AF_OOPsBaseFeeMatrix on AF_OOPS_Estimate__c (before delete) {
//AF_Brand_Estimate__r.AF_Agency__c,,AF_OOPS_Actual__r.Name
//WHERE id NOT IN: OopsEstiamteId and oopsEst.AF_Compound_key__c IN:Compoundkey
Set<string> Compoundkey =new Set<string> ();
Set<Id> OopsEstiamteId=new Set<Id>();
list<AF_OOPS_Estimate__c> oopsEstimateList = new list<AF_OOPS_Estimate__c>();
boolean errordisplay=false; 
Set<String> quarter = new Set<String>();
List<String> quarterList = new List<String>();
String quarterInfo='';
String OopsActualName='';          
    for(AF_OOPS_Estimate__c oopsEst:trigger.old){
        if( oopsEst.id!=null && oopsEst.AF_Compound_key__c!=null){
            OopsEstiamteId.add(oopsEst.Id);
            Compoundkey.add(oopsEst.AF_Compound_key__c);
            quarter.add(oopsEst.AF_Mean_Quarter__c);
        }
     }
    quarterList.addAll(quarter);
    if(quarterList.size()>0){
    quarterInfo = quarterList[0];
    }
     system.debug(Compoundkey+'Compoundkey.............');
     
   oopsEstimateList =[select id, Name, AF_Adaptation__c, AF_Digital__c,AF_Brand__c, AF_Brand_Estimate__c, AF_Agency_Entity__c, AF_Unilever_Entity__c,  AF_Traditional__c, AF_Brand_Estimate__r.AF_Agency__c,AF_OOPS_Actual__r.Name  from AF_OOPS_Estimate__c WHERE id NOT IN:OopsEstiamteId and AF_Compound_key__c IN:Compoundkey ]; 
     system.debug(oopsEstimateList+'oopsEstimateList..............');
      for(AF_OOPS_Estimate__c  oopslist:oopsEstimateList){
         OopsActualName = oopslist.AF_OOPS_Actual__r.Name;
         if(OopsActualName.contains(quarterInfo) && (oopslist.AF_Digital__c>0 || oopslist.AF_Adaptation__c>0 ||  oopslist.AF_Traditional__c>0 )){
            system.debug(oopslist+'oopslist..............');
            errordisplay=true;
         }
         OopsActualName='';
      }
          
    for(AF_OOPS_Estimate__c OOPSEstimateOldtrigger :trigger.old){
        If(errordisplay)
            OOPSEstimateOldtrigger.adderror('please check the base fees');
    } 
  
 }