public class IPM_ProjectsHandler {

    public static map<string,id> resourcemap;
    
    private static string NOT_YET_STARTED = 'Not Yet Started';
    private static string CHARTER_DOCUMENT = 'Charter Document';
    private static string CONTRACT_DOCUMENT = 'Contract Document';
    
    public static void processIPMProjects(Map<Id,IPM_Project__c> mapIPMProjects,List<IPM_Project__c> oldIPMProjects,String Action){
        ////Set<Id> ipmProjectId=new Set<Id>();
        ////List<IPM_Task__c> lsttasks=new List<IPM_Task__c>();
         List<IPM_Project_Task__c> lstProjectTask=new List<IPM_Project_Task__c>();
            
            lstProjectTask=helperMethod(mapIPMProjects);
            
            if(lstProjectTask!=null && !lstProjectTask.isEmpty()){
                insert lstProjectTask;
            }
    }
    public static void createTasks(map<id,IPM_Project__c> newMap,map<id,IPM_Project__c> oldMap)
    {
        map<id,IPM_Project__c> oldmaps=new map<id,IPM_Project__c>();
  //      system.debug(newMap);
    //    system.debug(oldMap);
        List<IPM_Project_Task__c> lstUpdProjectTask=new List<IPM_Project_Task__c>();
        for(id ipid:newMap.keyset())
        {
            if(newMap.get(ipid).IPM_Complexity__c!=null&&newmap.get(ipid).IPM_Complexity__c!=oldMap.get(ipid).IPM_Complexity__c)
            {
                oldmaps.put(ipid,oldMap.get(ipid));
            }   
        }
        if(oldmaps!=null && oldmaps.isEmpty()){
            return ;
        }else{
             lstUpdProjectTask=helperMethod(newMap);
        }
        
        List<IPM_Project_Task__c> lstProjectTasks=[SELECT Id,IPM_Active__c,IPM_Adhoc__c,IPM_Assigned_To__c,IPM_Completed__c,IPM_Due_Date__c,IPM_Gate_Documents__c,IPM_Project_Section__c,IPM_Project_Status_Icon__c,IPM_Project__c,IPM_Task_Name__c,IPM_Task_Role__c,IPM_Task_Status__c,IPM_Task_Type__c FROM IPM_Project_Task__c WHERE IPM_Project__c =: newMap.keyset() LIMIT 50000];

        if(lstUpdProjectTask!=null && !lstProjectTasks.isEmpty())
        for(integer i=0;i<lstProjectTasks.size();i++){
            for(integer j=0;j<lstUpdProjectTask.size();j++){
                if(lstUpdProjectTask[j].IPM_Task_Name__c == lstProjectTasks[i].IPM_Task_Name__c){
                   lstUpdProjectTask.remove(j);
                }
            }
        }
        
        List<IPM_Project_Task__c> updateProjectTasks=new List<IPM_Project_Task__c>();
      //  System.debug('Resource Map:'+IPM_ProjectsHandler.resourcemap);
        for(id ipid:newMap.keyset()){
            if(newMap.get(ipid).IPM_Complexity__c!=null&&newmap.get(ipid).IPM_Complexity__c!=oldMap.get(ipid).IPM_Complexity__c)
            {
                for(IPM_Project_Task__c ipTasks:lstProjectTasks){
                    ipTasks.IPM_Active__c = true;
            
                    if(ipTasks.IPM_Task_Role__c !=null)
                    {
                            if(resourcemap.get(ipTasks.IPM_Task_Role__c+'@'+ipTasks.IPM_Project__c)!=null)
                                ipTasks.IPM_Assigned_To__c=resourcemap.get(ipTasks.IPM_Task_Role__c+'@'+ipTasks.IPM_Project__c);
                            else
                                ipTasks.IPM_Assigned_To__c=newMap.get(ipid).IPM_Project_Leader__c;
                    }
                    else{
                        ipTasks.IPM_Assigned_To__c=newMap.get(ipid).IPM_Project_Leader__c;
                    }
                    updateProjectTasks.add(ipTasks);        
                    }
            }
                
        }
        update updateProjectTasks;
        
       // system.debug(lstUpdProjectTask);
        if(lstUpdProjectTask != null && !lstUpdProjectTask.isEmpty())
        upsert lstUpdProjectTask ExternalField__c;
        
    }
    
