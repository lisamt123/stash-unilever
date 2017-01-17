@isTest
public class SAFE_SolutionArchivedTabBPSec_Test 
{
    public static SAFE_Solutions__c Archivedsolution = new SAFE_Solutions__c();
public static  ApexPages.StandardController sc = new ApexPages.StandardController(Archivedsolution); 
    public static   SAFE_SolutionArchivedTabBPSec_CC p=new SAFE_SolutionArchivedTabBPSec_CC(sc);
    public static testMethod void SolutionArchivedTabMethod() 
    {        
        SAFE_Solutions__c o = new SAFE_Solutions__c (Name='Test',SAFE_Solution_Status__c= 'Under Review',
                                                     SAFE_Solution_Category__c= 'Covert',SAFE_Material_Type__c='Flexible',
                                                     SAFE_Contact_Phone__c='0987654321',SAFE_Supplier_Phone__c='1234567890',
                                                     SAFE_Solution_in_Use__c = false,SAFE_Price_Per_Unit__c = 77.0);               
        
        insert o;
        Profile p1 = [select id,Name from Profile where Name='Standard Platform User']; 
        
        User opUser = new user(alias = 'test123', email='test123@noemail.com',emailencodingkey='UTF-8', firstName='Pawan', lastname='Testing', 
                               languagelocalekey='en_US',localesidkey='en_US', profileid = p1.Id, country='United States',
                               timezonesidkey='America/Los_Angeles', username='test01@noemail.com'); 
        
        insert opUser;            
        PageReference myPage = Page.SAFE_SolutionArchiveTabBPSec;
        myPage.getParameters().put('id', o.Id);  
        Test.setCurrentPage(myPage);    
        ApexPages.StandardController control = new ApexPages.Standardcontroller(o);
        SAFE_SolutionArchivedTabBPSec_CC pageControl = new SAFE_SolutionArchivedTabBPSec_CC(control);        
    }    
    
    
    public static testMethod void testPagination() 
    {        
        p.Firstbtn();
        p.prvbtn();
        p.Nxtbtn();
        p.lstbtn();
        p.getNxt();
        p.getPrv();
    }
}