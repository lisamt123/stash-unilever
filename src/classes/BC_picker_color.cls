/* -----------------------------------------------------------------------------------------------------------------------
   Name:        BC_picker_color.cls 
   Description: 1) Class which handles the logic to manage the colour picker from Brand centre record.
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   November 2013     1.0    Vanessa Barros        Initial Release 
  ------------------------------------------------------------------------------------------------------------------------ */


public with sharing class BC_picker_color {
   
    public string new_colour {get;set;}
    public Id bc_id;
    
    public BC_picker_color(ApexPages.StandardController controller) {
        bc_id = ApexPages.currentPage().getParameters().get('id');
        
        
        Brand_centre_new__c c = [select background_colour__c from brand_centre_new__c where id =:bc_id];
        new_colour = c.background_colour__c;    
    }
    
    //Reset Button to take the colour from the Brand Centre background 
    public PageReference reset(){
        Brand_centre_new__c c = [select background_colour__c from brand_centre_new__c where id =:bc_id];
        c.background_colour__c = 'FFFFFF';
        update c;
        new_colour = c.background_colour__c;
        
        PageReference p = new pageReference('/apex/BC_picker_color_result?new_colour='+new_colour);
        return p;
        
       
    }
   
    //Save Button to save the colour picked from the user
    public PageReference save(){
        
        Brand_centre_new__c c = [select background_colour__c from brand_centre_new__c where id =:bc_id];
        c.background_colour__c = new_colour;
        update c;
        PageReference p = new pageReference('/apex/BC_picker_color_result?new_colour='+new_colour);
        return p;
          
       
    }
    //Edit button to redirect the user to the Background colour Edit page
    public PageReference edit(){
        PageReference p = new pageReference('/apex/BC_picker_color');
        return p;    
    }
    
    
    
    
    



}