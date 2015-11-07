Global class AF_brandEstimatehandlerHelper{
    global static boolean testvar=false;
    @future
  public static void brandEstimatehandlerMethod(Set<String> brandSet){
    
    Set<Id> brandEstIdcatfin = new Set<Id>();
    List<AF_Brand_Estimate__c> brandEstWithAgencyList = new List<AF_Brand_Estimate__c>();
    List<AF_Brand_Estimate__c> brandEstWithcatfinList = new List<AF_Brand_Estimate__c>();
    List<AF_Brand_Estimate__c> brandEstList = new  List<AF_Brand_Estimate__c>();
    List<AF_Brand_Estimate__c> brandEstupdateList = new  List<AF_Brand_Estimate__c>();
    List<AF_Brand_Estimate__c> brandEstimateList = new  List<AF_Brand_Estimate__c>();
    list<ProcessInstanceWorkitem> workItem=new list<ProcessInstanceWorkitem>();
    Set<String> workItemId = new Set<String>();
    testvar=true; 
    brandEstList = [select Id,Brand__r.Name,AF_Status_Base_Fees__c from AF_Brand_Estimate__c where Brand__r.Name IN:brandSet and AF_Active__c=true and AF_Status_Base_Fees__c!='Ready for PO'];
    for(AF_Brand_Estimate__c b:brandEstList){
        if(b.AF_Status_Base_Fees__c=='With Category Finance'){
            brandEstIdcatfin.add(b.Id);
            brandEstimateList.add(b);
                  
        }
        if(b.AF_Status_Base_Fees__c=='With Agency'){
            brandEstWithAgencyList.add(b);
        }
    }
    if(brandEstWithAgencyList.size()>0){
        update brandEstWithAgencyList;
    }
    
    system.debug('brandEstIdcatfin...'+brandEstIdcatfin);
    workItem  =[Select p.Id,P.ActorId,p.ProcessInstance.TargetObjectId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId IN:brandEstIdcatfin  limit 50000];
    Map<Id,Id> brandWorkitem = new Map<Id,Id>();
    if(workItem.size()>0){
    for(ProcessInstanceWorkitem  pis:workItem){
        if(pis.ActorId!=Label.AF_Dummy_User){
            brandWorkitem.put(pis.ProcessInstance.TargetObjectId,pis.Id);
        }
        //workItemId.add(pis.id);
    }
    }
    
    
    system.debug('brandWorkitem...'+brandWorkitem);
    for(ID wid : brandWorkitem.keySet()){
        
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Rejecting for change Approver'); //RejectComment
        req.setAction('Removed');                    
        req.setWorkitemId(brandWorkitem.get(wid));
        // Submit the request for approval
        Approval.ProcessResult result =  Approval.process(req);
        
    }
    for(AF_Brand_Estimate__c brandEst:brandEstimateList){
        brandEst.AF_Status_Base_Fees__c = 'With Agency';
        brandEstupdateList.add(brandEst);
    }
    if(brandEstupdateList.size()>0){
        update brandEstupdateList;
    }
    for(ID wid : brandWorkitem.keySet()){
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for Change Approver');
                    req1.setObjectId(wid);
                    Approval.ProcessResult result2 = Approval.process(req1);
    }
    
    }
    @future
    public static void oopsActualhandlerMethod(Set<String> brandSet){
        List<AF_OOPS_Actual__c> oopsActualList = new  List<AF_OOPS_Actual__c>();
        List<AF_OOPS_Actual__c> oopsActualWithcatList = new  List<AF_OOPS_Actual__c>();
        List<AF_OOPS_Actual__c> oopsWithAgencyList = new  List<AF_OOPS_Actual__c>();
        List<AF_OOPS_Actual__c> oopswithcatList = new  List<AF_OOPS_Actual__c>();
        List<AF_OOPS_Actual__c> oopsStatusUpdateList = new  List<AF_OOPS_Actual__c>();
        String year = String.valueof(System.Today().year());
        Set<Id> oopsId = new Set<Id>();
        oopsActualList = [select id,AF_Brand__r.Name,AF_Status__c from AF_OOPS_Actual__c where AF_Brand__r.Name IN:brandSet and AF_Status__c!='Ready For PO' and AF_Fiscal_year__c=:year];
        for(AF_OOPS_Actual__c oop:oopsActualList){
            if(oop.AF_Status__c=='With Category Finance'){
                oopsActualWithcatList.add(oop);
            }
            else if(oop.AF_Status__c=='With Agency'){
                oop.AF_Status__c = 'With Category Finance';
                oopsWithAgencyList.add(oop);
                oopsId.add(oop.Id);
            }
        }
        if(oopsActualWithcatList.size()>0){
            update oopsActualWithcatList;
        }
        if(oopsWithAgencyList.size()>0){
            update oopsWithAgencyList;
        }
        oopswithcatList = [select id,AF_Status__c from AF_OOPS_Actual__c where Id IN:oopsId];
        for(AF_OOPS_Actual__c oop:oopswithcatList){
            oop.AF_Status__c = 'With Agency';
            oopsStatusUpdateList.add(oop);
        }
        if(oopsStatusUpdateList.size()>0){
            update oopsStatusUpdateList;
        }
    }
  }