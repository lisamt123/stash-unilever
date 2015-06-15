public class IPM_CreateProject {
public IPM_Project__c ipmProject{get;set;}
public string projectid{get;set;}
public list<IPM_User_Profile__c>CompanyCard=new list<IPM_User_Profile__c>();
public list<IPM_User_Profile__c>lstGatekeeper=new list<IPM_User_Profile__c>();
public string isBoosEdtable{get;set;}
public string isProEditable{get;set;}
public IPM_CreateProject(){
string CCardid='';
isBoosEdtable=apexpages.currentpage().getparameters().get('IsBossCardEditable');
isProEditable=apexpages.currentpage().getparameters().get('IsProjectEditable');

CompanyCard=[select IPM_Company_Card__c,IPM_Project_Leader__c from IPM_User_Profile__c where IPM_User__c=:userinfo.getuserid()];
    if(CompanyCard.size()>0){
        CCardid=CompanyCard[0].IPM_Company_Card__c;   
     }
  if(CCardid !=''){
    lstGatekeeper=[select IPM_User__c from IPM_User_Profile__c where IPM_Company_Card__c=:CCardid];
    }
}
public void CreateProjectId(){
list <IPM_Project__c > lstofemptyProjectname=new list<IPM_Project__c>();
lstofemptyProjectname=[select name from IPM_Project__c where IPM_Project_Name__c=:'' and IPM_Bosscard__c='' and CreatedBy.ID=:UserInfo.getUserId()];
               
if(lstofemptyProjectname.size()>0){
   delete lstofemptyProjectname;
  }
 ipmProject=new IPM_Project__c();
 ipmProject.IPM_Project_Leader__c=userinfo.getuserid();
 if(lstGatekeeper.size()>0){
  //ipmProject.IPM_Project_Gatekeeper__c=lstGatekeeper[0].IPM_User__c;
 }
 if(CompanyCard.size()>0){
  //ipmProject.IPM_Company_Card__c=CompanyCard[0].IPM_Company_Card__c;
 }
 insert ipmProject;
 projectid=ipmProject.id;
}

}