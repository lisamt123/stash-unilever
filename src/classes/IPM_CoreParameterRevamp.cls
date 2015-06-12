public with sharing class IPM_CoreParameterRevamp {

/* Type Name: ipmCoreParameters
Author: Rajesh Kumar
Created Date:27/10/2014
Reason: To meet requirements   */

public String Q1_description{get;set;}//store question no.1 description
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
public Boolean IsQuestionOne{get;set;}//Flag for question no.1
public Boolean IsQuestionTwo{get;set;}//Flag for question no.2
public Boolean IsQuestionThree{get;set;}//Flag for question no.3
public string ProjectID{get;set;}//store project id from url parameter
public IPM_Project__c Ipm_project{get;set;}
public IPM_Project__c IPM_Coreparameter{get;set;}//get details of coreparameter
public IPM_Project__c IPM_CoreparameterProjectSpan{get;set;}
public String CoreparameterId{get;set;}
public string SelectedAnswer{get;set;}
public string SelectedQuestion{get;set;}
public IPM_CorePara_helps_example__c lstIpmCoreHelp{get;set;}
public IPM_CorePara_helps_example__c lstIpmCoreHelpQ2{get;set;}
public IPM_CorePara_helps_example__c lstIpmCoreHelpQ3{get;set;}
public string BosscardID{get;set;}
public Boolean saveQuestionOne{get;set;}//Display successfull message of question number one
public Boolean saveQuestionTwo{get;set;}//Display successfull message of question number two 
public Boolean saveQuestionThree{get;set;}//Display successfull message of question number three 
public Boolean saveMarket{get;set;}//Display successfull message of market
public string projecttype{get;set;}
public string Answerone{get;set;}
public Boolean IsBLG{get;set;}
public Boolean targetLaunchDateValidationPopup {get;set;}
public Integer error{get;set;}
public Integer closepopup{get;set;}
Public Boolean isEditable{get;set;}
Public IPM_CoreParameter_Strategic_help_content__c StrategicHelp{get;set;}
public string Innovationtxt{get;set;}
public string Renovationtxt{get;set;}
public string BLGtxt{get;set;}
public Boolean isSavedCoreparameter{get;set;}
public boolean isMarketMandatory{get;set;}
public list<selectoption>lstCompany{get;set;}
public id selectedCompany{get;set;}
//Project values
public IPM_Project__c IPMProjects{get;set;}
public String CompanyType{get;set;}
public string coreptab{get;set;}
public string addcorepara{get;set;}
//get market and sub sector data
public list<selectoption>lstmarket{get;set;}
public list<selectoption>lstsubsector{get;set;}
public string selectedmarket{get;set;}
public string selectedsubsector{get;set;}

//Contructor
public IPM_CoreParameterRevamp (){
    isEditable=false;
    selectedmarket='';
    selectedsubsector='';
    coreptab='';
    addcorepara='';
    CompanyType='';
    error = 0;
    closepopup=0;
    projecttype='';
    saveQuestionOne=false;
    targetLaunchDateValidationPopup  = false;
    isMarketMandatory=false;
    saveQuestionTwo=false;
    saveQuestionThree=false;
    saveMarket=false;
    IsBLG=false;
    SelectedAnswer='';
    SelectedQuestion='';
    IsQuestionOne=true;
    IsQuestionTwo=false;
    IsQuestionThree=false;
    ProjectID='';
    CoreparameterId='';
    Answerone='';
    IPMProjects=new IPM_Project__c();
    BosscardID=apexpages.currentpage().getparameters().get('id'); 
    if(BosscardID== Null || BosscardID== ''){
    BosscardID=apexpages.currentpage().getparameters().get('Pid');
    }
    IPM_Coreparameter=new IPM_Project__c();
    lstIpmCoreHelp=new IPM_CorePara_helps_example__c();
    IPM_Project__c ipmproject=new IPM_Project__c ();
    system.debug('Boss............'+ BosscardID);
    //ipmproject =[select id from IPM_Project__c  where IPM_Bosscard__c=:BosscardID limit 1];
    ProjectID=BosscardID;
    IPMProjects=[select IPM_Complexity__c,IPM_Target_Launch_Dates__c,IPM_PM_Approach__c,IPM_GateKeeping_Model__c from IPM_Project__c where id=:ProjectID];
    system.debug('ProjectID..........'+ ProjectID);
    IPM_CoreparameterProjectSpan = new IPM_Project__c();
   // ipmSoqlUtilities.IPM_ProjectID=ProjectID;  
    list<IPM_Project__c> CPProject=new list<IPM_Project__c>();
    CPProject=[select IPM_Answer_of_Q1__c,IPM_Category_Text__c,IPM_BET_Toolkit__c,IPM_Answer_of_Q2__c,IPM_Answer_of_Q3__c,IPM_Company_Card__c,
                            IPMProject_Span__c,IPMProject_Type__c,IPM_Category__c,IPM_Category_Group__c,IPMCompany__c,IPM_Market__c,IPMPlatform__c,IPMRegion__c,IPM_Sector__c,IPM_Sub_sector__c                       
                        from IPM_Project__c where id=:ProjectID limit 1];
    if(CPProject.size()>0){
    Answerone = CPProject[0].IPM_Answer_of_Q1__c;
    CoreparameterId=CPProject[0].id;
    IPM_Coreparameter.id=CPProject[0].id;
    IPM_Coreparameter.IPM_BET_Toolkit__c=CPProject[0].IPM_BET_Toolkit__c;
    IPM_Coreparameter.IPM_Category__c=CPProject[0].IPM_Category__c;
    IPM_Coreparameter.IPM_Category_Group__c=CPProject[0].IPM_Category_Group__c;
    IPM_Coreparameter.IPMCompany__c=CPProject[0].IPMCompany__c;
    IPM_Coreparameter.IPM_Market__c=CPProject[0].IPM_Market__c;
    IPM_Coreparameter.IPMPlatform__c=CPProject[0].IPMPlatform__c;
    IPM_Coreparameter.IPMRegion__c=CPProject[0].IPMRegion__c;
    IPM_Coreparameter.IPM_Sector__c=CPProject[0].IPM_Sector__c;
    IPM_Coreparameter.IPM_Sub_sector__c=CPProject[0].IPM_Sub_sector__c;
    IPM_Coreparameter.IPM_Answer_of_Q1__c=CPProject[0].IPM_Answer_of_Q1__c;
    IPM_Coreparameter.IPM_Answer_of_Q2__c=CPProject[0].IPM_Answer_of_Q2__c;
    IPM_Coreparameter.IPM_Answer_of_Q3__c=CPProject[0].IPM_Answer_of_Q3__c;
    IPM_Coreparameter.IPM_Category_Text__c =CPProject[0].IPM_Category_Text__c;
    projecttype=CPProject[0].IPMProject_Type__c;
    selectedCompany=CPProject[0].IPM_Company_Card__c;
    CompanyType=CPProject[0].IPMProject_Span__c;
    try{
    if(CPProject[0].IPM_Answer_of_Q1__c !=null){
    lstIpmCoreHelp=[select IPM_Core_Parameter_Helps__c,IPM_Core_Parameter_example__c,IPM_Core_Parameter_example_two__c,
                              IMP_Core_Parameter_example_three__c,IPM_Core_Parameter_example_four__c,
                              IPM_Core_Parameter_example_five__c from  IPM_CorePara_helps_example__c where IPM_Answer__c=:CPProject[0].IPM_Answer_of_Q1__c limit 1];
    }
    if(CPProject[0].IPM_Answer_of_Q2__c !=null){ 
     lstIpmCoreHelpQ2=[select IPM_Core_Parameter_Helps__c,IPM_Core_Parameter_example__c,IPM_Core_Parameter_example_two__c,
                              IMP_Core_Parameter_example_three__c,IPM_Core_Parameter_example_four__c,
                              IPM_Core_Parameter_example_five__c from  IPM_CorePara_helps_example__c where IPM_Answer__c=:CPProject[0].IPM_Answer_of_Q2__c limit 1];  
     }
    if(CPProject[0].IPM_Answer_of_Q3__c !=null){            
     lstIpmCoreHelpQ3=[select IPM_Core_Parameter_Helps__c,IPM_Core_Parameter_example__c,IPM_Core_Parameter_example_two__c,
                              IMP_Core_Parameter_example_three__c,IPM_Core_Parameter_example_four__c,
                              IPM_Core_Parameter_example_five__c from  IPM_CorePara_helps_example__c where IPM_Answer__c=:CPProject[0].IPM_Answer_of_Q3__c limit 1];                                                         
     }
    }catch(exception e){
    
    } 
   }      
    ProjectDetails();
    QuestionOne();
    QuestionTwo();
    QuestionThree();
    getIpmuserType();
    system.debug('Q2Ans.......'+IPM_Coreparameter.IPM_Answer_of_Q2__c);
    Strategichelp();
    getmarket();
    getsubsector();
}
//find company card type
public void searchprojectpahse(){
list<IPM_Company_Card__c >CompanyCard=[select RecordType.Name from IPM_Company_Card__c where id=:selectedCompany];
    if(CompanyCard.size()>0){
           string REType=CompanyCard[0].RecordType.Name;
           if(REType.contains('Global')){
           CompanyType='Global';
           }else if(REType.contains('Regional')){
           CompanyType='Regional';
           }else{
           CompanyType='Local';
            }
       }
}
//Get all comapny card related to current login user
 public List<SelectOption> getAllcompanycard()
     {
       
       lstCompany= new List<SelectOption>();
       lstCompany.add(new selectoption('','Select Company Card'));
       List<IPM_User_Profile__c> ipmcompanycard=[select ID,IPM_Company_Card__c,IPM_Company_Card__r.name from IPM_User_Profile__c where IPM_User__c=:userinfo.getuserid() and  IPM_Company_Card__c <>null and IPM_Company_Card__r.name!=null order by IPM_Company_Card__r.name ASC]; 
        if(ipmcompanycard.size()>0)
        {
             for(IPM_User_Profile__c pro:ipmcompanycard)
              {
                  lstCompany.add(new selectoption(pro.IPM_Company_Card__c,pro.IPM_Company_Card__r.name));
              }
              
        }
        return lstCompany;
    }  
//Method to get selected project details
public void ProjectDetails(){
    Ipm_project=new IPM_Project__c();
    if(ProjectID !=null){
    //Ipm_project=[select name from IPM_Project__c where id=:ProjectID];
    }
    
}
//Method to get Strategic help text
public void Strategichelp(){
IPM_CoreParameter_Strategic_help_content__c StrategicHelp=IPM_CoreParameter_Strategic_help_content__c.getInstance('IPM CoreParameter Strategic text');
Innovationtxt=StrategicHelp.IPM_Innovation__c;
Renovationtxt=StrategicHelp.IPM_Renovation__c;
BLGtxt=StrategicHelp.IPM_BLG__c;
}
/* Type Name: getBETToolkit()
Author: 
Parameter(s)
ReturnType: List
Reason: For getting charter approver */  
    public List<SelectOption> getBETToolkit(){
            Schema.sObjectType sobject_type = IPM_Project__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('IPM_BET_Toolkit__c').getDescribe().getPickListValues();

            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));
          }
      return options;
     }
