global class AF_sendemail implements Schedulable
{
    global void execute(SchedulableContext sc)
    {    
        try{
        AF_TriggerDate__c ATD = AF_TriggerDate__c.getOrgDefaults();
        string subject;
        string templatebody;
        for(emailtemplate emt : [select id,name,HtmlValue,body,subject from emailtemplate where name =: 'AF_Sendemail' limit 1])
        {
            subject = emt.subject;
            templatebody = emt.HtmlValue;
        }
        if(ATD.Date__c == System.today())
        {
            system.debug(' inside==');
            List<Id> lstusers=new List<Id>();
            List<String> lstEmail=new List<String>();
            string emails;
            List<PermissionSetAssignment> permissionSetAssign=[SELECT AssigneeId,Id,PermissionSetId FROM PermissionSetAssignment where PermissionSet.name=:'AF_CMCO_Super_User'];
            if(permissionSetAssign.size()>0){
                for(PermissionSetAssignment assignment:permissionSetAssign){
                    lstusers.add(assignment.AssigneeId);
                }
            }
            List<User> queryUser=[select Id, Email from User Where Id IN : lstusers];
            if(queryUser.size()>0){
                for(User userassign: queryUser){
                //  lstEmail.add(userassign.Email);
                  if(emails == '' || emails == null)
                    emails = userassign.email;
                  else
                    emails = emails + ';' + userassign.email;
                    
                }
            }

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
               // if(!lstEmail.IsEmpty()){
                  if(emails != null && emails != '') {
                     String[] toAddresses = emails.split(';');
                     mail.setToAddresses(toAddresses );
                
             
                //mail.setToAddresses(lstEmail);
             
                String[] ccAddresses = new String[] {'yamunayarlagadda@gmail.com'};
                mail.setCcAddresses(ccAddresses );
                mail.setSubject(subject );
                mail.setSaveAsActivity(false);
                mail.setPlainTextBody('Hi');
                mail.setHtmlBody(templatebody);
                messaging.sendemailresult[] r=Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                System.debug(r);
                }
        }
        }Catch(Exception e){
            System.debug(e.getMessage()+e.getStackTraceString());
        }
        
    }
}