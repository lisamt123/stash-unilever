public with sharing class HRO_PreBoardingAction_CX {
	
	private List<HRO_Onboarding_Plan__c> listOfTemplateTasks{get;set;}
    public HRO_Onboarding_Plan__c planInfo{get;set;}
    public HRO_PreBoardingAction_CX(ApexPages.StandardSetController ctrl){
        planInfo = new HRO_Onboarding_Plan__c();
    }
    
    public HRO_PreBoardingAction_CX(ApexPages.StandardController crl){
        //system.debug(listOfTemplateTasks);
        system.debug('check if was here 1');
    }
    
    public String getProfileUserId(){
        
        String userId = '';
        if(ApexPages.currentPage().getParameters().containsKey('sfdc.userId')){
        	userId = ApexPages.currentPage().getParameters().get('sfdc.userId');    
        }else{
            //userId = UserInfo.getUserId();
        }
        return userId;
        
    }
    
    public List<HRO_Onboarding_Plan__c> getPreBoardingTasks(){
        listOfTemplateTasks = new List<HRO_Onboarding_Plan__c>();
        for(HRO_Onboarding_Plan__c template : [Select Id,Due__c, Link__c, Manager__c, Name, New_Leader__c, Phase__c, Send_Welcome_Email__c, Start_Date__c, Task_Description__c, Task_for__c, Task_type__c from HRO_Onboarding_Plan__c where Phase__c = 'Pre-Boarding']){
            listOfTemplateTasks.add(template);
        }
        system.debug(listOfTemplateTasks);
        return listOfTemplateTasks;
    }
    
    public List<HRO_Onboarding_Plan__c> getPostBoardingTasks(){
        listOfTemplateTasks = new List<HRO_Onboarding_Plan__c>();
        for(HRO_Onboarding_Plan__c template : [Select Id,Due__c, Link__c, Manager__c, Name, New_Leader__c, Phase__c, Send_Welcome_Email__c, Start_Date__c, Task_Description__c, Task_for__c, Task_type__c from HRO_Onboarding_Plan__c where Phase__c != 'Pre-Boarding']){
            listOfTemplateTasks.add(template);
        }
        system.debug(listOfTemplateTasks);
        return listOfTemplateTasks;
    }
    
    public PageReference next(){
        createPreBoardingTasks();
        Schema.DescribeSObjectResult r = HRO_Onboarding_Plan__c.sObjectType.getDescribe();
		String keyPrefix = r.getKeyPrefix();
        return new PageReference('/_ui/core/userprofile/UserProfilePage?tab=HRO_HeadStart&sfdc.userId='+UserInfo.getUserId());
    }
    
    public void createPreBoardingTasks(){
        
        List<HRO_Onboarding_Task__c> tasksToCreate = new List<HRO_Onboarding_Task__c>();
        Map<Id,List<HRO_Onboarding_Task__c>> createdTaskForManager = new Map<Id,List<HRO_Onboarding_Task__c>>();
        for(HRO_Onboarding_Plan__c p : listOfTemplateTasks){
            HRO_Onboarding_Task__c managerTask = new HRO_Onboarding_Task__c();
            managerTask.Name = p.Name;
            managerTask.Action_Type__c = p.Task_type__c;
            managerTask.Action_Taken__c = false;
            managerTask.Completed__c = false;
            managerTask.Due_Date__c = planInfo.Start_Date__c.addDays(Integer.valueOf(p.Due__c));
            managerTask.OwnerId = planInfo.Manager__c;
            managerTask.New_Leader_Name__c = planInfo.New_Leader__c;
            managerTask.Onboarding_Plan__c =  p.id;
            managerTask.Phase__c = p.Phase__c;
            managerTask.Task_Detail__c = p.Task_Description__c;
            managerTask.ExternalPortalLink__c = p.Link__c;
            if(!createdTaskForManager.containsKey(managerTask.OwnerId)){
                createdTaskForManager.put(managerTask.OwnerId,new List<HRO_Onboarding_Task__c>{managerTask});
            }else{
                createdTaskForManager.get(managerTask.OwnerId).add(managerTask);
            }
            tasksToCreate.add(managerTask);
        }
        try{
            insert tasksToCreate;
            sentPreBoardingEmailNotification(createdTaskForManager);
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Following error occured wile creating tasks :'+ex));
        }
        
        
    }
    
    public void sentPreBoardingEmailNotification(Map<Id,List<HRO_Onboarding_Task__c>> emailsForUsers){
        Map<String,Schema.SObjectField> mfields = HRO_Onboarding_Task__c.getSObjectType().getDescribe().fields.getMap();
        Map<String,String> mFieldsLabels = new Map<String,String>();
        for(String key : mfields.keySet()){
            mFieldsLabels.put(key,mfields.get(key).getDescribe().getLabel());
        }
        //get user information
        Map<Id,User> userMap = new Map<Id,User>([Select id,email,name from user where id in : emailsForUsers.keySet()]);
        List<Messaging.SingleEmailMessage> emailsToSent = new List<Messaging.SingleEmailMessage>();
        for(Id userId  : emailsForUsers.keySet()){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{userMap.get(userId).Email});
        	String emailBody='Dear' + userMap.get(userId).Name+',<br/><br/>';
        	String emailSubject='Pre-Boarding tasks assigment';
        	emailBody =+ 'The following list of Pre-Boarding tasks  needs to be completed. Once you have completed them, please mark them complete in <link>Headstart<link>.<br/><br/>';
        	emailBody +='<style>table, th, td {border: 1px solid black;border-collapse: collapse;} th,td {padding: 5px;} table {width:100%;}</style>';
            String tdStyle = 'border: 1px solid black;border-collapse: collapse;padding: 5px;'; 
        	String tableBody='<table style="width:100%;border-collapse: collapse;"><tr><td style="'+tdStyle+'"><b>'+mFieldsLabels.get('phase__c')+'</b></td><td style="'+tdStyle+'"><b>'+mFieldsLabels.get('task_detail__c')+'</b></td><td style="'+tdStyle+'"><b>'+mFieldsLabels.get('due_date__c')+'</b></td><td style="'+tdStyle+'"><b>'+mFieldsLabels.get('action_type__c')+'</b></td><td style="'+tdStyle+'"><b>'+mFieldsLabels.get('new_leader_name__c')+'</b></td></tr>';
            for(HRO_Onboarding_Task__c onboardTask : emailsForUsers.get(userId)){
                tableBody += '<tr><td style="'+tdStyle+'">'+onboardTask.Phase__c+'</td><td style="'+tdStyle+'">'+onboardTask.Task_Detail__c+'</td><td style="'+tdStyle+'">'+onboardTask.Due_Date__c.format()+'</td><td style="'+tdStyle+'">'+onboardTask.Action_Type__c+'</td><td style="'+tdStyle+'">'+onboardTask.New_Leader_Name__c+'</td></tr>';
            }
            
            tableBody += '</table>';
            emailBody +=tableBody;
            mail.setHtmlBody(emailBody);
            mail.setSubject(emailSubject);
            emailsToSent.add(mail);
            
        }
        
        Messaging.sendEmail(emailsToSent);
    }
    
}