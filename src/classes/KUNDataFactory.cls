@isTest 
public class KUNDataFactory { 


    private static string  mstrLocaleKey = 'en_US';
    private static string  mstrContCapacity = 'North Asia';
    private static string  mstrCapability = 'Make';
    
    /*******************************************************************
    Purpose: This method is used to create a User & KUN Profile record 
    Parameters : Id  - Parent Record Id
    ********************************************************************/
    public static void createTestUserRecords() {
    
     // Setup test data
      // This code runs as the system user
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     // Creating the Collaboration Group for Chatter Posts     
     //Group name must be unique
     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         CollaborationGroup myGroup =new CollaborationGroup( Name = 'KUN Test Collaboration Group' ,  
         CollaborationType = 'Private', CanHaveGuests = false, IsArchived = false,IsAutoArchiveDisabled = true);
         Insert myGroup;
   
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // Creating the Users
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          User u1 = new User(Alias = 'stand1', Email='standarduser1@kunorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey= mstrLocaleKey , 
          LocaleSidKey=mstrLocaleKey , ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@kunorg.com');
          
          Insert u1  ;
          // Creating the User's KUN Profile
          KUN_Profile__c moProfile1 = new KUN_Profile__c( Name ='Testing -1',Unilever_Profile__c = u1.Id,Capability__c=mstrCapability  , 
          Cluster__c = mstrContCapacity  ,E2E_Process__c='Make-to-Deliver (M2D)' ,Employee_Type__c='Unilever');      
          Insert moProfile1 ;      
          
          moProfile1.KUN_Role_Type__c ='Full Time';
          Update moProfile1;
          
         CollaborationGroupMember groupMember = new CollaborationGroupMember();
            groupMember.memberid = u1.Id; //id of User you wish to add
            groupMember.CollaborationGroupId = myGroup.Id; //Id of group created above
            insert groupMember; 
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // Creating the Users
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         
      User u2 = new User(Alias = 'standt2', Email='standarduser2@kunorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey=mstrLocaleKey , 
      LocaleSidKey=mstrLocaleKey , ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2@kunorg.com');
      
      Insert u2 ;
    
      KUN_Profile__c moProfile2 = new KUN_Profile__c( Name ='Testing-2',Unilever_Profile__c = u2.Id,Capability__c = mstrCapability  , Cluster__c =  mstrContCapacity  ,E2E_Process__c='Make-to-Deliver (M2D)' ,Employee_Type__c='Unilever');
      
      Insert moProfile2 ;
      moProfile2 .KUN_Role_Type__c ='Full Time';
      Update moProfile2 ;
      
     groupMember = new CollaborationGroupMember();
       groupMember.memberid = u2.Id; //id of User you wish to add
       groupMember.CollaborationGroupId = myGroup.Id; //Id of group created above
       insert groupMember; 

      
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // Creating the Users
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      User u3 = new User(Alias = 'standt3', Email='standarduser3@kunorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey=mstrLocaleKey , 
      LocaleSidKey=mstrLocaleKey , ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser3@kunorg.com');

      Insert u3 ;
    
      KUN_Profile__c moProfile3 = new KUN_Profile__c( Name ='Testing-3',Unilever_Profile__c = u3.Id,Capability__c=mstrCapability  , Cluster__c = mstrContCapacity  ,E2E_Process__c='Make-to-Deliver (M2D)' ,Employee_Type__c='Unilever');
      
      Insert moProfile3 ;
      moProfile3 .KUN_Role_Type__c ='Full Time';
      Update moProfile3 ;
      
      groupMember = new CollaborationGroupMember();
      groupMember.memberid = u3.Id; //id of User you wish to add
      groupMember.CollaborationGroupId = myGroup.Id; //Id of group created above
      insert groupMember;          
    }
 
       
     
    /*******************************************************************
    Purpose: This method is used to create a Global event & Standred Events record 
    Parameters : numRecords- Number of the Record to be created 
    ********************************************************************/
    public static void createTestActionRecords(Integer numRecords , Id UserId) {      
       List<KUN_Activities__c> molstEvents = new List<KUN_Activities__c>() ;              
       RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType='KUN_Activities__c' AND DeveloperName ='KUN_Actions_RT' LIMIT 1];
             
       for(Integer iCount =0; iCount < numRecords; iCount++ ){
            
            KUN_Activities__c moActivity       =  new KUN_Activities__c ();
            moActivity.Name                    =  'Event Name - ' + iCount ;           
            moActivity.Short_Description__c    =  'Event Description';
            moActivity.URL__c                  =  'http://google.com';              
            moActivity.Active__c               =  true ;
            moActivity.RecordTypeId            =  rt.Id;
            molstEvents.add( moActivity);
          }
        Insert molstEvents ;
        
         List<Task> lstNewTasks = new List<Task>();
         for(Integer iCount =0; iCount < numRecords; iCount++ ){
            Task e = new Task();
            e.ActivityDate= Date.today().AddDays(iCount) ;
            e.Subject =  'Event Name - ' + iCount ;
            e.Status='Active';
            e.Description='Description';
            e.OwnerId = UserId;
            lstNewTasks.add(e);
          }

          insert lstNewTasks ;


     }    
    
    /*******************************************************************
    Purpose: This method is used to create a Quick Link records in 'KUN_Activities__c' object 
    Parameters : numRecords - Number of Quicklink records need to created 
    ********************************************************************/
    public static void createTestQuickLinkRecords(Integer numRecords) {     
       List<KUN_Activities__c> molstActivities = new List<KUN_Activities__c>() ;              
       RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType='KUN_Activities__c' AND DeveloperName ='KUN_Quick_Link' LIMIT 1];
    
        for(Integer iCount =0 ; iCount < numRecords; iCount++ )
        {
            KUN_Activities__c moActivity       =  new KUN_Activities__c ();
            moActivity.Name                    =  'Quick Link - ' + iCount ;           
            moActivity.Short_Description__c    =  'Quick Link Description';
            moActivity.URL__c                  =  'http://google.com' ;
            moActivity.Active__c               =  true ;
            moActivity.RecordTypeId            =  rt.Id;
            molstActivities.add( moActivity);
        }   
       Insert molstActivities ;     
    } 
         
    /*******************************************************************
    Purpose: This method is used to create a document type record in 'KUN_Activities__c' object 
    ********************************************************************/
    public static void createTestDocumentsTypeRecords(Integer numRecords) {     
       List<KUN_Activities__c> molstActivities = new List<KUN_Activities__c>() ;              
       RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType='KUN_Activities__c' AND DeveloperName ='KUN_Training_Documents' LIMIT 1];
    
        for(Integer iCount =0 ; iCount < numRecords; iCount++ )
        {        
            KUN_Activities__c moActivity       =  new KUN_Activities__c ();
            moActivity.Name                    =  'Compliance Process Indicator Document - ' + iCount ;           
            moActivity.Short_Description__c    =  'Document Description';
            moActivity.Active__c               =  true ;
            moActivity.RecordTypeId            =  rt.Id;
            molstActivities.add( moActivity);
        }        
        Insert molstActivities ;
        for( KUN_Activities__c moActivity: molstActivities){
           createTestAttachmentRecord(moActivity.Id);
        }   
    } 

    
     public static void createTestSubProcessNamesRecords(string ProcessArea) {     
       
       List<KUN_Activities__c> molstActivities = new List<KUN_Activities__c>() ;              
       RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType='KUN_Activities__c' AND DeveloperName ='KUN_Experts_RT' LIMIT 1];
    
