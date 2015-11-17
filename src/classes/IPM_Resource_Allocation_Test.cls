/*
* @Description Tests the resource allocation class
*/
@isTest
private class IPM_Resource_Allocation_Test{
    
    private static  string DUMMY_MAIL_ID='XXAAXX11@unilever.com';
    public static IPM_Project__c ipmProject;
    public static IPM_Project_Rollout__c projRollOut;
    public static IPM_User_Profile__c up;
    public static User resourceAlloctionUser;
    public static User resourceAlloctionUser1;
    public static Profile p;
    public static string invokedFrom;
    public static string invokedFrom2;
    private static final String  equalString ='Should be same';
    /*
    * @Description Constructor which initialised and prepares data needed for testing
    */
    
    static  void initialiseData(){
        
        PageReference pageRef = Page.IPM_ProjectSetup;
        Test.setCurrentPageReference(pageRef);
        Set<id> avoidDupUser= new Set<id> ();
       
        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id,Name FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        system.assert(Fps.Name == 'IPMNG_Basic',equalString);
        
        PermissionSetAssignment psa = new PermissionSetAssignment();
        resourceAlloctionUser = IPM_TestFactory_Helper.createUser(false); 
        System.runAs(resourceAlloctionUser) {
            psa.AssigneeId = resourceAlloctionUser.Id;
            psa.PermissionSetId = Fps.Id;
        }
        system.assert(psa.PermissionSetId == Fps.Id,equalString);
        
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        resourceAlloctionUser1 = IPM_TestFactory_Helper.createUserAdmin(false);
        System.runAs(resourceAlloctionUser1) {
            psa1.AssigneeId = resourceAlloctionUser1.Id;
            psa1.PermissionSetId = Fps.Id;
        }
       
        /*p = [SELECT Id FROM Profile WHERE Name='Standard user'];
        resourceAlloctionUser = IPM_TestFactory_Helper.createUser(false);
        resourceAlloctionUser.Email = DUMMY_MAIL_ID;
        resourceAlloctionUser.Alias = DUMMY_MAIL_ID.substring(2,3); 
        resourceAlloctionUser.EmailEncodingKey=IPM_ConstantUtils.USER_EMAIL_ENCODE;
        resourceAlloctionUser.LastName='IPMUSER_LASTNAME';
        resourceAlloctionUser.LanguageLocaleKey=IPM_ConstantUtils.USER_LOCALEKEY;
        resourceAlloctionUser.LocaleSidKey='en_US';
        
        resourceAlloctionUser.TimeZoneSidKey=IPM_ConstantUtils.USER_TIMEZONEKEY;
        resourceAlloctionUser.UserName=DUMMY_MAIL_ID; 
        resourceAlloctionUser.IPM_Category__c = IPM_ConstantUtils.TEST_STR;
        resourceAlloctionUser.IPM_Brand_Positioning__c= IPM_ConstantUtils.TEST_STR;
        resourceAlloctionUser.IPM_Brand_Name__c =IPM_ConstantUtils.TEST_STR;
        resourceAlloctionUser.IPM_Role__c=IPM_ConstantUtils.USER_IPM_ROLE;
        resourceAlloctionUser.IPM_Sub_Category__c=IPM_ConstantUtils.TEST_STR;
        resourceAlloctionUser.isActive =true;
        insert resourceAlloctionUser;
        User userObj=[select isActive from User where id=:resourceAlloctionUser.Id];
        system.assert(userObj.isActive,System.Label.IPM_Record_successfully_saved);
        
        resourceAlloctionUser1 = IPM_TestFactory_Helper.createUser(true);
        System.assertEquals(resourceAlloctionUser.Email,DUMMY_MAIL_ID,System.Label.IPM_Record_successfully_saved);*/
        
        //Insert User Profile
        
        
        up=new IPM_User_Profile__c();
        up=IPM_TestFactory_Helper.createUserProfile(false);
        up.IPM_User__c=resourceAlloctionUser.Id;
        up.IPM_User_Role__c='R&D';
        up.IPM_User_Function__c=IPM_ConstantUtils.PROJECT_LEADER;
        up.IPM_Central_Team__c=true;
        up.Export_Porfolio_Data__c=true;
        up.IPM_Work_Level__c='WL2';
        up.IPM_User_Function__c=IPM_ConstantUtils.PROJECT_LEADER;
        insert up;
        
        IPM_User_Profile__c userProfileObj=[select IPM_Central_Team__c from IPM_User_Profile__c where id=:up.Id];
        system.assert(userProfileObj.IPM_Central_Team__c,System.Label.IPM_Record_successfully_saved);
        
        System.assertEquals(up.IPM_User_Function__c,IPM_ConstantUtils.PROJECT_LEADER,System.Label.IPM_Record_successfully_saved);
        
        // invoked form 
        
        
        
        //Insert Project
        
        ipmProject = IPM_TestFactory_Helper.createIPMProject(false);
        ipmProject.IPM_Project_Name__c='TestNewGlobal';
        ipmProject.Sustainability_Period__c='3';
        ipmProject.IPMProject_Span__c =IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
        ipmProject.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
        ipmProject.IPM_ProjectSubType__c=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL_VALUE1;
        ipmProject.IPM_CompanyCardText__c = IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
        ipmProject.IPM_Selected_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
        ipmProject.IPM_Phase__c= IPM_ConstantUtils.PHASE_IDEAS;
        ipmProject.IPM_GateKeeping_Model__c=IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH; 
        ipmProject.IPM_PM_Approach__c = IPM_ConstantUtils.IPM_APPROACH_EXTERNAL;
        ipmProject.IPM_IsCompleted__c=false;
        ipmProject.IPM_Fast_Track_Project__c=false;
        ipmProject.IPM_Market_Type__c='Developing';
        ipmProject.IPM_Complexity__c= IPM_ConstantUtils.COMPLEXITY_LITE;
        ipmProject.Market_Cluster__c = 'GEO0023';
        ipmProject.Market_Cluster_Name__c ='South Asia';
        ipmProject.IPM_Target_Launch_Dates__c=System.today()+10;
        ipmProject.IPM_Answer_of_Q1__c='hi';
        ipmProject.IPM_Category_Text__c =IPM_ConstantUtils.TEAM_LAUNDRY;
        ipmProject.Deputy_Project_Leader__c=resourceAlloctionUser1.Id;
        ipmProject.IPM_Project_Gatekeeper__c=resourceAlloctionUser1.Id;
        ipmProject.IPM_Project_Leader__c=resourceAlloctionUser1.Id;
        ipmProject.IPM_Category_Text__c='Test';
        ipmProject.IPM_Technical_Project_Leader__c=resourceAlloctionUser1.Id;
        insert ipmProject;
        
        IPM_Project__c projectObj=[select Sustainability_Period__c from IPM_Project__c where id=:ipmProject.Id];
        system.assertEquals(projectObj.Sustainability_Period__c ,'3',System.Label.IPM_Record_successfully_saved);
        
        System.assertEquals(ipmProject.IPM_Technical_Project_Leader__c,resourceAlloctionUser1.Id,System.Label.IPM_Record_successfully_saved);
        avoidDupUser.add(ipmProject.Deputy_Project_Leader__c);
        avoidDupUser.add(ipmProject.IPM_Project_Gatekeeper__c);
        avoidDupUser.add(ipmProject.IPM_Project_Leader__c);
        avoidDupUser.add(ipmProject.IPM_Technical_Project_Leader__c);
        //Insert User
        
        invokedFrom ='xyz';
        invokedFrom2 = IPM_ConstantUtils.INVOKED_FROM_ROLLOUTS;
        //Insert Company Card 
        IPM_Company_Card__c comCard = IPM_TestFactory_Helper.createIPMCompanyCard(false);
        comCard.IPM_MCO__c='ANZ';
        insert comCard;
        IPM_Company_Card__c compCardObj=[select IPM_MCO__c from IPM_Company_Card__c where id=:comCard.Id];
        system.assertEquals(compCardObj.IPM_MCO__c,'ANZ',System.Label.IPM_Record_successfully_saved);
        
        System.assertNotEquals(comCard,Null,System.Label.IPM_Record_successfully_saved);
        
        //Insert Project Resource
        IPM_Project_Resource__c projRes = IPM_TestFactory_Helper.createIPMProjectResource(ipmProject.id ,false);
        projRes.IPM_Project__c=ipmProject.id;
        projRes.IPM_Role_Type__c= IPM_ConstantUtils.TEAM_GUEST;
        projRes.IPM_User__c=resourceAlloctionUser.Id;
        insert projRes;
        IPM_Project_Resource__c projectResObj=[select IPM_Role_Type__c from IPM_Project_Resource__c where id=:projRes.Id];
        system.assertEquals(projectResObj.IPM_Role_Type__c,IPM_ConstantUtils.TEAM_GUEST,System.Label.IPM_Record_successfully_saved);
        
        System.assertEquals( projRes.IPM_Project__c,ipmProject.id,System.Label.IPM_Record_successfully_saved);

        projRollOut=new IPM_Project_Rollout__c();
        projRollOut= IPM_TestFactory_Helper.createIPMProjectRollout(false);
        String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
        projRollOut=IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
        projRollOut.Name='TESTAPPROVERCL_SEAA';
        projRollOut.RecordTypeId=strRecordTypeId;
        projRollOut.IPM_Project__c=ipmProject.Id;
        projRollOut.Market_Cluster_Name__c='South Asia';
        projRollOut.Market_Cluster__c='GEO0023';
        projRollOut.MCO__c = 'LV4_GEO0077';
        projRollOut.MCO_Name__c = 'Other South Asia';
        projRollOut.Target_Launch_Date__c=date.today()+10;
        projRollOut.IPM_Regional_PL__c=resourceAlloctionUser1.Id;
        projRollOut.KeyMCO__c= true;
        projRollOut.Added_At_Stage__c=IPM_ConstantUtils.PHASE_IDEAS;
        projRollOut.IPM_Regional_PL_Text__c = 'regionla PL';
        projRollOut.IPM_Finance_Member_Text__c = 'Finance PL';
        insert projRollOut;
        
        IPM_Project_Rollout__c projectRolloutObj=[select KeyMCO__c from IPM_Project_Rollout__c where id=:projRollOut.Id];
        system.assert(projectRolloutObj.KeyMCO__c,System.Label.IPM_Record_successfully_saved);
        
        List<IPM_Project_Rollout__c> ls = [SELECT Id, Name, IPM_Regional_PL_Text__c, IPM_Finance_Member_Text__c FROM IPM_Project_Rollout__c WHERE Id = :projRollOut.Id limit 1];
        system.debug(' @@@ IPM_Project_Rollout__c id  -->'+ls);
        system.debug(' @@@ IPM_Project_Rollout__c id list -->'+ls[0].Id);
    }
    
