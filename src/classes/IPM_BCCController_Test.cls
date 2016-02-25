/*************************************************************
*@Author:Cognizant
*@Date:October 2014
*@Description : To test IPM_BCCController class for Local Projects
*************************************************************/

@isTest
public class  IPM_BCCController_Test {
    public static IPM_Project__c project;// Project object initialization
    public static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
    public static PageReference pRef;
    private static user testUser;
    public static List<IPM_Country__c> countryList=new List<IPM_Country__c>();
    private static IPM_BCCController ipmBcc;
    public static IPM_Financial__c fin=new IPM_Financial__c();
    private static string LOCAL_STR='Local';
    private static string REGIONAL_STR='Regional';
    private static String geoExternalId = '';
    private static MDO_Geography__c mdo;
    /*************************************************************************
    @Description : to Intialize(insert) the data for Project, 
        IPM_Project_Rollout__c, IPM_Financial__c objects
***************************************************************************/
    public static void initializeData(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            testUser= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        
        List<User>userLists=[SELECT id FROM user WHERE id=:testUser.id LIMIT 1];
        System.AssertEquals(userLists[0].id, testUser.id,'user id is:'+userLists[0].id);//positive test
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,testUser);
        System.runAs(testUser) {
            insert projectList;
            project=projectList[0];
            List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
            System.assertEquals(projlList1[0].Name,'TestComments1','project inserted');//positive test
            
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{testUser,testUser,testUser});
            insert regionalRolloutList;
            List<IPM_Project_Rollout__c> proRegListObj=[SELECT IPM_Rollout_Span__c from IPM_Project_Rollout__c WHERE ID =:regionalRolloutList[0].ID LIMIT 1];
            System.assertEquals(proRegListObj[0].IPM_Rollout_Span__c,REGIONAL_STR,'regional rollout created');//positive test
            
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
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{testUser});  
            
            insert localRolloutList; 
            List<IPM_Project_Rollout__c> proLocListObj=[SELECT IPM_Rollout_Span__c from IPM_Project_Rollout__c WHERE ID =:localRolloutList[0].ID LIMIT 1];
            System.assertEquals(proLocListObj[0].IPM_Rollout_Span__c,LOCAL_STR,'local rollout created');//positive test
            
            // Create Country specific information.
            mdo = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId);
            
            for(IPM_Project_Rollout__c localRolloutObj : localRolloutList)
            {
                
                if(localRolloutObj.IPM_Rollout_Project__c.contains('AFR'))
                {
                    geoExternalId = 'AG';
                }
                else if(localRolloutObj.IPM_Rollout_Project__c.contains('LA'))
                {
                    geoExternalId = 'BR';
                }
                
                IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo.id,
                IPM_Project__c = localRolloutObj.IPM_Project__c,local_Rollout__c = localRolloutObj.Id,IPM_Rollout_Status__c = 'With MCO');    
                countryList.add(tempCountry);
            }
            
            insert countryList;
            
            List<IPM_Country__c>counList=[select Id,IPM_Rollout_Status__c from IPM_Country__c where Id=:countryList[0].Id limit 1];
            system.assertEquals(counList[0].IPM_Rollout_Status__c,'With MCO','country inserted');
            

            project.IPM_Target_Launch_Dates__c=system.today();
            update project;
            
            List<IPM_Project__c> proListObj=[SELECT IPM_Target_Launch_Dates__c from IPM_Project__c WHERE ID=:project.ID LIMIT 1];
            System.assertEquals(proListObj[0].IPM_Target_Launch_Dates__c,system.today(),'project updated successfully');//positive test
            
            String strRecordTypeId1=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
            fin = IPM_TestFactory_Helper.createIPMFinancial(FALSE);
            fin.RecordTypeId=strRecordTypeId1;
            fin.IPM_Project_Rollout__c=regionalRolloutList[0].Id;
            fin.Parent_Project__c=project.Id;
            fin.Project_Sustainability_Period__c = '3';
            fin.Local_Project__c=project.Id;
            fin.isActive__c=true;
            insert fin;
            
            List<IPM_Financial__c> finListObj=[SELECT Local_Project__c,ID,Project_Sustainability_Period__c,RecordTypeId,IPM_Project_Rollout__c,Parent_Project__c from IPM_Financial__c WHERE ID=:fin.ID LIMIT 1];
            System.assertEquals(finListObj[0].Local_Project__c,project.Id,'finance data created');//positive test
            
            pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getParameters().put('Id',project.Id);
            Test.setCurrentPage(pRef);
            ipmBcc=new IPM_BCCController();
            ipmBcc.isPDFDownload=true;
            
        }
    }

    /*******************************************************************************************************
* @description: testMethod to save data 
*/
    public static testMethod void doSave(){
        initializeData();
        Test.startTest();
        system.RunAs(testUser){
            ipmBcc.finance=fin;
            ipmBcc.projList=new List<IPM_Project__c>();
            ipmBcc.projList=projectList;
            ipmBcc.tldAlignment=true;
            ipmBcc.save();
            List<IPM_Financial__c> finConList=[select Local_Project__c from IPM_Financial__c where id=:ipmBcc.finance.Id ];
            system.assertEquals(finConList[0].Local_Project__c ,fin.Local_Project__c,'save successfully');
            ipmBcc.finance.IPM_Business_Case_Confirmed__c=null;
            ipmBcc.save();
            List<IPM_Financial__c> finConLists=[select IPM_Business_Case_Confirmed__c from IPM_Financial__c where id=:ipmBcc.finance.Id ];
            system.assertNotEquals(finConLists[0].IPM_Business_Case_Confirmed__c,true,'status should not be changed');//negative test
           
            Test.stopTest();
        }
    }

    /*******************************************************************************************************
* @description: testMethod to save data 
*/
    public static testMethod void doChangeStatus(){
        initializeData();
        Test.startTest();
        system.RunAs(testUser){
        	
            ipmBcc.finance=fin;
            ipmBcc.projList=new List<IPM_Project__c>();
            ipmBcc.projList=projectList;
            ipmBcc.changeStatus();
            ipmBcc.hideSaveMsg();
            List<IPM_Financial__c> finConList=[select IPM_Business_Case_Confirmed__c from IPM_Financial__c where id=:ipmBcc.finance.Id ];
            system.assert(finConList[0].IPM_Business_Case_Confirmed__c,'status changed');
            ipmBcc.finance.id=null;
            ipmBcc.changeStatus();
            List<IPM_Financial__c> finConLists=[select IPM_Business_Case_Confirmed__c from IPM_Financial__c where id=:fin.Id ];
            system.assertNotEquals(finConLists.size()>0,true,'status should not be changed for financial');//negative test
           
            Test.stopTest();
        }
    }


}