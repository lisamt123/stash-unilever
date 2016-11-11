/*Main Batch for Mobile Biiling*/

global with sharing class MB_BillingBatch implements Database.Batchable<Sobject>,Database.Stateful {

   global set<String>  countryMonthList=new set<String>();
   global set<String>  countryMonthBillingInsightList=new set<String>();
   
   global List<MobileBillingInsights__c>  uniqueList=new List<MobileBillingInsights__c>(); 
   global String concatString='';
   
   global Set<String> countrySet = new Set<String>();
   global Set<String> monthSet = new Set<String>();
   global Database.QueryLocator start(Database.BatchableContext info){
   String instanceDay= MB_Info_ReportingGA__c.getinstance('Day').Text_Value__c;
   Integer days=integer.valueof(instanceDay);
       datetime dt = System.now()-days;
       System.debug('Date:==>'+ dt);
       
       //String query = 'SELECT Billing_Month__c,Service_Name__c, User_Country__c FROM MB_Billing_Entity__c WHERE CreatedDate > :dt';
       String query = 'SELECT Billing_Month__c,Service_Name__c, User_Country__c FROM MB_Billing_Entity__c WHERE LastModifiedDate > :dt';
     
       System.debug('Query getting executed'+query); 
       
       return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<MB_Billing_Entity__c> scope){
        List<MobileBillingInsights__c> lst = [Select id, Month__c, Country__c From MobileBillingInsights__c where Month__c!='' and Country__c!=''  ];
        for (MobileBillingInsights__c ur : lst)  {
            if(ur.Month__c != null && ur.Country__c != null){
                 concatString = ur.Month__c.trim()+'__'+ ur.Country__c.trim();
                 if(!countryMonthBillingInsightList.contains(concatString.toUppercase())){
                    system.debug('Upper Case 1 ConString===>'+concatString );
                    
                    countryMonthBillingInsightList.add(concatString.toUppercase());
                 }
            }
        }
        
        for (MB_Billing_Entity__c so : scope)  {
            if(so.Billing_Month__c != null && so.User_Country__c != null){
                concatString = so.Billing_Month__c.trim()+'__'+ so.User_Country__c.trim();
                //concatString = 'September 2016' +'__'+ so.User_Country__c.trim();
                system.debug('ConString===>'+concatString);
                
                if(!countryMonthList.contains(concatString.toUppercase())){
                    system.debug('Upper Case 2 ConString===>'+concatString.toUppercase());
                    countryMonthList.add(concatString.toUppercase());
                    system.debug('Upper Case 2 ConString -----2nd uppercase===>'+concatString.toUppercase());
                    
                    if(!countryMonthBillingInsightList.contains(concatString.toUppercase())){
                        system.debug('Upper Case 2 ConString -----2 Inner nd uppercase===>'+concatString.toUppercase());
                        MobileBillingInsights__c insiterecord = new MobileBillingInsights__c(Month__c=so.Billing_Month__c.trim(),Country__c=so.User_Country__c.trim(),TotalDevices__c=0,TotalUsers__c=0);
                        uniqueList.add(insiterecord);
                        countryMonthBillingInsightList.add(concatString.toUppercase());
                    }
                    monthSet.add(so.Billing_Month__c.trim());
                    countrySet.add(so.User_Country__c.trim());
                }
            }
        }
        
        Database.upsertResult[] srList = Database.upsert(uniqueList, false);
        
    }
    global void finish(Database.BatchableContext BC){
        //Database.upsertResult[] srList = Database.upsert(uniqueList, false);
        /*for (Database.upsertResult sr : srList) {
            if (sr.isSuccess()) {
                uniqueIdList.add(sr.getId());
            }
        }*/
        
        system.debug('Month List==>'+ monthSet);
        system.debug('country List==>'+ countrySet);
        
        List<String> countryList = new List<String>();
        List<String> monthList = new List<String>();
    
        countryList.addAll(countrySet);
        monthList.addAll(monthSet);        
        
        MB_MobileBillingBatch objMb = new MB_MobileBillingBatch(monthList,countryList);
        //MobileBillingBatch objMb = new MobileBillingBatch(monthList,countryList);
        database.executebatch(objMb,30000);
    }   
}