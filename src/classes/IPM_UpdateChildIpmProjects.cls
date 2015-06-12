public class IPM_UpdateChildIpmProjects{

    public Static Boolean off_Trigger =false;
    public Static void updChildIPMProjects(List<IPM_Project__c> lstipmProjects,Map<Id,IPM_Project__c> oldIpmprojects){
        Map<Id,Boolean> projectIds=new Map<Id,Boolean>();
        
        for(IPM_Project__c project:lstipmProjects){
            IPM_Project__c oldProject=oldIpmprojects.get(project.Id);
            if(oldProject.IPM_Fast_Track_Project__c != project.IPM_Fast_Track_Project__c){ 
                if (project.IPMProject_Span__c == 'Global' || project.IPMProject_Span__c == 'Regional'){
                    projectIds.put(project.Id,project.IPM_Fast_Track_Project__c);
                }
            }
        }
        
        if(!projectIds.isEmpty()){
            List<IPM_Project__c> lstprojects=[Select Id,IPM_Parent_Project__c from IPM_Project__c Where IPM_Parent_Project__c IN : projectIds.keySet()];
            List<IPM_Project__c> lstAllprojects=[Select Id,IPM_Parent_Project__r.IPM_Parent_Project__c from IPM_Project__c Where IPM_Parent_Project__c IN : lstprojects];
        
        List<IPM_Project__c> updprojects=new List<IPM_Project__c>();
        if(!lstprojects.isEmpty()){
            for(IPM_Project__c Proj:lstprojects){
                IPM_Project__c p=new IPM_Project__c(Id=Proj.Id);
                p.IPM_Fast_Track_Project__c=projectIds.get(Proj.IPM_Parent_Project__c);
                System.debug(p);
                updprojects.add(p);
            }
        }
        
        if(!lstAllprojects.isEmpty()){
            for(IPM_Project__c pro:lstAllprojects){
                IPM_Project__c p=new IPM_Project__c(Id=pro.Id);
                p.IPM_Fast_Track_Project__c=projectIds.get(pro.IPM_Parent_Project__r.IPM_Parent_Project__c);
                System.debug(p);
                updprojects.add(p);
            }
        }
        
        if(!updprojects.isEmpty()){
            off_Trigger =true;
            System.debug(updprojects);
            update updprojects;
            off_Trigger =false;
        }
    }
        //global,Religion
    }
}