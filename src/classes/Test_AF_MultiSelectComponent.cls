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
string User_permissonset_user1='AF_Sairam';
string User_permissonset_user2 = 'AF_Martin';    
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
ps1.Name = 'User_permissonset_user1';
ps1.Label = 'User_permissonset_user1';
insert ps1; 
System.Assert(ps1.Id != null, 'The Permission set record not inserted');

PermissionSet ps2=new PermissionSet();
ps2.Name = 'User_permissonset_user2';
ps2.Label = User_permissonset_user2;
insert ps2;
System.Assert(ps2.Id != null, 'The Permission set record not inserted');

PermissionSetAssignment psa1 = new PermissionSetAssignment();
psa1.AssigneeId = u.Id;
psa1.PermissionSetId = ps1.Id;     
insert psa1;
System.Assert(psa1.Id != null, 'The permissionsetAssigment record not inserted');

/*PermissionSetAssignment psa2 = new PermissionSetAssignment();
psa2.AssigneeId = u.Id;
psa2.PermissionSetId = ps2.Id;     
insert psa2;*/

//insert group

Group gr = new Group();
gr.Name = 'af_reetha';
insert gr;
System.Assert(gr.Id != null, 'The Group record not inserted');
//insert groupmember

GroupMember gmember = new GroupMember();
gmember.UserOrGroupId = u.Id;
gmember.GroupId = gr.Id;
insert gmember;
 System.Assert(gmember.Id != null, 'The GroupMember record not inserted');
ApexPages.currentPage().getParameters().put('userid', u.id); 
//Intialize the Class
AF_MultiSelectComponent af=new AF_MultiSelectComponent();
//Add parameters to page URL

permList.add(User_permissonset_user1);
permList.add(User_permissonset_user2);
af.selectedPerList.addAll(permList);

permSelectedList.add(User_permissonset_user2);
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
ps1.Name = 'AF_sai';
ps1.Label = 'User_Label';
insert ps1; 
System.Assert(ps1.Id != null, 'The Permission  set record not inserted');

PermissionSet ps2=new PermissionSet();
ps2.Name = 'AF_Connel';
ps2.Label = 'Martin_Label';
insert ps2;
System.Assert(ps2.Id != null, 'The permission set record not inserted');

PermissionSetAssignment psa1 = new PermissionSetAssignment();
psa1.AssigneeId = u.Id;
psa1.PermissionSetId = ps1.Id;     
insert psa1;
System.Assert(psa1.Id != null, 'The brandEstimate record not inserted');

/*PermissionSetAssignment psa2 = new PermissionSetAssignment();
psa2.AssigneeId = u.Id;
psa2.PermissionSetId = ps2.Id;     
insert psa2;*/

//insert group
Group gr = new Group();
gr.Name = 'af_reetha';
gr.DeveloperName='af_reetha';
insert gr;
System.Assert(gr.Id != null, 'The Group record not inserted');

//insert group member
GroupMember gmember = new GroupMember();
gmember.UserOrGroupId = u.Id;
gmember.GroupId = gr.Id;
insert gmember;
 System.Assert(gmember.Id != null, 'The GroupMember record not inserted');
 
ApexPages.currentPage().getParameters().put('userid', u.id); 
//Intialize the Class
AF_MultiSelectComponent af=new AF_MultiSelectComponent();
//Add parameters to page URL

permList.add('sai');
permList.add('martin');
af.selectedPerList.addAll(permList);

permSelectedList.add('Martin');
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