/**
 * Test_AF_MultiSelectComponent: This Test class for AF_MultiSelectComponent apex class
 * @author 
 *
 */
@istest(seealldata=false)
public class Test_AF_MultiSelectComponent{

static testmethod void AF_MultiSelectComponent()
{

test.starttest();
Profile p=[Select Id from Profile where Name='System Administrator'];       
List<String> permList =  new List<String>();
List<String> permSelectedList =  new List<String>();

//Insert User 
User u= new User(Alias = 'test123', Email='standarduser@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test User123', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuser@test123321.com',AF_Brand__c='Test Brand1',AF_Category__c='Test Beverages1');
      insert u;  

//insert permission set      
     
PermissionSet ps1=new PermissionSet();  
ps1.Name = 'AF_Sairam';
ps1.Label = 'AF_Sairam';
insert ps1; 

PermissionSet ps2=new PermissionSet();
ps2.Name = 'AF_Martin';
ps2.Label = 'AF_Martin';
insert ps2;

PermissionSetAssignment psa1 = new PermissionSetAssignment();
psa1.AssigneeId = u.Id;
psa1.PermissionSetId = ps1.Id;     
insert psa1;

/*PermissionSetAssignment psa2 = new PermissionSetAssignment();
psa2.AssigneeId = u.Id;
psa2.PermissionSetId = ps2.Id;     
insert psa2;*/

//insert group

Group gr = new Group();
gr.Name = 'af_reetha';
insert gr;

//insert groupmember

GroupMember gmember = new GroupMember();
gmember.UserOrGroupId = u.Id;
gmember.GroupId = gr.Id;
insert gmember;
 
ApexPages.currentPage().getParameters().put('userid', u.id); 
//Intialize the Class
AF_MultiSelectComponent af=new AF_MultiSelectComponent();
//Add parameters to page URL

permList.add('AF_Sairam');
permList.add('AF_Martin');
af.selectedPerList.addAll(permList);

permSelectedList.add('AF_Martin');
af.AvailablePerList.addAll(permSelectedList);
//Permission set method

af.addPermission();
af.removePermission();
af.savePermission();
        
        
test.stoptest();

}


static testmethod void AF_MultiSelectComponent1()
{

test.starttest();
Profile p=[Select Id from Profile where Name='System Administrator'];       
List<String> permList =  new List<String>();
List<String> permSelectedList =  new List<String>();

//Insert User 
User u= new User(Alias = 'test123', Email='standarduser@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test User123', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuser@test123321.com',AF_Brand__c='Test Brand1',AF_Category__c='Test Beverages1');
      insert u;

//insert permission set           
PermissionSet ps1=new PermissionSet();  
ps1.Name = 'AF_Sairam';
ps1.Label = 'AF_Sairam';
insert ps1; 

PermissionSet ps2=new PermissionSet();
ps2.Name = 'AF_Martin';
ps2.Label = 'AF_Martin';
insert ps2;

PermissionSetAssignment psa1 = new PermissionSetAssignment();
psa1.AssigneeId = u.Id;
psa1.PermissionSetId = ps1.Id;     
insert psa1;

/*PermissionSetAssignment psa2 = new PermissionSetAssignment();
psa2.AssigneeId = u.Id;
psa2.PermissionSetId = ps2.Id;     
insert psa2;*/

//insert group
Group gr = new Group();
gr.Name = 'af_reetha';
gr.DeveloperName='af_reetha';
insert gr;

//insert group member
GroupMember gmember = new GroupMember();
gmember.UserOrGroupId = u.Id;
gmember.GroupId = gr.Id;
insert gmember;
 
ApexPages.currentPage().getParameters().put('userid', u.id); 
//Intialize the Class
AF_MultiSelectComponent af=new AF_MultiSelectComponent();
//Add parameters to page URL

permList.add('AF_Sairam');
permList.add('AF_Martin');
af.selectedPerList.addAll(permList);

permSelectedList.add('AF_Martin');
af.AvailablePerList.addAll(permSelectedList);
//Permission set method

af.addPermission();
af.removePermission();
af.savePermission();
af.addgroups();
af.removegroups();
af.saveGroups();
        
        
test.stoptest();
   
   

}



}// end