/**********************************************************************
 Name:  CEC_Test_FulfilmentQualityCheckHelper
 Copyright © 2014  Unilever
 ======================================================================
=======================================================================
Purpose: This is the test class for the Helper class for CEC_FulfilmentQualityCheckHelper                                                                                                                     
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE            DETAIL               Description
   1.0 - Esther            21/10/2014      INITIAL DEVELOPMENT  CSR
 
***********************************************************************/

/**
Test class for the Helper class for Trigger for CEC_FulfilmentTrigger
*/

@isTest(SeeAllData=false)
public class CEC_Test_FulfilmentQualityCheckHelper  {

    /**
    Test method for beforeInsert() method
    */
    public static testMethod void test_beforeInsert(){
    
         Test.startTest(); 
         List<cec_Fulfilment__c>  Listff = new List<cec_Fulfilment__c> ();
    List<cec_Fulfilment__c>  Listff1 = new List<cec_Fulfilment__c> ();         
        
         Account accountObj = new Account();
         accountObj.RecordTypeId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
         accountObj.PersonMailingCity = 'Mumbai';
         accountObj.LastName = 'TestAccount';        
        
         insert accountObj;
         System.assertEquals( accountObj.LastName,'TestAccount');         

         
         
         Case caseObj = new Case();
         caseObj .Status = 'New';
         caseObj .Origin = 'Email';
         caseObj.AccountID=  accountObj.id;
         insert caseObj;
         System.assertEquals( caseObj.Origin,'Email');           
         
         System.debug('~~~~caseObj '+ caseObj);     
         System.debug('~~~~caseObj Account'+ caseObj.Account);      
           
         cec_Fulfilment__c fulfilmentObj = new cec_Fulfilment__c();
         
        // fulfilmentObj.Name = 'Test';
         fulfilmentObj.Case__c = caseObj.id;  
         Listff.add(fulfilmentObj);   
         insert Listff;
         System.debug('~~~~fulfilmentObj'+ fulfilmentObj);  
         
         System.assertEquals(Listff.size(),1);

         
         User loggedinuser = [select Quality_Check_Percentage__c, FirstName from User where id = :UserInfo.getUserId()];
         
         System.debug(''+loggedinuser.Quality_Check_Percentage__c+' '+loggedinuser.FirstName);
         
//         Double randomnumber = Math.random()*100;
Double randomnumber = 0.00;
  Double QualityPercent  = 1.00;
         System.debug('~~~~randomnumber ' + randomnumber ); 
         
         CEC_FulfilmentQualityCheckHelper qualityCheckHelper = new CEC_FulfilmentQualityCheckHelper();
         qualityCheckHelper.qualityCheck(Listff);
    
        // Listff = null;
        String.valueOf(randomnumber );
         cec_Fulfilment__c fulfilmentObj1 = new cec_Fulfilment__c();
         
                //fulfilmentObj1.Name = 'Test1';
         fulfilmentObj1.Case__c = caseObj.id;  
         Listff1.add(fulfilmentObj1);   
         insert Listff1;
         
         qualityCheckHelper.qualityCheck(Listff1);
         /**/
        
       }
        
        
        
}