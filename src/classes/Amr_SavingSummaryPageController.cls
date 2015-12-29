public with sharing class Amr_SavingSummaryPageController {
    public Amr_Saving__c saving {get;set;}
    
    public Amr_SavingSummaryPageController() {
       saving  = new Amr_Saving__c();
      // saving  = [Select Production_Type__c,No_of_Masters__c,Duration_of_Masters__c,Total_no_of_films__c,No_of_shoot_days__c,No_of_Additional_Films__c,Duration_of_Additional_Films__c,Shoot_Location__c,Stage_RAP_engaged__c from Amr_Saving__c limit 1];
    }


    public Boolean displayPopup {get;set;}

    public Amr_SavingSummaryPageController(ApexPages.StandardController controller) {

    }
    
    public void showPopup()
    {
        
    displayPopup = true;

    
    }
    
    public void closePopup() {
        displayPopup = false;
        
    }
    
    public PageReference redirectPopup()
    {
    displayPopup = false;
        
       PageReference p=new Pagereference('/apex/AM_SavingSummaryPage');
       p.setRedirect(true);
       return p;
        
    }
    


}