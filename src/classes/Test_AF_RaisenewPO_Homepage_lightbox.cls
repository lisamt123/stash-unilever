/**
 * Test_AF_RaisenewPO_Homepage_lightbox : This Test class for AF_RaisenewPO_Homepage_lightbox  apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_RaisenewPO_Homepage_lightbox 
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void raisenewPO_Homepage_lightbox ()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testrh', Email='standarduserrh@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userrh', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserrh@test123321.com',AF_Brand__c='Test Brandrh',AF_Category__c='Test Beveragesrh');
     insert u;        
     
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyrh';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Contact
     Contact con=new Contact();
     con.LastName='Test Con';
     con.AccountId=acc.Id;
     con.Email='test@test.com';
     con.AF_Send_Email_Notification__c=true;
     insert con;
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesrh';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandrh';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimaterh';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Active__c = true;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Controller_Flag__c=false;
     brandEst.Archived_BrandEstimate_Quarter__c='Q1;Q2;Q3';
     brandEst.AF_AgencyUsers1__c=u.Email;
     brandEst.AF_Traditional__c=23;
     brandEst.AF_Digital__c=24;
     brandEst.AF_Adaptive__c=44;
     brandEst.AF_BackupQuarter__c = 'Q1;Q2;Q3';
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
     List<AF_Brand_Estimate__c> branEs4=[select name,AF_Basefee_Estimate_Initial_Quarter__c,AF_RaiseNewPOQuarters__c,AF_BackupQuarter__c,AF_Pilot_Model__c,Archived_BrandEstimate_Quarter__c,AF_Traditional__c,AF_Digital__c,AF_Adaptive__c,Brand__r.Name,AF_Agency__r.Name,Brand__c,AF_Fiscal_Year__c,AF_Status_Base_Fees__c,AF_Active__c,AF_Controller_Flag__c from AF_Brand_Estimate__c];     
     System.debug(branEs4+'Test Class List agter insert');
     
     AF_Currency__c curr = new AF_Currency__c();
     curr.AF_Country__c = 'Ecuador';
     curr.AF_Currency_Code__c = 'USD';
     curr.Country_Currency__c = 'Eucador-USD';
     curr.AF_Fiscal_Year_new__c = currYear;
     curr.Currency_Unit__c = 'US $';
     curr.AF_Fiscal_Year__c = system.today();
     curr.AF_Average_Exchange_Rate_To_EUR__c = 1.3253;
     curr.Ready_For_PO_Exchange_Rate_SGD_To_USD__c=1.0000;
     curr.Ready_For_PO_Exchange_Rate_To_EUR__c = 1.6112;
     insert curr;  
     //System.Assert(brandEst != null, 'The Brandestimate record not inserted');
     List<AF_RaisenewPO_Homepage_lightbox.wrapChechbox> brandEstimateRecords=new List<AF_RaisenewPO_Homepage_lightbox.wrapChechbox>();

     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Australia';        
     entity1.AF_Agency__c=acc.Id;
     entity1.AF_Country__c='Australia';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Austria';
     entity2.AF_Country__c='Austria';        
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
     agency.AF_Status__c='With Agency';
     insert agency;          
     
     System.debug(agency+'Agency Estimateeeeeee');
     System.debug(agency.Brand__c+'Agency Estimateeeeeee');
             
     //Insert Bonus Threshold
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc.Id;
     bonThres.AF_Brand_Estimate__c=brandEst.Id;
     bonThres.Brand_Name__c=bran.Id;
     bonThres.AF_Country__c=entity2.id;
     bonThres.AF_Traditional__c=true;
     bonThres.AF_Digital__c=true;
     bonThres.Year__c=currYear;
     bonThres.AF_Minimum__c=10;
     bonThres.AF_Stretching__c=15;
     bonThres.AF_Outstanding__c=20;
     insert bonThres;
     
    List<AF_Brand_Estimate__c> branEs3=[select name,AF_Basefee_Estimate_Initial_Quarter__c,AF_RaiseNewPOQuarters__c,AF_BackupQuarter__c,AF_Pilot_Model__c,Archived_BrandEstimate_Quarter__c,AF_Traditional__c,AF_Digital__c,AF_Adaptive__c,Brand__r.Name,AF_Agency__r.Name,Brand__c,AF_Fiscal_Year__c,AF_Status_Base_Fees__c,AF_Active__c,AF_Controller_Flag__c from AF_Brand_Estimate__c];     
     System.debug(branEs3+'Test Class List Before Constructor');
     
     ApexPages.currentPage().getParameters().put('category',cat.id);
     ApexPages.currentPage().getParameters().put('Year',currYear);
     AF_RaisenewPO_Homepage_lightbox raiseHome=new AF_RaisenewPO_Homepage_lightbox ();
     List<AF_Brand_Estimate__c> branEs2=[select name,AF_Basefee_Estimate_Initial_Quarter__c,AF_RaiseNewPOQuarters__c,AF_BackupQuarter__c,AF_Pilot_Model__c,Archived_BrandEstimate_Quarter__c,AF_Traditional__c,AF_Digital__c,AF_Adaptive__c,Brand__r.Name,AF_Agency__r.Name,Brand__c,AF_Fiscal_Year__c from AF_Brand_Estimate__c];     
     System.debug(branEs2+'Test Class List Constructor');
     AF_RaisenewPO_Homepage_lightbox.wrapChechbox wr=new AF_RaisenewPO_Homepage_lightbox.wrapChechbox(brandEst,true,true,true,false);
     wr.Selected=true;
     brandEstimateRecords.add(wr);
     raiseHome.QuarterEstimate=brandEstimateRecords;     
     raiseHome.showPopup();
     raiseHome.saveBrandEstimate();   
     List<AF_Brand_Estimate__c> branEs=[select name,AF_Basefee_Estimate_Initial_Quarter__c,AF_RaiseNewPOQuarters__c,AF_BackupQuarter__c,AF_Pilot_Model__c,Archived_BrandEstimate_Quarter__c,AF_Traditional__c,AF_Digital__c,AF_Adaptive__c,Brand__r.Name,AF_Agency__r.Name,Brand__c,AF_Fiscal_Year__c from AF_Brand_Estimate__c];     
     List<AF_Brand_Estimate__c> branEst=[select name,AF_Basefee_Estimate_Initial_Quarter__c,AF_RaiseNewPOQuarters__c,AF_BackupQuarter__c,AF_Pilot_Model__c,Archived_BrandEstimate_Quarter__c,AF_Traditional__c,AF_Digital__c,AF_Adaptive__c,Brand__r.Name,AF_Agency__r.Name,Brand__c,AF_Fiscal_Year__c from AF_Brand_Estimate__c where AF_Status_Base_Fees__c = 'Ready for PO' and AF_Fiscal_Year__c =:currYear  and AF_Active__c=True and AF_Controller_Flag__c=False order by name asc limit 49999];
     System.debug(branEs+'Test Class List Initial');
     System.debug(branEst+'Test Class List');
     Test.stopTest();

   }
 }
  Static testMethod void raisenewPO_Homepage_lightbox1()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testrh1', Email='standarduserrh@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userrh1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserrh1@test123321.com',AF_Brand__c='Test Brandrh1',AF_Category__c='Test Beveragesrh1');
     insert u;        
     
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyrh1';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Contact
     Contact con=new Contact();
     con.LastName='Test Con1';
     con.AccountId=acc.Id;
     con.Email='test1@test.com';
     con.AF_Send_Email_Notification__c=true;
     insert con;
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesrh1';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandrh1';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimaterh1';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Active__c = true;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Controller_Flag__c=false;
     brandEst.Archived_BrandEstimate_Quarter__c='Q1;Q2;Q3';
     brandEst.AF_AgencyUsers1__c=u.Email;
     brandEst.AF_RaiseNewPOQuarters__c='Q1;Q2;Q3;Q4';
    // brandEst.AF_Traditional__c=23;
   //  brandEst.AF_Digital__c=24;
   //  brandEst.AF_Adaptive__c=44;
     brandEst.AF_BackupQuarter__c ='Q1;Q2;Q3;Q4';
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);  
     
     AF_Currency__c curr = new AF_Currency__c();
     curr.AF_Country__c = 'Ecuador';
     curr.AF_Currency_Code__c = 'USD';
     curr.Country_Currency__c = 'Eucador-USD';
     curr.AF_Fiscal_Year_new__c = currYear;
     curr.Currency_Unit__c = 'US $';
     curr.AF_Fiscal_Year__c = system.today();
     curr.AF_Average_Exchange_Rate_To_EUR__c = 1.3253;
     curr.Ready_For_PO_Exchange_Rate_SGD_To_USD__c=1.0000;
     curr.Ready_For_PO_Exchange_Rate_To_EUR__c = 1.6112;
     insert curr;
     
     List<AF_RaisenewPO_Homepage_lightbox.wrapChechbox> brandEstimateRecords=new List<AF_RaisenewPO_Homepage_lightbox.wrapChechbox>();

     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Australia';        
     entity1.AF_Agency__c=acc.Id;
     entity1.AF_Country__c='Australia';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Austria';
     entity2.AF_Country__c='Austria';        
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
     agency.AF_Status__c='With Agency';
     insert agency;              
             
     //Insert Bonus Threshold
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc.Id;
     bonThres.AF_Brand_Estimate__c=brandEst.Id;
     bonThres.Brand_Name__c=bran.Id;
     bonThres.AF_Country__c=entity2.id;
     bonThres.AF_Traditional__c=true;
     bonThres.AF_Digital__c=true;
     bonThres.Year__c=currYear;
     bonThres.AF_Minimum__c=10;
     bonThres.AF_Stretching__c=15;
     bonThres.AF_Outstanding__c=20;
     insert bonThres;
          
     ApexPages.currentPage().getParameters().put('category',cat.id);
     ApexPages.currentPage().getParameters().put('Year',currYear);     
     AF_RaisenewPO_Homepage_lightbox raiseHome1=new AF_RaisenewPO_Homepage_lightbox ();
      
     AF_RaisenewPO_Homepage_lightbox.wrapChechbox wr1=new AF_RaisenewPO_Homepage_lightbox.wrapChechbox(brandEst,true,true,true,false);
     wr1.Selected=true;
     brandEstimateRecords.add(wr1);
     raiseHome1.QuarterEstimate=brandEstimateRecords;
     //raiseHome1.AF_BackupQuarter__c.put(brandEst.id,'Q1;Q2;Q3');   
     raiseHome1.showPopup();
     raiseHome1.saveBrandEstimate();          
     
     Test.stopTest();

   }
 }
}