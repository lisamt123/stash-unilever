public class BFM_POD_DateAdjustment_CC{

  //  public BFM_POD_DateAdjustment_CC() {

  //  }

    List<BFM_POD__c> listPOD = new List<BFM_POD__c>();
    public List<podWrapper> listPODW{get; set;}
    public BFM_POD_DateAdjustment_CC(ApexPages.StandardSetController controller) {
       
    }

    
    
    public BFM_POD_DateAdjustment_CC(){
        listPODW = new List<podWrapper>();
        listPOD = [select id,POD_Date__c,POD_Number__c,Upload_date__c,NF_E__r.NF_e_creation_date__c,NF_E__r.NFS__c,NF_e_Access_Key__c,NF_E__r.CT_E__c,NF_E__r.CT_E__r.CTE_Status__c,NF_E__r.NFS__r.NFS_Status__c from BFM_POD__c where POD_Date_Check_Status__c ='Date Not Ok' limit 100];
        for(BFM_POD__c pod: listPOD){
            //if((pod.NF_E__r.NFS__r.NFS_Status__c !='Invoice Posted') ){
                podWrapper p = new podWrapper(pod);     
                listPODW.add(p); 
           // }
        }
        system.debug('wwwwwwwwwww'+listPODW);
    }
    
    public class podWrapper{
        public BFM_POD__c pod{get; set;}
        public string oldpodDate{get; set;}
        
        public string nfeDate{get; set;}
        public podWrapper(BFM_POD__c p){
            if(p.NF_E__r.NF_e_creation_date__c!=null){
                nfeDate = p.NF_E__r.NF_e_creation_date__c.date().format();
            }
            if(p.POD_Date__c!=null){
                oldpodDate = p.POD_Date__c.format();
            }
            p.POD_Date__c =null;
            pod = p;
        }
    }
    
    public pagereference podUpdate(){
        List<BFM_POD__c> listpodupdate = new List<BFM_POD__c>();
        for(podWrapper pw: listPODW){
            if(pw.pod.POD_Date__c!=null){
                BFM_POD__c bp = new BFM_POD__c(id=pw.pod.id);   
                bp.POD_Date__c = pw.pod.POD_Date__c;
                listpodupdate.add(bp);
            }
        }
        if(!listpodupdate.isEmpty()){
            update listpodupdate;
            
        }
        PageReference redirectPage = Page.BFM_POD_DateAdjustment_VF;
        redirectPage.setRedirect(true);
    //redirectPage.getParameters().put('id',controller.getId());
    return redirectPage;
      //  return page.BFM_POD_DateAdjustment_VF;
    
    }
    public void back(){
    
    }


}