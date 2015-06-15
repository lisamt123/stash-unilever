/* Type Name: IPM_CreateProjectDocumentSections
Developed By: Kannan and Samrat
Change History: 
Reason: To create Project Document and Project Document Sections records */
trigger IPM_CreateProjectDocumentSections on IPM_Project__c (after insert,after update) 
{
    if(IPM_UpdateChildIpmProjects.off_Trigger){
        return;
    }
    List<IPM_Project__c> projectList=new List<IPM_Project__c>();
    Set<Id> projectId=new Set<Id>();
    Set<Id> bosscardId=new Set<Id>();
    Boolean updateNew=false;
    if(trigger.isUpdate)
    {
        for(IPM_Project__c p:Trigger.New)
        {
            System.debug(Trigger.oldMap.get(p.Id).IPM_Complexity__c+'Trigger.oldMap.get(p.Id).IPM_Complexity__c'+p.IPM_Complexity__c+'p.IPM_Complexity__c');
            if((Trigger.oldMap.get(p.Id).IPM_Complexity__c==null || Trigger.oldMap.get(p.Id).IPM_Complexity__c=='') && p.IPM_Complexity__c!=null && p.IPM_Complexity__c !='' && (p.IPM_Parent_Project__c==null || p.IPM_Parent_Project__c==''))
            {
                System.debug(p.IPM_Project_Name__c+'Project Name');
                projectList.add(p);     
                projectId.add(p.Id);
                bosscardId.add(p.IPM_Bosscard__c);
                updateNew=true;
            }   
            else if((Trigger.oldMap.get(p.Id).IPM_Complexity__c!=Trigger.newMap.get(p.Id).IPM_Complexity__c) && p.IPM_Complexity__c!=null && p.IPM_Complexity__c !='' && (p.IPM_Parent_Project__c==null || p.IPM_Parent_Project__c=='') )
            {
                System.debug(p.IPM_Project_Name__c+'Project Name');
                projectList.add(p);     
                projectId.add(p.Id);
                bosscardId.add(p.IPM_Bosscard__c);
            }   
        }
        System.debug('Entering Class'+projectList+'with'+bosscardId);
        //bosscardList=[Select Id,IPM_Consumer_Need__c,IPM_Sustainibility__c,IPM_Background__c from IPM_Bosscard__c where Id In: bosscardId];
        if(projectList.size()>0)
        {
            IPM_CreateProjectDocumentSections CreateProDocSec=new IPM_CreateProjectDocumentSections();
            if(updateNew==true)
            CreateProDocSec.createSections(projectList,bosscardId);
            else
            CreateProDocSec.updateSections(projectList,bosscardId);
        }
         
    }
    /*if(trigger.isUpdate)
    {
        for(IPM_Project__c p:Trigger.New)
        {
            if(Trigger.oldMap.get(p.Id).IPM_Complexity__c != Trigger.newMap.get(p.Id).IPM_Complexity__c && (p.IPM_Complexity__c!=null && p.IPM_Complexity__c !='') && (p.IPM_Parent_Project__c==null || p.IPM_Parent_Project__c==''))
            {
                projectList.add(p);     
                projectId.add(p.Id)
            }
        }
        List<IPM_Project_Document__c> projDocList=[Select Id from IPM_Project_Document__c where IPM_Project__c In:projectId];
        delete projDocList;
        CreateProDocSec.createSections(projectList);
    }*/
    if(trigger.isInsert){
        //IPM_CreateIPMMilestones.createMileStonesTargetLaunchDate(Trigger.new);
        // IPM_CreateIPMProjectTasks.createIPMTasks(Trigger.new);
        IPM_CreateIPMProjectTasks.offTrigger=true;
        List<IPM_Project__c> localProjects=new List<IPM_Project__c>();
        Set<Id> regionalProjIds=new Set<Id>();
        Set<Id> globalProjIds=new Set<Id>();
        for(IPM_Project__c proj:trigger.new)
        {
            if(proj.IPMProject_Span__c=='Local' && proj.IPM_Phase__c=='Market Ready' && proj.IPM_GateKeeping_Model__c=='RCLT')
            {
                regionalProjIds.add(proj.IPM_Parent_Project__c);
            }
            if(proj.IPMProject_Span__c=='Local' && proj.IPM_Phase__c=='Market Ready' && proj.IPM_GateKeeping_Model__c=='GCLT & RCLT')
            {
                globalProjIds.add(proj.IPM_Parent_Project__c);
            }
        }
        if(regionalProjIds.size()>0)
            IPM_CreateProjectDocumentSections.createCountryFeedbackSections(regionalProjIds,'RCLT');
        if(globalProjIds.size()>0)
            IPM_CreateProjectDocumentSections.createCountryFeedbackSections(regionalProjIds,'GCLT & RCLT'); 
    }
    
    if(trigger.isUpdate){
        if(!IPM_CreateIPMMilestones.offtrigger){
            List<IPM_Project__c> lstprojs=new List<IPM_Project__c>();
            for(IPM_Project__c pro:Trigger.new){
                if(pro.IPM_Parent_Project__c == null){
                    lstprojs.add(pro);
                }
            }
            if(!lstprojs.isEmpty()){
                IPM_CreateIPMMilestones.createMileStonesTargetLaunchDate(lstprojs);
            }
            //CreateIPMMilestones.createMilestones(Trigger.new);
        }
        
        
        Set<Id> projectids=new Set<Id>();
        Boolean checkSpan=false;
        for(IPM_Project__c pro:Trigger.new){
        
            projectids.add(pro.Id);
            if(pro.IPMProject_Span__c != 'Global'){
                checkSpan =true;
            }
        }       
        
        if(IPM_CheckRecursive.runOnce()){
           /* Set<Id> pid=new Set<Id>();
            pid.addAll(projectids);
            IPM_CreateIPMProjectTasks.createIPMTasks(pid);*/
            IPM_CreateIPMProjectTasks.createIPMTasks(projectids);
        }
        
        /*if(!IPM_CreateIPMProjectTasks.offTrigger) {       
            IPM_CreateIPMProjectTasks.futureCreateTasks(projectids);
            IPM_CreateIPMProjectTasks.offTrigger=true;
        }
        
        if(checkSpan) {
              
        }*/
        
        
        //IPM_UpdateChildIpmProjects.updChildIPMProjects(Trigger.new,Trigger.oldMap);
    }
}