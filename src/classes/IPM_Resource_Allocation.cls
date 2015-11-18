/*************************************************************************************************************
* @author:Cognizant
* @date: 25/09/2014
* @description:add new team members in current project.
*    and assign project leader,deputy project leader and gatekeeper based on company card of current project.
*    assign technical project leader.
Assign PL or FL for rollouts.
* @reference:IPM_Resource_Allocation_PartRevamp page
*/
public with sharing class IPM_Resource_Allocation {   
    
    //String Literals replacement
    private static final String QUERY_ROLE_STR = 'IPM_User_Role__c=\'';
    private static final String QUERY_FIELDS_STR = 'ipm_user__r.smallphotourl,ipm_user__r.ipm_brand_name__c,ipm_user__r.ipm_role__c,';
    private static final String QUERY_WHERE_STR = 'IPM_User__r.UserRole.Name FROM IPM_user_profile__c WHERE  (IPM_User__r.IsActive=True ';
    private static final String QUERY_HOLDCATEGORY_STR = ' and IPM_HoldCategory__c like \'%';
    public static final String IPM_RESOURCEALLOCATION_STR = IPM_Resource_Allocation.class.getName();
    private static final string ADD_MEMBER_TO_WRAPPER = 'AddMemberToWrapper';
    private static final string UPDATE_CORE_MEMBER = 'UpdateCoreMember';
    private static final string CREATE_FINANCE_MEMBER ='createfinanceMember';
    private static final string DELETE_FINANCE_MEMBER ='deletefinanceMember';
    private static final string FILTER_LEADER_MEMBER ='FilterLeaderMember';
    private static final string SAME_CATEGORY_ROLLOUT_PROFILES ='getSameCategoryRolloutProfiles';
    private static final string ASSIGN_LEADER_MEMBER ='assignLeaderMember'; // used in exception message
    private static final string BEGIN_QUERY ='SELECT IPM_User__c,IPM_User__r.Function__c,IPM_User_Role__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,';
    private static final string BEGIN_QUERY_TEAM ='SELECT IPM_User__r.id,IPM_User__r.Function__c,IPM_User_Role__c,IPM_User__r.name,IPM_User__r.email,';
    private static final string MID_QUERY_TEAM ='IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.IPM_Role__c,';
    private static final string PERCENTAGE_SLASH='%\'';
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
    //@description:List of user profiles to be listed for PL selection
    public List<IPM_User_Profile__c> plUserProfiles{get;set;}
    //@description:List of user profiles to be listed for FL selection
    public List<IPM_User_Profile__c> flUserProfiles{get;set;}
    //@description:hold SELECTed leader member value FROM page
    public string SelectedLeaderMember{get;set;}
    //@description:hold SELECTed leader member value FROM page
    public string rolloutId{get;set;}
    //@description:hold SELECTed span of rollout leader member value FROM page
    public string rolloutSpan{get;set;}
    //@description: leader user profiles filtered from IPM_RolloutPlansTableController 
    public list<IPM_User_Profile__c> leaderUsers{get;set;}
   
    // map and list from table controller
    public List<IPM_User_Profile__c> lstIPMUserProfiles;
    public Map<String,Id> plNameMap {get; set;} //Map of Names and Ids of Project Leaders
    public Map<String,Id> flNameMap {get; set;} //Map of Names and Ids of Finance Members
    public Map<String,IPM_User_Profile__c> plUserNameProfileMap {get; set;} //Map of Names and User Profiles of Project Leaders, used in Resource Allocation
    public Map<String,IPM_User_Profile__c> flUserNameProfileMap {get; set;} //Map of Names and User Profiles of Finance Members, used in Resource Allocation 
    
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
        
        projectID=Apexpages.currentpage().getParameters().get(String.escapeSingleQuotes(IPM_ConstantUtils.TEAM_PROJECTID));
        IPM_Project__c ipmproject=[SELECT id,Deputy_Project_Leader__c,IPM_Project_Gatekeeper__c,IPM_Project_Leader__c,
            IPM_Technical_Project_Leader__c,IPM_Company_Card__c,IPM_Category_Text__c FROM 
            IPM_Project__c WHERE id=:projectID limit 1];
        category=Ipmproject.IPM_Category_Text__c;

        // get user profile map
        
        lstIPMUserProfiles = [SELECT IPM_User__c, IPM_User__r.Name, IPM_User__r.UserRole.Name, ipm_user__r.smallphotourl, ipm_user__r.Email, IPM_User_Function__c,IPM_User_Role__c, IPM_Region__c, IPM_Company_Card__c 
                                                            FROM IPM_User_Profile__c 
                                                            WHERE  IPM_User__r.IsActive = true AND IPM_User_Role__c=: IPM_ConstantUtils.PROJECT_LEADER LIMIT 50000];
                                                            
        plUserNameProfileMap = new Map<String,IPM_User_Profile__c>();
        flUserNameProfileMap = new Map<String,IPM_User_Profile__c>();    
                                                            
        plNameMap = new Map<String,Id>();
        flNameMap = new Map<String,Id>();
        
        string invokedFrom = Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.INVOKED_FROM); 
        if(invokedFrom != Null && invokedFrom.equals(IPM_ConstantUtils.INVOKED_FROM_ROLLOUTS))
        {
            isInvokedFromRollouts = true;   
        }
        
        for(IPM_User_Profile__c userProfile : lstIPMUserProfiles)
        {
                //Add Unique Names
                if(!plNameMap.containsKey(userProfile.IPM_User__r.Name))
                {
                    plNameMap.put(userProfile.IPM_User__r.Name, userProfile.IPM_User__c);
                    plUserNameProfileMap.put(userProfile.IPM_User__r.Name, userProfile);
                }

                //Add Unique Names
                if(!flNameMap.containsKey(userProfile.IPM_User__r.Name))
                {
                    flNameMap.put(userProfile.IPM_User__r.Name, userProfile.IPM_User__c);
                    flUserNameProfileMap.put(userProfile.IPM_User__r.Name, userProfile);
                }
         }
        
        
        
        
        if(isInvokedFromRollouts!=null && isInvokedFromRollouts){
            leaderUsers = new list<IPM_User_Profile__c>();
            //RolloutCntlr = new IPM_RolloutPlansTableController();
            leaderType = Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.ROLLOUT_LEADER_TYPE);           
            rolloutId = Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.ROLLOUTID);            
            rolloutSpan = Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.ROLLOUT_SPAN);
            
            if(leaderType != Null && leaderType==IPM_ConstantUtils.ROLLOUT_PL_TYPE){
                isLeaderTypePL = true;  
                plUserProfiles = plUserNameProfileMap.values();
                leaderUsers.addAll(plUserProfiles);
                if(leaderType==IPM_ConstantUtils.ROLLOUT_PL_TYPE && rolloutSpan == IPM_ConstantUtils.ROLLOUT_SPAN_REGIONAL){
                    ButtonLabel=IPM_ConstantUtils.USER_FUNCTON_PL;
                }else if(leaderType==IPM_ConstantUtils.ROLLOUT_PL_TYPE && rolloutSpan == IPM_ConstantUtils.ROLLOUT_SPAN_LOCAL){
                    ButtonLabel=IPM_ConstantUtils.USER_FUNCTON_CL;
                }
            }else if(leaderType==IPM_ConstantUtils.ROLLOUT_FL_TYPE){
                isLeaderTypeFL = true;  
                flUserProfiles = flUserNameProfileMap.values();             
                leaderUsers.addAll(flUserProfiles);
                ButtonLabel=IPM_ConstantUtils.USER_FUNCTON_FL;
            }        
        }else{
            if(String.IsNotBlank(String.valueOf(ipmproject.Deputy_Project_Leader__c))){
                avoidDupUser.add(ipmproject.Deputy_Project_Leader__c);
            }
            if(String.IsNotBlank(String.valueOf(ipmproject.IPM_Project_Gatekeeper__c))){
                avoidDupUser.add(ipmproject.IPM_Project_Gatekeeper__c);
            }
            if(String.IsNotBlank(String.valueOf(ipmproject.IPM_Project_Leader__c))){
                avoidDupUser.add(Ipmproject.IPM_Project_Leader__c);
            }
            if(String.IsNotBlank(String.valueOf(ipmproject.IPM_Technical_Project_Leader__c))){
                avoidDupUser.add(Ipmproject.IPM_Technical_Project_Leader__c);
            }
            
            
            
            PL=Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.TEAM_PL);
            
            DPL=Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.TEAM_DPL); 
            
            
            if(IPM_ConstantUtils.TEAM_TRUE==PL||IPM_ConstantUtils.TEAM_TRUE==DPL){
                isPLEdit=true;
            }
            projectID=String.escapeSingleQuotes(projectID);
            
            
            roleType=Apexpages.currentpage().getParameters().get(String.escapeSingleQuotes(IPM_ConstantUtils.TEAM_ROLETYPE));
            
            RoletypeRND=Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.TEAM_ROLETYPE);
            
            //category=Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.TEAM_CATEGORY);
            
            coreMembers=Apexpages.currentpage().getParameters().get(IPM_ConstantUtils.TEAM_COREMEMBER);
            
            CCardName=Ipmproject.IPM_Company_Card__c;
            if(IPM_ConstantUtils.TEAM_RND==RoletypeRND){
                roleType=IPM_ConstantUtils.TEAM_RESEARCH_DEVELOPMENT;
            }
            changeRoleType = roleType;
            
            if(IPM_ConstantUtils.TEAM_GUEST==roleType){
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
    public void getSameCategory(){
        list<IPM_Project_Resource__c>lstoldres=[SELECT IPM_User__c FROM IPM_Project_Resource__c WHERE IPM_Project__c=:projectID limit 50000];
        map<id,id>uniqueUsers=new map<id,id>();
        for(IPM_Project_Resource__c res:lstoldres){
            oldresourceid.add(res.IPM_User__c);
        }

        teamMembers=new list<wrapperclass>();
        list<IPM_User_Profile__c>lstuser=new list<IPM_User_Profile__c>();
        string UQuery=IPM_ConstantUtils.BLANK;      
        
        if(searchTeambyCat==IPM_ConstantUtils.TEAM_MYCATEGORY){
            UQuery=IPM_ConstantUtils.BLANK;
            UQuery = BEGIN_QUERY_TEAM;
            UQuery = UQuery+MID_QUERY_TEAM;
            UQuery = UQuery+'IPM_User__r.UserRole.Name FROM IPM_user_profile__c WHERE  (IPM_User__r.IsActive=True and ';
            UQuery = UQuery+' IPM_User_Category__c INCLUDES (:category)';
            
           
            if(String.IsNotBlank(String.valueOf(changeRoleType)))
            {
                UQuery=UQuery+' and '+QUERY_ROLE_STR+String.escapeSingleQuotes(changeRoleType)+'\'';
            }
            UQuery= UQuery + '  ) and IPM_User__r.id not in :oldresourceid limit 50000';
            
            
            
        }else if(IPM_ConstantUtils.TEAM_ALLCATEGORY==searchTeambyCat){
            if(IPM_ConstantUtils.TEAM_GUEST==roleType){
                UQuery=IPM_ConstantUtils.BLANK;
                UQuery =BEGIN_QUERY_TEAM;
                UQuery = UQuery+MID_QUERY_TEAM;
                UQuery = UQuery+'IPM_User__r.UserRole.Name FROM IPM_user_profile__c WHERE  (IPM_User__r.IsActive=True';
                UQuery = UQuery+' and IPM_HoldCategory__c!=null) ';
                UQuery = UQuery+'and IPM_User__r.id not in :oldresourceid limit 50000';
                
            }else{
                UQuery =IPM_ConstantUtils.BLANK;
                UQuery = BEGIN_QUERY_TEAM;
                UQuery = UQuery+MID_QUERY_TEAM;
                UQuery = UQuery+'IPM_User__r.UserRole.Name FROM IPM_user_profile__c WHERE  (IPM_User__r.IsActive=True and ';
                UQuery = UQuery+' IPM_HoldCategory__c !=null ';
                if(String.IsNotBlank(String.valueOf(changeRoleType)))
                {
                    UQuery = UQuery+' and '+QUERY_ROLE_STR+String.escapeSingleQuotes(changeRoleType)+'\' ';
                }
                UQuery = UQuery+' ) and IPM_User__r.id not in :oldresourceid limit 50000';
            } 
        }
        try{
            
            lstuser=database.query(UQuery);
            
        }
        catch(QueryException ex){
            
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));
               }


        for(IPM_User_Profile__c u:lstuser){
            if((avoidDupUser.contains(u.IPM_User__r.id) && u.IPM_User_Role__c=='R&D') || !avoidDupUser.contains(u.IPM_User__r.id) ){
                uniqueUsers.put(u.IPM_User__c,u.id);
            }
        }
        
        lstuser=[SELECT IPM_User__r.id,IPM_User__r.Function__c,IPM_User_Role__c,IPM_User__r.name,
        IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,
        IPM_User__r.IPM_Brand_Name__c,IPM_User__r.IPM_Role__c, IPM_User__r.UserRole.Name 
        FROM IPM_user_profile__c WHERE id IN:uniqueUsers.values()];
        for(IPM_User_Profile__c u:lstuser){
            teamMembers.add(new wrapperclass(u));
        }
        
    }
    /*************************************************************************************************************
    * @description:Search for same category members
    */
    public void filterTeamMember(){
        map<id,id>uniqueUsers=new map<id,id>();
        teamMembers=new list<wrapperclass>();
        list<IPM_User_Profile__c>lstuser=new list<IPM_User_Profile__c>();
        string uQuery=IPM_ConstantUtils.BLANK;
       
        string querySearchTeamMem=IPM_ConstantUtils.PERCENTAGE+searchTeamMem +IPM_ConstantUtils.PERCENTAGE;//used in the query below
        UQuery='SELECT IPM_User__r.id,IPM_User__r.Function__c,IPM_User_Role__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,';
        uQuery=uQuery+QUERY_FIELDS_STR;
        uQuery=uQuery+QUERY_WHERE_STR;
        if(searchTeambyCat==IPM_ConstantUtils.TEAM_MYCATEGORY){
            uQuery=uQuery+QUERY_HOLDCATEGORY_STR + String.escapeSingleQuotes(category) + '%\' and ';
            uQuery=uQuery+QUERY_ROLE_STR+String.escapeSingleQuotes(changeRoleType)+'\')and(IPM_User__r.name Like :querySearchTeamMem  or ';
            uQuery=uQuery+'IPM_User__r.email Like :querySearchTeamMem or  IPM_User_Role__c Like :querySearchTeamMem)';
            uQuery=uQuery+'and IPM_User__r.id !=:oldresourceid limit 50000';
            
        }
        else if(searchTeambyCat==IPM_ConstantUtils.TEAM_ALLCATEGORY ){
            if(roleType==IPM_ConstantUtils.TEAM_GUEST){
                uQuery=uQuery+' and IPM_HoldCategory__c !=null)and';
                uQuery=uQuery+'(IPM_User__r.name Like :querySearchTeamMem  or IPM_User__r.email Like :querySearchTeamMem or ';
                uQuery=uQuery+'IPM_User_Role__c Like :querySearchTeamMem) and IPM_User__r.id !=:oldresourceid limit 50000';
                
            }
            else{
                uQuery=uQuery+' and IPM_HoldCategory__c !=null and ';
                uQuery=uQuery+QUERY_ROLE_STR+changeRoleType+'\')and(IPM_User__r.name Like :querySearchTeamMem  or ';
                uQuery=uQuery+'IPM_User__r.email Like :querySearchTeamMem or  IPM_User_Role__c Like :querySearchTeamMem)';
                uQuery=uQuery+'and IPM_User__r.id !=:oldresourceid limit 50000';
                
            }
        }
        try{
            lstuser=database.query(uQuery);
        }
        catch(QueryException ex){
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
            'filterTeamMember',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null); 
        }
        if(lstuser.isEmpty()){
            isNoMatchfound=IPM_ConstantUtils.TEAM_TRUE;
        }
        else{
            isNoMatchfound=IPM_ConstantUtils.BLANK;
        }
        for(IPM_User_Profile__c u:lstuser){
            if((avoidDupUser.contains(u.IPM_User__r.id) && u.IPM_User_Role__c=='R&D') || !avoidDupUser.contains(u.IPM_User__r.id) ){
                uniqueUsers.put(u.IPM_User__c,u.id);
            }
        }
        lstuser=[SELECT IPM_User__r.id,IPM_User__r.Function__c,IPM_User_Role__c,IPM_User__r.name,IPM_User__r.email,
        IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.IPM_Role__c, 
        IPM_User__r.UserRole.Name FROM IPM_user_profile__c WHERE id IN:uniqueUsers.values() limit 50000];
        for(IPM_User_Profile__c u:lstuser){
            teamMembers.add(new wrapperclass(u));
        }
    }
    /*************************************************************************************************************
    * @description:Add members FROM same category which are SELECTed FROM page
    */
    public void addMemberToWrapper(){
        list<IPM_Project_Resource__c>lstnewResource=new list<IPM_Project_Resource__c>();
        
        for(wrapperclass MAdd:teamMembers){
            if(MAdd.checkboxuser != null && MAdd.checkboxuser){
                
                IPM_Project_Resource__c iPMresource=new IPM_Project_Resource__c();
                iPMresource=new IPM_Project_Resource__c();
                iPMresource.IPM_Project__c= projectID;
                iPMresource.IPM_User__c=MAdd.listofuser.IPM_User__r.id;
                iPMresource.IPM_Role_Type__c=roleType;
                
                if(CountProjectMembers(roleType)>0)
                iPMresource.IPM_Project_Role_Owner__c=false;
                else
                iPMresource.IPM_Project_Role_Owner__c=true;
                
                iPMresource.IPM_Unique_Resource__c=projectID+MAdd.listofuser.IPM_User__r.id;//added to support data migration
                lstnewResource.add(iPMresource);
            }
            
        }
        try{
            insert lstnewResource;
        }
        catch(DmlException ex){
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
             ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                 ADD_MEMBER_TO_WRAPPER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            
        }
        catch(Exception ex){
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
               ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                 ADD_MEMBER_TO_WRAPPER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
          
        }
    }   
    
    /*************************************************************************************************************
    * @description:Get list of already assigned members in the current project
    */
    public void  getAssignedTeamMember(){
        assignedList=new set<string>();
        assignedMember=new list<IPM_Project_Resource__c>();
        assignedMember=[SELECT id,IPM_User__c,IPM_User__r.name,IPM_User__r.SmallPhotoUrl,IPM_Project_Role_Owner__c,
        IPM_Role_Type__c FROM IPM_Project_Resource__c WHERE IPM_Role_Type__c=:roleType and 
        IPM_Project__r.id=:projectID order by IPM_User__c ASC limit 50000]; 
        
        if(!assignedMember.isEmpty()){
            for(IPM_Project_Resource__c assignedmem:assignedMember){
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
    public class wrapperclass{
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
        public wrapperclass(IPM_User_Profile__c lstuser){
            checkboxuser=false;
            listofuser=lstuser;
        }
    } 
    /*************************************************************************************************************
    * @description:Get Core members FROM user profiles(PL,DPL,TPL,Gatekeeper users)
    */
    public void getCoreMemberds(){
        string strCoreMem=IPM_ConstantUtils.BLANK;
        lstUserProfile=new list<IPM_User_Profile__c>();
        string uQuery=IPM_ConstantUtils.BLANK;

        if(IPM_ConstantUtils.TEAM_COREPL==coreMembers){
            buttonLabel=IPM_ConstantUtils.TEAM_PROJECT_LEADER;
            strCoreMem=IPM_ConstantUtils.TEAM_PROJECT_LEADER;
        }
        else if(IPM_ConstantUtils.TEAM_COREDPL==coreMembers){
            buttonLabel=IPM_ConstantUtils.TEAM_DEPUTY_PROJECT_LEADER;
            strCoreMem=IPM_ConstantUtils.TEAM_PROJECT_LEADER;
            
        }
        else if(IPM_ConstantUtils.TEAM_COREGATEK==coreMembers){
            buttonLabel=IPM_ConstantUtils.TEAM_GATEKEEPER;
            strCoreMem=IPM_ConstantUtils.TEAM_GATEKEEPER;
        }
        else if(IPM_ConstantUtils.TEAM_CORETPL==coreMembers){
            buttonLabel=IPM_ConstantUtils.TEAM_TECHNICAL_PROJECT_LEADER;
            strCoreMem=IPM_ConstantUtils.TEAM_RESEARCH_DEVELOPMENT;
            uQuery=BEGIN_QUERY;
            uQuery=uQuery+QUERY_FIELDS_STR;
            uQuery=uQuery+QUERY_WHERE_STR;
            uQuery=uQuery+QUERY_HOLDCATEGORY_STR + String.escapeSingleQuotes(category) + PERCENTAGE_SLASH ;
            uQuery=uQuery+' and IPM_User_Role__c=\''+strCoreMem+'\') limit 50000';
        }    
        if(IPM_ConstantUtils.TEAM_COREPL ==coreMembers || IPM_ConstantUtils.TEAM_COREDPL==coreMembers || IPM_ConstantUtils.TEAM_COREGATEK==coreMembers){
            uQuery=BEGIN_QUERY;
            uQuery=uQuery+QUERY_FIELDS_STR;
            uQuery=uQuery+QUERY_WHERE_STR;
            uQuery=uQuery+QUERY_HOLDCATEGORY_STR + String.escapeSingleQuotes(category) + PERCENTAGE_SLASH ; 
            uQuery=uQuery+' and IPM_User_Function__c=\''+strCoreMem+'\' and IPM_Company_Card__c=\''+CCardName+'\') limit 50000';
        }
        
        if(string.isNotBlank(uQuery)){
            try{
                lstUserProfile=database.query(uQuery);
            }
            catch(QueryException ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));    
            }
        }
        
    }
    /*************************************************************************************************************
    * @description:Filter core members FROM user profiles(PL,DPL,TPL,Gatekeeper users)
    */
    public void filterCoreMember(){
        lstUserProfile=new list<IPM_User_Profile__c>();
        string strCoreMem=IPM_ConstantUtils.BLANK;
        string uQuery=IPM_ConstantUtils.BLANK;
        string querySearchCoreTeam = IPM_ConstantUtils.PERCENTAGE+searchCoreTeam+IPM_ConstantUtils.PERCENTAGE;//used in the query below
        uQuery=BEGIN_QUERY;
        uQuery=uQuery+QUERY_FIELDS_STR;
        uQuery=uQuery+QUERY_WHERE_STR;
        uQuery=uQuery+QUERY_HOLDCATEGORY_STR + String.escapeSingleQuotes(category) + '%\')' ;
        if(IPM_ConstantUtils.TEAM_COREPL==coreMembers || IPM_ConstantUtils.TEAM_COREDPL==coreMembers){
            strCoreMem=IPM_ConstantUtils.TEAM_PROJECT_LEADER;
        }
        else if(IPM_ConstantUtils.TEAM_COREGATEK==coreMembers){
            strCoreMem=IPM_ConstantUtils.TEAM_GATEKEEPER;
        }
        else if(IPM_ConstantUtils.TEAM_CORETPL==coreMembers){
            strCoreMem=IPM_ConstantUtils.TEAM_RESEARCH_DEVELOPMENT;
            uQuery=uQuery+' and IPM_User_Role__c=\''+strCoreMem+'\'';
            uQuery=uQuery+' and (IPM_User__r.name Like :querySearchCoreTeam or IPM_User__r.email Like :querySearchCoreTeam) limit 50000' ;
        } 
        
        if(IPM_ConstantUtils.TEAM_COREPL==coreMembers || IPM_ConstantUtils.TEAM_COREDPL==coreMembers || IPM_ConstantUtils.TEAM_COREGATEK==coreMembers){
            uQuery=uQuery+' and IPM_User_Function__c=\''+strCoreMem+'\' and IPM_Company_Card__c=\''+CCardName+'\' ';
            uQuery=uQuery+' and (IPM_User__r.name Like :querySearchCoreTeam or IPM_User__r.email Like :querySearchCoreTeam) limit 50000' ;
        }
        
        try{
            lstUserProfile=database.query(uQuery);
        }
        catch(QueryException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
             ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                'filterCoreMember',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
          
        }
        
        if(lstUserProfile.isEmpty()){
            isNoMatchfound=IPM_ConstantUtils.TEAM_TRUE ;
        }else{
            isNoMatchfound=IPM_ConstantUtils.BLANK;
        }
    } 
    /*************************************************************************************************************
    * @description:Update Core Members for current project(PL,DPL,TPL,Gatekeeper users)
    */
    public void updateCoreMember(){
        list<IPM_Project__c>iPMProjectList=new list<IPM_Project__c>();
        IPM_Project__c ipmproject=new IPM_Project__c(id=projectID);
        if(IPM_ConstantUtils.TEAM_COREPL==coreMembers){
            ipmproject.IPM_Project_Leader__c=selecetedCoreMember;
        }
        else if(IPM_ConstantUtils.TEAM_COREdPL==coreMembers){
            ipmproject.Deputy_Project_Leader__c =selecetedCoreMember;
        }
        else if(IPM_ConstantUtils.TEAM_COREGATEK==coreMembers){
            ipmproject.IPM_Project_Gatekeeper__c=selecetedCoreMember;
        }
        else if(IPM_ConstantUtils.TEAM_CORETPL==coreMembers){
            ipmproject.IPM_Technical_Project_Leader__c=selecetedCoreMember;
        }
        iPMProjectList.add(ipmproject);
        try{
            if(!IPMProjectList.isEmpty())
            update iPMProjectList;
        }
        catch(DmlException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                UPDATE_CORE_MEMBER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
             ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                UPDATE_CORE_MEMBER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
          
        }
    } 
    /*************************************************************************************************************
    * @description:Hold core member id from UI
    */
    public void holdCoreMember(){
        //holding core members
    }        
    
    /*******************************************************************************************************
    * @Description:create finance members when regional rollout having finance user
    * @Param:map of regional project id's and finance user id's    
    */
    
    public static void createFinanceMember(Map<Id,Id>newproAndUserMap){
        list<IPM_Project_Resource__c>lstnewResource=new list<IPM_Project_Resource__c>();
        for(Id projid:newproAndUserMap.keySet()){
            IPM_Project_Resource__c iPMresource=new IPM_Project_Resource__c();
            iPMresource.IPM_Project__c= projid;
            iPMresource.IPM_User__c=newproAndUserMap.get(projid);
            iPMresource.IPM_Role_Type__c=IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE;
            iPMresource.IPM_Project_Role_Owner__c=true;
            iPMresource.IPM_Unique_Resource__c=projid+string.valueof(newproAndUserMap.get(projid));//added to support Data migration
            lstnewResource.add(IPMresource);
        }
        if(!lstnewResource.isEmpty()){
            try{
                insert lstnewResource;
            }
            catch(DmlException ex){
                If(!Trigger.isExecuting)
                {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                }
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                CREATE_FINANCE_MEMBER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null); 
            }
            catch(Exception ex){
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
    public static void deleteFinanceMember(Map<Id,Id>newproAndUserMap){
        list<IPM_Project_Resource__c>lstnewResource=new list<IPM_Project_Resource__c>();
        lstnewResource=[SELECT Id FROM IPM_Project_Resource__c WHERE IPM_Role_Type__c=:IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE
        and IPM_Project__c IN:newproAndUserMap.keySet() and IPM_User__c =:newproAndUserMap.values()];
        
        if(!lstnewResource.isEmpty()){
            try{
                //To Check CRUD
                if (IPM_Project_Resource__c.sObjectType.getDescribe().isDeletable()){
                    delete lstnewResource;
                }    
            }catch(DmlException ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                DELETE_FINANCE_MEMBER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
          
            }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                DELETE_FINANCE_MEMBER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
               
            }
        }
    }
    
    /*************************************************************************************************************
    * @description:Hold the Leader member id from UI
    */
    public void holdLeader(){
        //holding leader members
    }
    
    /*************************************************************************************************************
    * @description:Assign Project Leader or Finance leader for current rollout
    */
    public void assignLeaderMember(){
        
        
        List<IPM_Project_Rollout__c> lstRegRollout = new List<IPM_Project_Rollout__c>();
        List<IPM_Project_Rollout__c> lstUpdateRegRollout = new List<IPM_Project_Rollout__c>();
        List<User> lstUser = new List<User>();
        
        lstRegRollout = [SELECT Id, Name, IPM_Regional_PL_Text__c, IPM_Finance_Member_Text__c FROM IPM_Project_Rollout__c WHERE ID =: rolloutId limit 1];
        if(!lstRegRollout.isEmpty() && SelectedLeaderMember != Null){
            lstUser = [SELECT Id, Name FROM User WHERE ID =: SelectedLeaderMember];
        }
        system.debug('lstUser--> ' + lstUser);
        if(!lstUser.isEmpty()){ 
            if(IPM_ConstantUtils.USER_FUNCTON_PL.equalsIgnoreCase(ButtonLabel) || IPM_ConstantUtils.USER_FUNCTON_CL.equalsIgnoreCase(ButtonLabel)){                                                                                                
                lstRegRollout[0].IPM_Regional_PL_Text__c = lstUser[0].Name;
                lstRegRollout[0].IPM_Regional_PL__c = lstUser[0].Id;
                lstUpdateRegRollout.add(lstRegRollout[0]); 
            }else if(IPM_ConstantUtils.USER_FUNCTON_FL.equalsIgnoreCase(ButtonLabel)){                                    
                lstRegRollout[0].IPM_Finance_Member_Text__c = lstUser[0].Name;     
                lstRegRollout[0].Finance_Member__c = lstUser[0].Id;       
                lstUpdateRegRollout.add(lstRegRollout[0]);
            }           
        }
        try{
            if(!lstUpdateRegRollout.isEmpty()){
                Update lstUpdateRegRollout;
            }
        }catch(DmlException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                ASSIGN_LEADER_MEMBER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
               
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                ASSIGN_LEADER_MEMBER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    /*************************************************************************************************************
    * @description:Get all members FROM same category for functional role.
    */
    public void getSameCategoryRolloutProfiles(){

        
        map<id,id>uniqueUsers=new map<id,id>();
        
        list<IPM_User_Profile__c>lstuser=new list<IPM_User_Profile__c>();
        string uQuery=IPM_ConstantUtils.BLANK; 

        string holdCategory = '\'%' + String.escapeSingleQuotes(Category) + PERCENTAGE_SLASH;

        if(IPM_ConstantUtils.TEAM_MYCATEGORY.equalsIgnoreCase(SearchLeaderbyCat)){
            UQuery=IPM_ConstantUtils.BLANK;
            UQuery = BEGIN_QUERY_TEAM;
            UQuery = UQuery+MID_QUERY_TEAM;
            UQuery = UQuery+'IPM_User__r.UserRole.Name FROM IPM_user_profile__c WHERE  (IPM_User__r.IsActive=True and ';
            UQuery = UQuery+' IPM_HoldCategory__c like '+holdCategory;
            UQuery= UQuery + '  ) limit 50000';
        }else if(IPM_ConstantUtils.TEAM_ALLCATEGORY.equalsIgnoreCase(SearchLeaderbyCat)){
            UQuery=IPM_ConstantUtils.BLANK;
            UQuery =BEGIN_QUERY_TEAM;
            UQuery = UQuery+MID_QUERY_TEAM;
            UQuery = UQuery+'IPM_User__r.UserRole.Name FROM IPM_user_profile__c WHERE  (IPM_User__r.IsActive=True';
            UQuery = UQuery+' and IPM_HoldCategory__c!=null) ';
            UQuery = UQuery+' limit 50000';
        }
        
        try{
            lstuser=database.query(UQuery);            
        }catch(DmlException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                SAME_CATEGORY_ROLLOUT_PROFILES,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
          
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                SAME_CATEGORY_ROLLOUT_PROFILES,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
          
        }
        
        for(IPM_User_Profile__c u:lstuser){
            if(!AvoidDupUser.contains(u.IPM_User__r.id)){
                uniqueUsers.put(u.IPM_User__c,u.id);
            }
        }
        
        leaderUsers=[SELECT IPM_User__r.id,IPM_User__r.Function__c,IPM_User_Role__c,IPM_User__r.name,
        IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,
        IPM_User__r.IPM_Brand_Name__c,IPM_User__r.IPM_Role__c, IPM_User__r.UserRole.Name
        FROM IPM_user_profile__c WHERE id IN:uniqueUsers.values()];
        
    }
    
    /*************************************************************************************************************
    * @description:Filter leader members FROM user profiles
    */
    public void filterLeaderMember(){
        lstUserProfile=new list<IPM_User_Profile__c>();
        string strCoreMem=IPM_ConstantUtils.BLANK; // used in the query
        string UQuery=IPM_ConstantUtils.BLANK;
        string querySearchLeader = String.escapeSingleQuotes(SearchLeader) +PERCENTAGE_SLASH;//used in the query below
        UQuery=BEGIN_QUERY;
        UQuery=UQuery+QUERY_FIELDS_STR;
        UQuery=UQuery+QUERY_WHERE_STR;
        UQuery=UQuery+' and (IPM_User__r.name Like \''+querySearchLeader+' or IPM_User__r.email like \''+querySearchLeader+')) limit 50000';
        
        try{
            if(UQuery!=IPM_ConstantUtils.BLANK){
                lstUserProfile=database.query(UQuery);
            }
        }catch(DmlException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                FILTER_LEADER_MEMBER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
          
            
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCEALLOCATION_STR,
                FILTER_LEADER_MEMBER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
          
            
        }
        
        if(lstUserProfile.isEmpty()){
            IsNoMatchfound=IPM_ConstantUtils.TEAM_TRUE ;
        }else{
            IsNoMatchfound=IPM_ConstantUtils.BLANK;
            leaderUsers = lstUserProfile;
        }
        
    }
    
     public Integer CountProjectMembers(string role){
        
        Integer countUserRole=[SELECT count() 
        FROM IPM_Project_Resource__c WHERE IPM_Project__c=:projectID AND IPM_Role_Type__c=:role];
          return  countUserRole;
    }
}