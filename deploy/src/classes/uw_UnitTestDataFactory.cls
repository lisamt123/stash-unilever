@IsTest
public with sharing class uw_UnitTestDataFactory {

    public static CollaborationGroup testChatterGroup = null;
    public static Group testGroup = null;
    
    public static CollaborationGroup getTestChatterGroup()
    {
        if (testChatterGroup == null)
        {
            
            testChatterGroup = new CollaborationGroup(Name='Test Group'+Math.random(), CollaborationType='Private');
            insert  testChatterGroup;
            
        }
        
        return testChatterGroup;
    }
    
    public static Id getTestChatterGroupId()
    {
        
       CollaborationGroup cgr = new CollaborationGroup(Name='Test Group'+Math.random(), CollaborationType='Public');
            insert  cgr;
           return cgr.id;
    }

    
    
    public static Group createGroup()
    {
        if (null == testGroup)
        {
            testGroup = new Group(Name='test group');
            insert testGroup;
        }
        
        return testGroup;
    }
    //edited to add inoplan object
    public static uw_BET__c createBet(uw_Brand__c brand, String name,uw_Inoplan_Project__c projectName)
    {
        uw_BET__c newBet = new uw_BET__c();
        newBet.Name = name;
        if (newBet.Name.length() > 20)
        {
            newBet.Name = newBet.Name.substring(0,19);
        }
        
        newBet.uw_Brand__c = brand.Id;
        newBet.Inoplan_Project__c = projectName.id;
        newBet.Product_Category_Sub_Division__c = 'Test Category';
        
        return newBet;
    }
    
    /*public static uw_BET__c createBet_New(uw_Brand__c brand, String name,uw_Inoplan_Project__c projectName)
    {
        uw_BET__c newBet = new uw_BET__c();
        newBet.Name = name;
        if (newBet.Name.length() > 20)
        {
            newBet.Name = newBet.Name.substring(0,19);
        }
        
        newBet.uw_Brand__c = brand.Id;
        newBet.Inoplan_Project__c = projectName.id;
        newBet.Product_Category_Sub_Division__c = 'Test Category';
        
        return newBet;
    }*/
    
    public static uw_Brand__c createParentBrand()
    {
        uw_Brand__c newBrand = new uw_Brand__c();
        newBrand.name = 'Unit Test Parent Brand';
        newBrand.Website__c = 'www.unilever.com';
        // newBrand.RecordTypeId = TODO - Get correct rec type id from production - settings?  
        // newBrand.Logo__c = formula field 
        newBrand.Logo_Location__c =  'empty';
        newBrand.Font_Colour__c = 'white';
        newBrand.Background_Colour__c = 'maroon';
        newBrand.Description__c = 'This is a test Brand';
        
        return newBrand;
    }
    
    public static uw_Inoplan_Project__c createInoplan()
    {
        uw_Inoplan_Project__c newProject = new uw_Inoplan_Project__c();
        newProject.name = 'No Inoplan Project' + Math.random();
        return newProject;
    }
    
    
    public static uw_Brand__c createChildBrand(uw_Brand__c parent)
    {
        uw_Brand__c newBrand = new uw_Brand__c();
        newBrand.name = 'Unit Test Child Brand';
        newBrand.Parent_Brand__c = parent.Id;
        newBrand.Website__c = 'www.unilever.com';
        // newBrand.RecordTypeId = TODO - Get correct rec type id from production - settings?  
        // newBrand.Logo__c = formula field 
        newBrand.Logo_Location__c =  'empty';
        newBrand.Font_Colour__c = 'maroon';
        newBrand.Background_Colour__c = 'white';
        newBrand.Description__c = 'This is a test Brand';
        
        return newBrand;
    }
    
    // Neil's work in progress
    public static Profile internalProfile { get {
        if (internalProfile == null) {
            internalProfile = initInternalProfile();
        }
        return internalProfile;
    } set;}

    public static Profile internalSysAdminProfile { get {
        if (internalSysAdminProfile == null) {
            internalSysAdminProfile = initInternalSysAdminProfile();
        }
        return internalSysAdminProfile;
    } set;}

    public static Profile externalProfile { get {
        if (externalProfile == null) {
            externalProfile = initExternalProfile();
        }
        return externalProfile;
    } set;}
    
    public static Profile initInternalProfile() {
        Profile p = [Select Id From profile Where name='Unilever Way - Marketing - Standard Marketing User' LIMIT 1]; 
        system.assert(p != null);
        return p;
    }

    public static Profile initInternalSysAdminProfile() {
        Profile p = [Select Id From profile Where name='System Administrator' LIMIT 1]; 
        system.assert(p != null);
        return p;
    }

    public static User initInternalUser(String aAlias, String aEmail, String aLastName, String aUserName) {
        
        User u = new User(alias = aAlias, email=aEmail, 
            emailencodingkey='UTF-8', lastname=aLastName, languagelocalekey='en_US', 
            localesidkey='en_US', profileid = internalProfile.Id, 
            timezonesidkey='America/Los_Angeles', username=aUserName);
        
        insert u;
        system.assert(u!=null);

        return u;
    }

    public static User initInternaSysAdminlUser(String aAlias, String aEmail, String aLastName, String aUserName) {
        
        User u = new User(alias = aAlias, email=aEmail, 
            emailencodingkey='UTF-8', lastname=aLastName, languagelocalekey='en_US', 
            localesidkey='en_US', profileid = internalSysAdminProfile.Id, 
            timezonesidkey='America/Los_Angeles', username=aUserName);
        
        insert u;
        system.assert(u!=null);

        return u;
    }
    public static Profile initExternalProfile() {
        Profile p = [Select Id From profile Where name='Chatter External User']; 
        system.assert(p != null);
        return p;
    }

    public static User initExternalUser(String aAlias, String aEmail, String aLastName, String aUserName) {
        
        User u = new User(alias = aAlias, email=aEmail, 
            emailencodingkey='UTF-8', lastname=aLastName, languagelocalekey='en_US', 
            localesidkey='en_US', profileid = externalProfile.Id, 
            timezonesidkey='America/Los_Angeles', username=aUserName);
        
        insert u;
        system.assert(u!=null);

        uw_BET_Team_Member__c tm = new uw_BET_Team_Member__c();
        tm.Team_Member__c = u.Id;

        return u;
    }
    
    /*public static uw_BET__c initBET(String betName, uw_Brand__c brand, Boolean insertFlag,uw_Inoplan_Project__c projectName) {
        uw_BET__c bet = new uw_BET__c();
        bet.Status__c = 'First release';
        bet.Sharing__c = 'Private';
        bet.Product_Category_Sub_Division__c = 'Foods';
        bet.Category_Level_2__c ='Beverages';
        bet.Inoplan_Project__c = projectName.id;
        bet.Name = betName;
        
        if (insertFlag) {
            insert bet;
            system.assert(bet!=null);           
            // requery to pick up anything that was added by triggers
            bet = [SELECT Studio_Chatter_Group__c, Id, Name FROM uw_bet__c WHERE id=:bet.Id];
        }       
        
        return bet;
    }*/

	public static uw_BET__c initBET(String betName, Boolean insertFlag,uw_Inoplan_Project__c projectName) {
        uw_BET__c bet = new uw_BET__c();
        bet.Status__c = 'First release';
        bet.Sharing__c = 'Private';
        bet.Product_Category_Sub_Division__c = 'Foods';
        bet.Category_Level_2__c ='Beverages';
        bet.Inoplan_Project__c = projectName.id;
        bet.Name = betName;

        if (insertFlag) {
            insert bet;
            system.assert(bet!=null);
            bet = [SELECT Studio_Chatter_Group__c, Id, Name FROM uw_bet__c WHERE id=:bet.Id];
        }       
        
        return bet;
    }

    /*public static uw_BET__c initBET(String betName, uw_Brand__c brand, Boolean insertFlag,uw_Inoplan_Project__c projectName, BET_Category__c category, BET_Category__c subCategory) {
        uw_BET__c bet = new uw_BET__c();
        bet.Status__c = 'First release';
        bet.Sharing__c = 'Private';
        bet.Product_Category_Sub_Division__c = 'Foods';
        bet.Category_Level_2__c ='Beverages';
        bet.Inoplan_Project__c = projectName.id;
        bet.Name = betName;

        if (insertFlag) {
            insert bet;
            system.assert(bet!=null);           
            // requery to pick up anything that was added by triggers
            bet = [SELECT Studio_Chatter_Group__c, Id, Name FROM uw_bet__c WHERE id=:bet.Id];
        }       
        
        return bet;
    }*/

    
/*    public static uw_BET__c initBET_New(String betName, uw_Brand__c brand, Boolean insertFlag,uw_Inoplan_Project__c projectName) {
        uw_BET__c bet = new uw_BET__c();
        bet.uw_Brand__c = brand.Id;
        bet.Status__c = 'First release';
        bet.Sharing__c = 'Private';
        bet.Product_Category_Sub_Division__c = 'Foods';
        bet.Inoplan_Project__c = projectName.id;
        bet.Name = betName;
        
        if (insertFlag) {
            insert bet;
            system.assert(bet!=null);           
            // requery to pick up anything that was added by triggers
            bet = [SELECT Studio_Chatter_Group__c, Id, Name FROM uw_bet__c WHERE id=:bet.Id];
        }       
        
        return bet;
    }*/

    // to create BETS pass in a list of names and you get a map of names to id  
    public static Map<String, Id> initBETs(List<String> betNames, uw_Brand__c brand, List<uw_Inoplan_Project__c> projectName) {
        Map<String, Id> betMap = new Map<String, Id>();
        List<uw_BET__c> betList = new List<uw_BET__c>();
        for (String betName:betNames) {
        integer i=0;
            uw_BET__c betX = initBET(betName,false,projectName[i]);
            betList.add(betX);
            i=i+1;
        }
        insert betList;
        
        for (uw_BET__c betY:betList) {
            betMap.put(betY.Name, betY.Id);
        }
        
        return betMap;
    }
    // New init method
    /*public static Map<String, Id> initBETs_New(List<String> betNames, uw_Brand__c brand, List<uw_Inoplan_Project__c> projectName) {
        Map<String, Id> betMap = new Map<String, Id>();
        List<uw_BET__c> betList = new List<uw_BET__c>();
        for (String betName:betNames) {
        integer i=0;
            uw_BET__c betX = initBET_New(betName, brand, false,projectName[i]);
            betList.add(betX);
            i=i+1;
        }
        insert betList;
        
        for (uw_BET__c betY:betList) {
            betMap.put(betY.Name, betY.Id);
        }
        
        return betMap;
    }*/
    
    // to get the latest copy of a BET pass in the name
    public static uw_Bet__c getBet(Map<String,Id> betMap, String name) {
        uw_Bet__c bet = [SELECT Studio_Chatter_Group__c, Id, Name FROM uw_bet__c WHERE id=:betMap.get(name)];       
        return bet;
    } 
    
    public static EntitySubscription initEntitySubscription(String parentId, User u, Boolean insertFlag) {
        EntitySubscription es = new EntitySubscription();
        es.parentId = parentId;
        es.subscriberId = u.Id;
        if (insertFlag) {
            insert es;
        }
        return es;
    }

    public static FeedItem initFeedItem(ContentVersion cv, String id) {
        FeedItem fi = new FeedItem();
        fi.Type = 'ContentPost';
        fi.RelatedRecordId = cv.Id;
        //fi.ParentId = id;
        insert fi;
        return fi;
    }
    
    public static FeedComment initFeedComment(FeedItem fi, ContentVersion cv, uw_bet__c bet) {
        FeedComment fc = new FeedComment(FeedItemId=fi.id);
        fc.CommentType = 'ContentComment';
        fc.relatedRecordId = cv.Id;
        insert fc;
        return fc;      
    }

    public static uw_Brand__c initBrand(String brandName, Boolean insertFlag) {
        uw_Brand__c brand = new uw_Brand__c();
        brand.Name = brandName;
        
        if (insertFlag) {
            insert brand;
            system.assert(brand!=null);         
            // requery to pick up anything that was added by triggers
            brand = [SELECT Id, Name FROM uw_Brand__c WHERE id=:brand.Id];
        }       
        
        return brand;
    }
    
    public static Map<String, Id> initBrands(List<String> brandNames) {
        Map<String, Id> brandMap = new Map<String, Id>();
        List<uw_Brand__c> brandList = new List<uw_Brand__c>();
        for (String brandName:brandNames) {
            uw_Brand__c brandX = initBrand(brandName, false);
            brandList.add(brandX);
        }
        insert brandList;
        
        for (uw_Brand__c brandY:brandList) {
            brandMap.put(brandY.Name, brandY.Id);
        }
        
        return brandMap;
    }
    
    public CollaborationInvitation initCollaborationInvitation(String email, String msg, Id cgId) {
        CollaborationInvitation ci = new CollaborationInvitation();
        ci.InvitedUserEmail = email;
        ci.OptionalMessage = msg;
        ci.SharedEntityId = cgId;
        insert ci;
        return ci;
    }
    
    public static uw_Terms_Conditions__c initTaC(uw_BET__c bet, String email, String actionOnAccept, Boolean fromChatter, Boolean createFlag) {
        uw_Terms_Conditions__c tac = new uw_Terms_Conditions__c();
        tac.Bet_Name__c = bet.Name;
        tac.uw_BET__c = bet.Id;
        tac.Action_On_Accept__c = actionOnAccept;
        tac.Invite_Token__c = 'test';
        tac.Invitee_Email__c = email;
        tac.InvitefromChatter__c = fromChatter;
        tac.Sent_to_Email_Address__c = email;
        tac.Studio_Chatter_Group__c = bet.Studio_Chatter_Group__c;
        if (createFlag) {
            insert tac;
        }
        return tac;
    }

    public static uw_Brand__c getBrand(Map<String,Id> brandMap, String name) {
        uw_Brand__c brand = [SELECT Id, Name FROM uw_Brand__c WHERE id=:brandMap.get(name)];        
        return brand;
    } 
    
    public static ContentVersion initContentVersion() {
        ContentVersion cv =  new ContentVersion();
        cv.Description='test';
        cv.Title='test';
        cv.PathOnClient='test';
        Blob b=Blob.valueOf('test');
        cv.VersionData=b;
        insert cv;  
        
        return cv;
    }

    public static uw_Asset__c initAsset(String n, ContentVersion cv, uw_BET__c bet) {
        uw_Asset__c a = new uw_Asset__c(name=n, URL_of_Asset__c=cv.Id, uw_BET__c=bet.Id);
        insert a;
        
        return a;
    }

    public static CollaborationGroup initCollaborationGroup(String cgName, String collaborationType) {
        CollaborationGroup cg = new CollaborationGroup(name=cgName, CollaborationType=collaborationType, CanHaveGuests=false);
        insert cg;
        return cg;
    }
    
    public static CollaborationGroupMember initCollaborationGroupMember(String cgId, User u, String collabRole) {
        CollaborationGroupMember cgm = new CollaborationGroupMember(CollaborationGroupId=cgId, MemberId=u.Id, CollaborationRole=collabRole);
        insert cgm;
        return cgm;
    }
    
    public static uw_BET_Team_Member__c initTeamMember(User u, uw_BET__c bet, String accessLevel, String role, Boolean bStudio, Boolean bToolkit, Boolean insertFlag) {
        uw_BET_Team_Member__c tm = new uw_BET_Team_Member__c();
        tm.Access_Level__c = accessLevel;
        tm.BET__c = bet.Id;
        tm.BETEnabled__c = bToolkit;
        tm.Role__c = role;
        tm.StudioEnabled__c = bStudio;
        tm.Team_Member__c = u.id;
        
        if (insertFlag) {
            insert tm;
        }
        return tm;
    }

    public static uw_BET_Team_Member__c initTeamMember(User u, uw_BET__c bet, String accessLevel, String role, Boolean bStudio, Boolean bToolkit, Boolean insertFlag, Boolean pendingRequest) {
        uw_BET_Team_Member__c tm = new uw_BET_Team_Member__c();
        tm.Access_Level__c = accessLevel;
        tm.BET__c = bet.Id;
        tm.BETEnabled__c = bToolkit;
        tm.Role__c = role;
        tm.StudioEnabled__c = bStudio;
        tm.Team_Member__c = u.id;
        tm.Pending_Request__c = pendingRequest;
        
        if (insertFlag) {
            insert tm;
        }
        return tm;
    }
}