//Method to get question number one
public void QuestionOne(){
   IPM_CoreParameter__c QuestionOne=IPM_CoreParameter__c.getInstance('Question one');
   Q1_description=QuestionOne.Question__c;
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
     Q2_description=QuestionTwo.Question__c;
     Q2_Opt1=QuestionTwo.Q1__c;
     Q2_Opt2=QuestionTwo.Q2__c;
     Q2_Opt3=QuestionTwo.Q3__c;
     Q2_Opt4=QuestionTwo.Q4__c;
     Q2_Opt5=QuestionTwo.Q5__c;
   }
//Method to get question number three
public void QuestionThree(){
     IPM_CoreParameter__c QuestionThree=IPM_CoreParameter__c.getInstance('Question three');
     Q3_description=QuestionThree.Question__c;
     Q3_Opt1=QuestionThree.Q1__c;
     Q3_Opt2=QuestionThree.Q2__c;
     Q3_Opt3=QuestionThree.Q3__c;
     Q3_Opt4=QuestionThree.Q4__c;
    }   
//Method to get previous question
public void PreviousQiestion(){
    if( IsQuestionTwo==true){
      IsQuestionOne=true;
      IsQuestionTwo=false;  
      QuestionOne();
    }
    else if( IsQuestionThree==true){
     IsQuestionTwo=true;
     IsQuestionThree=false;
     QuestionTwo();
    }
} 
//Method to get next question
public void NextQuestion(){
    if(IsQuestionOne==true){
    IsQuestionOne=false;
    IsQuestionTwo=true;
    QuestionTwo();
    }
    else if(IsQuestionTwo==true){
    IsQuestionTwo=false;
    IsQuestionThree=true;
    QuestionThree();
    }
 } 
 
