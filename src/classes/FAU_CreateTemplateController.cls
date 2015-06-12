public with sharing class FAU_CreateTemplateController {

   // Constructor - this only really matters if the autoRun function doesn't work right
    private final FAU_Program__c oFAUProgram;
    public FAU_CreateTemplateController(ApexPages.StandardController stdController) {
        this.oFAUProgram = (FAU_Program__c)stdController.getRecord();
    }
     
    // Code we will invoke on page load.
    public PageReference ContinueProcess() {
        Recordtype oRecordtype;
        String theId = ApexPages.currentPage().getParameters().get('id');
 
        if (theId == null)	return null;
        
        oRecordtype = [SELECT  Id, Name, DeveloperName FROM RecordType
                            WHERE SobjectType = 'FAU_Program__c'
                            AND DeveloperName = 'Template' LIMIT 1];


        FAU_Program__c oProgram = [select FAU_Category__c, FAU_Don_t_Send_Reminders__c, FAU_Invitation_ResponseDeadline__c, 
                                                    FAU_Invite_Form_Text__c, FAU_Primary_Location__c, FAU_Program_Banner__c, 
                                                    FAU_Program_Banner_URL__c, FAU_Program_Description__c, FAU_Program_Fee__c, 
                                                    FAU_Program_Type__c, FAU_Start_Date__c, FAU_Status__c, FAU_Biography_Deadline__c,
                                                    FAU_Training_Centre__c, Id,  Name, OwnerId, RecordTypeId 
                                                    from FAU_Program__c 
                                                    where id =:theId
                                                    LIMIT 1];
        FAU_Program__c oProgramInsert = FAU_ProgramClsSC.createProgram(oProgram, oFAUProgram.Name, oRecordtype, oProgram.FAU_Start_Date__c.daysBetween(oFAUProgram.FAU_Start_Date__c));
            
 
        // Redirect the user back to the original page
        PageReference pageRef = new PageReference('/' + oProgramInsert.Id);
        pageRef.setRedirect(true);
        return pageRef;
 
    }

}