/**
 * Description : To update project name and rollout name
 * @author : Cognizant
 */
@isTest
private class IPM_UpdateGlobalProjectName_Test {
    
	private static IPM_Project_Rollout__c projectRollout;
	private static User gkAndPL;
	private static List<IPM_Project__c> projectAssert;
	private static string projectName='ProjectCreation';
	private static string proUpdatedName= 'ProjectUpdation';
	private static IPM_Project__c parentProject;
    private static IPM_Project__c childProject; 
    private static IPM_Project__c subChildProject;
    private static List<User>userList=new List<User>(); 
	private static string inValidProject_STR='ProjectCreation_project namw with long string project namw with long string project namw with long stringproject namw with long stringproject namw with long stringproject namw with long string';
    /*****************************************************************************
    * @description Test Data
    */  
    static void initializedData()
    {         
        //insert new user to assign as project leader,gatekeeper etc.
        gkAndPL = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);
        
        userList.add(gkAndPL); 
        List<User>userLists=[SELECT lastName FROM user WHERE id=:gkAndPL.id LIMIT 1];
        System.AssertEquals(userLists[0].lastName, gkAndPL.lastName,'user lastname is:'+userLists[0].lastName);//positive test 
            
		system.runAs(gkAndPL){
			//create parent project
			parentProject = IPM_TestFactory_Helper.createIPMProject(false);
	        parentProject.Name = projectName;
	        parentProject.IPM_Project_Name__c = projectName;
	        parentProject.IPM_PM_Approach__c = IPM_ConstantUtils.IPM_APPROACH_INTERNAL;
	        parentProject.IPM_IsCompleted__c=true;
	        parentProject.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
	        parentProject.IPM_Complexity__c = IPM_ConstantUtils.COMPLEXITY_LITE;
	        parentProject.IPM_Project_Leader__c=gkAndPL.id;
	        parentProject.IPM_Target_Launch_Date__c='30-12-2016';
	        insert parentProject; 
	        
	        List<IPM_Project__c>projPList=[SELECT IPM_Project_Name__c FROM IPM_Project__c WHERE id=:parentProject.id LIMIT 1];
	        system.assertEquals(projPList[0].IPM_Project_Name__c,projectName,'Parent Project name is:'+projPList[0].IPM_Project_Name__c);//positive test 
	        
	        //create child project
	        String CHILD_PROJECT_NAME = 'ProjectCreation_IND';
	        childProject=new IPM_Project__c();
	        childProject.Name=CHILD_PROJECT_NAME;
	        childProject.IPM_Parent_Project__c=parentProject.Id;
	        childProject.IPM_Project_Name__c=CHILD_PROJECT_NAME;
	        childProject.IPM_PM_Approach__c=IPM_ConstantUtils.IPM_APPROACH_INTERNAL;
	        childProject.IPM_IsCompleted__c=true;
	        childProject.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
	        childProject.IPM_Complexity__c=IPM_ConstantUtils.COMPLEXITY_LITE;
	        childProject.IPM_Project_Leader__c=gkAndPL.id;
	        childProject.IPM_Target_Launch_Date__c='30-12-2016';
	        childProject.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
	        insert childProject; 
	        List<IPM_Project__c>projChList=[SELECT IPM_Project_Name__c,IPM_PM_Approach__c,IPM_Complexity__c FROM IPM_Project__c WHERE  id=:childProject.id LIMIT 1];
	        system.assertEquals(projChList[0].IPM_Project_Name__c,CHILD_PROJECT_NAME,'Child Project name is:'+projChList[0].IPM_Project_Name__c);//positive test 
	        
	        //create subchild project
	        String SUBCHILD_PROJECT_NAME = 'ProjectCreation_IND_IN';
	        subChildProject=new IPM_Project__c();
	        subChildProject.Name=SUBCHILD_PROJECT_NAME;
	        subChildProject.IPM_Parent_Project__c=childProject.Id;
	        subChildProject.IPM_Project_Name__c=SUBCHILD_PROJECT_NAME;
	        subChildProject.IPM_PM_Approach__c=IPM_ConstantUtils.IPM_APPROACH_INTERNAL;
	        subChildProject.IPM_IsCompleted__c=true;
	        subChildProject.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
	        subChildProject.IPM_Complexity__c=IPM_ConstantUtils.COMPLEXITY_LITE;
	        subChildProject.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
	        subChildProject.IPM_Project_Leader__c=gkAndPL.id;
	        insert subChildProject; 
	        List<IPM_Project__c>projSubChList=[Select IPM_Project_Name__c,IPM_PM_Approach__c,IPM_Complexity__c From IPM_Project__c where id=:childProject.id];
	        system.assertEquals(projSubChList[0].IPM_Project_Name__c,CHILD_PROJECT_NAME,'Child Project name is:'+projSubChList[0].IPM_Project_Name__c);//positive test 
	        
				
			//insert project rollout 
			projectRollout=IPM_TestFactory_Helper.createIPMProjectRollout(false); 
			projectRollout.IPM_Rollout_Project__c=parentProject.IPM_Project_Name__c;
			projectRollout.Name=parentProject.IPM_Project_Name__c;
			projectRollout.IPM_Project__c=parentProject.id;
			insert projectRollout;
			List<IPM_Project_Rollout__c>rolloutList=[SELECT IPM_Project__c FROM IPM_Project_Rollout__c WHERE ID=:projectRollout.id LIMIT 1];
	        system.assertEquals(rolloutList[0].IPM_Project__c, +parentProject.id,'Rollout parent project is:'+parentProject.id);//positive test 
	            
			
			//Query to check all above inserts 
			projectAssert =[SELECT Id,Name,IPM_Project_Type__c
	                                            ,(SELECT Name,IPM_Rollout_Project__c,IPM_Project__c from IPM_Project_Rollout__r)
	                                            FROM IPM_Project__c WHERE Name=:projectName];
			system.assertEquals(projectAssert[0].Name,projectName);//positive test
		}		
		
    }
   /**************************************************************
    *@Description :testmethod to updateProjectName
    */
    static testmethod void testUpdateProjectName(){
        initializedData();
        test.startTest();
        //running as global project leader
        system.runAs(gkAndPL){
	        //get project old name and new name along with project id
	        map<id,string>projectOldname=new map<id,string>();
	        map<id,string>updatedname=new map<id,string>();
			projectOldname.put(parentProject.id, projectName);
	        parentProject.IPM_Project_Name__c=proUpdatedName;
	        parentProject.IPM_Phase__c=IPM_ConstantUtils.Phase_Ideas;
	        update parentProject;//update parent project
	        List<IPM_Project__c>projList=[SELECT IPM_Project_Name__c FROM IPM_Project__c WHERE id=:parentProject.id LIMIT 1];
        	system.assertEquals(projList[0].IPM_Project_Name__c,parentProject.IPM_Project_Name__c,'Parent Project name is:'+projList[0].IPM_Project_Name__c);//positive test 
        
	        updatedname.put(parentProject.id, parentProject.IPM_Project_Name__c); 
	        
	        //call a method which will update project name to entire project related records
        	IPM_UpdateGlobalProjectName.updateProjectName(updatedname,projectOldname);//call to update rollout name
            List<IPM_Project_Rollout__c>rolloutList=[SELECT IPM_Rollout_Project__c,IPM_Project__c FROM IPM_Project_Rollout__c WHERE ID=:projectRollout.id LIMIT 1];
            system.assertEquals(rolloutList[0].IPM_Rollout_Project__c, +parentProject.IPM_Project_Name__c,'Rollout name should be:'+parentProject.IPM_Project_Name__c);//positive test 
            
            IPM_UpdateGlobalProjectName.updateChildProjects(updatedname,projectOldname);//call to update child and subchild project name
            List<IPM_Project__c>chldProjectList=[SELECT IPM_Project_Name__c FROM IPM_Project__c WHERE ID=:childProject.id LIMIT 1];
            system.assertNotEquals(chldProjectList[0].IPM_Project_Name__c, +childProject.IPM_Project_Name__c,'child name should be:'+chldProjectList[0].IPM_Project_Name__c);//positive test  
            
            List<IPM_Project__c>subChldProjectList=[SELECT IPM_Project_Name__c FROM IPM_Project__c WHERE ID=:subChildProject.id LIMIT 1];
			system.assertNotEquals(subChldProjectList[0].IPM_Project_Name__c, +subChildProject.IPM_Project_Name__c,'sub child name should be:'+subChldProjectList[0].IPM_Project_Name__c);//positive test  
            
        }
		
        test.stopTest();
    }
    /**************************************************************
    *@Description :testmethod to updateProjectName with invalid project name
    */
    static testmethod void testUpdateProjectsName(){
        initializedData();
        test.startTest();
        //running as global project leader with invalid project name
        system.runAs(gkAndPL){
	        //get project old name and new name along with project id
	        map<id,string>projectOldname=new map<id,string>();
	        map<id,string>updatedname=new map<id,string>();
			projectOldname.put(parentProject.id, projectName);
	        updatedname.put(parentProject.id, inValidProject_STR); 
        	//call a method which will update project name to entire project related records
            IPM_UpdateGlobalProjectName.updateProjectName(updatedname,projectOldname);//call to update rollout name
            List<IPM_Project_Rollout__c>rolloutList=[SELECT IPM_Rollout_Project__c,IPM_Project__c FROM IPM_Project_Rollout__c WHERE ID=:projectRollout.id LIMIT 1];
            system.assertNotEquals(rolloutList[0].IPM_Rollout_Project__c, +inValidProject_STR,'Rollout name should be:'+parentProject.IPM_Project_Name__c);//negative test
            
            IPM_UpdateGlobalProjectName.updateChildProjects(updatedname,projectOldname);//call to update child and subchild project name
            List<IPM_Project__c>chldProjectList=[SELECT IPM_Project_Name__c FROM IPM_Project__c WHERE ID=:childProject.id LIMIT 1];
            system.assertEquals(chldProjectList[0].IPM_Project_Name__c, +childProject.IPM_Project_Name__c,'child name should be:'+chldProjectList[0].IPM_Project_Name__c);//positive test  
            
            List<IPM_Project__c>subChldProjectList=[SELECT IPM_Project_Name__c FROM IPM_Project__c WHERE ID=:subChildProject.id LIMIT 1];
			system.assertEquals(subChldProjectList[0].IPM_Project_Name__c, +subChildProject.IPM_Project_Name__c,'sub child name should be:'+subChldProjectList[0].IPM_Project_Name__c);//positive test  
             
         }
		
        test.stopTest();
    }
}