        KUN_Activities__c moActivity = new KUN_Activities__c();
        
        moActivity =  new KUN_Activities__c( Name = 'Make- Plant Maintenance and Engineering-North Asia' ,
                                                              Cluster__c=  mstrContCapacity , Expert_Group__c ='standarduser1@kunorg.com;standarduser3@kunorg.com;standarduser2@kunorg.com',      
                                                              Process_Area__c=ProcessArea,Sub_Process_Area__c ='Plant Maintenance and Engineering', Active__c = true , RecordTypeId  =  rt.Id);
        molstActivities.add( moActivity);
        moActivity =  new KUN_Activities__c( Name = 'Make- Quality Management-North Asia' ,
                                                              Cluster__c=  mstrContCapacity , Expert_Group__c ='standarduser1@kunorg.com;standarduser3@kunorg.com;standarduser2@kunorg.com',      
                                                              Process_Area__c=ProcessArea,Sub_Process_Area__c ='Quality Management', Active__c = true , RecordTypeId   =  rt.Id);
        molstActivities.add( moActivity);
        moActivity =  new KUN_Activities__c( Name = 'Make- Manufacturing-North Asia' ,
                                                              Cluster__c=  mstrContCapacity , Expert_Group__c ='standarduser1@kunorg.com;standarduser3@kunorg.com;standarduser2@kunorg.com',      
                                                              Process_Area__c = ProcessArea,Sub_Process_Area__c ='Manufacturing', Active__c = true ,RecordTypeId    =  rt.Id);
        molstActivities.add( moActivity);

        INSERT molstActivities;
     }        
  
    
    

    /*******************************************************************
    Purpose: This method is used to create a Attchment record in standred object for testing data
    Parameters : Id  - Parent Record Id
    ********************************************************************/

    public static void createTestAttachmentRecord(Id recordId) {
        
        Attachment attach=new Attachment(); 
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob; 
        attach.parentId=recordId; 
        attach.ContentType = 'application/msword'; 
        attach.IsPrivate = false; 
        attach.Description = 'Test'; 
        insert attach; 
     }
     
   
 }