//method to update answer
public void SelectedAnswer(){
  
     try{
    saveQuestionOne=false;
    saveQuestionTwo=false;
    saveQuestionThree=false;
    saveMarket=false;
    IPM_Coreparameter=new IPM_Project__c();
    list<IPM_Project__c>BeforecreatedCP=new list<IPM_Project__c>();
    BeforecreatedCP=[select IPM_Answer_of_Q1__c,IPM_Answer_of_Q2__c,IPM_Answer_of_Q3__c                       
                        from IPM_Project__c where id=:ProjectID limit 1];
     if(SelectedQuestion=='Question1'){
        if(SelectedAnswer==Q1_Opt1 || SelectedAnswer==Q1_Opt2 || SelectedAnswer==Q1_Opt3 || SelectedAnswer==Q1_Opt4 ||SelectedAnswer==Q1_Opt5 || SelectedAnswer==Q1_Opt6
                                        || SelectedAnswer==Q1_Opt7 || SelectedAnswer==Q1_Opt8 || SelectedAnswer==Q1_Opt9){
        if(SelectedAnswer==Q1_Opt9){
            IPM_Coreparameter.IPM_Answer_of_Q3__c='';
            system.debug('Q2Ans.......'+IPM_Coreparameter.IPM_Answer_of_Q2__c +'....'+Q2_Opt1);
             if(BeforecreatedCP.size()>0){
                if(BeforecreatedCP[0].IPM_Answer_of_Q2__c==Q2_Opt1){
                lstIpmCoreHelpQ2.clear();
              }
            }
        }
        projecttype=system.label.IPM_GlobalProject; 
        }else{
            IPM_Coreparameter.IPM_Answer_of_Q2__c='';
            IPM_Coreparameter.IPM_Answer_of_Q3__c='';
            projecttype=system.label.IPM_GlobalOperationalProject;
            
           }
        IPM_Coreparameter.IPMProject_Type__c=projecttype;   
      }
      
    if(BeforecreatedCP.size()>0){
      CoreparameterId=BeforecreatedCP[0].id;
      if(SelectedQuestion=='Question1'){
            IPM_Coreparameter.IPM_Answer_of_Q1__c=SelectedAnswer;
            Answerone=SelectedAnswer;
           }
           else if(SelectedQuestion=='Question2'){
            IPM_Coreparameter.IPM_Answer_of_Q2__c=SelectedAnswer;
            }
          else if(SelectedQuestion=='Question3'){
            IPM_Coreparameter.IPM_Answer_of_Q3__c=SelectedAnswer;
          }
      //CoreParaId=BeforecreatedCP[0].id;
      IPM_Coreparameter.id=BeforecreatedCP[0].id;
      update IPM_Coreparameter;
    }else{
           if(SelectedQuestion=='Question1'){
            IPM_Coreparameter.IPM_Answer_of_Q1__c=SelectedAnswer;
            Answerone=SelectedAnswer;
           }
           else if(SelectedQuestion=='Question2'){
            IPM_Coreparameter.IPM_Answer_of_Q2__c=SelectedAnswer;
            }
          else if(SelectedQuestion=='Question3'){
            IPM_Coreparameter.IPM_Answer_of_Q3__c=SelectedAnswer;
          }
           IPM_Coreparameter.id=ProjectId;
           /* For CoreParameter Market,Sector,Sub-Sector,GIC,Region and Platform fields default values */
           if(IPM_Coreparameter.IPM_Market__c==null)
           {
               IPM_Coreparameter.IPM_Market__c='Dishwash';               
           }
           if(IPM_Coreparameter.IPM_Sector__c==null)
           {
               IPM_Coreparameter.IPM_Sector__c='Cleaning Tools';               
           }
           if(IPM_Coreparameter.IPM_Sub_sector__c==null)
           {
               IPM_Coreparameter.IPM_Sub_sector__c='Machine Wash';               
           }
           if(IPM_Coreparameter.IPMRegion__c==null)
           {
               IPM_Coreparameter.IPMRegion__c='Europe';               
           }
           if(IPM_Coreparameter.IPMPlatform__c==null)
           {
               IPM_Coreparameter.IPMPlatform__c='Sample 1';               
           }
           if(IPM_Coreparameter.IPMCompany__c==null)
           {
               IPM_Coreparameter.IPMCompany__c='GIC HHC';               
           }
           update IPM_Coreparameter;
           CoreparameterId=IPM_Coreparameter.id;
           //CoreParaId=IPM_Coreparameter.id; 
    } 
  IPM_Coreparameter=[select IPM_Answer_of_Q1__c,IPM_Category_Text__c,IPM_BET_Toolkit__c,IPM_Answer_of_Q2__c,IPM_Answer_of_Q3__c,IPM_Category__c,
                        IPM_Category_Group__c,IPMCompany__c,IPM_Market__c,IPMPlatform__c,
                        IPMRegion__c,IPM_Sector__c,IPM_Sub_sector__c                        
                        from IPM_Project__c where id=:ProjectID limit 1];
   if(IPM_Coreparameter.IPM_Answer_of_Q1__c=='BLG'){
       IsBLG=true;
   } else{
    IsBLG=false;
   } 
   system.debug('BLG....'+ SelectedAnswer); 
  if(SelectedQuestion=='Question1'){                 
  lstIpmCoreHelp=[select IPM_Core_Parameter_Helps__c,IPM_Core_Parameter_example__c,IPM_Core_Parameter_example_two__c,
                              IMP_Core_Parameter_example_three__c,IPM_Core_Parameter_example_four__c,
                              IPM_Core_Parameter_example_five__c from  IPM_CorePara_helps_example__c where IPM_Answer__c=:SelectedAnswer limit 1];
   }
  if(SelectedQuestion=='Question2'){                           
  lstIpmCoreHelpQ2=[select IPM_Core_Parameter_Helps__c,IPM_Core_Parameter_example__c,IPM_Core_Parameter_example_two__c,
                              IMP_Core_Parameter_example_three__c,IPM_Core_Parameter_example_four__c,
                              IPM_Core_Parameter_example_five__c from  IPM_CorePara_helps_example__c where IPM_Answer__c=:SelectedAnswer limit 1];  
   }
  if(SelectedQuestion=='Question3'){                           
  lstIpmCoreHelpQ3=[select IPM_Core_Parameter_Helps__c,IPM_Core_Parameter_example__c,IPM_Core_Parameter_example_two__c,
                              IMP_Core_Parameter_example_three__c,IPM_Core_Parameter_example_four__c,
                              IPM_Core_Parameter_example_five__c from  IPM_CorePara_helps_example__c where IPM_Answer__c=:SelectedAnswer limit 1];                                                         
               }               
  }catch(exception e){
  
  } 
} 

