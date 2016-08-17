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

public with sharing class FS_ContactDetailHelper_CC{
    public FS_GetSiteLeadResult GetSiteLeadResult {get;set;}
    public with sharing class FS_GetSiteLeadResult {
        private Integer errorCode;   //0
        Private String message;  //???????? ?????????
        public FS_SiteLead SiteLead{get;set;}
        Private boolean success;
        Private List<FS_Warnings> warnings = new list<FS_Warnings>();
    }
    public with sharing  class FS_SiteLead {
        public String Address{get;set;}  //address-1, 4 - 33
        Private Integer age; //28
        Private String birthDate;    //1987-01-12
        Private String businessAddress;  //
        Private String businessName; //OOO MTC
        public String BusinessPostalCode{get;set;}   //449543
        public String City{get;set;} //city1
        public String Country{get;set;}  //Russia
        public String Email{get;set;}   //
        Public List<FS_ExtraParameters> extraParameters = new list<FS_ExtraParameters>();
        Private String facebookId;   //897384
        public String Firstname{get;set;}    //
       // public Blob Firstname{get;set;}    //
        Private String gender;   //Male
        Private String id;   //414c01d6-48fa-4578-9bfb-cf1b9c01335c
        Private Integer income;  //70000
        Private String jobTitle; //
        Private String landlinePhone;    //
        public String MaritalStatus{get;set;}    //Married
        public String Middlename{get;set;}   //middleName
        Private  String okId; //0294485
        Private String passportNumber;   //3606789654
        Private boolean personalDataAgree;
        public String Phone{get;set;}    //
        Private String propertyStatus;   //propertyStatus
        Public String socialStatus; //socialStatus
        public String Surname{get;set;} //Machev
        Public String username; //
        Public String vkId; //789347503
        Public String  SecretKey;//f838b1bfd6ebf01ad4108cefcb0b859e
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
    
    public static FS_contactDetailHelper_CC parse(String json){
        try{
            return (FS_ContactDetailHelper_CC) System.JSON.deserialize(json, FS_contactDetailHelper_CC.class);
            }
        catch(System.CalloutException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.ERRORMESSAGETEXT));
                return null;
            }
    }
    
}