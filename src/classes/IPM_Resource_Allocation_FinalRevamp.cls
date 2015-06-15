public without sharing class IPM_Resource_Allocation_FinalRevamp {
/*

Version 1.0 : To enable Team Assignment Functionality 
Date: 25/09/2014
Changelog :  [Rajesh Kumar] : Added methods to meet the REQ00027 

Version 1.1 : [Rajesh Kumar] Updated Save Functionality for Team Selection logic for Core Team Members 
Date:         13/10/2014
Changelog 2 :  [Rajesh Kumar] : Updated all methods to enable View Selected Teammembers functionality

Version 1.3 : [Rajesh Kumar] Populated all role type user image according to role type 
Date:         14/10/2014
Changelog 3 :  [Rajesh Kumar] : Populated all role type user image according to role type


*/
Public IPM_Project__c IPM_proj{get;set;}//Store IPM project details
Public list<String>IPM_User_Role{get;set;}//Store user roles from user object
public String ProjectName{get;set;}//Get project name as id from url parameter
public String selectedProject{get;set;}//Get selected project id from dropdown
public list<selectoption> PreviousProjects{get;set;}//Get all list of previous project
public list<IPM_Project_Resource__c>listofAssignedMem{get;set;}//Get all list of Assigned members for current project 
public string newGateKeeperid{get;set;}//Get gateKeeper id
public List<User> AllUsers=new List<User>();// get all user list
public list<String>ItemsPLeader{get;set;}//autocomplete for project leader
public list<String>lstGateKeeper{get;set;}//autocomplete for GATEKEEPER
public list<String>lstDPL{get;set;}//autocomplete for DEPUTY PROJECT LEADER
public list<String>lstTPL{get;set;}//autocomplete for TECHNICAL PROJECT LEADER
public String PLName{get;set;}// hold project leader name
public String GateKeeperName{get;set;}// hold gatekeeper name
public String DPLName{get;set;}// hold DEPUTY PROJECT LEADER name
public String TPLimg{get;set;}// hold TECHNICAL PROJECT LEADER image url
public String TPLName{get;set;}// hold TECHNICAL PROJECT LEADER name
Public User imgURL{get;set;}//Get user image from user object    
public String GKImage{get;set;} // hold gatekeeper image url
public String DPLimg{get;set;} //hold DEPUTY PROJECT LEADER image url
public string plImage{get;set;} // hold project leader image url
//other dropdowns
Public list<selectoption> GatekeeperUser {get;set;}
Public list<selectoption> TechLeadUser {get;set;}
Public list<selectoption> DPLUser {get;set;}
Public list<selectoption> PLUser {get;set;}

//Team member Id's
public string PL_ids{get;set;}
public string GateKeeper_ids{get;set;}
public string DPL_ids{get;set;}
public string TPL_ids{get;set;}
//count team members according to functional role in the project
public integer countBB{get;set;}
public integer countBD{get;set;}
public integer countFinance{get;set;}
public integer countCD{get;set;}
public integer countCMI{get;set;}
public integer countSupplyChain{get;set;}
public integer countGuest{get;set;}
public integer countReDev{get;set;}
// user Image
Public string selectedDPL{get;set;}
Public string selectedTL{get;set;}
Public string selectedGK{get;set;}
Public string selectedPL{get;set;}
public string userID{get;set;}
boolean plImgFlag=false;

//Error message for valid core team member
public Boolean PLError{get;set;}
public Boolean GatekepperError{get;set;}
public Boolean DPLError{get;set;}
public Boolean TPLError{get;set;}

//Core parameter list
public list<IPM_Project__c>ProjectCoreParemeters=new list<IPM_Project__c>();
public boolean isCoreParameter{get;set;}
public string errorMsg;
//User type
public Boolean isBasicProfile{get;set;}
public Boolean isDPLeader{get;set;}
public Boolean isPLeader{get;set;}
public Boolean isGuestUser{get;set;}

public list<wrapperclass>LstAssignedMember{get;set;}
public id SelectedRecordId{get;set;}
Public set<id>SelectedRId=new set<id>();
public boolean isGateKShow{get;set;}
public boolean isPLShow{get;set;}
public boolean isDPLShow{get;set;}
public boolean isTPLShow{get;set;}
public id IPMResourceId{get;set;}
public Boolean isTeamMemberSave{get;set;}
public String SelectedRoleType{get;set;}
public id SelectedUserId{get;set;}
public Boolean isEditable{get;set;}
public Boolean isCoreMemEditable{get;set;}
public boolean isTPLEditable{get;set;}
public string loginusertype{get;set;}
public boolean isShowEditmode{get;set;}
//Constructor
public  IPM_Resource_Allocation_FinalRevamp (){
       selectedProject='';
       isTeamMemberSave=false;
       isShowEditmode=false;
       loginusertype='';
       isEditable=false;
       isCoreMemEditable=false;
       isTPLEditable=false;
       isPLShow=false;
       isDPLShow=false;
       isTPLShow=false;
       isGateKShow=false;
       PLName='';
       GKImage='';
       GateKeeperName='';
       DPLName='';
       DPLimg='';
       TPLName='';
       TPLimg='';
       PL_ids='';
       GateKeeper_ids='';
       DPL_ids='';
       TPL_ids='';
       PLError=true;
       GatekepperError=true;
       DPLError=true;
       TPLError=true;
       isCoreParameter=true;
       string checktoshowedit=ApexPages.currentPage().getParameters().get('showedit');
       if(checktoshowedit=='true'){
        isShowEditmode=true;
       }
       
       ProjectName=ApexPages.currentPage().getParameters().get('Pid');
       if(ProjectName=='' || ProjectName==null){
        ProjectName=ApexPages.currentPage().getParameters().get('id');
       }
       LstAssignedMember=new list<wrapperclass>();
       Id profileId=userinfo.getProfileId();
       String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
       if(profileName=='IPM NG Basic'){
       isBasicProfile=true;
        }
  Initialise();     
  CountProjectMembers();
  getIpmuserType();
  }
public void Initialise(){
Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=9');
       
       /**User chuserRole=new user();
       chuserRole=[select IPM_Role__c from user where id=:userinfo.getuserid()];
       if(chuserRole.IPM_Role__c=='Deputy Project Leader'){
       isDPLeader=true;
        }
      if(chuserRole.IPM_Role__c=='Project Leader'){
        
       }**/
        
       ProjectCoreParemeters = [Select id, IPM_IsCompleted__c from IPM_Project__c where id =:ProjectName];
       if(ProjectCoreParemeters.size()>0){
         if(ProjectCoreParemeters[0].IPM_IsCompleted__c==true){
         isCoreParameter=true;
         }else{
            errorMsg='<a href="/apex/ipmProject?id='+ProjectName+'">'+ system.label.IPM_backto_intermediate + '</a>';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,errorMsg)); 
         }
       }else{
            errorMsg='<a href="/apex/ipmProject?id='+ProjectName+'">'+ system.label.IPM_backto_intermediate + '</a>';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,errorMsg));
       }
       IPM_proj=new IPM_Project__c();
       IPM_proj=[select IPM_Project_Name__c,IPMProject_Span__c,IPM_Project_Gatekeeper__c,Deputy_Project_Leader__c,IPM_Brand_Positioning__c,IPM_Project_Logo__c,IPM_Technical_Project_Leader__c,IPM_Project_Leader__c,IPM_Project_Description__c,IPM_CPP__c,
                IPM_CPP_Change_Reason__c,IPM_Technical_Project_Leader__r.name,Deputy_Project_Leader__r.name,Deputy_Project_Leader__r.id,IPM_Project_Gatekeeper__r.name,IPM_Project_Leader__r.name,
                IPM_Project_Leader__r.IPM_Category__c,IPM_Project_Leader__r.SmallPhotoUrl,IPM_Technical_Project_Leader__r.SmallPhotoUrl,IPM_Project_Gatekeeper__r.SmallPhotoUrl,
                Deputy_Project_Leader__r.SmallPhotoUrl,IPM_Brand__c,IPM_Category_Text__c from IPM_Project__c
                where id=:ProjectName];
       if(IPM_proj.Deputy_Project_Leader__r.id==userinfo.getuserid() && IPM_proj.IPM_Project_Leader__c==userinfo.getuserid() ){
         isPLeader=true; 
       }
       else if(IPM_proj.Deputy_Project_Leader__r.id==userinfo.getuserid()){
       isDPLeader=true;
       }
       if(IPM_proj.IPM_Project_Leader__c==userinfo.getuserid()){
        isPLeader=true;
       }        
        IPM_User_Role=new list<String>();       
        Schema.DescribeFieldResult RoleField= User.IPM_Role__c.getDescribe(); 
        Schema.PicklistEntry [] Rolefld = RoleField.getPickListValues();
       for(Schema.PicklistEntry val : Rolefld )
        {
          //system.debug('user Roles inside'+val.getValue());
            if(IPM_Proj.IPMProject_Span__c=='Local'){
               if(val.getValue()!='BD' && val.getValue()!='Project Leader' && val.getValue()!='Deputy Project Leader' && val.getValue()!='Gate Keeper' &&  val.getValue()!='Technical Leader' )
                IPM_User_Role.add(val.getValue());
              }else{
               if(val.getValue()!='BB' && val.getValue()!='Project Leader' && val.getValue()!='Deputy Project Leader' && val.getValue()!='Gate Keeper' &&  val.getValue()!='Technical Leader' )
                IPM_User_Role.add(val.getValue());
               }
           
        } 
        IPM_User_Role.Sort();
        IPM_User_Role.add('Guest');
    GetGuestUser();    
    getPreviousProject();
    GetAssignedMember();
    
    
    //get list of all users
    AllUsers=[select id,name,IPM_Category__c,IPM_Brand_Name__c,IPM_Role__c from user where IPM_Role__c!=null and IsActive=true and User_License__c='Salesforce' ]; 
    ItemsPLeader=new list<String>();
    lstGateKeeper=new list<String>();
    lstDPL=new list<String>();
    lstTPL=new list<String>();
   
    //get members according to roles
    for(User AU:AllUsers){
        if(AU.IPM_Role__c =='Project Leader'){
            ItemsPLeader.add(AU.Name);
        }
         if(AU.IPM_Role__c =='Gate Keeper'){
            lstGateKeeper.add(AU.Name);
           
        }
        if (AU.IPM_Role__c=='Deputy Project Leader'){
        lstDPL.add(AU.Name);
        }
         if (AU.IPM_Role__c=='Technical Leader' || AU.IPM_Role__c=='Supply Chain' || AU.IPM_Role__c=='R&D'){
        lstTPL.add(AU.Name);
        }
    }
    lstGateKeeper.add(IPM_proj.IPM_Project_Leader__r.Name);
    lstDPL.add(IPM_proj.IPM_Project_Leader__r.Name);
    lstTPL.add(IPM_proj.IPM_Project_Leader__r.Name);
    system.debug('list of users...'+ItemsPLeader+lstTPL+ lstDPL+lstGateKeeper);
    //Select Default Member
    selectedPL=IPM_proj.IPM_Project_Leader__c;
    selectedDPL=IPM_proj.Deputy_Project_Leader__c;
    selectedTL=IPM_proj.IPM_Technical_Project_Leader__c;
    selectedGK=IPM_proj.IPM_Project_Gatekeeper__c;
    PL_ids=IPM_proj.IPM_Project_Leader__c;
    plImage=IPM_proj.IPM_Project_Leader__r.SmallPhotoUrl;//get current project leader image
    PLName=IPM_proj.IPM_Project_Leader__r.Name;// get current project leader name
    if(IPM_proj.IPM_Project_Gatekeeper__c==null){
     GateKeeper_ids=IPM_proj.IPM_Project_Leader__c;
     GKImage=IPM_proj.IPM_Project_Leader__r.SmallPhotoUrl;
     GateKeeperName=IPM_proj.IPM_Project_Leader__r.Name;
    }else{
        GateKeeper_ids=IPM_proj.IPM_Project_Gatekeeper__c;
        GKImage=IPM_proj.IPM_Project_Gatekeeper__r.SmallPhotoUrl;
        GateKeeperName=IPM_proj.IPM_Project_Gatekeeper__r.name;
    }
    if(IPM_proj.Deputy_Project_Leader__r.name==null){
         DPL_ids=IPM_proj.IPM_Project_Leader__c;
         DPLimg=IPM_proj.IPM_Project_Leader__r.SmallPhotoUrl;
         DPLName=IPM_proj.IPM_Project_Leader__r.Name;
     }else{
        DPL_ids=IPM_proj.Deputy_Project_Leader__c;
        DPLName=IPM_proj.Deputy_Project_Leader__r.name;
        DPLimg=IPM_proj.Deputy_Project_Leader__r.SmallPhotoUrl;
    }
    if(IPM_proj.IPM_Technical_Project_Leader__r.name==null){
         TPL_ids=IPM_proj.IPM_Project_Leader__c;
         TPLimg=IPM_proj.IPM_Project_Leader__r.SmallPhotoUrl;
         TPLName=IPM_proj.IPM_Project_Leader__r.Name;
    }else{
      TPL_ids=IPM_proj.IPM_Technical_Project_Leader__c;
      TPLName=IPM_proj.IPM_Technical_Project_Leader__r.name;
      TPLimg=IPM_proj.IPM_Technical_Project_Leader__r.SmallPhotoUrl;
    }
}  
  