    public static List<IPM_Project_Task__c> helperMethod(MAP<Id,IPM_Project__c> newMap){
         set<string> complexityset=new set<string>();
        set<id> projectset=new set<id>();
        for(id ipid:newMap.keyset())
        {
            if(newMap.get(ipid).IPM_Complexity__c!=null)
            {
                complexityset.add(newMap.get(ipid).IPM_Complexity__c);
                projectset.add(ipid);
            }   
        }
        Map<string,list<IPM_Task__c>> lsttasks=new Map<string,list<IPM_Task__c>>();
        set<string> roleset=new set<string>();
        
        for(IPM_Task__c ITC:[Select Id,IPM_Function__c,IPM_Section_Number__c,IPM_Task_Name__c,IPM_Task_Type__c,IPM_Type_of_Gate__c,IPM_Task_Complexity__c from IPM_Task__c where IPM_Task_Complexity__c in:complexityset and IPM_Project__c In:projectset limit 50000])
            if(lsttasks.get(ITC.IPM_Task_Complexity__c)!=null)
            {
                list<IPM_Task__c> lit=new list<IPM_Task__c>();
                lit=lsttasks.get(ITC.IPM_Task_Complexity__c);
                lit.add(ITC);
                lsttasks.put(ITC.IPM_Task_Complexity__c,lit);
                if(ITC.IPM_Function__c!=null)
                    roleset.add(ITC.IPM_Function__c);
            }
            else
            {
                list<IPM_Task__c> lit=new list<IPM_Task__c>();
                lit.add(ITC);
                lsttasks.put(ITC.IPM_Task_Complexity__c,lit);
                if(ITC.IPM_Function__c!=null)
                    roleset.add(ITC.IPM_Function__c);
            }
            //map<string,id> resourcemap=new map<string,id>();
            IPM_ProjectsHandler.resourcemap=new map<string,id>();
     
        for(IPM_Project_Resource__c IPR:[Select id,Name,IPM_Role__c,IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,IPM_Project__c from IPM_Project_Resource__c where IPM_Project__c in:projectset and IPM_Role_Type__c in:roleset and IPM_User__c!=null limit 50000])
            {
                if(resourcemap.get(IPR.IPM_Role_Type__c +'@'+IPR.IPM_Project__c) !=null){
                    if(IPR.IPM_Project_Role_Owner__c){
                    resourcemap.put(IPR.IPM_Role_Type__c +'@'+IPR.IPM_Project__c,IPR.IPM_User__c);
                    }
                }else{
                    resourcemap.put(IPR.IPM_Role_Type__c +'@'+IPR.IPM_Project__c,IPR.IPM_User__c);
                }
            }
            
       //      system.debug( resourcemap);
            list<IPM_Project_Task__c> lstUpdProjectTask=new list<IPM_Project_Task__c>();
            for(id ipid:newMap.keyset())
        {
            if(newMap.get(ipid).IPM_Complexity__c!=null)
            {
                if(lsttasks.get(newMap.get(ipid).IPM_Complexity__c)!=null)
                for(IPM_Task__c ITS: lsttasks.get(newMap.get(ipid).IPM_Complexity__c))
                {
                        IPM_Project_Task__c projectTask=new IPM_Project_Task__c();
                        projectTask.IPM_Project__c=ipid;
                        projectTask.ExternalField__c=ITS.IPM_Task_Name__c+ipid;
                        projectTask.IPM_Task_Name__c=ITS.IPM_Task_Name__c;
                        projectTask.IPM_Task_Type__c=ITS.IPM_Task_Type__c;
                        projectTask.IPM_Task_Role__c=ITS.IPM_Function__c;
                            projectTask.IPM_Task_Status__c=NOT_YET_STARTED;
                        if(ITS.IPM_Type_of_Gate__c == IPM_ConstantUtils.CHARTER_GATE){
                            projectTask.IPM_Gate_Documents__c=CHARTER_DOCUMENT;
                        }
                        else if(ITS.IPM_Type_of_Gate__c == IPM_ConstantUtils.CONTRACT_GATE){
                            projectTask.IPM_Gate_Documents__c= CONTRACT_DOCUMENT;
                        } 
                    //    System.debug('Function Value:'+ITS.IPM_Function__c);
                        if(ITS.IPM_Function__c!=null)
                        {
                        if(resourcemap.get(ITS.IPM_Function__c+'@'+ipid)!=null)
                        projectTask.IPM_Assigned_To__c=resourcemap.get(ITS.IPM_Function__c+'@'+ipid);
                        else
                            projectTask.IPM_Assigned_To__c=newMap.get(ipid).IPM_Project_Leader__c;
                        }
                        else{
                            projectTask.IPM_Assigned_To__c=newMap.get(ipid).IPM_Project_Leader__c;
                            }
                       //     System.debug('Assigned User:'+projectTask.IPM_Assigned_To__c);
                            lstUpdProjectTask.add(projectTask);
                }
            }
        }
        return lstUpdProjectTask;
    }
}