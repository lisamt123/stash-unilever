/******************************************** 
*@Author:Cognizant
*@Date:October 2014
*@Description : PL,BP and Central team members can change the bosscard status
*Bosscard status can be changed to Approved, Rejected, Archived and In progress.
*Referring in page ipmBosscardStatus
*********************************************/
global with sharing class IPM_BosscardStatusController{
    /*******************************************************************************
    *@Description: bosscard for quering the BOSSCARD details and are used to 
    *populate the same in Project
    ********************************************************************************/
    public IPM_Bosscard__c bosscard{get; set;}
    /*******************************************************************************
    *@Description:To query the existing project details , Need to optimize the same.
    *********************************************************************************/
        public IPM_Project__c project{get; set;}
    /********************************************************************************
    *@Description:To get the current BOSSCARD ID via Page parameters
    *********************************************************************************/
    public string bosscardId{get; set;}
    /********************************************************************************
    *@Description:To get the status of the BOSSCARD and render the comments field on 
    *the page if Approved
    *********************************************************************************/
        public boolean isApproved{get;set;}
    /*******************************************************************************
    *@Description:To hold the BOSSCARD status at run time to hold the status 
    ********************************************************************************/
    public string Statusvalue{get;set;}
    /*******************************************************************************
    *@Description:get list of all project leader associated with company card
    ********************************************************************************/
    public list<selectoption>projectleadelist{get;set;}
    /*******************************************************************************
    *@Description:get list of all project leader associated with company card
    ********************************************************************************/
    public list<IPM_User_Profile__c>projecLeaderlist{get;set;} 
    
    /*******************************************************************************
    *@Description:get selected project leader associated with company card
    ********************************************************************************/
    public string selectedPL{get;set;}    
    /*******************************************************************************
    *@Description:hold project leader user id
    ********************************************************************************/
    public String holdPL_STR{get;set;}
    /*******************************************************************************
    *@Description:Display no result found error message
    ********************************************************************************/
    public boolean IsNoMatchfound{get;set;}
    /*******************************************************************************
    *@Description:Display change button
    ********************************************************************************/
    public boolean isPLSelected_Booln{get;set;}
    /*******************************************************************************
    *@Description:count PL
    ********************************************************************************/
    public Integer plcount_INT{get;set;}
    /*******************************************************************************
    *@Description:company card name
    ********************************************************************************/
    public string companycard_Str {get;set;}
    /*******************************************************************************
    *@Description:show the PL search panel
    ********************************************************************************/
    public Boolean searchPL_Bool {get;set;}
    /***************************************************************
    *@Description :Constructor to fetch the details of the Bosscard
    ****************************************************************/
    private static final string CREATE_PROJECT = 'createProject';
    private static final string BOSSCARD_CTRL = 'IPM_BosscardController';
    public IPM_BosscardStatusController(){
        // call utility class to save having to do this multiple times in multiple places
        IPM_IECompatible.ieFix();
        isPLSelected_Booln=false;
        companycard_Str=null;
        plcount_INT=0;
        searchPL_Bool=true;
        bosscardId = ApexPages.currentPage().getParameters().get('Id');
        List<IPM_Bosscard__c> lstbosscard=new List<IPM_Bosscard__c>();
        List<IPM_User_Profile__c>validplList=new List<IPM_User_Profile__c>();
        try{
            if(bosscardId!=null){
                    lstbosscard=[SELECT Id,IPM_BosscardName__c,IPM_Bosscard_Status__c,IPM_Bosscard_Approver_Comments__c,
                                 IPM_Is_Draft__c,IPM_Project_Leader__c,IPM_Is_Accepted__c,IPM_Is_Archived__c,IPM_Company_Card__c FROM IPM_Bosscard__c 
                                 WHERE Id=:bosscardId limit 1];
            }
            if(!lstbosscard.isEmpty()){
                bosscard=lstbosscard[0];
                companycard_Str=lstbosscard[0].IPM_Company_Card__c; 
                Statusvalue=lstbosscard[0].IPM_Bosscard_Status__c;     
            }
            string query_str='';
            string strCoreMem='';
            strCoreMem=IPM_ConstantUtils.TEAM_PROJECT_LEADER;
            query_str='Select ID,IPM_User__c,IPM_User_Role__c FROM IPM_User_Profile__c WHERE';
            if(companycard_Str!=null){
                query_str+=' IPM_Company_Card__c=\''+ String.escapeSingleQuotes(companycard_Str) + '\' AND';
                
            }
            query_str+='  IPM_User_Function__c=\''+ String.escapeSingleQuotes(strCoreMem)+'\' AND IPM_User__r.IsActive=True AND IPM_User__c=\''+ userinfo.getuserid() + '\'   LIMIT 50000';
            validplList=database.query(query_str);
            if(!validplList.isEmpty()){
                holdPL_STR=userinfo.getuserid();
                searchPL_Bool=false;
                isPLSelected_Booln=true;
            }
            
            
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),IPM_BosscardController.class.getName(),
                                                       BOSSCARD_CTRL,ex.getMessage(),ex, 'Error', null, null, null); 
        }
    }
    
    /********************************************************************************
    *@Description :Remote method to create a project on click of Approve and change
    *@Param: Present BOSSCARD ID,project leader id,bosscard approval comments
    *@return:This method returns the Project ID
    *********************************************************************************/
    @remoteaction
    global static id createProject(ID BOSSID,ID PLId,string bossFeedback_STR){
        List<IPM_Bosscard__c> lstbosscard=new List<IPM_Bosscard__c>();
        IPM_Bosscard__c BOSSCARD_Record=new IPM_Bosscard__c();
        lstbosscard=[SELECT Id,IPM_BosscardName__c,IPM_Bosscard_Approver_Comments__c,IPM_Category__c,IPM_Bosscard_Status__c,IPM_Company_Card__c,
                         IPM_Bosscard_Logo_Id__c,IPM_Project_Leader__c,IPM_Region_Shr__c,IPM_Target_Launch_Date__c,IPM_Bosscard_Logo__c,IPM_Gate_Keeper__c,IPMBosscard_Span__c,
                         IPM_Is_Archived__c,IPM_Is_Accepted__c,IPM_Is_Draft__c,IPM_Gate_Keeper__r.Name,IPM_Brand__c,
                         IPM_Brand_Positioning__c FROM IPM_Bosscard__c WHERE Id=:BOSSID limit 1];
        IPM_Project__c NewProject=new IPM_Project__c();
        Savepoint sp = Database.setSavepoint();//setting the save point
        if(!lstbosscard.isEmpty()){
                BOSSCARD_Record=lstbosscard[0];
                BOSSCARD_Record.IPM_Is_Draft__c = false;
                BOSSCARD_Record.IPM_Is_Accepted__c=true;
                BOSSCARD_Record.IPM_Is_Archived__c=false;
                BOSSCARD_Record.IPM_Bosscard_Status__c=IPM_ConstantUtils.STATUS_APPROVED;
                BOSSCARD_Record.IPM_Bosscard_Approver_Comments__c=bossFeedback_STR;
                BOSSCARD_Record.IPM_Project_Leader__c=PLId;
                NewProject.IPM_Project_Name__c=BOSSCARD_Record.IPM_BosscardName__c;
                NewProject.IPM_Brand__c=BOSSCARD_Record.IPM_Brand__c;
                NewProject.IPM_Category_Text__c=BOSSCARD_Record.IPM_Category__c;
                NewProject.IPM_Brand_Positioning__c=BOSSCARD_Record.IPM_Brand_Positioning__c;
                NewProject.IPM_Project_Gatekeeper__c=BOSSCARD_Record.IPM_Gate_Keeper__c;
                NewProject.IPM_Target_Launch_Date__c=BOSSCARD_Record.IPM_Target_Launch_Date__c;
                NewProject.IPM_Bosscard__c=BOSSCARD_Record.Id;
                NewProject.IPM_Bosscard_Status__c = true;
                NewProject.IPM_Project_Logo__c=BOSSCARD_Record.IPM_Bosscard_Logo__c;
                NewProject.IPM_Project_Logo_Id__c=BOSSCARD_Record.IPM_Bosscard_Logo_Id__c;
                NewProject.IPM_Company_Card__c=BOSSCARD_Record.IPM_Company_Card__c;
                NewProject.IPM_Region_Shr__c=BOSSCARD_Record.IPM_Region_Shr__c;
                
                
        }
         try{
            update BOSSCARD_Record;
            insert NewProject ;
            IPM_Project__c updateProject=new IPM_Project__c();
            updateProject.id=NewProject.id;
            updateProject.IPM_Project_Leader__c=PLId;
            update updateProject;
            
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),IPM_BosscardController.class.getName(),
                                                       CREATE_PROJECT,ex.getMessage(),ex, 'Error', null, null, null); 
            // Rollback to the previous  values
            Database.rollback(sp);
        }
        return NewProject.id;
    }
    /********************************************************************************
    *@Description :For getting Bosscard Status Value.
    *@Param: NA
    *@return:This method returns the list and which contains the status of BOSSCARD.
    *********************************************************************************/
    
    public List<SelectOption> getStatusValue(){
        Schema.sObjectType sobject_type = IPM_Bosscard__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('IPM_Bosscard_Status__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
       
    
    /********************************************************************************
    *@Description :For changing the status of Bosscard.
    *@Param: NA
    *@return:Void.
    *********************************************************************************/
    
    public void updateStatus(){
        
        if(Statusvalue==IPM_ConstantUtils.STATUS_IN_PROGRESS || Statusvalue==IPM_ConstantUtils.STATUS_NOT_APPROVED ){
                bosscard.IPM_Bosscard_Status__c=Statusvalue; 
        }     
        else if(Statusvalue==IPM_ConstantUtils.STATUS_DISCARD ){
                bosscard.IPM_Is_Draft__c = false;
                bosscard.IPM_Is_Accepted__c=false;
                bosscard.IPM_Is_Archived__c=true;   
        }
        try{
                update bosscard;
        }
        catch(Exception ex){
                ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),IPM_BosscardController.class.getName(),
                                                           'updateStatus',ex.getMessage(),ex, 'Error', null, null, null); 
       }
    }
    
    /********************************************************************************
    *@Description :Hold bosscard status which is select from UI.
    *@Param: NA
    *@return:Void.
    *********************************************************************************/
    
    public void setStatus(){
        bosscard.IPM_Bosscard_Status__c=Statusvalue;
    }
    
    /********************************************************************************
    *@Description :get list of project leader.
    *@Param: NA
    *@return:Void.
    *********************************************************************************/
    public void filterprojectLeader(){
        projecLeaderlist=new list<IPM_User_Profile__c>();
        IsNoMatchfound=false;
        isPLSelected_Booln=false;
        String likePerStr='%';
        plcount_INT=0;
        string strCoreMem='';
        strCoreMem=IPM_ConstantUtils.TEAM_PROJECT_LEADER;
        
        //Get a list of all IPM Project leader
        String queryString = 'SELECT ';
        //user profile fileds
        For (String field : Schema.SObjectType.IPM_User_Profile__c.fields.getMap().KeySet()){
            if (field != 'Id')
                queryString+= field + ', ';
        }
        queryString+= 'Id,IPM_User__r.name,IPM_User__r.id,IPM_User__r.SmallPhotoUrl,IPM_User__r.email FROM IPM_User_Profile__c WHERE (IPM_User__r.name like \''+ likePerStr + String.escapeSingleQuotes(selectedPL) + likePerStr + '\' OR IPM_User__r.email Like \'' + likePerStr + String.escapeSingleQuotes(selectedPL) + likePerStr + '\')';
        queryString+=' AND IPM_User_Function__c=\''+ String.escapeSingleQuotes(strCoreMem) +'\' AND IPM_User__r.IsActive=True ';
        
        queryString+= ' ORDER BY IPM_User__r.name';
        queryString+= ' LIMIT 1000';
        
        projecLeaderlist=database.query(queryString);
        map<id,id>uniqueUserList=new map<id,id>();
        if(projecLeaderlist.isEmpty()){
            IsNoMatchfound=true; 
        }
        else{
            
            for(IPM_User_Profile__c UP:projecLeaderlist){
                if(!uniqueUserList.containsKey(UP.IPM_User__c)){
                    uniqueUserList.put(UP.IPM_User__c,UP.Id); 
                    plcount_INT+=1;
                }
            }
            projecLeaderlist=[SELECT IPM_User__r.id,IPM_User_Role__c,IPM_User__r.name,IPM_User__r.email,
                              IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl, 
                              IPM_User__r.UserRole.Name FROM IPM_user_profile__c WHERE id IN:uniqueUserList.values() ORDER BY IPM_User__r.name limit 50000];
            
            IsNoMatchfound=false;
        }
    }
    /********************************************************************************
    *@Description :after selection of project leader show the change button
    *@Param: NA
    *@return:Void.
    *********************************************************************************/
    public void holdPLUserId(){
        isPLSelected_Booln=true;
    }
}