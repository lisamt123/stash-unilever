global Class PQN_UpdateFreezeDateOnPQN{

    /* This class and method will be called from the process builder, if the PQN is edited after the freeze period then a emial will be sent to the 
    Contacts of the associated account in the PQN record */ 
    
    
    
    @InvocableMethod 
    public static void updatePQNRecords(List<Id> pqnIds){
        try{
            //Store the Account Id of all the PQN records that has crossed the freeze period
             list<Id> accIds = new List<Id>();
             
            // Fetch the PQN Data
             List<PQN_Pallet_Quality_Non_Conformance__c> pqnResult = [select Id, Name,Account__c ,CreatedDate, Month__c,Date_Pallet_Received__c from PQN_Pallet_Quality_Non_Conformance__c where Id IN:pqnIds];
             
             
            //list to store the PQN records that are crossed the freeze date
            List<PQN_Pallet_Quality_Non_Conformance__c> freezedPQN = new List<PQN_Pallet_Quality_Non_Conformance__c>();
            
            
            //Loop through the List and get the PQN records that are crossed the freeze period
            for(PQN_Pallet_Quality_Non_Conformance__c pqn : pqnResult){
            
                // Get the PQNFreezeDate__c record whose Name is equal to "Month__c" value of the PQN record
                PQNFreezeDate__c FD = PQNFreezeDate__c.getInstance(pqn.Month__c);
                            
                //check whether the freeze date has crossed or not if crossed add the PQN Id to a list as well as Account Id
                if(FD.Freeze_Date__c < pqn.Date_Pallet_Received__c){
                    system.debug('the record has crossed the freeze period');
                    freezedPQN.add(pqn);
                    accIds.add(pqn.Account__c);
                    system.debug('The account ID is ' + pqn.Account__c);
                }               
                
            }            
            
            //Get all the contacts from the account and get the mail Id to send the email
            List<Contact> conList = new List<Contact>();
            conList = [select Id, Name, Email from Contact where Account.Id IN: accIds];
            
            List<Id> conId = new List<Id>();
            
            for(Contact con : conList){
                conId.add(con.Id);
                system.debug('the contact list is' + conId);
            }
            
            EmailTemplate et=[Select id from EmailTemplate where name = 'PQN_Freeze_Date_Notification' limit 1];
            Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
            mail.setTargetObjectIds(conId);
            mail.setSenderDisplayName('System Admin');
            mail.setTemplateId(et.id);
            Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
            system.debug('This method has been called');
             
        }
        catch(Exception e){
                system.debug('An exception has occured' + e.getMessage());
        }
        system.debug('Entered the Apex Class');
           
            
    }
}