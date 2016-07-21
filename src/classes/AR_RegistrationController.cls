// Timeline:
// 2013-09-19 09:48 | Marc Saelzler | Changed the init, to get an application id used as an identifier within the page. 

public with sharing class AR_RegistrationController {
    
    //constructor
    
    //create application method
    
    // next button to start application, pass application id
    //***************************
    //Attributes
    //***************************
    
    public AR_CaptchaHelper CaptchaHandler
    {
        get;
        set;
    } 
    
    
    public AR_SObjectHolder ApplicationObject
    {
        get
        {
            if(ApplicationObject == null)
            {
                ApplicationObject = new AR_SObjectHolder();
                ApplicationObject.obj = new ar_Application__c();
            }
            return ApplicationObject;
        }
        set;
    }
    public Map<String,Map<String,List<SelectOption>>> FieldNamePicklistOptions 
    {
        get;
        set;
    }
    
    public Map<String,Map<String,List<Schema.FieldSetMember>>> FieldSetMap
    {
        get;
        set;
    }
    
    public String x_CookieId;
    //***************************
    //Constructor
    //***************************
    
    public AR_RegistrationController()
    {
        CaptchaHandler = new AR_CaptchaHelper();
    }
    
    public void InitPage()
    {
        GetAllApplicationMetaData();
        
        x_CookieId = this.CheckCookie();
        
        if(x_CookieId == null)
        {
            CreateAgencyQuestionnaireData();
        }
    }
    
    public void GetAllApplicationMetaData()
    {
            this.FieldSetMap = new Map<String,Map<String,List<Schema.FieldSetMember>>>();
            this.FieldSetMap.put('ar_Application__c',AR_MetaDataHandler.GetAllApplicationFieldsets());  
            
            this.FieldNamePicklistOptions = new Map<String,Map<String,List<SelectOption>>>();
            this.FieldNamePicklistOptions.put('ar_Application__c',AR_MetaDataHandler.GetPicklistValuesForFieldsInObject('ar_Application__c'));
    }
    
    public void CreateAgencyQuestionnaireData()
    {
            AR_SObjectHolder tmp_class = new AR_SObjectHolder();
            tmp_class.obj =         new ar_Application__c();
            
            if(x_CookieId != null)
            {
                tmp_class.obj.Id = x_CookieId;
            }
            
            ApplicationObject       = tmp_class;
    }   
    
    
    public void SaveApplication()
    {   
        // Don't debug this, CaptchaHandler.verify() will return false 2nd time around
        if(CaptchaHandler.verify())//CaptchaHandler.verify()
        {
            upsert ApplicationObject.obj;
            
            System.Debug('#ApplicationObject.obj: ' + ApplicationObject.obj);
            
            AR_SessionHandler.SetCookie((String)ApplicationObject.getId());
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Captcha text you have doesn\'t match the image, please try again.'));
        }
    }   
    
    public String CheckCookie()
    {
        String tmp_CookieID = AR_SessionHandler.GetAgencyId();
        if(tmp_CookieID != null)
        {
            return tmp_CookieID;
        }
        return null;
    }   
    
    public PageReference goOnWithTheProcess()
    {
        return Page.AR_SupplierCode;
    }
    
    public PageReference Logout()
    {
        PageReference tmp_pageRef = Page.AR_LandingPage;
        
        tmp_pageRef.setRedirect(true);
        
        AR_SessionHandler.CloseSession();
        
        return tmp_pageRef;
    }
}