/**
 * Test_AF_BrandEstimateStdCtrlExt: This Test class for AF_BrandEstimateStdCtrlExt apex class 
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_BrandEstimateStdCtrlExt
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void brandEstimateStdCtrl ()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'test1234', Email='standarduser44@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test User123', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testuser44@test123321.com',AF_Brand__c='Test Brand',AF_Category__c='Test Beverages');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc1=new Account();
     acc1.Name='Test Agency';
     acc1.published__c=true;
     insert acc1;
     
     System.Assert(acc1.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverages';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brand';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     AF_OOPS_Settings__c custRecord = new AF_OOPS_Settings__c();
     custRecord.Overall_Percentage__c = 5;
     insert custRecord;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brand1=new AF_Brand_Estimate__c();
     brand1.AF_Agency__c=acc1.Id;               
     brand1.Name='Test Brand';
     brand1.AF_Status_Base_Fees__c='Initiate';  
     brand1.Brand__c=bran.id;
     insert brand1;
     
     System.assertEquals(brand1.Brand__c, bran.id);
     
     AF_Currency__c curr = new AF_Currency__c();
     curr.AF_Country__c = 'Ecuador';
     curr.AF_Currency_Code__c = 'USD';
     curr.Country_Currency__c = 'Eucador-USD';
     curr.AF_Fiscal_Year_new__c = currYear ;
     curr.Currency_Unit__c = 'US $';
     curr.AF_Fiscal_Year__c = system.today();
     curr.AF_Average_Exchange_Rate_To_EUR__c = 1.3253;
     curr.Ready_For_PO_Exchange_Rate_SGD_To_USD__c=1.0000;
     curr.Ready_For_PO_Exchange_Rate_To_EUR__c = 1.6112;
     insert curr;
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Test Entity';        
     entity1.AF_Country__c='Australia';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Test Unilever Entity';        
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
   /*  AF_Matrix_Table__c  MatrixRecords1=new AF_Matrix_Table__c();        
     MatrixRecords1.AF_Unilver_Country__c='Algeria';        
     MatrixRecords1.AF_Agency_Country__c='Algeria';        
     MatrixRecords1.AF_Matrix_Country__c='India';        
     MatrixRecords1.AF_Matrix_Currency_Code__c='INR';        
     MatrixRecords1.AF_Ready_For_PO_Country__c='India';        
     MatrixRecords1.AF_Ready_For_PO_Country_Currency__c='INR';        
     Insert MatrixRecords1;    
     
     
     AF_Currency__c currncy11=new AF_Currency__c();        
     currncy11.AF_Country__c='India';        
     currncy11.AF_Currency_Code__c='INR';        
     currncy11.Locked__c=false;        
     currncy11.AF_Fiscal_Year_new__c=String.valueOf(System.now().year()-1);        
     currncy11.AF_Average_Exchange_Rate_To_EUR__c=27.12;        
     insert currncy11;*/
     
     //Insert Agency Estimate          
     AF_Agency_Estimate__c agency1=new AF_Agency_Estimate__c();
     agency1.AF_Brand_Estimate__c=brand1.Id;
     agency1.AF_Agency_Entity__c=entity1.id;
     agency1.AF_Unilever_Entity__c=entity2.Id;  
     insert agency1;
     
     System.assertEquals(agency1.AF_Agency_Entity__c, entity1.id);
     
     ApexPages.StandardController sc = new ApexPages.StandardController(brand1);
     ApexPages.currentPage().getParameters().put('id',brand1.id);
     
     //Create Instance of the Class         
     AF_BrandEstimateStdCtrlExt bes=new AF_BrandEstimateStdCtrlExt(sc);   
     bes.SetStatus();  
     
     Test.stopTest(); 
     
    }
  } 
}