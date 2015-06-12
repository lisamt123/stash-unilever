public class IPM_NewTask {
        
    public IPM_Task__c tasks{get;set;}
    public IPM_Project__c projectObject{get;set;}
    public sObject taskObject{get;set;}
    public String sObjName{get; set;}
    public Id projectId{get; set;}
    public Id taskId{get; set;}
    public string dueDate {get;set;}
    public string completedDate {get;set;}
    public boolean validate {get;set;}
    public string dateFormat {get; set;}
    public String errorMessage {get;set;}
    public Map<String,String> mapphasedate {get;set;}
    public boolean displayDueDate {get;set;}
    public list<SelectOption> options {get;set;}
    public String sectionVersionName {get;set;}    
    public boolean redirectToGateDocument {get;set;}
    public String redirectToGateDocumentUrl {get;set;}
    public String listvalue {get;set;}
    public String roleValue {get;set;}
    public string ProjectWizard{get;set;}
    public String userName {get;set;}
   // public string dateFormat {get; set;}
    public string dateFormat1 {get; set;}
   // public map<string, string> localyVsDateFormatMap = new map<string, string>();
    public boolean displayPopup {get; set;}
    
    public IPM_NewTask (ApexPages.StandardController controller) 
    {
        ProjectWizard=ApexPages.currentPage().getParameters().get('Wizard');
        tasks = (IPM_Task__c)controller.getRecord();
        if(!String.IsBlank(tasks.Id)){
            validate=true;
        }
        sectionVersionName = tasks.IPM_Project_Document_Section__r.IPM_Section_Sequence__c + '-' + tasks.IPM_Project_Document_Section__c;
        if(String.IsNotBlank(ApexPages.currentPage().getParameters().get('projDocSecId'))){
            
            redirectToGateDocument = true;  
            redirectToGateDocumentUrl= ApexPages.currentPage().getURL();
            
        }
        
        
        if(String.IsNotBlank(ApexPages.currentPage().getParameters().get('projectId')))
        {
            projectId = ApexPages.currentPage().getParameters().get('projectId');
            sObjName = projectId.getSObjectType().getDescribe().getName();
            
            User usr=[Select Id,Name,IPM_Role__c from User Where Id = : UserInfo.getUserId()];
            System.debug(usr);
            //Project Leader , Deputy Project Leader or Technical Leader
            if(!(usr.IPM_Role__c == 'Project Leader' || usr.IPM_Role__c == 'Technical Leader' || usr.IPM_Role__c=='Deputy Project Leader')){
                tasks.IPM_Function__c=usr.IPM_Role__c;    
                roleValue=usr.IPM_Role__c;
            }
          
            
            try
            {
                string query= 'Select id,IPM_PM_Approach__c,IPM_Project_Leader__c,IPM_Project_Leader__r.Name,IPM_Target_Launch_Dates__c from '+sObjName+' where id =\''+ projectId + '\'';
                System.debug('query'+query);
                projectObject  = Database.query(query);
                integer pcount=[SELECT count() FROM IPM_Project_Resource__c WHERE IPM_Role_Type__c = : tasks.IPM_Function__c AND IPM_Project__c = : projectObject.Id];
                     if(pcount >1){
                         IPM_Project_Resource__c  presource=[SELECT IPM_Category__c,IPM_User__r.Name,IPM_Project_Role_Owner__c,IPM_Project__c,IPM_Role_Type__c,IPM_Role__c,IPM_send_an_email__c,IPM_User__c,Project_Leader__c FROM IPM_Project_Resource__c WHERE IPM_Role_Type__c = : tasks.IPM_Function__c AND IPM_Project__c = : projectObject.Id and IPM_Project_Role_Owner__c = true limit 1];
                         if(presource != null)
                         if(presource.IPM_User__c != null)
                             tasks.IPM_Assignee__c=presource.IPM_User__c;
                             userName=presource.IPM_User__r.Name;
                     }else if(pcount == 1){
                         IPM_Project_Resource__c  presource=[SELECT IPM_Category__c,IPM_User__r.Name,IPM_Project_Role_Owner__c,IPM_Project__c,IPM_Role_Type__c,IPM_Role__c,IPM_send_an_email__c,IPM_User__c,Project_Leader__c FROM IPM_Project_Resource__c WHERE IPM_Role_Type__c = : tasks.IPM_Function__c AND IPM_Project__c = : projectObject.Id limit 1];
                         if(presource != null)
                         if(presource.IPM_User__c != null)
                             tasks.IPM_Assignee__c=presource.IPM_User__c;
                             userName=presource.IPM_User__r.Name;
                     }
                     else {
                         tasks.IPM_Assignee__c=projectObject.IPM_Project_Leader__c;
                         userName=projectObject.IPM_Project_Leader__r.Name;
                     }
                     
                     System.debug(tasks.IPM_Assignee__c+' '+projectObject.IPM_Project_Leader__c);
            } 
             catch(Exception e)
             {
                 ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Invalid project');
                 ApexPages.addMessage(myMsg); 
             }
         }
        
        if(String.IsNotBlank(ApexPages.currentPage().getParameters().get('taskId')))
        {
            taskId = ApexPages.currentPage().getParameters().get('taskId');
            try
            {
            sObjName = taskId.getSObjectType().getDescribe().getName();
            String query= 'Select id,IPM_Project__c,IPM_Task_Name__c,IPM_Assignee__r.Name,IPM_Phase__c,IPM_Type_of_Gate__c,IPM_Project_Document_Section__c,IPM_Function__c,IPM_Assignee__c,IPM_Due_Date1__c  FROM IPM_Task__c where id =\''+ taskId + '\'';
            taskObject= Database.query(query);
            
            
            tasks = (IPM_Task__c)taskObject;
            
            if(tasks.Id == null)
            {
                   if(tasks.IPM_Project__c == null){
                        tasks.IPM_Project__c=apexpages.currentpage().getparameters().get('projectId');
                    }    
            }else{
               /* if(tasks.IPM_Due_Date1__c !=null){
                String[] datevalue=String.valueOf(tasks.IPM_Due_Date1__c).split('-');
                dueDate =datevalue[0]+'-'+datevalue[1]+'-'+datevalue[2];
                }
                if(tasks.IPM_Completed_On__c !=null){
                 String[] completeddatevalue=String.valueOf(tasks.IPM_Completed_On__c).split('-');
                completedDate =completeddatevalue[2]+'/'+completeddatevalue[1]+'/'+completeddatevalue[0];
                }*/
            }
            
            
        }
        
        catch(exception e)
        {
            // ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Incorrect Task');
             ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
             ApexPages.addMessage(myMsg); 
        
        }
            
        
     }
        displayDueDate=true;
        if(projectObject.IPM_PM_Approach__c == 'External'){
            displayDueDate=false;
        }
       dateFormat1=UserInfo.getLocale();            
       string result=null;
                            
       //Fetching the resource
       List<StaticResource> resourceList = [SELECT Id, Body FROM StaticResource WHERE Name = 'LocaleVsDateFormate'];
       //Checking if the result is returned or not
       if(resourceList.size() == 1) {
           result = resourceList[0].Body.toString();
       }
    }
   
    public void closePopup()
    {       
        displayPopup = false;   
    } 
    
    public void showPopup()
    {       
        displayPopup = true;   
    }
    
    public void upsertTask(IPM_Task__c task)
    {
            Database.upsert(task);
    }
    
    public pageReference dosaveTasks(){
                validate =true;
                PageReference detailview;
                
                System.debug('\n listvalue +'+listvalue);
                System.debug('dueDate :'+dueDate);

            if(tasks.IPM_Project__c == null){
                tasks.IPM_Project__c=apexpages.currentpage().getparameters().get('projectId');
                IPM_Task__c milestone;
                /*if(tasks.IPM_Phase__c!=null){
                      milestone=[SELECT Id,IPM_Category__c,IPM_Completed_On__c,IPM_Milestone__c,IPM_Phase__c,IPM_Type_of_gate__c,IPM_Type_of_Milestone__c FROM IPM_Milestone__c WHERE IPM_Project__c = :tasks.IPM_Project__c AND IPM_Phase__c =: tasks.IPM_Phase__c AND IPM_Milestone__c = null limit 1];
                 }else{
                      milestone =[SELECT Id,IPM_Category__c,IPM_Completed_On__c,IPM_Milestone__c,IPM_Phase__c,IPM_Type_of_gate__c,IPM_Type_of_Milestone__c FROM IPM_Milestone__c WHERE IPM_Project__c = :tasks.IPM_Project__c AND IPM_Phase__c = 'Ideas' AND IPM_Milestone__c = null limit 1];
                 }*/
                 
                 if(milestone != null){
                     tasks.IPM_Task_Name__c=milestone.Id;
                 }
                }
                
             tasks.RecordTypeId=Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get('IPM Project Tasks').getRecordTypeId();
             System.debug('\n Assignee Value'+tasks.IPM_Assignee__c);
             if(listvalue != null)
                 tasks.IPM_Project_Document_Section__c=listvalue;
             if(String.isEmpty(tasks.IPM_Assignee__c)){
                 if(String.isNotEmpty(tasks.IPM_Function__c)){
                     System.debug(tasks.IPM_Function__c+' '+tasks.IPM_Project__c);
                     integer pcount=[SELECT count() FROM IPM_Project_Resource__c WHERE IPM_Role_Type__c = : tasks.IPM_Function__c AND IPM_Project__c = : tasks.IPM_Project__c];
                     if(pcount >1){
                         IPM_Project_Resource__c  presource=[SELECT IPM_Category__c,IPM_Project_Role_Owner__c,IPM_Project__c,IPM_Role_Type__c,IPM_Role__c,IPM_send_an_email__c,IPM_User__c,Project_Leader__c FROM IPM_Project_Resource__c WHERE IPM_Role_Type__c = : tasks.IPM_Function__c AND IPM_Project__c = : tasks.IPM_Project__c and IPM_Project_Role_Owner__c = true limit 1];
                         if(presource != null)
                         if(presource.IPM_User__c != null)
                             tasks.IPM_Assignee__c=presource.IPM_User__c;
                     }else if(pcount == 1){
                         IPM_Project_Resource__c  presource=[SELECT IPM_Category__c,IPM_Project_Role_Owner__c,IPM_Project__c,IPM_Role_Type__c,IPM_Role__c,IPM_send_an_email__c,IPM_User__c,Project_Leader__c FROM IPM_Project_Resource__c WHERE IPM_Role_Type__c = : tasks.IPM_Function__c AND IPM_Project__c = : tasks.IPM_Project__c limit 1];
                         if(presource != null)
                         if(presource.IPM_User__c != null)
                             tasks.IPM_Assignee__c=presource.IPM_User__c;
                     }
                     else
                         tasks.IPM_Assignee__c=projectObject.IPM_Project_Leader__c;
                 }
             }
             
             System.debug('Due Date'+dueDate);
            /* if(!String.isEmpty(dueDate)){
                    String[] dtvalue=dueDate.split('-');
                 //tasks.IPM_Due_Date1__c=Date.parse(dueDate);
                 
                 tasks.IPM_Due_Date1__c=Date.newInstance(integer.valueOf(dtvalue[0]), integer.valueOf(dtvalue[1]), integer.valueOf(dtvalue[2]));
                
                 }*/
            
             try{
                upsertTask(tasks);
             }catch(Exception e){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
                 validate =false;
                 errorMessage =e.getMessage();
             }
            closePopup();
            validate =true;
            if(redirectToGateDocumentUrl == null){
                detailview= new pagereference('/apex/IPM_TaskList?Id='+apexpages.currentpage().getparameters().get('projectId'));
                detailview.setRedirect(true);
            }
            else{
                detailview= new pagereference(redirectToGateDocumentUrl);
                detailview.setRedirect(true);
            
            }

            //return detailview;
            return null;            
    }
    
   /* public void dovalidation(){
        System.debug('Due Date'+dueDate);
             if(!String.isEmpty(dueDate)){
                    String[] dtvalue=dueDate.split('-');
                 //tasks.IPM_Due_Date1__c=Date.parse(dueDate);
                 
                 tasks.IPM_Due_Date1__c=Date.newInstance(integer.valueOf(dtvalue[0]), integer.valueOf(dtvalue[1]), integer.valueOf(dtvalue[2]));
                 System.debug(tasks.IPM_Due_Date1__c);
                 System.debug(projectObject.IPM_Target_Launch_Dates__c);
                 System.debug('Days Between:'+projectObject.IPM_Target_Launch_Dates__c.daysBetween(tasks.IPM_Due_Date1__c));
                 if(projectObject.IPM_Target_Launch_Dates__c.daysBetween(tasks.IPM_Due_Date1__c) >= 365){
                     tasks.IPM_Due_Date1__c.addError('Due Date Should not be greater than IPM_Target_Launch_Dates__c');
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Due Date Should not be greater than IPM_Target_Launch_Dates__c'));
                     }
                 }
    }*/
    
    public void getSections(){
        System.debug('Hi Yamuna + @@@+' +tasks.IPM_Type_of_Gate__c);
        System.debug(tasks.IPM_Function__c);
        
        System.debug(UserInfo.getUserRoleId());
        
        getSectionlist();
    }
    
    public List<SelectOption> getSectionlist()
    {
        //roleValue=tasks.IPM_Function__c;
        if(tasks.IPM_Function__c == null){
            return null;
        }
        
        if(tasks.IPM_Type_of_Gate__c == null){
            return null;
        }
        List<IPM_Project_Document__c> pdocument=[Select Id,IPM_Project__c from IPM_Project_Document__c Where IPM_Project__c =: apexpages.currentpage().getparameters().get('projectId') and IPM_GateDocuments__c =: tasks.IPM_Type_of_Gate__c];
        if(pdocument.size() ==0){
            return null;
        }
        List<IPM_Project_Document_Section__c> pdocumentSection;
        if(tasks.IPM_Function__c == 'Supply Chain'){
            pdocumentSection=[Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:pdocument[0].Id and IPM_FunctionalRole__c ='SC'];
        }else{
            pdocumentSection=[Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:pdocument[0].Id and IPM_FunctionalRole__c =: tasks.IPM_Function__c];
        }
        
        List<SelectOption> options = new List<SelectOption>();
        System.debug('Hi Yamuna + @@@optionlist+' +tasks.IPM_Type_of_Gate__c);
        for(IPM_Project_Document_Section__c docsections:pdocumentSection){
        options.add(new SelectOption(docsections.Id,docsections.IPM_Section_Sequence__c+' '+docsections.IPM_Section_Name__c));
        }
        integer pcount=[SELECT count() FROM IPM_Project_Resource__c WHERE IPM_Role_Type__c = : tasks.IPM_Function__c AND IPM_Project__c = : projectObject.Id and IPM_Project_Role_Owner__c = true];
             if(pcount >1){
                 IPM_Project_Resource__c  presource=[SELECT IPM_Category__c,IPM_User__r.Name,IPM_Project_Role_Owner__c,IPM_Project__c,IPM_Role_Type__c,IPM_Role__c,IPM_send_an_email__c,IPM_User__c,Project_Leader__c FROM IPM_Project_Resource__c WHERE IPM_Role_Type__c = : tasks.IPM_Function__c AND IPM_Project__c = : projectObject.Id and IPM_Project_Role_Owner__c = true limit 1];
                 if(presource != null)
                 if(presource.IPM_User__c != null)
                     tasks.IPM_Assignee__c=presource.IPM_User__c;
                     userName=presource.IPM_User__r.Name;
             }else if(pcount == 1){
                 IPM_Project_Resource__c  presource=[SELECT IPM_Category__c,IPM_User__r.Name,IPM_Project_Role_Owner__c,IPM_Project__c,IPM_Role_Type__c,IPM_Role__c,IPM_send_an_email__c,IPM_User__c,Project_Leader__c FROM IPM_Project_Resource__c WHERE IPM_Role_Type__c = : tasks.IPM_Function__c AND IPM_Project__c = : projectObject.Id and IPM_Project_Role_Owner__c = true limit 1];
                 if(presource != null)
                 if(presource.IPM_User__c != null)
                     tasks.IPM_Assignee__c=presource.IPM_User__c;
                     userName=presource.IPM_User__r.Name;
             }
             else {
                 tasks.IPM_Assignee__c=projectObject.IPM_Project_Leader__c;
                 userName=projectObject.IPM_Project_Leader__r.Name;
             }
        return options;
    }
}