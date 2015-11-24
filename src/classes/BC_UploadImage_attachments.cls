/* -----------------------------------------------------------------------------------------------------------------------
   Name:        BC_UploadImage_attachments.cls 
   Description: 1) Class which handles the logic to upload an image to appear on the brand centre landing page
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   November 2013     1.0    Vanessa Barros        Initial Release 
  ------------------------------------------------------------------------------------------------------------------------ */
  

public with sharing class BC_UploadImage_attachments {
    public Attachment picture {get;set;}   
    public string article_id;
    public boolean checkImageRequired{get;set;}
    public Boolean refreshPage {get; set;}
    public string ErrorMessage {get;set;}
      
    public BC_UploadImage_attachments(ApexPages.StandardController controller) {
        article_id= System.currentPageReference().getParameters().get('id');
        picture = new Attachment();  
        
        brand_centre_content__c a = [select Header_Section__r.position__c, recordtype.name from brand_centre_content__c where id = :article_id];
        if(a.header_section__r.position__c == 'Latest News'){
            if(a.recordtype.name == 'Article'|| a.recordtype.name == 'Video Link' || a.recordtype.name == 'Non-Video Link'){
                checkImageRequired=true;    
            }else{
                checkImageRequired =false;
            }
        }else{
            checkImageRequired =false;
        }  
        refreshPage=false;
        ErrorMessage = '';
    }    
    
  
    public pageReference Attach(){
        if(picture.name <> null ){   
            if(picture.BodyLength > 5242880){  
                //maximum attachment size is 5MB.  Show an error
                
                ErrorMessage ='The file is too big - the maximum is 5MB';    
            }else{
                    try{
                
                    picture.parentId = article_id;
                    
                    insert picture;
                    
                    Brand_centre_content__c b = [select Preview_Image_ID__c from Brand_centre_content__c where Id = :article_id];
                    b.Preview_Image_ID__c = picture.Id;
                    
                    update b;
                    refreshPage=true;
                    picture.body = null;
                }catch(DmlException ex){
                    ApexPages.addMessages(ex);
                }
            }
        }else{
            ErrorMessage = 'You need to add an image before you click "save Preview Image" button';
        }
        return null;
    }
}