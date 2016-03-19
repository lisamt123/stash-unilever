/**
 * Test_AF_EditComment: This Test class for AF_EditComment apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_EditComment
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void editComment()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testc', Email='standarduserc@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userec', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testuserec@test123321.com',AF_Brand__c='Test Brandec',AF_Category__c='Test Beveragesec');
     insert u;        
     
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyec';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesec';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandec';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateec';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.AF_Fiscal_Year__c='2013';
     brandEst.AF_Active__c = true;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.Brand__c=bran.id;
     brandEst.AF_AgencyUsers1__c=u.Email;
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
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;     
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Fiscal_year__c='2013';
     insert oopsActual;   
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Test Entityec';        
     entity1.AF_Agency__c=acc.Id;
     entity1.AF_Country__c='Australia';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Test Unilever Entityec';        
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     //Insert Agency Estimate 
     AF_Agency_Estimate__c agency=new AF_Agency_Estimate__c();
     agency.AF_Brand_Estimate__c=brandEst.Id;
     agency.AF_Agency_Entity__c=entity1.id;
     agency.AF_Unilever_Entity__c=entity2.Id;  
     agency.AF_Fiscal_Year__c='2013';
     agency.AF_Adaptation__c=22;
     agency.AF_Digital__c=22;
     agency.AF_Traditional__c=22; 
     agency.AF_Status__c='With Agency';
     insert agency;
         
     //Insert OOPS Estimate
     AF_OOPS_Estimate__c oopEst=new AF_OOPS_Estimate__c();
     oopEst.AF_Agency_Entity__c=entity1.Id;
     oopEst.AF_Brand_Estimate__c=brandEst.id;
     oopEst.AF_OOPS_Actual__c=oopsActual.Id;
     oopEst.AF_Unilever_Entity__c=entity2.Id;
     oopEst.AF_Estimate__c=55;
     insert oopEst;
     
     //Insert Bonus Summary
     AF_Bonus_Summary__c bonSum=new AF_Bonus_Summary__c();
     bonSum.AF_Agency__c=acc.Id;
     bonSum.AF_Brand__c=bran.Id;
     bonSum.AF_Fiscal_Year__c='2013';   
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
     bonMat.AF_Fiscal_Year__c=currYear;     
     insert bonMat;
     
     //Insert Comment
     AF_Comments__c comm=new AF_Comments__c();
     comm.AF_Parent_Object_Type__c='AF_Brand_Estimate__c';
     comm.AF_Parent_Record_Id__c=brandEst.id;
     comm.AF_Agency_Estimate__c=agency.Id;
     comm.AF_Bonus__c=bonMat.Id;
     comm.AF_Brand_Estimate__c=brandEst.id;
     comm.AF_Comments__c='Comment';
     comm.AF_OOPS_Actual__c=oopsActual.Id;
     comm.AF_OOPS_Estimate__c=oopEst.Id;
     insert comm;
     
     //Insert Comment
     AF_Comments__c comm1=new AF_Comments__c();
     comm1.AF_Parent_Object_Type__c='AF_Agency_Estimate__c';
     comm1.AF_Parent_Record_Id__c=agency.Id;
     comm1.AF_Agency_Estimate__c=agency.Id;
     comm1.AF_Bonus__c=bonMat.Id;
     comm1.AF_Brand_Estimate__c=brandEst.id;
     comm1.AF_Comments__c='Comment1';
     comm1.AF_OOPS_Actual__c=oopsActual.Id;
     comm1.AF_OOPS_Estimate__c=oopEst.Id;
     insert comm1;
     
     //Insert Comment
     AF_Comments__c comm2=new AF_Comments__c();
     comm2.AF_Parent_Object_Type__c='AF_Bonus__c';
     comm2.AF_Parent_Record_Id__c=bonMat.Id;
     comm2.AF_Agency_Estimate__c=agency.Id;
     comm2.AF_Bonus__c=bonMat.Id;
     comm2.AF_Comments__c='Comment2';
     comm2.AF_Brand_Estimate__c=brandEst.id;
     comm2.AF_OOPS_Actual__c=oopsActual.Id;
     comm2.AF_OOPS_Estimate__c=oopEst.Id;
     insert comm2;
     
     //Insert Comment
     AF_Comments__c comm3=new AF_Comments__c();
     comm3.AF_Parent_Object_Type__c='AF_OOPS_Estimate__c';
     comm3.AF_Parent_Record_Id__c=oopEst.Id;
     comm3.AF_Agency_Estimate__c=agency.Id;
     comm3.AF_Bonus__c=bonMat.Id;
     comm3.AF_Comments__c='Comment3';
     comm3.AF_Brand_Estimate__c=brandEst.id;
     comm3.AF_OOPS_Actual__c=oopsActual.Id;
     comm3.AF_OOPS_Estimate__c=oopEst.Id;
     insert comm3;
     
     //Instantiating AF_EditComment Class 
     ApexPages.currentPage().getParameters().put('id',comm.id);
     ApexPages.currentPage().getParameters().put('rp',agency.id);
     AF_EditComment editComm=new AF_EditComment();
     editComm.CommentRecord=comm; 
     editComm.ParentRecordType='AF_Brand_Estimate__c'; 
     editComm.SaveComment();    
           
     ApexPages.currentPage().getParameters().put('id',comm1.id);
     ApexPages.currentPage().getParameters().put('rp',agency.id);
     AF_EditComment editComm1=new AF_EditComment();
     editComm1.CommentRecord=comm1; 
     editComm1.ParentRecordType='AF_Agency_Estimate__c'; 
     editComm1.SaveComment();
     
     ApexPages.currentPage().getParameters().put('id',comm2.id);
     ApexPages.currentPage().getParameters().put('rp',agency.id);
     AF_EditComment editComm2=new AF_EditComment();
     editComm2.CommentRecord=comm2; 
     editComm2.ParentRecordType='AF_Bonus__c'; 
     editComm2.SaveComment();
     
     ApexPages.currentPage().getParameters().put('id',comm3.id);
     ApexPages.currentPage().getParameters().put('rp',agency.id);
     AF_EditComment editComm3=new AF_EditComment();
     editComm3.CommentRecord=comm3; 
     editComm3.ParentRecordType='AF_OOPS_Estimate__c'; 
     editComm3.SaveComment();
     
     Test.stopTest();
     }
  }
}