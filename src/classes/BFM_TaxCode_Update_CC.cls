public class BFM_TaxCode_Update_CC{


    List<BFM_CT_e__c> listCTe = new List<BFM_CT_e__c>();
    public List<CTeWrapper> listCTeW{get; set;}
    public BFM_TaxCode_Update_CC(ApexPages.StandardSetController controller) {
       
    }   
    
    public BFM_TaxCode_Update_CC(){
        listCTeW = new List<CTeWrapper>();
        listCTe = [SELECT Id,DEFINITIVE__c,Tax_Status__c,Cte_Status__c,ICMS_Value__c,ICMS_Tax_Rate__c,(select Tax_Code__c from SESs__r) FROM BFM_CT_e__c where id=:ApexPages.currentPage().getParameters().get('id')];
        
        listCTe = [SELECT Id,CT_e_key__c,DEFINITIVE__c,Tax_Status__c,Cte_Status__c,ICMS_Value__c,
                   ICMS_Tax_Rate__c,
                   (select id, Tax_Code__c from SESs__r) FROM BFM_CT_e__c where id='a4P8A0000004JwH'];
        
        for(BFM_CT_e__c cte: listCte){
           
                CTeWrapper c = new CteWrapper(cte);     
                listCteW.add(c); 
        }
        system.debug('listCTeW--->'+listCTeW);
    }
    
    public class CTeWrapper{
        public BFM_CT_e__c cte{get; set;}
        public string CteStatus{get; set;}       
        public string taxCode{get; set;}
        public string taxlist{get; set;}
        public CTeWrapper(BFM_CT_e__c c){
            if(c.SESs__r[0].Tax_Code__c!=null){
                taxCode = c.SESs__r[0].Tax_Code__c;
            }
            if(c.Cte_Status__c!=null){
                CteStatus = c.Cte_Status__c;
            }
            c.Cte_Status__c =null;
            cte = c;
        }
    }
    
    public pagereference cteUpdate(){
        List<BFM_CT_e__c> listpodupdate = new List<BFM_CT_e__c>();
        for(CteWrapper pw: listCteW){
                BFM_CT_e__c bp = new BFM_CT_e__c(id=pw.cte.id);   
                //bp.SESs__r.Tax_Code__c = pw.cte.SESs__r.Tax_Code__c;
                listpodupdate.add(bp);
        }
        if(!listpodupdate.isEmpty()){
            update listpodupdate;
            
        }
        PageReference redirectPage = Page.BFM_TaxCode_Update_VF;
        redirectPage.setRedirect(true);
        //redirectPage.getParameters().put('id',controller.getId());
    return redirectPage;
      //  return page.BFM_POD_DateAdjustment_VF;
    
    }
    public void back(){
    
    }
}