//Project Span tab

public void ProjectSpan()
{
   
   /* if(IPM_Coreparameter.IPM_Market__c ==null || IPM_Coreparameter.IPM_Market__c==''){
    isMarketMandatory=true;
    }else{*/
    list<IPM_Project__c> CPProject=new list<IPM_Project__c>();
    CPProject=[select IPM_Category__c,IPM_Category_Text__c,IPM_Category_Group__c,IPMCompany__c,IPM_Market__c,IPMPlatform__c,IPMRegion__c,IPM_Sector__c,IPM_Sub_sector__c                       
                        from IPM_Project__c where id=:ProjectID limit 1];
    if(CPProject.size()>0){
    IPM_Coreparameter.id=CPProject[0].id;
    //IPM_Coreparameter.IPM_Company_Card__c=selectedCompany;
    IPM_Coreparameter.IPMProject_Span__c=CompanyType;
    IPM_Coreparameter.IPM_IsCompleted__c=true;
    update IPM_Coreparameter;
    update IPMProjects;
    isSavedCoreparameter=true;
    CoreparameterId=IPM_Coreparameter.id;
    saveQuestionOne=false;
    saveQuestionTwo=false;
    saveQuestionThree=false;
    saveMarket=true;
    }
 /* isMarketMandatory=false;
  }*/
}
/*
@RemoteAction
global static IPM_CorePara_helps_example__c[] AnswerOne(string Answer,string AnsType,String ProjectId) {
    String CoreParaId;
    CoreParaId='';
    IPM_Project__c IPM_Coreparameter=new IPM_Project__c();
    IPM_Coreparameter=new IPM_Project__c();
    list<IPM_Project__c>BeforecreatedCP=new list<IPM_Project__c>();
    BeforecreatedCP=[select IPM_Answer_of_Q1__c,IPM_Answer_of_Q2__c,IPM_Answer_of_Q3__c                       
                        from IPM_Project__c where IPM_Project__c=:ProjectID limit 1];
    if(BeforecreatedCP.size()>0){
      if(AnsType=='Question1'){
            IPM_Coreparameter.IPM_Answer_of_Q1__c=Answer;
           }
           else if(AnsType=='Question2'){
            IPM_Coreparameter.IPM_Answer_of_Q2__c=Answer;
            }
          else if(AnsType=='Question3'){
            IPM_Coreparameter.IPM_Answer_of_Q3__c=Answer;
          }
      CoreParaId=BeforecreatedCP[0].id;
      IPM_Coreparameter.id=BeforecreatedCP[0].id;
      update IPM_Coreparameter;
    }else{
           if(AnsType=='Question1'){
            IPM_Coreparameter.IPM_Answer_of_Q1__c=Answer;
           }
           else if(AnsType=='Question2'){
            IPM_Coreparameter.IPM_Answer_of_Q2__c=Answer;
            }
          else if(AnsType=='Question3'){
            IPM_Coreparameter.IPM_Answer_of_Q3__c=Answer;
          }
           IPM_Coreparameter.IPM_Project__c=ProjectId;
           update IPM_Coreparameter;
           CoreParaId=IPM_Coreparameter.id; 
    }    
    system.debug('here is....'+Answer);
   // Answer='here is....Answer';
    Return [select IPM_Core_Parameter_Helps__c,IPM_Core_Parameter_example__c from  IPM_CorePara_helps_example__c where IPM_Answer__c=:Answer];
    }

*/

