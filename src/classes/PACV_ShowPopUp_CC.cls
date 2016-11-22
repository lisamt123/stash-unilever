public class PACV_ShowPopUp_CC 
{

public Boolean displayPopup {get;set;}
public string Address1 {get; set;}
public string ExtUserEmail {get; set;}




    public PACV_ShowPopUp_CC() 
    {
       
     

    }
    
    
    
    public void showPopup()
    {
       
    displayPopup = true;

    
    }
    
    public void closePopup() {
        displayPopup = false;
        
    }
    
    public Pagereference redirectPopup()
    {
        
    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
    message.toAddresses = new String[] { ExtUserEmail, ExtUserEmail };
    message.optOutPolicy = 'FILTER';
    message.subject = 'LPAV email test';
    message.plainTextBody = 'LPAV email test.';
    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    
    if (results[0].success) {
        System.debug('The email was sent successfully.');
    } else {
        System.debug('The email failed to send: ' + results[0].errors[0].message);
    }
        
        displayPopup = false;
        //Please uncomment below 3 statements and replace YourObjectId
        PageReference p=new Pagereference('/apex/LPAVRiskAssesmentView');
        p.setRedirect(true);
        return p;
        
    }      


}