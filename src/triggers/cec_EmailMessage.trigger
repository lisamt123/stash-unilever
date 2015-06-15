trigger cec_EmailMessage on EmailMessage (before insert) {



                     if(trigger.isBefore && trigger.isInsert){
system.debug('1~~~~~~~Inside Trigger new map '+trigger.newMap+'  trigger new List  '+trigger.new);      
                //pass maps for Issue 
                    cec_EmailMessageHandler ocec_EmailMessageHandler = new cec_EmailMessageHandler();
                    ocec_EmailMessageHandler.forbeforeInsert(trigger.new);   
                
system.debug('~~~~~~~Inside Trigger new map '+trigger.newMap+'  trigger new List  '+trigger.new);
                    
                    }
                    

}