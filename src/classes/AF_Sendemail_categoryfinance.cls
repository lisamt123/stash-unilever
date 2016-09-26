/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_Sendemail_categoryfinance
   @CreateDate : 2/8/2014
   @Description : This is a class
   @			  this is used to send email to category finance users.
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
public with sharing class AF_Sendemail_categoryfinance
{
	public string templatebody{set;get;}
	public string templatesubject{set;get;}
	public boolean displayPopup {get; set;}
	/**********************************************************************
*  @Description: Contructor method
*  @name : AF_Sendemail_categoryfinance
*  @param : none
*  @return : none
*************************************************************************/   
	public AF_Sendemail_categoryfinance()
	{
		displayPopup = false;
		for(emailtemplate e:[select id,name,body,subject from emailtemplate where name =: AF_Constants.EMAIL_TEMPLATE_FINANCE])
		{
			if(e.id != null && e.body != null)
			{
				templatebody = e.body;
				templatesubject =e.subject;
			}
		}
	}
	/**********************************************************************
*  @Description: this method is used to send emails
*  @name : send
*  @param : none
*  @return: none.
**********************************************************************/
	public void send()
	{
		List<Id> lstusers=new List<Id>();
		string emails='';
		List<PermissionSetAssignment> permissionSetAssign=[SELECT AssigneeId,Id,PermissionSetId FROM PermissionSetAssignment where PermissionSet.name=:AF_Constants.PERM_FINANCE_CAT];
		if(permissionSetAssign.size()>0){
			for(PermissionSetAssignment assignment:permissionSetAssign){
				lstusers.add(assignment.AssigneeId);
			}
		}
		List<User> queryUser=[select Id, Email from User Where Id IN : lstusers];
		if(queryUser.size()>0){
			for(User userassign: queryUser){
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
			mail.setSubject(templatesubject);
			mail.setSaveAsActivity(false);
			mail.setPlainTextBody('Hi');
			mail.setHtmlBody(templatebody);
			messaging.sendemailresult[] r =Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			if(r[0].issuccess())
			{
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,Label.AF_Sent_Email);
				ApexPages.addMessage(myMsg);
				displayPopup = true;
			}
		}
	}
	/**********************************************************************
*  @Description: this method is used to close the pop up window
*  @name : closePopup
*  @param : none
*  @return: none.
**********************************************************************/
	public void closePopup() 
	{ 
		displayPopup = false;    
	} 
}