Public Class PQN_UpdateFreezeDateOnPQN{
    


    //This class will be called by the Process Builder (PQN_Check_Freeze_Period_and_Send_Email) only when the record is edited.
    // This class will update the field "Current_Month_Freeze_Date__c" on PQN record and
    // if the record has crossed the "Freeze Period" the class will send an email notification to few contacts
    
    @InvocableMethod 
    public static void updatePQNRecords(List<Id> pqnIds){
    
        //Store the Account Id of all the PQN records that has crossed the freeze period
         list<Id> accIds = new List<Id>();
        
        // This method will update the field and send email if criteria is match.
        // Fetch the PQN Data         
        List<PQN_Pallet_Quality_Non_Conformance__c> pqnResult = [select Id, Name,Account__c , Current_Month_Freeze_Date__c,CreatedDate, Month__c,Date_Pallet_Received__c from PQN_Pallet_Quality_Non_Conformance__c where Id IN:pqnIds];
        
        //List to store the PQN records which are to be updated with the freeze date
        List<PQN_Pallet_Quality_Non_Conformance__c> updatedPQN = new List<PQN_Pallet_Quality_Non_Conformance__c>();
        
        //list to store the PQAN records that are crossed the freeze date
        List<PQN_Pallet_Quality_Non_Conformance__c> freezedPQN = new List<PQN_Pallet_Quality_Non_Conformance__c>();
        
        
        //Loop through the List and get the PQN records that arte crossed the freeze period
        
        for(PQN_Pallet_Quality_Non_Conformance__c pqn : pqnResult){
        
            // Get the PQNFreezeDate__c record whose Name is equal to "Month__c" value of the PQN record
            PQNFreezeDate__c FD = PQNFreezeDate__c.getInstance(pqn.Month__c);
            
            
                        
            //check whether the freeze date has crossed or not
            if(FD.Freeze_Date__c < pqn.Date_Pallet_Received__c){
                system.debug('the record has crossed the freeze period');
                freezedPQN.add(pqn);
                accIds.add(pqn.Account__c);
                
            }
            
                     
            pqn.Current_Month_Freeze_Date__c = FD.Freeze_Date__c ;
            system.debug('The current month freeze date is' + pqn.Current_Month_Freeze_Date__c );
            updatedPQN.add(pqn);
            
            
        }
        update updatedPQN;
        
        //Get all the contacts from the account and get the mail Id to send the email 
        
        List<Contact> conList = new List<Contact>();
        
        conList = [select Id, Name, Email from Contact where Account.Id IN: accIds];
        List<Id> conId = new List<Id>();
        
        for(Contact con : conList){
            conId.add(con.Id);
        }
        
         EmailTemplate et=[Select id from EmailTemplate where name = 'PQN_Freeze_Date_Notification' limit 1];
 
             Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
             mail.setTargetObjectIds(conId);
             mail.setSenderDisplayName('System Admin');
             mail.setTemplateId(et.id);
             Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });

        system.debug('This method has been called');
        
        
        
        
    }
    
    
}