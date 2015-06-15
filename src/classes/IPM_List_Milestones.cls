/*
 
Version 1.0 : To show the generated Regional Rollouts  
Date: 4/12/14
Changelog :  [Irfan Khan] Initial constructor
*/ 
public with sharing class IPM_List_Milestones {
    
    public String isChecked{get;set;}
    public String MileStoneAlerts{get;set;}
    public String projectId{get;set;}
    public Integer milestoneCnt{get;set;}
    public Boolean isAsc{get;set;}
    public Map<String, String> currentSort{get;set;}
    public Boolean isEditable{get;set;}
    public Boolean isBDuser{get;set;}
    public Boolean isSDateEdit{get;set;}
    private List<String> phaseOrder = new List<String>{'Ideas', 'Feasibility', 'Capability', 'Market Ready', 'Market Deployment', 'PLE'};
    private Map<String, Integer> phaseOrderMap = new Map<String, Integer>{'Ideas' => 1, 
                                                                           'Feasibility' => 2,
                                                                           'Capability' => 3,
                                                                           'Market Ready' => 4,
                                                                           'Market Deployment' => 5, 
                                                                           'PLE' => 6};
    private String projectPhase;
    private String milestoneId = '';
    public void setMilestoneId(String n) {
        milestoneId = n;
    }
    public List<MilestoneWrapper> projectMilestones{get;set;}
    public List<TimelineWrap> timelineMilestones{get;set;}
    public String getMilestoneId() {
        return milestoneId;
    }
    
    private String phaseM = '';
    public void setphaseM(String n) {
        phaseM = n;
    }
    public String getphaseM() {
        return phaseM;
    }
    
    public String[] phaseMsList{get;set;}
    public String isCompleteMilestones{get;set;}
    
    public IPM_List_Milestones() {
        
        milestoneCnt = 0;
        phaseMsList = new List<String>();
        isAsc = false;
        currentSort = new Map<String, String>{'thisFld' => 'IPM_Due_Date__c'};
        Set<String> phaseMsSet = new Set<String>();
        projectId = ApexPages.currentPage().getParameters().get('id');
        if(projectId =='' || projectId ==null){
         projectId = ApexPages.currentPage().getParameters().get('Pid');
        }
        IPM_Project__c projectObj = [SELECT IPM_Phase__c FROM IPM_Project__c WHERE Id =:projectId];
        projectPhase =  projectObj != null && projectObj.IPM_Phase__c != null ? projectObj.IPM_Phase__c : '';
        projectMilestones = new List<MilestoneWrapper>();
        for(IPM_Milestone__c eachMilestone : loadMilestones()) {
            milestoneCnt++;
            phaseMsSet.add(eachMilestone.IPM_phase__c);
            if(eachMilestone.IPM_Completed__c) {
                projectMilestones.add(new MilestoneWrapper(eachMilestone, true));
            }else {
                projectMilestones.add(new MilestoneWrapper(eachMilestone, false));
            }
        }
        phaseMsList.addAll(phaseMsSet);
        phaseMsList.sort();
        loadTimelines(loadMilestones());
    }
    
    public void toggleDueDate() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Due_Date__c');
        getProjectMilestones();
    }
    
    public void toggleSortMilestones() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Name__c');
        getProjectMilestones();
    }
    
    public void toggleSortPhases() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Phase__c');
        getProjectMilestones();
    }
    
    public void toggleSortCompletion() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Completed__c');
        getProjectMilestones();
    }
    
    public void toggleSortCompletedOn() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Completed_On__c');
        getProjectMilestones();
    }
    
    private List<IPM_Milestone__c> loadMilestones() {
        
        List<IPM_Milestone__c> milestonesToReturn = new List<IPM_Milestone__c>();
        String soql  =  'SELECT IPM_Completed__c, IPM_Name__c, IPM_Due_Date__c, IPM_Completed_On__c, IPM_phase__c, IPM_Milestone__c';
               soql += ' FROM IPM_Milestone__c ';
               soql += 'WHERE IPM_Project__c = \'' + projectId + '\'';
        if(phaseM != '') {
            soql += ' AND IPM_phase__c IN ' + IPM_Utils.convertStrToSoqlList(phaseM);
        } 
        if(isCompleteMilestones == 't') {
            soql += ' AND IPM_Completed__c = true';
        }
        if(isCompleteMilestones == 'f') {
            soql += ' AND IPM_Completed__c = false';
        }
        soql += ' AND recordtypeId=\'' + IPM_Utils.getMilestoneRecordType('IPM Project Milestones') + '\'';
        if(isAsc) {
            soql += ' ORDER BY ' + currentSort.get('thisFld') + ' DESC NULLS LAST';
        } else {
            soql += ' ORDER BY ' + currentSort.get('thisFld') + ' ASC NULLS LAST';
        }
        system.debug('** soql : ' + soql);
        milestonesToReturn = Database.query(soql);
        
        return milestonesToReturn;                    
    }
    
    public void getProjectMilestones() {
        
        milestoneCnt = 0;
        projectMilestones = new List<MilestoneWrapper>();
        for(IPM_Milestone__c eachMilestone : loadMilestones()) {
             milestoneCnt++;
            if(eachMilestone.IPM_Completed__c) {
                projectMilestones.add(new MilestoneWrapper(eachMilestone, true));
            }else {
                projectMilestones.add(new MilestoneWrapper(eachMilestone, false));
            }
        }
        loadTimelines(loadMilestones());
    }
    
    public void loadTimelines(List<IPM_Milestone__c> milestones) {
        
        timelineMilestones = new List<TimelineWrap>();
        List<IPM_Milestone__c> tmpMilestonesLst;
        Integer currentPhase = 0; 
        Integer proPhase = 0;
        for(String eachPhase : phaseOrder) {
            currentPhase = phaseOrderMap.get(eachPhase);
            proPhase = phaseOrderMap.get(projectPhase);
            tmpMilestonesLst = new List<IPM_Milestone__c>();
            for(IPM_Milestone__c eachMilestone : milestones) {
                if(eachMilestone.IPM_Phase__c == eachPhase) {
                    if(eachMilestone.IPM_Completed__c) {
                        tmpMilestonesLst.add(eachMilestone);
                    }
                }
            }
            system.debug(currentPhase + ' ** tmpMilestonesLst : '+ tmpMilestonesLst);
            for(IPM_Milestone__c eachMilestone : milestones) {
                if(eachMilestone.IPM_Phase__c == eachPhase) {
                    if(!eachMilestone.IPM_Completed__c) {
                        tmpMilestonesLst.add(eachMilestone);
                    }
                }
            }
            Boolean isFtr = currentPhase > proPhase ? true : false;
            timelineMilestones.add(new TimelineWrap(eachPhase, isFtr, tmpMilestonesLst));
        }
    }
    
    public void filteredphaseM() {
        
        system.debug('** phaseM : ' + phaseM);
        getProjectMilestones();
    }
    
    public void filterCompleteMilestones() {
        
        system.debug('** isCompleteMilestones : ' + isCompleteMilestones);
        getProjectMilestones();
    }
    
    public void deleteMilestone() {
        
        system.debug('** milestoneId : ' + milestoneId);
        List<IPM_Milestone__c> mObj = [SELECT Id FROM IPM_Milestone__c WHERE Id =:milestoneId];
       // delete mObj;
       // getProjectMilestones();
    }
    
    public void markCompleteM() {
        
        IPM_Milestone__c mObj = [SELECT IPM_Completed__c FROM IPM_Milestone__c WHERE Id =:milestoneId];
        mObj.IPM_Completed__c = isChecked == 'true' ? true : false; 
        mObj.IPM_Completed_On__c = isChecked == 'true' ? system.today() : null;
        update mObj;
        getProjectMilestones();
    }
    
    public class MilestoneWrapper {
        
        public Boolean isComplete{get;set;}
        public IPM_Milestone__c mObj{get;set;}
        
        public MilestoneWrapper (IPM_Milestone__c t, Boolean c) {
            isComplete = c;
            mObj = t;
        }
    }
    
    public class TimelineWrap {
        
        public String milestineStatus{get;set;}
        public Boolean isFuture{get;set;}
        public List<IPM_Milestone__c> milestoneList{get;set;}
        
        public TimelineWrap(String s, Boolean f, List<IPM_Milestone__c> mL) {
            milestineStatus = s;
            milestoneList = mL;
            isFuture = f;
        }
    }
    /*
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

    // returns the first page of records
     public void first() {
         con.first();
     }

     // returns the last page of records
     public void last() {
         con.last();
     }

     // returns the previous page of records
     public void previous() {
         con.previous();
     }

     // returns the next page of records
     public void next() {
         con.next();
     }

     // returns the PageReference of the original page, if known, or the home page.
     public void cancel() {
         con.cancel();
     }*/
}