//Count team members
public void CountProjectMembers(){
countBB=[select count() from IPM_Project_Resource__c where IPM_Project__c=:ProjectName and IPM_Role_Type__c='BB'];
countBD=[select count() from IPM_Project_Resource__c where IPM_Project__c=:ProjectName and IPM_Role_Type__c='BD'];
countFinance=[select count() from IPM_Project_Resource__c where IPM_Project__c=:ProjectName and IPM_Role_Type__c='Finance'];
countCD=[select count() from IPM_Project_Resource__c where IPM_Project__c=:ProjectName and IPM_Role_Type__c='CD'];
countCMI=[select count() from IPM_Project_Resource__c where IPM_Project__c=:ProjectName and IPM_Role_Type__c='CMI'];
countSupplyChain=[select count() from IPM_Project_Resource__c where IPM_Project__c=:ProjectName and IPM_Role_Type__c='Supply Chain'];
countGuest=[select count() from IPM_Project_Resource__c where IPM_Project__c=:ProjectName and IPM_Role_Type__c='Guest'];
countReDev=[select count() from IPM_Project_Resource__c where IPM_Project__c=:ProjectName and IPM_Role_Type__c='R&D'];
}  
//check for guest user
public void GetGuestUser(){
  list<IPM_Project_Resource__c>lstofguest =new list<IPM_Project_Resource__c>();
  lstofguest =[select id,IPM_User__c,IPM_Role_Type__c
                       from IPM_Project_Resource__c where IPM_Project__r.id=:ProjectName and IPM_Role_Type__c='Guest' and IPM_User__c=:userinfo.getuserid() limit 1];
  if(lstofguest.size()>0){
  isGuestUser=true;
  isBasicProfile=true;
  }                     

} 
 //Get Assigned member list
 public void GetAssignedMember(){
     listofAssignedMem=new list<IPM_Project_Resource__c>();
     listofAssignedMem=[Select id,IPM_User__c,IPM_User__r.name,IPM_User__r.SmallPhotoUrl,IPM_Project_Role_Owner__c,IPM_Role__c,IPM_Role_Type__c
                              from IPM_Project_Resource__c where IPM_Project__r.id=:ProjectName order by IPM_Project_Role_Owner__c desc];
    for(IPM_Project_Resource__c members:listofAssignedMem){
        
        
    }
 }
 
