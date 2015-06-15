/**
 * Test_AF_usersearch: This Test class for af_usersearch apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_usersearch{

 static testMethod void af_usersearch() {

  
  
    
             Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'test123', Email='standarduser@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='af test', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,firstname='sf test one', 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuser@test123321.com',AF_Brand__c='Test Brand1',AF_Category__c='Test Beverages1');
     insert u;  
    test.starttest(); 
     af_usersearch  aff=new af_usersearch();
     aff.firstName=u.firstname;
   aff.lastname=u.lastname;
   aff.email=u.email;
   aff.name=u.name;


    
    aff.sortField='Email';
    aff.sortDir='desc';
    //aff.af_usersearch();
    //aff.debugSoql();
    aff.toggleSort();
    aff.runSearch();
    test.stoptest();
  }

  
  
   static testmethod void af_usersearch1(){
  
  
    
             Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'test123', Email='standarduser@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='af test', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,firstname='sf test one', 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuser@test123321.com',AF_Brand__c='Test Brand1',AF_Category__c='Test Beverages1');
     insert u; 
   
 
    test.starttest();
   af_usersearch  aff=new af_usersearch();
   aff.firstName=u.firstname;
   aff.lastname=u.lastname;
   aff.email=u.email;
   aff.name=u.name;   
   aff.toggleSort();
   aff.runSearch();
   test.stoptest();
  }


}