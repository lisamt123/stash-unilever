global class PQN_SendEmailtoDC_ClusterBatch implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        List<PQNFreezeDate__c> listFreeze = PQNFreezeDate__c.getall().values();
        date d = system.today();
        date startDate = date.newInstance(d.year(), d.month(), 1);
        date freezeDate;
        for(PQNFreezeDate__c xFP: listFreeze){
            if(xFP.Numeric_Value__c==d.month()){
                //system.debug('---->>>'+xFP.Freeze_Date__c);
                
                freezeDate = xFP.Freeze_Date__c;
            }
        }
        set<Id> accIDS = new set<Id>();
        if(freezeDate==null){
            for(PQN_Pallet_Quality_Non_Conformance__c xPQN : [Select Id,Account__c from PQN_Pallet_Quality_Non_Conformance__c Where Date_Pallet_Received__c >:startDate and Date_Pallet_Received__c <:freezeDate]){
                accIDS.add(xPQN.Account__c);
            }
            
        }
        
        return Database.getQueryLocator('Select Id,Name,Email__c From PQN_User_Creation_Request__c where Id in (Select PQN_User_Creation_Request__c from PQN_User_Account_Request__c where Account__c =:accIDS)');
    }
    
    global void execute(Database.BatchableContext BC, List<PQN_User_Creation_Request__c> listSobject)
    {
        string subject = 'Non Conformance';
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(PQN_User_Creation_Request__c xP : listSobject){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] {xP.Email__c});
                mail.setReplyTo(xP.Email__c);
                mail.setSubject(subject);
                string body = '<html><body>Dear ' + xP.Name+',<br><br>';
                mail.setHtmlBody(body);
                mails.add(mail);
        }

        Messaging.sendEmail(mails);
    }
    
    global void finish(Database.BatchableContext BC)
    {
    
    }
}