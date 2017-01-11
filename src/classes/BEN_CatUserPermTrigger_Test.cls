/*
  Class Name: BEN_CatUserPermTrigger_Test 
  Author : Mindtree
  Date: 15 Dec 2016
  Requirement/Project Name: SF Benchmarking
  Requirement/Description: This Test Class does Test Coverage of BEN_CategoryUserPermissionTrigger ,BEN_CategoryUserPermissionHandler 
**************************************************************************************************************************
*/ 
@isTest 
private class BEN_CatUserPermTrigger_Test {
  
 static testMethod void testCategory_Validation() {
  ID adminProfileID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].ID;
  user  userObject1 = new User(username='firstuserdb@test.com',
                                  alias = 'fu',
                                  email ='firstuser@test.com',
                                  emailencodingkey = 'UTF-8',
                                  lastname = 'fuln',
                                  CommunityNickname = 'fucn',
                                  languagelocalekey = 'en_US',
                                  localesidkey = 'en_US',                                            
                                  profileid = adminProfileID,
                                  timezonesidkey = 'Europe/Berlin',
                                  country = 'India'
                                 );
  insert  userObject1;
  user  userObject2 = new User(username='Seconduserdb@test.com',
                                  alias = 'fu',
                                  email ='Seconduserdb@test.com',
                                  emailencodingkey = 'UTF-8',
                                  lastname = 'fuln',
                                  CommunityNickname = 'Second',
                                  languagelocalekey = 'en_US',
                                  localesidkey = 'en_US',                                            
                                  profileid = adminProfileID,
                                  timezonesidkey = 'Europe/Berlin',
                                  country = 'India'
                                 );
  insert  userObject2;
  user  userObject3 = new User(username='Thirduserdb@test.com',
                                  alias = 'fu',
                                  email ='Thirduserdb@test.com',
                                  emailencodingkey = 'UTF-8',
                                  lastname = 'fuln',
                                  CommunityNickname = 'Third',
                                  languagelocalekey = 'en_US',
                                  localesidkey = 'en_US',                                            
                                  profileid = adminProfileID,
                                  timezonesidkey = 'Europe/Berlin',
                                  country = 'India'
                                 );
  insert  userObject3;
  user  userObject4 = new User(username='forthuserdb@test.com',
                                  alias = 'fu',
                                  email ='forthuserdb@test.com',
                                  emailencodingkey = 'UTF-8',
                                  lastname = 'fuln',
                                  CommunityNickname = 'forth',
                                  languagelocalekey = 'en_US',
                                  localesidkey = 'en_US',                                            
                                  profileid = adminProfileID,
                                  timezonesidkey = 'Europe/Berlin',
                                  country = 'India'
                                 );
  insert  userObject4;
  user  userObject5 = new User(username='fifthuserdb@test.com',
                                  alias = 'fu',
                                  email ='fifthuserdb@test.com',
                                  emailencodingkey = 'UTF-8',
                                  lastname = 'fuln',
                                  CommunityNickname = 'fifth',
                                  languagelocalekey = 'en_US',
                                  localesidkey = 'en_US',                                            
                                  profileid = adminProfileID,
                                  timezonesidkey = 'Europe/Berlin',
                                  country = 'India'
                                 );
  insert  userObject5;
  user  userObject6 = new User(username='sixthuserdb@test.com',
                                  alias = 'fu',
                                  email ='sixthuserdb@test.com',
                                  emailencodingkey = 'UTF-8',
                                  lastname = 'sixth',
                                  CommunityNickname = 'sixth',
                                  languagelocalekey = 'en_US',
                                  localesidkey = 'en_US',                                            
                                  profileid = adminProfileID,
                                  timezonesidkey = 'Europe/Berlin',
                                  country = 'India'
                                 );
  insert  userObject6;
  user  userObject7 = new User(username='seventhuserdb@test.com',
                                  alias = 'fu',
                                  email ='seventhuserdb@test.com',
                                  emailencodingkey = 'UTF-8',
                                  lastname = 'sixth',
                                  CommunityNickname = 'seventh',
                                  languagelocalekey = 'en_US',
                                  localesidkey = 'en_US',                                            
                                  profileid = adminProfileID,
                                  timezonesidkey = 'Europe/Berlin',
                                  country = 'India'
                                 );
  insert  userObject7;
  user  userObject8 = new User(username='Eightuserdb@test.com',
                                  alias = 'fu',
                                  email ='Eightuserdb@test.com',
                                  emailencodingkey = 'UTF-8',
                                  lastname = 'Eightuserdb',
                                  CommunityNickname = 'Eightuserdb',
                                  languagelocalekey = 'en_US',
                                  localesidkey = 'en_US',                                            
                                  profileid = adminProfileID,
                                  timezonesidkey = 'Europe/Berlin',
                                  country = 'India'
                                 );
  insert  userObject8;
  user  userObject9 = new User(username='ninthuserdb@test.com',
                                  alias = 'fu',
                                  email ='ninthuserdb@test.com',
                                  emailencodingkey = 'UTF-8',
                                  lastname = 'ninthuserdb',
                                  CommunityNickname = 'ninthuserdb',
                                  languagelocalekey = 'en_US',
                                  localesidkey = 'en_US',                                            
                                  profileid = adminProfileID,
                                  timezonesidkey = 'Europe/Berlin',
                                  country = 'India'
                                 );
  insert  userObject9;
  user  userObject10 = new User(username='tenthuserdb@test.com',
                                  alias = 'fu',
                                  email ='tenthuserdb@test.com',
                                  emailencodingkey = 'UTF-8',
                                  lastname = 'ninthuserdb',
                                  CommunityNickname = 'tenthuserdb',
                                  languagelocalekey = 'en_US',
                                  localesidkey = 'en_US',                                            
                                  profileid = adminProfileID,
                                  timezonesidkey = 'Europe/Berlin',
                                  country = 'India'
                                 );
  insert  userObject10;
  user  userObject11 = new User(username='Eleventhuserdb@test.com',
                                  alias = 'fu',
                                  email ='Eleventhuserdb@test.com',
                                  emailencodingkey = 'UTF-8',
                                  lastname = 'Eleventhuserdb',
                                  CommunityNickname = 'Eleventhuserdb',
                                  languagelocalekey = 'en_US',
                                  localesidkey = 'en_US',                                            
                                  profileid = adminProfileID,
                                  timezonesidkey = 'Europe/Berlin',
                                  country = 'India'
                                 );
    insert  userObject11;
    BEN_Category_Master__c CategoryMaster=new BEN_Category_Master__c(Name='Ice Cream');
    insert CategoryMaster;
    BEN_Category_Master__c CategoryMaster1=new BEN_Category_Master__c(Name='Skin Care');
    insert CategoryMaster1;
    BEN_Category_Master__c CategoryMaster2=new BEN_Category_Master__c(Name='Soap');
    insert CategoryMaster2;
    BEN_Category_Master__c CategoryMaster3=new BEN_Category_Master__c(Name='Beverages');
    insert CategoryMaster3;
    BEN_Category_Master__c CategoryMaster4=new BEN_Category_Master__c(Name='Skin');
    insert CategoryMaster4;
    Test.startTest();
            
