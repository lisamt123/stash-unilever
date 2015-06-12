/* Type Name: ipmCoreParametersViewController
Author: Rajesh and Samrat
Created Date: 29-10-2014
Reason: To meet requirements for Project Financial Group  REQ */
public class IPM_CoreParametersViewController {
    //Variable Declaration
public String Q1_Opt1{get;set;}//store option 1 for question no.1
public String Q1_Opt2{get;set;}//store option 2 for question no.1
public String Q1_Opt3{get;set;}//store option 3 for question no.1
public String Q1_Opt4{get;set;}//store option 4 for question no.1
public String Q1_Opt5{get;set;}//store option 5 for question no.1
public String Q1_Opt6{get;set;}//store option 6 for question no.1
public String Q1_Opt7{get;set;}//store option 7 for question no.1
public String Q1_Opt8{get;set;}//store option 8 for question no.1
public String Q1_Opt9{get;set;}//store option 9 for question no.1
public String Q1_Opt10{get;set;}//store option 10 for question no.1
public String Q1_Opt11{get;set;}//store option 11 for question no.1
public String Q1_Opt12{get;set;}//store option 12 for question no.1
public String Q1_Opt13{get;set;}//store option 13 for question no.1
public String Q1_Opt14{get;set;}//store option 14 for question no.1
public String Q2_description{get;set;}//store question no.2 description
public String Q2_Opt1{get;set;}//store option 1 for question no.2
public String Q2_Opt2{get;set;}//store option 2 for question no.2
public String Q2_Opt3{get;set;}//store option 3 for question no.2
public String Q2_Opt4{get;set;}//store option 4 for question no.2
public String Q2_Opt5{get;set;}//store option 5 for question no.2
public String Q3_description{get;set;}//store question no.3 description
public String Q3_Opt1{get;set;}//store option 1 for question no.3
public String Q3_Opt2{get;set;}//store option 2 for question no.3
public String Q3_Opt3{get;set;}//store option 3 for question no.3
public String Q3_Opt4{get;set;}//store option 4 for question no.3
public boolean isAnswer1Empty{get;set;}
public boolean isAnswer2Empty{get;set;}
public boolean isAnswer3Empty{get;set;}
public boolean isRegionEmpty{get;set;}
public boolean isCompanyEmpty{get;set;}
public boolean isPlatformEmpty{get;set;} 
public boolean isAnswer2asterisk{get;set;}
public boolean isAnswer3asterisk{get;set;}
public boolean isProjectSpanEmpty{get;set;} 
public boolean isProjectTypeEmpty{get;set;}   
public IPM_Project__c ProjectCoreParemeters{get;set;}
public string ProjectName{get;set;}
public boolean isDPLeader{get;set;}
public boolean isPLeader{get;set;}
public boolean isEditable{get;set;}
Public IPM_CoreParameter_Strategic_help_content__c StrategicHelp{get;set;}
public string Innovationtxt{get;set;}
public string Renovationtxt{get;set;}
public string BLGtxt{get;set;}
    /*
    Type Name: wrapCSV
    Reason: Store Business Case CSV data */
   
