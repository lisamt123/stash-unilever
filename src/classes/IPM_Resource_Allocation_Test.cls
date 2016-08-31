/*
* @Description Tests the resource allocation class
*/

@isTest
private class  IPM_Resource_Allocation_Test {
    public static IPM_Project__c project;// Project object initialization
    public static List<IPM_Project__c> projectListObj = new List<IPM_Project__c>();
    public static List<IPM_Project__c> projectList= new List<IPM_Project__c>();
    public static PageReference pRef;
    private static user stdUserForResourceAllocation;
    public static List<IPM_Country__c> countryList=new List<IPM_Country__c>();
    private static IPM_Resource_Allocation ipmResAlloccation;
    public static IPM_Financial__c fin=new IPM_Financial__c();
   
    private static string REGIONAL_STR='Regional';
    public static IPM_Project_Resource__c projectResRecord;
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static final String ge0023 ='GEO0023';
    private static final String southAsia='South Asia';
    public static IPM_Project_Rollout__c projRollOut;
    private static  string DUMMY_MAIL_ID='XXAAXX11@unilever.com';
    public static User globalUser;
    private static final String rolloutString='rolloutId';
    private static final string  invokedFrom;
    public static IPM_User_Profile__c userProf;
    public static  ApexPages.Message[] pageMessages;
    public static List<IPM_User_Profile__c> userProList=new List<IPM_User_Profile__c>();
    private static final string FUNCTION_NOT_CALL_PROPERLY ='function not not call properly';
    private static IPM_Company_Card__c globalCompanyCard=new IPM_Company_Card__c();
    private static IPM_Company_Card__c regionalCompanyCard=new IPM_Company_Card__c();
    private static IPM_Company_Card__c localCompanyCard=new IPM_Company_Card__c();
    private static final string USER_CATE='Household Care';
    private static final string CATE_LAUNDRY='Laundry';
    private static User readOnlyUser=new User();
    /*************************************************************************
    @Description : to Intialize(insert) the data for Project, 
        IPM_Project_Rollout__c, IPM_Financial__c objects
   ***************************************************************************/
    @testSetUp static void initializeData(){
        readOnlyUser=IPM_TestFactory_Helper.createUser(true);
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForResourceAllocation= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForResourceAllocation.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForResourceAllocation.id,'user insertion fails:'+userLists[0].id);//positive test
        
