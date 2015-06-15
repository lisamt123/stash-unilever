public class IPM_Milestone {
        
    public IPM_Milestone__c tasks{get;set;}
    public IPM_Project__c projectObject{get;set;}
    public sObject taskObject{get;set;}
    public String sObjName{get; set;}
    public Id projectId{get; set;}
    public Id taskId{get; set;}
    public string dueDate {get;set;}
    public string completedDate {get;set;}
    public boolean validate {get;set;}
    public String errorMessage {get;set;}
    public date duedateValue;
    public Map<String,String> mapphasedate {get;set;}
    public string isEditable{get;set;}
    Public string IsDateEdit{get;set;}
   // public string dateFormat {get; set;}
    public string dateFormat1 {get; set;}
   // public map<string, string> localyVsDateFormatMap = new map<string, string>();
    public boolean displayPopup {get; set;}
    public List<MilestoneWrapper> milestones {get;set;}
    public string ProjectWizard{get;set;}
    public IPM_Milestone(ApexPages.StandardController controller) 
    {
        ProjectWizard='';
        isEditable=ApexPages.currentPage().getParameters().get('isEdit');
        IsDateEdit=ApexPages.currentPage().getParameters().get('isDateEdit');
        ProjectWizard=ApexPages.currentPage().getParameters().get('Wizard');
        tasks = (IPM_Milestone__c)controller.getRecord();
        
        if(String.IsNotBlank(ApexPages.currentPage().getParameters().get('projectId')))
        {
            projectId = ApexPages.currentPage().getParameters().get('projectId');
            sObjName = projectId.getSObjectType().getDescribe().getName();
            
            
            try
            {
                string query= 'Select id,IPM_PM_Approach__c,IPM_Phase__c,IPM_Target_Launch_Dates__c from '+sObjName+' where id =\''+ projectId + '\'';
                System.debug('query'+query);
                projectObject  = Database.query(query);
                
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
            String query= 'SELECT Id,IPM_Category__c,IPM_Completed_On__c,IPM_Completed__c,IPM_Due_Date__c,IPM_Milestone__c,IPM_Name__c,IPM_No_of_Days__c,IPM_Phase__c,IPM_Planned_Date__c,IPM_Project__c,IPM_Type_of_gate__c,IPM_BET__c,IPM_Type_of_Milestone__c FROM IPM_Milestone__c where id =\''+ taskId + '\'';
            taskObject= Database.query(query);
            
            
            tasks = (IPM_Milestone__c)taskObject;
            
            if(tasks.Id == null)
            {
                   if(tasks.IPM_Project__c == null)
                        tasks.IPM_Project__c=apexpages.currentpage().getparameters().get('projectId');
                        
                        
            }else{
                if(tasks.IPM_Due_Date__c !=null){
                    duedateValue=tasks.IPM_Due_Date__c;
                /*String[] datevalue=String.valueOf(tasks.IPM_Due_Date__c).split('-');
                dueDate =datevalue[0]+'-'+datevalue[1]+'-'+datevalue[2];*/
                }
                /*if(tasks.IPM_Completed_On__c !=null){
                 String[] completeddatevalue=String.valueOf(tasks.IPM_Completed_On__c).split('-');
                completedDate =completeddatevalue[0]+'-'+completeddatevalue[1]+'-'+completeddatevalue[2];
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
        
       dateFormat1=UserInfo.getLocale();            
       string result=null;
                            
       //Fetching the resource
       List<StaticResource> resourceList = [SELECT Id, Body FROM StaticResource WHERE Name = 'LocaleVsDateFormate'];
       //Checking if the result is returned or not
       if(resourceList.size() == 1) {
           result = resourceList[0].Body.toString();
       }
       getCategories();
    }
   
    public void closePopup()
    {       
        displayPopup = false;   
    } 
    
    public void showPopup()
    {       
        displayPopup = true;   
    }
    
    public void updateTasksMileStones()
    { 
        Integer milecount=[SELECT count() FROM IPM_Milestone__c WHERE IPM_Type_of_Milestone__c = 'Standard' AND Id =: ApexPages.currentPage().getParameters().get('taskId')];
         if(milecount != 1){
            Boolean isVal = false;
            IPM_Milestone__c[] milestone;
            Map<String, Date> milestoneDueDateMap = new Map<String, Date>();
            milestone=[SELECT Id,IPM_Due_Date__c,IPM_Category__c,IPM_Completed_On__c,IPM_Milestone__c,IPM_Phase__c,IPM_Type_of_gate__c,IPM_Type_of_Milestone__c FROM IPM_Milestone__c WHERE IPM_Project__c = :tasks.IPM_Project__c AND IPM_Milestone__c = null];
            for(IPM_Milestone__c eachMilestone : milestone) {
                milestoneDueDateMap.put(eachMilestone.IPM_Phase__c, eachMilestone.IPM_Due_Date__c);
            }
            if(tasks.IPM_Due_Date__c > milestoneDueDateMap.get(tasks.IPM_Phase__c)) {
               isVal = true;
            } else {
                dosaveTasks();
            }
            if(isVal) {
                 ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,Label.IPM_Milestone_Due_Date_Error);
                 validate =false;
                 ApexPages.addMessage(myMsg); 
             }
         }
    
Set<String> mileNames=new Set<String>{'Charter Gate Approval','Contract Gate Approval','Market Ready Gate Approval','Market Deployment Gate Approval','Ship To Trade'};
    Id recordTypeId=Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get('IPM Project Milestones').getRecordTypeId();
    List<IPM_Milestone__c> lstMileStones=[select Id,IPM_Name__c,IPM_Due_Date__c from IPM_Milestone__c where RecordTypeId=: recordTypeId and IPM_Name__c IN : mileNames And IPM_Project__c=: apexpages.currentpage().getparameters().get('projectId')];
    
    //List<IPM_Milestone__c> lstMileStones=[select Id,IPM_Name__c,IPM_Due_Date__c from IPM_Milestone__c where RecordType.Name= 'IPM_Project_Milestones' and IPM_Name__c IN : mileNames And IPM_Project__c=: apexpages.currentpage().getparameters().get('projectId')];
    Map<String,IPM_Milestone__c> mapmilestone=new Map<String,IPM_Milestone__c>();
    for(IPM_Milestone__c ipmmiles:lstMileStones){
        mapmilestone.put(ipmmiles.IPM_Name__c,ipmmiles); 
    }
    //List<IPM_Milestone__c> qmileStones=[Select Id,IPM_Name__c,IPM_Due_Date__c from IPM_Milestone__c Where Id =: ApexPages.currentPage().getParameters().get('taskId')];
    
        System.debug(tasks.IPM_Name__c+ApexPages.currentPage().getParameters().get('taskId')+apexpages.currentpage().getparameters().get('projectId'));
        System.debug(tasks.IPM_Name__c == 'Contract Gate Approval');
            if(tasks.IPM_Name__c == 'Contract Gate Approval'){
                System.debug(tasks.IPM_Name__c);
                System.debug('Date Issue:'+tasks.IPM_Due_Date__c);
                
                if(tasks.IPM_Due_Date__c < mapmilestone.get('Charter Gate Approval').IPM_Due_Date__c){
                    ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,tasks.IPM_Name__c +' Due Date cannot be less than Charter Gate Approval');
                    ApexPages.addMessage(myMsg); 
                    return;
                }
            }
            if(tasks.IPM_Name__c == 'Market Ready Gate Approval'){
                if(tasks.IPM_Due_Date__c < mapmilestone.get('Contract Gate Approval').IPM_Due_Date__c){
                    ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,tasks.IPM_Name__c +' Due Date cannot be less than Contract Gate Approval');
                    ApexPages.addMessage(myMsg); 
                    return;
                }
            }
            if(tasks.IPM_Name__c == 'Market Deployment Gate Approval'){
                if(tasks.IPM_Due_Date__c < mapmilestone.get('Market Ready Gate Approval').IPM_Due_Date__c){
                    ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,tasks.IPM_Name__c +' Due Date cannot be less than Market Ready Gate Approval');
                    ApexPages.addMessage(myMsg); 
                    return;
                }
            }
            if(tasks.IPM_Name__c == 'Ship To Trade'){
                if(tasks.IPM_Due_Date__c < mapmilestone.get('Market Deployment Gate Approval').IPM_Due_Date__c){
                    ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,tasks.IPM_Name__c +' Due Date cannot be less than Market Deployment Gate Approval');
                    ApexPages.addMessage(myMsg);
                    return;
                }
            }
    
        if(duedateValue != tasks.IPM_Due_Date__c && duedateValue != null && projectObject.IPM_Phase__c == tasks.IPM_Phase__c ){    
        System.debug('duedateValue'+duedateValue);
            displayPopup = true;
        }else{
            dosaveTasks();
        }  
    }
    
    public void upsertTask(IPM_Milestone__c task) {
        try {
            Database.upsert(task);
        } catch(exception e) {
            errorMessage =e.getMessage();
            if(errorMessage.contains('Due date')) {
                errorMessage = Label.IPM_Milestone_Due_Date_Error;
            } 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, errorMessage));
            validate =false;
        }
    }
    
   /* public List<IPM_Milestone__c> getListMileStones(){
         Id mileStoneRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get('IPM Milestones').getRecordTypeId();
        List<IPM_Milestone__c> lstmiles=[SELECT Id,IPM_Due_Date__c,IPM_Name__c,IPM_Category__c,IPM_Planned_Date__c,IPM_Completed_On__c,IPM_Milestone__c,IPM_Phase__c,IPM_Type_of_gate__c,IPM_Type_of_Milestone__c FROM IPM_Milestone__c where IPM_Milestone__c != null and RecordTypeId= : mileStoneRecordType and IPM_Type_of_Milestone__c = 'Optional'];
        return lstmiles;
    }*/
    
    public pageReference createMileStones(){
        List<IPM_Milestone__c> lstmiles=new List<IPM_Milestone__c>();
        Boolean isVal=false;
        IPM_Milestone__c[] milestone;
        Map<String, Date> milestoneDueDateMap = new Map<String, Date>();
        milestone=[SELECT Id,IPM_Due_Date__c,IPM_Category__c,IPM_Completed_On__c,IPM_Milestone__c,IPM_Phase__c,IPM_Type_of_gate__c,IPM_Type_of_Milestone__c FROM IPM_Milestone__c WHERE IPM_Project__c = :projectObject.Id AND IPM_Milestone__c = null];
        for(IPM_Milestone__c eachMilestone : milestone) {
            milestoneDueDateMap.put(eachMilestone.IPM_Phase__c, eachMilestone.IPM_Due_Date__c);
        }
        for (MilestoneWrapper cw : milestones) {
            if (cw.checked){
             if(cw.mile.IPM_Due_Date__c > milestoneDueDateMap.get(cw.mile.IPM_Phase__c)) {
                isVal = true;
                break;
             }
              IPM_Milestone__c m=new IPM_Milestone__c();
              m.recordTypeId=Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get('IPM Project Milestones').getRecordTypeId();
              m.IPM_Name__c=cw.mile.IPM_Name__c;
              m.IPM_Project__c=projectObject.Id;
              
              //m.IPM_Project__c=cw.mile.IPM_Project__c;
              m.IPM_Milestone__c=cw.mile.Id;
              m.IPM_Phase__c=cw.mile.IPM_Phase__c;
              m.IPM_Planned_Date__c=cw.mile.IPM_Due_Date__c;
              m.IPM_Type_of_Milestone__c='Optional';
              
              //m.ExternalField__c=
              lstmiles.add(m);
                System.debug('\n\n Checked Record id Values: @@@@'+cw.mile.Id+cw.mile.IPM_Due_Date__c+cw.mile.IPM_Phase__c+cw.mile.IPM_Name__c);
                System.debug('\n\n Cheked Retrns :@@@'+cw.checked);
             }
            }
         if(isVal) {
             ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,Label.IPM_Milestone_Due_Date_Error);
             validate =false;
             ApexPages.addMessage(myMsg); 
             system.debug(milestoneDueDateMap + ' ** isVal ' + isVal);
             return null;
         } else {
            if(!lstmiles.isEmpty()){
                try {
                   upsert lstmiles;
                   pagereference pg=new pageReference('/apex/IPM_TaskList?id='+apexpages.currentpage().getparameters().get('projectId'));
                   validate =true;
                }catch(Exception e){
                     errorMessage =e.getMessage();
                     if(errorMessage.contains('Due date')) {
                        errorMessage = Label.IPM_Milestone_Due_Date_Error;
                     }
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, errorMessage));
                     validate =false;
                 }
            }
            //return pg;
            return null;
        }
    }
    
    public class MilestoneWrapper {
    public Boolean checked{ get; set; }
    public IPM_Milestone__c mile { get; set;}
    public MilestoneWrapper(){
        mile = new IPM_Milestone__c();
        checked = false;
    }
    public MilestoneWrapper(IPM_Milestone__c c,Date launchDate){
        mile = c;
        if(c.IPM_BET__c && c.IPM_Name__c == 'BET First Release'){
            mile.IPM_Due_Date__c = launchDate.month() <7?Date.newInstance(launchDate.year()-1, 04, 15):Date.newInstance(launchDate.year()-1, 06, 30);
        //mile.IPM_Due_Date__c = dt.month() >7?Date.today():Date.today();
        }else if(c.IPM_BET__c && c.IPM_Name__c == 'BET Final Release (complete with Approved Communication)'){
            mile.IPM_Due_Date__c=launchDate.addDays(-180);
        }
        checked = false;
    }
}

 
    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
            System.debug('\n Con Value:'+con);
            if(con == null) {
                // and IPM_Type_of_Milestone__c = 'Optional'
                //IPM_Milestone__c != null and 
                Id mileStoneRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get('IPM Milestones').getRecordTypeId();
                con = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id,IPM_Project__c,IPM_Due_Date__c,IPM_Name__c,IPM_Category__c,IPM_Planned_Date__c,IPM_Completed_On__c,IPM_Milestone__c,IPM_Phase__c,IPM_BET__c,IPM_Type_of_gate__c,IPM_Type_of_Milestone__c FROM IPM_Milestone__c where IPM_Name__c != null And RecordTypeId= : mileStoneRecordType and IPM_Type_of_Milestone__c='Optional']));
                // sets the number of records in each page set
                con.setPageSize(10);
            }
            return con;
        }
        set;
    }

    public List<MilestoneWrapper> getCategories() {
            milestones = new List<MilestoneWrapper>();
            for (IPM_Milestone__c mile : (List<IPM_Milestone__c>)con.getRecords())
                milestones.add(new MilestoneWrapper(mile,projectObject.IPM_Target_Launch_Dates__c));
     
            return milestones;
        }
    
    
    public void getduedate(){
            if(String.IsNotEmpty(tasks.IPM_Phase__c)){
            integer milescount=[select count() FROM IPM_Milestone__c WHERE IPM_Project__c = :projectId AND IPM_Milestone__c = null and IPM_Phase__c = : tasks.IPM_Phase__c and IPM_Planned_Date__c != null];
            if(!(milescount >0)){
                return;
            }
            IPM_Milestone__c miles=[SELECT Id,IPM_Category__c,IPM_Planned_Date__c,IPM_Completed_On__c,IPM_Milestone__c,IPM_Phase__c,IPM_BET__c,IPM_Type_of_gate__c,IPM_Type_of_Milestone__c FROM IPM_Milestone__c WHERE IPM_Project__c = :projectId AND IPM_Milestone__c = null and IPM_Phase__c = : tasks.IPM_Phase__c and IPM_Planned_Date__c != null limit 1];
            
                        if(miles.IPM_Planned_Date__c !=null){
                            //String[] datevalue=String.valueOf(miles.IPM_Planned_Date__c).split('-');
                            //dueDate =datevalue[0]+'-'+datevalue[1]+'-'+datevalue[2];
                            tasks.IPM_Planned_Date__c=miles.IPM_Planned_Date__c;
                            tasks.IPM_Due_Date__c=miles.IPM_Planned_Date__c;
                            }
            }
    }
    public void doupdateTasks(){
        System.debug('Phase Name:'+tasks.IPM_Phase__c);
        List<IPM_Task__c> lstTasks=[SELECT Id FROM IPM_Task__c where IPM_Phase__c =: tasks.IPM_Phase__c and IPM_Project__c = : tasks.IPM_Project__c];
        List<IPM_Task__c> updTasks=new List<IPM_Task__c>();
        for(IPM_Task__c tas:lstTasks){
            IPM_Task__c updateTasks=new IPM_Task__c(Id=tas.Id);
            updateTasks.IPM_Due_Date1__c=tasks.IPM_Due_Date__c;
            updTasks.add(updateTasks);
        }
        
        if(!updTasks.isEmpty()){
            System.debug(updTasks);
            update updTasks;
            System.debug(updTasks);
        }
        
        dosaveTasks();
    }
    
    
    public PageReference dosaveTasks(){
                PageReference detailview;
                
                System.debug('dueDate :'+dueDate);
                
             if(String.IsEmpty(tasks.IPM_Name__c)){
                ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Please enter MileStone name');
                ApexPages.addMessage(myMsg); 
                //tasks.IPM_Task_Name__c.addError('Please enter task name');
                return null;
            }
            
             if(String.IsBlank(tasks.IPM_Phase__c)){
                ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Please enter Phase');
                ApexPages.addMessage(myMsg); 
                //tasks.IPM_Task_Name__c.addError('Please enter task name');
                return null;
            }
            
            if(String.IsBlank(String.valueOf(tasks.IPM_Due_Date__c))){
                ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Due Date should not be null');
                ApexPages.addMessage(myMsg); 
                //tasks.IPM_Task_Name__c.addError('Please enter task name');
                return null;
            }
            
            
            
            /*if(!String.isEmpty(dueDate) && System.today() > Date.parse(dueDate)){
                ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Due Date Should not be past date');
                ApexPages.addMessage(myMsg); 
                //tasks.IPM_Task_Name__c.addError('Please enter task name');
                return null;
            }*/
            Boolean isVal = false;
            if(tasks.IPM_Project__c == null){
                tasks.IPM_Project__c=apexpages.currentpage().getparameters().get('projectId');
                IPM_Milestone__c milestone;
                if(tasks.IPM_Phase__c!=null){
                     milestone=[SELECT Id,IPM_Due_Date__c,IPM_Category__c,IPM_Completed_On__c,IPM_Milestone__c,IPM_Phase__c,IPM_Type_of_gate__c,IPM_Type_of_Milestone__c FROM IPM_Milestone__c WHERE IPM_Project__c = :tasks.IPM_Project__c AND IPM_Phase__c =: tasks.IPM_Phase__c AND IPM_Milestone__c = null limit 1];
                 }else{
                     milestone =[SELECT Id,IPM_Due_Date__c,IPM_Category__c,IPM_Completed_On__c,IPM_Milestone__c,IPM_Phase__c,IPM_Type_of_gate__c,IPM_Type_of_Milestone__c FROM IPM_Milestone__c WHERE IPM_Project__c = :tasks.IPM_Project__c AND IPM_Phase__c = 'Ideas' AND IPM_Milestone__c = null limit 1];
                 }
                 if(milestone != null){
                     tasks.IPM_Milestone__c=milestone.Id;
                 }
                 isVal = tasks.IPM_Due_Date__c > milestone.IPM_Due_Date__c ? true : false;
              }
             if(isVal) {
                 ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,Label.IPM_Milestone_Due_Date_Error);
                 ApexPages.addMessage(myMsg); 
                    //tasks.IPM_Task_Name__c.addError('Please enter task name');
                 return null;
             } else {
             tasks.RecordTypeId=Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get('IPM Project Milestones').getRecordTypeId();
             tasks.IPM_Planned_Date__c =tasks.IPM_Due_Date__c;
             tasks.IPM_Completed__c = tasks.IPM_Completed_On__c != null ? true : false;
           /*  System.debug('Due Date'+dueDate);
             if(!String.isEmpty(dueDate)){
                 tasks.IPM_Due_Date__c=Date.parse(dueDate);
                 
             }
             System.debug('Due Date'+completedDate );
             if(!String.isEmpty(completedDate)){
                 tasks.IPM_Completed_On__c=Date.parse(completedDate);
             }*/
             try{
                upsertTask(tasks);
                validate=true;
                closePopup();
             }catch(Exception e){
                 errorMessage =e.getMessage();
                 if(errorMessage.contains('Due date')) {
                    errorMessage = Label.IPM_Milestone_Due_Date_Error;
                 }
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, errorMessage));
                 validate =false;
             }
            detailview= new pagereference('/apex/IPM_TaskList?Id='+apexpages.currentpage().getparameters().get('projectId'));
            //detailview.setRedirect(true);
            //return detailview;
            return null;
           }
    }
    
}