trigger AF_PreventQual on AF_Bonus_Results__c (before insert,before update) {
AF_AnnualBonus_Qual__c Custom_Qualatative=AF_AnnualBonus_Qual__c.getInstance('5');

for(AF_Bonus_Results__c br:trigger.new){
    
    if(br.AF_Qual__c!=null){
    
    if(br.AF_Qual__c>decimal.valueof(Custom_Qualatative.name)|| br.AF_Qual__c==0){
    br.adderror('Please enter qual value between 1-5');
    }
   }
  }
}