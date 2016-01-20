/*******************************************************
 * @Description: Test class for IPMRolloutTriggerHandler
 * @Author:Cognizant
 * @Date:05/08/2015
 * *****************************************************/
@isTest
public class IPM_RolloutTriggerHandler_Test {
    
    public static IPM_Project__c project;
    public static IPM_Project_Rollout__c proRoll=new IPM_Project_Rollout__c();
    public static IPM_Project_Rollout__c proRollLocal=new IPM_Project_Rollout__c();
    public static IPM_Project_Rollout__c proRollRegional=new IPM_Project_Rollout__c();
    public static List<IPM_Project_Rollout__c> regionalRolloutList = new List<IPM_Project_Rollout__c>();
    public static List<IPM_Project_Rollout__c> regionalRolloutListOld = new List<IPM_Project_Rollout__c>();
    public static List<IPM_Project_Rollout__c> lstProjectRollouts=new List<IPM_Project_Rollout__c>();
    public static Map<Id, IPM_Project_Rollout__c> mapNewProjectRollouts=new Map<Id, IPM_Project_Rollout__c>();
    public static Map<Id, IPM_Project_Rollout__c> mapOldProjectRollouts=new Map<Id, IPM_Project_Rollout__c>(); // create another rollout and put it into this then update will work dont delete
    
    /***********************************
    * @Description: Test Data Creation
    * *********************************/
      @testSetup static void projectSetUp() 
     {
     
        List<User> userList = IPM_TestFactory_Helper.createUserList();
        
        
         
        List<IPM_Project__c> projectList = IPM_TestFactory_Helper.projectSetUp(3,userList[0]);
        
        System.runAs(userList[0])
        {
            insert projectList;
        }   
        
        
        
        
        IPM_TestFactory_Helper.getProjectMasterData();
        System.runAs(userList[0])
        {
            // Create Regional Rollouts for Created Global project.
            regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{userList[1],userList[1],userList[1]});
            insert regionalRolloutList;
            
           
            
            Map<Id,List<IPM_Project_Rollout__c>> projectToRolloutMap = new Map<Id,List<IPM_Project_Rollout__c>>();
            for(IPM_Project_Rollout__c projectRollout : regionalRolloutList)
            {
                List<IPM_Project_Rollout__c> projectRolloutList = new List<IPM_Project_Rollout__c>();
                if(projectToRolloutMap.containsKey(projectRollout.IPM_Project__c))
                {
                    projectRolloutList = projectToRolloutMap.get(projectRollout.IPM_Project__c);
                }
                projectRolloutList.add(projectRollout);
                projectToRolloutMap.put(projectRollout.IPM_Project__c,projectRolloutList);
                mapNewProjectRollouts.put(projectRollout.IPM_Project__c,projectRollout);
               
               
            }
              
            // Create local Rollouts for Created regional Rollouts.
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{userList[2]});  
            insert localRolloutList; 
            
            
            
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>();
            
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                String geoExternalId = '';
                if(localRollout.IPM_Rollout_Project__c.contains('AFR'))
                {
                    geoExternalId = 'AG';
                }
                else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
                {
                    geoExternalId = 'BR';
                }
                
                //MDO_Geography__c mdo = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId);
               
                
                IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId).Id,
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
                
                countryList.add(tempCountry);
            }
            
            insert countryList;
       
        }
     }
     
 
    /***********************************
    * @Description: Test method invoke
    * *********************************/
   
     static testMethod void dotestRegional(){
        test.startTest();
        //initializeData();
        //lstProjectRollouts.add(proRollRegional);
       
        
        IPM_RolloutTriggerHandler ipmRollHand=new IPM_RolloutTriggerHandler();
        ipmRollHand.processUpdate(mapNewProjectRollouts,mapNewProjectRollouts);
        
        ipmRollHand.processInsert(regionalRolloutList);
        ipmRollHand.processDelete(regionalRolloutList);
       
        List<IPM_Project_Rollout__c> projRollOutList=[SELECT ID,RecordTypeId,IPM_Rollout_Project__c,Market_Cluster__c,Target_Launch_Date__c,IPM_Regional_PL__c FROM IPM_Project_Rollout__c limit 1000];
        System.assertEquals(projRollOutList.size(), 12,'one rollout deleted');
        test.stopTest(); 
    }
    
    
    
}