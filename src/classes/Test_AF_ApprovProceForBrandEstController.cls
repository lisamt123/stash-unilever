/**
 * Test_AF_ApprovalProcessForBrandEstController : This Test class for AF_ApprovalProcessForBrandEstController apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_ApprovProceForBrandEstController  
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void approvalProcessForBrandEstController()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testap', Email='standarduserap@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userap', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserap@test123321.com',AF_Brand__c='Test Brandap',AF_Category__c='Test Beveragesap');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyap';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesap';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     string userid=u.id;
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandap';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateap';
     brandEst.AF_Status_Base_Fees__c='With Category Finance';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Basefee_Estimate_Initial_Quarter__c='Q4';
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Pilot_Model__c=false;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
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
     
     //Insert Agency Estimate 
     AF_Agency_Estimate__c agency=new AF_Agency_Estimate__c();
     agency.AF_Brand_Estimate__c=brandEst.Id;
     agency.AF_Agency_Entity__c=entity1.id;
     agency.AF_Unilever_Entity__c=entity2.Id;  
     agency.AF_Fiscal_Year__c=currYear;
     agency.AF_Adaptation__c=22;
     agency.AF_Digital__c=22;
     agency.AF_Traditional__c=22; 
     agency.AF_Category_Finance_Flag__c=false;
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
     
     /*    if([select count() from ProcessInstance where targetobjectid=:brandEst.id] < 1)
        {       
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Approve.');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setObjectId(brandEst.Id);

            //Submit the approval request
            Approval.ProcessResult result = Approval.process(req);

        }*/
     
     /*ProcessInstance procInst=new ProcessInstance();
     procInst.TargetObjectId=brandEst.id;
     procInst.status='Pending';
     insert procInst; */
     
     AF_Brand_Estimate__c BrandEstRecord=[select id,AF_Pilot_Model__c,AF_No_Bonus__c,AF_Basefee_Estimate_Initial_Quarter__c,AF_Category_Finance_Flag__c,Brand__c,AF_Fiscal_Year__c,AF_Category_Finance_Approved__c,AF_CMCO_Rejected__c,AF_Status_Base_Fees__c,AF_Agency__c,AF_Controller_Flag__c,ExceptionsComplete__c,AF_No_of_Central_Billing__c from AF_Brand_Estimate__c  where id=:brandEst.Id  limit 1 ];
     System.debug('Counttttt'+BrandEstRecord.AF_Category_Finance_Flag__c);
     
     ApexPages.currentPage().getParameters().put('id',brandEst.id); 
     List<AggregateResult> AgencyEstimateTotalCountByCountry = [SELECT SUM(AF_Total__c) CountryTotal,AF_Unilever_Entity__r.AF_Country__c CountryName FROM AF_Agency_Estimate__c  where AF_Brand_Estimate__c=: brandEst.Id GROUP BY AF_Unilever_Entity__r.AF_Country__c];
List<AF_Bonus_Threshold__c> BonusThresholdCollection = [Select a.Year__c,a.Country_Name__c, a.SystemModstamp, a.OwnerId, a.Name, a.LastViewedDate,  a.Id,a.Brand_Name__c, a.Bonus_Measure__c, a.Agency_Name__c, a.AF_Unique_Thresholds__c, a.AF_Traditional__c, a.AF_Stretching__c, a.AF_Pilot_Model__c, a.AF_Outstanding__c, a.AF_Minimum__c, a.AF_Digital__c, a.AF_Country__c, a.AF_Country_Full_Name__c, a.AF_Category__c, a.AF_Brand_Estimate__c, a.AF_Bonusable_Fee__c From AF_Bonus_Threshold__c a where Agency_Name__c=:brandEst.AF_Agency__c and Brand_Name__c=:brandEst.Brand__c and Year__c =: brandEst.AF_Fiscal_Year__c ];


System.debug(AgencyEstimateTotalCountByCountry +'Test Valuesssssssss'+BonusThresholdCollection);
     AF_ApprovalProcessForBrandEstController approvProceBrandEst=new AF_ApprovalProcessForBrandEstController();
     
     approvProceBrandEst.BrandEstRecord=BrandEstRecord;
     
    //approvProceBrandEst.SubitforApproval();
    approvProceBrandEst.RejectBrandEstComment();
    approvProceBrandEst.RejectBrandWithComments();
    approvProceBrandEst.ApproveRecord();
    approvProceBrandEst.RejectRecord();
    approvProceBrandEst.closePopupReject();
    approvProceBrandEst.closePopup();
    approvProceBrandEst.closePopupRejComment();
    approvProceBrandEst.showPopup();
    approvProceBrandEst.SubmitApprovalPopup();
   // approvProceBrandEst.Submit();
    approvProceBrandEst.closeApprovalPopup();
    //TempConstructor();
    approvProceBrandEst.ApproveBrandEst();
    approvProceBrandEst.RejectBrandEst();
    approvProceBrandEst.TrueControllerFlag();
    approvProceBrandEst.changeBrandStatus();
   // approvProceBrandEst.RejectChangeApprover();
     
     }
   }    
}