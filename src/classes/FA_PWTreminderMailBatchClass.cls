global  class FA_PWTreminderMailBatchClass implements Database.Batchable<sObject>
{
    //global final string query;
    public string query;
    List<FA_Pre_Work_Task__c> PWTlist = new List<FA_Pre_Work_Task__c>();
    Set<ID> usrIDs = new Set<ID> ();
    public Date endDate = system.today().addDays(7);
    public Date startDate = system.today();

    global FA_PWTreminderMailBatchClass()
    {
        // Batch Constructor
        query = 'SELECT Id, FA_OccurenceOM__r.FA_Course_Name__c,'
                        + 'FA_Due_Date__c, FA_Task_Name__c,'
                        + 'FA_OccMember__r.FA_Participant_Instructor__c FROM FA_Pre_Work_Task__c '
                        + 'where FA_Due_Date__c >=: startDate '
                        + 'AND FA_Due_Date__c<=:endDate '
                        + 'AND FA_Mark_Completed__c = false ';
                        //+ 'AND FA_OccurenceOM__c =\''+ 'a0hM0000007uBvB' + '\'';
                        
    }
                
             // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {                        
        return Database.getQueryLocator(query);
    }

     // Execute Logic
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        // Logic to be Executed batch wise
        /*FA_Config_Settings__c liPWTReminder =  FA_Config_Settings__c.getValues('FA_PWTReminderTemplateId'); 
        String templateId = liPWTReminder.FA_Value__c;*/
        dateTime formatDT;
        for(sObject sObj: scope)
        {
            PWTlist.add ((FA_Pre_Work_Task__c) sObj);
        }
        for(FA_Pre_Work_Task__c P: PWTlist)
        {
            usrIDs.add(P.FA_OccMember__r.FA_Participant_Instructor__c);

        }
        map<Id,User> mapUsr= new map<Id,User>([Select id, isActive, Name, email from User where isActive = true AND id IN: usrIDs]);
        for(FA_Pre_Work_Task__c P: PWTlist)
        {
                formatDT =  datetime.newInstance(P.FA_Due_Date__c.year(), P.FA_Due_Date__c.month(), P.FA_Due_Date__c.day(), 23, 59, 00);
                //FA_SendPWTMail.sendSingleMail(U.id, String.valueOf(U.Name), P.FA_Pre_Work_Task__c.FA_Task_Name__c, String.valueOf(P.FA_Pre_Work_Task__c.FA_OccurenceOM__r.FA_Course_Name__c), P.FA_Pre_Work_Task__c.FA_Due_Date__c, templateId );
                FA_SendPWTMail.sendSingleMail(P.FA_OccMember__r.FA_Participant_Instructor__c, mapUsr.get(P.FA_OccMember__r.FA_Participant_Instructor__c).Name, P.FA_Task_Name__c, formatDT.format('MMMM d,  yyyy'), String.valueOf(P.FA_OccurenceOM__r.FA_Course_Name__c) );
        }
           
    }

    global void finish(Database.BatchableContext BC)
    {

    }

}