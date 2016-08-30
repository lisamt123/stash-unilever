/**********************************************************************
Name: CI_R2R_SME_GetHistory 
Purpose:
This Controoler is used to capture the tracking history of comments.
VERSION   AUTHOR   DATE    
1.0       Chandana June-2016   
***********************************************************************/
public class CI_R2R_SME_GetHistory {
    
    
    public string smeid {get; set;}
    
    public string changedby {get; set;}
    public boolean panel {get; set;}
    public CI_R2R_SME_GetHistory(ApexPages.StandardController controller) {
        CI_SMS_Weekly_Update__c temp = (CI_SMS_Weekly_Update__c)controller.getRecord();
        smeid = temp.id;
        panel = true;
    }
   public List<wrapper> wrapperList {get; set;}
   public List<wrapper> getWrappervalues(){
       wrapperlist = new List<wrapper>();
       set<id> sIds = new set<id>();
       string newcomment;
       string oldcomment;
       string sDate;
       string sName;
       Id SmId;
       List<CI_SMS_Weekly_Update__History> smelist = [SELECT ParentId,createdBy.Name,OldValue,CreatedById,CreatedDate,NewValue, Field FROM CI_SMS_Weekly_Update__History where parentId =:smeid and Field = 'Comments__c'];
       for(CI_SMS_Weekly_Update__History sme : smeList){
               newcomment = string.valueof(sme.NewValue);
               oldcomment= string.valueof(sme.OldValue);
               sDate = string.valueof(sme.createdDate);
               sName = string.valueof(sme.createdBy.Name);
               wrapperList.add(new wrapper(newcomment,oldcomment,sName,sDate)); 
       }
       return wrapperList;
   } 
   
   public class wrapper{       
       public string newvalue {get; set;}
       public string oldvalue {get; set;}
       public string changedby {get; set;}
       public string sDate {get; set;}
       public wrapper(string n,string n1,string c,string sd){
           newvalue = n;
           oldvalue = n1;
           changedby = c;
           sDate = sd;
       }
   } 
        

}