    static  void initialiseDataForRollout(){
        
        PageReference pageRef = Page.IPM_ProjectSetup;
        Test.setCurrentPageReference(pageRef);
        Set<id> avoidDupUser= new Set<id> ();
       
        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id,Name FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        system.assert(Fps.Name == 'IPMNG_Basic',equalString);
        
        PermissionSetAssignment psa = new PermissionSetAssignment();
        resourceAlloctionUser = IPM_TestFactory_Helper.createUser(false); 
        System.runAs(resourceAlloctionUser) {
            psa.AssigneeId = resourceAlloctionUser.Id;
            psa.PermissionSetId = Fps.Id;
        }
        system.assert(psa.PermissionSetId == Fps.Id,equalString);
        
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        resourceAlloctionUser1 = IPM_TestFactory_Helper.createUserAdmin(false);
        System.runAs(resourceAlloctionUser1) {
            psa1.AssigneeId = resourceAlloctionUser1.Id;
            psa1.PermissionSetId = Fps.Id;
        }
       
        //Insert User Profile
        up=new IPM_User_Profile__c();
        up=IPM_TestFactory_Helper.createUserProfile(false);
        up.IPM_User__c=resourceAlloctionUser.Id;
        up.IPM_User_Role__c='R&D';
        up.IPM_User_Function__c=IPM_ConstantUtils.PROJECT_LEADER;
        up.IPM_Central_Team__c=true;
        up.Export_Porfolio_Data__c=true;
        up.IPM_Work_Level__c='WL2';
        up.IPM_User_Function__c=IPM_ConstantUtils.PROJECT_LEADER;
        insert up;
        
        IPM_User_Profile__c userProfileObj=[select IPM_Central_Team__c from IPM_User_Profile__c where id=:up.Id];
        system.assert(userProfileObj.IPM_Central_Team__c,System.Label.IPM_Record_successfully_saved);
        
        System.assertEquals(up.IPM_User_Function__c,IPM_ConstantUtils.PROJECT_LEADER,System.Label.IPM_Record_successfully_saved);
        
        //Insert Project
        
        ipmProject = IPM_TestFactory_Helper.createIPMProject(false);
        ipmProject.IPM_Project_Name__c='TestNewGlobal';
        ipmProject.Sustainability_Period__c='3';
        ipmProject.IPMProject_Span__c =IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
        ipmProject.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
        ipmProject.IPM_ProjectSubType__c=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL_VALUE1;
        ipmProject.IPM_CompanyCardText__c = IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
        ipmProject.IPM_Selected_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
        ipmProject.IPM_Phase__c= IPM_ConstantUtils.PHASE_IDEAS;
        ipmProject.IPM_GateKeeping_Model__c=IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH; 
        ipmProject.IPM_PM_Approach__c = IPM_ConstantUtils.IPM_APPROACH_EXTERNAL;
        ipmProject.IPM_IsCompleted__c=false;
        ipmProject.IPM_Fast_Track_Project__c=false;
        ipmProject.IPM_Market_Type__c='Developing';
        ipmProject.IPM_Complexity__c= IPM_ConstantUtils.COMPLEXITY_LITE;
        ipmProject.Market_Cluster__c = 'GEO0023';
        ipmProject.Market_Cluster_Name__c ='South Asia';
        ipmProject.IPM_Target_Launch_Dates__c=System.today()+10;
        ipmProject.IPM_Answer_of_Q1__c='hi';
        ipmProject.IPM_Category_Text__c =IPM_ConstantUtils.TEAM_LAUNDRY;
        ipmProject.Deputy_Project_Leader__c=resourceAlloctionUser1.Id;
        ipmProject.IPM_Project_Gatekeeper__c=resourceAlloctionUser1.Id;
        ipmProject.IPM_Project_Leader__c=resourceAlloctionUser1.Id;
        ipmProject.IPM_Category_Text__c='Test';
        ipmProject.IPM_Technical_Project_Leader__c=resourceAlloctionUser1.Id;
        insert ipmProject;
        
        IPM_Project__c projectObj=[select Sustainability_Period__c from IPM_Project__c where id=:ipmProject.Id];
        system.assertEquals(projectObj.Sustainability_Period__c ,'3',System.Label.IPM_Record_successfully_saved);
        
        System.assertEquals(ipmProject.IPM_Technical_Project_Leader__c,resourceAlloctionUser1.Id,System.Label.IPM_Record_successfully_saved);
        avoidDupUser.add(ipmProject.Deputy_Project_Leader__c);
        avoidDupUser.add(ipmProject.IPM_Project_Gatekeeper__c);
        avoidDupUser.add(ipmProject.IPM_Project_Leader__c);
        avoidDupUser.add(ipmProject.IPM_Technical_Project_Leader__c);
        
        invokedFrom2 = IPM_ConstantUtils.INVOKED_FROM_ROLLOUTS;
        
        //Insert Company Card 
        IPM_Company_Card__c comCard = IPM_TestFactory_Helper.createIPMCompanyCard(false);
        comCard.IPM_MCO__c='ANZ';
        insert comCard;
        
        IPM_Company_Card__c compCardObj=[select IPM_MCO__c from IPM_Company_Card__c where id=:comCard.Id];
        system.assertEquals(compCardObj.IPM_MCO__c,'ANZ',System.Label.IPM_Record_successfully_saved);
        
        System.assertNotEquals(comCard,Null,System.Label.IPM_Record_successfully_saved);
        
        //Insert Project Resource
        IPM_Project_Resource__c projRes = IPM_TestFactory_Helper.createIPMProjectResource(ipmProject.id ,false);
        projRes.IPM_Project__c=ipmProject.id;
        projRes.IPM_Role_Type__c= IPM_ConstantUtils.TEAM_GUEST;
        projRes.IPM_User__c=resourceAlloctionUser.Id;
        insert projRes;
        IPM_Project_Resource__c projectResObj=[select IPM_Role_Type__c from IPM_Project_Resource__c where id=:projRes.Id];
        system.assertEquals(projectResObj.IPM_Role_Type__c,IPM_ConstantUtils.TEAM_GUEST,System.Label.IPM_Record_successfully_saved);
        
        System.assertEquals( projRes.IPM_Project__c,ipmProject.id,System.Label.IPM_Record_successfully_saved);

        projRollOut=new IPM_Project_Rollout__c();
        projRollOut= IPM_TestFactory_Helper.createIPMProjectRollout(false);
        String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
        projRollOut=IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
        projRollOut.Name='TESTAPPROVERCL_SEAA';
        projRollOut.RecordTypeId=strRecordTypeId;
        projRollOut.IPM_Project__c=ipmProject.Id;
        projRollOut.Market_Cluster_Name__c='South Asia';
        projRollOut.Market_Cluster__c='GEO0023';
        projRollOut.MCO__c = 'LV4_GEO0077';
        projRollOut.MCO_Name__c = 'Other South Asia';
        projRollOut.Target_Launch_Date__c=date.today()+10;
        projRollOut.IPM_Regional_PL__c=resourceAlloctionUser1.Id;
        projRollOut.KeyMCO__c= true;
        projRollOut.Added_At_Stage__c=IPM_ConstantUtils.PHASE_IDEAS;
        projRollOut.IPM_Regional_PL_Text__c = 'regionla PL';
        projRollOut.IPM_Finance_Member_Text__c = 'Finance PL';
        insert projRollOut;
        
        IPM_Project_Rollout__c projectRolloutObj=[select KeyMCO__c from IPM_Project_Rollout__c where id=:projRollOut.Id];
        system.assert(projectRolloutObj.KeyMCO__c,System.Label.IPM_Record_successfully_saved);
    }
    /*
    * @Description To check if the same category has been assigned to GD
    */
    static testMethod  void testGetSameCategory(){
        initialiseData();
        User teamAUser = IPM_TestFactory_Helper.createUser(true);
        
        System.Assert(teamAUser.Id != null);//positive test
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_PROJECTID, ipmProject.id);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_ROLETYPE, IPM_ConstantUtils.TEAM_RND);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_CATEGORY, IPM_ConstantUtils.TEST_STR);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_PROJECT_LEAD, IPM_ConstantUtils.TEAM_TEST1);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_COREMEMBER, IPM_ConstantUtils.TEAM_TEST2);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_COREPL, IPM_ConstantUtils.TEAM_PL);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_CATEGORY, IPM_ConstantUtils.TEST_STR);
        Apexpages.currentpage().getParameters().put('rolloutId',projRollOut.Id); // put it in the page
        Apexpages.currentpage().getParameters().put(IPM_ConstantUtils.ROLLOUT_LEADER_TYPE,IPM_ConstantUtils.ROLLOUT_PL_TYPE);
        Apexpages.currentpage().getParameters().put(IPM_ConstantUtils.ROLLOUTID,projRollOut.Id);   // what we need to put          
        Apexpages.currentpage().getParameters().put(IPM_ConstantUtils.ROLLOUT_SPAN,IPM_ConstantUtils.ROLLOUT_SPAN_REGIONAL);
        Apexpages.currentpage().getParameters().put(IPM_ConstantUtils.INVOKED_FROM,invokedFrom); // what we need to put 
        IPM_Resource_Allocation  sic = new IPM_Resource_Allocation (); 
        
        Map<id,id> projUserMap = new Map<id,id>();
        IPM_Project__c ipmProjects = IPM_TestFactory_Helper.createIPMProject(false);
        ipmProjects.IPMProject_Span__c=IPM_ConstantUtils.ROLLOUT_SPAN_REGIONAL;
        ipmProjects.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        ipmProjects.IPM_Finance_Member__c=teamAUser.id;
        ipmProjects.IPM_Project_Leader__c=teamAUser.id;
        
        projUserMap.put(ipmProjects.id,teamAUser.Id);
        
        system.runas(teamAUser){
            Test.startTest();
            sic.isPLEdit=true;
            sic.searchLeaderbyCat=IPM_ConstantUtils.TEAM_MYCATEGORY;
            sic.isLeaderTypePL=true;
            sic.isLeaderTypeFL=true;
            sic.SelectedLeaderMember=String.valueOf(teamAUser);
            sic.SearchLeader='searchLeader';
            sic.isInvokedFromRollouts=true;
            string rollout = Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.ROLLOUTID); 
            sic.rolloutId=rollout;
                     
            
            system.debug('@@@ Rollout inside run as --> '+sic.rolloutId);
            string query='SELECT Id, Name, IPM_Regional_PL_Text__c, IPM_Finance_Member_Text__c FROM IPM_Project_Rollout__c WHERE Id = :rollout limit 1';
            
            List<IPM_Project_Rollout__c> ls = database.query(query);
            
            system.debug('@@@ Rollout inside list --> '+ls);
            sic.getSameCategory(); 
            sic.Category=IPM_ConstantUtils.TEAM_LAUNDRY;
            sic.SearchTeambyCat= IPM_ConstantUtils.TEAM_MYCATEGORY;
            sic.RoleType = IPM_ConstantUtils.IPM_ROLE_GUEST;
            sic.getSameCategory(); 
            system.assertEquals(sic.RoleType,IPM_ConstantUtils.IPM_ROLE_GUEST); //positive test
            sic.getSameCategory(); 
            sic.SearchTeambyCat= IPM_ConstantUtils.TEAM_ALLCATEGORY; 
            sic.RoleType =IPM_ConstantUtils.IPM_ROLE_GUEST;
            sic.getSameCategory();
            system.assertEquals(sic.SearchTeambyCat,IPM_ConstantUtils.TEAM_ALLCATEGORY);//Positive test 
            sic.SearchTeambyCat= IPM_ConstantUtils.TEAM_ALLCATEGORY; 
            sic.RoleType = '';    
            sic.getSameCategory();  
            system.assertEquals(sic.SearchTeambyCat,IPM_ConstantUtils.TEAM_ALLCATEGORY);//Positive test 
            
            sic.SearchTeamMem=DUMMY_MAIL_ID;
            sic.SearchTeambyCat= IPM_ConstantUtils.TEAM_MYCATEGORY; 
            sic.filterTeamMember(); 
            sic.SearchTeambyCat= IPM_ConstantUtils.TEAM_ALLCATEGORY; 
            sic.RoleType =IPM_ConstantUtils.IPM_ROLE_GUEST;
            sic.filterTeamMember(); 
            sic.RoleType =IPM_ConstantUtils.IPM_ROLE_BD;
            sic.filterTeamMember(); 
            sic.SearchTeambyCat='';
            sic.filterTeamMember();             
            system.assertEquals(sic.RoleType ,IPM_ConstantUtils.IPM_ROLE_BD, IPM_ConstantUtils.EXPECTED_TO_FILLED_IN);
            
            Integer tmBeforeAddition = sic.Teammembers.size();  
            sic.addMemberToWrapper(); 
            Integer tmAfterAddition = sic.Teammembers.size();  
            system.assertEquals(tmBeforeAddition,tmAfterAddition);//negative test scenario
            sic.RoleType=IPM_ConstantUtils.IPM_ROLE_GUEST;
            sic.getAssignedTeamMember(); 
            system.assertEquals(sic.RoleType,IPM_ConstantUtils.IPM_ROLE_GUEST, IPM_ConstantUtils.EXPECTED_TO_INCREASE_NOW);
            sic.coreMembers=IPM_ConstantUtils.TEAM_COREPL;
            sic.getCoreMemberds(); 
            sic.coreMembers = IPM_ConstantUtils.TEAM_COREDPL;
            sic.getCoreMemberds(); 
            sic.coreMembers=IPM_ConstantUtils.TEAM_COREGATEK;
            sic.getCoreMemberds();
            sic.coreMembers=IPM_ConstantUtils.TEAM_CORETPL;
            sic.getCoreMemberds();
            
            system.assertNotEquals(!sic.lstUserProfile.isEmpty(),true, IPM_ConstantUtils.INCREASE_BY_NOW);
            
            sic.coreMembers=IPM_ConstantUtils.TEAM_COREPL;
            sic.filterCoreMember(); 
            
            sic.coreMembers=IPM_ConstantUtils.TEAM_COREGATEK;
            sic.filterCoreMember(); 
            sic.coreMembers=IPM_ConstantUtils.TEAM_CORETPL;
            
            sic.filterCoreMember(); 
            sic.CoreMembers = IPM_ConstantUtils.TEAM_COREPL;
            sic.filterCoreMember(); 
            system.assertNotEquals(!sic.lstUserProfile.isEmpty(),true, IPM_ConstantUtils.INCREASE_BY_NOW);
            sic.UpdateCoreMember();
            sic.CoreMembers = IPM_ConstantUtils.TEAM_COREPL;
            sic.UpdateCoreMember(); 
            system.assertEquals(sic.CoreMembers ,IPM_ConstantUtils.TEAM_COREPL);//positive test
            sic.CoreMembers = IPM_ConstantUtils.TEAM_COREDPL;
            sic.UpdateCoreMember(); 
            system.assertEquals(sic.CoreMembers ,IPM_ConstantUtils.TEAM_COREDPL);//positive test
            sic.CoreMembers = IPM_ConstantUtils.TEAM_COREGATEK;
            sic.UpdateCoreMember(); 
            system.assertEquals(sic.CoreMembers ,IPM_ConstantUtils.TEAM_COREGATEK);//positive test
            sic.CoreMembers = IPM_ConstantUtils.TEAM_CORETPL;
            sic.UpdateCoreMember(); 
            system.assertEquals(sic.CoreMembers ,IPM_ConstantUtils.TEAM_CORETPL);//positive test
            sic.HoldCoreMember(); 
            sic.holdLeader();
            sic.getSameCategoryRolloutProfiles();
            sic.searchLeaderbyCat=IPM_ConstantUtils.TEAM_ALLCATEGORY;
            sic.getSameCategoryRolloutProfiles();
            
            system.debug('@@@ URL -->>'+rollout);  
                  
            sic.filterLeaderMember();
            
            
            sic.assignLeaderMember();
            IPM_Resource_Allocation.createfinanceMember(projUserMap);
            IPM_Resource_Allocation.deletefinanceMember(projUserMap);
            system.assertEquals(!ProjUserMap.isEmpty(),true);//positive test
            
        }
        Test.stopTest(); 
    }
    
    
    static testMethod  void testForRollout(){
        initialiseDataForRollout();
        User teamAUser = IPM_TestFactory_Helper.createUser(true);
        
        System.Assert(teamAUser.Id != null);//positive test
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_PROJECTID, ipmProject.id);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_ROLETYPE, IPM_ConstantUtils.TEAM_RND);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_CATEGORY, IPM_ConstantUtils.TEST_STR);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_PROJECT_LEAD, IPM_ConstantUtils.TEAM_TEST1);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_COREMEMBER, IPM_ConstantUtils.TEAM_TEST2);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_COREPL, IPM_ConstantUtils.TEAM_PL);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_CATEGORY, IPM_ConstantUtils.TEST_STR);
        Apexpages.currentpage().getParameters().put('rolloutId',projRollOut.Id); // put it in the page
        Apexpages.currentpage().getParameters().put(IPM_ConstantUtils.ROLLOUT_LEADER_TYPE,IPM_ConstantUtils.ROLLOUT_PL_TYPE);
        Apexpages.currentpage().getParameters().put(IPM_ConstantUtils.ROLLOUTID,projRollOut.Id);   // what we need to put          
        Apexpages.currentpage().getParameters().put(IPM_ConstantUtils.ROLLOUT_SPAN,IPM_ConstantUtils.ROLLOUT_SPAN_REGIONAL);
        Apexpages.currentpage().getParameters().put(IPM_ConstantUtils.INVOKED_FROM,invokedFrom2); // what we need to put 
        IPM_Resource_Allocation  sic = new IPM_Resource_Allocation (); 
        
        Map<id,id> projUserMap = new Map<id,id>();
        IPM_Project__c ipmProjects = IPM_TestFactory_Helper.createIPMProject(false);
        ipmProjects.IPMProject_Span__c=IPM_ConstantUtils.ROLLOUT_SPAN_REGIONAL;
        ipmProjects.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        ipmProjects.IPM_Finance_Member__c=teamAUser.id;
        ipmProjects.IPM_Project_Leader__c=teamAUser.id;
        
        sic.isPLEdit=true;
        sic.searchLeaderbyCat=IPM_ConstantUtils.TEAM_MYCATEGORY;
        sic.isLeaderTypePL=true;
        sic.isLeaderTypeFL=true;
        sic.SelectedLeaderMember=resourceAlloctionUser.Id;
        sic.SearchLeader='searchLeader';
        sic.isInvokedFromRollouts=true;
        string rollout = Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.ROLLOUTID); 
        sic.rolloutId=rollout;
        sic.holdLeader();
        sic.getSameCategoryRolloutProfiles();
        sic.searchLeaderbyCat=IPM_ConstantUtils.TEAM_ALLCATEGORY;
        sic.getSameCategoryRolloutProfiles();
        sic.filterLeaderMember();
        sic.assignLeaderMember();    
        
    }
    
    static testMethod  void testForRollout2(){
        initialiseDataForRollout();
        User teamAUser = IPM_TestFactory_Helper.createUser(true);
        
        System.Assert(teamAUser.Id != null);//positive test
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_PROJECTID, ipmProject.id);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_ROLETYPE, IPM_ConstantUtils.TEAM_RND);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_CATEGORY, IPM_ConstantUtils.TEST_STR);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_PROJECT_LEAD, IPM_ConstantUtils.TEAM_TEST1);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_COREMEMBER, IPM_ConstantUtils.TEAM_TEST2);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_COREPL, IPM_ConstantUtils.TEAM_PL);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_CATEGORY, IPM_ConstantUtils.TEST_STR);
        Apexpages.currentpage().getParameters().put('rolloutId',projRollOut.Id); // put it in the page
        Apexpages.currentpage().getParameters().put(IPM_ConstantUtils.ROLLOUT_LEADER_TYPE,IPM_ConstantUtils.ROLLOUT_FL_TYPE);
        Apexpages.currentpage().getParameters().put(IPM_ConstantUtils.ROLLOUTID,projRollOut.Id);   // what we need to put          
        Apexpages.currentpage().getParameters().put(IPM_ConstantUtils.ROLLOUT_SPAN,IPM_ConstantUtils.ROLLOUT_SPAN_REGIONAL);
        Apexpages.currentpage().getParameters().put(IPM_ConstantUtils.INVOKED_FROM,invokedFrom2); // what we need to put 
        IPM_Resource_Allocation  sic = new IPM_Resource_Allocation (); 
        
        Map<id,id> projUserMap = new Map<id,id>();
        IPM_Project__c ipmProjects = IPM_TestFactory_Helper.createIPMProject(false);
        ipmProjects.IPMProject_Span__c=IPM_ConstantUtils.ROLLOUT_SPAN_REGIONAL;
        ipmProjects.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        ipmProjects.IPM_Finance_Member__c=teamAUser.id;
        ipmProjects.IPM_Project_Leader__c=teamAUser.id;
        
        sic.isPLEdit=true;
        sic.searchLeaderbyCat=IPM_ConstantUtils.TEAM_MYCATEGORY;
        sic.isLeaderTypePL=true;
        sic.isLeaderTypeFL=true;
        sic.SelectedLeaderMember=resourceAlloctionUser.Id;
        sic.SearchLeader='searchLeader';
        sic.isInvokedFromRollouts=true;
        string rollout = Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.ROLLOUTID); 
        sic.rolloutId=rollout;
        sic.holdLeader();
        sic.getSameCategoryRolloutProfiles();
        sic.searchLeaderbyCat=IPM_ConstantUtils.TEAM_ALLCATEGORY;
        sic.getSameCategoryRolloutProfiles();
        sic.filterLeaderMember();
        sic.assignLeaderMember();
    }
    
    static testMethod  void testForRollout3(){
        initialiseDataForRollout();
        User teamAUser = IPM_TestFactory_Helper.createUser(true);
        
        System.Assert(teamAUser.Id != null);//positive test
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_PROJECTID, ipmProject.id);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_ROLETYPE, IPM_ConstantUtils.TEAM_RND);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_PROJECT_LEAD, IPM_ConstantUtils.TEAM_TEST1);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_COREMEMBER, IPM_ConstantUtils.TEAM_TEST2);
        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_COREPL, IPM_ConstantUtils.TEAM_PL);
        //ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.TEAM_CATEGORY, null);
        Apexpages.currentpage().getParameters().put('rolloutId',projRollOut.Id); // put it in the page
        Apexpages.currentpage().getParameters().put(IPM_ConstantUtils.ROLLOUT_LEADER_TYPE,IPM_ConstantUtils.ROLLOUT_FL_TYPE);
        Apexpages.currentpage().getParameters().put(IPM_ConstantUtils.ROLLOUTID,projRollOut.Id);   // what we need to put          
        Apexpages.currentpage().getParameters().put(IPM_ConstantUtils.ROLLOUT_SPAN,IPM_ConstantUtils.ROLLOUT_SPAN_REGIONAL);
        Apexpages.currentpage().getParameters().put(IPM_ConstantUtils.INVOKED_FROM,invokedFrom2); // what we need to put 
        IPM_Resource_Allocation  sic = new IPM_Resource_Allocation (); 
        
        Map<id,id> projUserMap = new Map<id,id>();
        IPM_Project__c ipmProjects = IPM_TestFactory_Helper.createIPMProject(false);
        ipmProjects.IPMProject_Span__c=IPM_ConstantUtils.ROLLOUT_SPAN_REGIONAL;
        ipmProjects.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        ipmProjects.IPM_Finance_Member__c=teamAUser.id;
        ipmProjects.IPM_Project_Leader__c=teamAUser.id;
        
        sic.isPLEdit=true;
        sic.searchLeaderbyCat=IPM_ConstantUtils.TEAM_MYCATEGORY;
        sic.isLeaderTypePL=true;
        sic.isLeaderTypeFL=true;
        sic.SelectedLeaderMember=resourceAlloctionUser.Id;
        sic.SearchLeader=null;
        sic.isInvokedFromRollouts=true;
        string rollout = Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.ROLLOUTID); 
        sic.rolloutId=rollout;
        sic.holdLeader();
        sic.category = null;
        sic.getSameCategoryRolloutProfiles();
        sic.searchLeaderbyCat=IPM_ConstantUtils.TEAM_ALLCATEGORY;
        sic.getSameCategoryRolloutProfiles();
        sic.filterLeaderMember();
        sic.assignLeaderMember();
    }
}