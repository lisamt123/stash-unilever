public with sharing  class SAJ_SessionNotesCTRL {

    public Design_Challenge__c designChallenge {get;set;}
    
    public Task newTask {get;set;}
    
   
    
    public Map<Id, Task> tasks {get{
        if(tasks == null){
            tasks = new Map<Id, Task>();
            tasks = new Map<Id, Task>([select id, Owner.Name, OwnerId, Subject, ActivityDate, Priority, isClosed from task where whatId = :designChallenge.Id order by isHighPriority ASC, createdDate ASC ]);
        }
        return tasks;
    }set;}
    
    public string string2HTML(blob b){
        string tempString = b.toString();
        
        String retString = tempString.replaceAll('\n','<br/>');
        retString = retString.replaceAll('\r','<br/>');
        retString = retString.replaceAll('\t','&Tab;');
        
        return '<pre>'+retString+'</pre>';
        
    }
    
    public pageReference saveNotes(){
        update designChallenge;
        return null;
    }
    
    public pageReference copyGuidance2Notes(){
        //if(designChallenge.Notes__c == null){
            designChallenge.Notes__c = guidance;
       // }
        return null;
    }
    
     public string guidance{get{
         if(guidance == null){
             guidance = '';
             try{
                 ContentVersion v = [select id, versionData, contentDocumentId from ContentVersion where Title = 'Design_Checklist_Salesforce_Platform.pdf' and isLatest = true LIMIT 1];
                 Blob b = v.versionData;
                 guidance=string2HTML(b);
             }catch(exception e){
                 guidance = 'No Guidance Avaliable';
             }
        }
        return guidance;
    }set;}
    
    public pageReference AddDecision(){
        
        DesignDecisions.add(new Design_Decision__c(Design_Challenge__c = designChallenge.Id, Business_solution__c = designChallenge.Business_Solution__c));
        decisions = null;
        
        return null;
    }
    
    public pageReference SaveDecisions(){
        upsert DesignDecisions;
        DesignDecisions = null;
        decisions = null;
        
        
        return null;
    }
    
    public List<ddWrap> decisions {get{
        System.debug('decisons get: ' + decisions);
        if(decisions == null){
            decisions = new List<ddWrap>();
            for(Design_Decision__c d : DesignDecisions){
                ddWrap tempWrap = new ddWrap(d);
                tempWrap.rowNum = decisions.size();
                decisions.add(tempWrap);
            }
        }
         System.debug('before return: ' + decisions);
        return decisions;
    }set;}
    
    public integer designDecisionRowNum {get;set;}
    
    public pageReference delDesignDecision(){
        // designDecisionRowNum
        
        ddWrap delItem = decisions.get(designDecisionRowNum);
        if(delItem.dd.Id!=null){
            delete delitem.dd;
        }
        DesignDecisions.remove(designDecisionRowNum);
        
        decisions = null;
        
        return null;    
    }
    
    public class ddWrap{
        public integer rowNum {get;set;}
        public boolean isChecked {get;set;}
        public Design_Decision__c dd {get;set;}
        
        public ddWrap(Design_Decision__c d){
            dd = d;
            isChecked = false;
        }
    }
    
    public List<Design_Decision__c> DesignDecisions {get{
        if(DesignDecisions == null){
            DesignDecisions = [select id, name, requirement__c, Design_Challenge__c, Options__c, Decision__c, is_Technical_Debt__c from Design_Decision__c where Design_Challenge__c = :designChallenge.Id];
        }
        return DesignDecisions;
    }set;}
    
    public List<taskWrap> openTasklist {get{
        if(openTasklist == null){
            openTasklist = new List<taskWrap>();
            integer cnt = 0;
            for(Task t : tasks.values()){
                if(!t.IsClosed){
                    openTasklist.add(new taskWrap(t, cnt));
                    cnt++;
                }
                
            }
        }
        return openTasklist;
    }set;}
    
     public List<taskWrap> closedTasklist {get{
        if(closedTasklist == null){
            closedTasklist = new List<taskWrap>();
            integer cnt = 0;
            for(Task t : tasks.values()){
                if(t.IsClosed){
                    closedTasklist.add(new taskWrap(t, cnt));
                    cnt++;
                }
            }
        }
        return closedTasklist;
    }set;}
    
    public Id toggleTask {get;set;}
    public Id delTaskId {get;set;}
    
    public pageReference removeTask(){
        Task delTask = tasks.get(delTaskId);
        
        delete delTask;
        
        rerenderTaskLists();
        
        return null;
    }
    
    public pageReference toggleStatus(){
        system.debug(toggleTask);
        
        if(toggleTask==null){
            return null;
        }
        
        task t = tasks.get(toggleTask);
        
        if(t.isClosed){
            t.Status = 'In Progress';
        }else{
            t.Status = 'Completed';
        }
        
        update t;
        
        rerenderTaskLists();
        
        
        return null;    
    }
    
    public void rerenderTaskLists(){
        tasks = null;
        closedTasklist = null;
        openTasklist = null;
    }
        
    public pageReference createTask(){
        insert newTask;
        
        newTask = generateNewTask();
        
        rerenderTaskLists();
        
        return null;
    }
    
    public task generateNewTask(){

        
        return new Task(Business_Solution__c = designChallenge.Business_Solution__c, 
                        WhatId = designChallenge.Id, Priority = 'Normal', ownerId=userinfo.getUserId());
    }
    
    public SAJ_SessionNotesCTRL(Apexpages.StandardController stdCtrl){
        designChallenge = (Design_Challenge__c)stdCtrl.getRecord();
        newTask = generateNewTask();
    }
    
    public class taskWrap{
        
        public boolean isChecked {get;set;}
        public integer pos {get;set;}
        public Task task {get;set;}
        public taskWrap(Task t, integer p){
            task = t;
            pos = p;
            isChecked = t.IsClosed;
        }
    }    
    
    
}