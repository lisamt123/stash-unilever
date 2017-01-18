/*Secondar Batch which gets called by Main Batch for Mobile Billing*/
global with sharing class MB_MobileBillingBatch implements Database.Batchable<Sobject>,Database.Stateful {
  
   global final string month;
   global final string  country;
   global Integer serviceCon=0;
   global Integer userCon=0;
   global set<String> countService = new set<String>();
   global set<String> userIdSet = new set<String>();
   global List<String> monthList = new List<String>();
   global List<String> countryList = new List<String>();
//   global Map<String,Integer> mapCountryList = new Map<String,Integer>();
   global Map<String,Set<String>> mapCountryList = new Map<String,Set<String>>();
   global Map<String,Set<String>> mapUserList = new Map<String,Set<String>>();   
        
    global MB_MobileBillingBatch (List<String> m, List<String> c)
    {
       monthList = m;
       countryList = c;
    }
    
    /*global MobileBillingBatch(String m,String c)
    {
        month= m;
       
        country=c;
      
    }*/
    global Database.QueryLocator start(Database.BatchableContext info){
        String query = 'SELECT Service_Name__c, User__c, Usage_Type__r.Name, Billing_Month__c, User_Country__c FROM MB_Billing_Entity__c WHERE User_Country__c in :countryList AND Billing_Month__c in :monthList';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,List<MB_Billing_Entity__c> scope){
        system.debug('Scope Billing Insight ===>'+ scope);
       
        for (MB_Billing_Entity__c so : scope)  {
         //   integer countryUserCount = 1;
            if(so.Usage_Type__r.Name != 'iPass'){
                if(mapCountryList.containsKey(so.Billing_Month__c+'__'+so.User_Country__c)){
                    //Integer icount = mapCountryList.get(so.Billing_Month__c+'__'+so.User_Country__c);
                    Set<String> setServiceName = new Set<String>();
                    setServiceName = mapCountryList.get(so.Billing_Month__c+'__'+so.User_Country__c);
                    setServiceName.add(so.Service_Name__c);
                    system.debug('icount -----'+setServiceName);
                    mapCountryList.put(so.Billing_Month__c+'__'+so.User_Country__c,setServiceName);
                }
                else{
                    if(so.Service_Name__c != null){
                    Set<String> setServiceName = new Set<String>();
                    setServiceName.add(so.Service_Name__c); 
                  // mapCountryList.put(so.Billing_Month__c+'__'+so.User_Country__c,countryUserCount);
                   mapCountryList.put(so.Billing_Month__c+'__'+so.User_Country__c,setServiceName);
                   }
                }
            }
            
            if(mapUserList.containsKey(so.Billing_Month__c+'__'+so.User_Country__c)){
                Set<String> setUserName = new Set<String>();
                setUserName= mapUserList.get(so.Billing_Month__c+'__'+so.User_Country__c);
                setUserName.add(so.User__c);
                mapUserList.put(so.Billing_Month__c+'__'+so.User_Country__c,setUserName);
            }else{
                Set<String> setUserName = new Set<String>();
                setUserName.add(so.User__c); 
                mapUserList.put(so.Billing_Month__c+'__'+so.User_Country__c,setUserName);
            }
            
            //userIdSet.add(so.User__c); 
        }
        
        system.debug('Service List ===>'+ mapCountryList);
       // Integer UserCount = userIdSet.Size();
        //userCon = userIdSet.size();
        
        List<MobileBillingInsights__c> serviceUserCountList=[select Id, Month__c, Country__c,TotalDevices__c,TotalUsers__c from MobileBillingInsights__c where Month__c in : monthList AND Country__c in : countryList ];
        system.debug('Billing Insight ===>'+ serviceUserCountList);
        
        if(serviceUserCountList.size() > 0){
            for(MobileBillingInsights__c  obj : serviceUserCountList){
                system.debug('Outer Billing Insight ===>'+obj.Month__c+'__'+obj.Country__c);
                if(mapCountryList.containsKey(obj.Month__c+'__'+obj.Country__c)){
                    system.debug('Before Billing Insight ===>'+obj.Month__c+'__'+obj.Country__c);
                    Set<String> uniqueServiceSet = mapCountryList.get(obj.Month__c+'__'+obj.Country__c);
                    //obj.TotalDevices__c=mapCountryList.get(obj.Month__c+'__'+obj.Country__c).size();
                    obj.TotalDevices__c=uniqueServiceSet.size();
                    system.debug('After Billing Insight ===>'+  obj.TotalDevices__c);
                    
                    Set<String> uniqueUserSet = mapUserList.get(obj.Month__c+'__'+obj.Country__c);
                    obj.TotalUsers__c=uniqueUserSet.size();
                }
            } 
        }   
        update serviceUserCountList;
    }
    global void finish(Database.BatchableContext BC){
    //No Finish Job required
       
    }    
}