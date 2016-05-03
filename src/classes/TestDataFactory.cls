@isTest
public class TestDataFactory {
	
	public static Map<String, Id> recordTypeMap 
	{
		get {
			if (recordTypeMap == null)
			{
				recordTypeMap = new Map<String, Id>();
				for (RecordType rt :[Select Id, DeveloperName From RecordType])
				{
					recordTypeMap.put(rt.DeveloperName, rt.Id);
				}
			}
			return recordTypeMap;
		}
		set;
	}

	public static ar_Application__c getApplication() {
		ar_Application__c app = new ar_Application__c();
		app.Additional_Information__c = 'Additional info of application';
		app.Address__c = '12 Lindsey st';
		app.Agree_to_Audits__c = 'Yes';
		app.Company_Name__c = 'Tquila';
		app.Contract_authority__c = 'Yes';
		app.Country__c = 'United Kingdom';
		app.D_B_Duns_Number__c = 'values for g b duns';
		app.Email__c = 'devs@tquila.com';
		app.First_Name__c = 'John';
		app.Last_Name__c = 'Wood';
		app.General_Email__c = 'general@tquila.com';
		app.General_Fax__c = '122034927982';
		app.General_Phone__c = '223749283749';
		app.Job_Title__c = 'Developer';
		app.Legal_Designation__c = 'Legal design';
		app.Ownership_Status__c = 'The ownership of the status';
		app.Phone_Landline__c = '34234234234';
		app.Phone_Mobile__c = '124242342';
		app.Postal_Code__c = 'N41ET';
		app.Status__c = 'Incomplete';
		app.Town_City__c = 'London';
		app.Website__c = 'www.tquila.com';
		app.Your_Title__c = 'Mr';
		app.Business_activity_types__c = 'what are the business activity types?';
		app.Agree_to_logo_use__c = 'Yes';
		
		return app;
	}
	
	public static ar_Experience__c getExpertise(Id applicationId) {
		RecordType rt = [select id from RecordType where SobjectType = 'ar_Experience__c' and developerName = 'Expertise'];
		ar_Experience__c exp = new ar_Experience__c();
		exp.Application__c = applicationId;
		exp.Market_Developing_Experience__c = 'a lot';
		exp.Client_Contact_Details__c = 'nice people';
		exp.recordTypeID = rt.id;
		return exp;
	}
	
	public static ar_Insurance_and_Policy__c getPolicy() {
		ar_Insurance_and_Policy__c policy = new ar_Insurance_and_Policy__c();
		policy.Policy__c = 'Training';
		return policy;
	}

	public static AR_CaptchaSettings__c getCaptchaSettings() {
		AR_CaptchaSettings__c settings = new AR_CaptchaSettings__c();
		settings.base_Url__c = 'http://captcha.setings';
    	settings.public_Key__c = 'r098f098sdv08sv098as09';
    	settings.private_Key__c = 'fa9fa89sd7f987s9f87fasdfaf';
    	return settings;
	}
	
	public static ar_Shareholder__c getShareholder()
	{
		ar_Shareholder__c shareholder = new ar_Shareholder__c();
		
		shareholder.Name = 'ShareHolderTest';
		
		return shareholder;
	}
	
	public static ar_Geography__c getGeography()
	{
		ar_Geography__c geography = new ar_Geography__c();
		
		geography.Name = 'GeographyTest';
		
		return geography;
	}
	
	public static Account getAccount(string recordTypeName)
	{
		Account account = new Account();
		account.Name = 'Test Account';
		account.Published__c = true;
		account.Featured__c = true;
		account.RecordTypeId = recordTypeMap.get(recordTypeName);
		
		return account;
		
	}
	
	public static ar_Rating_Review__c getReview(string agencyId)
	{
		ar_Rating_Review__c review = new ar_Rating_Review__c();
		review.Insight_Foresight__c = 1;
		review.Clarity_of_Strategy__c = 2;
		review.Collaboration_Fit__c = 3;
		review.Craft_Execution__c = 4;
		review.Creativity_Ideas__c = 5; 
		review.Value_for_Money__c = 6;
		review.Review__c = 'Test Review';
		review.Agency__c = agencyId;

		return review;
	}
	
	public static ar_Insurance_and_Policy__c getInsurance() {
		RecordType rt = [select id from RecordType where SobjectType = 'ar_Insurance_and_Policy__c' and developerName = 'Insurance'];
		ar_Insurance_and_Policy__c insurance = new ar_Insurance_and_Policy__c(RecordTypeId = rt.id);
		insurance.Insurance_Type__c = 'my custom type';
		insurance.Description__c = 'the best insurance ever';
		insurance.Start_Date_of_Policy__c = System.today().addMonths(-1);
		insurance.Expiration_date__c = System.today().addMonths(1);
		insurance.Provider__c = 'I dont know him';
		insurance.Level_of_Cover__c = '£5,000,000 or More';
		return insurance;
	}
	
	public static ar_Agency_Portal_CMS__c getCMS(String cmsType, String title, String body, Integer ord) {
		ar_Agency_Portal_CMS__c cms = new ar_Agency_Portal_CMS__c();
		cms.Title__c = title;
		cms.Body__c = body;
		cms.Type__c = cmsType;
		cms.order__c = ord;
		cms.Published__c = true;
		return cms;
	}
	
	public static AR_Fixed_Rate_Card_Questions__c getFixRateCardQuestion(String Name, String discipline, String taskGroup, Integer ord) {
		AR_Fixed_Rate_Card_Questions__c question = new AR_Fixed_Rate_Card_Questions__c();
		question.name = name;
		question.Definition__c = 'design bla bla';
		question.Discipline__c = discipline;
		question.Material_Costs_Included__c = 'Yes';
		question.Order__c = ord;
		question.Per_Item__c = 'variant (SKU)';
		question.Subject_to_Annual_Rebate_Scheme__c = 'Yes';
		question.Task_Group_short__c = taskgroup;
		question.Task_Group__c = taskgroup;
		return question;
	}
	
	public static AR_Insurance_Policy__c getInsuranceSetting(String name) {
		AR_Insurance_Policy__c p = new AR_Insurance_Policy__c();
		p.name = name;
		p.Description__c = 'Description efoafksafajdshf';
		p.type__c = 'Insurance';
		return p;
	}
	
	public static AR_Insurance_Policy__c getPolicySetting(String name) {
		AR_Insurance_Policy__c p = new AR_Insurance_Policy__c();
		p.name = name;
		p.Description__c = 'Description efoafksafajdshf';
		p.type__c = 'Policy';
		return p;
	}
}