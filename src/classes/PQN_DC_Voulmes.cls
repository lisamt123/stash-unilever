public with sharing class PQN_DC_Voulmes{
    public PQN_DC_Volumes__c dcv{get; set;}
     public List<SelectOption> yearOptions{get;set;}
    id dcvid;
    public PQN_DC_Voulmes(ApexPages.StandardController controller){
        dcv = new PQN_DC_Volumes__c ();
        dcvid = Apexpages.currentpage().getparameters().get('id');
        if(dcvid!=null){
            dcv=[select Total_Pallets_Checked_By_DC__c,Total_Pallets_received_by_DC__c,Reporting_DC__c,year__c,month__c from PQN_DC_Volumes__c where id=:dcvid];
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
     public pagereference saveDCV(){
         try{
         if(dcv!=null){
             upsert dcv;
         }
         if(dcv.id!=null){
             PageReference pqnhomePage = page.PQN_DC_Volumes_detail_VF;
             pqnhomePage.getParameters().put('id',dcv.id);
             pqnhomePage.setRedirect(true);                     
             return pqnhomePage; 
         }
         }         
         catch(exception e){
         }
         return null;
     }
      public pagereference cancelDCV(){       
          if(dcv.id==null){
            PageReference pqnhomePage = page.PQN_home;
            pqnhomePage.setRedirect(true);        
            return pqnhomePage;
        } 
        else{
            PageReference recordPage = page.PQN_DC_Volumes_detail_VF;
            recordPage.setRedirect(true);   
            recordPage.getParameters().put('id',dcv.id);     
            return recordPage;
        } 
        
        return null;
      } 
             
        
        
    }