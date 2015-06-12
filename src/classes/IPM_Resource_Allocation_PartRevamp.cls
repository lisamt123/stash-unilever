public class IPM_Resource_Allocation_PartRevamp {

/*

Version 1.0 : To enable team member assignment functionality 
Date: 25/09/2014
Changelog :  [Rajesh Kumar] : Added methods to meet the REQ000140 REQ000141 REQ000144

Version 1.1 : [Rajesh Kumar] Updated save functionality for select member from your category
Date:         13/10/2014

*/

public list<selectoption> MembersName{get;set;}
public IPM_Project_Resource__c IPMProjectResource{get;set;}//get project members
public String Projectname{get;set;}//To store project id from url parameter
public String RoleType{get;set;}//To store role type from url parameter
public String Category{get;set;}//To store category from url parameter
public String ProjectLead{get;set;}//To store project lead id from url parameter
public list<User>listofuser{get;set;}// get user list
public string newteammemberid{get;set;}// to store member id from global list(input text box) 
public string delResourceId{get;set;}//to store selected resource to be delete from the resource allocation list
public list<IPM_Project_Resource__c>AssignedMember{get;set;}//get a list of assigned member
public String ChosenUID{get;set;}//get id from assigned member and make the user as owner
public set<String>assignedlist=new set<string>();//get a set of assigned member
public set<String>removelist{get;set;}//remove the members those who are already assigned to current project
public list<selectoption> PreviousProjects{get;set;}
public String selectedProject{get;set;}
public list<IPM_Project_Resource__c>previousProjectMem{get;set;}//get a list of previous team members
public String Pre_UserId{get;set;}//to store previous project user id
public Boolean isSelected{get;set;}//check which user has selected as role owner
Public Boolean IsPreProSelect{get;set;}
public Boolean IsAssignedMemberSize{get;set;}//if member list size is more than one than show list of user
public list<String> addmemberFromPrePro{get;set;}
Public list<String>IPM_User_Role{get;set;}//get all role type from user object
Public list<IPM_Project_Resource__c>AssignedMemberList=new list<IPM_Project_Resource__c>();
Public list<IPM_Project_Resource__c>newlstmember=new list<IPM_Project_Resource__c>();
public Boolean isSaving{get;set;}        
public List<IPM_Project__c> projectLeader {get; set;}  
public string PL{get;set;}
public string DPL{get;set;}
public boolean isPLEdit{get;set;}
public boolean isBasicProfile{get;set;}
public list<wrapperclass> Teammembers{get;set;}
public String SearchTeamMem{get;set;}
public string SearchTeambyCat{get;set;}
public set<string>allcategorylist=new set<string>();  
public string CoreParaMember{get;set;}
public string CoreMembers{get;set;}
public list<IPM_User_Profile__c>lstUserProfile{get;set;}
public list<IPM_User_Profile__c>CompanyCard=new list<IPM_User_Profile__c>();
public string CCardName{get;set;}
public string SearchCoreTeam{get;set;}
public string SelecetedCoreMember{get;set;}
public string ButtonLabel{get;set;}
public string IsNoMatchfound{get;set;}
public string changeRoleType{get;set;}
public set<id>oldresourceid=new set<id>();
public list<IPM_Project_Resource__c>lstoldResource=new list<IPM_Project_Resource__c>();
public set<id>AvoidDupUser{get;set;}
//Contructor
public IPM_Resource_Allocation_PartRevamp (){
    AvoidDupUser=new set<id>();
    string RoletypeRND='';
    SearchTeambyCat='mycategory';
    IsNoMatchfound='';
    changeRoleType='';
    PL=Apexpages.currentpage().getParameters().get('PLeader');
    DPL=Apexpages.currentpage().getParameters().get('DPLeader'); 
    if(PL=='true' || DPL=='true'){
    isPLEdit=true;
    }
    Id profileId=userinfo.getProfileId();
       String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
       if(profileName==''){
       isBasicProfile=true;
    }
    Projectname=Apexpages.currentpage().getParameters().get('id');
    RoleType=Apexpages.currentpage().getParameters().get('RoleType');
    RoletypeRND=Apexpages.currentpage().getParameters().get('RoleType');
    Category=Apexpages.currentpage().getParameters().get('Category');
    ProjectLead=Apexpages.currentpage().getParameters().get('ProjectLead');
    CoreMembers=Apexpages.currentpage().getParameters().get('CoreMember');
    IPMProjectResource=new IPM_Project_Resource__c();
    previousProjectMem=new list<IPM_Project_Resource__c>();
    selectedProject='';
    IPM_Project__c Ipmproject=[select id,Deputy_Project_Leader__c,IPM_Project_Gatekeeper__c,IPM_Project_Leader__c,IPM_Technical_Project_Leader__c,IPM_Company_Card__c,IPM_Category_Text__c from IPM_Project__c where id=:Projectname];
    if(Ipmproject.Deputy_Project_Leader__c!=null)
    AvoidDupUser.add(Ipmproject.Deputy_Project_Leader__c);
    if(Ipmproject.IPM_Project_Gatekeeper__c!=null)
    AvoidDupUser.add(Ipmproject.IPM_Project_Gatekeeper__c);
    if(Ipmproject.IPM_Project_Leader__c!=null)
    AvoidDupUser.add(Ipmproject.IPM_Project_Leader__c);
    if(Ipmproject.IPM_Technical_Project_Leader__c!=null)
    AvoidDupUser.add(Ipmproject.IPM_Technical_Project_Leader__c);
    
    Category=Ipmproject.IPM_Category_Text__c;
    CCardName=Ipmproject.IPM_Company_Card__c;
    CompanyCard=[select IPM_Company_Card__c,IPM_Project_Leader__c from IPM_User_Profile__c where IPM_User__c=:userinfo.getuserid() limit 1];
    if(CompanyCard.size()>0){
       // CCardName=CompanyCard[0].IPM_Company_Card__c;   
      }
    list<String> addmemberFromPrePro=new list<String>();
    newlstmember=new list<IPM_Project_Resource__c>();
    if(RoletypeRND=='RND'){
      RoleType='R&D';
    }
    changeRoleType=RoleType;
    system.debug('changeRoleType.....'+changeRoleType);
   /* if(RoleType=='BD'){
     changeRoleType='Marketing';
    }else if(RoleType=='CD'){
    changeRoleType='Customer Development';
    }else if(RoleType=='R&D'){
    changeRoleType='Research/Development';
    }else{
    changeRoleType=RoleType;
    }*/
    
    if(RoleType=='Guest'){
    SearchTeambyCat='allcategory';
    }
    //get list of role from user object
        IPM_User_Role=new list<String>();  
        Schema.DescribeFieldResult RoleField= User.IPM_Role__c.getDescribe(); 
        Schema.PicklistEntry [] Rolefld = RoleField.getPickListValues();
       for(Schema.PicklistEntry val : Rolefld )
        {
          //system.debug('user Roles inside'+val.getValue());
          //  if(val.getValue()!='Project Leader' && val.getValue()!='Deputy Project Leader' && val.getValue()!='Gate Keeper' &&  val.getValue()!='Technical Leader' )
                IPM_User_Role.add(val.getValue());
           
        }
      
    getAssignedTeamMember();
    getUserdetails();
    getTeamMember();
    getPreviousProject();
    getSameCategory();
    GetCoreMemberds();
    system.debug('IsNoMatchfound.....'+IsNoMatchfound);
  
}
//Get members from same category
public void getSameCategory(){
 map<id,id>uniqueUsers=new map<id,id>();
 oldresourceid=(new map<id,IPM_Project_Resource__c>([select IPM_User__c from IPM_Project_Resource__c where IPM_Project__c=:Projectname])).keyset();
 system.debug('oldresourceid.......'+oldresourceid);
 Teammembers=new list<wrapperclass>();
 list<IPM_User_Profile__c>lstuser=new list<IPM_User_Profile__c>();
 String AllCatList=System.label.IPM_Category_list;
 String[] CategoryName=(System.label.IPM_Category_list).split(';');
 system.debug('CategoryName........'+CategoryName);
    for(Integer i=0;i<CategoryName.size();i++)
    {
     allcategorylist.add(CategoryName[i]);
    }

string UQuery='';
if(SearchTeambyCat=='mycategory'){
    UQuery='select IPM_User__r.id,IPM_User__r.Function__c,IPM_User_Role__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.IPM_Role__c, IPM_User__r.UserRole.Name from IPM_user_profile__c where  (IPM_User__r.IsActive=True and IPM_User__r.User_License__c=\'Salesforce\' and IPM_User__r.IPM_Category__c=\'' + Category + '\' and IPM_User_Role__c=\''+changeRoleType+'\' )';
    lstuser=Database.query(UQuery);
    system.debug('lstuser....'+lstuser);
 }else if(SearchTeambyCat=='allcategory'){
  
    if(RoleType=='Guest'){
    lstuser=[select IPM_User__r.id,IPM_User__r.Function__c,IPM_User_Role__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.IPM_Role__c, IPM_User__r.UserRole.Name from IPM_user_profile__c where  IPM_User__r.IsActive=true and IPM_User__r.User_License__c='Salesforce' and IPM_User__r.IPM_Category__c=:allcategorylist and id NOT IN:oldresourceid ];
    }else{
    lstuser=[select IPM_User__r.id,IPM_User__r.Function__c,IPM_User_Role__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.IPM_Role__c, IPM_User__r.UserRole.Name from IPM_user_profile__c where  IPM_User__r.IsActive=true and IPM_User__r.User_License__c='Salesforce' and IPM_User__r.IPM_Category__c=:allcategorylist and IPM_User_Role__c=:changeRoleType and id NOT IN:oldresourceid];
    } 
 }
 for(IPM_User_Profile__c u:lstuser){
    if(AvoidDupUser.contains(u.IPM_User__r.id)){
     }else{
     //Teammembers.add(new wrapperclass(u));
     uniqueUsers.put(u.IPM_User__c,u.id);
     }
 }
 system.debug('uniqueUsers......'+uniqueUsers.values());
lstuser=[select IPM_User__r.id,IPM_User__r.Function__c,IPM_User_Role__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.IPM_Role__c, IPM_User__r.UserRole.Name from IPM_user_profile__c where id IN:uniqueUsers.values()];
for(IPM_User_Profile__c u:lstuser){
    Teammembers.add(new wrapperclass(u));
}
}
//Search for same category members
public void FilterTeamMember(){
 map<id,id>uniqueUsers=new map<id,id>();
 Teammembers=new list<wrapperclass>();
 list<IPM_User_Profile__c>lstuser=new list<IPM_User_Profile__c>();
 string UQuery='';
 if(SearchTeambyCat=='mycategory'){
    UQuery='select IPM_User__r.id,IPM_User__r.Function__c,IPM_User_Role__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.IPM_Role__c, IPM_User__r.UserRole.Name from IPM_user_profile__c where  (IPM_User__r.IsActive=True and IPM_User__r.User_License__c=\'Salesforce\' and IPM_User__r.IPM_Category__c=\'' + Category + '\' and IPM_User_Role__c=\''+changeRoleType+'\')and(IPM_User__r.name Like \'' + SearchTeamMem +'%'+'\'  or IPM_User__r.email Like \'' + SearchTeamMem +'%'+ '\' or  IPM_User_Role__c Like \''+ SearchTeamMem + '%' + '\')';
    lstuser=Database.query(UQuery);
 }else if(SearchTeambyCat=='allcategory' ){
   if(RoleType=='Guest'){
     lstuser=[select IPM_User__r.id,IPM_User_Role__c,IPM_User__r.Function__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.IPM_Role__c, IPM_User__r.UserRole.Name from IPM_user_profile__c where  (IPM_User__r.IsActive=true and IPM_User__r.User_License__c='Salesforce' and IPM_User__r.IPM_Category__c IN:allcategorylist ) and(IPM_User__r.name Like:SearchTeamMem +'%' or IPM_User__r.email like:SearchTeamMem +'%' or IPM_User_Role__c Like:SearchTeamMem +'%') and IPM_User__r.id NOT IN:oldresourceid];
  }else{
  lstuser=[select IPM_User__r.id,IPM_User_Role__c,IPM_User__r.Function__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.IPM_Role__c, IPM_User__r.UserRole.Name from IPM_user_profile__c where  (IPM_User__r.IsActive=true and IPM_User__r.User_License__c='Salesforce' and IPM_User__r.IPM_Category__c IN:allcategorylist and IPM_User_Role__c=:changeRoleType) and(IPM_User__r.name Like:SearchTeamMem +'%' or IPM_User__r.email like:SearchTeamMem +'%' or IPM_User_Role__c Like:SearchTeamMem +'%') and IPM_User__r.id NOT IN:oldresourceid];
  }
 }
if(lstuser.size()==0){
  IsNoMatchfound='true';
 }else{
 IsNoMatchfound='';
 }
 list<id>lstdupuser=new list<id>();
 for(IPM_User_Profile__c u:lstuser){
     if(AvoidDupUser.contains(u.IPM_User__r.id)){
     }else{
    // Teammembers.add(new wrapperclass(u));   
     uniqueUsers.put(u.IPM_User__c,u.id);
     }
 }
lstuser=[select IPM_User__r.id,IPM_User__r.Function__c,IPM_User_Role__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.IPM_Role__c, IPM_User__r.UserRole.Name from IPM_user_profile__c where id IN:uniqueUsers.values()];
for(IPM_User_Profile__c u:lstuser){
    Teammembers.add(new wrapperclass(u));
}
}
//Add members from same category
public void AddMemberToWrapper(){
list<IPM_Project_Resource__c>lstnewResource=new list<IPM_Project_Resource__c>();
for(wrapperclass MAdd:Teammembers){
    
    if(MAdd.checkboxuser==true){
          IPM_Project_Resource__c IPMresource=new IPM_Project_Resource__c();
          IPMresource=new IPM_Project_Resource__c();
          IPMresource.IPM_Project__c= Projectname;
          IPMresource.IPM_User__c=MAdd.listofuser.IPM_User__r.id;
          IPMresource.IPM_Role_Type__c=RoleType;
          lstnewResource.add(IPMresource);
   }
   
   }
   try{
    insert lstnewResource;
   }catch(exception e){
   
}
}
//used for select members from role specific
public void getUserdetails(){
    removelist=new set<string>();
    listofuser=new list<User>();
    listofuser=[select id,name,IPM_Category__c,IPM_Brand_Name__c,IPM_Role__c from user where IPM_Role__c=:IPM_User_Role and IsActive=true and User_License__c='Salesforce'];
    for(User checkuser:listofuser){
    if(assignedlist.size()==0){
     removelist.add(checkuser.name);  
    }
       for(String assignedU:assignedlist){
       
           if(checkuser.id!=assignedU){
              removelist.add(checkuser.name);  
           }
       }
       
    }
  
    
    }
//Get team members
public List<SelectOption> getTeamMember()
     {
       
       MembersName= new List<SelectOption>();
       //MembersName.add(new selectoption('','Select'));
       
       // select user from same category
       system.debug('RoleType....'+ RoleType+ Category);
       List<User> IPMPro=[select Id,Name from User where IPM_Role__c=:RoleType and IPM_Category__c=:Category order by Name ASC]; 
       //List<IPM_Project_Resource__c> IPMPro=[select IPM_User__c,IPM_User__r.name from IPM_Project_Resource__c where IPM_User__r.IPM_Role__c=:RoleType and IPM_User__r.IPM_Category__c=:Category and IPM_Project__r.id !=:Projectname order by IPM_User__c ASC]; 
      // List<IPM_Project_Resource__c> IPMProFinal= new List<IPM_Project_Resource__c>();
       
       Set<String> IPMteammemberNames = New Set<String>();  // used to remove duplicates from the list
        
        /* Previous project
         for(IPM_Project_Resource__c pro:IPMPro)
          {
            if (IPMteammemberNames.Contains(pro.IPM_User__r.name) == FALSE){

              IPMteammemberNames.add(pro.IPM_User__r.name);

              MembersName.add(new selectoption(pro.IPM_User__c,pro.IPM_User__r.name));

           }*/
           
           // same category
            for(User pro:IPMPro)
              {
                if (IPMteammemberNames.Contains(pro.Name) == FALSE){
    
                  IPMteammemberNames.add(pro.Name);
    
                  MembersName.add(new selectoption(pro.Id,pro.Name));

               }
           
                
                
              
          }
          return MembersName;
    }
    
//Get previous project list associated with current project lead
 public List<SelectOption> getPreviousProject()
     {
       
       PreviousProjects= new List<SelectOption>();
       PreviousProjects.add(new selectoption('','Select'));
       List<IPM_Project__c> IPMProject=[select ID,Name from IPM_Project__c where IPM_Project_Leader__r.id=:ProjectLead  and id !=:Projectname order by name ASC]; 
         for(IPM_Project__c pro:IPMProject)
          {
              PreviousProjects.add(new selectoption(pro.id,pro.name));
          }
          return PreviousProjects;
    }  
    
  //save new team member for project alloaction  
  public void SaveNewmember(){
        try{
           
           //list<IPM_Project_Resource__c>newlstmember=new list<IPM_Project_Resource__c>();
           
           Boolean IsAleadyAssigned=false;
           String userid='';
           system.debug('I am here');
           list<User>selectedUser=[select id,name from User where name=:newteammemberid limit 1];
           userid=selectedUser[0].id;
           getAssignedTeamMember();
          for(IPM_Project_Resource__c assignedmem1:AssignedMemberList){
           if(assignedmem1.IPM_User__r.id==userid){
              IsAleadyAssigned=true;
                apexpages.addmessage(new apexpages.message(apexpages.severity.Warning,assignedmem1.IPM_User__r.name + ' already assigned to current project'+ ' as a '+ assignedmem1.IPM_Role_Type__c+' member.'));
             }
           }
           
          if(IsAleadyAssigned==false){    
                system.debug('I am here1');        
          IPM_Project_Resource__c IPMresource=new IPM_Project_Resource__c();
          IPMresource=new IPM_Project_Resource__c();
         
          IPMresource.IPM_Project__c= Projectname;
          IPMresource.IPM_User__c=userid;
          IPMresource.IPM_Role_Type__c=RoleType;
          newlstmember.add(IPMresource);
          list<IPM_Project_Resource__c>duplicateMember=new list<IPM_Project_Resource__c>();
          duplicateMember=new list<IPM_Project_Resource__c>();
          duplicateMember= [select id,IPM_User__c,IPM_User__r.name,IPM_User__r.SmallPhotoUrl,IPM_Project_Role_Owner__c,IPM_Role_Type__c from IPM_Project_Resource__c where IPM_Project__r.id=:Projectname and IPM_User__c=:userid order by IPM_User__c ASC]; 
          if(duplicateMember.size()==0){
           upsert newlstmember;
          }
         
          newteammemberid =null;
          getAssignedTeamMember();
          getUserdetails();
           
         }
        }Catch(exception e){
        
        }   
          
  
  }
  
  //Get list of already assigned members in the current project
  public void  getAssignedTeamMember(){
      
      assignedlist=new set<string>();
      AssignedMember=new list<IPM_Project_Resource__c>();
      
      projectLeader=[select id,IPM_Project_Leader__c,IPM_Project_Leader__r.id,IPM_Project_Leader__r.name,IPM_Project_Leader__r.SmallPhotoUrl from IPM_Project__c where IPM_Project_Leader__c=:ProjectLead and id=:Projectname];
      
   //   system.debug('ProjectLeaderData'+projectLeader.IPM_Project_Leader__r.name+ projectLeader.IPM_Project_Leader__r.SmallPhotoUrl+projectLeader.IPM_Project_Leader__r.id);
      
      //AssignedMember=[select id,IPM_User__c,IPM_User__r.name,IPM_User__r.SmallPhotoUrl,IPM_Project_Role_Owner__c from IPM_Project_Resource__c where IPM_User__r.IPM_Role__c=:RoleType and IPM_Project__r.id=:Projectname and IPM_User__r.IPM_Category__c=:Category order by IPM_User__c ASC]; 
      AssignedMember=[select id,IPM_User__c,IPM_User__r.name,IPM_User__r.SmallPhotoUrl,IPM_Project_Role_Owner__c,IPM_Role_Type__c from IPM_Project_Resource__c where IPM_Role_Type__c=:RoleType and IPM_Project__r.id=:Projectname order by IPM_User__c ASC]; 
      AssignedMemberList=new list<IPM_Project_Resource__c>();
      AssignedMemberList=[select id,IPM_User__c,IPM_User__r.name,IPM_User__r.SmallPhotoUrl,IPM_Project_Role_Owner__c,IPM_Role_Type__c from IPM_Project_Resource__c where IPM_Project__r.id=:Projectname order by IPM_User__c ASC]; 
      system.debug('Team List'+AssignedMember+'n'+Projectname);
      if(AssignedMember.size()>0){
          IsAssignedMemberSize=true;
          for(IPM_Project_Resource__c assignedmem:AssignedMember){
          assignedlist.add(assignedmem.IPM_User__r.id);
          AvoidDupUser.add(assignedmem.IPM_User__c);
      }
          
       }else{
         IsAssignedMemberSize=false;
        
      }
      system.debug('assignedlist'+assignedlist);
  }
  
 // Delete team member from the project 
 public void delResourceRecord( ){
     Try{
         if(delResourceId!= ''){
         IPM_Project_Resource__c delResource = new IPM_Project_Resource__c();
         delResource = [select Id from IPM_Project_Resource__c  where Id=:delResourceId];
         delete delResource ;
         isSelected=false;
         getAssignedTeamMember();
         getUserdetails();
         getPreviousProMembers();
         
         }
     }
     Catch(Exception e){
     
     }
 
 } 
 
 //Change the current project role owner
 public void changeOwner(){
        try{
         list<IPM_Project_Resource__c>AssignedMember1=new list<IPM_Project_Resource__c>();
         AssignedMember1=new list<IPM_Project_Resource__c>();
         for(IPM_Project_Resource__c allresource:AssignedMember){
            
             if(ChosenUID==allresource.id){
             allresource.IPM_Project_Role_Owner__c =true;
             }else
             {
                 allresource.IPM_Project_Role_Owner__c =false;
             }
         AssignedMember1.add(allresource);
         }
         update AssignedMember1;
         getAssignedTeamMember();
        
      }
      Catch(exception e){
      
      }
    }
    
 //Method for getting all previous project members
 public void getPreviousProMembers(){
     
     getAssignedTeamMember();
     previousProjectMem=[select id,IPM_User__c,IPM_User__r.name,IPM_User__r.SmallPhotoUrl,IPM_Project_Role_Owner__c,IPM_Role_Type__c
                              from IPM_Project_Resource__c where IPM_User__r.IPM_Role__c=:RoleType and IPM_Project__r.id=:selectedProject 
                              and IPM_User__r.IPM_Category__c=:Category and IPM_User__r.id !=:assignedlist order by IPM_User__c ASC]; 
       if(previousProjectMem.size()>0){
        IsPreProSelect=true;
       }else{
       IsPreProSelect=false;
       }                    
     }
     
 //Add members from previous project list
 public void addtoAssignedMem(){
     Try{
     Boolean IsAleadyAssigned=false;
     
     for(IPM_Project_Resource__c assignedmem1:AssignedMember){
          if(assignedmem1.IPM_User__r.id==Pre_UserId){
              IsAleadyAssigned=true;
             
          }
        }
        if(IsAleadyAssigned==false){
          String userid='';
          IPM_Project_Resource__c IPMresource=new IPM_Project_Resource__c();
          IPMresource=new IPM_Project_Resource__c();
          list<User>selectedUser=[select id,name from User where id=:Pre_UserId limit 1];
          userid=selectedUser[0].id;
          IPMresource.IPM_Project__c= Projectname;
          IPMresource.IPM_User__c=userid;
          IPMresource.IPM_Role_Type__c=RoleType;
          
          insert IPMresource;
         
          getAssignedTeamMember();
          getUserdetails();
          getPreviousProMembers();
        }
       }
      Catch(exception e){
      
      } 
    }
  
  //Add Previous project members to current project
  public void AddPreviousProMembers(){
   try{
          getAssignedTeamMember();
          Boolean IsAleadyAssigned=false;
          for(IPM_Project_Resource__c assignedmem1:AssignedMemberList){
              for(String addmem:addmemberFromPrePro){
          if(assignedmem1.IPM_User__r.id==addmem){
              IsAleadyAssigned=true;
              apexpages.addmessage(new apexpages.message(apexpages.severity.Warning,assignedmem1.IPM_User__r.name + ' already assigned to current project'+ ' as a '+ assignedmem1.IPM_Role_Type__c+' member.'));
             // break;
             }
            }
          }
          if(IsAleadyAssigned==false){
          String userid='';
         
          list<IPM_Project_Resource__c> IPMresource1=new list<IPM_Project_Resource__c>();
          IPMresource1=new list<IPM_Project_Resource__c>();
          list<User>selectedUser=[select id,name from User where id=:addmemberFromPrePro];
          for(user uId:selectedUser){
             IPM_Project_Resource__c IPMresource=new IPM_Project_Resource__c();
             IPMresource=new IPM_Project_Resource__c();
             IPMresource.IPM_Project__c= Projectname;
             IPMresource.IPM_User__c=uId.id; 
             IPMresource.IPM_Role_Type__c=RoleType;
             IPMresource1.add(IPMresource);
          }
         insert IPMresource1;
         
          getAssignedTeamMember();
          getUserdetails();
          getPreviousProMembers();
          getTeamMember();
       }
      
     }
  Catch(exception e){
  
  }
 }
public class wrapperclass{
public Boolean checkboxuser{get;set;}
public IPM_User_Profile__c listofuser{get;set;}
    public wrapperclass(IPM_User_Profile__c lstuser){
        checkboxuser=false;
        listofuser=lstuser;
    }
} 
//Get Core members from user profiles
public void GetCoreMemberds(){
  
  lstUserProfile=new list<IPM_User_Profile__c>();
    if(CoreMembers=='PL'){
        ButtonLabel='Project Leader';
        lstUserProfile=[select IPM_User__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.UserRole.Name from IPM_User_Profile__c where  IPM_User__r.IPM_Category__c like :'%'+Category+'%' and IPM_User_Function__c='Project Leader' and IPM_Company_Card__c=:CCardName];
     }
   else if(CoreMembers=='DPL'){
        ButtonLabel='Deputy Project Leader';
        lstUserProfile=[select IPM_User__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.UserRole.Name from IPM_User_Profile__c where  IPM_User__r.IPM_Category__c like :'%'+Category+'%' and IPM_User_Function__c='Project Leader' and IPM_Company_Card__c=:CCardName];
     }
  else if(CoreMembers=='GateK'){
        ButtonLabel='GateKeeper';
        lstUserProfile=[select IPM_User__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.UserRole.Name from IPM_User_Profile__c where  IPM_User__r.IPM_Category__c like :'%'+Category+'%' and IPM_User_Function__c='Gatekeeper' and IPM_Company_Card__c=:CCardName];
     }
 else if(CoreMembers=='TPL'){
    ButtonLabel='Technical Project Leader';
    lstUserProfile=[select IPM_User__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.UserRole.Name from IPM_User_Profile__c where  IPM_User__r.IPM_Category__c like :'%'+Category+'%' and IPM_User_Role__c='R&D' ];
 }    
system.debug('IsNoMatchfound.....'+IsNoMatchfound);
  
}
//Filter core members
public void FilterCoreMember(){
lstUserProfile=new list<IPM_User_Profile__c>();
    if(CoreMembers=='PL'){
        lstUserProfile=[select IPM_User__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.UserRole.Name from IPM_User_Profile__c where  IPM_User__r.IPM_Category__c like :'%'+Category+'%' and IPM_User_Function__c='Project Leader' and IPM_Company_Card__c=:CCardName  and(IPM_User__r.name Like:SearchCoreTeam +'%' or IPM_User__r.email like:SearchCoreTeam +'%')];
        //lstUserProfile=[select IPM_User__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.UserRole.Name from IPM_User_Profile__c where  IPM_User__r.IPM_Category__c like :'%'+Category+'%' and IPM_User_Role__c='Project Leader' and IPM_Company_Card__c=:CCardName and(IPM_User__r.name Like:SearchCoreTeam +'%' or IPM_User__r.email like:SearchCoreTeam +'%')];
        
     }
   else if(CoreMembers=='DPL'){
        lstUserProfile=[select IPM_User__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.UserRole.Name from IPM_User_Profile__c where  IPM_User__r.IPM_Category__c like :'%'+Category+'%' and IPM_User_Function__c='Project Leader' and IPM_Company_Card__c=:CCardName  and(IPM_User__r.name Like:SearchCoreTeam +'%' or IPM_User__r.email like:SearchCoreTeam +'%')];
        
     }
  else if(CoreMembers=='GateK'){
        lstUserProfile=[select IPM_User__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.UserRole.Name from IPM_User_Profile__c where  IPM_User__r.IPM_Category__c like :'%'+Category+'%' and IPM_User_Function__c='Gatekeeper' and IPM_Company_Card__c=:CCardName  and(IPM_User__r.name Like:SearchCoreTeam +'%' or IPM_User__r.email like:SearchCoreTeam +'%')];
        system.debug('IsNoMatchfound.....'+IsNoMatchfound);
       
     }  
 else if(CoreMembers=='TPL'){
        lstUserProfile=[select IPM_User__c,IPM_User__r.name,IPM_User__r.email,IPM_User__r.IPM_Category__c,IPM_User__r.SmallPhotoUrl,IPM_User__r.IPM_Brand_Name__c,IPM_User__r.UserRole.Name from IPM_User_Profile__c where  IPM_User__r.IPM_Category__c like :'%'+Category+'%' and IPM_User_Role__c='R&D' and(IPM_User__r.name Like:SearchCoreTeam +'%' or IPM_User__r.email like:SearchCoreTeam +'%')];
    } 
     if(lstUserProfile.size()==0){
        IsNoMatchfound='true';
        }else{
         IsNoMatchfound='';
        }
} 
//Update Core Members
public void UpdateCoreMember(){
 IPM_Project__c Ipmproject=new IPM_Project__c(id=Projectname);
 if(CoreMembers=='PL'){
   Ipmproject.IPM_Project_Leader__c=SelecetedCoreMember;
 }
 else if(CoreMembers=='DPL'){
    Ipmproject.Deputy_Project_Leader__c =SelecetedCoreMember;
 }
 else if(CoreMembers=='GateK'){
  Ipmproject.IPM_Project_Gatekeeper__c=SelecetedCoreMember;
 }
 else if(CoreMembers=='TPL'){
  Ipmproject.IPM_Technical_Project_Leader__c=SelecetedCoreMember;
 }
 update Ipmproject;
} 
//Hold core member id
public void HoldCoreMember(){

}   
}