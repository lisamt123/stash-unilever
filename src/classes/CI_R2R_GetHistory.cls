/**********************************************************************
Name: CI_R2R_GetHistory
Purpose:
This Controoler is used to capture the tracking history of comments.
VERSION   AUTHOR   DATE    
1.0       Chandana June-2016   
***********************************************************************/
public class CI_R2R_GetHistory {    
    
  public string rrid {get; set;}    
   public string changedby {get; set;}
   public boolean panel {get; set;}
   
   
   public CI_R2R_GetHistory(ApexPages.StandardController controller) {
        CI_R2R_Innovation__c temp = (CI_R2R_Innovation__c)controller.getRecord();
        rrid = temp.id;  
        panel = true;           
   }
   public List<wrapper> wrapperList {get; set;}
   public List<wrapper> getWrappervalues(){
       wrapperlist = new List<wrapper>();
       set<id> sIds = new set<id>();       
       string newcomment;
       string oldcomment;
       string cDate;
       string cName;           
       Id crId;
       List<CI_R2R_Innovation__History> rrlist = [SELECT ParentId,createdBy.Name,OldValue,CreatedById,CreatedDate,NewValue, Field FROM CI_R2R_Innovation__History where parentId =:rrid and Field = 'Comments__c'];
      
       for(CI_R2R_Innovation__History cr : rrList){       
               newcomment = string.valueof(cr.NewValue);               
               oldcomment = string.valueof(cr.OldValue);               
               cDate = string.valueof(cr.createdDate);
               cName = string.valueof(cr.createdBy.Name);              
               wrapperList.add(new wrapper(newcomment,oldcomment,cName,cDate));               
       }
       return wrapperList;
   } 
      
   public class wrapper{       
       public string newvalue {get; set;}
       public string oldvalue {get; set;}
       public string changedby {get; set;}
       public string cDate {get; set;}
       public wrapper(string n,string n1,string c,string cd){
           newvalue = n;
           oldvalue = n1;
           changedby = c;
           cDate = cd;
       }       
   }    
}