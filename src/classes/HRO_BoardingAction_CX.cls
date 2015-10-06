/**********************************************************************
 Name:  HRO_BoardingAction_CX()
 Copyright © 2015  Salesforce
 ======================================================
======================================================
Purpose:                                                            
-------                                                            
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL            Description
   1.0    Karol Szepietowski        dd/mm/yyyy      INITIAL DEVELOPMENT          CSR: 
***********************************************************************/

public with sharing class HRO_BoardingAction_CX {
    @testVisible
	private List<HRO_Onboarding_Plan__c> listOfTemplateTasks{get;set;}
    public HRO_Onboarding_Plan__c planInfo{get;set;}

    /**
     * { constructor_description }
     *
     * @param      ctrl  { parameter_description }
     */

    public HRO_BoardingAction_CX(ApexPages.StandardSetController ctrl){
        planInfo = new HRO_Onboarding_Plan__c();
    }
    
    /**
     * { constructor_description }
     *
     * @param      crl   { parameter_description }
     */

    public HRO_BoardingAction_CX(ApexPages.StandardController crl){
        //system.debug(listOfTemplateTasks);
        system.debug('check if was here 1');
    }
    
    /**
     * { function_description }
     *
     * @return     { description_of_the_return_value }
     */

    public String getProfileUserId(){
        
        String userId = '';
        if(ApexPages.currentPage().getParameters().containsKey('sfdc.userId')){
        	userId = ApexPages.currentPage().getParameters().get('sfdc.userId');    
        }else{
            userId = UserInfo.getUserId();
        }
        return userId;
        
    }
    
    /**
     * { function_description }
     *
     * @return     { description_of_the_return_value }
     */

    public List<HRO_Onboarding_Plan__c> getPreBoardingTasks(){
        listOfTemplateTasks = new List<HRO_Onboarding_Plan__c>();
        for(HRO_Onboarding_Plan__c template : [Select Id,Due__c, Link__c, Manager__c, Name, New_Leader__c, Phase__c, Send_Welcome_Email__c, Start_Date__c, Task_Description__c, Task_for__c, Task_type__c from HRO_Onboarding_Plan__c where Phase__c = 'Pre-Boarding']){
            listOfTemplateTasks.add(template);
        }
        system.debug(listOfTemplateTasks);
        return listOfTemplateTasks;
    }
    

    /**
     * { function_description }
     *
     * @return     { description_of_the_return_value }
     */

    public List<HRO_Onboarding_Plan__c> getPostBoardingTasks(){
        listOfTemplateTasks = new List<HRO_Onboarding_Plan__c>();
        for(HRO_Onboarding_Plan__c template : [Select Id,Due__c, Link__c, Manager__c, Name, New_Leader__c, Phase__c, Send_Welcome_Email__c, Start_Date__c, Task_Description__c, Task_for__c, Task_type__c from HRO_Onboarding_Plan__c where Phase__c != 'Pre-Boarding']){
            listOfTemplateTasks.add(template);
        }
        system.debug(listOfTemplateTasks);
        return listOfTemplateTasks;
    }
    

    /**
     * { function_description }
     *
     * @return     { description_of_the_return_value }
     */

    public PageReference savePreBoarding(){
    	system.debug('*****HRO Entering savePreBoarding');
        createPreBoardingTasks();
        Schema.DescribeSObjectResult r = HRO_Onboarding_Plan__c.sObjectType.getDescribe();
		String keyPrefix = r.getKeyPrefix();
		system.debug('*****HRO Exiting savePreBoarding');
        return new PageReference('/_ui/core/userprofile/UserProfilePage?tab=HRO_HeadStart&sfdc.userId='+UserInfo.getUserId());
    }


    /**
     * { function_description }
     *
     * @return     { description_of_the_return_value }
     */

    public PageReference savePostBoarding(){
        createPostBoardingTasks();
        Schema.DescribeSObjectResult r = HRO_Onboarding_Plan__c.sObjectType.getDescribe();
		String keyPrefix = r.getKeyPrefix();
        return new PageReference('/'+keyPrefix+'/o');
    }
    
    /**
     * { function_description }
     */

    public void createPreBoardingTasks(){

        system.debug('*****HRO Entering createPreBoardingTasks');

        List<HRO_Onboarding_Task__c> tasksToCreate = new List<HRO_Onboarding_Task__c>();
        Map<Id,List<HRO_Onboarding_Task__c>> createdTaskForManager = new Map<Id,List<HRO_Onboarding_Task__c>>();
        for(HRO_Onboarding_Plan__c p : listOfTemplateTasks){
            HRO_Onboarding_Task__c managerTask = new HRO_Onboarding_Task__c();
            managerTask.Action_Type__c = p.Task_type__c;

            if(p.Link__c == null || p.Link__c ==''){
            	managerTask.Action_Taken__c = true;	
            }else{
            	managerTask.Action_Taken__c = false;
            }
            
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
        	system.debug('task to insert:'+tasksToCreate);
            insert tasksToCreate;
            sentPreBoardingEmailNotification(createdTaskForManager);
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Following error occured wile creating tasks :'+ex));
        }

         system.debug('*****Exiting createPreBoardingTasks folowing task were created:'+tasksToCreate);
        
        
    }

    /**
     * { function_description }
     */

    public void createPostBoardingTasks(){
        
        List<HRO_Onboarding_Task__c> tasksToCreate = new List<HRO_Onboarding_Task__c>();
        Map<Id,List<HRO_Onboarding_Task__c>> createdTaskForUsers = new Map<Id,List<HRO_Onboarding_Task__c>>();
        String leaderName = [Select Name from user where id =: planInfo.New_LeaderLookup__c Limit 1].get(0).Name;
        for(HRO_Onboarding_Plan__c p : listOfTemplateTasks){
            HRO_Onboarding_Task__c userTask = new HRO_Onboarding_Task__c();
            userTask.Action_Type__c = p.Task_type__c;
            if(p.Link__c == null || p.Link__c ==''){
            	userTask.Action_Taken__c = true;	
            }else{
            	userTask.Action_Taken__c = false;
            }
            
            userTask.Completed__c = false;
            userTask.Due_Date__c = planInfo.Start_Date__c.addDays(Integer.valueOf(p.Due__c));
            if(p.Task_for__c == 'Manager'){
            	 userTask.OwnerId = planInfo.Manager__c;
            }else{
            	userTask.OwnerId = planInfo.New_LeaderLookup__c;
            }
           
            userTask.New_Leader_Name__c = leaderName;
            userTask.Onboarding_Plan__c =  p.id;
            userTask.Phase__c = p.Phase__c;
            userTask.Task_Detail__c = p.Task_Description__c;
            userTask.ExternalPortalLink__c = p.Link__c;
            
            if(!createdTaskForUsers.containsKey(userTask.OwnerId)){
                createdTaskForUsers.put(userTask.OwnerId,new List<HRO_Onboarding_Task__c>{userTask});
            }else{
                createdTaskForUsers.get(userTask.OwnerId).add(userTask);
            }
            
            tasksToCreate.add(userTask);
        }
        try{

            insert tasksToCreate;
            HRO_UtilWithoutSharing.addLeaderAccessToHROApplication(planInfo.New_LeaderLookup__c);
            //call furue method to avoid mixed dml's
            HRO_UtilWithoutSharing.addAccessForManager(createdTaskForUsers.get(planInfo.Manager__c),planInfo.Manager__c);
            
        }catch(Exception ex){
            system.debug('**HRO createPostBoardingTasks exit with following error:'+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Following error occured wile creating tasks :'+ex));
        }
        
        
    }

    
    
    /**
     * { function_description }
     *
     * @param      emailsForUsers  { parameter_description }
     */

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