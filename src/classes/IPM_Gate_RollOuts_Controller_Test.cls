/*******************************************************
 * @Description: Test class for IPM_Gate_RollOuts_Controller
 * @Author:Cognizant
 * @Date:05/08/2015
 * *****************************************************/

@isTest
public class IPM_Gate_RollOuts_Controller_Test{

   
     public static list<IPM_Country__c> countryList;
    
    /*******************************************************
     * @Description: Method to initilize data
     * *****************************************************/
   
     public testmethod static void projectSetUp() 
     {
  
        List<User> userList = IPM_TestFactory_Helper.createUserList();
         
        IPM_TestFactory_Helper.getProjectMasterData();
         
        List<IPM_Project__c> projectList = IPM_TestFactory_Helper.projectSetUp(1,userList[0]);
        System.runAs(userList[0])
        {
            insert projectList;
        }   
        
        system.assertEquals(projectList.size(),1,'Projects are created'); 
        System.runAs(userList[0])
        {
            // Create Regional Rollouts for Created Global project.
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{userList[1],userList[1],userList[1]});
            insert regionalRolloutList;
            
            
            system.assertEquals(regionalRolloutList.size(),2);
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
               
            }
            
           // Create local Rollouts for Created regional Rollouts.
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{userList[2]});  
            insert localRolloutList; 
           
            system.assertEquals(localRolloutList.size(),2,'Local Rollouts Created');
            
            // Create Country specific information.
             countryList= new List<IPM_Country__c>();
            
            for(IPM_Project_Rollout__c localRolloutObj : localRolloutList)
            {
                String geoExternalId = '';
                if(localRolloutObj.IPM_Rollout_Project__c.contains('AFR'))
                {
                    geoExternalId = 'AG';
                }
                else if(localRolloutObj.IPM_Rollout_Project__c.contains('LA'))
                {
                    geoExternalId = 'BR';
                }
                MDO_Geography__c mdo = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId);
                IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo.id,
                IPM_Project__c = localRolloutObj.IPM_Project__c,local_Rollout__c = localRolloutObj.Id,IPM_Rollout_Status__c = 'With MCO');    
                
                countryList.add(tempCountry);
            }
            
            insert countryList;
            
            
            List<IPM_Gate_RollOuts_Controller.LocalRolloutWrapper> lstLocalWrapper = new List<IPM_Gate_RollOuts_Controller.LocalRolloutWrapper>();
            IPM_Gate_RollOuts_Controller.LocalRolloutWrapper localRolloutWrapper = new IPM_Gate_RollOuts_Controller.LocalRolloutWrapper(localRolloutList[0],countryList);
            lstLocalWrapper.add(localRolloutWrapper);
            IPM_Gate_RollOuts_Controller.RegionalRollOutWrapper regionalRolloutWrapper = new IPM_Gate_RollOuts_Controller.RegionalRollOutWrapper(regionalRolloutList[0],lstLocalWrapper); // NO SONAR used to cover the test coverage of constructor  
            IPM_Gate_RollOuts_Controller gateController = new IPM_Gate_RollOuts_Controller(); 
            gateController.proId = projectList[0].Id; 
           
          
           
        }
     }
     
  	}