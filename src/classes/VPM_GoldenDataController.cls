public class VPM_GoldenDataController {

    public VPM_PurchasingRequests__c pr{get;set;}
    VPM_PurchasingRequests__c  vendorQuery{get;set;}
    public Boolean isRequiredField{get;set;}
    
    public Boolean hideWarning{get;set;}
    public string inputCountry{get;set;}
    //public string street1{get;set;}
    public Id purid{get;set;}
    
    public string pageName{get;set;}
    public string userlang{get;set;}   
    public static final string VENDOR_COUNTRY = 'BR_Brazil';
    
    
    ApexPages.StandardController newController;
    
    public VPM_GoldenDataController(ApexPages.StandardController controller) {
       this.pr= (VPM_PurchasingRequests__c)Controller.getRecord(); 
      //system.debug('@@'+pr.VPM_ECC__c);
       
       inputCountry = pr.VPM_Country__c;
       this.newController = controller;
       purid = pr.id;  
       hideWarning=true; 
       pageName = '';
       userlang = [select LanguageLocaleKey from User where Id=:UserInfo.getUserId()].LanguageLocaleKey;
                system.debug('@@userlang=' +userlang);
       try{
           vendorQuery = [select Id,VPM_City__c,VPM_VendorType__c,VPM_Location__c,VPM_Street1__c,VPM_Country__c, VPM_CompanyCode__r.ecc__c,VPM_AdvancedFormSubmitted__c, VPM_FinanceApprovalRequired__c,
           VPM_Regions__c,VPM_ProcurementApprovalRequired__c,VPM_OrderingEmailAddress__c from VPM_PurchasingRequests__c where id = : purid];
           //street1 = vendorQuery.VPM_Street1__c==null ? '':vendorQuery.VPM_Street1__c;
           userlang = [select LanguageLocaleKey from User where Id=:UserInfo.getUserId()].LanguageLocaleKey;
           system.debug('@@userlang=' +userlang);
           system.debug('@@@After Input Country ' +  pr.VPM_Country__c);
           IF(pr.VPM_Country__c == VENDOR_COUNTRY)
           {
               isRequiredField = true;
           }
           else {
               isRequiredField = false;             
           }           
       }
       catch(Exception ex){
       
       }
    }
        
    public pageReference saveMethod() {
        Pagereference pg;
        newController.save();
        system.debug('@@pageName' + pageName);
        
        pg =  new Pagereference('/apex/VPM_GoldenData2?id='+pr.id); 
        pg.setRedirect(true);
       return pg;      
    }
    

    public pageReference newMethod() {
        
        system.debug('@@inputCountry' + pr.VPM_Country__c) ;
        hideWarning = false;
        IF( pr.VPM_Country__c == VENDOR_COUNTRY)
        {
            isRequiredField = true;
            system.debug('@@isRequiredField ' + isRequiredField) ;
        }else {
            isRequiredField = false;
        }        
        return null;    
    }
       
    
    public pagereference backToFlow()
    {
    string queryString = '&back=true';    
    Pagereference pg =  new Pagereference('/apex/VPM_AdvancedForm_v1?id=' + purid + queryString); 
    pg.setRedirect(true);
    return pg;
    }
}