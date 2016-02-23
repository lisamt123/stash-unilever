@isTest
private class last_tstSharecontroler {
    public static ID userid; 
    public static Id leftselected;
    public static Profile profileid =[Select Id from Profile where Name='RAP']; 
    
    static testMethod void myUnitTest() {
       Amr_Job_Details__c job = new Amr_Job_Details__c();
        job.Name = 'testjob';
        job.Agency_Contact_Account_Director_Email__c = 'test@gmail.com';
        job.Digital_Agency_Name__c = 'test';
        job.Target_Air_Date__c = Date.Today();
        job.Your_Email_Address__c = 'abc@gmail.com';
        job.Any_other_agencies_involved__c = 'abc';
        job.Budget_Allocated_Input_Value__c = 5;
        job.Campaign_Name__c = 'xyz';
        job.Final_Approver_Of_Material_Email__c = 'asd@gmail.com';
        job.Unilever_Finance_Member_Email__c = 'qwe@gmail.com';
        
    
        insert job;
        
         Profile p = [select Id,name from Profile where Name ='RAP'];
            
          User newUser = new User(
                profileId = p.id, 
                username = 'newUser1234@yahoo.com', 
                email = 'pb@ff.com', 
                emailencodingkey = 'UTF-8', 
                localesidkey = 'en_US', 
                languagelocalekey = 'en_US', 
                timezonesidkey = 'America/Los_Angeles', 
                alias ='nuser', 
                lastname ='lastname'
             
                      
            );
            insert newUser; 
            
             User newUser1 = new User(
                profileId = p.id, 
                username = 'newUser12345@yahoo.com', 
                email = 'pb@ff.com', 
                emailencodingkey = 'UTF-8', 
                localesidkey = 'en_US', 
                languagelocalekey = 'en_US', 
                timezonesidkey = 'America/Los_Angeles', 
                alias ='nuser', 
                lastname ='lastname'
                
        
                
            );
            insert newUser1; 
            List<User> alluser = new List<User>();
           alluser.add(newUser);
           alluser.add(newUser1); 
           
           List<String> userStr = new List<String>();
           for(User u:alluser){
             userStr.add(u.Name);
           }
            test.startTest();
            PageReference pageRef = Page.Amr_RecordShare;
            Test.setCurrentPage(pageRef);                       
           // ApexPages.currentPage().getParameters().put('qp', 'yyyy');
            Amr_Sharecontroler controller = new Amr_Sharecontroler();
            controller.leftselected = userStr;
            controller.recordShare();

            test.stopTest();
            system.assert(controller!= null);
        
    }
    

}