/**********************************************************************
Name: BET_TestingHelper
Copyright © 2015 Unilever.
=======================================================
=======================================================
Purpose: Helper class for BET unit tests
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Wojciech Migas          16/01/2015      INITIAL DEVELOPMENT
***********************************************************************/
@isTest
global with sharing class BET_TestingHelper {
    private static Integer nameRandomizer = 0;

    //presentation Id to set for all UT
    public static String UT_PRESENTATIONID    = '069000123123123123';
    public static String UT_ASSETDOWNLOADLINK = 'https://download.com';
    public static String UT_ASSETTHUMBLINK    = 'https://download.com/thumb';
    public static String UT_COUNTRY           = 'United Kingdom';
    
    //bet statuses
    public static String BET_STATUS_UNRELEASED   = 'Unreleased';
    public static String BET_STATUS_FIRSTRELEASE = 'First release';
    public static String BET_STATUS_FINALRELEASE = 'Final release';

    //assets sub function
    public static String ASSET_SUBFUNCTION_BD = 'Brand Development';
    public static String ASSET_SUBFUNCTION_BB = 'Brand Building';

    //assets statuses
    public static String ASSET_STATUS_APPROVED = 'Approved';
    public static String ASSET_STATUS_DRAFT    = 'Draft';
    public static String ASSET_STATUS_SHARED   = 'Shared';

    //assets studiotype
    public static String ASSET_STUDIOTYPE_PRESENTATION = 'Brand Experience Presentation';
    public static String ASSET_STUDIOTYPE_CREATIVEWORK = 'Creative Work';

    //asset mediaType
    public static String ASSET_MEDIATYPE_KEYVISUAL       = 'Key Visual';
    public static String ASSET_MEDIATYPE_BETPRESENTATION = 'BET Presentation';
    public static String ASSET_MEDIATYPE_SOCIALMEDIA     = 'Social Media';

    //admin and standard user profiles
    public static Profile AdminProfile;
    public static Profile UserProfile;

    //Default object used to create BET
    private static User DEFAULT_OWNER;
    private static User DEFAULT_MANAGER;
    private static User DEFAULT_MEMBER;
    private static User DEFAULT_NOTMEMBER;

    //helper structure to return test data in the common way
    global class BET_TestingData {
        public User owner;
        public User manager;
        public User member;
        public User notMember;
        public uw_BET__c BET;
        public uw_Asset__c presentation;
        public uw_Asset__c creativeWork;
        public FeedItem unlabelledFeedItem;

        /**
         * Method add user as a BET member (create manual sharing rule, add user to private chatter group)
         * @param {User}      memberUser User Who will be added as a BET member
         * @param {String}    role       Member role (Manager or Member)
         */
        public void addUserAsMember(User memberUser, String role) {
            uw_BET_Team_Member__c BETTeamMember = new uw_BET_Team_Member__c();
            RecordType recordType = [SELECT Id FROM RecordType WHERE SobjectType = 'uw_BET_Team_Member__c' AND Name = 'InternalUser' LIMIT 1];
            
            BETTeamMember.recordTypeId = recordType.Id;
            BETTeamMember.BET__c = this.BET.Id;
            BETTeamMember.BETEnabled__c = true;
            BETTeamMember.Access_Level__c = 'Toolkit Experience (Toolkit only)';
            BETTeamMember.Team_Member__c = memberUser.Id;
            BETTeamMember.Role__c = role;

            insert BETTeamMember;
            
            // Not necessary done by trigger now
            //String accessLevel = (BETTeamMember.Role__c.equalsIgnoreCase('Manager')) ? 'Edit' : 'Read';
            //createBETShare(BETTeamMember.Team_Member__c, accessLevel, BETTeamMember.BET__c);
            //createCollaborationGroupMemberRecord(this.BET.Studio_Chatter_Group__c, memberUser.Id, role);
        }

        /**
         * Create manual sharing rule (Gives user access to BET object)
         * @param  {Id}     userId        User Id
         * @param  {String} accessLevel   Read or Write
         * @param  {Id}     betId         BET id
         * @return {uw_BET__Share}
         */
        private uw_BET__Share createBETShare(Id userId, String accessLevel, Id betId) {
             uw_BET__Share betShare = new uw_BET__Share();
             betShare.UserOrGroupId = userid;
             betShare.AccessLevel = accessLevel;
             betShare.ParentId = betId;

             insert betShare;
             
             return betShare; 
        }

        /**
         * Add User to a chatter group
         * @param  {Id}     groupId       Chatter group Id
         * @param  {Id}     userId        User Id
         * @param  {String} role          New member's role (Manager or Member)
         * @return {CollaborationGroupMember}
         */
        private CollaborationGroupMember createCollaborationGroupMemberRecord(Id groupId, Id userId, String role) {
            CollaborationGroupMember cgm = new CollaborationGroupMember();
            cgm.CollaborationGroupId = groupId;
            cgm.MemberId = userId;
            cgm.NotificationFrequency = 'N';
            if (role.equalsIgnoreCase('Manager')){
                cgm.CollaborationRole = 'Admin';
            }else {                
                cgm.CollaborationRole = 'Standard';
            }     

            insert cgm;

            return cgm;
        }

        /**
         * Add default member to BET
         */
        public void addMember() {
            User memberUser = BET_TestingHelper.getDefaultMember();
            addMember(memberUser);
        }

        /**
         * Add given user as a BET member
         * @param {User} memberUser User who will be BET member
         */
        public void addMember(User memberUser) {
            addUserAsMember(memberUser, 'Member');
            this.member = memberUser;
        }
        
        /**
         * Add default manager to BET
         */
        public void addManager() {
            User managerUser = getDefaultManager();
            addManager(managerUser);
        }

        /**
         * Add given user as a BET manager
         * @param {User} managerUser User who will be BET manager
         */
        public void addManager(User managerUser) {
            addUserAsMember(managerUser, 'Manager');
            this.manager = managerUser;
        }

        /**
         * Add unlabbeled file to BET (upload file ic context of the BET's private chatter group)
         * @param {String}  fileName file name
         */
        public void addUnlabelledFile(String fileName) {
            feedItem unlabelledFeedItem = new FeedItem(
                ParentId = this.BET.Studio_Chatter_Group__c,
                Body = 'Some Content',
                ContentFileName = fileName,
                ContentData = EncodingUtil.base64Decode('test')
            );
            
            insert unlabelledFeedItem;

            this.unlabelledFeedItem = unlabelledFeedItem;
        }

        /**
         * Add presentation asset
         * @param {String}  fileName file name
         * @param {String}  status   asset status (Approved, Shared, Draft)
         */
        public uw_Asset__c addPresentation(String fileName, String status) {
            uw_Asset__c presentationAsset = addAsset(fileName, ASSET_SUBFUNCTION_BD,  ASSET_STUDIOTYPE_PRESENTATION, status, ASSET_MEDIATYPE_BETPRESENTATION);
            this.presentation = presentationAsset;
            return presentationAsset;
        }

        /**
         * Add creative work asset
         * @param {String}  fileName file name
         * @param {String}  status   asset status (Approved, Shared, Draft)
         */
        public uw_Asset__c addCreativeWork(String fileName, String status) {
            return addCreativeWork(fileName, status, ASSET_MEDIATYPE_KEYVISUAL);
        }

        /**
         * Add creative work asset
         * @param {String}  fileName    file name
         * @param {String}  status      asset status (Approved, Shared, Draft)
         * @param {String}  mediaType   Media Type (Key Visual, BET Presentation etc...)
         */
        public uw_Asset__c addCreativeWork(String fileName, String status, String mediaType) {
            uw_Asset__c creativeWorkAsset = addAsset(fileName, ASSET_SUBFUNCTION_BD,  ASSET_STUDIOTYPE_CREATIVEWORK, status, mediaType);
            this.creativeWork = creativeWorkAsset;
            return creativeWorkAsset;
        }

        /**
         * Add asset
         * @param {String}  fileName        file name
         * @param {String}  subFunction     Asset sub function (Brand Development, Brand Building)
         * @param {String}  studioType      tudio asset Type (Brand Experience Presentation, Creative Work)
         * @param {String}  status          asset status (Approved, Shared, Draft)
         * @param {String}  mediaType       Media Type (Key Visual, BET Presentation etc...)
         */
        public uw_Asset__c addAsset(String fileName, String subFunction, String studioType, String status, String mediaType) {
            feedItem assetFeedItem = new FeedItem(
                ParentId = this.BET.Studio_Chatter_Group__c,
                Body = 'Some Content',
                ContentFileName = fileName,
                ContentData = EncodingUtil.base64Decode('test')
            );

            insert assetFeedItem;

            //WE CANNOT USE CONNECT API ON DATA WHICH HAS BEEN CREATED DUERING UT
            //ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.getFeedItem(null, assetFeedItem.Id);
            //ConnectApi.ContentAttachment ca = (ConnectApi.ContentAttachment) fi.attachment;

            uw_Asset__c asset = new uw_Asset__c(
                Name                 = fileName,
                uw_BET__c            = this.BET.Id,
                Sub_Function__c      = subFunction,
                Studio_Asset_Type__c = studioType,
                Media_Type__c        = mediaType,
                Status__c            = status,
                Related_Feed_Item__c = assetFeedItem.Id,
                Country__c           = BET_TestingHelper.UT_COUNTRY,
                //connect API
                URL_of_Asset__c      = BET_TestingHelper.UT_ASSETDOWNLOADLINK,
                thumbnail__c         = BET_TestingHelper.UT_ASSETTHUMBLINK
            );
            
            insert asset;

            return asset;
        }

        public void archiveGroup() {
            CollaborationGroup chatterGroup = [SELECT IsArchived FROM CollaborationGroup 
                                                WHERE Id =: this.BET.Studio_Chatter_Group__c LIMIT 1];
            chatterGroup.IsArchived = true;
            update chatterGroup;
        }
    }

    /**
     * Returns a unique number which can be added to the test name
     * @retur {String} unique number
     */
    private static String getRandomPart() {
        return String.valueOf(nameRandomizer++);
    }

    /**
     * Creates user
     * @param  {Profile} uProfile      Profile object
     * @param  {String}  uAlias        alias
     * @param  {String}  uEmail        email
     * @param  {String}  uLastName     lastname
     * @return {User}
     */
    private static User createUser(Profile uProfile, String uAlias, String uEmail, String uLastName) {
        User u = new User(
            alias = uAlias, 
            email = uEmail, 
            lastname = uLastName,
            profileId = uProfile.Id,
            username = uEmail + '.sfdcbetUT',
            emailencodingkey = 'UTF-8',
            languagelocalekey = 'en_US', 
            localesidkey = 'en_US',
            timezonesidkey='America/Los_Angeles'
        );

        insert u;

        u = [SELECT Id, Name, alias, email, firstname, lastname, profileId, username, emailencodingkey, languagelocalekey, localesidkey, timezonesidkey
                FROM User WHERE Id =: u.Id LIMIT 1];

        return u;
    }

    /**
     * Get user object which is default BET owner. If it doesn't exists, it is created
     * @return {User} 
     */
    public static user getDefaultOwner() {
        if (DEFAULT_OWNER == null) {
            DEFAULT_OWNER = createUser(getAdminProfile(), 'TEST-OWN', 'test-owner@force.com', 'test-owner');
        }
        return DEFAULT_OWNER;
    }

    /**
     * Get user object which is default BET manager. If it doesn't exists, it is created
     * @return {User} 
     */
    public static user getDefaultManager() {
        if (DEFAULT_MANAGER == null) {
            DEFAULT_MANAGER = createUser(getUserProfile(), 'TEST-MAN', 'test-manager@force.com', 'test-manager');
        }
        return DEFAULT_MANAGER;
    }

    /**
     * Get user object which is default BET member. If it doesn't exists, it is created
     * @return {User} 
     */
    public static user getDefaultMember() {
        if (DEFAULT_MEMBER == null) {
            DEFAULT_MEMBER = createUser(getUserProfile(), 'TEST-MEM', 'test-member@force.com', 'test-member');
        }
        return DEFAULT_MEMBER;
    }

    /**
     * Get user object which is not a BET member. If it doesn't exists, it is created
     * @return {User} 
     */
    public static user getDefaultNotMember() {
        if (DEFAULT_NOTMEMBER == null) {
            DEFAULT_NOTMEMBER = createUser(getUserProfile(), 'TEST-MEM', 'test-notmember@force.com', 'test-notmember');
        }
        return DEFAULT_NOTMEMBER;
    }

    /**
     * Returns system administrator Profile
     * @return {Profile} 
     */
    public static Profile getAdminProfile() {
        if (AdminProfile == null) {
            AdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1]; 
        }
        return AdminProfile;
    }

    /**
     * Returns marketing user Profile
     * @return {Profile} 
     */
    public static Profile getUserProfile() {
        if (UserProfile == null) {
            UserProfile = [SELECT Id FROM Profile WHERE Name='Unilever Way - Marketing - Standard Marketing User' LIMIT 1]; 
        }
        return UserProfile;
    }

    /**
     * Creates administrator user
     * @param  {String} uAlias        alias
     * @param  {String} uEmail        email
     * @param  {String} uLastName     lastname
     * @return {User}
     */
    public static user createAdminUser(String uAlias, String uEmail, String uLastName) {
        return createUser(getAdminProfile(), uAlias, uEmail, uLastName);
    }

    /**
     * Creates InoPlan project object
     * @param  {String}  inoplanName    Inoplan project name
     * @param  {Boolean} insertFlag     if true, insert object into database
     * @return {uw_Inoplan_Project__c}
     */
    public static uw_Inoplan_Project__c initInoplan(String inoplanName, Boolean insertFlag)
    {
        uw_Inoplan_Project__c inoplan = new uw_Inoplan_Project__c();
        inoplan.name = inoplanName;

        if (insertFlag) {
            insert inoplan;
        }

        return inoplan;
    }


        /**
     * Creates brand object
     * @param  {String}  brandName     brand name
     * @param  {Boolean} insertFlag    if true, insert object into database
     * @return {uw_Brand__c}
     */
    public static uw_Brand__c initBrand(String brandName, Boolean insertFlag) {
        uw_Brand__c brand = new uw_Brand__c();
        brand.Name = brandName;
        
        if (insertFlag) {
            insert brand;
            // requery to pick up anything that was added by triggers
            brand = [SELECT Id, Name FROM uw_Brand__c WHERE Id =: brand.Id];
        }       
        
        return brand;
    }

    /**
     * Creates category object
     * @param  {String}  categoryName  category name
     * @param  {Boolean} insertFlag    if true, insert object into database
     * @return {BET_Category__c}
     */
    public static BET_Category__c initCategory(String categoryName, Boolean insertFlag) {
        return initCategory(categoryName, null, insertFlag);
    }

    /**
     * Creates category object
     * @param  {String}             categoryName    category name
     * @param  {BET_Category__c}    parentCategory  parent category
     * @param  {Boolean}            insertFlag      if true, insert object into database
     * @return {BET_Category__c}
     */
    public static BET_Category__c initCategory(String categoryName, BET_Category__c parentCategory, Boolean insertFlag) {
        BET_Category__c category = new BET_Category__c();
        category.Name = categoryName;
        if (parentCategory != null) {
            category.BET_Parent_Category__c = parentCategory.Id;
        }

        if (insertFlag) {
            insert category;
            // requery to pick up anything that was added by triggers
            category = [SELECT Id, Name, BET_Parent_Category__c FROM BET_Category__c WHERE Id =: category.Id];
        }       
        
        return category;
    }

    /**
     * Creates category and brand junction object
     * @param  {BET_Category__c}    category        category
     * @param  {uw_Brand__c}        brand           brand
     * @param  {Boolean}            insertFlag      if true, insert object into database
     * @return {BET_Category_Brands__c}
     */
    public static BET_Category_Brands__c initCategoryBrand(BET_Category__c category, uw_Brand__c brand, Boolean insertFlag) {
        BET_Category_Brands__c categoryBrand = new BET_Category_Brands__c();
        categoryBrand.BET_Brand__c = brand.Id;
        categoryBrand.BET_Category__c = category.Id;

        if (insertFlag) {
            insert categoryBrand;
        }

        return categoryBrand;
    }
    

    /**
     * Creates BET object. Sets all unspecified parameteres using default common data
     * @param  {String}  BETName       BET name
     * @param  {Boolean} insertFlag    if true, insert object into database
     * @return {BET_TestingData}
     */
    public static BET_TestingData initBET(String BETName, Boolean insertFlag) {
        uw_Bet__c BET = BET_TestUtils.getTestBet();
        BET.ownerId = getDefaultOwner().id;
        BET.name = BETName;
        BET.Status__c = BET_TestingHelper.BET_STATUS_UNRELEASED;
        if (insertFlag) {
            insert BET;
            BET = getBET(BET.Id);
        }
        User notMember = getDefaultNotMember();
        BET_TestingData testData = new BET_TestingData();
        testData.BET = BET;
        testData.owner = new User(id = BET.ownerId);
        testData.notMember = notMember;
        return testData;
    }

    /**
     * Creates BET object.
     * @param  {User}    owner         User wh will be BET owner  
     * @param  {String}  BETName       BET name
     * @param  {String}  BETStatus     BET status (Unreleased, First release, Final release)
     * @param  {Boolean} insertFlag    if true, insert object into database
     * @param  {Boolean} withDefault   if true, all unsfecified fields will be populated using common default data. Otherewise it will create new objects
     * @return {BET_TestingData}
     */
    public static BET_TestingData initBET(User owner, String BETName, String BETStatus, Boolean insertFlag, Boolean withDefault) {
        uw_Bet__c BET = BET_TestUtils.getTestBet();
        BET.ownerId = getDefaultOwner().id;
        BET.name = BETName;
        BET.Status__c = BETStatus;
        if (insertFlag) {
            insert BET;
            BET = getBET(BET.Id);
        }
        User notMember = getDefaultNotMember();
        BET_TestingData testData = new BET_TestingData();
        testData.BET = BET;
        testData.owner = new User(id = BET.ownerId);
        testData.notMember = notMember;
        return testData;
    }

    /**
     * Returns BET object
     * @param  {Id} BETId         BET Id
     * @return {uw_BET__c}
     */
    public static uw_BET__c getBET(Id BETId) {
        return [SELECT Status__c, Sharing__c, Inoplan_Project__c, Studio_Chatter_Group__c, Id, Name, Brand_Keyword_Search__c, Inoplan_Project_Keyword_Search__c, 
                        Category_Keyword_Search__c, Owner_Keyword_Search__c, OwnerId, Owner.Email,
                        Owner.Name, Presentation_Id__c, Is_Archived__c, Banner_1_Location__c, Icon_Location__c, 
                        FirstReleaseDate__c, FinalReleaseDate__c,Final_Release_Due_Date__c,First_Release_Due_Date__c, Launch_Date__c,
                        Product_Brand__c,Product_Category__c,Brand_Position__c,Category_Group__c
                    FROM uw_BET__c WHERE Id =: BETId LIMIT 1];
    }

    /**
     * Checks if helper works correctly
     * It demonstrates how to use helper class
     */
     public static testMethod void createBETWithAsset() {
        //create BET with owner
        //testData.BET
        //testData.owner
        //testData.notMember
        BET_TestingHelper.BET_TestingData testData = BET_TestingHelper.initBET('BETTEST', true);
        System.assert(testData != null, 'BET_TestingData object has not been initialized');
        System.assertEquals('BETTEST', testData.BET.Name);
        System.assertEquals('Private', testData.BET.Sharing__c);
        System.assertEquals(BET_TestingHelper.BET_STATUS_UNRELEASED, testData.BET.Status__c);
        System.assertEquals(BET_TestingHelper.getDefaultOwner().id, testData.owner.Id);
        System.assertEquals(BET_TestingHelper.getDefaultNotMember().id, testData.notMember.Id);


        //add manager to BET
        //testData.manager
        testData.addManager(/*optional User object*/);
        System.assertEquals(BET_TestingHelper.getDefaultManager(), testData.manager);

        //add member to BET
        //testData.member
        testData.addMember(/*optional User object*/);
        System.assertEquals(BET_TestingHelper.getDefaultMember(), testData.member);

        //add presentation to BET
        //testData.presentation
        uw_Asset__c presentation = testData.addPresentation('Test Presentation.PPT', BET_TestingHelper.ASSET_STATUS_APPROVED);
        System.assertNotEquals(null, testData.presentation);
        System.assertNotEquals(null, presentation);
        System.assertEquals(presentation, testData.presentation);

        //add creative work to BET
        //testData.creativeWork
        uw_Asset__c creativeWork = testData.addCreativeWork('Test Creative Work.PDF', BET_TestingHelper.ASSET_STATUS_APPROVED);
        System.assertNotEquals(null, testData.creativeWork);
        System.assertNotEquals(null, creativeWork);
        System.assertEquals(creativeWork, testData.creativeWork);


        //add unlabelledFeedItem to BET
        //testData.unlabelledFeedItem
        testData.addUnlabelledFile('Unlabelled files.png');
        System.assertNotEquals(null, testData.unlabelledFeedItem);
    }

    /**
     * Check if page message exists
     * @param  {String}             errorMessage  error message
     * @param  {ApexPages.Severity} errorSeverity error severity
     * @return {Boolean}
     */
    public static boolean checkIfPageMessageExists(String errorMessage, ApexPages.Severity errorSeverity) {
        for (ApexPages.Message msg: ApexPages.getMessages()) {
            if (errorMessage == msg.getSummary() && errorSeverity == msg.getSeverity()) {
                return true;
            }
        }
        return false;
    }

    /**
     * Check if any page message of given severity exists
     * @param  {ApexPages.Severity} errorSeverity error severity
     * @return {Boolean}
     */
    public static boolean checkIfAnyPageMessageExists(ApexPages.Severity errorSeverity) {
        for (ApexPages.Message msg: ApexPages.getMessages()) {
            if (errorSeverity == msg.getSeverity()) {
                return true;
            }
        }
        return false;
    }
}