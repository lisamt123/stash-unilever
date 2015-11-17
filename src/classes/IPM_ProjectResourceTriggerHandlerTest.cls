/*******************************************************
* @Description: Test class for CustomerChannelController
* @Author:Cognizant
* @Date:05/11/2015  
* *****************************************************/

@isTest
public class IPM_ProjectResourceTriggerHandlerTest {
    
    public static List<User> userList = new  List<User>();
    public static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
    public static List<IPM_Project_Document__c> projectDocList = new List<IPM_Project_Document__c>();
    public static List<IPM_Project_Document_Section__c> projectDocSectionList  = new List<IPM_Project_Document_Section__c>();
    public static List<IPM_Project_Resource__c> projectResourceList  = new List<IPM_Project_Resource__c>();
    public static List<IPM_Task__c> taskList  = new List<IPM_Task__c>();
	private static String RESOURCE_HISTORY_INSERTED = 'Project Resource History Inserted'; 
    private static String RESOURCE_HISTORY_UPDATED = 'Project Resource History Updated'; 
    
    
    
    /***********************************
    * @Description: Test Data Creation
    * *********************************/
    
    private static void createTestData()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 3]; 
        User projectLeader = new User(Alias = 'standus1', Email='standarduser@testorg4.com', EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                                      LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1_ipm@testorg.com', 
                                      IPM_Category__c = 'test4', IPM_Brand_Positioning__c= 'test4', IPM_Brand_Name__c ='test1', IPM_Role__c='Gate Keeper',
                                      IPM_Sub_Category__c='test',isActive =true
                                     );
        
        User projectResource1 = new User(Alias = 'standus2', Email='standarduser@testorg5.com', EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
                                         LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2_ipm@testorg.com', 
                                         IPM_Category__c = 'test4', IPM_Brand_Positioning__c= 'test4', IPM_Brand_Name__c ='test1', IPM_Role__c='Gate Keeper',
                                         IPM_Sub_Category__c='test',isActive =true
                                        );
        
        User projectResource2 = new User(Alias = 'standus3', Email='standarduser@testorg6.com', EmailEncodingKey='UTF-8', LastName='Testing3', LanguageLocaleKey='en_US', 
                                         LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standarduser3_ipm@testorg.com', 
                                         IPM_Category__c = 'test4', IPM_Brand_Positioning__c= 'test4', IPM_Brand_Name__c ='test1', IPM_Role__c='Gate Keeper',
                                         IPM_Sub_Category__c='test',isActive =true
                                        );
        User projectResource3 = new User(Alias = 'standus4', Email='standarduser@testorg7.com', EmailEncodingKey='UTF-8', LastName='Testing3', LanguageLocaleKey='en_US', 
                                         LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standarduser4_ipm@testorg.com', 
                                         IPM_Category__c = 'test4', IPM_Brand_Positioning__c= 'test4', IPM_Brand_Name__c ='test1', IPM_Role__c='Gate Keeper',
                                         IPM_Sub_Category__c='test',isActive =true
                                        );
        
        User projectResource4 = new User(Alias = 'standus5', Email='standarduser@testorg8.com', EmailEncodingKey='UTF-8', LastName='Testing3', LanguageLocaleKey='en_US', 
                                         LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standarduser5_ipm@testorg.com', 
                                         IPM_Category__c = 'test4', IPM_Brand_Positioning__c= 'test4', IPM_Brand_Name__c ='test1', IPM_Role__c='Gate Keeper',
                                         IPM_Sub_Category__c='test',isActive =true
                                        );                                                                      
        
		User projectResource5 = new User(Alias = 'standus6', Email='standarduser@testorg8.com', EmailEncodingKey='UTF-8', LastName='Testing3', LanguageLocaleKey='en_US', 
                                         LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standarduser6_ipm@testorg.com', 
                                         IPM_Category__c = 'test4', IPM_Brand_Positioning__c= 'test4', IPM_Brand_Name__c ='test1', IPM_Role__c='Gate Keeper',
                                         IPM_Sub_Category__c='test',isActive =true
                                        );      
										
        userList.add(projectLeader);
        userList.add(projectResource1);
        userList.add(projectResource2);
        userList.add(projectResource3);
        userList.add(projectResource4);
		userList.add(projectResource5);
        insert userList;
        
        //creating Project Template
        IPM_Project_Template__c projTemplate=new IPM_Project_Template__c();
        projTemplate.IPM_Template_Complexity__c='Full';
        insert projTemplate;
        
        //Creating Document Template
        IPM_Document_Template__c ipdoctem=new IPM_Document_Template__c();
        ipdoctem.IPM_Project_Template__c=projTemplate.ID;
        ipdoctem.IPM_Document_Template_Name__c='Charter Gate Full';
        ipdoctem.IPM_Document_Type__c='Charter';
        insert ipdoctem;
        
        //Creating master Section
        IPM_Section__c secMast=new IPM_Section__c();
        secMast.IPM_Document_Template__c=ipdoctem.ID;
        secMast.IPM_Section_Sequence__c='1.1';
        secMast.IPM_Section_Name__c='Idea / Graphic';
        secMast.IPM_Negotiable__c=false;
        insert secMast;
        
        IPM_Task__c taskAsociatedRD = new IPM_Task__c(IPM_Type_of_Gate__c = 'Charter',IPM_Phase__c = 'Ideas',
                                                      IPM_Task_Complexity__c = 'Full',Name= '-Identify top 3 strategic channels',
                                                      IPM_Function__c = 'R&D',IPM_Task_Name__c ='Develop and lock Concept1',
                                                      IPM_Project_Template__c = projTemplate.Id,IPM_Section__c = secMast.Id
                                                     );
        
        IPM_Task__c taskAsociatedFinance = new IPM_Task__c(IPM_Type_of_Gate__c = 'Charter',IPM_Phase__c = 'Ideas',
                                                           IPM_Task_Complexity__c = 'Full',Name= 'Identify Finance',
                                                           IPM_Function__c = 'Finance',IPM_Task_Name__c ='Develop and lock Concept2',
                                                           IPM_Project_Template__c = projTemplate.Id,IPM_Section__c = secMast.Id
                                                          );
        
        taskList.add(taskAsociatedRD);
        taskList.add(taskAsociatedFinance);
        insert taskList;
        
        IPM_Project__c project1 = new IPM_Project__c(Name='TestComments1',IPM_PM_Approach__c= IPM_Utils.Internal,IPM_Project_Leader__c = projectLeader.Id,
                                                     IPM_Phase__c='Ideas',IPM_Complexity__c='Full',IPM_GateKeeping_Model__c='Both');
        
        
        projectList.add(project1);
        insert projectList;
        
        IPM_Project_Document__c projectDocList1 = new IPM_Project_Document__c(Name='TESTAPPROVERCL-Charter1',IPM_Project__c=projectList[0].Id,
                                                                              IPM_Project_Template__c= projTemplate.Id,IPM_GateDocuments__c='Charter',
                                                                              IPM_Approval_Date__c=System.today(),IPM_Approved_Comments__c='Approved'
                                                                             );
        projectDocList.add(projectDocList1);
        insert projectDocList;

        // Creationg Project Document Sections
        IPM_Project_Document_Section__c pojDocSection0 = new IPM_Project_Document_Section__c(IPM_Project_Document__c=projectDocList[0].Id,
                                                                                             IPM_Section_Name__c='Idea / Graphic',
                                                                                             IPM_Section__c=secMast.Id,
                                                                                             IPM_Default_Section__c=true);
        projectDocSectionList.add(pojDocSection0);
        insert projectDocSectionList;
    } 
    
    /***********************************
    * @Description: validate Resource Sharing functionality
    * *********************************/
    public static testmethod void testResourceSharing()
    {
        Test.startTest();
        createTestData();
        Test.stopTest();
        // Add Resources to Project to create Tasks for resources.
        IPM_Project_Resource__c ipmProjectResource1 = new IPM_Project_Resource__c(IPM_Role_Type__c = 'Finance',IPM_Project__c = projectList[0].Id,
                                                                                  IPM_User__c = userList[1].Id,IPM_Project_Role_Owner__c = true);
        
        IPM_Project_Resource__c ipmProjectResource2 = new IPM_Project_Resource__c(IPM_Role_Type__c = 'R&D',IPM_Project__c = projectList[0].Id,
                                                                                  IPM_User__c = userList[2].Id,IPM_Project_Role_Owner__c = true);
        
        projectResourceList.add(ipmProjectResource1);
        projectResourceList.add(ipmProjectResource2);
        insert projectResourceList;
        
        System.runAs(userList[0]){
            update projectList[0];
            
            // Update the User information and assign it to someone else and verify whether tasks are reAllocated.        
            projectResourceList[0].IPM_User__c  = userList[3].Id;
            
            update projectResourceList;
            
            list<IPM_Task__c> tasksList = [SELECT IPM_Assignee__c, IPM_Function__c, IPM_Project__c FROM IPM_Task__c 
                                           WHERE IPM_Project__c = :projectList[0].Id AND IPM_Completed__c != true];
            
            // Validate if the Tasks have been reassigned.
            for(IPM_Task__c task : tasksList ){
                if(task.IPM_Function__c == 'Finance')
                {
                    System.assertEquals(task.IPM_Assignee__c,userList[3].Id);
                    System.assertNotEquals(task.IPM_Assignee__c,userList[1].Id);
                }
            }
        }
    }