//Method for save message
public void SaveMessage(){
    saveQuestionOne=true;
    saveQuestionTwo=false;
    saveQuestionThree=false;
    saveMarket=false;
  }
//Save message for question number two
public void SaveMessageTwo(){
saveQuestionOne=false;
    saveQuestionTwo=true;
    saveQuestionThree=false;
    saveMarket=false;
} 
//Save message for question number three
public void SaveMessageThree(){
    saveQuestionOne=false;
    saveQuestionTwo=false;
    saveQuestionThree=true;
    saveMarket=false;
}  


public pagereference confirm(){
    targetLaunchDateValidationPopup = true;
    SaveAndReturn();
    
    if(error== 0)
    {
        closepopup =1;
        targetLaunchDateValidationPopup = false;
        PageReference pageRef = new PageReference('/apex/ipmCoreParametersLandingPage?id='+ProjectID );

        pageRef.setredirect(true);
        return pageRef;

        
    }
    
    return null;



}

public void editTargetLaunchDateValidationPopup (){
    targetLaunchDateValidationPopup = false;

}
// Get user type with access permission
 public void getIpmuserType(){
 list<IPM_Project_Resource__c>lstProuser=[select IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,IPM_Project__r.IPM_Project_Leader__c from IPM_Project_Resource__c where 
                                         IPM_Project__c=:projectId and IPM_User__c=:userinfo.getuserid() limit 1];
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
                                        id=:projectId and (IPM_Project_Leader__c =:userinfo.getuserid() or IPM_Technical_Project_Leader__c=:userinfo.getuserid() 
                                         or Deputy_Project_Leader__c=:userinfo.getuserid() ) limit 1];

 if(lstofuser.size()>0){
    isEditable=true;  
 }else{
  isEditable=false;
 }
}
list<PermissionSetAssignment>PermissonS=[select Assignee.Name, PermissionSet.Name
                                        from PermissionSetAssignment where (PermissionSet.Name='IPM_Central_Team' or PermissionSet.Name='IPM_Business_Partner'
                                            or PermissionSet.Name='IPM_BB_PL' or PermissionSet.Name='IPM_Deputy_Project_Leader' or 
                                             PermissionSet.Name='IPM_ProjectLeader') and Assignee.id=:userinfo.getuserid()];
