/*
    Class Name              : Core_SendToChatter_Test
    Date                    : 30/9/2014
    Requirement/Description : Test class for the class Core_CA_SendToChatter. 
*/

@isTest
public class Core_SendToChatter_Test{
    
    static testMethod void TestSendToChatter(){
       
       ApexPages.currentPage().getParameters().put('urlVal','test.salesforce.com'); 
       ApexPages.currentPage().getParameters().put('linkName','Salesforce');
       Core_SendToChatterController objsendToCtr= new Core_SendToChatterController ();
       
       //Insert Colloboration group.
       CollaborationGroup objgroup= new CollaborationGroup(Name = 'my_group1', CollaborationType = 'public');
       insert objgroup; 
       System.assert(objgroup != null);
        
       //Call the postOnWall with the strSelToVal='MyFollowers'     
       objsendToCtr.postOnWall();
       
       //Call the postOnWall with the strSelToVal='AGroup' and groupsize is null.
       objsendToCtr.strSelToVal='AGroup';
       objsendToCtr.postOnWall();
       
       //Call the postOnWall with the strSelToVal='AGroup' and groupsize is not null.
       objsendToCtr.targetField=objgroup.Id;
       objsendToCtr.saveGroupInList();
       objsendToCtr.strSelToVal='AGroup';
       objsendToCtr.postOnWall();
       
       //Call the postOnWall with the trSelToVal is null
       objsendToCtr.strSelToVal=null;
       objsendToCtr.postOnWall();
             
       objsendToCtr.getItems();
       objsendToCtr.getMyFollowers();
       objsendToCtr.getAGroup();
       objsendToCtr.removeGroupInList();
       objsendToCtr.createDesc();
    } 
    
 
    static testMethod void test_AutoComplete_Con(){
       //create some test account
       List<CollaborationGroup> lstCollaborationGrp = new List<CollaborationGroup>();
       
       for(Integer i =0 ; i < 2 ; i++){
          lstCollaborationGrp.add(new CollaborationGroup(Name='Test'+i,CollaborationType ='public'));
       }
       //insert test records
       insert lstCollaborationGrp;
       
       Test.startTest();
       System.assertEquals(lstCollaborationGrp.size(),Core_AutoComplete_Con.getData('CollaborationGroup','Name','Id','T').size());
       //System.assertEquals(1, Core_AutoComplete_Con.getData('CollaborationGroup','Name','Id','Test123').size());
       System.assertEquals(0, Core_AutoComplete_Con.getData('CollaborationGroup','Name','Id','xxxxxxx').size());
       Core_AutoComplete_Con controller = new Core_AutoComplete_Con ();
       controller.setTargetFieldVar(lstCollaborationGrp[0].Id);
       System.assertEquals(lstCollaborationGrp[0].Id,controller.getTargetFieldVar());
       controller.setCacheField(null);
       Test.stopTest(); 
    }
}