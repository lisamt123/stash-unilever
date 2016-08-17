/**********************************************************************
Name: FS_ContactDetailHelper_CC
======================================================
======================================================
Purpose: For Displaying Contact in Vf page fetching from 
Brandtone.
-------
======================================================
======================================================
History
-------
VERSION AUTHOR   DATE        DETAIL Description
1.0     santhosh 22/07/2016 INITIAL DEVELOPMENT 
***********************************************************************/

public with sharing class FS_ContactDetailHelper_CC_v1{
    public cls_AddSiteLeadResult AddSiteLeadResult;
	public class cls_AddSiteLeadResult {
		public Integer ErrorCode;	//0
		public String Message;	//???????? ?????????
		public cls_SiteLead SiteLead;
		public boolean Success;
		public List<FS_Warnings> warnings = new list<FS_Warnings>();
	}
	public class cls_SiteLead {
		public String Address;	//address-1, 4 - 33
		public Integer Age;	//28
		public String BirthDate;	//1987-01-12
		public String BusinessAddress;	//
		public String BusinessName;	//OOO MTC
		public String BusinessPostalCode;	//449543
		public String City;	//city1
		public String Country;	//Russia
		public String Email;	//tolmachev@example.com
		public List<FS_ExtraParameters> extraParameters = new list<FS_ExtraParameters>();
		public String FacebookId;	//897384
		public String Firstname;	//Tol
		public String Gender;	//Male
		public String Id;	//feff7eae-f646-4ba5-987f-ecd265e498f0
		public Integer Income;	//70000
		public String JobTitle;	//
		public String LandlinePhone;	//89345673245
		public String MaritalStatus;	//Married
		public String Middlename;	//middleName
		public String OkId;	//0294485
		public String PassportNumber;	//3606789654
		public boolean PersonalDataAgree;
		public String Phone;	//89270087098
		public String PropertyStatus;	//propertyStatus
		public String SocialStatus;	//socialStatus
		public String Surname;	//Machev
		public String Username;	//Tolmachev
		public String VkId;	//789347503
	}
    public with sharing class FS_ExtraParameters {
        Public String name; //Number of pets
        Public String value;    //2
    }
    public with sharing class FS_Warnings {
    }
    
  /* * function for  returing JSON value
*  @name parse
*  @param String 
*  @return FS_contactDetailHelper_CC
*  @throws 
*/ 
    
    public static FS_ContactDetailHelper_CC_v1 parse(String json){
        try{
            return (FS_ContactDetailHelper_CC_v1) System.JSON.deserialize(json, FS_ContactDetailHelper_CC_v1.class);
            }
        catch(System.CalloutException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.ERRORMESSAGETEXT));
                return null;
            }
    }
    
}