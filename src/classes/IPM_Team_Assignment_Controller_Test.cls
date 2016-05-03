/**
* @author Cognizant
* @date 23/04/2015
* @description This is a test class to verify the IPM Resource Allocation Revamp work
*/

@isTest
private class IPM_Team_Assignment_Controller_Test{
    private static IPM_Project__c project;
    private static IPM_Bosscard__c Bosscard;  
    public static final string FEASIBILITY_STR = 'Feasibility';
    public static List<IPM_Project__c> listIPMProjects;
    public static string projectId;
    public static IPM_Project_Resource__c  ipmProjectResource;
    public static IPM_Project_Resource__c  ipmProjectResource1;
    public static IPM_Project_Resource__c  ipmProjectResource2;
    public static IPM_Project_Resource__c  ipmProjectResource3;
    public static IPM_Project_Resource__c  ipmProjectResource4;
    public static IPM_Project_Resource__c  ipmProjectResource5;
    public static IPM_Project_Resource__c  ipmProjectResource6;

    /*****************************************************************************
    * @description Test Data
    */ 
    static void initializedData(){ 
        
        //insert new user to assign as project resource.
        User stnUser = IPM_TestFactory_Helper.createUser(true);
        system.assert(stnUser.id!=null);//positive test
        
        Bosscard=IPM_TestFactory_Helper.createIPMBosscard(TRUE);
        System.assert(Bosscard!=null);//positive test
        //insert a project with details
    
        project= IPM_TestFactory_Helper.createIPMProject(false);
        project.IPM_Selected_Project_Type__c='Operational';
        project.IPM_Project_Type__c ='Operational';
        project.IPM_Bosscard__c=Bosscard.id;
        project.IPM_Technical_Project_Leader__c =stnUser.Id;
        project.IPM_Project_Leader__c = userinfo.getuserid();
        project.Deputy_Project_Leader__c = userinfo.getuserid();
        project.IPM_Project_Gatekeeper__c = stnUser.Id;
        project.IPM_Project_Name__c='TESTAPPROVERCL';
        project.IPM_Phase__c= FEASIBILITY_STR;
        project.IPM_GateKeeping_Model__c='RCLT'; 
        project.Sustainability_Period__c='3';
        project.Deputy_Project_Leader__c=userinfo.getuserid();
        project.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
        insert project;
        IPM_Project__c projectObj=[select Sustainability_Period__c from IPM_Project__c where id=:project.Id];
        system.assertEquals(projectObj.Sustainability_Period__c ,'3',System.Label.IPM_Record_successfully_saved);
        
        
        System.assertEquals(project.Sustainability_Period__c,IPM_ConstantUtils.MIX_HEADER_SEQUENCE,System.Label.IPM_Record_successfully_saved);
        
        //add project into list of projects
        listIPMProjects=new List<IPM_Project__c> ();
        listIPMProjects.add(project);
        projectId=ApexPages.currentPage().getParameters().get('project.id');
        System.assertEquals(project.IPM_Bosscard__c, Bosscard.id);//positive test
        
        //insert ipm resource with project id
        ipmProjectResource =IPM_TestFactory_Helper.createIPMProjectResource(project.id, FALSE);
        ipmProjectResource.IPM_Role_Type__c=IPM_ConstantUtils.FUNCTIONAL_ROLE_BB;
        ipmProjectResource.IPM_User__c = stnUser.id  ;
        insert ipmProjectResource;
        IPM_Project_Resource__c projectResObj1=[select IPM_Role_Type__c from IPM_Project_Resource__c where id=:ipmProjectResource.Id];
        system.assertEquals(projectResObj1.IPM_Role_Type__c,IPM_ConstantUtils.FUNCTIONAL_ROLE_BB,System.Label.IPM_Record_successfully_saved);
        
        
        System.assertEquals(ipmProjectResource.IPM_User__c, stnUser.id,System.Label.IPM_Record_successfully_saved);
        
        
        ipmProjectResource2 = IPM_TestFactory_Helper.createIPMProjectResource(project.id,FALSE);
        ipmProjectResource2.IPM_Role_Type__c = 'BD';
        ipmProjectResource2.IPM_User__c = stnUser.id;
        ipmProjectResource2.IPM_Project__c= project.id;
        ipmProjectResource2.IPM_Project_Role_Owner__c=true;
        insert ipmProjectResource2;
        IPM_Project_Resource__c projectResObj2=[select IPM_Project_Role_Owner__c from IPM_Project_Resource__c where id=:ipmProjectResource2.Id];
        system.assert(projectResObj2.IPM_Project_Role_Owner__c,System.Label.IPM_Record_successfully_saved);
        
        system.assertEquals(ipmProjectResource2.IPM_Project__c,project.id);//positive test

        ipmProjectResource3 = IPM_TestFactory_Helper.createIPMProjectResource(project.id,FALSE);
        ipmProjectResource3.IPM_Role_Type__c = 'R&D';
        ipmProjectResource3.IPM_User__c = stnUser.id;
        ipmProjectResource3.IPM_Project__c= project.id;
        insert ipmProjectResource3;
        
        IPM_Project_Resource__c projectResObj3=[select IPM_User__c,IPM_Project__c from IPM_Project_Resource__c where id=:ipmProjectResource3.Id];
        system.assertEquals(projectResObj3.IPM_User__c,stnUser.id,System.Label.IPM_Record_successfully_saved);
        system.assertEquals(projectResObj3.IPM_Project__c,project.id);//positive test
        
        }
    
    
    /*
    * @Description This tests initialise data method
    */
    static testMethod  void testIpm_Resource_Allocation_FinalRevamp_TestConstructor(){
        initializedData();
        User cUser = IPM_TestFactory_Helper.createUser(true);
        system.assert(cUser.id!=null, 'User Id Is NUll');//positive test
        system.RunAs(cUser){
            Test.startTest();
            PageReference pRef = Page.IPM_ProjectSetupView;
            pRef.getParameters().put('Id', project.Id);
            pRef.getParameters().put('Pid', project.Id);
            Test.setCurrentPage(pRef);
            IPM_Team_Assignment_Controller   sic = new IPM_Team_Assignment_Controller(); 
            sic.isDPLeader=true;
            sic.isGuestUser=true;
            sic.isPLeader=true;
            sic.projectID=project.id;
            sic.initialise(); //initialise method
            sic.CountProjectMembers();//count user as function group
            system.assertNotEquals(!sic.isEditable,false, System.Label.IPM_FUNC_CALLED_SUCCESSFULLY);
        }
        Test.stopTest();  
        
    }
    
