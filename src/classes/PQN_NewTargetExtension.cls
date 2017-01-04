public with sharing class PQN_NewTargetExtension{
     Public PQN_Targets__c targets {get;set;}
//    public Integer targetDate {get;set;}
    public List<SelectOption> yearOptions{get;set;}
    Id targetId;
        
    Public PQN_NewTargetExtension(ApexPages.StandardController controller){
        system.debug('*********');
        targets = new PQN_Targets__c();
        targetId = Apexpages.currentpage().getparameters().get('id');
        if(targetId!=null){
           targets = [select id,Region__c,Target_Reduction__c,Notes__c, Year__c
                    from PQN_Targets__c where id=: targetId];    
        }
        
        yearOptions=Years();
    }
    
    
    public List<SelectOption> Years() {
        Integer year= System.Today().year();
        List<SelectOption> options = new List<SelectOption>();
        for(Integer i=0; i<=5; i++){
            options.add(new SelectOption(String.valueOf(year),String.valueOf(year)));
            year++;
            
        }
        return options;
    }
    
    Public PageReference saveTarget(){
        try{
            if(targets!=null){
            upsert targets;
            if(targetId==null)
            {
            List<PQN_Targets__c> listtar=new List<PQN_Targets__c>();
            listtar.add(targets);
            PQN_updateTAR.update_TAR(listtar);
            }
 
            PageReference targetDetailPage = page.PQN_Target_Detail_VF;
            targetDetailPage.setRedirect(true);
            targetDetailPage.getParameters().put('id',targets.id);
            return targetDetailPage;
            
            }
        }catch (Exception e){
             ApexPages.Message Msg = new ApexPages.Message(ApexPages.Severity.INFO,e.getmessage());
            ApexPages.addMessage(Msg);
            system.debug('an exception has been thrown');
        }
        return null;
    }
    
    public pagereference cancelTarget(){       
          if(targets.id==null){
            PageReference pqnhomePage = page.PQN_home;
            pqnhomePage.setRedirect(true);        
            return pqnhomePage;
        } 
        else{
            PageReference recordPage = page.PQN_Target_Detail_VF;
            recordPage.setRedirect(true);   
            recordPage.getParameters().put('id',targets.id);     
            return recordPage;
        } 
        
        return null;
      } 
  

}