//Get previous project list associated with current project lead
 public List<SelectOption> getPreviousProject()
     {
       
       PreviousProjects= new List<SelectOption>();
       PreviousProjects.add(new selectoption('','Copy Team from Other Projects'));
       List<IPM_Project__c> IPMProject=[select ID,Name,IPM_Project_Name__c from IPM_Project__c where IPM_Project_Leader__r.id=:IPM_proj.IPM_Project_Leader__c  and id !=:ProjectName and IPM_Project_Name__c !=Null order by IPM_Project_Name__c ASC]; 
        if(IPMProject.size()>0)
        {
             for(IPM_Project__c pro:IPMProject)
              {
                  PreviousProjects.add(new selectoption(pro.id,pro.IPM_Project_Name__c));
              }
              
        }
        return PreviousProjects;
    }  
  //Add All previous project members in the current project
  
  public void AddAllPreviousProMembers(){
    try{
       GetAssignedMember();
       list<IPM_Project_Resource__c >previousProjectMem=new list<IPM_Project_Resource__c >();
       previousProjectMem=new list<IPM_Project_Resource__c >();
       if(selectedProject !=Null){
                              previousProjectMem=[select id,IPM_User__c,IPM_User__r.name,IPM_User__r.SmallPhotoUrl,IPM_Project_Role_Owner__c,IPM_Role_Type__c,
                              IPM_Project__r.IPM_Project_Gatekeeper__c,IPM_Project__r.IPM_Project_Gatekeeper__r.SmallPhotoUrl,IPM_Project__r.IPM_Project_Gatekeeper__r.name,
                              IPM_Project__r.Deputy_Project_Leader__c,IPM_Project__r.Deputy_Project_Leader__r.name,IPM_Project__r.Deputy_Project_Leader__r.SmallPhotoUrl,
                              IPM_Project__r.IPM_Technical_Project_Leader__c,IPM_Project__r.IPM_Technical_Project_Leader__r.name,IPM_Project__r.IPM_Technical_Project_Leader__r.SmallPhotoUrl
                              from IPM_Project_Resource__c where IPM_Project__r.id=:selectedProject ];
        }
        
        if(previousProjectMem.size()>0){
           list<IPM_Project_Resource__c>NewMember=new list<IPM_Project_Resource__c>();
           NewMember=new list<IPM_Project_Resource__c>();
          
           for(IPM_Project_Resource__c IPMPrePro:previousProjectMem){
                Boolean IsExist=false;
               if(listofAssignedMem.size()>0){
                   for(IPM_Project_Resource__c IpmListMem:listofAssignedMem){
                       if(IPMPrePro.IPM_User__c==IpmListMem.IPM_User__c){
                          IsExist=true; 
                          break;
                       }
                       
                   }
               }
               if(IsExist==false){
                    IPM_Project_Resource__c CpoyPreviousProjectMem=new IPM_Project_Resource__c();
                    CpoyPreviousProjectMem=new IPM_Project_Resource__c();
                    CpoyPreviousProjectMem.IPM_User__c=IPMPrePro.IPM_User__c;
                    CpoyPreviousProjectMem.IPM_Project_Role_Owner__c=IPMPrePro.IPM_Project_Role_Owner__c;
                    CpoyPreviousProjectMem.IPM_Project__c=ProjectName;
                    CpoyPreviousProjectMem.IPM_Role_Type__c=IPMPrePro.IPM_Role_Type__c;
                    NewMember.add(CpoyPreviousProjectMem);
               } 
            }
          insert  NewMember; // insert previous members in the current project
          NewMember.clear();
        }
         //add core team member
         IPM_Project__c AssignedPro=new IPM_Project__c();
         list<IPM_Project__c>lstupdatedcoremember=new list<IPM_Project__c >();
         lstupdatedcoremember=new list<IPM_Project__c >();
          AssignedPro=[select IPM_Project_Name__c,IPM_Project_Gatekeeper__c,Deputy_Project_Leader__c,IPM_Project_Logo__c,IPM_Technical_Project_Leader__c,IPM_Project_Leader__c,IPM_Project_Description__c,IPM_CPP__c,
                IPM_CPP_Change_Reason__c,IPM_Technical_Project_Leader__r.name,Deputy_Project_Leader__r.name,IPM_Project_Gatekeeper__r.name,IPM_Project_Leader__r.name,IPM_Project_Leader__r.IPM_Category__c,IPM_Project_Leader__r.SmallPhotoUrl,IPM_Technical_Project_Leader__r.SmallPhotoUrl,IPM_Project_Gatekeeper__r.SmallPhotoUrl,Deputy_Project_Leader__r.SmallPhotoUrl from IPM_Project__c
                where id=:selectedProject];
          
        IPM_proj.IPM_Project_Gatekeeper__c=AssignedPro.IPM_Project_Gatekeeper__c;
        IPM_proj.Deputy_Project_Leader__c=AssignedPro.Deputy_Project_Leader__c;
        IPM_proj.IPM_Technical_Project_Leader__c=AssignedPro.IPM_Technical_Project_Leader__c;
        lstupdatedcoremember.add(IPM_proj);
        update lstupdatedcoremember;
        system.debug('IPM_proj....'+IPM_proj);
        selectedProject='';
       
        GateKeeper_ids=AssignedPro.IPM_Project_Gatekeeper__c;
        GKImage=AssignedPro.IPM_Project_Gatekeeper__r.SmallPhotoUrl;
        GateKeeperName=AssignedPro.IPM_Project_Gatekeeper__r.name;
        DPL_ids=AssignedPro.Deputy_Project_Leader__c;
        DPLName=AssignedPro.Deputy_Project_Leader__r.name;
        DPLimg=AssignedPro.Deputy_Project_Leader__r.SmallPhotoUrl;
        TPL_ids=AssignedPro.IPM_Technical_Project_Leader__c;
        TPLName=AssignedPro.IPM_Technical_Project_Leader__r.name;
        TPLimg=AssignedPro.IPM_Technical_Project_Leader__r.SmallPhotoUrl;
       }
       Catch(exception e){
        }
   }  
  
  //for core team members
 public List<SelectOption> getItemsPL() {
  
       PLUser = new List<SelectOption>();
       PLUser.add(new selectoption('','Select'));
       Boolean isUserProLead;
         for(User pl:AllUsers)
          {
              if(pl.IPM_Role__c=='Project Leader' ){
                  if(Pl.id==UserInfo.getUserId()){
                      isUserProLead=true;
                  }
                  PLUser.add(new selectoption(pl.id,pl.name));
                 
                  system.debug('Project Leaders'+ PLUser);
                  }
          }
          if(isUserProLead==false)
          PLUser.add(new selectoption(UserInfo.getUserId(),UserInfo.getName()));
          return PLUser;
         
    }
        
  public List<SelectOption> getItemsGK() {
  
       GatekeeperUser = new List<SelectOption>();
       GatekeeperUser.add(new selectoption('','Select'));
       
         for(User gateKeeper:AllUsers)
          {
              if(gateKeeper.IPM_Role__c=='Gate Keeper')
              
                  GatekeeperUser.add(new selectoption(gateKeeper.id,gateKeeper.name));
          }
          GatekeeperUser.add(new selectoption(UserInfo.getUserId(),UserInfo.getName()));
          return GatekeeperUser;
          
        }
        
       public List<SelectOption> getItemsTL() {
        
          TechLeadUser = new List<SelectOption>();
       TechLeadUser.add(new selectoption('','Select'));
       
         for(User tl:AllUsers)
          {
              if(tl.IPM_Role__c=='Technical Leader' || tl.IPM_Role__c=='R&D')
              
                  TechLeadUser.add(new selectoption(tl.id,tl.name));
          }
          TechLeadUser.add(new selectoption(UserInfo.getUserId(),UserInfo.getName()));
          return TechLeadUser;
          
        }
        
        public List<SelectOption> getItemsDPL() {
        
          DPLUser = new List<SelectOption>();
          DPLUser.add(new selectoption('','Select'));
       
         for(User dpl:AllUsers)
          {
              if(dpl.IPM_Role__c=='Deputy Project Leader')
              
                  DPLUser.add(new selectoption(dpl.id,dpl.name));
          }
          DPLUser.add(new selectoption(UserInfo.getUserId(),UserInfo.getName()));
          return DPLUser ;
                
        }
        
       
    
    
    // get deputy user user Image
    public void DPLImage(){
        //GetAssignedMember();
          // list<IPM_Project_Resource__c >previousProjectMem=new list<IPM_Project_Resource__c >();
          // previousProjectMem=new list<IPM_Project_Resource__c >();
                  
          
           if(selectedDPL!=Null){
                userID=selectedDPL;
                imgURL=new User();
                imgURL=[select name, SmallPhotoUrl
                                  from User where id=:userID];
           
                DPLimg=imgURL.SmallPhotoUrl;
                DPLName=imgURL.name;
              
            }
        }
        
        //get technical leader image
        public void TLImage(){
        //GetAssignedMember();
          // list<IPM_Project_Resource__c >previousProjectMem=new list<IPM_Project_Resource__c >();
          // previousProjectMem=new list<IPM_Project_Resource__c >();
                  
          
           if(selectedTL!=Null){
                userID=selectedTL;
                imgURL=new User();
                imgURL=[select name,SmallPhotoUrl
                                  from User where id=:userID];
           
                TPLimg=imgURL.SmallPhotoUrl;
                TPLName=imgURL.name;
           // system.debug('photo url'+imgURL+'id'+selectedDPL);
            }
        }
        
        //Gate keeper Image
        public void GKImage(){
        //GetAssignedMember();
          // list<IPM_Project_Resource__c >previousProjectMem=new list<IPM_Project_Resource__c >();
          // previousProjectMem=new list<IPM_Project_Resource__c >();
                  
          
           if(selectedGK!=Null){
                userID=selectedGK;
                imgURL=new User();
                imgURL=[select name,SmallPhotoUrl
                                  from User where id=:userID];
           
                GKImage=imgURL.SmallPhotoUrl; 
                GateKeeperName=imgURL.name;
            }
        }
        
        //Get project leader image
        public void PLImageNew(){
           string PLeadName='';
           plImage='';
           PL_ids='';
           PLError=false;
      
           PLeadName=PLName;
           system.debug('PLeadName....'+PLeadName);
           if(PLName !=Null){
           list<User> imgURL=new list<User>();
           imgURL=[select SmallPhotoUrl,id
                                  from User where name=:PLeadName and IPM_Role__c='Project Leader' limit 1];
          if(imgURL.size()>0){
               plImage=imgURL[0].SmallPhotoUrl;
               PL_ids=imgURL[0].id;
               PLError=True;
              }
            
           }
        }
       
       //Get gateKeeper image
       
       Public void GKImageNew(){
            
           string GateKName='';
           GKImage='';
           GateKeeper_ids='';
           GatekepperError=false;
      
           GateKName= GateKeeperName;
           if(GateKName !=Null){
           list<User> imgURL=new list<User>();
           imgURL=[select SmallPhotoUrl,id
                                  from User where name=:GateKName and (IPM_Role__c='Gate Keeper' OR IPM_Role__c='Project Leader') limit 1];
           if(imgURL.size()>0){
               GKImage=imgURL[0].SmallPhotoUrl;
               GateKeeper_ids=imgURL[0].id;
               GatekepperError=true;
            }
            
           }
       }
      //Get deputy project leader image
      public void DPLImageNew(){
       String DPLeadName='';
       DPLeadName=DPLName;
       DPLimg='';
       DPL_ids='';
       DPLError=false;
      
        if(DPLeadName!=Null){
           list<User> imgURL=new list<User>();
           imgURL=[select SmallPhotoUrl,id
                                  from User where name=:DPLName and (IPM_Role__c='Deputy Project Leader' OR IPM_Role__c='Project Leader') limit 1];
           if(imgURL.size()>0){
               DPLimg=imgURL[0].SmallPhotoUrl;
               DPL_ids=imgURL[0].id;
               DPLError=true;
            }
           }
      } 
      //Get technical project leader
      Public void TLImageNew(){
       String TPLeadName='';
       TPLeadName=TPLName;
       TPLimg='';
       TPL_ids='';
       TPLError=false;
        if(TPLeadName!=Null){
           list<User> imgURL=new list<User>();
           imgURL=[select SmallPhotoUrl,id
                                  from User where name=:TPLeadName and (IPM_Role__c='Technical Leader' or IPM_Role__c='Supply Chain' or IPM_Role__c='R&D' OR IPM_Role__c='Project Leader') limit 1];
           if(imgURL.size()>0){
               TPLimg=imgURL[0].SmallPhotoUrl;
               TPL_ids=imgURL[0].id;
               TPLError=true;
             } 
          }
      }
      
         //project leader Image
       public void PLImage(){
           
           
           if(selectedPL!=Null){
                userID=selectedPL;
                plImgFlag=true;
                system.debug('photo url id'+userID);
               SelectImage(userID,plImgFlag); 
           // system.debug('photo url'+imgURL+'id'+selectedDPL);
            }
        }
        
     public void SelectImage(String uID, boolean flag)
      {
              
           imgURL=new User();
           imgURL=[select name,SmallPhotoUrl
                                  from User where id=:uID];
           if(flag==true)
           {
               plImage=imgURL.SmallPhotoUrl;
               PLName=imgURL.name;
           }
      }
      
       //popup effect
          public boolean displayPopup {get; set;}
 
    public void closePopup() {
        displayPopup = false;
    }
 
    public void showPopup() {
        displayPopup = true;
    }
    
    //Save team members
    public pagereference SaveTeamMembers(){
     try{
     
       /*  PLImageNew();
         GKImageNew();
         DPLImageNew();
         TLImageNew();
         
         */
                  
         if(PL_ids!='' && GateKeeper_ids!='' && DPL_ids !='' && TPL_ids !='')
           {   
           IPM_proj.IPM_Project_Leader__c=PL_ids;
           IPM_proj.IPM_Project_Gatekeeper__c=GateKeeper_ids;
           IPM_proj.IPM_Technical_Project_Leader__c=TPL_ids;
           IPM_proj.Deputy_Project_Leader__c=DPL_ids;
           update IPM_proj;
           isTeamMemberSave=true;
           if(PLName!=''){
           
           apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,'Successfully saved'));
           }
         else{
         
             apexpages.addmessage(new apexpages.message(apexpages.severity.info,'Please enter correct project leader name'));
            }
          }else{
             apexpages.addmessage(new apexpages.message(apexpages.severity.Warning,'Please enter valid team members'));
          }  
         }catch(exception e){
         
         }
      return null;
       }
    // Save core team member and gavigate to imp project page
    public PageReference SaveTeamMembers_Nextpage(){
       try{
         
         PLImageNew();
         GKImageNew();
         DPLImageNew();
         TLImageNew();
                
         if(PL_ids!='' && GateKeeper_ids!='' && DPL_ids !='' && TPL_ids !='')
           {
          
            
           IPM_proj.IPM_Project_Leader__c=PL_ids;
           IPM_proj.IPM_Project_Gatekeeper__c=GateKeeper_ids;
           IPM_proj.IPM_Technical_Project_Leader__c=TPL_ids;
           IPM_proj.Deputy_Project_Leader__c=DPL_ids;
           
           if(PLName!=''){
           update IPM_proj;
           pagereference pg=new pagereference('/apex/ipmProject?id='+ProjectName);
           return pg;
         }
         else{
             apexpages.addmessage(new apexpages.message(apexpages.severity.info,'Please enter correct project leader name'));
             
         }
        }else{
            apexpages.addmessage(new apexpages.message(apexpages.severity.Warning,'Please enter valid team members'));
        } 
         }catch(exception e){
         
         } 
        
         return null;
     } 