    /*
    * @Description This is the checks the guest user
    */
    static testMethod  void testGetGuestUser(){
        initializedData();
        User sUser = IPM_TestFactory_Helper.createUserAdmin(true);
        //User sUser = IPM_TestFactory_Helper.createUser(true);
        System.Assert(sUser.Id != null, 'User Id is Null');//positive test
        
        ipmProjectResource4 = IPM_TestFactory_Helper.createIPMProjectResource(project.id,FALSE);
        ipmProjectResource4.IPM_Role_Type__c = 'Finance';
        ipmProjectResource4.IPM_User__c = sUser.id;
        ipmProjectResource4.IPM_Project__c= project.id;
        ipmProjectResource4.IPM_Project_Role_Owner__c=true;
        insert ipmProjectResource4;
        system.assertEquals(ipmProjectResource4.IPM_Project__c,project.id,System.Label.IPM_Record_successfully_saved);//positive test
       
        
        ipmProjectResource5 = IPM_TestFactory_Helper.createIPMProjectResource(project.id,FALSE);
        ipmProjectResource5.IPM_Role_Type__c = 'Guest';
        ipmProjectResource5.IPM_User__c =sUser.id;
        ipmProjectResource5.IPM_Project__c= project.id;
        insert ipmProjectResource5;
        System.assertNotEquals(ipmProjectResource5.id, null,System.Label.IPM_Record_successfully_saved);
        
        
        system.Runas(sUser){
            Test.startTest();
            PageReference pRef = Page.IPM_ProjectSetupView;
            pRef.getParameters().put('Id', project.Id);
            pRef.getParameters().put('Pid', project.Id);
            Test.setCurrentPage(pRef);
            IPM_Team_Assignment_Controller sic = new IPM_Team_Assignment_Controller (); 
            sic.projectID=project.id;
            sic.getGuestUser();//get user as guest
            system.assert(sic.isGuestUser,System.Label.IPM_FUNC_CALLED_SUCCESSFULLY);//positive test
            
            sic.getAssignedMember() ; //get all assigned team members
            system.assertNotEquals(sic.listofAssignedMem.isempty(),true, System.Label.IPM_FUNC_CALLED_SUCCESSFULLY);
            
            sic.PL_ids = sUser.Id;
            sic.GateKeeper_ids=sUser.Id;
            sic.DPL_ids= sUser.Id;
            sic.TPL_ids = sUser.Id;
            sic.SaveTeamMembers(); //save team members
            system.assert(sic.isTeamMemberSave, 'Team Members Not Updated');//positive test
            
            sic.projectID=project.id;
            sic.SelectedRoleType=IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE;
            sic.SelectedRecordId=ipmProjectResource4.Id;
            sic.hodingSelecteOwnerId(); 
            system.assert(!sic.SetSelectedRId.isEmpty(), System.Label.IPM_FUNC_CALLED_SUCCESSFULLY);
            
            sic.selectedPL = string.Valueof(sUser.Id);
            sic.selectedDPL=string.valueof(sUser.Id);
            sic.selectedTL= string.valueof(sUser.Id);
            sic.selectedGK = string.valueof(sUser.Id);
            sic.SaveCoreMembers();//save team members
            system.assert(sic.isTeamMemberSave, System.Label.IPM_FUNC_CALLED_SUCCESSFULLY);
            
            sic.DeleteAssignedmembers(); //deleting assigned team members
           
           
            sic.getIpmuserType(); 
            system.assert(sic.isEditable,System.Label.IPM_FUNC_CALLED_SUCCESSFULLY);//positive test
            
          
            sic.getIpmuserType(); 
            system.assert(sic.isEditable,System.Label.IPM_FUNC_CALLED_SUCCESSFULLY);//positive test
            
            sic.isShowEditmode =false;
            sic.ShowEditTeam(); //hide edit mode of team assignment page
            sic.isShowEditmode =true;
            sic.ShowEditTeam();//show edit mode of team assignment page
            system.assertEquals(sic.isShowEditmode, false,System.Label.IPM_FUNC_CALLED_SUCCESSFULLY);//negative test
            Test.stopTest();
        }
          
        
    }
    
}