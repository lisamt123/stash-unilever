public class CI_R2R_GetHistory {    
    
  public string rrid {get; set;}    
    public string changedby {get; set;}
   public CI_R2R_GetHistory(ApexPages.StandardController controller) {
        CI_R2R_Innovation__c temp = (CI_R2R_Innovation__c)controller.getRecord();
        rrid = temp.id;        
   }
   public List<wrapper> wrapperList {get; set;}
   public List<wrapper> getWrappervalues(){
       wrapperlist = new List<wrapper>();
       set<id> sIds = new set<id>();
       string value;
       string value1;
       string value2;
       string value3;
       string uValue;
       Id crId;
       List<CI_R2R_Innovation__History> rrlist = [SELECT ParentId,createdBy.Name,OldValue,CreatedById,CreatedDate,NewValue, Field FROM CI_R2R_Innovation__History where parentId =:rrid and Field = 'Comments__c'];
      
       for(CI_R2R_Innovation__History cr : rrList){        
               value = string.valueof(cr.NewValue);
               value1 = string.valueof(cr.OldValue);
               value3 = string.valueof(cr.createdDate);
               value2 = string.valueof(cr.createdBy.Name);
              // uValue = value2;
               wrapperList.add(new wrapper(value,value1,Value2,value3));               
       }
       return wrapperList;
   } 
   
   
   public class wrapper{       
       public string name {get; set;}
       public string name1 {get; set;}
       public string changedby {get; set;}
       public string cDate {get; set;}
       public wrapper(string n,string n1,string c,string cd){
           name = n;
           name1 = n1;
           changedby = c;
           cDate = cd;
       }
   } 
        

}