    //Initializing Constructor
    public IPM_CoreParametersViewController()
    {
         ProjectCoreParemeters = new IPM_Project__c();
         ProjectName=ApexPages.currentPage().getParameters().get('id');
         isAnswer1Empty=false;
         isAnswer2Empty=false;
         isAnswer3Empty=false;
         isRegionEmpty=false;
         isCompanyEmpty=false;
         isPlatformEmpty=false;
         isAnswer2asterisk=false;
         isAnswer3asterisk=false;
         isProjectSpanEmpty=false;
         isProjectTypeEmpty=false;
         isEditable=false;
         system.debug('bossid........'+ProjectName);
         if(ProjectName !=null){
         list<IPM_Project__c>checktocreated=new list<IPM_Project__c>();
         checktocreated=[Select id,name,Deputy_Project_Leader__c,IPM_Project_Leader__c from IPM_Project__c where id =:ProjectName limit 1];
         if(checktocreated.size()>0){
         ProjectCoreParemeters = [Select id,name,IPM_GateKeeping_Model__c, IPM_IsCompleted__c,IPM_Answer_of_Q1__c,IPM_Answer_of_Q2__c,IPM_Answer_of_Q3__c,
                                     IPM_Company_Card__r.name,IPM_Market__c,IPMProject_Span__c,IPMCompany__c,IPMPlatform__c,IPM_Approver_of_Contract_Market_Ready__c,IPM_Approver_of_Charter__c,IPM_Fast_Track_Project__c,
                                     IPM_Target_Launch_Dates__c,IPM_Category_Text__c,IPM_Brand_Positioning__c,IPM_Brand__c,IPM_Project_Description__c,
                                     IPMProject_Type__c,IPMRegion__c,IPM_Sector__c,IPM_Sub_sector__c,IPM_Category__c,IPM_Category_Group__c
                                     from IPM_Project__c where id =:ProjectName Limit 1];
               }
        
       if(checktocreated[0].Deputy_Project_Leader__c==userinfo.getuserid() && checktocreated[0].IPM_Project_Leader__c==userinfo.getuserid() ){
         isPLeader=true; 
       }
      else if(checktocreated[0].Deputy_Project_Leader__c==userinfo.getuserid()){
       isDPLeader=true;
       }
       if(checktocreated[0].IPM_Project_Leader__c==userinfo.getuserid()){
        isPLeader=true;
       }  
           
        QuestionOne();
        QuestionTwo();
        QuestionThree();  
        if(ProjectCoreParemeters.IPMProject_Type__c==system.label.IPM_GlobalProject){
           
            if(ProjectCoreParemeters.IPM_Answer_of_Q1__c==Q1_Opt9){
                   if(ProjectCoreParemeters.IPM_Answer_of_Q2__c==null){
                         isAnswer2asterisk=true;
                         
                 }
              }else{
               if(ProjectCoreParemeters.IPM_Answer_of_Q2__c==null){
                         isAnswer2asterisk=true;
                         
                 }
                if(ProjectCoreParemeters.IPM_Answer_of_Q3__c==null){
                         isAnswer3asterisk=true;
                         
                 }
              }
            } 
           if(ProjectCoreParemeters.IPM_Answer_of_Q1__c==null){
           
              if(ProjectCoreParemeters.IPM_Answer_of_Q2__c==null){
                         isAnswer2asterisk=true;
                }
              
              if(ProjectCoreParemeters.IPM_Answer_of_Q3__c==null){
                         isAnswer3asterisk=true;
                 }   
             }          
    }
   getIpmuserType();
   Strategichelp();
   } 
//Method to get Strategic help text
public void Strategichelp(){
IPM_CoreParameter_Strategic_help_content__c StrategicHelp=IPM_CoreParameter_Strategic_help_content__c.getInstance('IPM CoreParameter Strategic text');
Innovationtxt=StrategicHelp.IPM_Innovation__c;
Renovationtxt=StrategicHelp.IPM_Renovation__c;
BLGtxt=StrategicHelp.IPM_BLG__c;
}   
//Method to get question number one
public void QuestionOne(){
   IPM_CoreParameter__c QuestionOne=IPM_CoreParameter__c.getInstance('Question one');
   Q1_Opt1=QuestionOne.Q1__c;
   Q1_Opt2=QuestionOne.Q2__c;
   Q1_Opt3=QuestionOne.Q3__c;
   Q1_Opt4=QuestionOne.Q4__c;
   Q1_Opt5=QuestionOne.Q5__c;
   Q1_Opt6=QuestionOne.Q6__c;
   Q1_Opt7=QuestionOne.Q7__c;
   Q1_Opt8=QuestionOne.Q8__c;
   Q1_Opt9=QuestionOne.Q9__c;
   Q1_Opt10=QuestionOne.Q10__c;
   Q1_Opt11=QuestionOne.Q11__c;
   Q1_Opt12=QuestionOne.Q12__c;
   Q1_Opt13=QuestionOne.Q13__c;
   Q1_Opt14=QuestionOne.Q14__c;
  }
//Method to get question number two
public void QuestionTwo(){
     IPM_CoreParameter__c QuestionTwo=IPM_CoreParameter__c.getInstance('Question two');
     Q2_Opt1=QuestionTwo.Q1__c;
     Q2_Opt2=QuestionTwo.Q2__c;
     Q2_Opt3=QuestionTwo.Q3__c;
     Q2_Opt4=QuestionTwo.Q4__c;
     Q2_Opt5=QuestionTwo.Q5__c;
   }
//Method to get question number three
public void QuestionThree(){
     IPM_CoreParameter__c QuestionThree=IPM_CoreParameter__c.getInstance('Question three');
     Q3_Opt1=QuestionThree.Q1__c;
     Q3_Opt2=QuestionThree.Q2__c;
     Q3_Opt3=QuestionThree.Q3__c;
     Q3_Opt4=QuestionThree.Q4__c;
    }       
    
    /*
Type Name: ReadFile()
Parameter(s)
ReturnType: PageReference
Reason:  */
   
