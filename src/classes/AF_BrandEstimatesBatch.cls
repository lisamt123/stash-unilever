global class AF_BrandEstimatesBatch implements Database.Batchable<sObject>
{
     global final String query;
     String statusBasefee='Ready for PO';
     List<AF_Brand_Estimate__c> brandEstimateList=new  List<AF_Brand_Estimate__c>();
     List<AF_Brand_Estimate__c>  InserBrandEstimates=new List<AF_Brand_Estimate__c>();
 
    
    global AF_BrandEstimatesBatch(string q)
    {
       // query = 'select id,Name,AF_Active__c,AF_Adaptive__c ,AF_Agency__c,Agency_Base_Fee__c,AF_Archived__c,AF_Basefee_Estimate_Initial_Quarter__c,Base_Fee_Total__c,AF_Bonus_Trigger_Date__c,Brand__c,AF_Comment_Type__c,AF_Controller_Flag__c,AF_Created_By_Batch__c,AF_Digital__c,AF_Fiscal_Year__c,AF_Measure_Bonus__c,AF_Overall_OOPS__c,AF_Status_Base_Fees__c,AF_Status_Bonus__c,AF_Status_OOPs_Atcual__c,AF_Status_OOPs_Estimate__c,AF_Traditional__c, (select id,Name,AF_Crossborder__c,AF_Agency_Entity_Column_Name__c,AF_Adaptation__c,AF_Adaptation_Local__c,AF_Agency__c,AF_Agency_Entity__c,AF_Archived__c,AF_Brand_Estimate__c,AF_Category__c,AF_Comment_Type__c,AF_Controller_Flag__c,AF_Deleted__c,AF_Digital__c,AF_Digital_Local__c,AF_Estimates_don_t_match__c,AF_Fiscal_Year__c,AF_IsCrossborder__c,AF_Locked__c,AF_Matrix_Data_Entry_Currency__c,AF_Agency_Exchange_Rate__c,AF_Quarter__c,AF_Rate_Currency__c,AF_Rate_Type__c,AF_Ready_For_PO_Entry_Currency__c,AF_Agency_Spot_Rate__c,AF_Status__c,AF_Total_Local__c,AF_Traditional__c,AF_Traditional_Local__c,AF_Unilever_Entity__c,AF_Unilever_Entity_Column_Name__c,AF_Unilever_Estimates__c from Agency_Estimates__R),(select id,Name,AF_Agency_Entity__c,AF_Agency_Entity_Column_Name__c,AF_Agency_Exchange_Rate__c,AF_Agency_Spot_Rate__c,AF_Agreed_Base_Fees__c,AF_Archived__c,AF_Brand_Estimate__c,AF_Estimate__c,AF_Estimate_Local__c,AF_Fiscal_Year__c,AF_Locked__c,AF_Overall_OOPS__c,AF_Quarter__c,AF_Rate_Currency__c,AF_Rate_Type__c,AF_Status__c,AF_Unilever_Entity__c,AF_Unilever_Entity_Column_Name__c from OOPS_Estimates__R)from AF_Brand_Estimate__c where AF_Status_Base_Fees__c=:statusBasefee and AF_Fiscal_Year__c=:Fisyear '  ;
       query=q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,  List<AF_Brand_Estimate__c> brandEstimateList) 
    {  
        list<AF_Brand_Estimate__c > abelist = new list<AF_Brand_Estimate__c >();
        list<AF_Agency_Estimate__c> agest_list = new list<AF_Agency_Estimate__c >();
        list<AF_OOPS_Estimate__c> aoop_list = new list<AF_OOPS_Estimate__c>();
        AF_Brand_Estimate__c  abe = [select id,Name,af_agency__r.name,brand__r.name,AF_Active__c,AF_Adaptive__c ,   AF_Copied__c,AF_Agency__c,Agency_Base_Fee__c,AF_Basefee_Estimate_Initial_Quarter__c,Base_Fee_Total__c,AF_Bonus_Trigger_Date__c,Brand__c,AF_Comment_Type__c,AF_Controller_Flag__c,AF_Created_By_Batch__c,AF_Digital__c,AF_Fiscal_Year__c,AF_Measure_Bonus__c,AF_Overall_OOPS__c,AF_Status_Base_Fees__c,AF_Status_Bonus__c,AF_Status_OOPs_Atcual__c,AF_Status_OOPs_Estimate__c,AF_Traditional__c,AF_Locked__c from AF_Brand_Estimate__c where id in :brandEstimateList];
        AF_Brand_Estimate__c  abe_new = abe.clone(false,true);
        abe_new.AF_Fiscal_Year__c = string.valueof(system.today().year());
        abe_new.Name=abe_new.brand__r.name+'-'+ abe_new.af_agency__r.name +'-Q1-' +abe_new.AF_Fiscal_Year__c;
        abe_new.AF_Basefee_Estimate_Initial_Quarter__c ='Q1';
        abe_new.AF_Status_Base_Fees__c = 'Initiate';
        abe_new.AF_Locked__c  = false;
        abe_new.AF_Created_By_Batch__c = true;
        abe_new.AF_Traditional__c = 0;
        abe_new.AF_Digital__c = 0;
        abe_new.AF_Adaptive__c = 0;
        abe_new.AF_Copied__c = false;
        
        Database.SaveResult br = Database.insert(abe_new, false);
            if(br.issuccess())
            {
                try{
                  List<AF_Agency_Estimate__c> aelist = [select id,Name,AF_Crossborder__c,AF_Agency_Entity_Column_Name__c,AF_Adaptation__c,AF_Adaptation_Local__c,AF_Agency__c,AF_Agency_Entity__c,AF_Archived__c,AF_Brand_Estimate__c,AF_Category__c,AF_Comment_Type__c,AF_Controller_Flag__c,AF_Deleted__c,AF_Digital__c,AF_Digital_Local__c,AF_Estimates_don_t_match__c,AF_Fiscal_Year__c,AF_IsCrossborder__c,AF_Locked__c,AF_Matrix_Data_Entry_Currency__c,AF_Agency_Exchange_Rate__c,AF_Quarter__c,AF_Rate_Currency__c,AF_Rate_Type__c,AF_Ready_For_PO_Entry_Currency__c,AF_Agency_Spot_Rate__c,AF_Status__c,AF_Total_Local__c,AF_Traditional__c,AF_Traditional_Local__c,AF_Unilever_Entity__c,AF_Unilever_Entity_Column_Name__c,AF_Unilever_Estimates__c from AF_Agency_Estimate__c where AF_Brand_Estimate__c = : abe.Id];
            
                    for(AF_Agency_Estimate__c ae: aelist)
                    {
                        AF_Agency_Estimate__c aecopy = ae.clone(false,true);
                        aecopy.AF_Brand_Estimate__c = br.Id;
                        //aecopy.AF_Agency_Entity__c = ae.id;
                        //aecopy.AF_Unilever_Entity__c = ae.id;
                        aecopy.AF_Fiscal_Year__c = string.valueof(system.today().year());
                        aecopy.AF_Quarter__c = 'Q1';
                        aecopy.AF_Locked__c = false;
                        //aecopy.AF_Adaptation__c = 0;
                        //aecopy.AF_Traditional__c = 0;
                        //aecopy.AF_Digital__c = 0;
                        
                        agest_list.add(aeCopy);
                    }
                    if(agest_list.size() > 0)
                    {
                      
                          insert agest_list;
                    }
                  } catch(exception e) {}
                        
                  /*   // oops estimates   
                    List<AF_OOPS_Estimate__c> aolist = [select id,Name,AF_Agency_Entity__c,AF_Agency_Entity_Column_Name__c,AF_Agency_Exchange_Rate__c,AF_Agency_Spot_Rate__c,AF_Archived__c,AF_Brand_Estimate__c,AF_Estimate__c,AF_Estimate_Local__c,AF_Fiscal_Year__c,AF_Locked__c,AF_Overall_OOPS__c,AF_Quarter__c,AF_Rate_Currency__c,AF_Rate_Type__c,AF_Status__c,AF_Unilever_Entity__c,AF_Unilever_Entity_Column_Name__c from AF_OOPS_Estimate__c where AF_Brand_Estimate__c = : abe.Id];
                    for(AF_OOPS_Estimate__c ao: aolist)
                    {
                        AF_OOPS_Estimate__c aocopy = ao.clone(false,true);
                        aocopy.AF_Brand_Estimate__c = br.Id;
                        aocopy.AF_Quarter__c ='Q1';
                        aocopy.AF_Fiscal_Year__c = string.valueof(system.today().year());
                        aocopy.AF_Locked__c = false;
                        aocopy.AF_Adaptation__c = 0;
                        aocopy.AF_Traditional__c = 0;
                        aocopy.AF_Digital__c = 0;
                        aoop_list.add(aoCopy);
                    }
                    if(aoop_list.size() > 0)
                        insert aoop_list; */  
                   if(abe.AF_Locked__c == false) {      
                    abe.AF_Locked__c  = true;
                    abe.AF_Copied__c = true;
                    abelist.add(abe);
                    if(abelist.size() >0) 
                        update abelist;
                   }
            }
         AF_BrandEstimate_TriggerDate__c ABT = AF_BrandEstimate_TriggerDate__c.getOrgDefaults();
         ABT.AF_Currency_Uploaded__c = false;
         update ABT; 
    }
    //finish Mehtod
    global void finish(Database.BatchableContext BC)
    {
            List<Id> lstusers=new List<Id>();
            List<String> lstEmail=new List<String>();
            string emails;
            List<PermissionSetAssignment> permissionSetAssign=[SELECT AssigneeId,Id,PermissionSetId FROM PermissionSetAssignment where PermissionSet.name=:'AF_CMCO_Super_User'];
            if(permissionSetAssign.size()>0){
                for(PermissionSetAssignment assignment:permissionSetAssign){
                    lstusers.add(assignment.AssigneeId);
                }
            }
            List<User> queryUser=[select Id, Email from User Where Id IN : lstusers];
            if(queryUser.size()>0){
                for(User userassign: queryUser){
                //  lstEmail.add(userassign.Email);
                  if(emails == '' || emails == null)
                    emails = userassign.email;
                  else
                    emails = emails + ';' + userassign.email;
                    
                }
            }
                string emailbody;
                string emailsubject;
                emailtemplate e = [select id,name,body,htmlvalue,subject from emailtemplate where name =: 'Batch template CMCO'];
                emailbody = e.htmlvalue;
                emailsubject = e.subject;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              
                  if(emails != null && emails != '') {
                     String[] toAddresses = emails.split(';');
                     mail.setToAddresses(toAddresses );
                
             
                //mail.setToAddresses(lstEmail);
             
                String[] ccAddresses = new String[] {'yamuna.sfdc@gmail.com'};
                mail.setCcAddresses(ccAddresses );
                mail.setSubject(emailsubject);
                mail.setSaveAsActivity(false);
                mail.setPlainTextBody('Hi');
                mail.setHtmlBody(emailbody);
                messaging.sendemailresult[] r=Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
               }
    }
}