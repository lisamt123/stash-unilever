/*
*       Class Name:CoreNTImportUtility
*       Author:Mindtree
*       Date:09 May 2014
*       Description : This class contains the Utilities for Import functionality
*                     
*/
public with sharing class CoreNTImportUtility {

    /*
     *  Variables that hold the imported Values
    */
    CORE_NT_Project__c project;
    transient CORE_NT_Project__c existingProject;
    transient List<CORE_NT_Summary_Task__c> lstSummaryTask;
    transient List<CORE_NT_Task__c> lstTasks;
    transient public List<CORE_NT_Team__c> projTeamList;
    transient public Map<String,String> mapOfTaskId; 
    /*
     *  Variables that hold the Information, Warnings and Exceptions
     */ 
    public List<String> assignmentErrorList;
    public List<String> prjErrorList;
    public List<String> taskErrorList;
    public List<String> resourceErrorList;
    public List<String> infoTaskList;
    public List<String> infoResourceList;
    public List<String> warnAssignmentList; 
    transient public List<CORE_NT_Summary_Task__c> lstExistingSummTask;
    transient public List<CORE_NT_Task__c> lstExistingTask;
    transient public List<CORE_NT_Team__c> lstExistingPrjTeam;
    /*
     *  Variables that hold the values parsed from the XML
    */ 
    transient String name = '';
    transient String kickOffDate = '';
    transient String deadLine = '';   
    transient String milestone = '';
    transient String summary = '';
    transient String firstName='';
    transient String email='';
    transient String lastName='';
    transient String grp='';
    transient String resourceUid = '';
    transient String taskUid = '';
    transient String percentComplete='';
    transient String startDate = '';
    transient String dueDate = '';
    transient String critical = '';
    Map<String, String> mapResourceToTask = new Map<String,String>();  
        
    public CoreNTImportUtility() {
        System.debug(' Class : ImportProjectUtility || Method : constructor || Started ');
        project = new CORE_NT_Project__c();
        lstSummaryTask = new List < CORE_NT_Summary_Task__c > ();
        lstTasks = new List < CORE_NT_Task__c > ();
        projTeamList = new List < CORE_NT_Team__c > ();
        assignmentErrorList = new List < String > ();
        prjErrorList = new List < String > ();
        taskErrorList = new List < String > ();
        resourceErrorList = new List < String > ();
        infoTaskList = new List < String > ();
        infoResourceList = new List < String > ();
        warnAssignmentList = new List < String > ();
        mapOfTaskId = new Map < String, String > ();
        System.debug(' Class : ImportProjectUtility || Method : constructor || Completed ');
    }

    
    transient String mppUid = '';
    transient String taskName = '';
    transient String percentWorkComplete = '';
    transient String predUid = '';
    transient Integer predCount = 0;
    transient String ns = '';
    
    /**
     *       This method is used to import and parse the given MPP XML.
     *
     *       @param blob xml
     *       @return CORE_NT_Project__c
     *       @throws exception-XMLException
     */
    public CORE_NT_Project__c importProject(blob xml) {
        System.debug(' Class : ImportProjectUtility || Method : importProject || Started ');
        String loggedInUser = Userinfo.getUserId();
        String loggedInUserName = Userinfo.getUserEmail();
        // System.debug('loggedInUser '+loggedInUser);
        transient DOM.Document doc = new DOM.Document();
        transient Integer count = 1;
        try {
            doc.load(xml.toString());
            xml = null;
            transient DOM.XMLNode root = doc.getRootElement();
            doc = null;
            ns = CoreNTConstants.XML_NAMESPACE;

            /*Parse Project starts here*/
            if (root.getChildElement(CoreNTConstants.PROJECT_TITLE_TAG, ns) == null)
                throw new CoreNTException(CoreNTException.ERROR_PROJECT_NAME_BLANK);
            project.Name = root.getChildElement(CoreNTConstants.PROJECT_TITLE_TAG, ns).getText();
            if (project.Name == null || project.Name == '')
                throw new CoreNTException(CoreNTException.ERROR_PROJECT_NAME_BLANK);

            /* If the Project Is Existing in Network Tracking System then, 
            get all the Resources of that Project and validate whether the logged in User is among the resource list.*/

            transient List < CORE_NT_Project__c > projectLst = new List < CORE_NT_Project__c > ();
            transient List < CORE_NT_Team__c > prjTeamLst = new List < CORE_NT_Team__c > ();
            Boolean validUser = true;
            Boolean validateProject = false;
            if (project.Name != null)
                projectLst = [Select id, name from CORE_NT_Project__c where Name = : project.Name Limit 1];
            // Implementing L2 mgr signoff    
           /* if(projectLst[0].name!=null){
                projectLst[0].SignOff__c=true;
                upsert projectLst[0];
            }*/
            if (!projectLst.isEmpty())
                prjTeamLst = [Select id, name, TeamMemberName__r.id, Role__c from CORE_NT_Team__c where Project__r.id = : projectLst[0].Id];

            if (!prjTeamLst.isEmpty())
                for (CORE_NT_Team__c prjTeamMember: prjTeamLst) {
                    if (prjTeamMember.Role__c == CoreNTConstants.ROLE_PROJECT_MANAGER && prjTeamMember.TeamMemberName__r.id == loggedInUser) {
                        validUser = true;                       
                        break;
                    } else
                        validUser = false;
                }
            
            if (!validUser)
                throw new CoreNTException(CoreNTException.ERROR_INVALID_USER);

            /*Parse Resources -- First get all the Resources and validate whether the logged in User
                                 is among the resource list.*/
            Boolean isValid = false;
            for (Dom.XMLNode child: root.getChildElement(CoreNTConstants.RESOURCES_TAG, ns).getChildElements()) {
                transient CORE_NT_Team__c projTeamObj = new CORE_NT_Team__c();
                projTeamObj.Name = project.Name;
                projTeamObj.Resource_UID__c = child.getChildElement(CoreNTConstants.UID_TAG, ns).getText();
                if (projTeamObj.Resource_UID__c == '' || projTeamObj.Resource_UID__c == '0')
                    continue;
                if (child.getChildElement(CoreNTConstants.NAME_TAG, ns) == null)
                    continue;
                else
                    firstName = child.getChildElement(CoreNTConstants.NAME_TAG, ns).getText();
                if (child.getChildElement(CoreNTConstants.INITIALS_TAG, ns) != null)
                    lastName = child.getChildElement(CoreNTConstants.INITIALS_TAG, ns).getText();

                if (child.getChildElement(CoreNTConstants.GROUP_TAG, ns) == null)
                    resourceErrorList.add(CoreNTConstants.ERROR_MSG_GROUP_BLANK + firstName + ' ' + lastName);
                else {
                    grp = child.getChildElement(CoreNTConstants.GROUP_TAG, ns).getText();
                    if (grp == null || grp == '')
                        resourceErrorList.add(CoreNTConstants.ERROR_MSG_GROUP_BLANK + firstName + ' ' + lastName);
                }
                if (grp == 'NO' || grp == 'PM')
                    projTeamObj.Role__c = CoreNTConstants.ROLE_PROJECT_MANAGER;
                if (grp == 'TP')
                    projTeamObj.Role__c = CoreNTConstants.ROLE_TASK_PERFORMER;
                if (grp == 'SL')
                    projTeamObj.Role__c = CoreNTConstants.ROLE_SENIOR_LEADER;
                
                if(grp != 'NO' && grp != 'PM' && grp != 'TP' && grp != 'SL')
                    projTeamObj.Role__c ='';
                
                if (child.getChildElement(CoreNTConstants.EMAIL_ADDRESS_TAG, ns) == null) {
                    resourceErrorList.add(CoreNTConstants.ERROR_MSG_EMAIL_ADDRESS_BLANK + firstName + ' ' + lastName);
                    continue;
                } else {
                    email = child.getChildElement(CoreNTConstants.EMAIL_ADDRESS_TAG, ns).getText();
                    if (email == null || email == '') {
                        resourceErrorList.add(CoreNTConstants.ERROR_MSG_EMAIL_ADDRESS_BLANK + firstName + ' ' + lastName);
                        continue;
                    }
                }

                if (!isValid) {
                    if (loggedInUserName == email && grp == 'NO')
                        isValid = true;
                    else
                        isValid = false;
                }

                for (User userObj: [Select id from User where Email = : email Limit 1]) {
                    projTeamObj.TeamMemberName__c = userObj.id;
                    projTeamList.add(projTeamObj);
                }
                email = '';
                grp = '';
            } //resource for loop ends here
            if (!isValid)
                throw new CoreNTException(CoreNTException.ERROR_NOT_NETWORK_OWNER);
            if (root.getChildElement(CoreNTConstants.PROJECT_START_DATE_TAG, ns) == null)
                prjErrorList.add(CoreNTConstants.ERROR_MSG_PROJECT_START_DATE_BLANK);
            else {
                kickOffDate = root.getChildElement(CoreNTConstants.PROJECT_START_DATE_TAG, ns).getText();
                if (kickOffDate == null || kickOffDate == '')
                    prjErrorList.add(CoreNTConstants.ERROR_MSG_PROJECT_START_DATE_BLANK);
                else
                    project.Kickoff__c = Date.valueOf(kickOffDate);
            }
            if (root.getChildElement(CoreNTConstants.PROJECT_FINISH_DATE_TAG, ns) == null)
                prjErrorList.add(CoreNTConstants.ERROR_MSG_PROJECT_FINISH_DATE_BLANK);
            else {
                deadLine = root.getChildElement(CoreNTConstants.PROJECT_FINISH_DATE_TAG, ns).getText();
                if (deadLine == null || deadLine == '')
                    prjErrorList.add(CoreNTConstants.ERROR_MSG_PROJECT_FINISH_DATE_BLANK);
                else
                    project.Deadline__c = Date.valueOf(deadLine);
            }
            project.Description__c = project.Name + '\n Created on ' + Datetime.now();

          /*  if (project.Kickoff__c > project.Deadline__c) {
                prjErrorList.add('Finish Date of project cannot be before the Start Date');
                project.Kickoff__c = null;
                project.Deadline__c = null;
            }*/
            /*Task PArsing starts here*/
            if (root.getChildElement(CoreNTConstants.TASKS_TAG, ns) != null)
                for (Dom.XMLNode child: root.getChildElement(CoreNTConstants.TASKS_TAG, ns).getChildElements()) {
                    if (child.getChildElement(CoreNTConstants.UID_TAG, ns) != null)
                        mppUid = child.getChildElement(CoreNTConstants.UID_TAG, ns).getText();
                    if (mppUid == '0') {
                        if (child.getChildElement(CoreNTConstants.PERCENT_WORK_COMPLETE_TAG, ns) != null)
                            percentWorkComplete = child.getChildElement(CoreNTConstants.PERCENT_WORK_COMPLETE_TAG, ns).getText();
                        if (percentWorkComplete != '')
                            project.PercentComplete__c = Integer.valueOf(percentWorkComplete);
                        continue;
                    }
                    if (mppUid == null || mppUid == '')
                        continue;
                    if (child.getChildElement(CoreNTConstants.NAME_TAG, ns) == null)
                        continue;
                    taskName = child.getChildElement(CoreNTConstants.NAME_TAG, ns).getText();
                    if (taskName == null || taskName == '') {
                        taskErrorList.add(CoreNTConstants.ERROR_MSG_TASK_NAME_BLANK + mppUid);
                        continue;
                    }
                    if (child.getChildElement(CoreNTConstants.SUMMARY_TAG, ns) == null)
                        taskErrorList.add(CoreNTConstants.ERROR_MSG_SUMMARY_BLANK + taskName);
                    else
                        summary = child.getChildElement(CoreNTConstants.SUMMARY_TAG, ns).getText();

                    if (child.getChildElement(CoreNTConstants.CRITICAL_TAG, ns) == null)
                        taskErrorList.add(CoreNTConstants.ERROR_MSG_CRITICAL_BLANK + taskName);
                    else {
                        critical = child.getChildElement(CoreNTConstants.CRITICAL_TAG, ns).getText();
                        if (critical == '')
                            taskErrorList.add(CoreNTConstants.ERROR_MSG_CRITICAL_BLANK + taskName);
                    }
                    if (child.getChildElement(CoreNTConstants.MILESTONE_TAG, ns) == null)
                        taskErrorList.add(CoreNTConstants.ERROR_MSG_MILESTONE_BLANK + taskName);
                    else
                        milestone = child.getChildElement(CoreNTConstants.MILESTONE_TAG, ns).getText();


                    /*it is a task*/
                    if (summary == '0' && milestone == '0')
                        lstTasks.add(taskDetails(child, 0));

                    /* it is a milestone*/
                    if (summary == '0' && milestone == '1')
                        lstTasks.add(taskDetails(child, 1));

                    /*it is a summary task*/
                    if (summary == '1' && milestone == '0')
                        lstSummaryTask.add(summaryTaskDetails(child));
                } //task for loop ends here     

            for (Dom.XMLNode child: root.getChildElement(CoreNTConstants.ASSIGNMENTS_TAG, ns).getChildElements()) {
                if (child.getChildElement(CoreNTConstants.RESOURCE_UID_TAG, ns) == null)
                    assignmentErrorList.add(CoreNTConstants.ERROR_MSG_RESOURCE_UID_BLANK);
                else {
                    resourceUid = child.getChildElement(CoreNTConstants.RESOURCE_UID_TAG, ns).getText();
                    if (resourceUid == '' || resourceUid == null)
                        assignmentErrorList.add(CoreNTConstants.ERROR_MSG_RESOURCE_UID_BLANK);
                }
                if (child.getChildElement(CoreNTConstants.TASK_UID_TAG, ns) == null)
                    assignmentErrorList.add(CoreNTConstants.ERROR_MSG_TASK_UID_BLANK);
                else {
                    taskUid = child.getChildElement(CoreNTConstants.TASK_UID_TAG, ns).getText();
                    if (taskUid == '' || taskUid == null)
                        assignmentErrorList.add(CoreNTConstants.ERROR_MSG_TASK_UID_BLANK);
                }
                if ((resourceUid != '' || resourceUid != null) && (taskUid != '' || taskUid != null)) {
                    if (!mapResourceToTask.containsKey(taskUid))
                        mapResourceToTask.put(taskUid, resourceUid);
                    else
                        infoResourceList.add(CoreNTConstants.INFO_MSG_MULTIPLE_RESOURCE_ASSIGNMENT + mapOfTaskId.get(taskUid));
                }
            }
            insertSalesforceObjects();
            System.debug(' Class : ImportProjectUtility || Method : importProject || Completed ');
            return project;
        } catch (System.XMLException e) {
            System.debug(' Exception Occured in ImportProjectUtility Method[importProject] msg[ ' + e.getMessage() + ' ]');
            return project;
        }
    }
    
    /**
     *       This Method is used to extract the Task /Milestone related details from the XML file.
     *
     *       @param Dom.XMLNode child,Integer flag
     *       @return CORE_NT_Task__c
     *       @throws exception-XMLException
     */
    private CORE_NT_Task__c taskDetails(Dom.XMLNode child, Integer flag) {
        transient CORE_NT_Task__c taskObj = new CORE_NT_Task__c();
        if (mppUid != null || mppUid != '')
            taskObj.MPP_Id__c = mppUid;
        taskObj.Name = taskName;
        if ((mppUid != null || mppUid != '') && (taskName != null || taskName != ''))
            mapOfTaskId.put(mppUid, taskName);          
        if (child.getChildElement(CoreNTConstants.OUTLINENUMBER_TAG, ns) != null)
            taskObj.Outline_Number__c = child.getChildElement(CoreNTConstants.OUTLINENUMBER_TAG, ns).getText();

        if (child.getChildElement(CoreNTConstants.PERCENTCOMPLETE_TAG, ns) != null)
            percentComplete = child.getChildElement(CoreNTConstants.PERCENTCOMPLETE_TAG, ns).getText();
        if (percentComplete == '' || percentComplete == null)
            taskErrorList.add(CoreNTConstants.ERROR_MSG_PERCENT_COMPLETE_BLANK + taskObj.Name + '.');
        if (percentComplete == '100') {
            taskObj.Task_Completed_MPP__c = true;
            taskObj.Complete__c = true;
        } else{
            if (flag == 0)
                taskObj.Task_Completed_MPP__c = false;
        }

        if (child.getChildElement(CoreNTConstants.TASK_START_DATE_TAG, ns) == null)
            taskErrorList.add(CoreNTConstants.ERROR_MSG_TASK_START_DATE_BLANK + taskName);
        else {
            startDate = child.getChildElement(CoreNTConstants.TASK_START_DATE_TAG, ns).getText();
            if (startDate == null || startDate == '')
                taskErrorList.add(CoreNTConstants.ERROR_MSG_TASK_START_DATE_BLANK + taskName);
            else
                taskObj.Start_Date__c = Date.valueOf(startDate);
        }

        if (child.getChildElement(CoreNTConstants.TASK_FINISH_DATE_TAG, ns) == null)
            taskErrorList.add(CoreNTConstants.ERROR_MSG_TASK_FINISH_DATE_BLANK + taskName);
        else {
            dueDate = child.getChildElement(CoreNTConstants.TASK_FINISH_DATE_TAG, ns).getText();
            if (dueDate == null || dueDate == '')
                taskErrorList.add(CoreNTConstants.ERROR_MSG_TASK_FINISH_DATE_BLANK + taskName);
            else
                taskObj.Due_Date__c = Date.valueOf(dueDate);
        }
        if (taskObj.Start_Date__c != null && taskObj.Due_Date__c != null)
            if (taskObj.Start_Date__c > taskObj.Due_Date__c) {
                taskErrorList.add('Finish Date cannot be before Start Date of task - ' + taskName);
                taskObj.Start_Date__c = null;
                taskObj.Due_Date__c = null;
            }

        //This will only work only for Tasks. Milestones and Summary tasks are ignored.
        if (flag == 0) {
            if (child.getChildElement(CoreNTConstants.CRITICAL_TAG, ns) != null)
                critical = child.getChildElement(CoreNTConstants.CRITICAL_TAG, ns).getText();

            if (critical == '1')
                taskObj.Critical__c = true;

            DOM.XMLNode predNode = child.getChildElement(CoreNTConstants.PREDECESSOR_LINK_TAG, ns);

            if (predNode != null)
                predUid = predNode.getChildElement(CoreNTConstants.PREDECESSOR_UID_TAG, ns).getText();
            if (predUid != null || predUid != '')
                taskObj.PredecessorId__c = predUid;
            else
                taskErrorList.add(CoreNTConstants.ERROR_MSG_PREDECESSOR_UID_BLANK + taskName);
            /*for(Dom.XMLNode pred : child.getChildElements()){
                if(pred != null)
                    if(pred.getName() == CoreNTConstants.PREDECESSOR_LINK_TAG )
                        predCount++;
            }
            if(predCount > 1)
                infoTaskList.add('Task: '+taskObj.Name+' has multiple Predecessors.');*/
        } else
            taskObj.Milestone__c = true;

        return taskObj;
    }
    
    /**
     *       This Method is used to extract the Summary Task  related details.
     *
     *       @param Dom.XMLNode child
     *       @return CORE_NT_Summary_Task__c
     *       @throws exception-XMLException
     */
    private CORE_NT_Summary_Task__c summaryTaskDetails(Dom.XMLNode child) {
            transient CORE_NT_Summary_Task__c summTaskObj = new CORE_NT_Summary_Task__c();
            summTaskObj.MPP_Id__c = mppUid;
            summTaskObj.Name = taskName;
            summTaskObj.Outline_Number__c = child.getChildElement(CoreNTConstants.OUTLINENUMBER_TAG, ns).getText();
            if (child.getChildElement(CoreNTConstants.TASK_START_DATE_TAG, ns) == null)
                taskErrorList.add(CoreNTConstants.ERROR_MSG_TASK_START_DATE_BLANK + taskName);
            else {
                startDate = child.getChildElement(CoreNTConstants.TASK_START_DATE_TAG, ns).getText();
                if (startDate == null || startDate == '')
                    taskErrorList.add(CoreNTConstants.ERROR_MSG_TASK_START_DATE_BLANK + taskName);
                else
                    summTaskObj.Kickoff__c = Date.valueOf(startDate);
            }
            if (child.getChildElement(CoreNTConstants.TASK_FINISH_DATE_TAG, ns) == null)
                taskErrorList.add(CoreNTConstants.ERROR_MSG_TASK_FINISH_DATE_BLANK + taskName);
            else {
                dueDate = child.getChildElement(CoreNTConstants.TASK_FINISH_DATE_TAG, ns).getText();
                if (dueDate == null || dueDate == '')
                    taskErrorList.add(CoreNTConstants.ERROR_MSG_TASK_FINISH_DATE_BLANK + taskName);
                else
                    summTaskObj.Deadline__c = Date.valueOf(dueDate);
            }
            if (summTaskObj.Kickoff__c != null && summTaskObj.Deadline__c != null)
                if (summTaskObj.Kickoff__c > summTaskObj.Deadline__c) {
                    taskErrorList.add('Finish Date cannot be before Start Date of task - ' + taskName);
                    summTaskObj.Kickoff__c = null;
                    summTaskObj.Deadline__c = null;
                }
            return summTaskObj;
        }
        
    /**
     *       This method will insert/update Project,tasks, Summary Tasks and Project Team into Salesforce.
     *       @param None
     *       @return None
     *       @throws exception- Exception
     */
    public void insertSalesforceObjects() {
        System.debug(' Class : ImportProjectUtility || Method : insertSalesforceObjects || Started ');
        try {
            List < CORE_NT_Project__c > objProject = [Select id from CORE_NT_Project__c where Name = : project.Name Limit 1];
            if (!objProject.isEmpty()) {
                project.Id = objProject[0].id;
                lstExistingSummTask = new List < CORE_NT_Summary_Task__c > ();
                lstExistingTask = new List < CORE_NT_Task__c > ();
                lstExistingPrjTeam = new List < CORE_NT_Team__c > ();
                lstExistingSummTask = [Select id, MPP_Id__c from CORE_NT_Summary_Task__c where Project__c = : project.Id];
                lstExistingTask = [Select id, MPP_Id__c from CORE_NT_Task__c where ProjectId__c = : project.Id];
                lstExistingPrjTeam = [Select id, Resource_UID__c from CORE_NT_Team__c where Project__c = : project.Id];
                deleteTasks(lstExistingTask);
                deleteSummaryTasks(lstExistingSummTask);
                deleteProjectTeam(lstExistingPrjTeam);
            } else
                project.Baselined__c = true;
            //making lstProject list null to reduce view state limit. 
            objProject = null;
            upsert project;
            for (CORE_NT_Summary_Task__c summTask: lstSummaryTask) {
                summTask.Milestone_ExtID__c = project.Id + summTask.MPP_Id__c;
            }
            for (CORE_NT_Task__c task: lstTasks) {
                task.Task_ExtId__c = project.Id + task.MPP_Id__c;
            }

            upsert lstTasks Task_ExtId__c;
            upsert lstSummaryTask Milestone_ExtID__c;

            transient Map < String, CORE_NT_Summary_Task__c > summTaskMap = new Map < String, CORE_NT_Summary_Task__c > ();
            transient Map < String, CORE_NT_Task__c > taskMap = new Map < String, CORE_NT_Task__c > ();
            transient Map < String, CORE_NT_Team__c > projTeamMap = new Map < String, CORE_NT_Team__c > ();
            if (!lstSummaryTask.isEmpty()) {
                for (CORE_NT_Summary_Task__c summTaskObj: lstSummaryTask) {
                    summTaskObj.Project__c = project.Id;
                    summTaskMap.put(summTaskObj.Outline_Number__c, summTaskObj);
                }
                matchSummaryTaskToSummaryTask(summTaskMap);
                matchSummaryTaskToTask(summTaskMap);
                update lstSummaryTask;
            }

            if (!lstTasks.isEmpty()) {
                for (CORE_NT_Task__c taskObj: lstTasks) {
                    taskObj.ProjectId__c = project.Id;
                    taskMap.put(taskObj.MPP_Id__c, taskObj);
                }
                matchTaskToPredecessorTask(taskMap);
                update lstTasks;
            }
            for (CORE_NT_Team__c projTeamObj: projTeamList) {
                projTeamObj.Project__c = project.Id;
                String extId = project.Id + projTeamObj.Resource_UID__c;
                projTeamObj.ProjTeam_ExtId__c = extId;
                projTeamMap.put(projTeamObj.Resource_UID__c, projTeamObj);
            }
            upsert projTeamList ProjTeam_ExtId__c;
            matchResourcesToTasks(mapResourceToTask, projTeamMap);
        } catch (Exception ex) {
            throw ex;
        }
        System.debug(' Class : ImportProjectUtility || Method : insertSalesforceObjects || Completed ');
    }

    /**
     *       This will link Summary Tasks to Summary Tasks.
     *
     *       @param None
     *       @return None
     *       @throws exception- None
     */
    public void matchSummaryTaskToSummaryTask(Map < String, CORE_NT_Summary_Task__c > milestoneMap) {
        System.debug(' Class : ImportProjectUtility || Method : matchSummaryTaskToSummaryTask || Started ');
        //map consists of the outline no. as key and object as parent            
        transient CORE_NT_Summary_Task__c parentSummaryTask;
        transient String key;
        for (CORE_NT_Summary_Task__c childSummaryTask: lstSummaryTask) {
            if (childSummaryTask.Outline_Number__c.contains('.')) {
                key = childSummaryTask.Outline_Number__c.substringBeforeLast('.');
                parentSummaryTask = milestoneMap.get(key); //gives parent Summary Task Object from (Map<String,CORE_NT_Summary_Task__c> milestoneMap)
                if (parentSummaryTask != null)
                    if (childSummaryTask.Id != parentSummaryTask.Id) {
                        childSummaryTask.Parent_Milestone__c = parentSummaryTask.id; //Link the parent Summary Task to the Child Summary Task
                        parentSummaryTask.isParentSummaryTask__c = true;
                    }
            }
        }
        System.debug(' Class : ImportProjectUtility || Method : matchSummaryTaskToSummaryTask || Completed ');
    }

    /**
     *       This method will link Summary Tasks to Tasks.
     *
     *       @param None
     *       @return None
     *       @throws exception- None
     */
    public void matchSummaryTaskToTask(Map < String, CORE_NT_Summary_Task__c > milestoneMap) {
        System.debug(' Class : ImportProjectUtility || Method : matchSummaryTaskToTask || Started ');
        transient CORE_NT_Summary_Task__c parentSummaryTask;
        transient String key;
        for (CORE_NT_Task__c childTask: lstTasks) {
            if (childTask.Outline_Number__c.contains('.')) {
                key = childTask.Outline_Number__c.substringBeforeLast('.');
                parentSummaryTask = milestoneMap.get(key);
                if (parentSummaryTask != null) {
                    if (!parentSummaryTask.isParentSummaryTask__c)
                        childTask.Project_Milestone__c = parentSummaryTask.id;
                }
            }
        }
        System.debug(' Class : ImportProjectUtility || Method : matchSummaryTaskToTask || Completed ');
    }

    /**
     *       This method links Tasks to Predecessor Tasks
     *
     *       @param None
     *       @return None
     *       @throws exception- None
     */
    public void matchTaskToPredecessorTask(Map < String, CORE_NT_Task__c > parentTaskMap) {
        System.debug(' Class : ImportProjectUtility || Method : matchTaskToPredecessorTask || Started ');
        transient CORE_NT_Task__c parentTask;
        for (CORE_NT_Task__c subtask: lstTasks) {

            parentTask = parentTaskMap.get(subtask.PredecessorId__c);
            if (parentTask != null)
                if (subtask.Id != parentTask.Id)
                    subtask.Predecessor_Task__c = parentTask.Id;
        }
        System.debug(' Class : ImportProjectUtility || Method : matchTaskToPredecessorTask || Completed ');
    }

    /**
     *       This method is used for Task assignment.
     *
     *       @param None
     *       @return None
     *       @throws exception- None
     */
    public void matchResourcesToTasks(Map < String, String > resourceTaskUidMap, Map < String, CORE_NT_Team__c > prjTeamMap) {
        System.debug(' Class : ImportProjectUtility || Method : matchResourcesToTasks || Started ');
        transient String resourcekey;
        transient CORE_NT_Team__c prjTeamMember;
        for (CORE_NT_Task__c taskObj: lstTasks) {
            resourcekey = resourceTaskUidMap.get(taskObj.MPP_Id__c);
            if (resourcekey != null || resourcekey != '')
                prjTeamMember = prjTeamMap.get(resourcekey);
            if (prjTeamMember != null)
                taskObj.Assigned_To__c = prjTeamMember.TeamMemberName__c; //Assign the resource to the task
        }
        update lstTasks;
        /*Get the List of Tasks that do not have any assignments*/
        for (CORE_NT_Task__c taskObj: lstTasks) {
            if (taskObj.Assigned_To__c == null)
                warnAssignmentList.add('Resource is not assigned to Task - ' + taskObj.Name);
        }
        System.debug(' Class : ImportProjectUtility || Method : matchResourcesToTasks || Completed ');
    }

    /**
     *       This method is used to delete the tasks that are not present in the MPP xml
     *
     *       @param None
     *       @return None
     *       @throws exception- None
     */
    public void deleteTasks(List < CORE_NT_Task__c > lstExistingTask) {
        System.debug(' Class : ImportProjectUtility || Method : deleteTasks || Started ');
        transient Map < String, CORE_NT_Task__c > taskMap = new Map < String, CORE_NT_Task__c > (); //xml tasks
        transient List < CORE_NT_Task__c > deleteTaskLst = new List < CORE_NT_Task__c > ();
        //Get all the New Tasks in the Map
        for (CORE_NT_Task__c newtask: lstTasks) {
            taskMap.put(newtask.MPP_Id__c, newtask);
        }
        for (CORE_NT_Task__c existingtask: lstExistingTask) {
            CORE_NT_Task__c taskObj = taskMap.get(existingtask.MPP_Id__c);
            if (taskObj == null) {
                deleteTaskLst.add(existingtask);
            }
        }
        delete deleteTaskLst;
        System.debug(' Class : ImportProjectUtility || Method : deleteTasks || Completed ');
    }

    /**
     *       This method is used to delete the Summary tasks from SF that are not present in the xml
     *
     *       @param None
     *       @return None
     *       @throws exception- None
     */
    public void deleteSummaryTasks(List < CORE_NT_Summary_Task__c > lstExistingSummTask) {
        System.debug(' Class : ImportProjectUtility || Method : deleteSummaryTasks || Started ');
        transient Map < String, CORE_NT_Summary_Task__c > summTaskMap = new Map < String, CORE_NT_Summary_Task__c > (); //xml summary tasks
        transient List < CORE_NT_Summary_Task__c > deleteSummTaskLst = new List < CORE_NT_Summary_Task__c > ();
        for (CORE_NT_Summary_Task__c newSummtask: lstSummaryTask) {
            summTaskMap.put(newSummtask.MPP_Id__c, newSummtask);
        }
        for (CORE_NT_Summary_Task__c existingSummtask: lstExistingSummTask) {
            CORE_NT_Summary_Task__c summtaskObj = summTaskMap.get(existingSummtask.MPP_Id__c);
            if (summtaskObj == null) {
                deleteSummTaskLst.add(existingSummtask);
            }
        }
        delete deleteSummTaskLst;
        System.debug(' Class : ImportProjectUtility || Method : deleteSummaryTasks || Completed ');
    }

    /**
     *       This method is used to delete the project team members that are not present in the xml
     *
     *       @param None
     *       @return None
     *       @throws exception- None
     */
    public void deleteProjectTeam(List < CORE_NT_Team__c > lstExistingPrjTeam) {
        System.debug(' Class : ImportProjectUtility || Method : deleteProjectTeam || Started ');
        transient Map < String, CORE_NT_Team__c > prjTeamMap = new Map < String, CORE_NT_Team__c > ();
        transient List < CORE_NT_Team__c > deleteProjTeamLst = new List < CORE_NT_Team__c > ();
        for (CORE_NT_Team__c newProjTeam: projTeamList) {
            prjTeamMap.put(newProjTeam.Resource_UID__c, newProjTeam);
        }
        for (CORE_NT_Team__c existingProjTeam: lstExistingPrjTeam) {
            CORE_NT_Team__c prjTeamObj = prjTeamMap.get(existingProjTeam.Resource_UID__c);
            if (prjTeamObj == null) {
                deleteProjTeamLst.add(existingProjTeam);
            }
        }
        delete deleteProjTeamLst;
        System.debug(' Class : ImportProjectUtility || Method : deleteProjectTeam || Completed ');
    }
}