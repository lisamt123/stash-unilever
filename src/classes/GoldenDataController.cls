public class GoldenDataController {
    public VPM_PurchasingRequests__c pr{get;set;}
    public Boolean isRequired;
    public  string VPM_AdvancedFormSubmitted {get;set;}
    public string inputCountry{get;set;}
	ApexPages.StandardController newController;
    
    public GoldenDataController(ApexPages.StandardController controller) {
       this.pr= (VPM_PurchasingRequests__c)Controller.getRecord(); 
       
        System.debug('Alsana ---' +pr);
       inputCountry = pr.VPM_Country__c;
       this.newController = controller;
    }

  public boolean getBrazil() {
  
      IF(string.isNotBlank(inputCountry) && inputCountry == 'Brazil')
      {
        return true;
      }
      else 
    return false;
    }
    
    public pageReference saveMethod() {
        pageReference newPage = null; 
      if(newController.save() != null) {
        System.debug('Alsanaa 2 ----' + newController);
        PageReference congratsPage = Page.VPM_GoldenData2;    
        congratsPage.setRedirect(true);    
        congratsPage.getParameters().put('id',newController.getId());    
        newPage =  congratsPage;  
      }
        return newPage;
    }
    /*
     public pageReference saveMethod2() {
        pageReference newPage = null;
          pr.VPM_AdvancedBusinessRequestorSubmitted__c='Yes';
      if(newController.save() != null) {
          
      }
        return newPage;
    }
   */
    
}