public pagereference backtohomepg(){
          pagereference pg=new pagereference('/apex/ipmProject?id='+ProjectName);
           return pg;
}
//Wrapper class
public class wrapperclass{
public IPM_Project_Resource__c ProjectResource{get;set;}
//constructor
public void wrapperclass(){

}
}
//Hold selected owner id
public void HodingSelecteOwnerId(){
SelectedRId.add(SelectedRecordId);
list<IPM_Project_Resource__c>lstassignedowner=[select id,IPM_Project_Role_Owner__c from IPM_Project_Resource__c where IPM_Project__c=:ProjectName and IPM_Role_Type__c=:SelectedRoleType and IPM_Project_Role_Owner__c=true];
if(lstassignedowner.size()>0){
IPM_Project_Resource__c Change_FunctionOwner=new IPM_Project_Resource__c(id=lstassignedowner[0].id);
Change_FunctionOwner.IPM_Project_Role_Owner__c=false;
update Change_FunctionOwner;
}
IPM_Project_Resource__c FunctionOwner=new IPM_Project_Resource__c(id=SelectedRecordId);
FunctionOwner.IPM_Project_Role_Owner__c=true;
update FunctionOwner;
if(SelectedRoleType=='R&D'){
//IPM_proj.IPM_Technical_Project_Leader__c=SelectedUserId;
//update IPM_proj;
Initialise();
}
GetAssignedMember();
}

