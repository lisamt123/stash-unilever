public  class Redirect_Brand_Page {

public Redirect_Brand_Page(ApexPages.StandardController controller)
        {
        
        
        
        
                
         }
         
         
         public pagereference redirect()
         {
         	string profilename;
         	string brandcentreurl;
         	try{
         	profilename =[select name from Profile where id= :system.Userinfo.getProfileId()].name;
         	}
         	catch(exception e){}
         	try{
         	brandcentreurl = [select Brand_Centre_URL__c from uw_brand__c where id = :ApexPages.currentPage().getParameters().get('id')].Brand_Centre_URL__c;
         	}
         	catch(exception e){}
         	if(profilename == 'Unilever Way - Marketing - Brand and HUB Admin' || profilename == 'Unilever Way - Marketing - Brand Centre Admin' ||  profilename.contains('System Administrator'))
         	{
         		
         		
         		return new PageReference('/' + ApexPages.currentPage().getParameters().get('id')+'?nooverride=1');
         	}
         	
         	
         	
         	else 
         	
         	
         	 return new PageReference('/apex/' + brandcentreurl + '?id=' +ApexPages.currentPage().getParameters().get('id'));
         }
         


}