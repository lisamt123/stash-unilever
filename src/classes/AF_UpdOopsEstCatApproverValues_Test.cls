/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_UpdOopsEstCatApproverValues_Test
@Created Date : 04/08/2014.
@Description : This Test class for AF_UpdateOopsEstimateCatApproverValues apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_UpdOopsEstCatApproverValues_Test  
{    
	Static Integer IcurrYear = System.Today().year();
	Static string currYear=string.valueof(IcurrYear);
	Static Integer IcurrYear1 = System.Today().year()-1;
	Static string currYear1=string.valueof(IcurrYear1);
	static user userForupdateoopsEstcatApprover;
	static user userForupdateoopsEstcatApprover1;
	static user userForupdateoopsEstcatApprover2;
	static user userForupdateoopsEstcatApprover3;
	static user userForupdateoopsEstcatApprover4;
	static user userForupdateoopsEstcatApprover5;
	static user userForupdateoopsEstcatApprover6;
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : UpdOopsEstiCatApproverValues
*  @param : none
*  @return : none
*************************************************************************/  
	Static testMethod void UpdOopsEstiCatApproverValues ()
	{
		Test.startTest();
		userForupdateoopsEstcatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
		User u=[SELECT id,AF_Brand__c, Email FROM user WHERE id=:userForupdateoopsEstcatApprover.id LIMIT 1];
		System.runAs(u)
		{
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
			List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
			System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
			//insert contact.
			List<contact> con =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con1 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con2 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con4 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con5 =AF_TestFactory_Helper.AFInsertContact(1,true);
			//Insert category
			List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
			List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
			System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
			//Insert Brand
			List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
			List<AF_Category_Brand__c> AFCategoryBrandlist= new List<AF_Category_Brand__c>();
			for(AF_Category_Brand__c brand:AFCategoryBrand){
				brand.name=AF_Constants.TEST_BRANDNAME;
				AFCategoryBrandlist.add(brand);
			}
			insert AFCategoryBrandlist;
			List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrandlist LIMIT 1];
			//Insert BrandEstimate
			List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
			List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br : BrandEst){
				br.AF_AgencyUsers1__c=u.Email;
				br.AF_Cat_Finance_Approver_1__c=u.id;
				br.AF_Active__c = true;
				br.AF_Copied__c= false;
				br.AF_Locked__c = false;
				br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
				br.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
				br.AF_Fiscal_Year__c=currYear1;
				br.AF_Pilot_Model__c=false;
				BrandEstNew.add(br);
			}
			insert BrandEstNew;
			List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList1(1,false);
			List<AF_Brand_Estimate__c> BrandEstNew1 = new List<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br1 : BrandEst1){
				br1.AF_AgencyUsers1__c=u.Email;
				br1.AF_Active__c = true;
				br1.AF_Copied__c= false;
				br1.AF_Locked__c = false;
				br1.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
				br1.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
				br1.AF_Fiscal_Year__c=currYear;
				br1.AF_Pilot_Model__c=false;
				BrandEstNew1.add(br1);
			}
			insert BrandEstNew1;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//insert OOPs Actual.
			List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
			List<AF_OOPS_Actual__c> OopsactualListNew = new List<AF_OOPS_Actual__c>();
			for(AF_OOPS_Actual__c oopact: OopsactualList){
				oopact.AF_Fiscal_year__c=currYear;
				OopsactualListNew.add(oopact);
			}
			insert OopsactualListNew;
			List<AF_OOPS_Actual__c> OopsactualList1 = AF_TestFactory_Helper.insertOOPSActual1(1,false);
			List<AF_OOPS_Actual__c> OopsactualListNew1 = new List<AF_OOPS_Actual__c>();
			for(AF_OOPS_Actual__c oopact1: OopsactualList1){
				oopact1.AF_Fiscal_year__c=currYear1;
				OopsactualListNew1.add(oopact1);
			}
			insert OopsactualListNew1;
			List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualListNew LIMIT 1];
			System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
			AF_UpdateOopsEstimateCatApproverValues.UpdateOopsEstimates(OopsactualListNew);
			AF_UpdateOopsEstimateCatApproverValues.UpdateOopsagencyBulk(OopsactualListNew);
			Test.stopTest();
		}
	}
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : UpdOopsEstiCatApproverValues1
*  @param : none
*  @return : none
*************************************************************************/ 
	Static testMethod void UpdOopsEstiCatApproverValues1()
	{
		Test.startTest();
		userForupdateoopsEstcatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
		User u=[SELECT id,AF_Brand__c,Email FROM user WHERE id=:userForupdateoopsEstcatApprover.id LIMIT 1];
		userForupdateoopsEstcatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
		User u1=[SELECT id,AF_Brand__c,Email FROM user WHERE id=:userForupdateoopsEstcatApprover1.id LIMIT 1];
		System.runAs(u)
		{
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
			List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
			System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
			//insert contact.
			List<contact> con =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con1 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con2 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con4 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con5 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con6 =AF_TestFactory_Helper.AFInsertContact(1,true);
			//Insert category
			List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
			List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
			System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
			//Insert Brand
			List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
			List<AF_Category_Brand__c> AFCategoryBrandlist= new List<AF_Category_Brand__c>();
			for(AF_Category_Brand__c brand:AFCategoryBrand){
				brand.name=AF_Constants.TEST_BRANDNAME;
				AFCategoryBrandlist.add(brand);
			}
			insert AFCategoryBrandlist;
			List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrandlist LIMIT 1];
			//Insert BrandEstimate
			List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
			List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br : BrandEst){
				br.AF_AgencyUsers1__c=u.Email;
				br.AF_Cat_Finance_Approver_1__c=u.id;
				br.AF_Cat_Finance_Approver_2__c=u1.id;
				br.AF_Active__c = true;
				br.AF_Copied__c= false;
				br.AF_Locked__c = false;
				br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
				br.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
				br.AF_Fiscal_Year__c=currYear1;
				br.AF_Pilot_Model__c=false;
				BrandEstNew.add(br);
			}
			insert BrandEstNew;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//insert OOPs Actual.
			List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
			List<AF_OOPS_Actual__c> OopsactualListNew = new List<AF_OOPS_Actual__c>();
			for(AF_OOPS_Actual__c oopact: OopsactualList){
				oopact.AF_Fiscal_year__c=currYear;
				OopsactualListNew.add(oopact);
			}
			insert OopsactualListNew;
			List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualListNew LIMIT 1];
			System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
			AF_UpdateOopsEstimateCatApproverValues.UpdateOopsEstimates(OopsactualListNew);
			AF_UpdateOopsEstimateCatApproverValues.UpdateOopsagencyBulk(OopsactualListNew);
			Test.stopTest();
		}
	}
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : UpdOopsEstiCatApproverValues2
*  @param : none
*  @return : none
*************************************************************************/  
	Static testMethod void UpdOopsEstiCatApproverValues2()
	{   Test.startTest();
		userForupdateoopsEstcatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
		User u=[SELECT id,AF_Brand__c,Email FROM user WHERE id=:userForupdateoopsEstcatApprover.id LIMIT 1];
		userForupdateoopsEstcatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
		User u1=[SELECT id,AF_Brand__c,Email FROM user WHERE id=:userForupdateoopsEstcatApprover1.id LIMIT 1];
		userForupdateoopsEstcatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
		User u2=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover2.id LIMIT 1];
		System.runAs(u)
		{
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
			List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
			System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
			//insert contact.
			List<contact> con =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con1 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con2 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con4 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con5 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con6 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con7 =AF_TestFactory_Helper.AFInsertContact(1,true);
			//Insert category
			List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
			List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
			System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
			//Insert Brand
			List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
			List<AF_Category_Brand__c> AFCategoryBrandlist= new List<AF_Category_Brand__c>();
			for(AF_Category_Brand__c brand:AFCategoryBrand){
				brand.name=AF_Constants.TEST_BRANDNAME;
				AFCategoryBrandlist.add(brand);
			}
			insert AFCategoryBrandlist;
			List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrandlist LIMIT 1];
			//Insert BrandEstimate
			List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
			List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br : BrandEst){
				br.AF_AgencyUsers1__c=u.Email;
				br.AF_Active__c = true;
				br.AF_Copied__c= false;
				br.AF_Locked__c = false;
				br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
				br.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
				br.AF_Fiscal_Year__c=currYear1;
				br.AF_Pilot_Model__c=false;
				BrandEstNew.add(br);
			}
			insert BrandEstNew;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//insert OOPs Actual.
			List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
			List<AF_OOPS_Actual__c> OopsactualListNew = new List<AF_OOPS_Actual__c>();
			for(AF_OOPS_Actual__c oopact: OopsactualList){
				oopact.AF_Fiscal_year__c=currYear;
				OopsactualListNew.add(oopact);
			}
			insert OopsactualListNew;
			List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
			System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
			AF_UpdateOopsEstimateCatApproverValues.UpdateOopsEstimates(OopsactualListNew);
			AF_UpdateOopsEstimateCatApproverValues.UpdateOopsagencyBulk(OopsactualListNew);
			Test.stopTest();
		}
	}
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : UpdOopsEstiCatApproverValues3
*  @param : none
*  @return : none
*************************************************************************/  
	Static testMethod void UpdOopsEstiCatApproverValues3()
	{
		Test.startTest();
		userForupdateoopsEstcatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
		User u=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover.id LIMIT 1];
		userForupdateoopsEstcatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
		User u1=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover1.id LIMIT 1];
		userForupdateoopsEstcatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
		User u2=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover2.id LIMIT 1];
		userForupdateoopsEstcatApprover3=AF_TestFactory_Helper.createUserADMINSTRATOR3(true);
		User u3=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover3.id LIMIT 1];
		System.runAs(u)
		{
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
			List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
			System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
			//insert contact.
			List<contact> con =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con1 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con2 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con4 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con5 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con6 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con7 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con8 =AF_TestFactory_Helper.AFInsertContact(1,true);
			//Insert category
			List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
			List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
			System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
			//Insert Brand
			//Insert Brand
			List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
			List<AF_Category_Brand__c> AFCategoryBrandlist= new List<AF_Category_Brand__c>();
			for(AF_Category_Brand__c brand:AFCategoryBrand){
				brand.name=AF_Constants.TEST_BRANDNAME;
				AFCategoryBrandlist.add(brand);
			}
			insert AFCategoryBrandlist;
			//Insert BrandEstimate
			List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
			List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br : BrandEst){
				br.AF_AgencyUsers1__c=u.Email;
				br.AF_Active__c = true;
				br.AF_Copied__c= false;
				br.AF_Locked__c = false;
				br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
				br.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
				br.AF_Fiscal_Year__c=currYear1;
				br.AF_Pilot_Model__c=false;
				BrandEstNew.add(br);
			}
			insert BrandEstNew;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
			//insert OOPs Actual.
			List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
			List<AF_OOPS_Actual__c> OopsactualListNew = new List<AF_OOPS_Actual__c>();
			for(AF_OOPS_Actual__c oopact: OopsactualList){
				oopact.AF_Fiscal_year__c=currYear;
				OopsactualListNew.add(oopact);
			}
			insert OopsactualListNew;
			List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
			System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
			AF_UpdateOopsEstimateCatApproverValues.UpdateOopsEstimates(OopsactualListNew);
			AF_UpdateOopsEstimateCatApproverValues.UpdateOopsagencyBulk(OopsactualListNew);
			Test.stopTest();
		}
	}
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : UpdOopsEstiCatApproverValues4
*  @param : none
*  @return : none
*************************************************************************/ 
	Static testMethod void UpdOopsEstiCatApproverValues4 ()
	{   Test.startTest();
		userForupdateoopsEstcatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
		User u=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateoopsEstcatApprover.id LIMIT 1];
		userForupdateoopsEstcatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
		User u1=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover1.id LIMIT 1];
		userForupdateoopsEstcatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
		User u2=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover2.id LIMIT 1];
		userForupdateoopsEstcatApprover3=AF_TestFactory_Helper.createUserADMINSTRATOR3(true);
		User u3=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover3.id LIMIT 1];
		userForupdateoopsEstcatApprover4=AF_TestFactory_Helper.createUserADMINSTRATOR4(true);
		User u4=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover4.id LIMIT 1];
		system.runAs(u)
		{
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
			List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
			System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
			//insert contact.
			List<contact> con =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con1 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con2 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con4 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con5 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con6 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con7=AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con8 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con9 =AF_TestFactory_Helper.AFInsertContact(1,true);
			//Insert category
			List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
			List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
			System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
			//Insert Brand
			List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
			List<AF_Category_Brand__c> AFCategoryBrandlist= new List<AF_Category_Brand__c>();
			for(AF_Category_Brand__c brand:AFCategoryBrand){
				brand.name=AF_Constants.TEST_BRANDNAME;
				AFCategoryBrandlist.add(brand);
			}
			insert AFCategoryBrandlist;
			List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrandlist LIMIT 1];
			//Insert BrandEstimate
			List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
			List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br : BrandEst){
				br.AF_AgencyUsers1__c=u.Email;
				br.AF_Active__c = true;
				br.AF_Copied__c= false;
				br.AF_Locked__c = false;
				br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
				br.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
				br.AF_Fiscal_Year__c=currYear1;
				br.AF_Pilot_Model__c=false;
				BrandEstNew.add(br);
			}
			insert BrandEstNew;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//insert OOPs Actual.
			List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
			List<AF_OOPS_Actual__c> OopsactualListNew = new List<AF_OOPS_Actual__c>();
			for(AF_OOPS_Actual__c oopact: OopsactualList){
				oopact.AF_Fiscal_year__c=currYear;
				OopsactualListNew.add(oopact);
			}
			insert OopsactualListNew;
			List<AF_OOPS_Actual__c> OopsactualList1 = AF_TestFactory_Helper.insertOOPSActual(1,false);
			List<AF_OOPS_Actual__c> OopsactualListNew1 = new List<AF_OOPS_Actual__c>();
			for(AF_OOPS_Actual__c oopact1: OopsactualList1){
				oopact1.AF_Fiscal_year__c=currYear1;
				OopsactualListNew1.add(oopact1);
			}
			insert OopsactualListNew1;
			List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualListNew LIMIT 1];
			System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
			AF_UpdateOopsEstimateCatApproverValues.UpdateOopsEstimates(OopsactualListNew);
			AF_UpdateOopsEstimateCatApproverValues.UpdateOopsagencyBulk(OopsactualListNew);
			Test.stopTest();
		}
	}
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : UpdOopsEstiCatApproverValues5
*  @param : none
*  @return : none
*************************************************************************/ 
	Static testMethod void UpdOopsEstiCatApproverValues5 ()
	{   Test.startTest();
		userForupdateoopsEstcatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
		User u=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateoopsEstcatApprover.id LIMIT 1];
		userForupdateoopsEstcatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
		User u1=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover1.id LIMIT 1];
		userForupdateoopsEstcatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
		User u2=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover2.id LIMIT 1];
		userForupdateoopsEstcatApprover3=AF_TestFactory_Helper.createUserADMINSTRATOR3(true);
		User u3=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover3.id LIMIT 1];
		userForupdateoopsEstcatApprover4=AF_TestFactory_Helper.createUserADMINSTRATOR4(true);
		User u4=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover4.id LIMIT 1];
		userForupdateoopsEstcatApprover5=AF_TestFactory_Helper.createUserAdmin3(true);
		User u5=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover5.id LIMIT 1];
		system.runAs(u)
		{
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
			List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
			System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
			//insert contact.
			List<contact> con =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con1 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con2 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con4 =AF_TestFactory_Helper.AFInsertContact(1,true);
			//Insert category
			List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
			List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
			System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
			//Insert Brand
			List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
			List<AF_Category_Brand__c> AFCategoryBrandlist= new List<AF_Category_Brand__c>();
			for(AF_Category_Brand__c brand:AFCategoryBrand){
				brand.name=AF_Constants.TEST_BRANDNAME;
				AFCategoryBrandlist.add(brand);
			}
			insert AFCategoryBrandlist;
			List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrandlist LIMIT 1];
			//Insert BrandEstimate
			List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
			List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br : BrandEst){
				br.AF_AgencyUsers1__c=u.Email;
				br.AF_Active__c = true;
				br.AF_Copied__c= false;
				br.AF_Locked__c = false;
				br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
				br.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
				br.AF_Fiscal_Year__c=currYear1;
				br.AF_Pilot_Model__c=false;
				BrandEstNew.add(br);
			}
			insert BrandEstNew;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//insert OOPs Actual.
			List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
			List<AF_OOPS_Actual__c> OopsactualListNew = new List<AF_OOPS_Actual__c>();
			for(AF_OOPS_Actual__c oopact: OopsactualList){
				oopact.AF_Fiscal_year__c=currYear;
				OopsactualListNew.add(oopact);
			}
			insert OopsactualListNew;
			List<AF_OOPS_Actual__c> OopsactualList1 = AF_TestFactory_Helper.insertOOPSActual(1,false);
			List<AF_OOPS_Actual__c> OopsactualListNew1 = new List<AF_OOPS_Actual__c>();
			for(AF_OOPS_Actual__c oopact1: OopsactualList1){
				oopact1.AF_Fiscal_year__c=currYear1;
				OopsactualListNew1.add(oopact1);
			}
			insert OopsactualListNew1;
			List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualListNew LIMIT 1];
			System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
			AF_UpdateOopsEstimateCatApproverValues.UpdateOopsEstimates(OopsactualListNew);
			AF_UpdateOopsEstimateCatApproverValues.UpdateOopsagencyBulk(OopsactualListNew);
			Test.stopTest();
		}
	}
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : UpdOopsEstiCatApproverValues6
*  @param : none
*  @return : none
*************************************************************************/ 
	Static testMethod void UpdOopsEstiCatApproverValues6()
	{   Test.startTest();
		userForupdateoopsEstcatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
		User u=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateoopsEstcatApprover.id LIMIT 1];
		userForupdateoopsEstcatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
		User u1=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover1.id LIMIT 1];
		userForupdateoopsEstcatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
		User u2=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover2.id LIMIT 1];
		userForupdateoopsEstcatApprover3=AF_TestFactory_Helper.createUserADMINSTRATOR3(true);
		User u3=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover3.id LIMIT 1];
		userForupdateoopsEstcatApprover4=AF_TestFactory_Helper.createUserADMINSTRATOR4(true);
		User u4=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover4.id LIMIT 1];
		userForupdateoopsEstcatApprover5=AF_TestFactory_Helper.createUserAdmin3(true);
		User u5=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover5.id LIMIT 1];
		userForupdateoopsEstcatApprover6=AF_TestFactory_Helper.createAgency(true);
		User u6=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover6.id LIMIT 1];
		system.runAs(u)
		{
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
			List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
			System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
			//insert contact.
			List<contact> con =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con1 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con2 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
			//Insert category
			List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
			List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
			System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
			//Insert Brand
			List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
			List<AF_Category_Brand__c> AFCategoryBrandlist= new List<AF_Category_Brand__c>();
			for(AF_Category_Brand__c brand:AFCategoryBrand){
				brand.name=AF_Constants.TEST_BRANDNAME;
				AFCategoryBrandlist.add(brand);
			}
			insert AFCategoryBrandlist;
			List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrandlist LIMIT 1];
			//Insert BrandEstimate
			List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
			List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br : BrandEst){
				br.AF_AgencyUsers1__c=u.Email;
				br.AF_Active__c = true;
				br.AF_Copied__c= false;
				br.AF_Locked__c = false;
				br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
				br.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
				br.AF_Fiscal_Year__c=currYear1;
				br.AF_Pilot_Model__c=false;
				BrandEstNew.add(br);
			}
			insert BrandEstNew;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//insert OOPs Actual.
			List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
			List<AF_OOPS_Actual__c> OopsactualListNew = new List<AF_OOPS_Actual__c>();
			for(AF_OOPS_Actual__c oopact: OopsactualList){
				oopact.AF_Fiscal_year__c=currYear;
				OopsactualListNew.add(oopact);
			}
			insert OopsactualListNew;
			List<AF_OOPS_Actual__c> OopsactualList1 = AF_TestFactory_Helper.insertOOPSActual(1,false);
			List<AF_OOPS_Actual__c> OopsactualListNew1 = new List<AF_OOPS_Actual__c>();
			for(AF_OOPS_Actual__c oopact1: OopsactualList1){
				oopact1.AF_Fiscal_year__c=currYear1;
				OopsactualListNew1.add(oopact1);
			}
			insert OopsactualListNew1;
			List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualListNew LIMIT 1];
			System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
			AF_UpdateOopsEstimateCatApproverValues.UpdateOopsEstimates(OopsactualListNew);
			AF_UpdateOopsEstimateCatApproverValues.UpdateOopsagencyBulk(OopsactualListNew);
			Test.stopTest();
		}
	}
}