//Save Updated Core project members
public void SaveCoreMembers(){
    if(selectedPL !='' && selectedDPL !='' && selectedTL !='' && selectedGK !=''){
           IPM_proj.IPM_Project_Leader__c=selectedPL;
           IPM_proj.IPM_Project_Gatekeeper__c=selectedGK;
           IPM_proj.IPM_Technical_Project_Leader__c=selectedTL;
           IPM_proj.Deputy_Project_Leader__c=selectedDPL;
           update IPM_proj;
           isGateKShow=false;
           isTPLShow=false;
           isPLShow=false;
           isDPLShow=false;
           isTeamMemberSave=true;
    }
}
//To display GateKeeper list on click of edit
public void showGateKlist(){
isGateKShow=true;
}
//To display TPL list on click of edit
public void showTPLlist(){
isTPLShow=true;
}
//To display PL list on click of edit
public void showPLlist(){
isPLShow=true;
}
//To display DPL list on click of edit
public void showDPLlist(){
isDPLShow=true;
}
//Delete Assigned Member
public void DeleteAssignedmembers(){
try{
    IPM_Project_Resource__c DeleteRecord=new IPM_Project_Resource__c(id=IPMResourceId);
    delete DeleteRecord;
    GetAssignedMember();
    CountProjectMembers();
    }catch(exception e){
    
    }
}
// Get user type with access permission
 public void getIpmuserType(){
 list<IPM_Project_Resource__c>lstProuser=[select IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,IPM_Project__r.IPM_Project_Leader__c from IPM_Project_Resource__c where 
                                         IPM_Project__c=:ProjectName and IPM_User__c=:userinfo.getuserid() and IPM_Project_Role_Owner__c=true limit 1];
 if(lstProuser.size()>0){
    loginusertype=lstProuser[0].IPM_Role_Type__c;
    isEditable=true;
    if(lstProuser[0].IPM_Role_Type__c=='BD'){
    isEditable=true;
       
    }else if(lstProuser[0].IPM_Role_Type__c=='CMI'){
     isEditable=true;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='CD'){
     isEditable=true;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='R&D'){
    isEditable=true;
    isTPLEditable=true;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='Supply Chain'){
     isEditable=true;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='Finance'){
     isEditable=true;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='BB'){
     isEditable=false;
    }
 } 
 list<IPM_Project__c>lstofuser=[select IPM_Project_Leader__c from IPM_Project__c where 
                                        id=:ProjectName and (IPM_Project_Leader__c =:userinfo.getuserid() 
                                         or Deputy_Project_Leader__c=:userinfo.getuserid() ) limit 1];

 if(lstofuser.size()>0){
    //if(lstofuser[0].IPM_Project_Leader__c==userinfo.getuserid()){
    isCoreMemEditable=true;
    //}
    isEditable=true;  
 }else{
  //isEditable=false;
 }
list<PermissionSetAssignment>PermissonS=[select Assignee.Name, PermissionSet.Name
                                        from PermissionSetAssignment where (PermissionSet.Name='IPM_Central_Team' or PermissionSet.Name='IPM_Business_Partners'
                                         or PermissionSet.Name='IPM_BB_PL') and Assignee.id=:userinfo.getuserid()];
if(PermissonS.size()>0){
 isEditable=true;
 isCoreMemEditable=true;
 }                                       
} 
//show edit team members
public void ShowEditTeam(){
if(isShowEditmode==false){
    isShowEditmode=true;
}else{
 isShowEditmode=false;
}

}  
 }