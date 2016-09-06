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
2.0     Dinesh   22/08/2016  DEVELOPMENT
***********************************************************************/

public with sharing class FS_ContactDetailHelper_CC{
    public FS_GetSiteLeadResult GetSiteLeadResult {get;set;}
    public with sharing class FS_GetSiteLeadResult {
        public Integer errorCode;   //0
        public String message;  //???????? ?????????
        public FS_SiteLead SiteLead{get;set;}
        public boolean success;
        public List<FS_Warnings> warnings = new list<FS_Warnings>();
    }
    
    public virtual without sharing class FS_SiteLeadMainchild {
    
              
                public String MaritalStatus;    //Married
                public String SocialStatus; //socialStatus
                public String PropertyStatus;   //propertyStatus
                public String Profession;   //Developer
                public Integer Income;   //70000
                public String PassportNumber;   //3606789654
                public boolean personalDataAgree;
                public Integer age; //28
                public String birthDate;    //1987-01-12
                public String facebookId;   //897384
              
    }
    
    public virtual without sharing class FS_SiteLeadMainchildAdress extends FS_SiteLeadMainchild  {
    
                public String Address;  //address-1, 4 - 33
                public String City; //city1
                public String BusinessPostalCode;   //449543 
                public String Country;  //Russia
    }
    
    public with sharing  class FS_SiteLead extends FS_SiteLeadMainchildAdress  {
   
       
            public String businessAddress;  //
            public  String businessName; //OOO MTC
            public String Email{get;set;}   //
            Public List<FS_ExtraParameters> extraParameters = new list<FS_ExtraParameters>();
            public String Firstname{get;set;}    //
            public String gender;   //Male
            public String id;   //414c01d6-48fa-4578-9bfb-cf1b9c01335c
            public String jobTitle; //
            public String landlinePhone;    //
            public String Middlename{get;set;}   //middleName
            public String okId; //0294485
            public String Phone{get;set;}    //
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