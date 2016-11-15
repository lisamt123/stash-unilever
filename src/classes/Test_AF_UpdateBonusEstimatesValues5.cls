/**
 * Test_AF_UpdateBonusEstimatesValues5 : This Test class for AF_UpdateBonusEstimatesValues5  apex class
 * @author 
 *
 */
 
 @isTest(SeeAlldata=false)
public class Test_AF_UpdateBonusEstimatesValues5 
{    
    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static Integer IcurrYear1 = System.Today().year();
    Static string currYear1=string.valueof(IcurrYear1); 
     Static testMethod void UpdateBonusEstimates()
    {
        Test.startTest();
        Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testo', Email='standarduserbec@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u;
      System.runAs(u)
     {
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyer';
     acc.published__c=true;
     insert acc;
     
     //inser Contact
     Contact con=new Contact();
     con.LastName='Test Cono';
     con.AccountId=acc.Id;
     con.email = 'standarduserbec@unilever.com';
     con.AF_Send_Email_Notification__c = true;
     insert Con;
     
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverageser';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brander';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateer';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Locked__c=false; 
     brandEst.AF_Pilot_Model__c=true;
     insert brandEst;
     
     AF_Currency__c curr = new AF_Currency__c();
     curr.AF_Country__c = 'Algeria';
     curr.AF_Currency_Code__c = 'USD';
     curr.Country_Currency__c = 'Algeria-USD';
     curr.AF_Fiscal_Year_new__c = currYear;
     curr.Currency_Unit__c = 'US $';
     curr.AF_Fiscal_Year__c = system.today();
     curr.AF_Average_Exchange_Rate_To_EUR__c = 1.3253;
     curr.Ready_For_PO_Exchange_Rate_SGD_To_USD__c=1.0000;
     curr.Ready_For_PO_Exchange_Rate_To_EUR__c = 1.6112;
     insert curr;
     
      //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Algeria';        
     entity1.AF_Agency__c=acc.Id;
     entity1.AF_Country__c='Algeria';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Indonesia';
     entity2.AF_Country__c='Indonesia';        
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2;
     
      //Insert Agency Estimate 
     AF_Agency_Estimate__c agency=new AF_Agency_Estimate__c();
     agency.AF_Brand_Estimate__c=brandEst.Id;
     agency.AF_Agency_Entity__c=entity1.id;
     agency.AF_Unilever_Entity__c=entity2.Id;  
     agency.AF_Fiscal_Year__c=currYear;
     agency.AF_Adaptation__c=22;
     agency.AF_Digital__c=22;
     agency.AF_Traditional__c=22; 
     agency.AF_Status__c='Ready for PO';
     agency.AF_Fiscal_Year__c=currYear;
     insert agency;
     
     //Insert Bonus Summary
     AF_Bonus_Summary__c bonSum=new AF_Bonus_Summary__c();
     bonSum.AF_Agency__c=acc.Id;
     bonSum.AF_Brand__c=bran.Id;
     bonSum.AF_Fiscal_Year__c=currYear1;   
     insert bonSum;
     
     //Insert Bonus Threshold
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc.Id;
     bonThres.AF_Brand_Estimate__c=brandEst.Id;
     bonThres.Brand_Name__c=bran.Id;
     bonThres.AF_Country__c=entity2.id;
     insert bonThres;
     
     //Insert Bonus Results 
     AF_Bonus_Results__c bonRes=new AF_Bonus_Results__c();
     bonRes.AF_Bonus_Thresholds__c=bonThres.Id;
     bonRes.AF_Total_Bonus_Value__c=23;
     insert bonRes;
     
     //Insert Bonus Matrix
     AF_Bonus_Matrix__c bonMat=new AF_Bonus_Matrix__c();
     bonMat.AF_Agency_Entity__c=entity1.Id;
     bonMat.AF_Bonus_Results__c=bonRes.Id;
     bonMat.AF_Bonus_Summary__c=bonSum.Id;
     bonMat.AF_Unilever_Entity__c=entity2.Id;
     bonMat.AF_Value__c=55;
     bonMat.AF_Base_Fee_Country_Total__c =35353;
     bonMat.AF_BonusableFee__c=86588; 
     bonMat.AF_Status__c = 'Ready for PO'; 
     bonMat.AF_Fiscal_Year__c = currYear;  
     //insert bonMat;
     
     List<AF_Bonus_Matrix__c> bonMatrixList=new List<AF_Bonus_Matrix__c>();
     bonMatrixList.add(bonMat);
     
     AF_Matrix_Table__c mtable = new AF_Matrix_Table__c();
    mtable.AF_Agency_Country__c = 'Algeria';
     mtable.AF_Unilver_Country__c = 'Indonesia';
     mtable.AF_Matrix_Country__c = 'Ecuador';
     mtable.AF_Matrix_Currency_Code__c = 'USD';
     mtable.AF_Ready_For_PO_Currency_Code__c = 'USD';
     mtable.AF_Ready_For_PO_Country__c ='Algeria';
    mtable.Ready_For_PO_Conversion__c = 'USD';
    insert mtable;
    
    AF_UpdateBonusEstimatesValues5.UpdateExchageRates(bonMatrixList);
        
        Test.stopTest();
        }
        }

    }