     public PageReference BackToProjectIntermediate(){
            if(ProjectCoreParemeters.IPM_Answer_of_Q1__c==null){
               isAnswer1Empty=true;
              } 
            if(ProjectCoreParemeters.IPMRegion__c==null){
              isRegionEmpty=true;
              } 
            if( ProjectCoreParemeters.IPMCompany__c==null){
              isCompanyEmpty=true;
              }
            if( ProjectCoreParemeters.IPMPlatform__c==null){
               isPlatformEmpty=true;
             }
            if(ProjectCoreParemeters.IPMProject_Type__c==null){
            
                 isProjectTypeEmpty=true;
            } 
            if(ProjectCoreParemeters.IPMProject_Span__c==null){
                 isProjectSpanEmpty=true;
            } 
           if(ProjectCoreParemeters.IPMProject_Type__c==system.label.IPM_GlobalProject){
           
            if(ProjectCoreParemeters.IPM_Answer_of_Q1__c==Q1_Opt9){
                   if(ProjectCoreParemeters.IPM_Answer_of_Q2__c==null){
                         isAnswer2Empty=true;
                         
                 }
              }else{
               if(ProjectCoreParemeters.IPM_Answer_of_Q2__c==null){
                         isAnswer2Empty=true;
                         
                 }
                if(ProjectCoreParemeters.IPM_Answer_of_Q3__c==null){
                         isAnswer3Empty=true;
                         
                 } 
              }
            } 
           if(ProjectCoreParemeters.IPM_Answer_of_Q1__c==null){
           
              if(ProjectCoreParemeters.IPM_Answer_of_Q2__c==null){
                         isAnswer2Empty=true;
                }
              
              if(ProjectCoreParemeters.IPM_Answer_of_Q3__c==null){
                         isAnswer3Empty=true;
                 }   
             }      
           if(ProjectCoreParemeters.IPM_Answer_of_Q1__c!=null && ProjectCoreParemeters.IPMRegion__c!=null && ProjectCoreParemeters.IPMCompany__c!=null && ProjectCoreParemeters.IPMPlatform__c!=null){
            if(ProjectCoreParemeters.IPMProject_Type__c==system.label.IPM_GlobalProject){
              
                if(ProjectCoreParemeters.IPM_Answer_of_Q1__c==Q1_Opt9){
                   if(ProjectCoreParemeters.IPM_Answer_of_Q2__c==null){
                         isAnswer2Empty=true;
                         ApexPages.addmessage(new apexpages.message(apexpages.severity.error,system.label.IPM_CoreParameters_validation));
                         return null; 
                 }  
                }else{
               
                if(ProjectCoreParemeters.IPM_Answer_of_Q2__c==null || ProjectCoreParemeters.IPM_Answer_of_Q3__c==null ){
                   if(ProjectCoreParemeters.IPM_Answer_of_Q2__c==null){
                    isAnswer2Empty=true;
                   }
                   if(ProjectCoreParemeters.IPM_Answer_of_Q3__c==null){
                    isAnswer3Empty=true;
                   }
                    ApexPages.addmessage(new apexpages.message(apexpages.severity.error,system.label.IPM_CoreParameters_validation));
                 return null;
                }
              }
            }
               ProjectCoreParemeters.IPM_IsCompleted__c=true;
               update ProjectCoreParemeters;
               pagereference pg=new pagereference('/apex/ipmProject?id='+ProjectName);
               return pg;
        }
        else {
              
              ApexPages.addmessage(new apexpages.message(apexpages.severity.error,system.label.IPM_CoreParameters_validation));
              return null;
        
        }
        
     }
     
public pagereference ProjectIntermediate(){
               pagereference pg=new pagereference('/apex/ipmProject?id='+ProjectName);
               return pg;
}
// Get user type with access permission
 public void getIpmuserType(){
 list<IPM_Project_Resource__c>lstProuser=[select IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,IPM_Project__r.IPM_Project_Leader__c from IPM_Project_Resource__c where 
                                         IPM_Project__c=:ProjectName and IPM_User__c=:userinfo.getuserid() limit 1];
 if(lstProuser.size()>0){
    
    if(lstProuser[0].IPM_Role_Type__c=='BD'){
    isEditable=false;
       
    }else if(lstProuser[0].IPM_Role_Type__c=='CMI'){
     isEditable=true;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='CD'){
     isEditable=false;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='R&D'){
    isEditable=false;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='Supply Chain'){
     isEditable=false;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='Finance'){
     isEditable=false;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='BB'){
     isEditable=true;
    }
 } 
if(isEditable==false){
 list<IPM_Project__c>lstofuser=[select IPM_Project_Leader__c from IPM_Project__c where 
                                        id=:ProjectName and (IPM_Project_Leader__c =:userinfo.getuserid() or IPM_Technical_Project_Leader__c=:userinfo.getuserid() 
                                         or Deputy_Project_Leader__c=:userinfo.getuserid() ) limit 1];

 if(lstofuser.size()>0){
    isEditable=true;  
 }else{
  isEditable=false;
 }
}
list<PermissionSetAssignment>PermissonS=[select Assignee.Name, PermissionSet.Name
                                        from PermissionSetAssignment where (PermissionSet.Name='IPM_Central_Team' or PermissionSet.Name='IPM_Business_Partners') and Assignee.id=:userinfo.getuserid()];
 if(PermissonS.size()>0){
 isEditable=true;
}                                       
system.debug('isEditable.....'+isEditable);
                                         
 } 
}