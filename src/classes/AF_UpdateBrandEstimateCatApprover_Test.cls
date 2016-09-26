/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_UpdateBrandEstimateCatApproverValues_Test
@Created Date : 04/08/2014.
@Description : This Test class for AF_UpdateBrandEstimateCatApproverValues apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_UpdateBrandEstimateCatApprover_Test 
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
	Static testMethod void UpdateBrandEstimateCatApproverValues()
	{
		Test.startTest();
		userForupdateoopsEstcatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
		User u=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover.id LIMIT 1];
		System.runAs(u)
		{
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
			List<Account> acctQuery= [SELECT id FROM account LIMIT 1];
			System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.CONTACT_RECORD);
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
			list<AF_Brand_Estimate__c> brandlist=new list<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br : BrandEst){
				br.AF_Agency__c=acctQuery[0].id;
				br.AF_AgencyUsers1__c=u.Email;
				br.AF_Active__c = true;
				br.AF_Copied__c= false;
				br.AF_Locked__c = false;
				brandlist.add(br);
			}
			insert brandlist;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//insert OOPs Actual.
			List<AF_Brand_Estimate__c> Brandestiamtelist= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> Brandestiamtelist1= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> BrandestiamtelistQuery = [SELECT ID,AF_Agency__c FROM AF_Brand_Estimate__c WHERE ID IN : Brandestiamtelist LIMIT 1];
			System.assertEquals(BrandestiamtelistQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandlist);
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagencyBulk(brandlist);
			Test.stopTest();
		}
	}
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : UpdateBrandEstimateCatApproverValues1
*  @param : none
*  @return : none
*************************************************************************/  
	Static testMethod void UpdateBrandEstimateCatApproverValues1()
	{
		Test.startTest();
		userForupdateoopsEstcatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
		User u=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover.id LIMIT 1];
		userForupdateoopsEstcatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
		User u1=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover1.id LIMIT 1];
		userForupdateoopsEstcatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
		User u2=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover2.id LIMIT 1];
		System.runAs(u2)
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
			List<contact> conQuery = [SELECT id FROM contact LIMIT 1];
			System.Assert(conQuery[0].Id != null, AF_TestFactory_Helper.CONTACT_RECORD);
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
			List<AF_Brand_Estimate__c> BrandEstNew = new   List<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br : BrandEst){
				br.AF_AgencyUsers1__c=u.Email;
				br.AF_Active__c = true;
				br.AF_Copied__c= false;
				br.AF_Locked__c = false;
				br.Brand__c=AFCategoryBrandlist[0].id;
				br.AF_Cat_Finance_Approver_1__c=u.id;
				br.AF_Cat_Finance_Approver_2__c=u1.id;
				br.AF_Cat_Finance_Approver_3__c=u2.id;
				BrandEstNew.add(br);
			}
			insert BrandEstNew;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//insert OOPs Actual.
			List<AF_Brand_Estimate__c> Brandestiamtelist= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> Brandestiamtelist1= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> BrandestiamtelistQuery = [SELECT ID,AF_Agency__c FROM AF_Brand_Estimate__c WHERE ID IN : Brandestiamtelist LIMIT 1];
			System.assertEquals(BrandestiamtelistQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(Brandestiamtelist);
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagencyBulk(Brandestiamtelist);
			Test.stopTest();
		}
	}
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : UpdOopsEstiCatApproverValues2
*  @param : none
*  @return : none
*************************************************************************/  
	Static testMethod void UpdateBrandEstimateCatApproverValues2()
	{   Test.startTest();
		userForupdateoopsEstcatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
		User u=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover.id LIMIT 1];
		userForupdateoopsEstcatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
		User u1=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover1.id LIMIT 1];
		System.runAs(u)
		{
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
			List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
			System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
			//insert contact.
			List<contact> con  = AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con1 = AF_TestFactory_Helper.AFInsertContact1(1,true);
			List<contact> con2 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con4 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con5 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con6 =AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> conQuery = [SELECT id FROM contact LIMIT 1];
			System.Assert(conQuery[0].Id != null, AF_TestFactory_Helper.CONTACT_RECORD);
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
			List<AF_Brand_Estimate__c> BrandEstNew =new List<AF_Brand_Estimate__c> ();
			for(AF_Brand_Estimate__c br : BrandEst){
				br.AF_AgencyUsers1__c=u.Email;
				br.AF_Active__c = true;
				br.AF_Copied__c= false;
				br.AF_Locked__c = false;
				BrandEstNew.add(br);
			}
			insert BrandEstNew;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//insert OOPs Actual.
			List<AF_Brand_Estimate__c> Brandestiamtelist= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> Brandestiamtelist1= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> BrandestiamtelistQuery = [SELECT ID,AF_Agency__c FROM AF_Brand_Estimate__c WHERE ID IN : Brandestiamtelist LIMIT 1];
			System.assertEquals(BrandestiamtelistQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(Brandestiamtelist);
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagencyBulk(Brandestiamtelist);
		}
	}
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : UpdOopsEstiCatApproverValues3
*  @param : none
*  @return : none
*************************************************************************/  
	Static testMethod void UpdateBrandEstimateCatApproverValues3()
	{
		Test.startTest();
		userForupdateoopsEstcatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
		User u=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover.id LIMIT 1];
		userForupdateoopsEstcatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
		User u1=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover1.id LIMIT 1];
		userForupdateoopsEstcatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR3(true);
		User u2=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover2.id LIMIT 1];
		userForupdateoopsEstcatApprover3=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
		User u3=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover3.id LIMIT 1];
		System.runAs(u)
		{
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
			List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
			System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
			//insert contact.
			List<contact> con  = AF_TestFactory_Helper.AFInsertContact(1,true); 
			List<contact> con1  = AF_TestFactory_Helper.AFInsertContact(1,true);  
			List<contact> con2  = AF_TestFactory_Helper.AFInsertContact(1,true);  
			List<contact> con3  = AF_TestFactory_Helper.AFInsertContact(1,true);  
			List<contact> con4  = AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con5  = AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con6  = AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con7  = AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> conQuery = [SELECT id FROM contact LIMIT 1];
			System.Assert(conQuery[0].Id != null, AF_TestFactory_Helper.CONTACT_RECORD);           
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
				BrandEstNew.add(br);
			}
			insert BrandEstNew;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//insert OOPs Actual.
			List<AF_Brand_Estimate__c> Brandestiamtelist= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> Brandestiamtelist1= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> BrandestiamtelistQuery = [SELECT ID,AF_Agency__c FROM AF_Brand_Estimate__c WHERE ID IN : Brandestiamtelist LIMIT 1];
			System.assertEquals(BrandestiamtelistQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(Brandestiamtelist);
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagencyBulk(Brandestiamtelist);
		}
	}
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : UpdateBrandEstimateCatApproverValues4
*  @param : none
*  @return : none
*************************************************************************/  
	Static testMethod void UpdateBrandEstimateCatApproverValues4()
	{   Test.startTest();
		userForupdateoopsEstcatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
		User u=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover.id LIMIT 1];
		userForupdateoopsEstcatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
		User u1=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover1.id LIMIT 1];
		userForupdateoopsEstcatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR4(true);
		User u2=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover2.id LIMIT 1];
		userForupdateoopsEstcatApprover3=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
		User u3=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover3.id LIMIT 1];
		userForupdateoopsEstcatApprover4=AF_TestFactory_Helper.createUserADMINSTRATOR3(true);
		User u4=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover4.id LIMIT 1];
		system.runAs(u)
		{
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
			List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
			System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
			//insert contact.
			List<contact> con  = AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con1 = AF_TestFactory_Helper.AFInsertContact1(1,true);
			List<contact>con2 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact>con3 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact>con4 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact>con5 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact>con6 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact>con7 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact>con8 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact> conQuery = [SELECT id FROM contact LIMIT 1];
			System.Assert(conQuery[0].Id != null, AF_TestFactory_Helper.CONTACT_RECORD);
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
			list<AF_Brand_Estimate__c> Brandlist=new list<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br : BrandEst){
				br.AF_AgencyUsers1__c=u.Email;
				br.AF_Active__c = true;
				br.AF_Copied__c= false;
				br.AF_Locked__c = false;
				Brandlist.add(br);
			}
			insert Brandlist;
			List<AF_Brand_Estimate__c> bran= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> bran1= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> bran2= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//insert OOPs Actual.
			List<AF_Brand_Estimate__c> Brandestiamtelist= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> Brandestiamtelist1= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> BrandestiamtelistQuery = [SELECT ID,AF_Agency__c FROM AF_Brand_Estimate__c WHERE ID IN : Brandestiamtelist LIMIT 1];
			System.assertEquals(BrandestiamtelistQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(Brandestiamtelist);
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagencyBulk(Brandestiamtelist);
			Test.stopTest();
		}
	}
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : UpdateBrandEstimateCatApproverValues5
*  @param : none
*  @return : none
*************************************************************************/  
	Static testMethod void UpdateBrandEstimateCatApproverValues5()
	{   Test.startTest();
		userForupdateoopsEstcatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
		User u=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover.id LIMIT 1];
		userForupdateoopsEstcatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
		User u1=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover1.id LIMIT 1];
		userForupdateoopsEstcatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR4(true);
		User u2=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover2.id LIMIT 1];
		userForupdateoopsEstcatApprover3=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
		User u3=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover3.id LIMIT 1];
		userForupdateoopsEstcatApprover4=AF_TestFactory_Helper.createUserADMINSTRATOR3(true);
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
			List<contact> con  = AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con1 = AF_TestFactory_Helper.AFInsertContact1(1,true);
			List<contact>con2 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact>con3 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact>con4 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact>con5 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact>con6 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact>con7 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact>con8 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact>con9 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact> conQuery = [SELECT id FROM contact LIMIT 1];
			System.Assert(conQuery[0].Id != null, AF_TestFactory_Helper.CONTACT_RECORD);
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
			list<AF_Brand_Estimate__c> Brandlist=new list<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br : BrandEst){
				br.AF_AgencyUsers1__c=u.Email;
				br.AF_Active__c = true;
				br.AF_Copied__c= false;
				br.AF_Locked__c = false;
				Brandlist.add(br);
			}
			insert Brandlist;
			List<AF_Brand_Estimate__c> bran= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> bran1= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> bran2= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//insert OOPs Actual.
			List<AF_Brand_Estimate__c> Brandestiamtelist= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> Brandestiamtelist1= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> BrandestiamtelistQuery = [SELECT ID,AF_Agency__c FROM AF_Brand_Estimate__c WHERE ID IN : Brandestiamtelist LIMIT 1];
			System.assertEquals(BrandestiamtelistQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(Brandestiamtelist);
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagencyBulk(Brandestiamtelist);
			Test.stopTest();
		}
	}
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : UpdateBrandEstimateCatApproverValues6
*  @param : none
*  @return : none
*************************************************************************/  
	Static testMethod void UpdateBrandEstimateCatApproverValues6()
	{   Test.startTest();
		userForupdateoopsEstcatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
		User u=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover.id LIMIT 1];
		userForupdateoopsEstcatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
		User u1=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover1.id LIMIT 1];
		userForupdateoopsEstcatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR4(true);
		User u2=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover2.id LIMIT 1];
		userForupdateoopsEstcatApprover3=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
		User u3=[SELECT id,Email FROM user WHERE id=:userForupdateoopsEstcatApprover3.id LIMIT 1];
		userForupdateoopsEstcatApprover4=AF_TestFactory_Helper.createUserADMINSTRATOR3(true);
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
			List<contact> con  = AF_TestFactory_Helper.AFInsertContact(1,true);
			List<contact> con1 = AF_TestFactory_Helper.AFInsertContact1(1,true);
			List<contact>con2 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact>con3 = AF_TestFactory_Helper.AFInsertContact2(1,true);
			List<contact> conQuery = [SELECT id FROM contact LIMIT 1];
			System.Assert(conQuery[0].Id != null, AF_TestFactory_Helper.CONTACT_RECORD);
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
			list<AF_Brand_Estimate__c> Brandlist=new list<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br : BrandEst){
				br.AF_AgencyUsers1__c=u.Email;
				br.AF_Active__c = true;
				br.AF_Copied__c= false;
				br.AF_Locked__c = false;
				Brandlist.add(br);
			}
			insert Brandlist;
			List<AF_Brand_Estimate__c> bran= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> bran1= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> bran2= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//insert OOPs Actual.
			List<AF_Brand_Estimate__c> Brandestiamtelist= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> Brandestiamtelist1= AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> BrandestiamtelistQuery = [SELECT ID,AF_Agency__c FROM AF_Brand_Estimate__c WHERE ID IN : Brandestiamtelist LIMIT 1];
			System.assertEquals(BrandestiamtelistQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(Brandestiamtelist);
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagencyBulk(Brandestiamtelist);
			Test.stopTest();
		}
	}
}