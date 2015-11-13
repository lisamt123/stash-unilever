trigger AF_UserUpdateCatFinanceApprover  on User (before Insert,after Update){  
                 /*update*/
    String brands='';
    List<String> userList = new List<String>();
    List<String> brandList = new List<String>();
    List<String> userBrands = new List<String>();
    Map<Id,List<String>> userBrandsMap = new Map<Id,List<String>>();
    set<String> brandSet = new set<String>();
    Set<Id> brandEstIdcatfin = new Set<Id>();
    List<AF_Brand_Estimate__c> brandEstWithAgencyList = new List<AF_Brand_Estimate__c>();
    List<AF_Brand_Estimate__c> brandEstList = new  List<AF_Brand_Estimate__c>();
    Public list<ProcessInstanceWorkitem> workItem=new list<ProcessInstanceWorkitem>();
    Set<String> workItemId = new Set<String>(); 
    for(User userRecord:Trigger.new){ 
        if(Trigger.isUpdate){
        if(userRecord.AF_Agency_Fees_User_Type__c == 'Category Finance'||Trigger.oldMap.get(userRecord.Id).AF_Agency_Fees_User_Type__c == 'Category Finance'){
            if((userRecord.IsActive||!userRecord.IsActive) && (userRecord.AF_Brand__c!=null || Trigger.oldMap.get(userRecord.Id).AF_Brand__c !=null) &&
              (userRecord.AF_Agency_Fees_User_Type__c!=Trigger.oldMap.get(userRecord.Id).AF_Agency_Fees_User_Type__c
            || userRecord.AF_Brand__c!=Trigger.oldMap.get(userRecord.Id).AF_Brand__c)){
                if(userRecord.AF_Brand__c!=null){
                brands = userRecord.AF_Brand__c;
                system.debug('brands...'+brands);
                userList = brands.split(';');
                }
                brandList.addall(userList);
                system.debug('userList...1...'+userList);
                if(Trigger.oldMap.get(userRecord.Id).AF_Brand__c!=null){
                brands = Trigger.oldMap.get(userRecord.Id).AF_Brand__c;
                }
                userList = brands.split(';');
                brandList.addall(userList);
                brandSet.addAll(brandList);
                userBrandsMap.put(userRecord.Id,userList);
                system.debug('userList....'+userList);
            }
        }
        }
        if(Trigger.isInsert){
            if(userRecord.AF_Agency_Fees_User_Type__c == 'Category Finance'){
            if(userRecord.IsActive && userRecord.AF_Brand__c!=null){
              
                brands = userRecord.AF_Brand__c;
                userList = brands.split(';');
                //brands = Trigger.oldMap.get(userRecord.Id).AF_Brand__c;
                userList = brands.split(';');
                brandSet.addAll(userList);
                userBrandsMap.put(userRecord.Id,userList);
            }
        }
        }
        
    }
    system.debug('brandSet....'+brandSet);
    if(brandSet.size()>0){
    AF_brandEstimatehandlerHelper.brandEstimatehandlerMethod(brandSet);
    AF_brandEstimatehandlerHelper.oopsActualhandlerMethod(brandSet);
    }
    
    }