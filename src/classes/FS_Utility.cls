/**********************************************************************
Purpose: Utility class for Food Solution (NAFS).
History :
VERSION AUTHOR         DATE         DETAIL Description
1.0     Accenture    11/May/2016     Utility class of NAFS project
                     10/June/2016    Updated to add test user creation method  
***********************************************************************/

public with sharing Class FS_Utility{
    private static boolean OppProduct= true;//Used in after update trigger - FS_OpportunityHelper
    private static boolean runaccPlan = true;
    private static boolean runobj = true;
    private static boolean ContractProduct= true;//Used in after update trigger - FS_ContractProductHelper
    public static boolean runOnceOppProduct(){
        if(OppProduct){
            OppProduct=false;
            return true;
        }else{
            return OppProduct;
        }
    }
    public static boolean runaccPlanOnce(){
        if(runaccPlan){
            runaccPlan=false;
            return true;
        }else{
            return runaccPlan;
        }
    }
    public static boolean runObjOnce(){
        if(runobj){
            runobj=false;
            return true;
        }else{
            return runobj;
        }
    } 
    public static boolean runOnceContractProduct(){
        if(ContractProduct){
            ContractProduct=false;
            return true;
        }else{
            return ContractProduct;
        }
    }
    
    Public Static map<String,String> recordTypewithName(String Name)
    {
        map<String,String> recordTypeWithName=new map<String,String>();
        List<RecordType> recordTypeWithNameList=[select id,DeveloperName from RecordType where sObjectType=:Name];
        for(RecordType varRecord:recordTypeWithNameList)
        {
        recordTypeWithName.put(varRecord.DeveloperName,varRecord.id);
        }
        return recordTypeWithName;
    }
    
    //This method is being called from FS Process Builder
    @InvocableMethod(label='Get Owners Custom Settings' description='')
    public static void getDefaults(List<Account> accounts) {
        list<Account> acts = new list<Account>();
        //list<ID> listOwner = new list<ID>();
        
        for(Account a : accounts){
           FS_User_Territory__c ut = FS_User_Territory__c.getInstance(a.ownerId);
           acts.add(new Account(Id=a.Id, Region__c = ut.Region__c,FS_CHD_Lock__c=true, Zone__c=ut.Zone__c, Territory__c=ut.Territory__c));//CurrencyIsoCode='CAD'
        }
        try{
            update acts;
        }catch(Exception e){
            system.debug(e);
        }
    }    
    
   }