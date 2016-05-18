public class VPM_GoldenDataController {

    public VPM_PurchasingRequests__c pr{get;set;}
    public Boolean isRequiredField{get;set;}
    public string inputCountry{get;set;}
    public Id purid{get;set;}
    ApexPages.StandardController newController;
    
    public VPM_GoldenDataController(ApexPages.StandardController controller) {
       this.pr= (VPM_PurchasingRequests__c)Controller.getRecord(); 
       inputCountry = pr.VPM_Country__c;
       this.newController = controller;
       purid = pr.id;   
       system.debug('@@@After Input Country ' +  pr.VPM_Country__c);
       IF(pr.VPM_Country__c == 'Brazil')
      {
        isRequiredField = true;
        
        
      }
      else {
          isRequiredField = false;

      }
    }

  
    
    public pageReference saveMethod() {
        pageReference newPage = null;
        system.debug('@@@After Input Country ' +  inputCountry);
      if(newController.save() != null) {

        PageReference congratsPage = Page.VPM_GoldenData2;    
        congratsPage.setRedirect(true);    
        congratsPage.getParameters().put('id',newController.getId());    
        newPage =  congratsPage;  
      }
        return newPage;
    }
    

    public pageReference newMethod() {
        system.debug('@@inputCountry' + pr.VPM_Country__c) ;
        IF( pr.VPM_Country__c == 'Brazil')
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
    Pagereference pg =  new Pagereference('/apex/VPM_AdvancedForm?id=' + purid ); 
    pg.setRedirect(true);
    return pg;
    }
}