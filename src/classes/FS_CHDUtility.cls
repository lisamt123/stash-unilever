/**********************************************************************
Purpose: To display the Segment values from CHD subsegment value .
History :
VERSION AUTHOR         DATE               DETAIL Description
1.0     Accenture    30/November/2016       Created
1.0     Accenture    30/january/2017        Updated
                      
***********************************************************************/

public with sharing Class FS_CHDUtility{
      
    @invocableMethod(label='CHD GFCCode for Segment' description='To display the Segment value')  
    public static void getsegment(list<account> accounts){
        list<Account> actlist = new list<Account>();            
        for(Account acts : accounts){        
            
            if(!String.ISBLANK(acts.SubSegment__c)){
               List<string> strList = new List<String>();
               strList =acts.SubSegment__c.split('\\.');
               FS_CHD_GFCCode__c ut = FS_CHD_GFCCode__c.getInstance(strList[0].trim());
                
                if(!String.ISBLANK(ut.Segment__c))
                      actlist.add(new Account(Id=acts.Id,FS_CHD_Lock__c=true,Segment__c= ut.Segment__c.trim()));
            } 
        }
        try{        
            if(!actlist.isEmpty()){
             update actlist;
            }  
        }
        Catch(DmlException e){
           System.debug(e);
        }
    } 
}