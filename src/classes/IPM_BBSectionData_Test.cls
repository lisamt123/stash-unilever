/******************************************** 
*@Author:Cognizant
*@Date:26/10/2015
*@Description : To test IPM_CompanyCard class functionalities
*********************************************/
@isTest
public class  IPM_BBSectionData_Test{
    public static IPM_Project__c project;
    public static User bbSectionUser;
    
    /****************************************************************************************************************************
    *  @Description Initializing test data  
    *  @name initializeData
    *  @param None
    *  @return void
    */
    static void initializeData(){
        bbSectionUser=IPM_TestFactory_Helper.createUser(true);
        System.runAs(bbSectionUser){
        
            project = IPM_TestFactory_Helper.createIPMProject(FALSE);
             project.Sustainability_Period__c='3';
             project.IPM_Target_Launch_Dates__c=system.today();
             project.IPM_IsCompleted__c=true; 
             project.IPM_Project_Type__c='Original';
             
             project.IPM_Project_Name__c='ProjectName';
             project.IPM_Phase__c='Ideas';
        project.IPM_Brand_Positioning__c='Dirt Is Good';
       project.IPM_GateKeeping_Model__c='GCLT&RCLT';
       project.IPM_ProjectSubType__c='Innovation/Rennovation';
       project.IPM_Category_Text__c='Household Care';
        project.IPM_Project_Leader__c=bbSectionUser.Id;
        project.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
        insert project;

            IPM_Project__c projectObj=[select IPM_IsCompleted__c from IPM_Project__c where id=:project.Id LIMIT 1];
            system.assert(projectObj.IPM_IsCompleted__c,System.Label.IPM_Record_successfully_saved);
           
            
           
           
        }
    }
    /******************************************************************************
    *@Description :Testmethod To craete projecr,rollout,company card
    */
   static testMethod void dotest(){
        initializeData();
        System.runAs(bbSectionUser){
            test.startTest();
            PageReference pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getParameters().put('Id', project.Id);
            Test.setCurrentPage(pRef);
            IPM_BBSectionData con=new IPM_BBSectionData();
            
             
            List<IPM_project__c>proList1=[SELECT IPMProject_Span__c  FROM IPM_project__c WHERE id=:con.proid LIMIT 1];
           system.assertEquals(proList1[0].IPMProject_Span__c,IPM_ConstantUtils.PROJECT_SPAN_GLOBAL,'span should be global');
            
            project.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            update project;
            
            IPM_Project__c projectObj=[select IPMProject_Span__c from IPM_Project__c where id=:project.Id LIMIT 1];
            system.assertEquals(projectObj.IPMProject_Span__c,IPM_ConstantUtils.PROJECT_SPAN_REGIONAL,'Project Updated Successfully');
            
           
            
            IPM_BBSectionData conNew=new IPM_BBSectionData();
             List<IPM_project__c>proList2=[SELECT IPMProject_Span__c  FROM IPM_project__c WHERE id=:conNew.proid LIMIT 1];
           system.assertEquals(proList2[0].IPMProject_Span__c,IPM_ConstantUtils.PROJECT_SPAN_REGIONAL,'span should be regional');
        test.stopTest();
        }
    }
}