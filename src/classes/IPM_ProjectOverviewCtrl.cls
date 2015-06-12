/*Change Log
Samrat: Change date time to date as per VD of stopping projects
Samrat: Changed Stopping Logic on line 117
*/

public without sharing class IPM_ProjectOverviewCtrl {

    public List<IPM_Project__History> lstprojecthistory {get;set;}
    public String lstalertMessage {get;set;}
    public IPM_Project_Document__c projectDoc{get; set;}
    private String currPhase;
    public boolean IsUpdateStatus{get;set;}
    public String stoppedMsg{get;set;}
    public String gateDateAlert{get;set;}
    public String currGate{get;set;}
    public String unApprovedCurrGate{get;set;}
    public IPM_Milestone__c milesTone{get;set;}
    public IPM_Project__c projectObj {get;set;}
    public String projectId {get;set;}
    public List<IPM_Project_Document_Section__c> projectSections {get;set;}
    public Integer allIncompleteTasks {get;set;}
    public String taskId{get;set;}
    public String isChecked{get;set;}
    public sObject projSectionList{get; set;} 
    public Integer remainingDays{get;set;}
    public Date days{get;set;}
    public objectHistoryWrapper[] activityHistory {get;set;}
    public Boolean Taskeditable{get;set;}
    Public Boolean AllTask{get;set;}
    
    public Date stoppedDate{get;set;}
    
    public Map<String, String> objectFldMap = new Map<String, String>{
                                              'IPM_Task__History' => 'IPM_Completed__c,IPM_Task_Name__c,IPM_Task_Complexity__c,IPM_Assignee__c,IPM_Task_Type__c',
                                              'IPM_Project_Document_Section__History' => 'IPM_Section_Name__c,IPM_Section_Owner__c,IPM_Section_Status__c',
                                              'IPM_Project_Document__History' => 'IPM_Document_Status__c,IPM_Approval_Date__c'
                                                                     };
    public Map<String, String> objectAddtnlFldsMap = new Map<String, String>{
                                              'IPM_Task__History' => 'Parent.IPM_Task_Name__c',
                                              'IPM_Project_Document_Section__History' => 'Parent.IPM_Project_Section__c',
                                              'IPM_Project_Document__History' => 'Parent.IPM_GateDocuments__c'
                                                                     };
    
    public IPM_ProjectOverviewCtrl(IPM_ProjDocumentSectionHstryController controller) {
        taskId = '';
        allIncompleteTasks = 0;
        remainingDays = 0;
        IsUpdateStatus=false;
        
        projectSections = new List<IPM_Project_Document_Section__c>();
        projectId = ApexPages.currentPage().getParameters().get('id');
        lstprojecthistory=[SELECT ParentId,Parent.Name,Parent.IPM_Fast_Track_Project__c 
                            FROM IPM_Project__History 
                            WHERE Field = 'IPM_Fast_Track_Project__c' and ParentId=:projectId AND CreatedDate >=: System.today()-7];
        if(!lstprojecthistory.isEmpty()){
            for(IPM_Project__History history:lstprojecthistory){
                if(history.Parent.IPM_Fast_Track_Project__c){
                    lstalertMessage=' Project is now fast Track';
                }else{
                    lstalertMessage=' Project is no more Fast track';
                }
            }
        }
        
        list<IPM_Project__c>lstofuser=[select IPM_Project_Leader__c,IPM_Project_Gatekeeper__c from IPM_Project__c where 
                                        id=:projectId and (IPM_Project_Leader__c =:userinfo.getuserid() 
                                         or Deputy_Project_Leader__c=:userinfo.getuserid() ) limit 1];

        if(lstofuser.size()>0 && lstofuser[0].IPM_Project_Gatekeeper__c!=userinfo.getuserid()) {
            IsUpdateStatus=true;
        }
           
        list<PermissionSetAssignment>PermissonS=[select Assignee.Name, PermissionSet.Name
                                                    from PermissionSetAssignment 
                                                    where (PermissionSet.Name='IPM_Central_Team' or 
                                                        PermissionSet.Name='IPM_Business_Partners') and Assignee.id=:userinfo.getuserid()];
        if(PermissonS.size()>0){
            IsUpdateStatus=true;
        }
 
       List<IPM_Task__c> tskList = [SELECT Id FROM IPM_Task__c WHERE IPM_Project__c = :projectId];
       projSectionList = tskList.size() > 0 ? tskList[0] : new IPM_Task__c();
       
       try{
            IPM_Project__c projObj = IPM_Utils.getCurrentPhase(projectId);
            currPhase = projObj.IPM_Phase__c;
            init();
        }catch(exception e) {
            system.debug(e + ' ** error : ' + e.getLineNumber());
        }
    }
    
    public IPM_ProjectOverviewCtrl() {
        projectId = ApexPages.currentPage().getParameters().get('id');
        taskId = '';
        allIncompleteTasks = 0;
        IsUpdateStatus=false;
        
        list<IPM_Project__c>lstofuser=[select IPM_Project_Leader__c,IPM_Project_Gatekeeper__c from IPM_Project__c where 
                                        id=:projectId and (IPM_Project_Leader__c =:userinfo.getuserid()  
                                         or Deputy_Project_Leader__c=:userinfo.getuserid() ) limit 1];
        if(lstofuser.size()>0) {
            IsUpdateStatus=true;
        }
           
        list<PermissionSetAssignment>PermissonS=[select Assignee.Name, PermissionSet.Name
                                                    from PermissionSetAssignment 
                                                    where (PermissionSet.Name='IPM_Central_Team' or 
                                                        PermissionSet.Name='IPM_Business_Partners') and Assignee.id=:userinfo.getuserid()];
        if(PermissonS.size()>0){
            IsUpdateStatus=true;
        }
        projectSections = new List<IPM_Project_Document_Section__c>();
        projectId = ApexPages.currentPage().getParameters().get('id');
        List<IPM_Task__c> tskList = [SELECT Id FROM IPM_Task__c WHERE IPM_Project__c = :projectId];
        projSectionList = tskList.size() > 0 ? tskList[0] : new IPM_Task__c();
       
       try{
            IPM_Project__c projObj = IPM_Utils.getCurrentPhase(projectId);
            currPhase = projObj.IPM_Phase__c;
            init();
        }catch(exception e) {
            system.debug(e + ' ** error : ' + e.getLineNumber());
        }
    }
    
    private void init() {
        
        projectObj = [SELECT IPM_Project_Type__c,IPM_Stopped_Date_Time__c,IPM_Stopped_Comments__c, IPM_Project_Name__c, IPM_Target_Launch_Dates__c, IPM_Complexity__c, 
                                IPM_Project_Leader__r.Name, IPM_Project_Gatekeeper__r.Name, IPM_Project_Description__c, IPM_Stopped_Phase__c,Is_Archieved__c, 
                                IPM_Project_Leader__r.SmallPhotoUrl, IPM_Project_Gatekeeper__r.SmallPhotoUrl,IPM_Brand__c,IPM_Stopped_By__c,IPM_Phase__c,
                                IPM_Stopped_By__r.Name,IPM_UserCategory__c, IPM_Sub_Category__c, IPM_FilledIn_Percentage__c,IPM_Category_Text__c,IPMProject_Span__c,
                            (SELECT IPM_Task_Name__c, IPM_Due_Date1__c, IPM_Task_Type__c, IPM_Project_Document_Section__r.IPM_Section_Sequence__c,
                                    IPM_Project_Document_Section__r.IPM_Section_Name__c, IPM_Completed__c, IPM_Completed_Date__c,IPM_Project_Document_Section__c,
                                    IPM_Project__c
                                    FROM Tasks__r 
                                WHERE IPM_Completed__c = false AND IPM_Assignee__c = :UserInfo.getUserId() AND IPM_Phase__c = :currPhase
                                ORDER BY IPM_Due_Date1__c),
                            (SELECT IPM_Project_Template__r.IPM_Template_Complexity__c,LastModifiedBy.Name,IPM_GateDocuments__c,
                                    IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,
                                    LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c
                                From Project_Documents__r),
                            (SELECT IPM_Phase__c, IPM_Type_of_gate__c,IPM_Due_Date__c FROM IPM_Milestones__r
                                WHERE IPM_Phase__c = :currPhase LIMIT 1)
                        FROM IPM_Project__c 
                        WHERE Id =:projectId];
        stoppedDate= projectObj.IPM_Stopped_Date_Time__c != null ? projectObj.IPM_Stopped_Date_Time__c.Date() : null;// get the stopped date ipm ProjectCancel Page
        milesTone = projectObj != null && projectObj.IPM_Milestones__r != null ? projectObj.IPM_Milestones__r : new IPM_Milestone__c();
        for(IPM_Project_Document__c eachDoc : projectObj.Project_Documents__r) {
            if(IPM_Utils.phaseGateDocumentMap.containsKey(currPhase)) {
                currGate = IPM_Utils.phaseGateDocumentMap.get(currPhase);
                if(eachDoc.IPM_Document_Status__c != IPM_ConstantUtils.STATUS_APPROVED) {
                    unApprovedCurrGate = IPM_Utils.phaseGateDocumentMap.get(currPhase);
                }
                projectDoc = eachDoc;
            }
        }
        
        list<IPM_Task__c> tasksList = projectObj.Tasks__r;
        allIncompleteTasks = tasksList.size();
        if(milesTone != null && 
                        milesTone.IPM_Due_Date__c != null) {
            remainingDays = system.today().daysBetween(milesTone.IPM_Due_Date__c);
        } 
        if(remainingDays > 0) {
            gateDateAlert = milesTone.IPM_Type_of_gate__c + ' approval is due in ' + remainingDays + ' day(s)';
        }else if(remainingDays < 0) {
            gateDateAlert = 'You have missed your ' + milesTone.IPM_Type_of_gate__c + ' approval on ' + math.abs(remainingDays) + ' day(s) ago';
        }else if(remainingDays == 0) {
            gateDateAlert = 'Your '  + milesTone.IPM_Type_of_gate__c + ' approval is due Today!';
        }
        
       // if(IPM_ConstantUtils.PD_STATUS_STOPPED.equals(projectObj.IPM_Phase__c)) {
        if(projectObj.Is_Archieved__c==true) {
            stoppedMsg = 'This project is stopped by ' + projectObj.IPM_Stopped_By__r.Name + ' at ';
            stoppedMsg += projectObj.IPM_Stopped_Date_Time__c.Date() + ' during ' + projectObj.IPM_Phase__c + ' phase.';
        }
        List<IPM_Project_Document_Section__c> projectSectionsList = new List<IPM_Project_Document_Section__c>();
        
        if(projectObj.IPM_Project_Leader__c != UserInfo.getUserId()) {
            projectSectionsList = [SELECT IPM_Section_Name__c, IPM_Section_Sequence__c, IPM_Section_Status__c,
                                                                                IPM_Project_Document__r.IPM_Project__c
                                                                        FROM IPM_Project_Document_Section__c
                                                                        WHERE IPM_Project_Document__r.IPM_Project__c = :projectId AND 
                                                                                IPM_Section_Status__c != :IPM_ConstantUtils.STATUS_EXCLUDED AND
                                                                                IPM_Project_Document__r.IPM_GateDocuments__c = :currGate AND
                                                                                IPM_FunctionalRole__c = :IPM_Utils.userRole()
                                                                        ORDER BY IPM_Section_Sequence__c];
        } else {
            projectSectionsList = [SELECT IPM_Section_Name__c, IPM_Section_Sequence__c, IPM_Section_Status__c,
                                                                                IPM_Project_Document__r.IPM_Project__c
                                                                        FROM IPM_Project_Document_Section__c
                                                                        WHERE IPM_Project_Document__r.IPM_Project__c = :projectId AND 
                                                                                IPM_Section_Status__c != :IPM_ConstantUtils.STATUS_EXCLUDED AND
                                                                                IPM_Project_Document__r.IPM_GateDocuments__c = :currGate
                                                                        ORDER BY IPM_Section_Sequence__c];
        }
        
        for(IPM_Project_Document_Section__c eachProSection : projectSectionsList) {
            if(eachProSection.IPM_Section_Status__c == IPM_ConstantUtils.STATUS_NOT_FILLED && (!eachProSection.IPM_Section_Sequence__c.startsWith('8.'))) {
                projectSections.add(eachProSection);
            }
        }
        for(IPM_Project_Document_Section__c eachProSection : projectSectionsList) {
            if(eachProSection.IPM_Section_Status__c == IPM_ConstantUtils.STATUS_NOT_STARTED && (!eachProSection.IPM_Section_Sequence__c.startsWith('8.'))) {
                projectSections.add(eachProSection);
            }
        }
        loadObjectHistory();
    }
    
    private Map<String, IPM_Task__c> getTaskDetail(Set<String> tasksId) {
        
        Map<String, IPM_Task__c> mapToReturn = new Map<String, IPM_Task__c>();
        list<IPM_Task__c> lst = [SELECT IPM_Task_Name__c FROM IPM_Task__c WHERE Id IN :tasksId];
        for(IPM_Task__c eachRec : lst) {
            mapToReturn.put(eachRec.Id, eachRec);
        }
        return mapToReturn;
    }
    
    private Map<String, IPM_Project_Document_Section__c> getPSDetail(Set<String> psId) {
        
        Map<String, IPM_Project_Document_Section__c> mapToReturn = new Map<String, IPM_Project_Document_Section__c>();
        list<IPM_Project_Document_Section__c> lst = [SELECT IPM_Project_Section__c FROM IPM_Project_Document_Section__c WHERE Id IN :psId];
        for(IPM_Project_Document_Section__c eachRec : lst) {
            mapToReturn.put(eachRec.Id, eachRec);
        }
        return mapToReturn;
    }
    
    private Map<String, IPM_Project_Document__c> getPDDetail(Set<String> pdId) {
        
        Map<String, IPM_Project_Document__c> mapToReturn = new Map<String, IPM_Project_Document__c>();
        list<IPM_Project_Document__c> lst = [SELECT IPM_GateDocuments__c FROM IPM_Project_Document__c WHERE Id IN :pdId];
        for(IPM_Project_Document__c eachRec : lst) {
            mapToReturn.put(eachRec.Id, eachRec);
        }
        return mapToReturn;
    }
    
    private Map<String, User> getUserDetails(Set<String> usId) {
        
        Map<String, User> mapToReturn = new Map<String, User>();
        list<User> lst = [SELECT Name, SmallPhotoUrl FROM User WHERE Id IN :usId];
        for(User eachRec : lst) {
            mapToReturn.put(eachRec.Id, eachRec);
        }
        return mapToReturn;
    }
    
    public void loadObjectHistory() {
        
        activityHistory = new List<objectHistoryWrapper>();
        list<sObject> objectHistoryRecords = new list<sObject>();
        Map<String, sObject> objectHistoryRecordsMap = new Map<String, sObject>();
        Set<String> tasksIds = new Set<String>();
        Set<String> psIds = new Set<String>();
        Set<String> pdIds = new Set<String>();
        Set<String> usrIds = new Set<String>();
        for(String eachObject : objectFldMap.keySet()) {
            objectHistoryRecords.addAll(getHistoryRecords(eachObject, objectFldMap.get(eachObject), objectAddtnlFldsMap.get(eachObject)));
        }
        system.debug('** objectHistoryRecords : ' + objectHistoryRecords);
        for(sObject eachObjHistory : objectHistoryRecords) {
            String parentId = String.valueOf(eachObjHistory.get('ParentId'));
            if(parentId.startsWith(Label.TASK_OBJ_NAME)) {
                tasksIds.add(String.valueOf( eachObjHistory.get('ParentId') ));
            } else if(parentId.startsWith(Label.PS_OBJ_NAME)) {
                psIds.add(String.valueOf( eachObjHistory.get('ParentId') ));
            } else if(parentId.startsWith(Label.PD_OBJ_NAME)) {
                pdIds.add(String.valueOf(eachObjHistory.get('ParentId')));
            }
            if(String.valueOf(eachObjHistory.get('OldValue')) != null && String.valueOf(eachObjHistory.get('OldValue')).startsWith('005')) {
                usrIds.add(String.valueOf( eachObjHistory.get('OldValue')));
            }
            if(String.valueOf(eachObjHistory.get('NewValue')) != null && String.valueOf(eachObjHistory.get('NewValue')).startsWith('005')) {
                usrIds.add(String.valueOf( eachObjHistory.get('OldValue')));
            }
            usrIds.add(String.valueOf( eachObjHistory.get('CreatedById')));
        }
        
        Map<String, IPM_Task__c> taskDetailsMap = getTaskDetail(tasksIds);
        Map<String, IPM_Project_Document_Section__c> projectSectionMap = getPSDetail(psIds);
        Map<String, IPM_Project_Document__c> projectDocumentMap = getPDDetail(pdIds);
        List<IPM_Project__Feed> projectFeed = [SELECT Body,ParentId,CreatedDate,CreatedById FROM IPM_Project__Feed WHERE ParentId = :projectId];
        for(IPM_Project__Feed eachObjHistory : projectFeed) {
            usrIds.add(String.valueOf(eachObjHistory.get('CreatedById')));
        }
        Map<String, User> userDetailMap = getUserDetails(usrIds);
        for(IPM_Project__Feed eachObjHistory : projectFeed) {
            objectHistoryWrapper objWrap = new objectHistoryWrapper();
            DateTime dT = eachObjHistory.CreatedDate;
            Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            objWrap.theDate = String.valueOf(myDate);
            system.debug('** eachObjHistory.createdById : ' + eachObjHistory.createdById);
            objWrap.user = userDetailMap.get(eachObjHistory.createdById).Name;
            objWrap.recordLink = eachObjHistory.ParentId;
            objWrap.whoImage = userDetailMap.get(eachObjHistory.createdById).SmallPhotoUrl;
            objWrap.actionType = 'Chatter';
            objWrap.action = eachObjHistory.Body;
            activityHistory.add(objWrap);
        }
        system.debug('** activityHistory : ' + activityHistory);
        for(sObject eachObjHistory : objectHistoryRecords) {
            if(!objectHistoryRecordsMap.containsKey(String.valueOf( eachObjHistory.get('CreatedDate') ))) {
                objectHistoryWrapper objWrap = new objectHistoryWrapper();
                objWrap.theDate = String.valueOf( eachObjHistory.get('CreatedDate') );
                objWrap.user = userDetailMap.get(String.valueOf( eachObjHistory.get('CreatedById') )).Name;
                objWrap.recordLink = String.valueOf( eachObjHistory.get('ParentId') ) != null ? String.valueOf( eachObjHistory.get('ParentId') ) : '';
                objWrap.fromValue = String.valueOf( eachObjHistory.get('OldValue') ) != null ? String.valueOf( eachObjHistory.get('OldValue') ) : '';
                objWrap.toValue = String.valueOf( eachObjHistory.get('NewValue') ) != null ? String.valueOf( eachObjHistory.get('NewValue') ) : '';
                objWrap.whoImage = userDetailMap.get(String.valueOf(eachObjHistory.get('CreatedById'))).SmallPhotoUrl;
                objWrap.actionType = 'Change';
                String frm = String.valueOf( eachObjHistory.get('NewValue'));
                String to = String.valueOf( eachObjHistory.get('OldValue'));
                if(String.valueOf(eachObjHistory.get('Field')) == 'IPM_Completed__c' 
                         && String.valueOf(eachObjHistory.get('NewValue')) == 'true') { // when a task is completed
                    objWrap.actionType = 'Complete';
                    objWrap.action = ' has completed the task ' + taskDetailsMap.get(String.valueOf(eachObjHistory.get('ParentId'))).IPM_Task_Name__c;
                }else {
                    objWrap.actionType = 'Change';
                    if(String.valueOf(eachObjHistory.get('ParentId')).startsWith(Label.PS_OBJ_NAME)) { // when a section is changed
                        objWrap.action = ' has changed the field ' + String.valueOf(eachObjHistory.get('Field')) + ' for the section ';
                        objWrap.action +=  projectSectionMap.get(String.valueOf(eachObjHistory.get('ParentId'))).IPM_Project_Section__c;
                    } else if(String.valueOf(eachObjHistory.get('ParentId')).startsWith(Label.PD_OBJ_NAME)) { // when a Project document
                        objWrap.action = ' has changed the field ' + String.valueOf(eachObjHistory.get('Field')) + ' for the Gate Document ';
                        objWrap.action +=  projectDocumentMap.get(String.valueOf(eachObjHistory.get('ParentId'))).IPM_GateDocuments__c;
                    } else if(String.valueOf(eachObjHistory.get('ParentId')).startsWith(Label.TASK_OBJ_NAME)) { // when a task is changed
                        if(String.valueOf(eachObjHistory.get('Field')) == 'IPM_Assignee__c' ) {
                            objWrap.actionType = 'Owner';
                            objWrap.action = ' has changed the owner for the task ';
                            objWrap.action +=  taskDetailsMap.get(String.valueOf(eachObjHistory.get('ParentId'))).IPM_Task_Name__c;
                            objWrap.action +=  ' from ' + frm + ' to ' + to;
                        } else {
                            objWrap.action = ' has changed the field ' + String.valueOf(eachObjHistory.get('Field')) + ' for the task ';
                            objWrap.action +=  taskDetailsMap.get(String.valueOf(eachObjHistory.get('ParentId'))).IPM_Task_Name__c;
                            
                        }
                    }
                    objWrap.action +=  ' from ' + frm + ' to ' + to;
                    objectHistoryRecordsMap.put(String.valueOf(eachObjHistory.get('CreatedDate')), eachObjHistory);
                }
                objWrap.action +=  ' on ' + String.valueOf(eachObjHistory.get('CreatedDate'));
                activityHistory.add(objWrap);
            }
        }
    }
    
    private list<sObject> getHistoryRecords(String objectNameHistory, String flds, String addtionalFlds) {
        
        String sQuery  = 'SELECT ParentId, OldValue, NewValue, Field, CreatedById, CreatedDate';
               sQuery = addtionalFlds != null ? sQuery + ',' + addtionalFlds : sQuery;
               sQuery += ' FROM ' + objectNameHistory + ' WHERE Field IN '+ IPM_Utils.convertStrToSoqlList(flds) + ' ORDER BY CreatedDate DESC LIMIT 100';
        system.debug('** sQuery : ' + sQuery);
        return Database.query(sQuery);
    }
    
    public void markComplete() {
        
        IPM_Task__c tObj = [SELECT IPM_Completed__c, IPM_Completed_Date__c FROM IPM_Task__c WHERE Id =:taskId];
        tObj.IPM_Completed__c = isChecked == 'true' ? true : false; 
        tObj.IPM_Completed_Date__c = isChecked == 'true' ? system.today() : null;
        update tObj;
        init();
    }
    
    // Inner Class to store the detail of the object history lines 

    public class objectHistoryWrapper {
        
        public String theDate {get; set;}
        public String who {get; set;}
        public String user {get; set;} 
        public String action {get; set;}
        public String whoImage{get; set;}
        public String recordLink{get;set;}
        public String actionType{get; set;}
        public String fromValue {get; set;}
        public String toValue {get;set;}
    }

}