//Testmethod to test IPM Project Resource History for Bulk insertion of project resources
    static testMethod void testProjectResourceHistoryForBulkInsertion(){
        //Initialize test data
        createTestData();
        Test.startTest();
        
        // Add Resources to Project to 
        IPM_Project_Resource__c ipmProjectResource1 = new IPM_Project_Resource__c(IPM_Role_Type__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE,IPM_Project__c = projectList[0].Id,
                                                                                  IPM_User__c = userList[1].Id,IPM_Project_Role_Owner__c = true);
        
        IPM_Project_Resource__c ipmProjectResource2 = new IPM_Project_Resource__c(IPM_Role_Type__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_RD,IPM_Project__c = projectList[0].Id,
                                                                                  IPM_User__c = userList[2].Id,IPM_Project_Role_Owner__c = true);
        
        IPM_Project_Resource__c ipmProjectResource3 = new IPM_Project_Resource__c(IPM_Role_Type__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_CD,IPM_Project__c = projectList[0].Id,
                                                                                  IPM_User__c = userList[3].Id,IPM_Project_Role_Owner__c = true);
        
        IPM_Project_Resource__c ipmProjectResource4 = new IPM_Project_Resource__c(IPM_Role_Type__c =  IPM_ConstantUtils.FUNCTIONAL_ROLE_BD,IPM_Project__c = projectList[0].Id,
                                                                                  IPM_User__c = userList[4].Id,IPM_Project_Role_Owner__c = true);
        
        IPM_Project_Resource__c ipmProjectResource5 = new IPM_Project_Resource__c(IPM_Role_Type__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_CMI,IPM_Project__c = projectList[0].Id,
                                                                                  IPM_User__c = userList[5].Id,IPM_Project_Role_Owner__c = true);
        
        projectResourceList.add(ipmProjectResource1);
        projectResourceList.add(ipmProjectResource2);
        projectResourceList.add(ipmProjectResource3);
        projectResourceList.add(ipmProjectResource4);
        projectResourceList.add(ipmProjectResource5);
        insert projectResourceList;
        
        List<IPM_Project_Resource_History__c> resourceHistoryList = [Select Id,Type__c from IPM_Project_Resource_History__c where IPM_Project__c =: projectList[0].Id];
        System.assertEquals(5, resourceHistoryList.size(), RESOURCE_HISTORY_INSERTED);
        
        for(IPM_Project_Resource_History__c resourceHistory : resourceHistoryList){
            System.assertEquals(IPM_ConstantUtils.HISTORY_INSERTED, resourceHistory.Type__c, RESOURCE_HISTORY_INSERTED);
        }
        Test.stopTest();
    }
    
     //Testmethod to test IPM Project Resource History for Bulk updation of project resources
    static testMethod void testProjectResourceHistoryForBulkUpdation(){
        Integer updateCount =0;
         
        //Initialize test data
        createTestData();
        Test.startTest();
        
        // Add Resources to Project to 
        IPM_Project_Resource__c ipmProjectResource1 = new IPM_Project_Resource__c(IPM_Role_Type__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE,IPM_Project__c = projectList[0].Id,
                                                                                  IPM_User__c = userList[1].Id,IPM_Project_Role_Owner__c = true);
        
        IPM_Project_Resource__c ipmProjectResource2 = new IPM_Project_Resource__c(IPM_Role_Type__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_RD,IPM_Project__c = projectList[0].Id,
                                                                                  IPM_User__c = userList[2].Id,IPM_Project_Role_Owner__c = true);
        
        IPM_Project_Resource__c ipmProjectResource3 = new IPM_Project_Resource__c(IPM_Role_Type__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_CD,IPM_Project__c = projectList[0].Id,
                                                                                  IPM_User__c = userList[3].Id,IPM_Project_Role_Owner__c = true);
        
        IPM_Project_Resource__c ipmProjectResource4 = new IPM_Project_Resource__c(IPM_Role_Type__c =  IPM_ConstantUtils.FUNCTIONAL_ROLE_BD,IPM_Project__c = projectList[0].Id,
                                                                                  IPM_User__c = userList[4].Id,IPM_Project_Role_Owner__c = true);
        
        IPM_Project_Resource__c ipmProjectResource5 = new IPM_Project_Resource__c(IPM_Role_Type__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_CMI,IPM_Project__c = projectList[0].Id,
                                                                                  IPM_User__c = userList[5].Id,IPM_Project_Role_Owner__c = true);
        
        projectResourceList.add(ipmProjectResource1);
        projectResourceList.add(ipmProjectResource2);
        projectResourceList.add(ipmProjectResource3);
        projectResourceList.add(ipmProjectResource4);
        projectResourceList.add(ipmProjectResource5);
        insert projectResourceList;
        
        List<IPM_Project_Resource_History__c> resourceHistoryList = [Select Id from IPM_Project_Resource_History__c where IPM_Project__c =: projectList[0].Id];
        System.assertEquals(5, resourceHistoryList.size(), RESOURCE_HISTORY_INSERTED);
        
        List<IPM_Project_Resource__c> lstResourceToUpdate = new List<IPM_Project_Resource__c>();
        for(IPM_Project_Resource__c eachResource : projectResourceList){
                eachResource.IPM_Project_Role_Owner__c = false;
                lstResourceToUpdate.add(eachResource);
        }
        update lstResourceToUpdate;
        
        resourceHistoryList = [Select Id,Type__c from IPM_Project_Resource_History__c where IPM_Project__c =: projectList[0].Id];
        
        for(IPM_Project_Resource_History__c resourceHistory : resourceHistoryList){
            if(IPM_ConstantUtils.HISTORY_UPDATED == resourceHistory.Type__c )
                updateCount++;
        }
        System.assertEquals(5, updateCount, RESOURCE_HISTORY_UPDATED);
        Test.stopTest();
    }
}