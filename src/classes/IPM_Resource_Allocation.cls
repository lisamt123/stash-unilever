/*************************************************************************************************************
* @author:Cognizant
* @date: 25/09/2014
* @description:add new team members in current project.
*    and assign project leader,deputy project leader and gatekeeper based on company card of current project.
*    assign technical project leader.
Assign PL or FL for rollouts.
* @reference:IPM_Resource_Allocation_PartRevamp page
@Business Logic: This class is used to Allocate the Resources in a Project across various Roles eg: BD, FInancie,Guest etc.
				This class also is used to Support the PL selection for the Rollouts. The user is selected based on the category, 
				userprofile and company card information availavble. If a user foesnot belong to the company card for which it is selected. The Business logic suggest to dynamically create the same.

*/
public with sharing class IPM_Resource_Allocation {   
    
    //String Literals replacement
    private static final String QUERY_ROLE_STR = 'IPM_User_Role__c=\'';
    private static final String QUERY_FIELDS_STR = 'ipm_user__r.smallphotourl,';
    private static final String QUERY_WHERE_STR = 'IPM_User__r.UserRole.Name FROM IPM_user_profile__c WHERE  (IPM_User__r.IsActive=True ';
    private static final String QUERY_HOLDCATEGORY_STR = ' and IPM_HoldCategory__c like \'%';
    private static final String QUERY_STRING_PROFILE='IPM_User__r.UserRole.Name FROM IPM_user_profile__c WHERE  (IPM_User__r.IsActive=True AND ';
    public static final String IPM_RESOURCEALLOCATION_STR = IPM_Resource_Allocation.class.getName();
    private static final string ADD_MEMBER_TO_WRAPPER = 'AddMemberToWrapper';
    private static final string UPDATE_CORE_MEMBER = 'UpdateCoreMember';
    private static final string CREATE_FINANCE_MEMBER ='createfinanceMember';
    private static final string DELETE_FINANCE_MEMBER ='deletefinanceMember';
    private static final string FILTER_LEADER_MEMBER ='FilterLeaderMember';
    private static final string SAME_CATEGORY_ROLLOUT_PROFILES ='getSameCategoryRolloutProfiles';
    private static final string ASSIGN_LEADER_MEMBER ='assignLeaderMember'; // used in exception message
    private static final string BEGIN_QUERY ='SELECT IPM_User__c,IPM_User_Role__c,IPM_User__r.name,IPM_User__r.email,';
    private static final string BEGIN_QUERY_TEAM ='SELECT IPM_User__r.id,IPM_User_Role__c,IPM_User__r.name,IPM_User__r.email,';
    private static final string MID_QUERY_TEAM =' IPM_User__r.SmallPhotoUrl,';
    private static final string PERCENTAGE_SLASH='%\'';
    private static final string QUERY_LIMIT=' limit 50000';
    //@description:To store project id FROM url parameter

    public String projectID{get;set;}
    //@description:To store role type FROM url parameter
    public String roleType{get;set;}
    //@description:To store category FROM url parameter
    public String category{get;set;}
    //@description:get a list of assigned member
    public list<IPM_Project_Resource__c>assignedMember{get;set;}
    //@description:get a set of assigned member
    public set<String>assignedList=new set<string>();
    //@description:hold PL value
    public string PL{get;set;}
    //@description:hold DPL value
    public string DPL{get;set;}
    //@description:checking whether PL has edit access
    public boolean isPLEdit{get;set;}
    //@description:wrapper class to add new team members
    public list<wrapperclass> teamMembers{get;set;}
    //@description:hold search member value
    public String searchTeamMem{get;set;}
    //@description:hold search member by category
    public string searchTeambyCat{get;set;}
    //@description:hold search leader member by category
    public string searchLeaderbyCat{get;set;}
    //@description:hold core member details FROM url
    public string coreMembers{get;set;}
    //@description:list of user profile details
    public list<IPM_User_Profile__c>lstUserProfile{get;set;}
    //@description:hold project company card name
    public string CCardName{get;set;}
    //@description:hold search core member value FROM page
    public string searchCoreTeam{get;set;}
    //@description:hold search leader member value FROM page
    public string searchLeader{get;set;}
    //@description:hold SELECTed core member value FROM page
    public string selecetedCoreMember{get;set;}
    //@description:hold button label value
    public string buttonLabel{get;set;}
    //@description:if no match found while search member FROM filter
    public string isNoMatchfound{get;set;}
    //@description:get user role type
    public string changeRoleType{get;set;}
    //@description:get already added members for current project
    public set<id>oldresourceid=new set<id>();
    //@description:set of duplicate members
    public set<id>avoidDupUser{get;set;}
    
    //@description:to distinguish if the page is invoked from Rollouts to use selectOptions instead of checkboxes for user selection
    public Boolean isInvokedFromRollouts{get;set;}
    //@description:Rollouts user selection type - PL/FL
    public String leaderType{get;set;}
    //@description:to distinguish if the Rollouts user selection is for PL
    public Boolean isLeaderTypePL{get;set;}
    //@description:to distinguish if the Rollouts user selection is for FL
    public Boolean isLeaderTypeFL{get;set;}
    
    //@description:hold SELECTed leader member value FROM page
    public string selectedLeaderMember{get;set;}
    //@description:hold SELECTed leader member value FROM page
    public string rolloutId{get;set;}
    //@description:hold SELECTed span of rollout leader member value FROM page
    public string rolloutSpan{get;set;}
    //@description: leader user profiles filtered from IPM_RolloutPlansTableController 
    public list<IPM_User_Profile__c> leaderUsers{get;set;}
   
  
    @TestVisible private static final String REGIONAL_ROLLOUT_RECORDTYPE =Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).getRecordTypeId(); //Recordtype Id for Regional Rollouts on IPM_Project_Rollout__c object cant delete it using in the query below
    @TestVisible private static final String LOCAL_ROLLOUT_RECORDTYPE =Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId(); //Recordtype Id for Local Rollouts on IPM_Project_Rollout__c object cant delete it using in the query below
    
    /*************************************************************************************************************
    * @description:Constructor of the class.get all url parameter values in variables.get project details.
    */
    public IPM_Resource_Allocation (){
    
        IPM_IECompatible.ieFix();//Added for compatibility fix
        avoidDupUser=new set<id>();
        string RoletypeRND=IPM_ConstantUtils.BLANK;
        searchTeambyCat=IPM_ConstantUtils.TEAM_MYCATEGORY;
        isNoMatchfound=IPM_ConstantUtils.BLANK;
        changeRoleType=IPM_ConstantUtils.BLANK;
        isLeaderTypePL=false;
        isLeaderTypeFL=false;
        isInvokedFromRollouts = false;
        
        projectID=Apexpages.currentpage().getParameters().get(String.escapeSingleQuotes(IPM_ConstantUtils.TEAM_PROJECTID));
        IPM_Project__c ipmproject=[SELECT id,Deputy_Project_Leader__c,IPM_Project_Gatekeeper__c,IPM_Project_Leader__c,IPMProject_Span__c,
            IPM_Technical_Project_Leader__c,IPM_Company_Card__c,IPM_Category_Text__c FROM 
            IPM_Project__c WHERE id=:projectID LIMIT 1];
        category=Ipmproject.IPM_Category_Text__c;

        // get user profile map
        string invokedFrom = Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.INVOKED_FROM); 
        if(invokedFrom != Null && invokedFrom.equals(IPM_ConstantUtils.INVOKED_FROM_ROLLOUTS))
        {
            isInvokedFromRollouts = true;   
        }
        
      
        // check if the Team Management is invoked or Member (PL and Finance) selection for Rollouts is invoked
       if(isInvokedFromRollouts!=null && isInvokedFromRollouts)
        {
            leaderUsers = new list<IPM_User_Profile__c>();
            
            leaderType = Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.ROLLOUT_LEADER_TYPE);           
            rolloutId = Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.ROLLOUTID);            
            rolloutSpan = Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.ROLLOUT_SPAN);
            
            if(leaderType != Null && leaderType==IPM_ConstantUtils.ROLLOUT_PL_TYPE)
            {
                isLeaderTypePL = true;  
              
                if(leaderType==IPM_ConstantUtils.ROLLOUT_PL_TYPE && rolloutSpan == IPM_ConstantUtils.ROLLOUT_SPAN_REGIONAL)
                {
                    ButtonLabel=IPM_ConstantUtils.USER_FUNCTON_PL;
                }
                else if(leaderType==IPM_ConstantUtils.ROLLOUT_PL_TYPE && rolloutSpan == IPM_ConstantUtils.ROLLOUT_SPAN_LOCAL)
                {
                    ButtonLabel=IPM_ConstantUtils.USER_FUNCTON_CL;
                }
            }
            else if(leaderType==IPM_ConstantUtils.ROLLOUT_FL_TYPE)
            {
                isLeaderTypeFL = true; 
                ButtonLabel=IPM_ConstantUtils.USER_FUNCTON_FL;
            }  
            
            getSameCategoryRolloutProfiles();      
        }else
        {
            if(String.IsNotBlank(String.valueOf(ipmproject.Deputy_Project_Leader__c)))
            {
                avoidDupUser.add(ipmproject.Deputy_Project_Leader__c);
            }
            if(String.IsNotBlank(String.valueOf(ipmproject.IPM_Project_Gatekeeper__c)))
            {
                avoidDupUser.add(ipmproject.IPM_Project_Gatekeeper__c);
            }
            if(String.IsNotBlank(String.valueOf(ipmproject.IPM_Project_Leader__c)))
            {
                avoidDupUser.add(Ipmproject.IPM_Project_Leader__c);
            }
            if(String.IsNotBlank(String.valueOf(ipmproject.IPM_Technical_Project_Leader__c)))
            {
                avoidDupUser.add(Ipmproject.IPM_Technical_Project_Leader__c);
            }
            
            PL=Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.TEAM_PL);
            
            DPL=Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.TEAM_DPL); 
            
            
            if(IPM_ConstantUtils.TEAM_TRUE==PL||IPM_ConstantUtils.TEAM_TRUE==DPL)
            {
                isPLEdit=true;
            }
            projectID=String.escapeSingleQuotes(projectID);
            
            roleType=Apexpages.currentpage().getParameters().get(String.escapeSingleQuotes(IPM_ConstantUtils.TEAM_ROLETYPE));
            
            RoletypeRND=Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.TEAM_ROLETYPE);
            
                 
            coreMembers=Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.TEAM_COREMEMBER);
            
            CCardName=Ipmproject.IPM_Company_Card__c;
            if(IPM_ConstantUtils.TEAM_RND==RoletypeRND)
            {
                roleType=IPM_ConstantUtils.TEAM_RESEARCH_DEVELOPMENT;
            }
            changeRoleType = roleType;
            
            if(IPM_ConstantUtils.TEAM_GUEST==roleType)
            {
                searchTeambyCat=IPM_ConstantUtils.TEAM_ALLCATEGORY;
            }
            //get list of role FROM user object
            getAssignedTeamMember();
            getSameCategory();
            GetCoreMemberds();
        }
    }
    /*************************************************************************************************************
    * @description:Get all members FROM same category for functional role.
    */
    public void getSameCategory()
    {
        
        
        list<IPM_Project_Resource__c>lstoldres=[SELECT IPM_User__c FROM IPM_Project_Resource__c WHERE IPM_Project__c=:projectID LIMIT 50000];
        
        map<id,id>uniqueUsers=new map<id,id>();
        for(IPM_Project_Resource__c res:lstoldres)
        {
            oldresourceid.add(res.IPM_User__c);
        }

        teamMembers=new list<wrapperclass>();
        list<IPM_User_Profile__c>lstuser=new list<IPM_User_Profile__c>();
        string UQuery=IPM_ConstantUtils.BLANK;      
        
        if(searchTeambyCat==IPM_ConstantUtils.TEAM_MYCATEGORY)
        {
            UQuery=IPM_ConstantUtils.BLANK;
            UQuery = BEGIN_QUERY_TEAM;
            UQuery = UQuery+MID_QUERY_TEAM;
            UQuery = UQuery+QUERY_STRING_PROFILE;
            UQuery = UQuery+' IPM_User_Category__c INCLUDES (:category)';
            
           
            if(String.IsNotBlank(String.valueOf(changeRoleType)))
            {
                UQuery=UQuery+' AND '+QUERY_ROLE_STR+String.escapeSingleQuotes(changeRoleType)+'\'';
            }
            UQuery= UQuery + '  ) AND IPM_User__r.id NOT IN :oldresourceid'+QUERY_LIMIT;
            
        }
        else if(IPM_ConstantUtils.TEAM_ALLCATEGORY==searchTeambyCat)
        {
            if(IPM_ConstantUtils.TEAM_GUEST==roleType)
            {
                UQuery=IPM_ConstantUtils.BLANK;
                UQuery =BEGIN_QUERY_TEAM;
                UQuery = UQuery+MID_QUERY_TEAM;
                UQuery = UQuery+'IPM_User__r.UserRole.Name FROM IPM_user_profile__c WHERE  (IPM_User__r.IsActive=True';
                UQuery = UQuery+' AND IPM_HoldCategory__c!=null) ';
                UQuery = UQuery+'AND IPM_User__r.id NOT IN :oldresourceid '+QUERY_LIMIT;
                
            }
            else
            {
                UQuery =IPM_ConstantUtils.BLANK;
                UQuery = BEGIN_QUERY_TEAM;
                UQuery = UQuery+MID_QUERY_TEAM;
                UQuery = UQuery+QUERY_STRING_PROFILE;
                UQuery = UQuery+' IPM_HoldCategory__c != null ';
                if(String.IsNotBlank(String.valueOf(changeRoleType)))
                {
                    UQuery = UQuery+' AND '+QUERY_ROLE_STR+String.escapeSingleQuotes(changeRoleType)+'\' ';
                }
                UQuery = UQuery+' ) AND IPM_User__r.id NOT IN :oldresourceid '+QUERY_LIMIT;
            } 
        }
        try
        {
            lstuser=database.query(UQuery);
        }
        catch(QueryException ex)
        {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));
        }

        for(IPM_User_Profile__c u:lstuser)
        {
            if((avoidDupUser.contains(u.IPM_User__r.id) && u.IPM_User_Role__c == IPM_ConstantUtils.FUNCTIONAL_ROLE_RD) || !avoidDupUser.contains(u.IPM_User__r.id) )
            {
                uniqueUsers.put(u.IPM_User__c,u.id);
            }
        }
        
        lstuser=[SELECT IPM_User__r.id,IPM_User_Role__c,IPM_User__r.name,
        IPM_User__r.email,IPM_User__r.SmallPhotoUrl,
        IPM_User__r.UserRole.Name 
        FROM IPM_user_profile__c WHERE id IN:uniqueUsers.values()];
        for(IPM_User_Profile__c u:lstuser)
        {
            teamMembers.add(new wrapperclass(u));
        }
        
    }
    /*************************************************************************************************************
    * @description:Search for same category members
    */
    public void filterTeamMember()
    {
        map<id,id>uniqueUsers=new map<id,id>();
        teamMembers=new list<wrapperclass>();
        list<IPM_User_Profile__c>lstuser=new list<IPM_User_Profile__c>();
        string uQuery=IPM_ConstantUtils.BLANK;
       
        string querySearchTeamMem=IPM_ConstantUtils.PERCENTAGE+String.escapeSingleQuotes(searchTeamMem) +IPM_ConstantUtils.PERCENTAGE;//used in the query below
        UQuery='SELECT IPM_User__r.id,IPM_User_Role__c,IPM_User__r.name,IPM_User__r.email, ';
        uQuery=uQuery+QUERY_FIELDS_STR;
        uQuery=uQuery+QUERY_WHERE_STR;
        
        if(searchTeambyCat==IPM_ConstantUtils.TEAM_MYCATEGORY){
            
            if(String.IsNotBlank(category))
            {
                
                uQuery=uQuery+QUERY_HOLDCATEGORY_STR + String.escapeSingleQuotes(category) + '%\')' +' AND ';
            }
            
            if(String.IsNotBlank(changeRoleType))
            {
                
                uQuery= uQuery+QUERY_ROLE_STR+String.escapeSingleQuotes(changeRoleType)+'\''; 
            }
          
            uQuery=uQuery+' AND (IPM_User__r.name LIKE :querySearchTeamMem  OR ';
            uQuery=uQuery+'IPM_User__r.email LIKE :querySearchTeamMem OR  IPM_User_Role__c LIKE :querySearchTeamMem)';
            uQuery=uQuery+' AND IPM_User__r.id !=:oldresourceid '+QUERY_LIMIT;
           
        }
        else if(searchTeambyCat==IPM_ConstantUtils.TEAM_ALLCATEGORY )
        {
            if(roleType==IPM_ConstantUtils.TEAM_GUEST)
            {
                uQuery=uQuery+' AND IPM_HoldCategory__c !=null)AND';
                uQuery=uQuery+'(IPM_User__r.name LIKE :querySearchTeamMem  OR IPM_User__r.email LIKE :querySearchTeamMem OR ';
                uQuery=uQuery+'IPM_User_Role__c LIKE :querySearchTeamMem) AND IPM_User__r.id !=:oldresourceid '+QUERY_LIMIT;
            }
            else
            {
                uQuery=uQuery+' AND IPM_HoldCategory__c !=null AND ';
                uQuery=uQuery+QUERY_ROLE_STR+String.escapeSingleQuotes(changeRoleType)+'\')AND(IPM_User__r.name LIKE :querySearchTeamMem  OR ';
                uQuery=uQuery+'IPM_User__r.email LIKE :querySearchTeamMem OR  IPM_User_Role__c LIKE :querySearchTeamMem)';
                uQuery=uQuery+'AND IPM_User__r.id !=:oldresourceid '+QUERY_LIMIT;
            }
        }
        try
        {
            
            lstuser=database.query(uQuery);
            
        }
        catch(QueryException ex)
        {
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
            'filterTeamMember',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null); 
        }
        if(lstuser.isEmpty())
        {
            isNoMatchfound=IPM_ConstantUtils.TEAM_TRUE;
        }
        else
        {
            isNoMatchfound=IPM_ConstantUtils.BLANK;
        }
        for(IPM_User_Profile__c u:lstuser)
        {
            if((avoidDupUser.contains(u.IPM_User__r.id) && u.IPM_User_Role__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_RD) || !avoidDupUser.contains(u.IPM_User__r.id) )
            {
                uniqueUsers.put(u.IPM_User__c,u.id);
            }
        }
        
        
        lstuser=[SELECT IPM_User__r.id,IPM_User_Role__c,IPM_User__r.name,IPM_User__r.email,
        IPM_User__r.SmallPhotoUrl, 
        IPM_User__r.UserRole.Name FROM IPM_user_profile__c WHERE id IN:uniqueUsers.values() limit 50000];
        
        
        for(IPM_User_Profile__c u:lstuser)
        {
            teamMembers.add(new wrapperclass(u));
        }
    }
    /*************************************************************************************************************
    * @description:Add members FROM same category which are SELECTed FROM page
    */
    public void addMemberToWrapper()
    {
        list<IPM_Project_Resource__c>lstnewResource=new list<IPM_Project_Resource__c>();
        
        for(wrapperclass MAdd:teamMembers)
        {
            if(MAdd.checkboxuser != null && MAdd.checkboxuser)
            {
                
                IPM_Project_Resource__c iPMresource=new IPM_Project_Resource__c();
                iPMresource=new IPM_Project_Resource__c();
                iPMresource.IPM_Project__c= projectID;
                iPMresource.IPM_User__c=MAdd.listofuser.IPM_User__r.id;
                iPMresource.IPM_Role_Type__c=roleType;
                
                if(CountProjectMembers(roleType)>0 && !roleType.equals(IPM_ConstantUtils.IPM_ROLE_GUEST))
                {
                    iPMresource.IPM_Project_Role_Owner__c=false;
                }
                else if(CountProjectMembers(roleType)==0 && lstnewResource.isEmpty() && !roleType.equals(IPM_ConstantUtils.IPM_ROLE_GUEST))
                {
                    iPMresource.IPM_Project_Role_Owner__c=true;
                }
                iPMresource.IPM_Unique_Resource__c=projectID+MAdd.listofuser.IPM_User__r.id;//added to support data migration
                lstnewResource.add(iPMresource);
            }
            
        }
        try
        {
            insert lstnewResource;
        }
        
        catch(Exception ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
               ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                 ADD_MEMBER_TO_WRAPPER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
          
        }
    }   
    
    /*************************************************************************************************************
    * @description:Get list of already assigned members in the current project
    */
    public void  getAssignedTeamMember()
    {
        assignedList=new set<string>();
        assignedMember=new list<IPM_Project_Resource__c>();
        assignedMember=[SELECT id,IPM_User__c,IPM_User__r.name,IPM_User__r.SmallPhotoUrl,IPM_Project_Role_Owner__c,
        IPM_Role_Type__c FROM IPM_Project_Resource__c WHERE IPM_Role_Type__c=:roleType and 
        IPM_Project__r.id=:projectID order by IPM_User__c ASC limit 50000]; 
        
        if(!assignedMember.isEmpty())
        {
            for(IPM_Project_Resource__c assignedmem:assignedMember)
            {
                assignedList.add(assignedmem.IPM_User__r.id);
                avoidDupUser.add(assignedmem.IPM_User__c);
            }
        }
        
    }
    /*************************************************************************************************************
    * @author:Cognizant
    * @date: 25/09/2014
    * @description:list out all users FROM user profile and add one boolean value with user profile record.
    *               this is used while adding the SELECTed users FROM page
    */
    public class wrapperclass
    {
        /*************************************************************************************************************
        * @description:flag whether check box in true or false
        */
        public Boolean checkboxuser{get;set;}
        /*************************************************************************************************************
        * @description:initialise the user profile object
        */
        public IPM_User_Profile__c listofuser{get;set;}
        /*************************************************************************************************************
        * @description:constructor,get user profile records.
        * @param:user profile object
        */
        public wrapperclass(IPM_User_Profile__c lstuser)
        {
            checkboxuser=false;
            listofuser=lstuser;
        }
    } 
    /*************************************************************************************************************
    * @description:Get Core members FROM user profiles(PL,DPL,TPL,Gatekeeper users)
    */
    public void getCoreMemberds()
    {
        string strCoreMem=IPM_ConstantUtils.BLANK;
        lstUserProfile=new list<IPM_User_Profile__c>();
        string uQuery=IPM_ConstantUtils.BLANK;

        if(IPM_ConstantUtils.TEAM_COREPL==coreMembers)
        {
            buttonLabel=IPM_ConstantUtils.TEAM_PROJECT_LEADER;
            strCoreMem=IPM_ConstantUtils.TEAM_PROJECT_LEADER;
        }
        else if(IPM_ConstantUtils.TEAM_COREDPL==coreMembers)
        {
            buttonLabel=IPM_ConstantUtils.TEAM_DEPUTY_PROJECT_LEADER;
            strCoreMem=IPM_ConstantUtils.TEAM_PROJECT_LEADER;
            
        }
        else if(IPM_ConstantUtils.TEAM_COREGATEK==coreMembers)
        {
            buttonLabel=IPM_ConstantUtils.TEAM_GATEKEEPER;
            strCoreMem=IPM_ConstantUtils.TEAM_GATEKEEPER;
        }
        else if(IPM_ConstantUtils.TEAM_CORETPL==coreMembers)
        {
            buttonLabel=IPM_ConstantUtils.TEAM_TECHNICAL_PROJECT_LEADER;
            strCoreMem=IPM_ConstantUtils.TEAM_RESEARCH_DEVELOPMENT;
            uQuery=BEGIN_QUERY;
            uQuery=uQuery+QUERY_FIELDS_STR;
            uQuery=uQuery+QUERY_WHERE_STR;
            uQuery=uQuery+QUERY_HOLDCATEGORY_STR + String.escapeSingleQuotes(category) + PERCENTAGE_SLASH ;
            uQuery=uQuery+' AND IPM_User_Role__c=\''+strCoreMem+'\') '+QUERY_LIMIT;
        }    
        if(IPM_ConstantUtils.TEAM_COREDPL==coreMembers || IPM_ConstantUtils.TEAM_COREGATEK==coreMembers)
        {
            uQuery=BEGIN_QUERY;
            uQuery=uQuery+QUERY_FIELDS_STR;
            uQuery=uQuery+QUERY_WHERE_STR;
            uQuery=uQuery+QUERY_HOLDCATEGORY_STR + String.escapeSingleQuotes(category) + PERCENTAGE_SLASH ; 
            uQuery=uQuery+' AND IPM_User_Function__c=\''+strCoreMem+'\' AND IPM_Company_Card__c=\''+CCardName+'\') '+QUERY_LIMIT;
        }
        else if(IPM_ConstantUtils.TEAM_COREPL ==coreMembers)
        {
            uQuery=IPM_ConstantUtils.BLANK;
            uQuery=BEGIN_QUERY;
            uQuery=uQuery+QUERY_FIELDS_STR;
            uQuery=uQuery+QUERY_WHERE_STR;
            uQuery=uQuery+' AND IPM_User_Function__c=\''+strCoreMem+'\' ) '+QUERY_LIMIT;
        }
        
        if(string.isNotBlank(uQuery))
        {
            try
            {
                lstUserProfile=database.query(uQuery);
                Map<id,id>uniqueUserMapId=new Map<id,id>();
                if(lstUserProfile != null && !lstUserProfile.isEmpty())
                { 
                    for(IPM_User_Profile__c u:lstUserProfile)
                    {
                        uniqueUserMapId.put(u.IPM_User__c,u.id);
                    }
                 
                }
                if(!uniqueUserMapId.isEmpty())
                {
                    lstUserProfile=[SELECT IPM_User__r.id,IPM_User_Role__c,IPM_User__r.name,
                    IPM_User__r.email,IPM_User__r.SmallPhotoUrl,
                    IPM_User__r.UserRole.Name
                    FROM IPM_user_profile__c WHERE id IN:uniqueUserMapId.values() Limit 50000];
                }
            }
            catch(QueryException ex)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));    
            }
        }
        
    }
    /*************************************************************************************************************
    * @description:Filter core members FROM user profiles(PL,DPL,TPL,Gatekeeper users)
    * This method is used to query the core team member name and role and email id in case of task and milestones team updation.
    * user selection is based on the company card of the project and fucntion.
    * Resource allocation window will enlist these user for further selection of team.
    * return none
    */
    public void filterCoreMember()
    {
        lstUserProfile=new list<IPM_User_Profile__c>();
        string strCoreMem=IPM_ConstantUtils.BLANK;
        string uQuery=IPM_ConstantUtils.BLANK;
        string querySearchCoreTeam = IPM_ConstantUtils.PERCENTAGE+searchCoreTeam+IPM_ConstantUtils.PERCENTAGE;//used in the query below
        uQuery=BEGIN_QUERY;
        uQuery=uQuery+QUERY_FIELDS_STR;
        uQuery=uQuery+QUERY_WHERE_STR;
        
        if(IPM_ConstantUtils.TEAM_COREPL==coreMembers || IPM_ConstantUtils.TEAM_COREDPL==coreMembers)
        {
            strCoreMem=IPM_ConstantUtils.TEAM_PROJECT_LEADER;
        }
        else if(IPM_ConstantUtils.TEAM_COREGATEK==coreMembers)
        {
            strCoreMem=IPM_ConstantUtils.TEAM_GATEKEEPER;
        }
        else if(IPM_ConstantUtils.TEAM_CORETPL==coreMembers)
        {
            strCoreMem=IPM_ConstantUtils.TEAM_RESEARCH_DEVELOPMENT;
            uQuery=uQuery+QUERY_HOLDCATEGORY_STR + String.escapeSingleQuotes(category) + '%\')' ;
            uQuery=uQuery+' AND IPM_User_Role__c=\''+strCoreMem+'\'';
            uQuery=uQuery+' AND (IPM_User__r.name LIKE :querySearchCoreTeam OR IPM_User__r.email LIKE :querySearchCoreTeam) '+QUERY_LIMIT ;
        } 
        
        if(IPM_ConstantUtils.TEAM_COREDPL==coreMembers || IPM_ConstantUtils.TEAM_COREGATEK==coreMembers)
        {
            uQuery=uQuery+QUERY_HOLDCATEGORY_STR + String.escapeSingleQuotes(category) + '%\')' ;
            uQuery=uQuery+' AND IPM_User_Function__c=\''+strCoreMem+'\' AND IPM_Company_Card__c=\''+CCardName+'\' ';
            uQuery=uQuery+' AND (IPM_User__r.name Like :querySearchCoreTeam OR IPM_User__r.email Like :querySearchCoreTeam) '+QUERY_LIMIT ;
        }
        else if(IPM_ConstantUtils.TEAM_COREPL==coreMembers)
        {
            uQuery=uQuery+' AND IPM_User_Function__c=\''+strCoreMem+'\' )';
            uQuery=uQuery+' AND (IPM_User__r.name Like :querySearchCoreTeam OR IPM_User__r.email Like :querySearchCoreTeam) '+QUERY_LIMIT ;
        }
        
        try
        {
            
            lstUserProfile=database.query(uQuery);
            Map<id,id>uniqueUserMapId=new Map<id,id>();
            if(lstUserProfile != null && !lstUserProfile.isEmpty())
            { 
                for(IPM_User_Profile__c u:lstUserProfile)
                {
                    uniqueUserMapId.put(u.IPM_User__c,u.id);
                }
             
            }
            if(!uniqueUserMapId.isEmpty())
            {
                lstUserProfile=[SELECT IPM_User__r.id,IPM_User_Role__c,IPM_User__r.name,
                IPM_User__r.email,IPM_User__r.SmallPhotoUrl,
                IPM_User__r.UserRole.Name
                FROM IPM_user_profile__c WHERE id IN:uniqueUserMapId.values() Limit 50000];
            }
            if(lstUserProfile.isEmpty())
            {
                isNoMatchfound=IPM_ConstantUtils.TEAM_TRUE ;
            }
            else
            {
                isNoMatchfound=IPM_ConstantUtils.BLANK;
            }
            
        }
        catch(QueryException ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
             ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                'filterCoreMember',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
       }
        
        
    } 
    /*************************************************************************************************************
    * @description:Update Core Members for current project(PL,DPL,TPL,Gatekeeper users)
    */
    public void updateCoreMember()
    {
        list<IPM_Project__c>iPMProjectList=new list<IPM_Project__c>();
        IPM_Project__c ipmproject=new IPM_Project__c(id=projectID);
        if(IPM_ConstantUtils.TEAM_COREPL==coreMembers)
        {
            List<IPM_User_Profile__c>checkValidUserCompanyCList=[SELECT IPM_Company_Card__c FROM IPM_User_Profile__c WHERE IPM_User__c=:selecetedCoreMember AND
                                                                     IPM_Company_Card__c =:CCardName LIMIT 1];
                    
            if(checkValidUserCompanyCList.isEmpty()){
                IPM_WithoutShareController.createUserProfile(CCardName,selecetedCoreMember,category);//create user profile for selected PL with company card
            }
            ipmproject.IPM_Project_Leader__c=selecetedCoreMember;
        }
        else if(IPM_ConstantUtils.TEAM_COREdPL==coreMembers)
        {
            ipmproject.Deputy_Project_Leader__c =selecetedCoreMember;
        }
        else if(IPM_ConstantUtils.TEAM_COREGATEK==coreMembers)
        {
            ipmproject.IPM_Project_Gatekeeper__c=selecetedCoreMember;
        }
        else if(IPM_ConstantUtils.TEAM_CORETPL==coreMembers)
        {
            ipmproject.IPM_Technical_Project_Leader__c=selecetedCoreMember;
        }
        iPMProjectList.add(ipmproject);
        try{
            if(!IPMProjectList.isEmpty()){
                update iPMProjectList;
            }
        }
        
        catch(Exception ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
             ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                UPDATE_CORE_MEMBER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
       }
    } 
    /*************************************************************************************************************
    * @description:Hold core member id from UI
    */
    public void holdCoreMember()
    {
        //holding core members
    }        
    
    /*******************************************************************************************************
    * @Description:create finance members when regional rollout having finance user
    * @Param:map of regional project id's and finance user id's    
    */
    
    public static void createFinanceMember(Map<Id,Id>newproAndUserMap)
    {
        list<IPM_Project_Resource__c>lstnewResource=new list<IPM_Project_Resource__c>();
        for(Id projid:newproAndUserMap.keySet())
        {
            IPM_Project_Resource__c iPMresource=new IPM_Project_Resource__c();
            iPMresource.IPM_Project__c= projid;
            iPMresource.IPM_User__c=newproAndUserMap.get(projid);
            iPMresource.IPM_Role_Type__c=IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE;
            iPMresource.IPM_Project_Role_Owner__c=true;
            iPMresource.IPM_Unique_Resource__c=projid+string.valueof(newproAndUserMap.get(projid));//added to support Data migration
            lstnewResource.add(IPMresource);
        }
        if(!lstnewResource.isEmpty())
        {
            try
            {
                insert lstnewResource;
            }
            
            catch(Exception ex)
            {
                If(!Trigger.isExecuting)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                }
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                CREATE_FINANCE_MEMBER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            }
        }
    }
    /*******************************************************************************************************
    * @Description:Delete finance members when local rollout having finance user
    * @Param:map of local project id's and finance user id's    
    */
    public static void deleteFinanceMember(Map<Id,Id>newproAndUserMap)
    {
        list<IPM_Project_Resource__c>lstnewResource=new list<IPM_Project_Resource__c>();
        lstnewResource=[SELECT Id FROM IPM_Project_Resource__c WHERE IPM_Role_Type__c=:IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE
        AND IPM_Project__c IN:newproAndUserMap.keySet() AND IPM_User__c =:newproAndUserMap.values()];
        
        if(!lstnewResource.isEmpty())
        {
            try
            {
                //To Check CRUD
                if (IPM_Project_Resource__c.sObjectType.getDescribe().isDeletable())
                {
                    delete lstnewResource;
                }    
             }
            
            catch(Exception ex)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                DELETE_FINANCE_MEMBER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            }
        }
    }
    
    /*************************************************************************************************************
    * @description:Hold the Leader member id from UI
    */
    public void holdLeader()
    {
        //holding leader members
    }
    
    /*************************************************************************************************************
    * @description:Assign Project Leader or Finance leader for current rollout
    */
    public void assignLeaderMember()
    {
        IPM_Project_Rollout__c inContextRollout = null;
        Id companyCardRecordTypeId = null;
        
        List<String> locationFilter = new List<String>();
        List<Id> filteredCompanyCardList = new List<Id>();
        
        // Get Project Specific information 
        IPM_Project__c ipmproject = [SELECT id,Deputy_Project_Leader__c,IPM_Project_Gatekeeper__c,IPM_Project_Leader__c,IPMProject_Span__c,
            IPM_Technical_Project_Leader__c,IPM_Company_Card__c,IPM_Category_Text__c FROM 
            IPM_Project__c WHERE id=:projectID LIMIT 1];
        
       
        String projectManagedCategory = ipmproject.IPM_Category_Text__c;
        // Get In context Rollout Information
        List<IPM_Project_Rollout__c> lstRegRollout = [SELECT Id, Name,RecordTypeId,Market_Cluster_Name__c,IPM_Regional_PL_Text__c, IPM_Finance_Member_Text__c,(SELECT Id,Country_Name__c FROM IPM_Countries_Local__r) FROM IPM_Project_Rollout__c WHERE ID =: rolloutId LIMIT 1];
      
        List<User> lstUser = [SELECT Id,Name FROM User WHERE Id =:selectedLeaderMember LIMIT 1];
        
        if(!lstRegRollout.isEmpty())
        {
            inContextRollout = lstRegRollout[0];
            if(inContextRollout.recordTypeId == REGIONAL_ROLLOUT_RECORDTYPE)
            {
                
                locationFilter.add(inContextRollout.Market_Cluster_Name__c);
            }
            else if(inContextRollout.recordTypeId == LOCAL_ROLLOUT_RECORDTYPE)
            {
                
                for(IPM_Country__c country : inContextRollout.IPM_Countries_Local__r)
                { 
                    if(!String.isBlank(country.Country_Name__c))
                    {
                        locationFilter.add(IPM_ConstantUtils.PERCENTAGE + country.Country_Name__c+IPM_ConstantUtils.PERCENTAGE); 
                    }
                } 
            }
        }
        
        String selectCompanyCard = ' SELECT Id, name, IPM_TxtGeographical_Scope__c, IPM_Managed_Category__c,IPM_Market_Cluster__c FROM IPM_Company_Card__c ';
        String whereClause = ' WHERE IPM_Managed_Category__c INCLUDES(:projectManagedCategory) ';
        
        
            if(inContextRollout.recordTypeId == REGIONAL_ROLLOUT_RECORDTYPE)
            {
                whereClause += ' AND IPM_TxtGeographical_Scope__c IN :locationFilter ';
                
            }
            else
            {
                whereClause += ' AND IPM_TxtGeographical_Scope__c LIKE :locationFilter ';
                
            }
        
        String limitString = ' LIMIT 50000';
        String finalQueryString = selectCompanyCard + whereClause + limitString;
        
        List<IPM_Company_Card__c> lstCompanyCards = database.query(finalQueryString);
        Set<id>companyCardIdSet=new Set<id>();
        if(!lstCompanyCards.isEmpty())
        {
            for(IPM_Company_Card__c ccid:lstCompanyCards){
                companyCardIdSet.add(ccid.id);
            }
        }
        if(!lstUser.isEmpty())
        { 
            if(IPM_ConstantUtils.USER_FUNCTON_PL.equalsIgnoreCase(ButtonLabel) || IPM_ConstantUtils.USER_FUNCTON_CL.equalsIgnoreCase(ButtonLabel))
            {   
                                                                                                           
                inContextRollout.IPM_Regional_PL_Text__c = lstUser[0].Name;
                inContextRollout.IPM_Regional_PL__c = lstUser[0].Id;
                
                if(!lstCompanyCards.isEmpty())
                {
                    List<IPM_User_Profile__c>checkValidUserCompanyCList=[SELECT IPM_Company_Card__c FROM IPM_User_Profile__c WHERE IPM_User__c=:selectedLeaderMember AND
                                                                     IPM_Company_Card__c IN:companyCardIdSet LIMIT 1];
                    
                    if(!checkValidUserCompanyCList.isEmpty()){
                        inContextRollout.IPM_Company_Card__c = checkValidUserCompanyCList[0].IPM_Company_Card__c; // assigning regional company card
                    }
                    else{// get all company card associated with category,market cluster/countries
                        inContextRollout.IPM_Company_Card__c=lstCompanyCards[0].id;//assign company card to project leader
                        IPM_WithoutShareController.createUserProfile(lstCompanyCards[0].id,selectedLeaderMember,projectManagedCategory);//create user profile for selected PL with company card
                    }
                    
                }
                
             if(inContextRollout.IPM_Company_Card__c!=null){
                id companyCardId=inContextRollout.IPM_Company_Card__c;
                list<IPM_User_Profile__c>lstGatekeeper=[SELECT IPM_User__c FROM IPM_User_Profile__c WHERE IPM_Company_Card__c=:companyCardId 
                                                        AND IPM_User_Function__c=:IPM_ConstantUtils.TEAM_GATEKEEPER LIMIT 1];  
                if(lstGatekeeper!=null && !lstGatekeeper.isEmpty()){
                    inContextRollout.IPM_Rollout_Gatekeeper__c=lstGatekeeper[0].IPM_User__c;    
                }else{
                inContextRollout.IPM_Rollout_Gatekeeper__c=lstUser[0].Id;   
                }  
             }else{
                inContextRollout.IPM_Rollout_Gatekeeper__c=lstUser[0].Id;   
             }  
            }
            else if(IPM_ConstantUtils.USER_FUNCTON_FL.equalsIgnoreCase(ButtonLabel))
            {                                    
                inContextRollout.IPM_Finance_Member_Text__c = lstUser[0].Name;     
                inContextRollout.Finance_Member__c = lstUser[0].Id;       
            } 
        }          
        try
        {
            update inContextRollout;   
        }
        
        catch(Exception ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                ASSIGN_LEADER_MEMBER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    
    /*************************************************************************************************************
    * @description:Get all members FROM same category for functional role.
    */
    public void getSameCategoryRolloutProfiles()
    {
        String project_Leader=IPM_ConstantUtils.TEAM_PROJECT_LEADER;
        String function_Leader = IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE;
        map<id,id>uniqueUsers=new map<id,id>();
        
        list<IPM_User_Profile__c>lstuser=new list<IPM_User_Profile__c>();
        string uQuery=IPM_ConstantUtils.BLANK; 

        string holdCategory = '\'%' + String.escapeSingleQuotes(category) + PERCENTAGE_SLASH;
        if(isLeaderTypePL)
        {  
           if(IPM_ConstantUtils.TEAM_MYCATEGORY.equalsIgnoreCase(SearchLeaderbyCat))
           {
                UQuery=IPM_ConstantUtils.BLANK;
                UQuery = BEGIN_QUERY_TEAM;
                UQuery = UQuery+MID_QUERY_TEAM;
                UQuery = UQuery+QUERY_STRING_PROFILE;
                UQuery = UQuery+' IPM_HoldCategory__c LIKE '+holdCategory;
                UQuery= UQuery + '  ) AND IPM_User_Function__c = \''+project_Leader+'\''+QUERY_LIMIT;
                
            }
            else if(IPM_ConstantUtils.TEAM_ALLCATEGORY.equalsIgnoreCase(SearchLeaderbyCat))
            {
                UQuery=IPM_ConstantUtils.BLANK;
                UQuery =BEGIN_QUERY_TEAM;
                UQuery = UQuery+MID_QUERY_TEAM;
                UQuery = UQuery+'IPM_User__r.UserRole.Name FROM IPM_user_profile__c WHERE  (IPM_User__r.IsActive=True';
                UQuery = UQuery+' and IPM_HoldCategory__c!=null) AND IPM_User_Function__c = \''+project_Leader+'\'';
                UQuery = UQuery+QUERY_LIMIT;
            }
            else // in case of default selection
            {
                UQuery=IPM_ConstantUtils.BLANK;
                UQuery = BEGIN_QUERY_TEAM;
                UQuery = UQuery+MID_QUERY_TEAM;
                UQuery = UQuery+QUERY_STRING_PROFILE;
                UQuery = UQuery+' IPM_HoldCategory__c LIKE '+holdCategory;
                UQuery= UQuery + '  ) AND IPM_User_Function__c = \''+project_Leader+'\''+QUERY_LIMIT;
            }
        }
        
        else if(isLeaderTypeFL)
        {   
            if(IPM_ConstantUtils.TEAM_MYCATEGORY.equalsIgnoreCase(SearchLeaderbyCat))
           {
                UQuery=IPM_ConstantUtils.BLANK;
                UQuery = BEGIN_QUERY_TEAM;
                UQuery = UQuery+MID_QUERY_TEAM;
                UQuery = UQuery+QUERY_STRING_PROFILE;
                UQuery = UQuery+' IPM_HoldCategory__c LIKE '+holdCategory;
                UQuery= UQuery + '  ) AND IPM_User_Role__c = \''+function_Leader+'\''+QUERY_LIMIT;
                
            }
            else if(IPM_ConstantUtils.TEAM_ALLCATEGORY.equalsIgnoreCase(SearchLeaderbyCat))
            {
                UQuery=IPM_ConstantUtils.BLANK;
                UQuery =BEGIN_QUERY_TEAM;
                UQuery = UQuery+MID_QUERY_TEAM;
                UQuery = UQuery+'IPM_User__r.UserRole.Name FROM IPM_user_profile__c WHERE  (IPM_User__r.IsActive=True';
                UQuery = UQuery+' and IPM_HoldCategory__c!=null) AND IPM_User_Role__c =\''+function_Leader+'\'';
                UQuery = UQuery+QUERY_LIMIT;
            }
            else // in case of default selection
            {
                UQuery=IPM_ConstantUtils.BLANK;
                UQuery = BEGIN_QUERY_TEAM;
                UQuery = UQuery+MID_QUERY_TEAM;
                UQuery = UQuery+QUERY_STRING_PROFILE;
                UQuery = UQuery+' IPM_HoldCategory__c LIKE '+holdCategory;
                UQuery= UQuery + '  ) AND IPM_User_Role__c =\''+function_Leader+'\''+QUERY_LIMIT;
            }
        }
        
        Map<Id, Id> uniqueUserMapId = new Map<Id, Id>();
        try
        {
            lstuser=database.query(UQuery);
     
        }
        
        catch(Exception ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                SAME_CATEGORY_ROLLOUT_PROFILES,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
       
        if(lstuser != null && !lstuser.isEmpty())
        { 
            IsNoMatchfound=IPM_ConstantUtils.BLANK;
            for(IPM_User_Profile__c u:lstuser)
            {
                uniqueUserMapId.put(u.IPM_User__r.Id,u.id);
                
            }
         
        }
        if(!uniqueUserMapId.isEmpty())
        {
            leaderUsers=[SELECT IPM_User__r.id,IPM_User_Role__c,IPM_User__r.name,
            IPM_User__r.email,IPM_User__r.SmallPhotoUrl,
            IPM_User__r.UserRole.Name
            FROM IPM_user_profile__c WHERE id IN:uniqueUserMapId.values() Limit 50000];
        }
    
      
    }
    
    /*************************************************************************************************************
    * @description:Filter leader members FROM user profiles
    */
    public void filterLeaderMember()
    {
        lstUserProfile=new list<IPM_User_Profile__c>();
        string strCoreMem=IPM_ConstantUtils.BLANK; // used in the query
        string UQuery=IPM_ConstantUtils.BLANK;
        string querySearchLeader = String.escapeSingleQuotes(SearchLeader) +PERCENTAGE_SLASH;//used in the query below
        UQuery=BEGIN_QUERY;
        UQuery=UQuery+QUERY_FIELDS_STR;
        UQuery=UQuery+QUERY_WHERE_STR;
        UQuery=UQuery+' and (IPM_User__r.name Like \''+querySearchLeader+' or IPM_User__r.email like \''+querySearchLeader+')) '+QUERY_LIMIT;
        
        try{
            if(UQuery!=IPM_ConstantUtils.BLANK)
            {
                lstUserProfile=database.query(UQuery);
                if(lstUserProfile.isEmpty())
                {
                    IsNoMatchfound=IPM_ConstantUtils.TEAM_TRUE ;
                    leaderUsers.clear();
                 }
                else
                {
                    IsNoMatchfound=IPM_ConstantUtils.BLANK;
                    leaderUsers = lstUserProfile;   
                                
                    Map<Id, Id> uniqueUserMapId = new Map<Id, Id>();
                    if(leaderUsers != null && !leaderUsers.isEmpty())
                    { 
                        for(IPM_User_Profile__c u:leaderUsers)
                        {
                            uniqueUserMapId.put(u.IPM_User__r.Id,u.id); 
                        }
                     
                    }
                    
                    if(!uniqueUserMapId.isEmpty())
                    {
                        leaderUsers=[SELECT IPM_User__r.id,IPM_User_Role__c,IPM_User__r.name,
                        IPM_User__r.email,IPM_User__r.SmallPhotoUrl,
                        IPM_User__r.UserRole.Name
                        FROM IPM_user_profile__c WHERE id IN:uniqueUserMapId.values() Limit 50000];
                    }
                }
            }
        }
        
        catch(Exception ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                FILTER_LEADER_MEMBER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        
        
        
    }
    
     public Integer CountProjectMembers(string role)
     {
        Integer countUserRole=[SELECT count() 
        FROM IPM_Project_Resource__c WHERE IPM_Project__c=:projectID AND IPM_Role_Type__c=:role];
        return  countUserRole;
    }
}