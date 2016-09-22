public with sharing class FAU_CreateProgramController {

   // Constructor - this only really matters if the autoRun function doesn't work right
    private final FAU_Program__c oFAUProgram;
  
    public FAU_CreateProgramController(ApexPages.StandardController stdController) {
        this.oFAUProgram = (FAU_Program__c)stdController.getRecord();
    }
     

    public PageReference ContinueProcess() {
        Recordtype oRecordtype;
       // Date dtStartDate = oFAUProgram.FAU_Start_Date__c;
        String theId = ApexPages.currentPage().getParameters().get('id');
        
        system.debug('##### Entering continue1: ');
        if (theId == null) return null;

        system.debug('##### Entering continue1  theId: ' + theId);

        system.debug('##### Entering continue1  oFAUProgram: ' + oFAUProgram);
        system.debug('##### Entering continue1  FAU_Start_Date__c: ' + ApexPages.currentPage().getParameters().get('FAU_Start_Date__c'));



        FAU_Program__c oProgram = [select FAU_Category__c, FAU_Don_t_Send_Reminders__c, FAU_Invitation_ResponseDeadline__c, 
                                                    FAU_Invite_Form_Text__c, FAU_Primary_Location__c, FAU_Program_Banner__c, 
                                                    FAU_Program_Banner_URL__c, FAU_Program_Description__c, FAU_Program_Fee__c,  
                                                    FAU_Program_Type__c, FAU_Start_Date__c, FAU_Status__c, FAU_Biography_Deadline__c,
                                                    FAU_Training_Centre__c, Id,  Name, OwnerId, RecordTypeId,
                                                    FAU_Video_Introduction__c // Fix to add missing Video link when program created from Template
                                                    from FAU_Program__c 
                                                    where id =:theId
                                                    LIMIT 1];

        system.debug('##### Entering continue1  oProgram.FAU_Category__c: ' + oProgram.FAU_Category__c);
        oRecordtype = [SELECT  Id, Name, DeveloperName FROM RecordType
                            WHERE SobjectType = 'FAU_Program__c'
                            AND DeveloperName = :oProgram.FAU_Category__c LIMIT 1];

        FAU_Program__c oProgramInsert = FAU_ProgramClsSC.createProgram(oProgram, oFAUProgram.Name, oRecordtype, oProgram.FAU_Start_Date__c.daysBetween(oFAUProgram.FAU_Start_Date__c));


        // Redirect the user back to the original page
        PageReference pageRef = new PageReference('/' + oProgramInsert.Id);
        pageRef.setRedirect(true);
        return pageRef;
   }

}