if(PermissonS.size()>0){
 isEditable=true;
}                                       

                                         
 }   

//Save and return to coreparameterlanding page
public pagereference SaveAndReturn(){
    error=0;
if(IPMProjects.IPM_PM_Approach__c == null) {
        
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'IPM Approach cannot be blank');
        ApexPages.addmessage(myMsg );
        error++;   
    } 
  if(IPMProjects.IPM_Complexity__c == null) {
    
        error++;
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'IPM complexity cannot be blank');
        ApexPages.addmessage(myMsg );
 } 
    
    if(IPMProjects.IPM_Target_Launch_Dates__c == null) {
        
        error++;
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'IPM target launch date cannot be blank');
        ApexPages.addmessage(myMsg);   

    } 
  if(error>0){
        PageReference pageRef = new PageReference('/apex/ipmCoreParameters?slide=projectSpan');
        pageRef.setRedirect(false);
        return null;
    }
  if(IPMProjects.IPM_Target_Launch_Dates__c != null) {
        Date today = date.today();

        if( IPMProjects.IPM_Target_Launch_Dates__c.addDays(-390)<  today  && targetLaunchDateValidationPopup ==false)
        {
            targetLaunchDateValidationPopup = true;
            PageReference pageRef = new PageReference('/apex/ipmCoreParameters?slide=projectSpan');
            pageRef.setRedirect(false);
            return null;
       }
  }
