/* -----------------------------------------------------------------------------------------------------------------------
Name:        BC_brandContentHeader.cls 
Description: 1) Class which handles the logic to fill the brand Centre content in the Brand Centre page record
               
Date         Version       Author           Summary of Changes 
-----------  -------   -----------------    ------------------------------------------------------------------------
November 2013     1.0    Vanessa Barros        Initial Release 
------------------------------------------------------------------------------------------------------------------------ */

public with sharing class BC_brandContentHeader {
    
    public string id{get;set;}
    public PageReference page{get;set;}
    public string LastestNewsHeader;
    private final Brand_centre_new__c brand_centre;
    public boolean hasCommunity {get;set;}
    public boolean hasNews {get;set;}
    public boolean hasOnline {get;set;}
    public String msg{get;set;}
    
    public BC_brandContentHeader(ApexPages.StandardController controller) {
       id = ApexPages.currentPage().getParameters().get('Id');
       this.brand_centre = (Brand_centre_new__c)controller.getRecord();
    }
    
    
    public List<Brand_Centre_content__c> getBB(){
        List<Brand_Centre_content__c> bb = [select id,name, position__c, ordinal__c, display__c from brand_centre_content__c where brand_centre__c = :id and 
            header__c =true order by ordinal__c Asc];
        for(brand_centre_content__c b : bb){
            if(b.position__c == 'Latest News'){
                hasNews= true;
            }

            if(b.position__c == 'Online'){
                hasOnline = true;
            }
            if(b.position__c == 'Community'){
                hasCommunity = true;
            }
        }
        return bb;
    }
    
    public PageReference DeleteBrandCentreContent(){
        string bc_id = ApexPages.currentPage().getParameters().get('bc');
        string brand_centre = ApexPages.currentPage().getParameters().get('bcentre');
        boolean deletedBcc = false;
        List<brand_centre_content__c> haveContent = [select id from brand_centre_content__c where header_section__c = :bc_id];
        
        if(haveContent.size()>0){
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Before delete the header, you need to delete the content inside the header.');    
            msg='Before delete the header, you need to delete the content inside the header.';
        }else{
            
            try{
                List<brand_centre_content__c> bcc = [select id from brand_centre_content__c where header_section__c = :bc_id];
                delete bcc;
                deletedBcc =true;
            }catch(DmlException ex){
                ApexPages.addMessages(ex);
            }
            if(deletedBcc == true){
                try{
                    Brand_centre_content__c b =[select id from brand_centre_content__c where id=:bc_id];
                    delete b;
                    
                }catch(DmlException ex){
                    ApexPages.addMessages(ex);
                }
            }
        }
      
        return null;
   
    }
  
 
    
   
    


}