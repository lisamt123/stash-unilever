/*
 * @Description displaying Financial Action Standards 
*               in the gate document
*/  
@isTest
private class  IPM_FinancialActionStandards_Test {
    
    @testSetup static void financialSetUp() {
         List<User> userList = IPM_TestFactory_Helper.createUserList();
         
         IPM_TestFactory_Helper.getProjectMasterData();
         
         List<IPM_Project__c> globalProjectList = IPM_TestFactory_Helper.projectSetUp(1,userList[0]);
         System.runAs(userList[0])
         {
            insert globalProjectList;
         }
         
        System.runAs(userList[0])
        {
            // Create Regional Rollouts for Created Global project.
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,globalProjectList,new List<User>{userList[1],userList[1],userList[1]});
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
                    geoExternalId = 'AGO';
                }
                else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
                {
                    geoExternalId = 'BRA';
                }
                
                IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new mdm_Geography__c(ISO_3166_1_Code__c = geoExternalId).Id,
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
                
                countryList.add(tempCountry);
            }
            
            insert countryList;
        }
        
        List<IPM_Project__c> regionalProjectList = IPM_TestFactory_Helper.projectSetUpRegional(1,UserList[1]);
         
        System.runAs(userList[1])
        {
            insert regionalProjectList;
        }
         
     }
    
     static testMethod void financialGlobalOrignalTest()
     {      
        Set<String> projectNameSet = new Set<String>{'TestComments1'};

        User globalUser = [Select Id from User where Email ='globalUser@unilever.test.com' limit 1]; 
        System.runAs(globalUser)
        {
            List<IPM_Project__c>  projectList = [Select Id,Name,IPM_Phase__c,(Select Id from Project_Documents__r),(Select Id,Name,recordTypeId,IPM_Project_Job_Status__c from IPM_Project_Rollout__r) from IPM_Project__c where Name in:projectNameSet];
            
            Set<Id> projDocIdSet = new Set<Id>();
            
            for(IPM_Project__c project : projectList){
                for(IPM_Project_Document__c projDoc : project.Project_Documents__r){
                    projDocIdSet.add(projDoc.Id);
                }
            }
            
            List<IPM_Project_Document_Section__c> ipmProjDocSectionList = [Select Id from IPM_Project_Document_Section__c WHERE IPM_Project_Document__c IN: projDocIdSet];
            
            // Get one record of Project Doument Section Content which are to be updated.
            List<IPM_Project_Document_Section_Content__c> ipmProjectDocSectContentList = [Select Id,IPM_Content_Type__c ,IPM_Payback_Action_Standard_Charter_Cmts__c, IPM_Inov_Value_Share_Action_Charter_Cmts__c, IPM_Inc_Val_Share_Action_Charter_Cmts__c, IPM_gTO_Action_Standard_Charter_Cmts__c, IPM_iTo_Action_Standard_Charter_Cmts__c, 
                                                                                                IPM_GM_Action_Standards_Charter_Cmts__c, IPM_NPV_Action_Standard_Charter_Cmts__c, IPM_IRR_Action_Standard_Charter_Cmts__c from IPM_Project_Document_Section_Content__c WHERE IPM_Project_Document_Section__c IN : ipmProjDocSectionList limit 1];
            
            System.assertEquals(ipmProjectDocSectContentList[0].IPM_Content_Type__c,IPM_ConstantUtils.FINANCIAL_ACTION_STANDARDS, 'Content Type Financial Action Standard');
            
            Test.startTest();
            
            PageReference pageRef = Page.IPM_Financial;
            Test.setCurrentPageReference(pageRef);  
            ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, projectList[0].Id);
            
            
            IPM_FinancialActionStandards ipmFinController = new IPM_FinancialActionStandards();
            ipmFinController.projDocSecId = ipmProjDocSectionList[0].Id;
            ipmFinController.setprojectId (projectList[0].Id);
            ipmFinController.editTable = true;
            
            // Set the project document section content id
            ID proDocSectionContentId = ipmProjectDocSectContentList[0].Id;
            ipmFinController.conId = proDocSectionContentId;
            
            // When comment value is Innovation
            ipmFinController.commentField = IPM_FinancialActionStandards.COMMENT_INNOVATION;
            ipmFinController.comments = 'Test Comments';
            ipmFinController.isComment = true;
            ipmFinController.updateActionStandards();
            
            IPM_Project_Document_Section_Content__c proDocSectionContent = [ Select IPM_Inov_Value_Share_Action_Charter_Cmts__c,IPM_Innov_Value_Share_Action_Charter__c 
                                                                             from IPM_Project_Document_Section_Content__c 
                                                                             where id=:proDocSectionContentId ];
            System.assertEquals('Test Comments',proDocSectionContent.IPM_Inov_Value_Share_Action_Charter_Cmts__c,'IPM_Inov_Value_Share_Action_Charter_Cmts__c values match');
            
            
            ipmFinController.commentField = IPM_FinancialActionStandards.COMMENT_INNOVATION;
            ipmFinController.numvalue = 5;
            ipmFinController.isComment = false;
            ipmFinController.updateActionStandards();
            proDocSectionContent = [ Select IPM_Inov_Value_Share_Action_Charter_Cmts__c,IPM_Innov_Value_Share_Action_Charter__c 
                                     from IPM_Project_Document_Section_Content__c 
                                     where id=:proDocSectionContentId ];
            System.assertEquals(5,proDocSectionContent.IPM_Innov_Value_Share_Action_Charter__c,'IPM_Innov_Value_Share_Action_Charter__c value valid');
            
            // When comment value is Incremental 
            ipmFinController.commentField = IPM_FinancialActionStandards.COMMENT_INCREMENTAL;
            ipmFinController.isComment = true;
            ipmFinController.comments = 'Test Comments1';
            ipmFinController.updateActionStandards();
            proDocSectionContent = [ Select IPM_Inc_Val_Share_Action_Charter_Cmts__c,IPM_Innov_Value_Share_Action_Charter__c 
                                     from IPM_Project_Document_Section_Content__c 
                                     where id=:proDocSectionContentId ];
            System.assertEquals('Test Comments1',proDocSectionContent.IPM_Inc_Val_Share_Action_Charter_Cmts__c,'IPM_Inov_Value_Share_Action_Charter_Cmts__c value  match');
            
            
            ipmFinController.commentField = IPM_FinancialActionStandards.COMMENT_INCREMENTAL;
            ipmFinController.numvalue = 5;
            ipmFinController.isComment = false;
            ipmFinController.updateActionStandards();
            proDocSectionContent = [ Select IPM_Inc_Val_Share_Action_Charter_Cmts__c,IPM_Innov_Value_Share_Action_Charter__c 
                                     from IPM_Project_Document_Section_Content__c 
                                     where id=:proDocSectionContentId ];
            System.assertEquals(5,proDocSectionContent.IPM_Innov_Value_Share_Action_Charter__c,'IPM_Innov_Value_Share_Action_Charter__c value  valid');
            
            
            // When comment value is GTO
            ipmFinController.commentField = IPM_FinancialActionStandards.COMMENT_GTO;
            ipmFinController.isComment = true;
            ipmFinController.comments = 'Test Comments2';
            ipmFinController.updateActionStandards();
            proDocSectionContent = [ Select IPM_gTO_Action_Standard_Charter__c,IPM_gTO_Action_Standard_Charter_Cmts__c 
                                     from IPM_Project_Document_Section_Content__c 
                                     where id=:proDocSectionContentId ];
            System.assertEquals('Test Comments2',proDocSectionContent.IPM_gTO_Action_Standard_Charter_Cmts__c, 'gto Comments  match');
            
            ipmFinController.commentField = IPM_FinancialActionStandards.COMMENT_GTO;
            ipmFinController.numvalue = 5;
            ipmFinController.isComment = false;
            ipmFinController.updateActionStandards();
            proDocSectionContent = [ Select IPM_gTO_Action_Standard_Charter__c,IPM_gTO_Action_Standard_Charter_Cmts__c 
                                     from IPM_Project_Document_Section_Content__c 
                                     where id=:proDocSectionContentId ];
            System.assertEquals(5,proDocSectionContent.IPM_gTO_Action_Standard_Charter__c,'IPM_gTO_Action_Standard_Charter__c value  match');
            
            // When comment value is ITO
            ipmFinController.commentField = IPM_FinancialActionStandards.COMMENT_ITO;
            ipmFinController.isComment = true;
            ipmFinController.comments = 'Test Comments3';
            ipmFinController.updateActionStandards();
            proDocSectionContent = [ Select IPM_iTo_Action_Standard_Charter_Cmts__c,IPM_iTo_Action_Standard_Charter__c 
                                     from IPM_Project_Document_Section_Content__c 
                                     where id=:proDocSectionContentId ];
            System.assertEquals('Test Comments3',proDocSectionContent.IPM_iTo_Action_Standard_Charter_Cmts__c,'IPM_iTo_Action_Standard_Charter_Cmts__c value  match');
            
            ipmFinController.commentField = IPM_FinancialActionStandards.COMMENT_ITO;
            ipmFinController.numvalue = 5;
            ipmFinController.isComment = false;
            ipmFinController.updateActionStandards();
            proDocSectionContent = [ Select IPM_iTo_Action_Standard_Charter_Cmts__c,IPM_iTo_Action_Standard_Charter__c 
                                     from IPM_Project_Document_Section_Content__c 
                                     where id=:proDocSectionContentId ];
            System.assertEquals(5,proDocSectionContent.IPM_iTo_Action_Standard_Charter__c,'IPM_iTo_Action_Standard_Charter__c value  match');
            
            // When comment value is GM
            ipmFinController.commentField = IPM_FinancialActionStandards.COMMENT_GM;
            ipmFinController.isComment = true;
            ipmFinController.comments = 'Test Comments4';
            ipmFinController.updateActionStandards();
            proDocSectionContent = [ Select IPM_GM_Action_Standards_Charter_Cmts__c,IPM_GM_Action_Standards_Charter__c 
                                     from IPM_Project_Document_Section_Content__c 
                                     where id=:proDocSectionContentId ];
            System.assertEquals('Test Comments4',proDocSectionContent.IPM_GM_Action_Standards_Charter_Cmts__c,'IPM_GM_Action_Standards_Charter_Cmts__c  match');
            
            ipmFinController.commentField = IPM_FinancialActionStandards.COMMENT_GM;
            ipmFinController.numvalue = 5;
            ipmFinController.isComment = false;
            ipmFinController.updateActionStandards();
            proDocSectionContent = [ Select IPM_GM_Action_Standards_Charter_Cmts__c,IPM_GM_Action_Standards_Charter__c 
                                     from IPM_Project_Document_Section_Content__c 
                                     where id=:proDocSectionContentId ];
            System.assertEquals(5,proDocSectionContent.IPM_GM_Action_Standards_Charter__c,'IPM_GM_Action_Standards_Charter__c value  match');
            
            // When comment value is NPV
            ipmFinController.commentField = IPM_FinancialActionStandards.COMMENT_NPV;
            ipmFinController.isComment = true;
            ipmFinController.comments = 'Test Comments5';
            ipmFinController.updateActionStandards();        
            proDocSectionContent = [ Select IPM_NPV_Action_Standard_Charter_Cmts__c,IPM_NPV_Action_Standard_Charter__c 
                                     from IPM_Project_Document_Section_Content__c 
                                     where id=:proDocSectionContentId ];
            System.assertEquals('Test Comments5',proDocSectionContent.IPM_NPV_Action_Standard_Charter_Cmts__c,'IPM_NPV_Action_Standard_Charter_Cmts__c value  set properly');
            
            ipmFinController.commentField = IPM_FinancialActionStandards.COMMENT_NPV;
            ipmFinController.numvalue = 5;
            ipmFinController.isComment = false;
            ipmFinController.updateActionStandards();
            proDocSectionContent = [ Select IPM_NPV_Action_Standard_Charter_Cmts__c,IPM_NPV_Action_Standard_Charter__c 
                                     from IPM_Project_Document_Section_Content__c 
                                     where id=:proDocSectionContentId ];
            System.assertEquals(5,proDocSectionContent.IPM_NPV_Action_Standard_Charter__c,'IPM_NPV_Action_Standard_Charter__c value  set');
            
            // When comment value is IRR
            ipmFinController.commentField = IPM_FinancialActionStandards.COMMENT_IRR;
            ipmFinController.isComment = true;
            ipmFinController.comments = 'Test Comments5';
            ipmFinController.updateActionStandards();
            proDocSectionContent = [ Select IPM_IRR_Action_Standard_Charter_Cmts__c,IPM_IRR_Action_Standard_Charter__c 
                                     from IPM_Project_Document_Section_Content__c 
                                     where id=:proDocSectionContentId ];
            System.assertEquals('Test Comments5',proDocSectionContent.IPM_IRR_Action_Standard_Charter_Cmts__c,'IPM_IRR_Action_Standard_Charter_Cmts__c value  set');
            
            
            ipmFinController.commentField = IPM_FinancialActionStandards.COMMENT_IRR;
            ipmFinController.numvalue = 5;
            ipmFinController.isComment = false;
            ipmFinController.updateActionStandards();
            proDocSectionContent = [ Select IPM_IRR_Action_Standard_Charter_Cmts__c,IPM_IRR_Action_Standard_Charter__c 
                                     from IPM_Project_Document_Section_Content__c 
                                     where id=:proDocSectionContentId ];
            System.assertEquals(5,proDocSectionContent.IPM_IRR_Action_Standard_Charter__c,'IPM_IRR_Action_Standard_Charter__c value  set');
            
            // When comment value is Payback
            ipmFinController.commentField = IPM_FinancialActionStandards.COMMENT_PAYBACK;
            ipmFinController.isComment = true;
            ipmFinController.comments = 'Test Comments6';
            ipmFinController.updateActionStandards();
            proDocSectionContent = [ Select IPM_Payback_Action_Standard_Charter_Cmts__c,IPM_Payback_Action_Standard_Charter__c 
                                     from IPM_Project_Document_Section_Content__c 
                                     where id=:proDocSectionContentId ];
            System.assertEquals('Test Comments6',proDocSectionContent.IPM_Payback_Action_Standard_Charter_Cmts__c,'IPM_Payback_Action_Standard_Charter_Cmts__c value  updated');
            
            ipmFinController.commentField = IPM_FinancialActionStandards.COMMENT_PAYBACK;
            ipmFinController.numvalue = 5;
            ipmFinController.isComment = false;
            ipmFinController.updateActionStandards();
            proDocSectionContent = [ Select IPM_Payback_Action_Standard_Charter_Cmts__c, IPM_Payback_Action_Standard_Charter__c 
                                     from IPM_Project_Document_Section_Content__c 
                                     where id=:proDocSectionContentId ];
            System.assertEquals(5,proDocSectionContent.IPM_Payback_Action_Standard_Charter__c,'IPM_Payback_Action_Standard_Charter__c value  set');
                       
            Test.stopTest();
        } 
     }
}