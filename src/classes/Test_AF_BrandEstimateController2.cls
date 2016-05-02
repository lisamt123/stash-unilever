/**
 * Test_AF_BrandEstimateController2: This Test class for AF_BrandEstimateController2 apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_BrandEstimateController2
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void brandEstimateController2()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testo', Email='standarduserbec@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testuserbec@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyer';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverageser';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brander';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     string userid=u.id;
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateer';
     brandEst.AF_Status_Base_Fees__c='Initiate'; 
     brandEst.Brand__c=bran.id;
     brandEst.AF_Locked__c=false; 
     brandEst.AF_Pilot_Model__c=true;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
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
     entity1.Name='Test Entityer';        
     entity1.AF_Country__c='Australia'; 
     entity1.AF_Agency__c=acc.Id;
     
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Test Unilever Entityer';   
     entity2.AF_Country__c='Austria';     
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     //Insert Agency Estimate
     AF_Agency_Estimate__c agenEst=new AF_Agency_Estimate__c();
     agenEst.AF_Brand_Estimate__c=brandEst.Id;
     agenEst.AF_Agency_Entity__c=entity1.Id;
     agenEst.AF_Unilever_Entity__c=entity2.Id;
     agenEst.AF_Adaptation__c=324;
     agenEst.AF_Adaptation_Local__c=23;
     agenEst.AF_Digital__c=12;
     agenEst.AF_Digital_Local__c=12;
     agenEst.AF_Traditional__c=46;
     agenEst.AF_Traditional_Local__c=23;     
     insert agenEst;
     
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc.Id;
     bonThres.AF_Brand_Estimate__c=brandEst.Id;
     bonThres.Brand_Name__c=bran.Id;
     bonThres.AF_Country__c=entity2.Id;
     bonThres.Year__c='2013';
     insert bonThres;
     
            
     //Instantiate AF_BrandEstimateController  Class
     ApexPages.currentPage().getParameters().put('id',brandEst.id);
     AF_BrandEstimateController2 stdCtrl=new AF_BrandEstimateController2();
     stdCtrl.IsPilotModel=true;
     stdCtrl.showpilot=true;
     stdCtrl.checkpilot();
     stdCtrl.addwrapper();
     stdCtrl.createBonusThreshold();
     stdCtrl.save();
     stdCtrl.SaveBonusThresholds();
     stdCtrl.SaveBonusRemeneration();
     stdCtrl.showPopup();
     stdCtrl.showPopup1();
     stdCtrl.showPopup2();
     stdCtrl.closePopup();
     stdCtrl.closePopup1();
     stdCtrl.Reload();
     
     
     
     Test.stopTest();
    }
  }  

Static testMethod void brandEstimateController21()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testbec1', Email='standarduserbec1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='CMCO Super User',isActive=true, 
      UserName='testuserbec11@test123321.com',AF_Brand__c='Test Brandbec1',AF_Category__c='Test Beveragesbec1');
      insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencybec';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesbec1';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandbec1';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     string userid=u.id;
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimatebec1';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
    

     brandEst.AF_Pilot_Model__c=false;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
     
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
     entity1.Name='Test Entityer1';        
     entity1.AF_Country__c='Australia'; 
     entity1.AF_Agency__c=acc.Id;
     
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Test Unilever Entityer1';   
     entity2.AF_Country__c='Austria';     
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     //Insert Agency Estimate
     AF_Agency_Estimate__c agenEst=new AF_Agency_Estimate__c();
     agenEst.AF_Brand_Estimate__c=brandEst.Id;
     agenEst.AF_Agency_Entity__c=entity1.Id;
     agenEst.AF_Unilever_Entity__c=entity2.Id;
     agenEst.AF_Adaptation__c=324;
     agenEst.AF_Adaptation_Local__c=23;
     agenEst.AF_Digital__c=12;
     agenEst.AF_Digital_Local__c=12;
     agenEst.AF_Traditional__c=46;
     agenEst.AF_Traditional_Local__c=23;     
     insert agenEst;
     
      AF_AnnualBonus_Qual__c customRecord = new AF_AnnualBonus_Qual__c();
     customRecord.Name='5';
     customRecord.X5__c = 15;
     insert customRecord;
     
     AF_Bonus_Summary__c bonSum=new AF_Bonus_Summary__c();
     bonSum.AF_Agency__c=acc.Id;
     bonSum.AF_Fiscal_Year__c=currYear ;
     bonSum.AF_Brand__c=bran.Id;     
     insert bonSum;
     
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc.Id;
     bonThres.AF_Brand_Estimate__c=brandEst.Id;
     bonThres.Brand_Name__c=bran.Id;
     bonThres.AF_Country__c=entity2.Id;
     bonThres.Year__c='2013';
     insert bonThres;
     
     //Insert Bonus Results 
     RecordType bonResRT = [select id,Name from RecordType where SobjectType='AF_Bonus_Results__c' and Name='Bonus Annual' Limit 1]; 
     AF_Bonus_Results__c bonRes=new AF_Bonus_Results__c();
     bonRes.AF_Bonus_Thresholds__c=bonThres.Id;
     bonRes.RecordTypeId=bonResRT.Id;
     bonRes.AF_Total_Bonus_Value__c=23;
     bonRes.AF_Qual__c=1;
     bonRes.AF_Status__c='Draft';
     bonRes.AF_Quant_Bonus__c=13;
     bonRes.AF_Quant_Bonus_Value__c=156;
     bonRes.AF_Total_Bonus__c=3800;
     bonRes.AF_Total_Remuneration__c=8;
     bonRes.AF_Remuneration_Percentage__c=15;
     bonRes.AF_Quant__c=18;
     insert bonRes;
     
     //Insert Bonus Matrix
     AF_Bonus_Matrix__c bonMat=new AF_Bonus_Matrix__c();
     bonMat.AF_Agency_Entity__c=entity1.Id;
     bonMat.AF_Bonus_Results__c=bonRes.Id;
     bonMat.AF_Bonus_Summary__c=bonSum.Id;
     bonMat.AF_Unilever_Entity__c=entity2.Id;
     bonMat.AF_Value__c=decimal.valueOf(5500);
     bonMat.AF_Base_Fee_Country_Total__c =35353;
     bonMat.AF_BonusableFee__c=86588;     
     insert bonMat;
     
     //subresult
     
            AF_Sub_Result__c res=new AF_Sub_Result__c();  
            res.AF_Bonus_Threshold__c=bonThres.id;
            res.AF_Country__c=entity2.Id;
            res.AF_Digital__c=true;
            res.AF_Traditional__c=true;
            
          
            insert res;
            
     //Instantiate AF_BrandEstimateController  Class
     ApexPages.currentPage().getParameters().put('id',brandEst.id);
     AF_BrandEstimateController2 stdCtrl1=new AF_BrandEstimateController2();
     stdCtrl1.IsPilotModel=true;
     stdCtrl1.R_Traditional= true;
     stdCtrl1.SaveBonusRemeneration();
     stdCtrl1.IsPilotModel=false;
     stdCtrl1.checkpilot();
     stdCtrl1.addwrapper();
     stdCtrl1.createBonusThreshold();
     stdCtrl1.save();
     stdCtrl1.SaveBonusThresholds();
     stdCtrl1.showPopup();
     stdCtrl1.showPopup1();
     stdCtrl1.showPopup2();
     stdCtrl1.closePopup();
     stdCtrl1.closePopup1();
     stdCtrl1.Reload();
     stdCtrl1.clearErrorMsg();
     stdCtrL1.CalculateTotal();
     
     stdCtrl1.delCountryId = res.id;//bonThres.id;
     stdCtrl1.delCounrtyRecord();
     stdctrl1.bonusThresholdValidation();
     stdctrL1.bonusCheck();
     stdCtrl1.getPilotmethod();
    
     Test.stopTest();
    }
  } 
  Static testMethod void brandEstimateController212()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testbec1', Email='standarduserbec1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='CMCO Super User',isActive=true, 
      UserName='testuserbec11@test123321.com',AF_Brand__c='Test Brandbec1',AF_Category__c='Test Beveragesbec1');
      insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencybec';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesbec1';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandbec1';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     string userid=u.id;
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimatebec1';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     

     brandEst.AF_Pilot_Model__c=false;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
     
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
     entity1.Name='Test Entityer1';        
     entity1.AF_Country__c='Australia'; 
     entity1.AF_Agency__c=acc.Id;
     
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Test Unilever Entityer1';   
     entity2.AF_Country__c='Austria';     
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     //Insert Agency Estimate
     AF_Agency_Estimate__c agenEst=new AF_Agency_Estimate__c();
     agenEst.AF_Brand_Estimate__c=brandEst.Id;
     agenEst.AF_Agency_Entity__c=entity1.Id;
     agenEst.AF_Unilever_Entity__c=entity2.Id;
     agenEst.AF_Adaptation__c=324;
     agenEst.AF_Adaptation_Local__c=23;
     agenEst.AF_Digital__c=12;
     agenEst.AF_Digital_Local__c=12;
     agenEst.AF_Traditional__c=46;
     agenEst.AF_Traditional_Local__c=23;     
     insert agenEst;
     
      AF_AnnualBonus_Qual__c customRecord = new AF_AnnualBonus_Qual__c();
     customRecord.Name='5';
     customRecord.X5__c = 15;
     insert customRecord;
     
     AF_Bonus_Summary__c bonSum=new AF_Bonus_Summary__c();
     bonSum.AF_Agency__c=acc.Id;
     bonSum.AF_Fiscal_Year__c=currYear ;
     bonSum.AF_Brand__c=bran.Id;     
     insert bonSum;
     
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc.Id;
     bonThres.AF_Brand_Estimate__c=brandEst.Id;
     bonThres.Brand_Name__c=bran.Id;
     bonThres.AF_Country__c=entity2.Id;
     bonThres.Year__c='2013';
     bonThres.AF_Digital__c=false;
     insert bonThres;
     //system.debug([select id,name,AF_Digital__c from  AF_Bonus_Threshold__c where id=:bonThres]);
     //Insert Bonus Results 
     RecordType bonResRT = [select id,Name from RecordType where SobjectType='AF_Bonus_Results__c' and Name='Bonus Annual' Limit 1]; 
     AF_Bonus_Results__c bonRes=new AF_Bonus_Results__c();
     bonRes.AF_Bonus_Thresholds__c=bonThres.Id;
     bonRes.RecordTypeId=bonResRT.Id;
     bonRes.AF_Total_Bonus_Value__c=23;
     bonRes.AF_Qual__c=1;
     bonRes.AF_Status__c='Draft';
     bonRes.AF_Quant_Bonus__c=13;
     bonRes.AF_Quant_Bonus_Value__c=156;
     bonRes.AF_Total_Bonus__c=3800;
     bonRes.AF_Total_Remuneration__c=8;
     bonRes.AF_Remuneration_Percentage__c=15;
     bonRes.AF_Quant__c=18;
     insert bonRes;
     
     //Insert Bonus Matrix
     AF_Bonus_Matrix__c bonMat=new AF_Bonus_Matrix__c();
     bonMat.AF_Agency_Entity__c=entity1.Id;
     bonMat.AF_Bonus_Results__c=bonRes.Id;
     bonMat.AF_Bonus_Summary__c=bonSum.Id;
     bonMat.AF_Unilever_Entity__c=entity2.Id;
     bonMat.AF_Value__c=decimal.valueOf(5500);
     bonMat.AF_Base_Fee_Country_Total__c =35353;
     bonMat.AF_BonusableFee__c=86588;     
     insert bonMat;
     
     //subresult
            AF_Sub_Result__c res=new AF_Sub_Result__c();  
            res.AF_Bonus_Threshold__c=bonThres.id;
            //res.AF_Country__c=entity2.Id;
            res.AF_Digital__c=false;
            res.AF_Traditional__c=false;
          
            insert res;
            
            
     //Instantiate AF_BrandEstimateController  Class
     ApexPages.currentPage().getParameters().put('id',brandEst.id);
     AF_BrandEstimateController2 stdCtrl1=new AF_BrandEstimateController2();
     stdCtrl1.IsPilotModel=true;
     stdCtrl1.R_Traditional= true;
     stdCtrl1.SaveBonusRemeneration();
     stdCtrl1.IsPilotModel=true;
     stdCtrl1.checkpilot();
     stdCtrl1.addwrapper();
     stdCtrl1.createBonusThreshold();
     stdCtrl1.save();
     //system.debug([select id,AF_Digital__c from AF_Sub_Result__c where id=:res.id]+'HHHHHHHH');       
    //stdCtrl1.R_Digital=false;
    //stdCtrl1.R_Traditional=false;
    
     stdCtrl1.showPopup();
     stdCtrl1.showPopup1();
     stdCtrl1.showPopup2();
     stdCtrl1.closePopup();
     stdCtrl1.closePopup1();
     stdCtrl1.Reload();
     stdCtrl1.clearErrorMsg();
     stdCtrl1.showpilot=true;
     stdCtrl1.getPilotmethod();
     
     
     stdCtrl1.delCountryId = res.id;//bonThres.id;
     stdctrL1.bonusCheck();
    
     stdCtrl1.SaveBonusRemeneration();
      
     stdCtrl1.R_Digital=false;
     stdCtrl1.delCounrtyRecord();
     stdCtrL1.CalculateTotal();
     stdctrL1.ispilotModel=true;
     stdctrl1.bonusThresholdValidation();
     
     Test.stopTest();
    }
  }  
}