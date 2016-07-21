Public class AF_Sendemail_categoryfinance
{
    Public string templatebody{set;get;}
    Public string templatesubject{set;get;}
    //Public boolean sendpanel{set;get;}
    //public boolean mainpanel{set;get;}
     public boolean displayPopup {get; set;}
    Public AF_Sendemail_categoryfinance()
    {
       // sendpanel = false;
       // mainpanel = true;
       displayPopup = false;
        for(emailtemplate e:[select id,name,body,subject from emailtemplate where name =: 'AF_Email_CatFinance'])
        {
            if(e.id != null && e.body != null)
            {
                 templatebody = e.body;
                 templatesubject =e.subject;
            }
        }
        
    }
    Public void opensendpanel()
    {
      // sendpanel = true;
      // mainpanel = false;
    }
    Public void send()
    {
       
       
        List<Id> lstusers=new List<Id>();
            List<String> lstEmail=new List<String>();
            string emails;
            List<PermissionSetAssignment> permissionSetAssign=[SELECT AssigneeId,Id,PermissionSetId FROM PermissionSetAssignment where PermissionSet.name=:'AF_Category_Finance'];
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
              
                  if(emails != null && emails != '') {
                     String[] toAddresses = emails.split(';');
                     mail.setToAddresses(toAddresses );
                
             
                //mail.setToAddresses(lstEmail);
             
                String[] ccAddresses = new String[] {'yamunayarlagadda@gmail.com'};
                mail.setCcAddresses(ccAddresses );
                mail.setSubject(templatesubject);
                mail.setSaveAsActivity(false);
                mail.setPlainTextBody('Hi');
                mail.setHtmlBody(templatebody);
                messaging.sendemailresult[] r =Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                  if(r[0].issuccess())
                  {
                     //mainpanel = true;
                     //sendpanel = false;
                     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,'Email is sent successfully');
                     ApexPages.addMessage(myMsg);
                     displayPopup = true;
                  }
                }
    }
      public void closePopup() 
        { 
           displayPopup = false;    
        } 
}