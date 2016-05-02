public  class uw_uploadBCImage {
        
    public Document picture {get;set;}
 
    private uw_Brand__c brand = null;
    
    public string bannerloaded {get;set;}
    
    String CurrentID;
         
    public uw_uploadBCImage (ApexPages.StandardController controller) { 
        CurrentID = System.currentPageReference().getParameters().get('id');
        picture = new Document(); 
    
 
         brand = [Select  Banner_Location__c, Name,Description__c, Logo_Location__c,id From uw_Brand__c where Id = : CurrentID];
   		bannerloaded = [select Banner_Location__c from uw_Brand__c where Id = : CurrentID].Banner_Location__c;
    }
    
    public void clearbanner()
    {
    	
    	brand = [Select  Banner_Location__c, Name,Description__c, Logo_Location__c,id From uw_Brand__c where Id = : CurrentID];
    	
    	brand.Banner_Location__c = '';
    	update brand;
    	  
    	bannerloaded = '';
    	
    }
    
    
    
    public uw_Brand__c getBrand()                {
          return brand;
    }
    
    public void setBrand(uw_Brand__c b)                {
          brand = b;
          update brand;
    }
     
    public PageReference editbrand() {    
        return new PageReference('/apex/BrandLayoutEdit?id=' + ApexPages.currentPage().getParameters().get('id') );
    }
      
      
    public pageReference Attachbanner(){
        
 
        Folder currentfolder = [select Id,name from Folder where Name = 'Branding'];        
        
        picture.folderId = currentfolder.ID;  
        picture.AuthorId=UserInfo.getUserId();

         if (null != picture)        {
                 if (picture.name != null && picture.body != null)                {
                        //uw_Brand__c currentBrand = [select id, Banner_Location__c from uw_Brand__c where Id = :getBrand().id];
						uw_Brand__c currentBrand = brand;                		               
             
                        if (uw_HelperMethods.valueIsNull( currentBrand.Banner_Location__c)) {      
								        insert picture;   //create a new document for the bet.
                                        currentBrand.Banner_Location__c = picture.Id;                          
                 						setBrand(currentBrand);
                 						update currentbrand;
                 						picture=null; 
                        }  else 	{                                                             
                                        Document currentPic= [select name,body,description ,folderid
                                        						From document 
                                        						Where Id = :currentBrand.Banner_Location__c    ];
                                        if (picture.folderId  != currentPic.folderid) {		//picture is not from brandding follder
                                        	insert picture;    
                                        	currentBrand.Banner_Location__c = picture.Id;                          
                 							setBrand(currentBrand);                 						
                 							update currentbrand;
                 							picture=null; 
                                        }                                        	
                                        else 	{
                                        	currentPic.name=picture.name;
                                        	currentPic.body=picture.body ;
                                        
                                        	update currentPic;
                                        	picture=null;
                                        	
                                        }	
                                        
                        }// end (uw_HelperMethods.valueIsNull( currentBrand.Banner_Location__c)) {                                        
                 }  // if (picture.name != null && picture.body != null)        
        }       // if (null != picture) 
        bannerloaded = [select Banner_Location__c from uw_Brand__c where Id = : CurrentID].Banner_Location__c;
        PageReference origPage = new PageReference('/apex/BrandLayoutEdit?id=' + ApexPages.currentPage().getParameters().get('id') );
        return origPage;
       
    }
      
       
}