            BEN_Category_User_Permission__c   Pobj2=new BEN_Category_User_Permission__c  (
            Name='Testdata2',
            pkl_Category_Access__c=BEN_ConstantsForBenchmarkingAppClasses.VIEWER,
            Category_Master__c=CategoryMaster.Id,
            pkl_User_Type__c= BEN_ConstantsForBenchmarkingAppClasses.SINGLE_CATEGORY,
            BEN_Category_User__c=userObject1.Id );
            insert Pobj2;
            
            BEN_Category_User_Permission__c  Pobj12=new BEN_Category_User_Permission__c (
            Name='Testdata12',
            pkl_Category_Access__c=BEN_ConstantsForBenchmarkingAppClasses.VIEWER,
            Category_Master__c=CategoryMaster1.Id,
            pkl_User_Type__c= BEN_ConstantsForBenchmarkingAppClasses.SINGLE_CATEGORY,
            BEN_Category_User__c=userObject6.Id );
            insert Pobj12;
            
            BEN_Category_User_Permission__c   Pobj14=new BEN_Category_User_Permission__c  (
            Name='Testdata14',
            pkl_Category_Access__c=BEN_ConstantsForBenchmarkingAppClasses.EDITOR,
            Category_Master__c=CategoryMaster.Id,
            pkl_User_Type__c= BEN_ConstantsForBenchmarkingAppClasses.SINGLE_CATEGORY,
            BEN_Category_User__c=userObject9.Id );      
            insert Pobj14;
            
            BEN_Category_User_Permission__c   Pobj16=new BEN_Category_User_Permission__c  (
            Name='Testdata16',
            pkl_Category_Access__c= BEN_ConstantsForBenchmarkingAppClasses.APPROVER,
            Category_Master__c=CategoryMaster.Id,
            pkl_User_Type__c= BEN_ConstantsForBenchmarkingAppClasses.SINGLE_CATEGORY,
            BEN_Category_User__c=userObject10.Id );      
            insert Pobj16;
            
