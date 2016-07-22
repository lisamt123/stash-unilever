/***********************************************************************************************************
* @author:Cognizant
* @date:25/09/2014
* @description: This class is used for assigned project team members,change functional role owner,
*               delete team members and save core team members.get total numbers of user respective
*               functional role.Populated all role type user image according to role type.
*               this is used in project initiation wizard and team assigned page.
*/

public with sharing class IPM_Team_Assignment_Controller {
    
    public static final String IPM_RESOURCE_ALLOCATION_FINALREVAMP_STR = IPM_Team_Assignment_Controller.class.getName();
    private static final string HOLDING_SELECTE_OWNER_ID = 'hodingSelecteOwnerId';
    private static final string SAVE_TEAM_MEMBERS='SaveTeamMembers';
    private static final string SAVE_CORE_MEMBERS='SaveCoreMembers';
    private static final string DELETE_ASSIGNED_MEM='DeleteAssignedmembers';

    /*******************************************************************************************************
    * @description: Store IPM project details.
    * returns IPM Project details.
    */ 
    public IPM_Project__c IPM_proj{get;set;}

    /*******************************************************************************************************
    * @description: Store user roles FROM user object.
    * returns list of user roles.
    */
    public list<String>IPM_User_Role{get;set;}
    /*******************************************************************************************************
    * @description: Get project name as id FROM url parameter.
    * returns project id.
    */
    public String projectID{get;set;}
    
    /*******************************************************************************************************
    * @description: Get all list of Assigned members for current project .
    * returns all assigned project members.
    */
    public list<IPM_Project_Resource__c>listofAssignedMem{get;set;}
    
    /*******************************************************************************************************
    * @description: hold project leader name.
    * returns project leader name.
    */
    public String pLName{get;set;}
    /*******************************************************************************************************
    * @description: hold gatekeeper name.
    * returns gatekeeper name.
    */
    public String gateKeeperName{get;set;}
    /*******************************************************************************************************
    * @description: hold DEPUTY PROJECT LEADER name.
    * returns DEPUTY PROJECT LEADER name.
    */
    public String dPLName{get;set;}
    /*******************************************************************************************************
    * @description: hold TECHNICAL PROJECT LEADER image url.
    * returns TECHNICAL PROJECT LEADER image.
    */
    public String tPLimg{get;set;}
    /*******************************************************************************************************
    * @description: hold TECHNICAL PROJECT LEADER name.
    * returns TECHNICAL PROJECT LEADER name.
    */
    public String tPLName{get;set;}
    
    /*******************************************************************************************************
    * @description: hold gatekeeper image url.
    * returns gatekeeper image.
    */  
    public String gKImage{get;set;} 
    /*******************************************************************************************************
    * @description: hold DEPUTY PROJECT LEADER image url.
    * returns DEPUTY PROJECT LEADER image.
    */ 
    public String dPLimg{get;set;} 
    /*******************************************************************************************************
    * @description: hold project leader image url.
    * returns project leader image.
    */ 
    public string plImage{get;set;} 
    
    /*******************************************************************************************************
    * @description: hold Project Leader id.
    * returns Project Leader id.
    */
    public string pL_ids{get;set;}
    /*******************************************************************************************************
    * @description: hold GateKeeper id.
    * returns Project Leader id.
    */
    public string gateKeeper_ids{get;set;}
    /*******************************************************************************************************
    * @description: hold Deputy Project Leader id.
    * returns Deputy Project Leader id.
    */
    public string dPL_ids{get;set;}
    /*******************************************************************************************************
    * @description: hold Technical Project Leader id.
    * returns Technical Project Leader id.
    */
    public string tPL_ids{get;set;}
    /*******************************************************************************************************
    * @description: count BB team members FROM current project.
    * returns total number of BB members.
    */
    public integer countBB{get;set;}
    /*******************************************************************************************************
    * @description: count BD team members FROM current project.
    * returns total number of BD members.
    */
    public integer countBD{get;set;}
    /*******************************************************************************************************
    * @description: count finance team members FROM current project.
    * returns total number of finance members.
    */
    public integer countFinance{get;set;}
    /*******************************************************************************************************
    * @description: count CD team members FROM current project.
    * returns total number of CD members.
    */
    public integer countCD{get;set;}
    /*******************************************************************************************************
    * @description: count CMI team members FROM current project.
    * returns total number of CMI members.
    */
    public integer countCMI{get;set;}
    /*******************************************************************************************************
    * @description: count Supply Chain team members FROM current project.
    * returns total number of Supply Chain members.
    */
    public integer countSupplyChain{get;set;}
    /*******************************************************************************************************
    * @description: count Guest team members FROM current project.
    * returns total number of Guest members.
    */
    public integer countGuest{get;set;}
    /*******************************************************************************************************
    * @description: count R&D team members FROM current project.
    * returns total number of R&D members.
    */
    public integer countReDev{get;set;}
    /*******************************************************************************************************
    * @description: hold Selected Deputy Project Leader name.
    * returns Deputy Project Leader name.
    */
    public string selectedDPL{get;set;}
    /*******************************************************************************************************
    * @description: hold Selected Technical Project Leader image.
    * returns Technical Project Leader image.
    */
    public string selectedTL{get;set;}
    /*******************************************************************************************************
    * @description: checking whether coreparameter is completed.
    */
    public boolean isCoreParameter{get;set;}
    /*******************************************************************************************************
    * @description: hold Selected Project Leader image.
    * returns Project Leader image.
    */
    public string selectedGK{get;set;}
    /*******************************************************************************************************
    * @description: hold Selected Project Leader image.
    * returns Project Leader image.
    */
    public string selectedPL{get;set;}
    /*******************************************************************************************************
    * @description: checking whether logged in user is deputy project leader.
    */
    public Boolean isDPLeader{get;set;}
    /*******************************************************************************************************
    * @description: checking whether logged in user is project leader.
    */
    public Boolean isPLeader{get;set;}
    /*******************************************************************************************************
    * @description: checking whether logged in user is guest.
    */
    public Boolean isGuestUser{get;set;}
    /*******************************************************************************************************
    * @description: get Selected resource record id.
    */
    public id selectedRecordId{get;set;}
    /*******************************************************************************************************
    * @description: set of Selected resource record id.
    */
    Public set<id>setSelectedRId=new set<id>();
    /*******************************************************************************************************
    * @description: show or hide the gatekeeper.
    */
    public boolean isGateKShow{get;set;}
    /*******************************************************************************************************
    * @description: show or hide the Project leader.
    */
    public boolean isPLShow{get;set;}
    /*******************************************************************************************************
    * @description: show or hide the deputy project leader.
    */
    public boolean isDPLShow{get;set;}
    /*******************************************************************************************************
    * @description: show or hide the technical project leader.
    */
    public boolean isTPLShow{get;set;}
    /*******************************************************************************************************
    * @description: hold Selected resource record id.
    */
    public id IPMResourceId{get;set;}
    /*******************************************************************************************************
    * @description: checking whether team members are saved.
    */
    public Boolean isTeamMemberSave{get;set;}
    /*******************************************************************************************************
    * @description: hold Selected user role at run time.
    */
    public String selectedRoleType{get;set;}
    /*******************************************************************************************************
    * @description: checking whether current logged in user has edit permission  to core members allocation.
    */
    public Boolean isEditable{get;set;}
    /*******************************************************************************************************
    * @description: checking whether current logged in user has edit permission  to core members allocation.
    */
    public Boolean isCoreMemEditable{get;set;}
    /*******************************************************************************************************
    * @description: checking whether technical project leader has edit access.
    */        
    public boolean isTPLEditable{get;set;}
    /*******************************************************************************************************
    * @description: get current logged in role type.
    */
    public string loginusertype{get;set;}
    /*******************************************************************************************************
    * @description: checking whether current logged in user has edit permission to team assigned page.
    */
    public boolean isShowEditmode{get;set;}
    
     /*******************************************************************************************************
    * @description: checking whether current logged in user has edit permission to team assigned page on stopped Projects.
    */
    public boolean isStopped{get
        { return ( IPM_proj.IPM_PrepareForArchival__c || IPM_proj.Is_Archieved__c);}set;}
   
    /*******************************************************************************************************
    * @Description: This is IPM_Resource_Allocation_FinalRevamp constructor and Initialise all variables.Get Project id FROM url parameter
    * @return:
    */ 

    public  IPM_Team_Assignment_Controller (){
        IPM_IECompatible.ieFix();// added for Compatibility fix
        isTeamMemberSave=false;
        isShowEditmode=false;
        loginusertype=IPM_ConstantUtils.BLANK;
        isEditable=false;
        isCoreMemEditable=false;
        isTPLEditable=false;
        isPLShow=false;
        isDPLShow=false;
        isTPLShow=false;
        isGateKShow=false;
        isDPLeader=false;
        isPLeader=false;
        
        PLName=IPM_ConstantUtils.BLANK;
        GKImage=IPM_ConstantUtils.BLANK;
        GateKeeperName=IPM_ConstantUtils.BLANK;
        DPLName=IPM_ConstantUtils.BLANK;
        DPLimg=IPM_ConstantUtils.BLANK;
        TPLName=IPM_ConstantUtils.BLANK;
        TPLimg=IPM_ConstantUtils.BLANK;
        PL_ids=IPM_ConstantUtils.BLANK;
        GateKeeper_ids=IPM_ConstantUtils.BLANK;
        DPL_ids=IPM_ConstantUtils.BLANK;
        TPL_ids=IPM_ConstantUtils.BLANK;
        isCoreParameter=true;
        
        string checktoshowedit=IPM_ConstantUtils.BLANK;
        checktoshowedit=ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.IPM_Edit_Show_Team);
        if(string.isNotBlank(checktoshowedit) && checktoshowedit.Equals(IPM_ConstantUtils.TEAM_TRUE)){
            isShowEditmode=true;
        }
        projectID=ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.IPM_Project_PID);
        if(String.isBlank(projectID)){
            projectID=ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.TEAM_PROJECTID);
        }
        initialise();     
        countProjectMembers();
        getIpmuserType();
    }
    /*******************************************************************************************************
    * @Description: This is method is used to get Project details like(Project name,core team members,etc.).
    *               get all team members image. 
    */  
    public void initialise(){
        
        IPM_proj=new IPM_Project__c();
        List<IPM_Project__c>ipmProjectList=new List<IPM_Project__c>();
        ipmProjectList=[SELECT IPM_Project_Name__c,IPMProject_Span__c,IPM_Project_Gatekeeper__c,
        Deputy_Project_Leader__c,IPM_Brand_Positioning__c,IPM_Project_Logo__c,IPM_PrepareForArchival__c,
        IPM_Technical_Project_Leader__c,IPM_Project_Leader__c,IPM_Project_Description__c,Is_Archieved__c,
        IPM_CPP__c,IPM_CPP_Change_Reason__c,IPM_Technical_Project_Leader__r.name,
        Deputy_Project_Leader__r.name,Deputy_Project_Leader__r.id,IPM_Project_Gatekeeper__r.name,
        IPM_Project_Leader__r.name,IPM_Project_Leader__r.SmallPhotoUrl,
        IPM_Technical_Project_Leader__r.SmallPhotoUrl,IPM_Project_Gatekeeper__r.SmallPhotoUrl,
        Deputy_Project_Leader__r.SmallPhotoUrl,IPM_Brand__c,IPM_Category_Text__c FROM IPM_Project__c
        WHERE id=:projectID LIMIT 1];
        if(!ipmProjectList.isEmpty()){
            IPM_proj=ipmProjectList[0];
            if(IPM_proj.IPM_Project_Leader__c==userinfo.getuserid() || 
                    (IPM_proj.Deputy_Project_Leader__r.id==userinfo.getuserid() && 
                        IPM_proj.IPM_Project_Leader__c==userinfo.getuserid()) ){
                isPLeader=true; 
            }
            else if(IPM_proj.Deputy_Project_Leader__r.id==userinfo.getuserid()){
                isDPLeader=true;
            }
            
        }       
        IPM_User_Role=new list<String>(); 
        if(IPM_ConstantUtils.PROJECT_SPAN_LOCAL.equalsIgnoreCase(IPM_proj.IPMProject_Span__c)){
            IPM_User_Role.add(IPM_ConstantUtils.FUNCTIONAL_ROLE_BB);
        }else{
            IPM_User_Role.add(IPM_ConstantUtils.FUNCTIONAL_ROLE_BD);
        }
        IPM_User_Role.add(IPM_ConstantUtils.FUNCTIONAL_ROLE_CD);
        IPM_User_Role.add(IPM_ConstantUtils.FUNCTIONAL_ROLE_CMI);
        IPM_User_Role.add(IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE);
        IPM_User_Role.add(IPM_ConstantUtils.FUNCTIONAL_ROLE_RD);
        IPM_User_Role.add(IPM_ConstantUtils.IPM_ROLE_SUPPLY_CHAIN);
        IPM_User_Role.Sort();
        IPM_User_Role.add(IPM_ConstantUtils.TEAM_GUEST);
        getGuestUser();    
        getAssignedMember();
        
        //SELECT Default Member
        SelectedPL=IPM_proj.IPM_Project_Leader__c;
        SelectedDPL=IPM_proj.Deputy_Project_Leader__c;
        SelectedTL=IPM_proj.IPM_Technical_Project_Leader__c;
        SelectedGK=IPM_proj.IPM_Project_Gatekeeper__c;
        PL_ids=IPM_proj.IPM_Project_Leader__c;
        plImage=IPM_proj.IPM_Project_Leader__r.SmallPhotoUrl;//get current project leader image
        PLName=IPM_proj.IPM_Project_Leader__r.Name;// get current project leader name
        if(String.IsBlank(String.valueOf(IPM_proj.IPM_Project_Gatekeeper__c))){
            GateKeeper_ids=IPM_proj.IPM_Project_Leader__c;
            GKImage=IPM_proj.IPM_Project_Leader__r.SmallPhotoUrl;
            GateKeeperName=IPM_proj.IPM_Project_Leader__r.Name;
        }else{
            GateKeeper_ids=IPM_proj.IPM_Project_Gatekeeper__c;
            GKImage=IPM_proj.IPM_Project_Gatekeeper__r.SmallPhotoUrl;
            GateKeeperName=IPM_proj.IPM_Project_Gatekeeper__r.name;
        }
        if(String.IsBlank(String.valueOf(IPM_proj.Deputy_Project_Leader__r.name))){
            DPL_ids=IPM_proj.IPM_Project_Leader__c;
            DPLimg=IPM_proj.IPM_Project_Leader__r.SmallPhotoUrl;
            DPLName=IPM_proj.IPM_Project_Leader__r.Name;
        }else{
            DPL_ids=IPM_proj.Deputy_Project_Leader__c;
            DPLName=IPM_proj.Deputy_Project_Leader__r.name;
            DPLimg=IPM_proj.Deputy_Project_Leader__r.SmallPhotoUrl;
        }
        if(String.IsBlank(String.valueOf(IPM_proj.IPM_Technical_Project_Leader__r.name))){
            TPL_ids=IPM_proj.IPM_Project_Leader__c;
            TPLimg=IPM_proj.IPM_Project_Leader__r.SmallPhotoUrl;
            TPLName=IPM_proj.IPM_Project_Leader__r.Name;
        }else{
            TPL_ids=IPM_proj.IPM_Technical_Project_Leader__c;
            TPLName=IPM_proj.IPM_Technical_Project_Leader__r.name;
            TPLimg=IPM_proj.IPM_Technical_Project_Leader__r.SmallPhotoUrl;
        }
    }  
    /*******************************************************************************************************
    * @Description:Counting all team resource with respective functional roles  
    */   
    public void CountProjectMembers(){
        //initializing the counts to 0 
        countBB=0;
        countBD=0;
        countFinance=0;
        countCD=0;
        countCMI=0;
        countSupplyChain=0;
        countGuest=0;
        countReDev=0;
        for(IPM_Project_Resource__c proRes:[SELECT ID,IPM_Project__c,IPM_Role_Type__c 
        FROM IPM_Project_Resource__c WHERE IPM_Project__c=:projectID AND IPM_Role_Type__c!=null LIMIT 50000]){
            if(proRes.IPM_Role_Type__c.equals(IPM_ConstantUtils.FUNCTIONAL_ROLE_BB)){
                countBB++;
            }
            if(proRes.IPM_Role_Type__c.equals(IPM_ConstantUtils.FUNCTIONAL_ROLE_BD)){
                countBD++;
            }
            if(proRes.IPM_Role_Type__c.equals(IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE)){
                countFinance++;
            }
            if(proRes.IPM_Role_Type__c.equals(IPM_ConstantUtils.FUNCTIONAL_ROLE_CD)){
                countCD++;
            }
            if(proRes.IPM_Role_Type__c.equals(IPM_ConstantUtils.FUNCTIONAL_ROLE_CMI)){
                countCMI++;
            }
            if(proRes.IPM_Role_Type__c.equals(IPM_ConstantUtils.IPM_ROLE_SUPPLY_CHAIN)){
                countSupplyChain++;
            }
            if(proRes.IPM_Role_Type__c.equals(IPM_ConstantUtils.TEAM_GUEST)){
                countGuest++;
            }
            if(proRes.IPM_Role_Type__c.equals(IPM_ConstantUtils.FUNCTIONAL_ROLE_RD)){
                countReDev++;
            }
        }
    }
    
    
    
    /*******************************************************************************************************
    * @Description:checking the current logged in user as guest user for current project        
    */ 
    public void GetGuestUser(){
        list<IPM_Project_Resource__c>lstofguest =new list<IPM_Project_Resource__c>();
        lstofguest =[SELECT id,IPM_User__c,IPM_Role_Type__c FROM IPM_Project_Resource__c WHERE 
        IPM_Project__r.id=:projectID AND IPM_Role_Type__c=:IPM_ConstantUtils.TEAM_GUEST 
        AND IPM_User__c=:userinfo.getuserid() LIMIT 1];
        if(!lstofguest.isEmpty()){
            isGuestUser=true;
        }                     
        
    } 
    
    /*******************************************************************************************************
    * @Description:Get all assigned team members list of current project   
    */ 
    public void GetAssignedMember(){
    CountProjectMembers();
        listofAssignedMem=new list<IPM_Project_Resource__c>();
        
        listofAssignedMem=[SELECT id,IPM_User__c,IPM_User__r.name,IPM_User__r.SmallPhotoUrl,
        IPM_Project_Role_Owner__c,
        IPM_Role_Type__c FROM IPM_Project_Resource__c WHERE 
        IPM_Project__r.id=:projectID 
        ORDER BY IPM_Project_Role_Owner__c DESC LIMIT 50000];
        
       
        }
        
       
    /*******************************************************************************************************
    * @Description:Save team members   
    * @return:null
    */ 
    public pagereference SaveTeamMembers(){
        list<IPM_Project__c>projectTeamMemsList=new list<IPM_Project__c>();
        if(string.isNotBlank(PL_ids) && string.isNotBlank(GateKeeper_ids) && string.isNotBlank(DPL_ids) 
                && string.isNotBlank(TPL_ids)){   
            IPM_proj.IPM_Project_Leader__c=PL_ids;
            IPM_proj.IPM_Project_Gatekeeper__c=GateKeeper_ids;
            IPM_proj.IPM_Technical_Project_Leader__c=TPL_ids;
            IPM_proj.Deputy_Project_Leader__c=DPL_ids;
            projectTeamMemsList.add(IPM_proj);
            
            try{
                update projectTeamMemsList;
                
            }
            catch(DmlException ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCE_ALLOCATION_FINALREVAMP_STR,
                SAVE_TEAM_MEMBERS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            }
            catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCE_ALLOCATION_FINALREVAMP_STR,
                SAVE_TEAM_MEMBERS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            }
            isTeamMemberSave=true;
        }
        
        return null;
    }
    /*******************************************************************************************************
    * @Description:hold Selected owner user and update functional owner
    */ 
    public void hodingSelecteOwnerId(){
        SetSelectedRId.add(SelectedRecordId);
        list<IPM_Project_Resource__c>changeFunctionWonerList=new list<IPM_Project_Resource__c>();
        list<IPM_Project_Resource__c>lstassignedowner=[SELECT id,IPM_Project_Role_Owner__c FROM IPM_Project_Resource__c 
        WHERE IPM_Project__c=:projectID AND 
        IPM_Role_Type__c=:SelectedRoleType 
        AND IPM_Project_Role_Owner__c=true LIMIT 50000];
        if(lstassignedowner != NULL && !lstassignedowner.isEmpty()){
            IPM_Project_Resource__c changeFunctionOwner=new IPM_Project_Resource__c(id=lstassignedowner[0].id);
           
            
            changeFunctionOwner.IPM_Project_Role_Owner__c=false;
            changeFunctionWonerList.add(changeFunctionOwner);
            try{
                update changeFunctionWonerList;
            }
            catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCE_ALLOCATION_FINALREVAMP_STR,
                HOLDING_SELECTE_OWNER_ID,ex.getMessage(),ex, 'Error', null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            }           
        }
        IPM_Project_Resource__c functionOwner=new IPM_Project_Resource__c(id=SelectedRecordId);
        functionOwner.IPM_Project_Role_Owner__c=true;
        changeFunctionWonerList.add(functionOwner);
        try{
            update changeFunctionWonerList;
        }
        catch(DmlException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCE_ALLOCATION_FINALREVAMP_STR,
            HOLDING_SELECTE_OWNER_ID,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCE_ALLOCATION_FINALREVAMP_STR,
            HOLDING_SELECTE_OWNER_ID,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }       
        if(SelectedRoleType.equalsIgnoreCase(IPM_ConstantUtils.FUNCTIONAL_ROLE_RD)){
            initialise();
        }
        getAssignedMember();
    }
    /*******************************************************************************************************
    * @Description:Save Updated Core project members    
    */
    public void SaveCoreMembers(){
        list<IPM_Project__c>projectCoreMemsList=new list<IPM_Project__c>();
        if(string.isNotBlank(SelectedPL) && string.isNotBlank(SelectedDPL) && string.isNotBlank(SelectedTL) 
                && string.isNotBlank(SelectedGK)){
            IPM_proj.IPM_Project_Leader__c=SelectedPL;
            IPM_proj.IPM_Project_Gatekeeper__c=SelectedGK;
            IPM_proj.IPM_Technical_Project_Leader__c=SelectedTL;
            IPM_proj.Deputy_Project_Leader__c=SelectedDPL;
            projectCoreMemsList.add(IPM_proj);
            try{
                update projectCoreMemsList;
            }
            catch(DmlException ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCE_ALLOCATION_FINALREVAMP_STR,
                SAVE_CORE_MEMBERS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            }
            catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCE_ALLOCATION_FINALREVAMP_STR,
                SAVE_CORE_MEMBERS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            }
            isGateKShow=false;
            isTPLShow=false;
            isPLShow=false;
            isDPLShow=false;
            isTeamMemberSave=true;
        }
    }
    
    /*******************************************************************************************************
    * @Description:Delete Assigned Member   
    */
    public void DeleteAssignedmembers(){
        list<IPM_Project_Resource__c>tobedeleteProjectMemList=new list<IPM_Project_Resource__c>();
        IPM_Project_Resource__c deleteRecord=new IPM_Project_Resource__c(id=IPMResourceId);
        tobedeleteProjectMemList.add(deleteRecord);
        try{
            //To Check CRUD
            if (IPM_Project_Resource__c.sObjectType.getDescribe().isDeletable()){   
                delete tobedeleteProjectMemList;
            }    
        }
        catch(DmlException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCE_ALLOCATION_FINALREVAMP_STR,
            DELETE_ASSIGNED_MEM,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_RESOURCE_ALLOCATION_FINALREVAMP_STR,
            DELETE_ASSIGNED_MEM,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        getAssignedMember();
        countProjectMembers();
        
    }
    /*******************************************************************************************************
    * @Description:Get user type with access permission   
    */
    public void getIpmuserType(){
        IPM_Project__c associatedProject = null;
        list<IPM_Project__c> projectList = [SELECT IPM_Project_Leader__c,IPM_PrepareForArchival__c,Is_Archieved__c FROM IPM_Project__c WHERE 
        id=:projectID AND (IPM_Project_Leader__c =:userinfo.getuserid() OR Deputy_Project_Leader__c=:userinfo.getuserid() ) LIMIT 1];
        
        if(!projectList.isEmpty())
        {
        	associatedProject = projectList[0];
            isCoreMemEditable=true;
            isEditable=true;
        }
         
        //security for central team and BP users
        IPM_CustomPermission cpr = new IPM_CustomPermission();
        boolean isCentralTeam=false;
        boolean isBPUser=false;
        isCentralTeam = cpr.hasPermission(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
        isBPUser=cpr.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
        if(isCentralTeam || isBPUser){
            isEditable=true;
            isCoreMemEditable=true;
        }                                              
    } 
    /*******************************************************************************************************
    * @Description:show edit team members    
    */
    public void ShowEditTeam(){
        if(!isShowEditmode){
            isShowEditmode=true;
        }else{
            isShowEditmode=false;
        }
    }  
}