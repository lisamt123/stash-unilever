/**********************************************************************
 Name:  CEC_CaseTriggerHelper()
 Copyright ? 2013  Unilever
======================================================================
======================================================================
Purpose:  Trigger Helper Class                                                
1. To populate the case account and contact id                                   
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
   1.0 - Nagesh       28/12/2014       INITIAL DEVELOPMENT     Case Field Population 
   2.0 - Nagesh       14/1/2014        UPDATION                Send Email Functionality
****************************************************************************/
public class CEC_CaseTriggerHelper{
    
    map<Id,string> caseMap = new map<Id,String>();
    map<string,Id> accountMap = new map<string,Id>();
    map<string,Account> emailAccntIdMap = new map<string,Account>();
    map<string,Id> contactMap = new map<string,Id>();
    set<string> dupEmailSet = new set<string>();
    List<Account> accntList = new List<Account>();
    List<Case> caseList = new List<Case>();
    string suppName,lName,fName,failedCases;
    Case caseRecord;
    Account accnt;
    String msgString;
    String emailSubject;
    String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm()+'/';
       
    //Code change to update the default Account Owner Id
    public void updateAccountOwner(List<Case> newCase){
    
        for(Case c: newCase){
            if(c.CMMFlag__C && c.NewAccountFlag__C){

                c.CMMFlag__C = False;
                c.NewAccountFlag__C = False;
                
                if(c.Country__c != null){
                    if(c.CMM_Account_Owner_Active_Flag__C){
                        accnt = new Account(id=c.AccountId);
                        accnt.OwnerId = c.DefaultCMMAccountOwner_Id__C;
                        accntList.add(accnt);
                    }
                    else{
                        msgString = '<Html><Body> This is an automated email<BR/><BR/>CEC Carelines Account owner could not be updated. Please check the case market mapping record and take the necessary action.<BR/><BR/>Case Number: '+ c.CaseNumber+'<BR/><BR/>Thank You</Body></Html>';  
                        emailSubject = '[ERR004] Default Account Owner is either not populated or Inactive at CMM';
                        CEC_Util.sendNotificationEmail(msgString,emailSubject);
                    }    
                }

                if(accntList.size()>0){
                    Database.SaveResult[] srList = Database.update(accntList, false);
                }
            
            }
        }
    
    }
       
       
    
    public void checkCaseDetails(Map<Id, Case> newCaseMap){       
        
        //Check for cases with null contactId
        for(Case c: newCaseMap.Values()){
            System.debug('c----------------'+c);
            if(c.ContactId == null && (c.SuppliedEmail != null && c.SuppliedEmail != '') && c.Origin.contains('Email')){
                caseMap.put(c.Id,c.SuppliedEmail);
            }
        }   
               
        if(caseMap.size() > 0){
            
            //Check for Duplicate Account
            checkDupAccnt();
            
            for(Id caseId: caseMap.keySet()){
                if(dupEmailSet.contains(caseMap.get(caseId))){
                    caseRecord = new Case(Id=caseId);
                    caseRecord.Matching_Response__c = Label.CEC_MatchingResponse_DuplicateAccount;
                    caseList.add(caseRecord);
                    caseMap.remove(caseId);
                }
                else if(emailAccntIdMap.containsKey(caseMap.get(caseId))){
                    caseRecord = new Case(Id=caseId);
                    caseRecord.AccountId=emailAccntIdMap.get(caseMap.get(caseId)).Id;
                    caseRecord.ContactId=emailAccntIdMap.get(caseMap.get(caseId)).PersonContactId;
                    caseList.add(caseRecord);
                    caseMap.remove(caseId);
                }
                else{
                    accnt = new Account();
                    suppName = newCaseMap.get(caseId).SuppliedName;
                    Lname=FName=null;
                    if(suppName!=null){
                        if(suppName.contains(',')){
                            FName = suppName.split(',')[1];
                            Lname = suppName.split(',')[0];
                        }
                        else if(suppName.contains(' ')){
                            Lname = suppName.split(' ')[(suppName.split(' ')).size()-1];
                            FName = suppName.substring(0,(suppName.length()-Lname.length())-1);
                        }
                        else{
                            Lname = suppName;
                        }
                    }                    
                    accnt.PersonEmail = newCaseMap.get(caseId).SuppliedEmail;
                    accnt.LastName = LName;
                    accnt.FirstName = FName;
                    System.debug('Nagesh I am here'+ accntList);                  
                    accntList.add(accnt);
                }
            }
                       
            if(accntList.size()>0){
                Database.SaveResult[] srList = Database.insert(accntList, false);
            }
            
            for(account accntdetail: accntList){
                accountMap.put(accntdetail.PersonEmail, accntdetail.Id);         
            }
            
            for(Contact cont: [Select Email, Id from Contact where Email IN: accountMap.KeySet()]){
                contactMap.put(cont.Email, cont.Id);         
            }
            
        } 
        
        //Associate the account and contact records
        for(Id caseId: caseMap.KeySet()){
            caseRecord = new Case(Id=caseId);
            caseRecord.AccountId= accountMap.get(caseMap.get(caseId));
            caseRecord.ContactId= contactMap.get(caseMap.get(caseId));
            caseRecord.NewAccountFlag__C = TRUE;
            if(accountMap.get(caseMap.get(caseId)) == null){
                caseRecord.Matching_Response__c=Label.CEC_MatchingResponse_AccountNotCreated;
            }
            caseList.add(caseRecord);
        }
        
        //Update the case records
        if(caseList.size()>0){
            //update caseList;
            Database.SaveResult[] updateResults = Database.update(caseList, false);
            failedCases = '';
            for(Integer i=0; i<updateResults.size();i++){
                if(!updateResults.get(i).isSuccess()){
                    Database.Error error = updateResults.get(i).getErrors().get(0);                
                    failedCases = failedCases + '<B>CaseId</B>:&nbsp;&nbsp;' +sfdcBaseURL+caseList.get(i).Id + '<br/>'; 
                    failedCases = failedCases + '<B>Error Message</B>:&nbsp;&nbsp;' + error.getMessage();       
                }
            }
            if(failedCases !=''){
                msgString = '<Html><Body> This is an automated email<BR/><BR/>CEC Carelines case could not be updated. Please check the error message and take the necessary action.<BR/><BR/>'+ failedCases+'<BR/><BR/>Thank You</Body></Html>';  
                emailSubject = '[ERR003] Case could not be updated';
                CEC_Util.sendNotificationEmail(msgString,emailSubject);
            }            
        }
        
    }
    