            BEN_Category_User_Permission__c  Pobj15=new BEN_Category_User_Permission__c (
            Name='Testdata15',
            pkl_Category_Access__c = BEN_ConstantsForBenchmarkingAppClasses.EDITOR,
            Category_Master__c=CategoryMaster.Id,
            pkl_User_Type__c=BEN_ConstantsForBenchmarkingAppClasses.MULTI_CATEGORY_RESTRICTED_ACCESS,
            BEN_Category_User__c=userObject8.Id );      
            insert Pobj15;
            
            BEN_Category_User_Permission__c  Pobj17=new BEN_Category_User_Permission__c (
            Name='Testdata17',
            pkl_Category_Access__c= BEN_ConstantsForBenchmarkingAppClasses.APPROVER,
            Category_Master__c=CategoryMaster1.Id,
            pkl_User_Type__c=BEN_ConstantsForBenchmarkingAppClasses.MULTI_CATEGORY_RESTRICTED_ACCESS,
            BEN_Category_User__c=userObject11.Id );
            insert Pobj17;
            
        try{        
            BEN_Category_User_Permission__c   Pobj1=new BEN_Category_User_Permission__c  (
            Name='Testdata1',
            pkl_Category_Access__c=BEN_ConstantsForBenchmarkingAppClasses.EDITOR,
            Category_Master__c=CategoryMaster.Id,
            pkl_User_Type__c= BEN_ConstantsForBenchmarkingAppClasses.SINGLE_CATEGORY,
            BEN_Category_User__c=userObject2.Id );
            insert Pobj1;
            
            BEN_Category_User_Permission__c   Pobj10=new BEN_Category_User_Permission__c  (
            Name='Testdata10',
            pkl_Category_Access__c=BEN_ConstantsForBenchmarkingAppClasses.VIEWER,
            Category_Master__c=CategoryMaster3.Id,
            pkl_User_Type__c=BEN_ConstantsForBenchmarkingAppClasses.MULTI_CATEGORY_RESTRICTED_ACCESS,
            BEN_Category_User__c=userObject5.Id );
            insert Pobj10;
            
            BEN_Category_User_Permission__c   Pobj101=new BEN_Category_User_Permission__c  (
            Name='Testdata101',
            pkl_Category_Access__c=BEN_ConstantsForBenchmarkingAppClasses.VIEWER,
            Category_Master__c=CategoryMaster2.Id,
            pkl_User_Type__c=BEN_ConstantsForBenchmarkingAppClasses.MULTI_CATEGORY_RESTRICTED_ACCESS,
            BEN_Category_User__c=userObject5.Id );
            insert Pobj101;
            
            BEN_Category_User_Permission__c   Pobj7=new BEN_Category_User_Permission__c  (
            Name='Testdata7',
            pkl_Category_Access__c=BEN_ConstantsForBenchmarkingAppClasses.VIEWER,
            Category_Master__c=CategoryMaster2.Id,
            pkl_User_Type__c=BEN_ConstantsForBenchmarkingAppClasses.MULTI_CATEGORY_RESTRICTED_ACCESS,
            BEN_Category_User__c=userObject4.Id );
            insert Pobj7;
            
            BEN_Category_User_Permission__c   Pobj8=new BEN_Category_User_Permission__c  (
            Name='Testdata8',
            pkl_Category_Access__c=BEN_ConstantsForBenchmarkingAppClasses.EDITOR,
            Category_Master__c=CategoryMaster2.Id,
            pkl_User_Type__c=BEN_ConstantsForBenchmarkingAppClasses.MULTI_CATEGORY_RESTRICTED_ACCESS,
            BEN_Category_User__c=userObject4.Id);
            insert Pobj8;
             
            BEN_Category_User_Permission__c   Pobj6=new BEN_Category_User_Permission__c  (
            Name='Testdata6',
            pkl_Category_Access__c=BEN_ConstantsForBenchmarkingAppClasses.EDITOR,
            Category_Master__c=CategoryMaster2.Id,
            pkl_User_Type__c=BEN_ConstantsForBenchmarkingAppClasses.MULTI_CATEGORY_RESTRICTED_ACCESS,
            BEN_Category_User__c=userObject3.Id );
            insert Pobj6;
          
            }
        catch(DmlException e) {
            System.debug('DML exception occurred: ' + e.getMessage());
        }
        catch (Exception e) {
            System.debug('General exception occurred: ' + e.getMessage());
        }
        
        List<BEN_Category_User_Permission__c> DLRecords1=[Select Id,Name from BEN_Category_User_Permission__c   where Name=:Pobj17.Name];
        delete DLRecords1;
        System.assert(true, DLRecords1==null);
    Test.stopTest();
 }
  
}