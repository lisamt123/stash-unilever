global class IPM_CreateIPMProjectTasks {
    
    public static void addAssigneeToTasks(List<IPM_Task__c> tasks){
        
    }
    
    public static Boolean offTrigger=false;
    
    /*@future
    public static void futureCreateTasks(List<Id> projectIds){
        createIPMTasks(projectIds);
    }*/
    
    public static void createIPMTasks(Set<Id> ipmprojectIds){
    
            List<IPM_Project__c> ipmprojects=[select Id,IPM_Complexity__c,IPM_PM_Approach__c,IPM_Phase__c from IPM_Project__c where Id IN : ipmprojectIds];
        
            Id taskPRecordType=Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get('IPM Project Tasks').getRecordTypeId();
            Set<Id> projectIds=new Set<Id>();
            Set<String> ipmcomplexity=new Set<String>();
            Set<String> ipmPhase=new Set<String>();
            Set<String> ipmSetPhase=new Set<String>();
            for(IPM_Project__c projects:ipmprojects){
                System.debug('Complexity Value:'+projects.IPM_Complexity__c);
                if(!String.isEmpty(projects.IPM_Complexity__c) && projects.IPM_PM_Approach__c == 'Internal'){
                    projectIds.add(projects.Id);
                    ipmcomplexity.add(projects.IPM_Complexity__c);
                    ipmPhase.add(IPM_Utils.phaseGateDocumentMap.get(projects.IPM_Phase__c));
                    ipmSetPhase.add(projects.IPM_Phase__c);
                }
                else{
                    return;
                }
            }
            
            List<IPM_Task__c> lstupdTasks=new List<IPM_Task__c>();
            List<IPM_Task__c> lstupdateTasks=[SELECT Id,IPM_Assignee__c,ExternalField__c,IPM_Project_Template__c,IPM_Section__r.IPM_Section_Name__c,IPM_Task_Complexity__c,IPM_Task_Name__c,IPM_Task_Type__c,IPM_Type_of_Gate__c,IPM_Phase__c,IPM_Function__c,IPM_Version_Number__c,IPM_Project_Document_Section__c,Name,RecordTypeId FROM IPM_Task__c where IPM_Project__c IN : projectIds and IPM_Task_Complexity__c NOT IN :ipmcomplexity];
            if(!lstupdateTasks.isEmpty()){
            //
                    for(IPM_Task__c updTasks:lstupdateTasks){
                            IPM_Task__c tas=new IPM_Task__c(Id=updTasks.Id,IPM_Active__c=false);
                            lstupdTasks.add(tas);
                    }
            }
            
            if(!lstupdTasks.isEmpty()){
                update lstupdTasks;
                lstupdTasks.clear();
            }
            
            
            
            List<IPM_Task__c> lstupdatephaseTasks=[SELECT Id,IPM_Assignee__c,ExternalField__c,IPM_Project_Template__c,IPM_Section__r.IPM_Section_Name__c,IPM_Task_Complexity__c,IPM_Task_Name__c,IPM_Task_Type__c,IPM_Type_of_Gate__c,IPM_Phase__c,IPM_Function__c,IPM_Version_Number__c,IPM_Project_Document_Section__c,Name,RecordTypeId FROM IPM_Task__c where IPM_Project__c IN : projectIds];
            if(!lstupdatephaseTasks.isEmpty()){
                for(IPM_Task__c updphaseTasks:lstupdatephaseTasks){
                    System.debug(updphaseTasks.IPM_Phase__c);
                    for(String phaseValue:ipmSetPhase){
                        System.debug('Phase Value:'+phaseValue);
                        if(phaseValue == 'Feasibility'){
                            IPM_Task__c tas=new IPM_Task__c(Id=updphaseTasks.Id);
                            tas.IPM_Completed__c=updphaseTasks.IPM_Phase__c=='Ideas'?true:false;
                            lstupdTasks.add(tas);
                        }
                        if(phaseValue == 'Capability'){
                            IPM_Task__c tas=new IPM_Task__c(Id=updphaseTasks.Id);
                            tas.IPM_Completed__c=(updphaseTasks.IPM_Phase__c=='Ideas' || tas.IPM_Phase__c=='Feasibility')?true:false;
                            lstupdTasks.add(tas);
                        }
                        if(phaseValue == 'Market Ready'){
                            IPM_Task__c tas=new IPM_Task__c(Id=updphaseTasks.Id);
                            tas.IPM_Completed__c=(updphaseTasks.IPM_Phase__c=='Ideas' || tas.IPM_Phase__c=='Feasibility' || tas.IPM_Phase__c=='Capability')?true:false;
                            //lstupdTasks.add(tas);
                        }
                        
                    }
                }
            }
            
            if(!lstupdTasks.isEmpty()){
                update lstupdTasks;
            }
            
            System.debug('Project Ids:'+projectIds);
            List<IPM_Project_Document__c> ipmPDocs=[select Id,IPM_Project__r.IPM_Phase__c,IPM_Project_Template__c,IPM_Project__c,IPM_Project__r.IPM_Project_Leader__c,IPM_Project__r.IPM_Complexity__c from IPM_Project_Document__c where IPM_Project__c IN:projectIds and IPM_GateDocuments__c IN : ipmPhase];
            if(ipmPDocs.isEmpty()){
                return;
            }
            List<Id> lstdocIds=new List<Id>();
            List<Id> ipmpTemplat=new List<Id>();
            for(IPM_Project_Document__c ipmpdocume:ipmPDocs){
                ipmpTemplat.add(ipmpdocume.IPM_Project_Template__c);
                lstdocIds.add(ipmpdocume.Id);
            }
            
            List<IPM_Project_Document_Section__c> lstDocSection=[Select Id,IPM_Section_Sequence__c,IPM_Section_Name__c from IPM_Project_Document_Section__c where IPM_Project_Document__c IN :lstdocIds];
            Map<String,Id> mapdocSection=new Map<String,Id>();
            for(IPM_Project_Document_Section__c dsec:lstDocSection){
                mapdocSection.put(dsec.IPM_Section_Name__c+dsec.IPM_Section_Sequence__c,dsec.Id);
            }
            
        /*    Map<id,String> mapsection=new Map<id,String>();
            List<IPM_Section__c> lstsection=[Select Id,IPM_Section_Name__c from IPM_Section__c];
            for(IPM_Section__c sec:lstsection){
                mapsection.put(sec.Id,sec.IPM_Section_Name__c);
            }*/
            
            Map<String,Id> mapPRUser=new Map<String,Id>();
            List<IPM_Project_Resource__c> ipmprojectResource=new List<IPM_Project_Resource__c>();
            Integer pResourceCount=[select count() from IPM_Project_Resource__c where IPM_Project__c IN : projectIds];
            if(pResourceCount > 1){
                ipmprojectResource=[select Id,IPM_User__c,IPM_Project__c,IPM_Role_Type__c from IPM_Project_Resource__c where IPM_Project__c IN : projectIds and IPM_Project_Role_Owner__c =true];
            }else if(pResourceCount == 1){
                ipmprojectResource=[select Id,IPM_User__c,IPM_Project__c,IPM_Role_Type__c from IPM_Project_Resource__c where IPM_Project__c IN : projectIds];
            }
            if(!ipmprojectResource.isEmpty())
            for(IPM_Project_Resource__c res:ipmprojectResource){
                mapPRUser.put(res.IPM_Project__c+res.IPM_Role_Type__c,res.IPM_User__c);
            }
            System.debug('\n USer:'+mapPRUser);
            
            List<IPM_Project_Template__c> ipmPTemplate=[select Id,IPM_Category__c,IPM_Template_Complexity__c,IPM_Project__c from IPM_Project_Template__c Where IPM_Template_Complexity__c IN : ipmcomplexity];
            if(ipmPTemplate.isEmpty()){
                ipmPTemplate=[select Id,IPM_Category__c,IPM_Template_Complexity__c,IPM_Project__c from IPM_Project_Template__c Where IPM_Template_Complexity__c = 'Default'];
            }
            
            
            
           /* if(qTasks.isEmpty()){*/
                List<IPM_Task__c> qTasks=[SELECT Id,IPM_Assignee__c,IPM_Project_Template__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Section__r.IPM_Section_Name__c,IPM_Task_Complexity__c,IPM_Task_Name__c,IPM_Task_Type__c,IPM_Type_of_Gate__c,IPM_Phase__c,IPM_Function__c,IPM_Version_Number__c,IPM_Project_Document_Section__c,Name,RecordTypeId FROM IPM_Task__c where IPM_Project_Template__c IN : ipmPTemplate];
            //}
            Map<Id,List<IPM_Task__c>> mapIpmTasks=new Map<Id,List<IPM_Task__c>>();
            System.debug('Q tasks:'+qTasks);
    
            Set<IPM_Task__c> lstTasks=new Set<IPM_Task__c>();
            for(IPM_Project_Document__c docs:ipmPDocs){
                for(IPM_Task__c tasks:qTasks){
                    System.debug('\n Phase Values:'+tasks.IPM_Phase__c + docs.IPM_Project__r.IPM_Phase__c);
                    if(tasks.IPM_Phase__c == docs.IPM_Project__r.IPM_Phase__c){
                      IPM_Task__c task=new IPM_Task__c(IPM_Task_Name__c=tasks.IPM_Task_Name__c,
                                                      IPM_Active__c=true,
                                                       IPM_Task_Type__c=tasks.IPM_Task_Type__c,
                                                      IPM_Type_of_Gate__c=tasks.IPM_Type_of_Gate__c,
                                                      IPM_Task_Complexity__c=docs.IPM_Project__r.IPM_Complexity__c,
                                                      IPM_Phase__c=tasks.IPM_Phase__c,
                                                      IPM_Function__c=tasks.IPM_Function__c,
                                                      IPM_Version_Number__c=tasks.IPM_Version_Number__c,
                                                      IPM_Section__c=tasks.IPM_Section__c,
                                                      //IPM_Project_Document_Section__c=mapdocSection.get(mapsection.get(tasks.IPM_Section__c)),
                                                      IPM_Project_Document_Section__c=mapdocSection.get(tasks.IPM_Section__r.IPM_Section_Name__c+tasks.IPM_Section__r.IPM_Section_Sequence__c),
                                                       IPM_Project__c=docs.IPM_Project__c,    
                                                       ExternalField__c=tasks.IPM_Task_Name__c+docs.IPM_Project__c,
                                                      RecordTypeId=taskPRecordType);
                    if(mapPRUser.containsKey(docs.IPM_Project__c+tasks.IPM_Function__c)){
                        task.IPM_Assignee__c=mapPRUser.get(docs.IPM_Project__c+tasks.IPM_Function__c);
                    }else if(docs.IPM_Project__r.IPM_Project_Leader__c != null){
                        task.IPM_Assignee__c=docs.IPM_Project__r.IPM_Project_Leader__c;
                    }
                    
                   /* if(docs.IPM_Project__r.IPM_Phase__c != 'Ideas'){
                        task.IPM_Completed__c =true;
                    }*/
                    
                    lstTasks.add(task);
                    }
                }
            }
            if(!lstTasks.isEmpty()){
            List<IPM_Task__c> task=new List<IPM_Task__c>();
            task.addAll(lstTasks);
                upsert task ExternalField__c;
            }
       
      /*  else if(action =='UPDATE'){
            Map<Id,String> mapprojects=new Map<Id,String>();
            for(IPM_Project__c projects:ipmprojects){
                mapprojects.put(projects.Id,projects.IPM_Complexity__c);
            }
            List<IPM_Task__c> updipmtasks=new List<IPM_Task__c>();
            List<IPM_Task__c> lstIpmTasks=[select Id,IPM_Project__c from IPM_Task__c where IPM_Project__c IN : mapprojects.keySet()];
            for(IPM_Task__c ipmtasks:lstIpmTasks){
                IPM_Task__c tasks=new IPM_Task__c(id=ipmtasks.Id,IPM_Task_Complexity__c = mapprojects.get(ipmtasks.IPM_Project__c));
                updipmtasks.add(tasks);
            }
            if(!updipmtasks.isEmpty()){
                update updipmtasks;
            }
            
        }*/
    }
}