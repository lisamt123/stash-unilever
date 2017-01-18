@IsTest 
Public class Kun_Community_Test {
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Initial Test Data
    //Add Logic to Create data required
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    static Kun_HomeView_CC instance = null;
    
    @testSetup
    static void UserProfileSetup() {
        KUNDataFactory.createTestUserRecords();
    }
    
    static void SetUp(){     
        test.StartTest(); 
        instance = new Kun_HomeView_CC();          
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Tear Down 
    //Add Logic to delete data that has been created
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    static void TearDown(){
        test.StopTest();
    }
    
    public static testmethod void Test_AllContructors_Positive(){
       SetUp();
       User u2 = [Select Id ,Name ,UserName, Email FROM User WHERE UserName='standarduser1@kunorg.com' LIMIT 1];
       System.runAs(u2) {
            Kun_HomeView_CC instance1 = new Kun_HomeView_CC();        
       } 
      TearDown();
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     public static testmethod void Test_AllContructors_Negative(){
       SetUp();
       
      // Setup test data
      // This code runs as the system user
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
  
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // Creating the Users
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          User u1 = new User(Alias = 'stand1', Email='standarduser11@kunorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser11@kunorg.com');          
          Insert u1  ;
                      
        System.runAs(u1) {
            Kun_HomeView_CC instance1 = new Kun_HomeView_CC();        
       } 
      TearDown();
    }

   ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // Test_AllProperties
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public static testmethod void Test_AllProperties(){
        SetUp();
        // Test Property: MyEvents
        instance.MyEvents = new List<KUN_Links>();
        System.Assert(instance.MyEvents != null);
        
        // Test Property: DateFrom
        instance.DateFrom = '';
        System.Assert(instance.DateFrom == '');
        
        // Test Property: DateTo
        instance.DateTo = '';
        System.Assert(instance.DateTo == '');
        
        // Test Property: DocumentType
        instance.DocumentType = '';
        System.Assert(instance.DocumentType == '');
        
        // Test Property: TaskLink
        
        string strTaskLink = '/00T/e?retURL='+EncodingUtil.urlEncode('/apex/Kun_HomeView','UTF-8');
        System.Assert(instance.TaskLink == strTaskLink );
        
        // Test Property: Question
        instance.Question = '';
        System.Assert(instance.Question == '');
        
        // Test Property: HighlightEvents
        instance.HighlightEvents = new List<KUN_Links>();
        System.Assert(instance.HighlightEvents != null);
        
        // Test Property: UserProfile
        instance.UserProfile = new KUN_Profile__C();
        System.Assert(instance.UserProfile != null);
        
        // Test Property: ProcessName
        instance.ProcessName = '';
        System.Assert(instance.ProcessName == '');
        
        // Test Property: SubProcessName
        instance.SubProcessName = '';
        System.Assert(instance.SubProcessName == '');
        
        TearDown();
    }
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       // Test Method: RefreshEvents
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
    public static testmethod void Test_RefreshEvents(){
        SetUp();
        
        User u2 = [Select Id ,Name ,UserName, Email FROM User WHERE UserName='standarduser1@kunorg.com' LIMIT 1];
        System.runAs(u2) {
            PageReference pageRef = Page.Kun_HomeView; 
            Test.setCurrentPage(pageRef); 

            datetime datefrom = System.Now();
            datetime dateto = System.Now().Adddays(6) ;
             
            List<KUN_Activities__c> molstEvents = new List<KUN_Activities__c>() ;              
            RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType='KUN_Activities__c' AND DeveloperName ='KUN_Events_RT' LIMIT 1];
            KUN_Activities__c moActivity  ;
           for(Integer iCount =0; iCount < 5 ; iCount++ ){            
                moActivity       =  new KUN_Activities__c ();
                moActivity.Name                    =  'Event Name - ' + iCount ;           
                moActivity.Short_Description__c    =  'Event Description - ' + iCount ;           
                moActivity.Start_Date__c           =  Datetime.Now().AddDays(iCount) ;   
                moActivity.Active__c               =  true ;
                moActivity.RecordTypeId            =  rt.Id;
                molstEvents.add( moActivity);
              }
            Insert molstEvents ;
        
           /* List<Event > lstNewEvents = new List<Event>();
            for(Integer iCount =0; iCount < 5; iCount++ ){
                Event e = new Event();
                e.StartDateTime = Datetime.Now().AddDays(iCount) ;
                e.EndDateTime = Datetime.Now().AddDays(iCount) ;
                e.Subject =  'Event Name - ' + iCount ;
                e.OwnerId = U2.Id;
                lstNewEvents.add(e);
              }

            insert lstNewEvents;
*/       
            // Add parameters to page URL 
            ApexPages.currentPage().getParameters().put('DateFrom', datefrom.format('MM/dd/yyyy') ); 
            ApexPages.currentPage().getParameters().put('DateTo', dateto.format('MM/dd/yyyy') ); 
            instance.RefreshEvents() ;      
            System.Assert(instance.MyEvents.Size() == 5);
           }
        TearDown();
    }
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       // Test Method: DocumentLink
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
    public static testmethod void Test_DocumentLink(){
        SetUp();        
        System.Assert(instance.DocumentLink() != null);
        TearDown();
    }
    // Test Method: getDocumentTypes
    public static testmethod void Test_getDocumentTypes(){
        SetUp();       
        System.Assert(instance.getDocumentTypes() != null);
        TearDown();
    }
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     // Test Method: SubmitQuestion
     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
    public static testmethod void Test_SubmitQuestion(){
        SetUp();
        User u2 = [Select Id ,Name ,UserName, Email FROM User WHERE UserName='standarduser1@kunorg.com' LIMIT 1];
         System.runAs(u2) {
            instance.Question = ' Test Question for Apex Testing';
            instance.ProcessName ='Make';
            instance.SubProcessName ='Quality Management';
            instance.IsTest =true;
            KUNDataFactory.createTestSubProcessNamesRecords(instance.ProcessName);
            instance.SubmitQuestion() ;
            
            System.Assert( instance.Question == '');
            }
        TearDown();
    }
    // Test Method: getQuickLinks
    public static testmethod void Test_getQuickLinks(){
        SetUp();
        Integer iCount = 5 ;
        KUNDataFactory.createTestQuickLinkRecords(iCount );
        List<KUN_Activities__c> molstActivities = instance.getQuickLinks() ;
        
        System.Assert(molstActivities.size()== iCount );
        TearDown();
    }
    // Test Method: getActions
    public static testmethod void Test_getActions(){
        SetUp();
         User u2 = [Select Id ,Name ,UserName, Email FROM User WHERE UserName='standarduser1@kunorg.com' LIMIT 1];
         System.runAs(u2) {
            Integer iCount = 5 ;
            KUNDataFactory.createTestActionRecords(iCount, u2.Id);       
            List<KUN_Links> moActivities = instance.getActions() ;      
            System.Assert(moActivities.Size() == (iCount*2) );
           }
          TearDown();
    }
    // Test Method: getNotify
    public static testmethod void Test_getNotify(){
        SetUp();
        Integer numRecords= 5 ;       
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType='KUN_Activities__c' AND DeveloperName ='KUN_Broadcast_Message_RT' LIMIT 1];
        List<KUN_Activities__c> molstActivities  = new  List<KUN_Activities__c>();
        for(Integer iCount =0 ; iCount < numRecords; iCount++ )
        {
            KUN_Activities__c moActivity       =  new KUN_Activities__c ();
            moActivity.Name                    =  'Notification - ' + iCount ;           
            moActivity.Short_Description__c    =  'Notification Description';
            moActivity.Active__c               =  true ;
            moActivity.RecordTypeId            =  rt.Id;
            molstActivities.add( moActivity);
        }   
        Insert molstActivities ;  
        molstActivities = instance.getNotify() ;
        
        System.Assert(molstActivities.size()== numRecords);
        TearDown();
    }
    // Test Method: getFactFigure
    public static testmethod void Test_getFactFigure(){
        SetUp();        
        System.Assert(instance.getFactFigure() != null);
        TearDown();
    }
    // Test Method: getDocumentsbyType
    public static testmethod void Test_getDocumentsbyType(){
        SetUp();     
        Integer iCount = 5 ;
        KUNDataFactory.createTestDocumentsTypeRecords(iCount );           
        System.Assert(instance.getDocumentsbyType().Size() == iCount );
        TearDown();
    }
    // Test Method: getIsForceUI
    public static testmethod void Test_getIsForceUI(){
        SetUp();        
        System.Assert(instance.getIsForceUI() == true);
        TearDown();
    }
    // Test Method: getProcessNames
    public static testmethod void Test_getProcessNames(){
        SetUp();        
        System.Assert(instance.getProcessNames() != null);
        TearDown();
    }
    // Test Method: getSubProcessNames
    public static testmethod void Test_getSubProcessNames(){
        SetUp();
        User u2 = [Select Id ,Name ,UserName, Email FROM User WHERE UserName='standarduser1@kunorg.com' LIMIT 1];
        System.runAs(u2) {
            instance.ProcessName='Make';
            KUNDataFactory.createTestSubProcessNamesRecords(instance.ProcessName);
            List<selectOption> moselectOptions = instance.getSubProcessNames();             
            System.Assert(moselectOptions.Size()==4);
        }
        TearDown();
    }
    // Test Method: getNewJoiners
    public static testmethod void Test_getNewJoiners(){
        SetUp();        
        List<KUN_Profile__c> molstNewJoiners =  instance.getNewJoiners() ;
        System.Assert(molstNewJoiners.size()==3 );
        TearDown();
    }
    // Test Method: getNewsLetters
    public static testmethod void Test_getNewsLetters(){
       SetUp(); 
       Integer numRecords= 5 ;
       List<KUN_Activities__c> molstNewsLetters = new List<KUN_Activities__c>() ;              
       RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType='KUN_Activities__c' AND DeveloperName ='KUN_News_Letter_RT' LIMIT 1];
      
       for(Integer intloopCount =0 ; intloopCount < numRecords; intloopCount ++ )
       {
            KUN_Activities__c moActivity       =  new KUN_Activities__c ();
            moActivity.Name                    =  'News Letter Name - ' + intloopCount ;           
            moActivity.Short_Description__c    =  'News Letter Short Description';
            moActivity.Active__c               =  true ;
            moActivity.RecordTypeId            =  rt.Id;
            molstNewsLetters .add( moActivity);
       }
       
       Insert molstNewsLetters ;       
       for( KUN_Activities__c moNewsLetter: molstNewsLetters){
           KUNDataFactory.createTestAttachmentRecord(moNewsLetter.Id);
       }        
       List<KUN_Links> molstLinks= instance.getNewsLetters() ;        
       System.Assert(molstLinks!= null);
       TearDown();
    }
    // Test Method: getNews
    public static testmethod void Test_getNews(){
        SetUp();
        Integer numRecords= 5 ;
       List<KUN_Activities__c> molstActivities = new List<KUN_Activities__c>() ;              
       RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType='KUN_Activities__c' AND DeveloperName ='KUN_News_RT' LIMIT 1];
      
       for(Integer iCount =0 ; iCount < numRecords; iCount++ )
       {
            KUN_Activities__c moActivity       =  new KUN_Activities__c ();
            moActivity.Name                    =  'Global Business - ' + iCount ;           
            moActivity.Short_Description__c    =  'News Description ';
            moActivity.Description__c          =  'News Complete Description' ;
            moActivity.Active__c               =  true ;
            moActivity.RecordTypeId            =  rt.Id;
            molstActivities .add( moActivity);
       }
       
       Insert molstActivities ;       
       for( KUN_Activities__c moActivity: molstActivities ){
           KUNDataFactory.createTestAttachmentRecord(moActivity.Id);
       }        
       List<KUN_Links> molstLinks= instance.getNews();
       System.Assert(molstLinks.size()== numRecords);
       TearDown();
    }
    // Test Method: getEventLink
    public static testmethod void Test_getEventLink(){
        SetUp();
        string strLinkURL='/00U/e?retURL='+EncodingUtil.urlEncode('/apex/Kun_HomeView','UTF-8');
        System.Assert(instance.getEventLink() == strLinkURL);
        TearDown();
    }
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     // Test Method: getKey
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
    public static testmethod void Test_getKey(){
        SetUp();        
        Integer numRecords= 5 ;
        List<KUN_Activities__c> molstActivities = new List<KUN_Activities__c>() ;              
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType='KUN_Activities__c' AND DeveloperName ='KUN_Spotlight_RT' LIMIT 1];
    
        for(Integer iCount =0 ; iCount < numRecords; iCount++ )
        {        
            KUN_Activities__c moActivity       =  new KUN_Activities__c ();
            moActivity.Name                    =  'Key User Name - ' + iCount ;           
            moActivity.Short_Description__c    =  'Spotlight Description';
            moActivity.Active__c               =  true ;
            moActivity.RecordTypeId            =  rt.Id;
            molstActivities.add( moActivity);
        }        
        Insert molstActivities ;
        for( KUN_Activities__c moActivity: molstActivities){
           KUNDataFactory.createTestAttachmentRecord(moActivity.Id);
        } 
        List<KUN_Links> molstLinks = instance.getKey() ;
        
        System.Assert(molstLinks.size()==numRecords);
        TearDown();
    }
  }