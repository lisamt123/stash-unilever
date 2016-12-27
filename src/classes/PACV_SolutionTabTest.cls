/**
 * Name:        -   PACV_SolutionsTabTest
 * @Description -   This Solution tab will display the list of solutions related to loggedin user and giving access to selected user by clicking the grant access button. 
 * @Author      -   Anusha S from Mindtree     
 */
@isTest
public class PACV_SolutionTabTest
{
public static testMethod void SolutionTabMethod() {
        
     
        PACV_Solutions__c o = new PACV_Solutions__c (Name='Test',PACV_Solution_Status__c= 'Under Review',
                                                    PACV_Solution_Category__c= 'Covert',PACV_Material_Type__c='Flexible',
                                                    PACV_Contact_Phone__c='0987654321',PACV_Supplier_Phone__c='1234567890');
        insert o;
       Profile p1 = [select id,Name from Profile where Name='Standard Platform User']; 

        User opUser = new user(alias = 'test123', email='test123@noemail.com',emailencodingkey='UTF-8', firstName='Pawan', lastname='Testing', 
                               languagelocalekey='en_US',localesidkey='en_US', profileid = p1.Id, country='United States',
                               timezonesidkey='America/Los_Angeles', username='test01@noemail.com'); 
           
            insert opUser;
            
          //  PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'PACV_PM_User'];
            //insert new PermissionSetAssignment(AssigneeId = opUser.id, PermissionSetId = ps.Id );
            
            PageReference myPage = Page.PACV_SolutionTab;
            myPage.getParameters().put('id', o.Id);  
            Test.setCurrentPage(myPage);    
            ApexPages.StandardController control = new ApexPages.Standardcontroller(o);
            PACV_SolutionsTab_CC pageControl = new PACV_SolutionsTab_CC(control); 
            pageControl.getSearchTerm();
            pageControl.showPopup();   
            pageControl.closePopup();
    //added by sibatri
            List<User> Users = PACV_SolutionsTab_CC.searchuser('Testing');
                System.assertEquals(true, Users.size()!=0);
    
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
        //  System.assertNotEquals(0, pageMessages.size());

            // Check that the error message you are expecting is in pageMessages
            Boolean messageFound = false;
            
            for(ApexPages.Message message : pageMessages) {
                if(message.getSummary() == 'Your summary'
                    && message.getDetail() == 'Your detail')
                     {
                    messageFound = true;        
                }
            }
            
            try
            {
                pageControl.selecteduser = opUser.id;
                pageControl.savepermissionset();
            }Catch(Exception ee)    
            {}
    }

}