update IPMProjects;  
    
    
    
    list<IPM_Project__c> CPProject=new list<IPM_Project__c>();
    CPProject=[select IPM_Category__c,IPM_Category_Group__c,IPMCompany__c,IPM_Market__c,IPMPlatform__c,IPMRegion__c,IPM_Sector__c,IPM_Sub_sector__c                       
                        from IPM_Project__c where id=:ProjectID limit 1];
                        
  if(CPProject.size()>0){
        IPM_Coreparameter.id=CPProject[0].id;
        update IPM_Coreparameter;
        CoreparameterId=IPM_Coreparameter.id;
        Date today = date.today();
        if(IPMProjects.IPM_Target_Launch_Dates__c.addDays(-390)>  today){

            closepopup =1;
            targetLaunchDateValidationPopup = false;

            return null;
            
            
        }
        else{
            
             return null;
        }
       }else{
    
             return null;
        
       }
} 
public void BETvalue(){

} 
public void getmarket(){
    if(IPM_Coreparameter.IPM_Category_Text__c!=null){
    lstmarket=new list<selectoption>();
    lstmarket.add(new selectoption('','Select Market'));
    string CatName='';
    string selCat=IPM_Coreparameter.IPM_Category_Text__c;
    set<string>UniqueMarket=new set<string>();
    if(selCat.equals('HHC')){
    CatName='Household Care';
    }else{
    CatName=selCat;
    }
 List<mdm_Brand_Position__c> userMarket=[select id, Market_Name__c from mdm_Brand_Position__c where Category_Name__c=: CatName and Market_Name__c!='' ];
    if(!userMarket.isEmpty())
    {
        for(mdm_Brand_Position__c u:userMarket)
        {
            UniqueMarket.add(u.Market_Name__c);
           
        } 
        for(string CatMarket:UniqueMarket){
         lstmarket.add(new Selectoption(CatMarket,CatMarket));
        }           
    }
               
}
}

public void getsubsector(){
   if(IPM_Coreparameter.IPM_Category_Text__c!=null){
    lstsubsector=new list<selectoption>();
    string CatName='';
    string selCat=IPM_Coreparameter.IPM_Category_Text__c;
    set<string>UniqueSubSector=new set<string>();
    if(selCat.equals('HHC')){
    CatName='Household Care';
    }else{
    CatName=selCat;
    }
    lstsubsector.add(new Selectoption('','Select Sub-Sector'));
 List<mdm_Product_Category__c > userMarket=[select id, L5_Product_Category__c from mdm_Product_Category__c where L2_Product_Category__c=: CatName and L5_Product_Category__c!=null];
    if(!userMarket.isEmpty())
    {
        for(mdm_Product_Category__c u:userMarket)
        {
            UniqueSubSector.add(u.L5_Product_Category__c );
           
        } 
        for(string CatMarket:UniqueSubSector){
         lstsubsector.add(new Selectoption(CatMarket,CatMarket));
        }           
    }
 }          
}
//getCategory name
public void getcategoryname(){
 IPM_Coreparameter=[select IPM_Answer_of_Q1__c,IPM_Category_Text__c,IPM_BET_Toolkit__c,IPM_Answer_of_Q2__c,IPM_Answer_of_Q3__c,IPM_Category__c,
                        IPM_Category_Group__c,IPMCompany__c,IPM_Market__c,IPMPlatform__c,
                        IPMRegion__c,IPM_Sector__c,IPM_Sub_sector__c                        
                        from IPM_Project__c where id=:ProjectID limit 1];
getsubsector();
getmarket();
}
}