        // Create Company Card information 
        globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        regionalCompanyCard.IPM_TxtGeographical_Scope__c=southAsia;
        localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c>  companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id,IPM_TxtGeographical_Scope__c, IPM_Managed_Category__c,IPM_Market_Cluster__c from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card insertion fails');
        IPM_User_Profile__c userProfs=new IPM_User_Profile__c();
        userProfs.IPM_User__c = readOnlyUser.Id;
        userProfs.IPM_User_Role__c=IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE;
        userProfs.IPM_User_Function__c=IPM_ConstantUtils.PROJECT_LEADER;
        userProfs.IPM_User_Category__c=CATE_LAUNDRY;
        userProfs.IPM_Company_Card__c=regionalCompanyCard.id;
        insert userProfs;
		IPM_User_Profile__c userProfile = [SELECT Id FROM IPM_User_Profile__c WHERE Id = : userProfs.id];
		System.assertEquals(userProfile.id,userProfs.id, 'User Profile insertion fails');
        IPM_TestFactory_Helper.getProjectMasterData();
        projectListObj = IPM_TestFactory_Helper.projectSetUp(1,stdUserForResourceAllocation);
        System.runAs(stdUserForResourceAllocation) {
            insert projectListObj;
            List<IPM_Project__c> projlList1=[SELECT ID,Deputy_Project_Leader__c,IPM_Project_Gatekeeper__c,IPM_Project_Leader__c,IPMProject_Span__c,
            IPM_Technical_Project_Leader__c,IPM_Company_Card__c,IPM_Category_Text__c ,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectListObj[0].ID LIMIT 1];
            System.assertEquals(projlList1[0].Name,TEST_COMMENTS_STR,'project name is not validated');//positive test
            project=projectListObj[0];
        }
       
    }
    
    /*************************************************************************************************************************
    * @description Test Data
    */
    static void initializeTestMethodData()
    {
        
        Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
        globalUser = [Select Id,LastName,Name from User where LastName='PLATFORM_USER' limit 1]; 
        system.runAs(globalUser)
        {
            projectList = [SELECT id,Deputy_Project_Leader__c,IPM_Project_Gatekeeper__c,IPM_Project_Leader__c,IPMProject_Span__c,
            IPM_Technical_Project_Leader__c,IPM_Company_Card__c,IPM_Category_Text__c ,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
            (Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r),(select ID,IPM_Project__c from IPM_Questionnaires__r)
            from IPM_Project__c where Name =:projectNameSet];
            project=projectList[0];
            project.Deputy_Project_Leader__c=globalUser.Id;
            project.IPM_Technical_Project_Leader__c=globalUser.Id;
            project.IPM_Finance_Lead__c=globalUser.id;
            project.IPM_Project_Leader__c=globalUser.id;
            project.IPM_Company_Card__c=globalCompanyCard.id;
            project.IPM_Category_Text__c=CATE_LAUNDRY;
            update project;
            List<IPM_Project__c> projlList1=[SELECT id,IPM_Project_Gatekeeper__c,IPM_Project_Leader__c,IPMProject_Span__c,
            IPM_Technical_Project_Leader__c,IPM_Company_Card__c,IPM_Category_Text__c ,Deputy_Project_Leader__c,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
            System.assertEquals(projlList1[0].Deputy_Project_Leader__c,globalUser.Id,'project updation fails');//positive test
            
            projectResRecord = IPM_TestFactory_Helper.createIPMProjectResource(project.Id,false);
            projectResRecord.IPM_User__c=globalUser.Id;
            projectResRecord.IPM_Project__c=project.Id;
            projectResRecord.IPM_Role_Type__c=IPM_ConstantUtils.TEAM_RND;
            projectResRecord.IPM_Project_Role_Owner__c=true;
            projectResRecord.IPM_Project__c=project.Id;
            insert projectResRecord;
            
            List<IPM_Project_Resource__c>resList=[select Id,IPM_Role_Type__c from IPM_Project_Resource__c where Id=:projectResRecord.Id limit 1];
            System.assertEquals(resList[0].IPM_Role_Type__c,IPM_ConstantUtils.TEAM_RND,'resource record insertion fails');//positive test
            
            projRollOut=new IPM_Project_Rollout__c();
            projRollOut= IPM_TestFactory_Helper.createIPMProjectRollout(false);
            String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
            projRollOut=IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
            projRollOut.Name='TESTAPPROVERCL_SEAA';
            projRollOut.RecordTypeId=strRecordTypeId;
            projRollOut.IPM_Project__c=project.Id;
            projRollOut.Market_Cluster_Name__c=southAsia;
            projRollOut.Market_Cluster__c=ge0023;
            projRollOut.MCO__c = 'LV4_GEO0077';
            projRollOut.MCO_Name__c = 'Other South Asia';
            projRollOut.Target_Launch_Date__c=date.today()+10;
            projRollOut.IPM_Regional_PL__c=globalUser.Id;
            projRollOut.KeyMCO__c= true;
            projRollOut.IPM_Rollout_Span__c=REGIONAL_STR;
            projRollOut.Added_At_Stage__c=IPM_ConstantUtils.PHASE_IDEAS;
            projRollOut.IPM_Regional_PL_Text__c = 'regionla PL';
            projRollOut.IPM_Finance_Member_Text__c = 'Finance PL';
            insert projRollOut; 
            
            List<IPM_Project_Rollout__c> proRegListObj=[SELECT IPM_Rollout_Span__c ,Id,Finance_Member__c,IPM_Regional_PL__c,RecordTypeId,Name,Market_Cluster_Name__c,IPM_Regional_PL_Text__c, IPM_Finance_Member_Text__c,(Select Id,Country_Name__c from IPM_Countries_Local__r) from IPM_Project_Rollout__c WHERE ID =:projRollOut.ID LIMIT 1];
            System.assertEquals(proRegListObj[0].IPM_Rollout_Span__c,REGIONAL_STR,'regional rollout is not created');//positive test
            
            List<IPM_User_Profile__c>uProfileList=new List<IPM_User_Profile__c>();
            userProf=new IPM_User_Profile__c();
            userProf=IPM_TestFactory_Helper.createUserProfile(false);
            userProf.IPM_User__c = globalUser.Id;
            userProf.IPM_User_Role__c=IPM_ConstantUtils.PROJECT_LEADER;
            userProf.IPM_User_Function__c=IPM_ConstantUtils.PROJECT_LEADER;
            userProf.IPM_Company_Card__c=globalCompanyCard.id;
            userProf.IPM_User_Category__c=USER_CATE;
            uProfileList.add(userProf);
            
            
            insert uProfileList; 
             
            List<IPM_User_Profile__c>userProfList=[select Id,IPM_User_Role__c,IPM_Company_Card__c,IPM_Company_Card__r.RecordTypeId from IPM_User_Profile__c where Id=:userProf.Id limit 1];
            system.assertEquals(userProfList[0].IPM_User_Role__c,IPM_ConstantUtils.PROJECT_LEADER,'user profile insertion fails');
            
            pRef = Page.IPM_Resource_Allocation;
            pRef.getParameters().put(rolloutString,projRollOut.Id); // put it in the page
            pRef.getParameters().put(IPM_ConstantUtils.ROLLOUTID,projRollOut.Id);   // what we need to put   
            pRef.getParameters().put('Id',project.Id);
            pRef.getParameters().put(IPM_ConstantUtils.TEAM_ROLETYPE, IPM_ConstantUtils.TEAM_RND);
            pRef.getParameters().put(IPM_ConstantUtils.TEAM_CATEGORY, IPM_ConstantUtils.TEST_STR);
            pRef.getParameters().put(IPM_ConstantUtils.TEAM_PROJECT_LEAD, IPM_ConstantUtils.TEAM_TEST1);
            pRef.getParameters().put(IPM_ConstantUtils.TEAM_COREMEMBER, IPM_ConstantUtils.TEAM_TEST2);
            pRef.getParameters().put(IPM_ConstantUtils.TEAM_COREPL, IPM_ConstantUtils.TEAM_PL);
            pRef.getParameters().put(IPM_ConstantUtils.TEAM_CATEGORY, IPM_ConstantUtils.TEST_STR);
            pRef.getParameters().put(IPM_ConstantUtils.TEAM_PL, IPM_ConstantUtils.TEAM_TRUE);
            pRef.getParameters().put(IPM_ConstantUtils.ROLLOUT_LEADER_TYPE,IPM_ConstantUtils.ROLLOUT_PL_TYPE);
            pRef.getParameters().put(IPM_ConstantUtils.TEAM_DPL,IPM_ConstantUtils.TEAM_TRUE);
            pRef.getParameters().put(IPM_ConstantUtils.ROLLOUT_SPAN,IPM_ConstantUtils.ROLLOUT_SPAN_REGIONAL);
            pRef.getParameters().put(IPM_ConstantUtils.INVOKED_FROM,IPM_ConstantUtils.INVOKED_FROM_ROLLOUTS); // what we need to put 
            Test.setCurrentPage(pRef);
            
            ipmResAlloccation=new IPM_Resource_Allocation();
            pRef.getParameters().put(IPM_ConstantUtils.ROLLOUT_SPAN,IPM_ConstantUtils.ROLLOUT_SPAN_LOCAL);
            ipmResAlloccation=new IPM_Resource_Allocation();
            pRef.getParameters().put(IPM_ConstantUtils.ROLLOUT_LEADER_TYPE,IPM_ConstantUtils.ROLLOUT_FL_TYPE);
            ipmResAlloccation=new IPM_Resource_Allocation();
            pRef.getParameters().put(IPM_ConstantUtils.INVOKED_FROM,invokedFrom);
            ipmResAlloccation=new IPM_Resource_Allocation();
            pRef.getParameters().put(IPM_ConstantUtils.TEAM_ROLETYPE,IPM_ConstantUtils.TEAM_GUEST);
            ipmResAlloccation=new IPM_Resource_Allocation();
            pageMessages = ApexPages.getMessages();
            
        }
    }

    /*
    * @Description To check if the same category has been assigned to GD
    */
    static testMethod  void testGetSameCategory()
    {
        initializeTestMethodData(); 
       
        system.RunAs(globalUser)
        {
            test.startTest();
            userProf.IPM_User_Role__c=IPM_ConstantUtils.IPM_ROLE_RD;
            update userProf;
            List<IPM_User_Profile__c>userProfList=[select Id,IPM_User_Role__c,IPM_Company_Card__c,IPM_Company_Card__r.RecordTypeId from IPM_User_Profile__c where Id=:userProf.Id limit 1];
            system.assertEquals(userProfList[0].IPM_User_Role__c,IPM_ConstantUtils.IPM_ROLE_RD,'user profile updation fails');
            Map<id,id> projUserMap = new Map<id,id>();
            projUserMap.put(project.id,globalUser.Id);
            ipmResAlloccation.isPLEdit=true;
            ipmResAlloccation.searchLeaderbyCat=IPM_ConstantUtils.TEAM_MYCATEGORY;
            ipmResAlloccation.isLeaderTypePL=true;
            ipmResAlloccation.isLeaderTypeFL=true;
            ipmResAlloccation.SelectedLeaderMember=String.valueOf(globalUser);
            ipmResAlloccation.SearchLeader='searchLeader';
            ipmResAlloccation.isInvokedFromRollouts=true;
            ipmResAlloccation.rolloutId=projRollOut.Id;
            
            ipmResAlloccation.changeRoleType='gfgf';
            ipmResAlloccation.SearchTeambyCat= IPM_ConstantUtils.TEAM_MYCATEGORY;
            ipmResAlloccation.getSameCategory(); 
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            System.assertEquals(userProList[0].IPM_User_Role__c,IPM_ConstantUtils.IPM_ROLE_RD,FUNCTION_NOT_CALL_PROPERLY);
            
            ipmResAlloccation.RoleType = IPM_ConstantUtils.IPM_ROLE_GUEST;
            ipmResAlloccation.getSameCategory(); 
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            System.assertEquals(userProList[0].IPM_User_Role__c,IPM_ConstantUtils.IPM_ROLE_RD,FUNCTION_NOT_CALL_PROPERLY);
            
            system.assertEquals(ipmResAlloccation.RoleType,IPM_ConstantUtils.IPM_ROLE_GUEST,'User Role type is not validated'); //positive test
            ipmResAlloccation.RoleType='Project Leader';
            ipmResAlloccation.getSameCategory(); 
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            System.assertEquals(userProList[0].IPM_User_Role__c,IPM_ConstantUtils.IPM_ROLE_RD,FUNCTION_NOT_CALL_PROPERLY);
            
            ipmResAlloccation.SearchTeambyCat= IPM_ConstantUtils.TEAM_ALLCATEGORY; 
            ipmResAlloccation.RoleType =IPM_ConstantUtils.IPM_ROLE_GUEST;
            ipmResAlloccation.getSameCategory();
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            System.assertEquals(userProList[0].IPM_User_Role__c,IPM_ConstantUtils.IPM_ROLE_RD,FUNCTION_NOT_CALL_PROPERLY);
            
            ipmResAlloccation.SearchTeambyCat= IPM_ConstantUtils.TEAM_ALLCATEGORY; 
            ipmResAlloccation.RoleType = '';   
            ipmResAlloccation.getSameCategory();  
            system.assertEquals(ipmResAlloccation.SearchTeambyCat,IPM_ConstantUtils.TEAM_ALLCATEGORY,'Team Category is not validated');//Positive test 
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            System.assertEquals(userProList[0].IPM_User_Role__c,IPM_ConstantUtils.IPM_ROLE_RD,FUNCTION_NOT_CALL_PROPERLY);
            userProf.IPM_User_Role__c=IPM_ConstantUtils.PROJECT_LEADER;
            update userProf;
			IPM_user_profile__c userProfile = [SELECT Id,IPM_User_Role__c FROM IPM_user_profile__c WHERE Id =:userProf.id]; 
			System.assertEquals(IPM_ConstantUtils.PROJECT_LEADER,userProfile.IPM_User_Role__c , 'User Role Is updated');
			
            ipmResAlloccation.SearchTeambyCat= IPM_ConstantUtils.TEAM_ALLCATEGORY; 
            ipmResAlloccation.RoleType =IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE;   
            ipmResAlloccation.getSameCategory();  
            
            userProfList=[select Id,IPM_User_Role__c,IPM_Company_Card__c,IPM_Company_Card__r.RecordTypeId from IPM_User_Profile__c where Id=:userProf.Id limit 1];
            system.assertEquals(userProfList[0].IPM_User_Role__c,IPM_ConstantUtils.PROJECT_LEADER,'user profile updation fail');
            pageMessages = ApexPages.getMessages();  
        }
        Test.stopTest(); 
    }
    
    /*
    * @Description To check if the same category has been assigned to GD
    */
    static testMethod  void testAddMemberToWrapper()
    {
        initializeTestMethodData();
        
        system.RunAs(globalUser) 
        {
            test.startTest();
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            IPM_Resource_Allocation.wrapperclass wrp=new IPM_Resource_Allocation.wrapperclass(userProList[0]);
            wrp.checkboxuser=true;
            ipmResAlloccation.getSameCategory();
            System.assertEquals(true, wrp.checkboxuser,'Wraaper Check box Fails');
            
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            System.assertEquals(userProList[0].IPM_User_Role__c,IPM_ConstantUtils.PROJECT_LEADER,FUNCTION_NOT_CALL_PROPERLY);
            ipmResAlloccation.teamMembers.clear();
            ipmResAlloccation.addMemberToWrapper();
            ipmResAlloccation.teamMembers.add(wrp);
            ipmResAlloccation.addMemberToWrapper();
            ipmResAlloccation.HoldCoreMember(); 
            ipmResAlloccation.holdLeader(); 
            
        }
        Test.stopTest(); 
    }
    
    /*
    * @Description To check if the same category has been assigned to GD
    */
    static testMethod  void testFilterTeamMember()
    {
        initializeTestMethodData();
        
        system.RunAs(globalUser)
        {
            test.startTest();
            
            ipmResAlloccation.SearchTeamMem=DUMMY_MAIL_ID;
            ipmResAlloccation.SearchTeambyCat= IPM_ConstantUtils.TEAM_MYCATEGORY; 
            ipmResAlloccation.filterTeamMember(); 
            ipmResAlloccation.SearchTeambyCat= IPM_ConstantUtils.TEAM_ALLCATEGORY; 
            ipmResAlloccation.RoleType =IPM_ConstantUtils.IPM_ROLE_GUEST;
          
            ipmResAlloccation.filterTeamMember();
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            System.assertEquals(userProList[0].IPM_User_Role__c,IPM_ConstantUtils.PROJECT_LEADER,FUNCTION_NOT_CALL_PROPERLY);          
            ipmResAlloccation.RoleType =IPM_ConstantUtils.IPM_ROLE_BD;
            ipmResAlloccation.filterTeamMember(); 
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            System.assertEquals(userProList[0].IPM_User_Role__c,IPM_ConstantUtils.PROJECT_LEADER,FUNCTION_NOT_CALL_PROPERLY);
            ipmResAlloccation.SearchTeambyCat='';
            ipmResAlloccation.filterTeamMember();  
            ipmResAlloccation.searchTeamMem=IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE;
            ipmResAlloccation.SearchTeambyCat= IPM_ConstantUtils.TEAM_ALLCATEGORY; 
            ipmResAlloccation.changeRoleType =IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE;   
            ipmResAlloccation.filterTeamMember();          
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            System.assertEquals(userProList[0].IPM_User_Role__c,IPM_ConstantUtils.PROJECT_LEADER,FUNCTION_NOT_CALL_PROPERLY);
            pageMessages = ApexPages.getMessages();
        }
        Test.stopTest(); 
    }
    
    /*
    * @Description To check if the same category has been assigned to GD
    */
    static testMethod  void testGetAssignedTeamMember()
    {
        initializeTestMethodData();
       
        system.RunAs(globalUser){
            test.startTest();
            ipmResAlloccation.roleType=IPM_ConstantUtils.TEAM_RND;
            ipmResAlloccation.getAssignedTeamMember(); 
            List<IPM_Project_Resource__c>resList1=[SELECT id,IPM_User__c,IPM_User__r.name,IPM_User__r.SmallPhotoUrl,IPM_Project_Role_Owner__c,
            IPM_Role_Type__c FROM IPM_Project_Resource__c where Id=:projectResRecord.Id limit 1]; 
            System.assertEquals(resList1[0].IPM_Role_Type__c,IPM_ConstantUtils.TEAM_RND,FUNCTION_NOT_CALL_PROPERLY);  
            pageMessages = ApexPages.getMessages(); 
        }
        Test.stopTest(); 
    }
    
    /*
    * @Description To check if the same category has been assigned to GD
    */
    static testMethod  void testGetCoreMemberds()
    {
        initializeTestMethodData();
      
        system.RunAs(globalUser)
        {
            test.startTest();
            ipmResAlloccation.coreMembers=IPM_ConstantUtils.TEAM_COREPL;
            ipmResAlloccation.getCoreMemberds();
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            System.assertEquals(userProList[0].IPM_User_Role__c,IPM_ConstantUtils.PROJECT_LEADER,FUNCTION_NOT_CALL_PROPERLY);          
            ipmResAlloccation.coreMembers = IPM_ConstantUtils.TEAM_COREDPL;
            ipmResAlloccation.getCoreMemberds();
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            System.assertEquals(userProList[0].IPM_User_Role__c,IPM_ConstantUtils.PROJECT_LEADER,FUNCTION_NOT_CALL_PROPERLY);          
            ipmResAlloccation.coreMembers=IPM_ConstantUtils.TEAM_COREGATEK;
            ipmResAlloccation.getCoreMemberds();
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            System.assertEquals(userProList[0].IPM_User_Role__c,IPM_ConstantUtils.PROJECT_LEADER,FUNCTION_NOT_CALL_PROPERLY);
            ipmResAlloccation.coreMembers=IPM_ConstantUtils.TEAM_CORETPL;
            ipmResAlloccation.getCoreMemberds();
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            System.assertEquals(userProList[0].IPM_User_Role__c,IPM_ConstantUtils.PROJECT_LEADER,FUNCTION_NOT_CALL_PROPERLY);
            pageMessages = ApexPages.getMessages();
        }
        Test.stopTest(); 
    }
    
    /*
    * @Description To check if the same category has been assigned to GD
    */
    static testMethod  void testFilterCoreMember()
    {
        initializeTestMethodData();
        
        system.RunAs(globalUser)
        {
            test.startTest();
            ipmResAlloccation.coreMembers=IPM_ConstantUtils.TEAM_COREPL;
            ipmResAlloccation.filterCoreMember(); 
            
            ipmResAlloccation.coreMembers=IPM_ConstantUtils.TEAM_COREGATEK;
            ipmResAlloccation.filterCoreMember(); 
            ipmResAlloccation.coreMembers=IPM_ConstantUtils.TEAM_CORETPL;
            
            ipmResAlloccation.filterCoreMember(); 
            ipmResAlloccation.CoreMembers = IPM_ConstantUtils.TEAM_COREPL;
            ipmResAlloccation.filterCoreMember(); 
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            System.assertEquals(userProList[0].IPM_User_Role__c,IPM_ConstantUtils.PROJECT_LEADER,FUNCTION_NOT_CALL_PROPERLY);
            ipmResAlloccation.coreMembers=IPM_ConstantUtils.TEAM_COREPL;
            ipmResAlloccation.searchCoreTeam=globalUser.Name;
            ipmResAlloccation.filterCoreMember();
            system.assertEquals(ipmResAlloccation.lstUserProfile.isEmpty(),false,'UserProfilelist should not be empty');
            pageMessages = ApexPages.getMessages();
        }
        Test.stopTest(); 
    }
    


    
    /*
    * @Description To check if the same category has been assigned to GD
    */
    static testMethod  void testGetSameCategoryRolloutProfiles()
    {
        initializeTestMethodData();
       
        system.RunAs(globalUser)
        {
            test.startTest();
            ipmResAlloccation.projectID=null;
            ipmResAlloccation.UpdateCoreMember();
            ipmResAlloccation.projectID=project.Id;
            ipmResAlloccation.UpdateCoreMember();
            ipmResAlloccation.CoreMembers = IPM_ConstantUtils.TEAM_COREPL;
            ipmResAlloccation.UpdateCoreMember(); 
            
            ipmResAlloccation.CoreMembers = IPM_ConstantUtils.TEAM_COREDPL;
            ipmResAlloccation.UpdateCoreMember(); 
            
            ipmResAlloccation.CoreMembers = IPM_ConstantUtils.TEAM_COREGATEK;
            ipmResAlloccation.UpdateCoreMember(); 
            
            ipmResAlloccation.CoreMembers = IPM_ConstantUtils.TEAM_CORETPL;
            ipmResAlloccation.UpdateCoreMember();
            ipmResAlloccation.getSameCategoryRolloutProfiles();
            
            ipmResAlloccation.searchLeaderbyCat=IPM_ConstantUtils.TEAM_MYCATEGORY;
            ipmResAlloccation.getSameCategoryRolloutProfiles();
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c,IPM_User_Function__c,IPM_HoldCategory__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            System.assertEquals(userProList[0].IPM_User_Role__c,IPM_ConstantUtils.PROJECT_LEADER,FUNCTION_NOT_CALL_PROPERLY);
            ipmResAlloccation.searchLeaderbyCat=IPM_ConstantUtils.TEAM_ALLCATEGORY;
            ipmResAlloccation.getSameCategoryRolloutProfiles();
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c,IPM_User_Function__c,IPM_HoldCategory__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            System.assertEquals(userProList[0].IPM_User_Role__c,IPM_ConstantUtils.PROJECT_LEADER,FUNCTION_NOT_CALL_PROPERLY);
            ipmResAlloccation.isLeaderTypePL=true;
            ipmResAlloccation.category=USER_CATE;
            ipmResAlloccation.SearchLeaderbyCat=IPM_ConstantUtils.TEAM_MYCATEGORY;
            ipmResAlloccation.getSameCategoryRolloutProfiles();
            ipmResAlloccation.SearchLeaderbyCat=IPM_ConstantUtils.TEAM_ALLCATEGORY;
            ipmResAlloccation.getSameCategoryRolloutProfiles();
            userProf.IPM_User_Role__c=IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE;
            update userProf;
			IPM_user_profile__c userProfile = [SELECT Id,IPM_User_Role__c FROM IPM_user_profile__c WHERE Id =:userProf.id]; 
			System.assertEquals(IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE,userProfile.IPM_User_Role__c , 'User Role is not  updated');
			
            ipmResAlloccation.isLeaderTypeFL=true;
            ipmResAlloccation.isLeaderTypePL=false;
            ipmResAlloccation.category=USER_CATE;
            ipmResAlloccation.SearchLeaderbyCat=IPM_ConstantUtils.TEAM_MYCATEGORY;
            ipmResAlloccation.getSameCategoryRolloutProfiles();
            ipmResAlloccation.SearchLeaderbyCat=IPM_ConstantUtils.TEAM_ALLCATEGORY;
            ipmResAlloccation.getSameCategoryRolloutProfiles();
            system.assertEquals(ipmResAlloccation.leaderUsers.isEmpty(),false,'Userlist should not be empty');
            pageMessages = ApexPages.getMessages();
        }
        Test.stopTest(); 
    }
    /*
    * @Description To check if the same category has been assigned to GD
    */
    static testMethod  void testFilterLeaderMember()
    {
        initializeTestMethodData();
        
        system.RunAs(globalUser)
        {
            test.startTest();
            ipmResAlloccation.Category='fhhg';
            ipmResAlloccation.SearchLeader =globalUser.Name;
            ipmResAlloccation.filterLeaderMember();
            ipmResAlloccation.SearchLeader =string.valueOf(globalUser.Id);
            ipmResAlloccation.filterLeaderMember();
            userProList=[SELECT IPM_User__r.id,IPM_User_Role__c FROM IPM_user_profile__c WHERE id =:userProf.Id limit 10];
            System.assertEquals(userProList[0].IPM_User_Role__c,IPM_ConstantUtils.PROJECT_LEADER,FUNCTION_NOT_CALL_PROPERLY);
            pageMessages = ApexPages.getMessages();
        }
        Test.stopTest(); 
    }
    
    /*
    * @Description To check if the same category has been assigned to GD
    */
    static testMethod  void testAssignLeaderMember()
    {
        initializeTestMethodData();
       
        system.RunAs(globalUser)
        {
            test.startTest();
            ipmResAlloccation.rolloutId =projRollout.Id;
            ipmResAlloccation.SearchLeader =string.valueOf(globalUser.Id);
            ipmResAlloccation.SelectedLeaderMember =string.valueOf(globalUser.Id);
            ipmResAlloccation.ButtonLabel=IPM_ConstantUtils.USER_FUNCTON_PL;
            ipmResAlloccation.assignLeaderMember();
            ipmResAlloccation.projectID=project.id;
            ipmResAlloccation.assignLeaderMember(); 
            List<IPM_Project_Rollout__c>rolloutList1=[select Id,Name,RecordTypeId,Market_Cluster_Name__c,Finance_Member__c,IPM_Regional_PL_Text__c,IPM_Regional_PL__c, IPM_Finance_Member_Text__c,(Select Id,Country_Name__c from IPM_Countries_Local__r)  FROM IPM_Project_Rollout__c where Id=:projRollout.Id];
            System.assertEquals(rolloutList1[0].IPM_Regional_PL__c,globalUser.Id,FUNCTION_NOT_CALL_PROPERLY);
            ipmResAlloccation.ButtonLabel=IPM_ConstantUtils.USER_FUNCTON_FL;
            ipmResAlloccation.assignLeaderMember();
            projRollout.recordTypeId=Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId(); 
            update projRollout;
			
			System.assertEquals(Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId(),projRollout.recordTypeId,'Rollout type is invalid');
            ipmResAlloccation.assignLeaderMember();
            rolloutList1=[select Id,Name,Market_Cluster_Name__c,IPM_Regional_PL__c,Finance_Member__c,RecordTypeId,IPM_Regional_PL_Text__c, IPM_Finance_Member_Text__c,(Select Id,Country_Name__c from IPM_Countries_Local__r)  FROM IPM_Project_Rollout__c where Id=:projRollout.Id];
            System.assertEquals(rolloutList1[0].Finance_Member__c ,globalUser.Id,FUNCTION_NOT_CALL_PROPERLY);
            pageMessages = ApexPages.getMessages();
        }
        Test.stopTest(); 
    }  
    
    /*
    * @Description To check if the same category has been assigned to GD
    */
    static testMethod  void testCreatefinanceMember()
    {
        initializeTestMethodData();
       
        system.RunAs(globalUser)
        {
            test.startTest();
            Map<id,id> projUserMap = new Map<id,id>();
            projUserMap.put(null,globalUser.Id);
           
            projUserMap.put(project.id,globalUser.Id);
            IPM_Resource_Allocation.createfinanceMember(projUserMap);
            List<IPM_Project_Resource__c>resList1=[SELECT id,IPM_User__c,IPM_User__r.name,IPM_User__r.SmallPhotoUrl,IPM_Project_Role_Owner__c,
            IPM_Role_Type__c FROM IPM_Project_Resource__c where Id=:projectResRecord.Id limit 1]; 
            System.assertEquals(resList1[0].IPM_Role_Type__c,IPM_ConstantUtils.TEAM_RND,FUNCTION_NOT_CALL_PROPERLY);   
            IPM_Resource_Allocation.deletefinanceMember(projUserMap);
            resList1=new List<IPM_Project_Resource__c>();
            resList1=[SELECT Id FROM IPM_Project_Resource__c WHERE IPM_Role_Type__c=:IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE];
            System.assertEquals(resList1.size(),0,FUNCTION_NOT_CALL_PROPERLY);
            pageMessages = ApexPages.getMessages();
        }
        Test.stopTest(); 
    }
}