    //To Quick Fill details of case if Record type is changed "Spam"
    public void updateCaseDetailsIfRecordTypeIsSpam(Map<Id, Case> newCaseMap,Map<Id, Case> oldCaseMap){
        Map<String,String> allRecordtypesMap= new Map<String,String>();
        
        //Querying all recordtypes
        List<RecordType> allRecordtypes= [select id,name from RecordType];
        Map<String,cec_Case_QC_Mapping__c> qcMap=new Map<String,cec_Case_QC_Mapping__c>(); 
        Set<String> recordTypesSet=new Set<String>();
        List<String> recordTypesList=new List<String>();
        Set<String> countryCodeSet = new Set<String>();
        
        //Map of case recordtype
        for(RecordType rctype: allRecordtypes){
            allRecordtypesMap.put(rctype.Id,rctype.Name);
        }
        //set of all record types in Map of case
        for(Case caseobject:newCaseMap.values()){
            recordTypesSet.add(allRecordtypesMap.get(caseobject.recordtypeId));
            countryCodeSet.add(caseobject.Case_Market_Mapping_Country_Id__c);
            System.debug('--------- -----caseobject.recordtype.Name'+caseobject.recordtypeId);
        }
        recordTypesList.addAll(recordTypesSet);
        System.debug('--------'+recordTypesList);
        System.debug('--------'+countryCodeSet);
        List<cec_Case_QC_Mapping__c> caseQcMapping= [select Product__c,QC_Type__c,Reason_Code__c,Status__c,Verbatim__c,Country__c from cec_Case_QC_Mapping__c where QC_Type__c in : recordTypesList AND Country__c in : countryCodeSet];

        System.debug('caseQcMapping:: '+caseQcMapping);
                
        //Map of all qc mapping
        for(cec_Case_QC_Mapping__c qc:caseQcMapping){
            if(qc.QC_Type__c!=null && qc.Country__c!=null){
            if(!qcMap.containsKey(qc.QC_Type__c+qc.Country__c)){
                qcMap.put(qc.QC_Type__c+qc.Country__c,qc);
            }
            }
            
        }
            
            cec_Case_QC_Mapping__c qc;
            
            for(Case caseObject: newCaseMap.Values()){
                Id caseMarketMappingCountryId = caseObject.Case_Market_Mapping_Country_Id__c;
                //chck if val change
                if(newCaseMap.get(caseObject.Id).recordTypeId!=oldCaseMap.get(caseObject.Id).recordTypeId){
                    if(qcMap.size()>0 && allRecordtypesMap.size()>0){
                        if(allRecordtypesMap.get(newCaseMap.get(caseObject.Id).recordTypeId) != null ) {
                         
                         qc = qcMap.get(allRecordtypesMap.get(newCaseMap.get(caseObject.Id).recordTypeId)+caseMarketMappingCountryId);
                         
                         if(qc!=null) {
                            if(qc.Reason_Code__c != null){
                                    newCaseMap.get(caseObject.Id).Reason_Code__c=qc.Reason_Code__c;
                            }
                            if(qc.Status__c!=null) {
                                newCaseMap.get(caseObject.Id).Status=qc.Status__c;
                            }
                            if(qc.Verbatim__c!=null){
                                newCaseMap.get(caseObject.Id).Subject=qc.Verbatim__c;
                            }
                            if(qc.Product__c !=null){
                                newCaseMap.get(caseObject.Id).CEC_Product__c=qc.Product__c;
                            }
                        
                        }
                      }
                    }    
                    
                }
            }
        
    }
    public void checkDupAccnt(){
        
        Id recTypeId =[Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id; 
        
        //Query for Duplicate Account
        for(AggregateResult ar :[Select PersonEmail, Count(Id) from Account where PersonEmail IN: caseMap.values() and RecordTypeId =: recTypeId group by PersonEmail having count(Id) > 1]){
            dupEmailSet.add((string)ar.get('PersonEmail'));
        }
     
        //Query for Account Id
        for(Account accnt:[Select Id, PersonEmail, PersonContactId from Account where PersonEmail IN: caseMap.values() and RecordTypeId =: recTypeId]){
            if(!dupEmailSet.Contains(accnt.PersonEmail)){
                emailAccntIdMap.put(accnt.PersonEmail, accnt);
            }
        }
        
    }
    
        //To update Account product/reason code from case
    public void updateProductAndReasonCode(Map<Id, Case> newCaseMap){
        if((newCaseMap.values()).size()>0){
        Map<String,Case> accMaps=new map<String,Case>();
        for(Case cases:newCaseMap.values()){            
            accMaps.put(cases.AccountId,cases);
        }
        if (accMaps.keySet().size() > 0) {
            List<Account> accList=[select id from Account where id in: accMaps.keyset()];
            for(Account acc:accList){
                acc.Latest_Case_Product_Code__c=(accMaps.get(acc.Id)).Product_Code__c;
                acc.Latest_Case_Reason_Code__c=accMaps.get(acc.Id).CEC_Reason_Code__c;
                acc.Latest_Case_Number__c=accMaps.get(acc.Id).CaseNumber;
            }
            update accList;
        }
      }
     }
     

     public void updateDayCodeMftrCode(Map<Id, Case> newCaseMap,Map<Id, Case> oldCaseMap){
        for(Case caseobject:newCaseMap.values()){
            identifyDaycode(caseobject);
        }
     }

       /**
    This method identifies daycode from the production code
     */
    private void identifyDaycode(Case caseRecord){
    
        Boolean populateDayCode;
        String Daycode = '';
        caseRecord.Date_of_Manufacture_str__c = '';
        caseRecord.Date_of_Manufacture__c = null;

        try{
        
        if (caseRecord.Production_Code__c!= null && caseRecord.Production_Code__c!= '' && caseRecord.Production_Code__c.length() >= 4){
            //production_Code validations
            String productionCode=caseRecord.Production_Code__c;
           
            if((productionCode.substring(0,4)).isNumeric()){
                Daycode = productionCode.substring(0,4);
            }
            else if (productionCode.length()>4 &&( productionCode.substring(1,5)).isNumeric() ){
                Daycode = productionCode.substring(1,5);
            }
        
            if(Daycode !=''){
                String days=Daycode.subString(1);
                if(Integer.valueof(days)>366){
                Daycode='';
                            
                }

            /* identify the date of manufacture from the daycode */
            }
            caseRecord.DayCode__c = Daycode;
            identifyDateOfManufacture(caseRecord);
        }
           caseRecord.DayCode__c = Daycode; 
        } catch(Exception e)  {
                System.debug('Exception in calculating Daycode');
        }
     
    }

    /**
    This method identifies date of manufacture from the daycode
     */
    @testVisible
    private void identifyDateOfManufacture(Case caseRecord){
        if (caseRecord.DayCode__c != null && caseRecord.DayCode__c != '' && caseRecord.DayCode__c.length() == 4){
            /* splitting 1st char as Year & taking it as integer */

            try{

                String year = caseRecord.DayCode__c.substring(0,1); 
                Integer prodYearDigit = Integer.valueOf(year);  

                /* splitting 2 to 4 chars as number of days & taking it as integer*/            
                String noOfDays = caseRecord.DayCode__c.substring(1); 
                Integer n = Integer.valueOf(noOfDays);



                /* identifying current year & converting it into String */
                Integer currentYear = Integer.valueOf((Date.today()).year()); 
                String currentYearStr  = String.valueOf(currentYear);

                /*extracting the last digit of the current year */
                String currentYearLastDigitStr = currentYearStr.substring(3);
                Integer currentYearLastDigitNum = Integer.valueOf(currentYearLastDigitStr); 

                /*extracting the first three digits of the current year */
                String currentYearfirstthreeDigitStr = currentYearStr.substring(0,3);
                Integer currentYearfirstthreeDigitNum = Integer.valueOf(currentYearfirstthreeDigitStr); 


                Integer prodYear;

                /* if production year <= current year */
                if (prodYearDigit <= currentYearLastDigitNum ){    
                    //prodYear = Date.today().year();

                    String prodYearStr = currentYearfirstthreeDigitStr + year;
                    System.debug('~~~prodYearStr '+ prodYearStr );
                    prodYear = Integer.valueOf(prodYearStr);

                }else{
                    prodYear =  Date.today().year() -1;

                    System.debug('~~~currentYearfirstthreeDigitNum '+ currentYearfirstthreeDigitNum);

                    Integer prodYearfirstthreeDigitNum = currentYearfirstthreeDigitNum-1;
                    System.debug('~~~prodYearfirstthreeDigitNum '+ prodYearfirstthreeDigitNum );

                    String prodYearfirstthreeDigitStr= string.valueof(prodYearfirstthreeDigitNum);
                    System.debug('~~~prodYearfirstthreeDigitStr'+ prodYearfirstthreeDigitStr);

                    String prodYearStr = prodYearfirstthreeDigitStr + year;
                    System.debug('~~~prodYearStr'+ prodYearStr);

                    prodYear =  Integer.valueOf(prodYearStr);
                    System.debug('~~~prodYear '+ prodYear );
                }

                /*creating a date instance for the Prod year & 1st Jan */
                DateTime dateOfManufacture =  DateTime.newInstance(prodYear , 1, 1);
                System.debug('~~~dateOfManufacture '+dateOfManufacture);
                /* adding number of days from daycode to above date */
                dateOfManufacture = dateOfManufacture.addDays(n-1);
                String dateOfManufactureStr =  dateOfManufacture.format('dd-MM-yyyy');

                System.debug('~~~dateOfManufactureStr '+ dateOfManufactureStr);
                caseRecord.Date_of_Manufacture__c = dateOfManufacture;
                caseRecord.Date_of_Manufacture_str__c = dateOfManufactureStr;

            }
            catch(Exception e)  {
                System.debug('Exception in calculating ManufactureCode');
            }
        }else if(caseRecord.DayCode__c==null || caseRecord.DayCode__c==''){
            caseRecord.Date_of_Manufacture__c =null;
        }
    }



      public void updateCountryDetail(Map<Id, Case> newCaseMap){
      
      System.debug('newCaseMap~~~~~~~~'+newCaseMap);
      
     for(Case caseitem:newCaseMap.values()){
     
                System.debug('Case_Market_Mapping_Country__c~~~~~~~~~'+ caseitem.Case_Market_Mapping_Country__c);
                caseitem.Country_Name__c=caseitem.Case_Market_Mapping_Country__c;
                caseitem.Tag__c=caseitem.Case_Market_Tag__c;
                System.debug('Country_Name__c~~~~~~~~~'+ caseitem.Country_Name__c);
        }
    
        }
        
    /* Support team change starts
    
     -> Changes for incident INC000096161554 - [Information not transmitted in Salesforce]
     -> To populate Country Name field when case is created by Contact-us form
    
   */
       
    public void insertCountryDetail(List<Case> newCaseList){
      if(newCaseList!=null){
      
      System.debug('newCaseList~~~~~~~~'+newCaseList);
      
     for(Case caseitem:newCaseList){
     
                 
                System.debug('Case_Market_Mapping_Country__c~~~~~~~~~'+ caseitem.Case_Market_Mapping_Country__c);
                caseitem.Country_Name__c=caseitem.Case_Market_Mapping_Country__c;
                System.debug('Country_Name__c~~~~~~~~~'+ caseitem.Country_Name__c);
        }
     }  
        }
     
      /* Support team change ends*/
     
     
        
     }