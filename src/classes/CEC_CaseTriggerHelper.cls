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
3.0 - Samrin       16/11/2015       CSC-2845                US-097 Personal data not included in Pulse
4.0 - Mahendra     17/11/2015       CSC-2910                Personal Data Retention
5.0 - Goverdhan S. 9/12/2015        CSC-2850                Added method to implement CSAT functionality
6.0 - Masood       16/12/2015       CSC-2986                Added flag for picking account according to retention date
****************************************************************************/
public class CEC_CaseTriggerHelper{
    
    map<Id,string> caseMap = new map<Id,String>();
    map<string,Id> accountMap = new map<string,Id>();
    map<string,Account> emailAccntMap = new map<string,Account>();
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
    map<id, Account> caseToAccountMap = new map<id, Account>();
    list<Id> noAccountCaseIds = new list<Id>();
    
    
    
    //Code change to update the default Account Owner Id
    public void updateAccountOwner(List<Case> newCase){
        
        System.debug('New Case $$$$$$$$$$$$$$' + newCase);
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
            }
        }
        
        if(accntList.size()>0){
            Database.SaveResult[] srList = Database.update(accntList, false);
        }
        
        
    }
    
    
    
    public void checkCaseDetails(Map<Id, Case> newCaseMap){       
        
        //Check for cases with null contactId
        for(Case c: newCaseMap.Values()){
            System.debug('c----------------'+c);
            if(c.ContactId == null && (c.SuppliedEmail != null && c.SuppliedEmail != '') && (c.Origin.contains('Email') || c.Origin.contains('Web North America'))){
                caseMap.put(c.Id,c.SuppliedEmail);
            }
        }   
        
        if(caseMap.size() > 0){
            
            //Check for Duplicate Account
            checkDupAccnt();
            
            for(Id caseId: caseMap.keySet()){
                // If duplicate found, set Matching_Response__c field 
                if(dupEmailSet.contains(caseMap.get(caseId))){
                    caseRecord = new Case(Id=caseId);
                    caseRecord.Matching_Response__c = Label.CEC_MatchingResponse_DuplicateAccount;
                    // Update case brand
                    caseRecord.Brand__c = CEC_CaseDescriptionParser.getBrand(newCaseMap.get(caseId).description);
                    caseList.add(caseRecord);
                    caseMap.remove(caseId);
                } // if no duplicates are found, and account already exists, add case to account
                else if(emailAccntMap.containsKey(caseMap.get(caseId))){
                    account acc = new account();
                    acc = emailAccntMap.get(caseMap.get(caseId));
                    caseRecord = new Case(Id=caseId);
                    caseRecord.AccountId = acc.Id;
                    caseRecord.ContactId = acc.PersonContactId;
                    // update case brand
                    caseRecord.Brand__c = CEC_CaseDescriptionParser.getBrand(newCaseMap.get(caseId).description);
                    // update related account details from case description
                    acc = updateAccountDetailsFromCaseDescription(acc, newCaseMap.get(caseId).description);
                    accntList.add(acc);
                    
                    caseList.add(caseRecord);
                    caseMap.remove(caseId);
                } // if no matching account is found, create new account
                else{
                    accnt = new Account();
                    suppName = newCaseMap.get(caseId).SuppliedName;
                    Lname=FName=null;
                    // split supplied name to obtain first and last name of account
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
                    
                    // update related account details from case description
                    if(newCaseMap.get(caseId).Origin == 'Web North America'){
                        accnt = updateAccountDetailsFromCaseDescription(accnt, newCaseMap.get(caseId).description);
                    }
                    System.debug('Nagesh I am here'+ accntList);                  
                    accntList.add(accnt);
                }
            }
            // insert new accounts
            if(accntList.size()>0){
                Database.SaveResult[] srList = Database.insert(accntList, false);
            }
            // create account map to fetch inserted accounts based on email
            for(account accntdetail: accntList){
                accountMap.put(accntdetail.PersonEmail, accntdetail.Id);         
            }
            // create contact map to fetch inserted contacts based on email
            for(Contact cont: [Select Email, Id from Contact where Email IN: accountMap.KeySet()]){
                contactMap.put(cont.Email, cont.Id);         
            }
            
        } 
        
        //Associate the account and contact records
        for(Id caseId: caseMap.KeySet()){
            caseRecord = new Case(Id=caseId);
            caseRecord.AccountId= accountMap.get(caseMap.get(caseId));
            caseRecord.ContactId= contactMap.get(caseMap.get(caseId));
            caseRecord.NewAccountFlag__c = TRUE;
            if(accountMap.get(caseMap.get(caseId)) == null){
                caseRecord.Matching_Response__c=Label.CEC_MatchingResponse_AccountNotCreated;
            }
            caseList.add(caseRecord);
        }
        
        //Update the case records
        if(caseList.size()>0){
            
            Database.SaveResult[] updateResults = Database.update(caseList, false);
            failedCases = '';
            for(Integer i=0; i<updateResults.size();i++){
                if(!updateResults.get(i).isSuccess()){
                    Database.Error error = updateResults.get(i).getErrors().get(0);                
                    failedCases = failedCases + '<B>CaseId</B>:&nbsp;&nbsp;' +sfdcBaseURL+caseList.get(i).Id + '<br/>'; 
                    failedCases = failedCases + '<B>Error Message</B>:&nbsp;&nbsp;' + error.getMessage();       
                }
            }
            // send error emails if case insertion fails
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
        List<RecordType> allRecordtypes= [select id,name from RecordType where SobjectType='Case'];
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
        List<cec_Case_QC_Mapping__c> caseQcMapping= [select Product__c,Product__r.Consumer_Product_Descriptor_Local_Lang__c,QC_Type__c,Reason_Code__c,Status__c,Verbatim__c,Country__c from cec_Case_QC_Mapping__c where QC_Type__c in : recordTypesList AND Country__c in : countryCodeSet];
        
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
                                newCaseMap.get(caseObject.Id).CEC_Product_Hierarchy__c = qc.Product__r.Consumer_Product_Descriptor_Local_Lang__c;
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
                emailAccntMap.put(accnt.PersonEmail, accnt);
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
    
    /* Starts-  US-097 Personal data not included in Pulse */ 
    
    //Method to update the PIIWarning checkbox for New cases
    public void updatePIIWarningForInsert(List<Case> newCaseList){
        
        cec_Org_Settings__c orgSetting = cec_Org_Settings__c.getOrgDefaults();
        Map<Id, Account> accountsMap = new Map<Id, Account>();
        Set<Id> accountSet = new Set<Id>();   
        List<Case> newCaseUpdateList = new List<Case>();             
        
        try{
            
            for(case caseRecord : newCaseList){
                
                if(caseRecord.AccountId != null){
                    accountSet.add(caseRecord.AccountId);
                }   
                if(caseRecord.AccountId != null || (caseRecord.Description != null && caseRecord.Description !='')){
                    newCaseUpdateList.add(caseRecord); 
                }                
            }  
            
            if(accountSet.Size()>0){
                accountsMap = new Map<Id, Account>([SELECT id, LastName, FirstName, PersonMailingPostalCode,PersonMailingStreet FROM Account WHERE id IN : accountSet]);
            }
            
            for(case caseRecord : newCaseList){
                checkPIIWarning(caseRecord, accountsMap, orgSetting.PII_Account_Name_Check__c, orgSetting.PII_Account_Address_Check__c, orgSetting.PII_DOB_Check__c, orgSetting.PII_Phone_Number_Check__c, orgSetting.PII_Email_Check__c, orgSetting.PII_Keywords__c);        
            }                                
        }
        
        catch(Exception e)  {
            System.debug('Exception in the updatePIIWarning method : ' + e.getMessage());
        }
        
    }
    
    //Method to update the PIIWarning Flag for case updates
    public void updatePIIWarningForUpdate(List<Case> newCaseList , Map<id,Case> oldMap){
        
        cec_Org_Settings__c orgSetting = cec_Org_Settings__c.getOrgDefaults();
        Map<Id, Account> accountsMap = new Map<Id, Account>();
        Set<Id> accountSet = new Set<Id>();  
        Set<Id> caseSet = new Set<Id>();             
        
        try{
            
            for(case caseRecord : newCaseList){
                
                if(caseRecord.Description != oldMap.get(caseRecord.Id).Description || caseRecord.AccountId != oldMap.get(caseRecord.Id).AccountId){
                    caseSet.add(caseRecord.Id);
                    accountSet.add(caseRecord.AccountId);
                }
                
            }  
            
            if(accountSet.Size()>0){
                accountsMap = new Map<Id, Account>([SELECT id, LastName, FirstName, PersonMailingPostalCode,PersonMailingStreet FROM Account WHERE id IN : accountSet]);
            }
            
            for(case caseRecord : newCaseList){
                if(caseSet.contains(caseRecord.Id)){
                    checkPIIWarning(caseRecord, accountsMap, orgSetting.PII_Account_Name_Check__c, orgSetting.PII_Account_Address_Check__c, orgSetting.PII_DOB_Check__c, orgSetting.PII_Phone_Number_Check__c, orgSetting.PII_Email_Check__c, orgSetting.PII_Keywords__c);        
                }
            }
            
        }
        
        catch(Exception e)  {
            System.debug('Exception in the updatePIIWarning method : ' + e.getMessage());
        }
        
    }
    
    
    //Method to check whether PII data is present in the description or not
    public void checkPIIWarning(Case caseRecord, Map<Id, Account> accountsMap, Boolean isAccNameChk, Boolean isAccAddChk, Boolean isDOBChk, Boolean isPhChk, Boolean isEmailChk, String PIIKeyWords){
        // control variable
        Boolean isMatchFound = False;
        
        try{
            // parse description for email address
            if(isEmailChk && caseRecord.Description != null && caseRecord.Description.contains('@')){
                isMatchFound = True;
            }
            // parse description for phone numbers if phone check setting is enabled
            if(!isMatchFound && caseRecord.Description != null && isPhChk){
                String strRegEx='[0-9][0-9][0-9][0-9]';
                Pattern MyPattern = Pattern.compile(strRegEx);
                Matcher MyMatcher = MyPattern.matcher(caseRecord.Description);
                isMatchFound = MyMatcher.find();
            }
            // parse description for DOB if DOB check setting is enabled
            if(!isMatchFound && caseRecord.Description != null && isDOBChk){
                String strMultilang = PIIKeyWords;
                if(strMultilang != null){
                    List<String> keyWordStrList = strMultilang.split('-');
                    for(String keyWord : keyWordStrList){
                        keyWord =  keyWord.trim();
                        keyWord = keyWord.replaceAll('(\\s+)', '');
                        isMatchFound = caseRecord.Description.containsIgnoreCase(keyWord);
                        if(isMatchFound)
                            break;
                    }    
                } 
            }
            // parse description for name if name check setting is enabled
            if(!isMatchFound && caseRecord.Description != null && isAccNameChk && caseRecord.AccountId != NULL && ((accountsMap.get(caseRecord.AccountId).LastName !=null && caseRecord.Description.containsIgnoreCase(accountsMap.get(caseRecord.AccountId).LastName))|| (accountsMap.get(caseRecord.AccountId).FirstName != null && caseRecord.Description.containsIgnoreCase(accountsMap.get(caseRecord.AccountId).FirstName)))){
                isMatchFound = TRUE;
            }
            // parse description for Address if Address check setting is enabled
            if(!isMatchFound && caseRecord.Description != null && isAccAddChk && caseRecord.AccountId != NULL && ((accountsMap.get(caseRecord.AccountId).PersonMailingStreet !=null && caseRecord.Description.containsIgnoreCase(accountsMap.get(caseRecord.AccountId).PersonMailingStreet))|| (accountsMap.get(caseRecord.AccountId).PersonMailingPostalCode != null && caseRecord.Description.containsIgnoreCase(accountsMap.get(caseRecord.AccountId).PersonMailingPostalCode)))){
                isMatchFound = TRUE;
            }
            
            caseRecord.PII_Warning_Check__c = isMatchFound;
        }
        catch(Exception e){
            System.debug('Exception in the updatePIIWarning method : ' + e.getMessage());
        }
        
    }
    
    /* Ends -  US-097 Personal data not included in Pulse */ 
    
    
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
    
    /* US- CSC-2910 Personal Data Retention */
    
    public void updateAccountRetentionDetails(List<Case> caseLst, Map<id,Case> oldMap){
        Set<Id> accountIDsset = new Set<Id>();
        List<Case> getCasesRelatedToAccount = new List<Case>();       
        Map<Id , Case> casesMap = new Map<Id , Case>();
        List<Account> acctoUpdatelst= new List<Account>();                          
        
        Try{
            
            for(case caseRecord : caseLst){
                if(caseRecord.Status == 'Closed' && oldMap.get(caseRecord.ID).Status != 'Closed' && (caseRecord.Manual_Override_Reason__c !='' && caseRecord.Manual_Override_Reason__c != NULL)){
                    accountIDsset.add(caseRecord.AccountID);
                }
            }
            
            getCasesRelatedToAccount = [Select id,Manual_Override_Reason__c,AccountId,Manual_Retention_Override__c from Case where AccountId in: accountIDsset AND Manual_Retention_Override__c != null AND status = 'Closed' order by Manual_Override_Reason__c ASC, Manual_Retention_Override__c DESC];
            
            for(Case caseRecord : getCasesRelatedToAccount){
                if(!casesMap.containsKey(caseRecord.AccountId)){
                    casesMap.put(caseRecord.AccountId,caseRecord);
                }
            }
            for(Case caseRecord : casesMap.values()){                          
                if(caseRecord.AccountId != null)
                {
                    Account objAcc=new Account();
                    objAcc.id=caseRecord.AccountId;
                    objAcc.Retention_Date__c=caseRecord.Manual_Retention_Override__c;
                    objAcc.Retention_Reason__c=caseRecord.Manual_Override_Reason__c;
                    objAcc.Retention_Record_Id__c = caseRecord.id;
                    objAcc.Anonymise_check__c = true;
                    acctoUpdatelst.add(objAcc);
                }
            }
            
            if(acctoUpdatelst!=null && !acctoUpdatelst.isEmpty()){
                update acctoUpdatelst;
            }
        }
        Catch(Exception e){
            System.debug('An exception occurred: ' + e.getMessage());  
        }
    }
    
    public void updateRetentionDate(List<Case> caseLst , Map<id,Case> oldMap){
        
        List<Case> caseLstUpdate = new List<Case>();
        
        Try{
            for(Case newCase: caseLst){
                if(newCase.Status == 'Closed' && oldMap.get(newCase.id).status != 'Closed'&& newCase.Reason_Code_Retention_Days__c!= NULL && String.isEmpty(newCase.Manual_Override_Reason__c)){
                    newCase.Manual_Override_Reason__c = '3-Default';
                    newCase.Manual_Retention_Override__c = Date.Today().addDays(integer.valueof(newCase.Reason_Code_Retention_Days__c));
                }
                else if(newCase.Status == 'Closed' && oldMap.get(newCase.id).status != 'Closed' && newCase.Reason_Code_Retention_Days__c== NULL && newCase.Manual_Override_Reason__c == '3-Default'){
                    newCase.Manual_Override_Reason__c = '';
                    newCase.Manual_Retention_Override__c = null;
                }
            }       
            
        }Catch(Exception e ){
            System.debug('An exception occurred: ' + e.getMessage());  
        }        
    }
    
    public void setWorkflowFlag(Map<id,Case> newMap , Map<id,Case> oldMap){
        List<Case> caseLstUpdate = new List<Case>();
        list<id> caseIds = new list<id>();
        
        for(Case newCase: newMap.values()){
            // fetch caseIds of closed cases
            if(newCase.Status == 'Closed' && oldMap.get(newCase.id).status != 'Closed'){                
                caseIds.add(newCase.id);
            }
            // if cases are reopened, set Surveyworkflow flag to false
            if(newCase.Status != 'Closed' && oldMap.get(newCase.id).status == 'Closed'){
                newCase.ExecuteCaseSurveyWorkflow__c = false;
            }
        }
        // query cases that are closed along with related account fields
        caseLstUpdate = [SELECT id, ExecuteCaseSurveyWorkflow__c, account.PersonEmail, account.Known_Consumer__c
                         FROM Case
                         WHERE id IN :caseIds
                         LIMIT 10000];
        for(Case c :caseLstUpdate){
            // for all closed cases that fulfill the Survey criteria set survey flag to true
            if(c.account.PersonEmail != Null && c.account.PersonEmail != '' && c.account.Known_Consumer__c != 'Frequent'){
                newMap.get(c.id).ExecuteCaseSurveyWorkflow__c = true;
            }
        }
    }
    /* End US CSC-2910 Personal Data Retention */
    
    
    //To update the store and product information for Web Cases
    public void updateStoreAndProductInfo(List<Case> caseList , Map<id,Case> oldMap){
        // to map Case and UPC code
        map<id, string> caseUPCMap = new map<id, string>();
        // to map Case and store
        map<id, string> caseStoreMap = new map<id, string>();
        // to map Case and country
        map<id, string> caseCountryMap = new map<id, string>();
        // to map Case and ISO code
        map<id, string> caseISOCodeMap = new map<id, string>();
        
        list<mdm_Case_Product__c> caseProdList  = new list<mdm_Case_Product__c>();
        list<cec_store__c> caseStoreList = new list<cec_store__c>();
        
        string caseUPC = '';
        string caseStore = '';
        
        
        Try{
            for(case newCase: caseList){
                
                System.debug('Values $$$$$$$$$$$$$$$$' + newCase.Origin + ' ' + newCase.Case_ISO_Country_Code__c + ' ' + oldMap.get(newCase.Id).Case_ISO_Country_Code__c + ' ' + newCase.Country_Name__c + ' ' + oldMap.get(newCase.Id).Country_Name__c);
                // if case satisfies entry criteria, extract the required detais and update maps
                if(newCase.Origin == 'Web North America' && newCase.Case_ISO_Country_Code__c != oldMap.get(newCase.Id).Case_ISO_Country_Code__c && newCase.Country_Name__c != oldMap.get(newCase.Id).Country_Name__c){
                    caseUPC = CEC_CaseDescriptionParser.getCaseUPC(newCase.description);
                    // populate case maps
                    if(caseUPC != null){
                        caseUPCMap.put(newCase.Id, caseUPC);
                        caseISOCodeMap.put(newCase.Id, newCase.Case_ISO_Country_Code__c ); 
                    }
                    // fetch case store
                    caseStore = CEC_CaseDescriptionParser.getStoreName(newCase.description);
                    // populate store and country maps
                    if(caseStore != null){
                        caseStoreMap.put(newCase.Id, caseStore);
                        caseCountryMap.put(newCase.Id, newCase.Country_Name__c); 
                    }
                    
                }
                
            } 
            
            // query case product
            if(caseUPCMap.size() > 0){
                caseProdList  = [Select Id, GTIN_EAN_UPC_Code__c, ISO_Country_Code__c from mdm_Case_Product__c where GTIN_EAN_UPC_Code__c IN :caseUPCMap.values() AND ISO_Country_Code__c IN :caseISOCodeMap.values()];
            }  
            
            //query case stores
            if(caseStoreMap.size() > 0){
                caseStoreList = [Select Id, Name, Country__r.Name from cec_store__c where Country__r.Name IN :caseCountryMap.values() and Name IN :caseStoreMap.values()];
            }
            // update case fields based on criteria
            if(caseProdList.size()>0 || caseStoreList.size()>0){
                
                for(case newCase: caseList){
                    
                    if(newCase.Origin == 'Web North America' && newCase.Case_ISO_Country_Code__c != ''){
                        // update case product
                        if(caseUPCMap.get(newCase.Id) != null){
                            for(mdm_Case_Product__c caseProd : caseProdList){
                                if(caseProd.GTIN_EAN_UPC_Code__c == caseUPCMap.get(newCase.Id) && caseProd.ISO_Country_Code__c == caseISOCodeMap.get(newCase.Id)){
                                    newCase.CEC_Product__c = caseProd.Id;
                                    break;
                                }
                            }                        
                        } 
                        // update case store
                        if(caseStoreMap.get(newCase.Id) != null){
                            for(cec_store__c storeRec : caseStoreList){
                                if(storeRec.Name == caseStoreMap.get(newCase.Id) && storeRec.Country__r.Name == caseCountryMap.get(newCase.Id)){
                                    newCase.Store__c= storeRec.Id;
                                    break;
                                }
                            }                        
                        }
                        // update case origin
                        newCase.Origin = 'Web';
                    }
                    
                    
                }
                
            }
            
        }Catch(Exception e ){
            System.debug('An exception occurred: ' + e.getMessage());  
        }        
    }   
    
    
    
    /****  BEGIN: Case description parsing  ******/       
    public void updateSuppliedEmail(List<Case> newCaseList){
        
        // set supplied Email and Supplier name fields for Web North America Cases
        for(Case aCase : newCaseList){
            
            string caseEmail = '';
            string firstName = '', lastName = '';
            
            if(aCase.Origin == 'Web North America'){
                try{
                    aCase.AccountId = null;
                    aCase.ContactId = null;
                    // Fetch Email address from description 
                    caseEmail = CEC_CaseDescriptionParser.getCaseEmail(aCase.Description);
                    
                    // Set case email    
                    if(!String.isEmpty(caseEmail)){
                        aCase.SuppliedEmail = caseEmail;
                    }
                    
                    // Extract First name from case description
                    firstName = CEC_CaseDescriptionParser.getFirstName(aCase.Description);
                    
                    // Extract last name from Case description
                    lastName = CEC_CaseDescriptionParser.getLastName(aCase.Description);
                    
                    // Set case name
                    if(!String.isEmpty(lastName)){
                        if(!String.isEmpty(firstName)){
                            aCase.suppliedName = lastName + ', ' + firstName;
                        }else{
                            aCase.suppliedName = lastName;
                        }
                    }   
                    
                    // update case brand
                    aCase.Brand__c = CEC_CaseDescriptionParser.getBrand(aCase.Description);
                    
                }catch(Exception e ){
                    System.debug('An exception occurred: ' + e.getMessage());  
                }
            }
        }
    }
    
    private account updateAccountDetailsFromCaseDescription(Account accnt, string caseDescription){
        // fetch street Address
        accnt.PersonMailingStreet = CEC_CaseDescriptionParser.getPersonMailingStreet(caseDescription);
        // fetch City
        accnt.PersonMailingCity = CEC_CaseDescriptionParser.getPersonMailingCity(caseDescription);
        //fetch State
        accnt.PersonMailingState = CEC_CaseDescriptionParser.getPersonMailingState(caseDescription);
        // fetch ZIP code
        accnt.PersonMailingPostalCode = CEC_CaseDescriptionParser.getPersonMailingPostalCode(caseDescription);
        // fetch Country
        accnt.PersonMailingCountry = CEC_CaseDescriptionParser.getPersonMailingCountry(caseDescription);
        
        return accnt;
    }
    
    /******  END: Case description parsing *******/
    
    //Changes for CSC-3942
    /*****  ******/
    public void updateCaseBrandAndSkillOnUpdate(Map<Id,Case> newCaseMap, Map<id,Case> oldMap){
        
        map<Id, String> caseIdtoEmailMap = new map<Id, String>();
        System.debug('@@@@newCaseMap' + newCaseMap);
        if(newCaseMap != null){
            for(Case aCase : newCaseMap.values()){
                
                if(aCase.Brand__c != '' && aCase.Brand__c != null && (aCase.Brand__c != oldMap.get(aCase.id).Brand__c || aCase.Country_Name__c != oldMap.get(aCase.id).Country_Name__c)){
                    string caseBrandEmail;
                    caseBrandEmail = aCase.Country_Name__c +'.'+ aCase.Brand__c + '@unilever.com';                    
                    caseBrandEmail = caseBrandEmail.toLowerCase().replace(':','').replace(' ','');
                    System.debug('@@@caseBrandEmail '+caseBrandEmail);
                    caseIdtoEmailMap.put(aCase.id, caseBrandEmail);
                }
            }
        }
        
        List<cec_Case_Brand_Mapping__c> caseBrandMapping =[Select id, Inbound_Email__c, Skill__c from cec_Case_Brand_Mapping__c where Inbound_Email__c IN : caseIdtoEmailMap.Values()] ;
        System.debug('@@@caseBrandMapping ' +caseBrandMapping);
        try{
            if(!caseBrandMapping.isEmpty()){
                for(cec_Case_Brand_Mapping__c CBM : caseBrandMapping){
                    for(id caseId :caseIdtoEmailMap.keyset()){
                        if(caseIdtoEmailMap.get(caseId) == CBM.Inbound_Email__c){
                            newCaseMap.get(caseId).Case_Brand_Mapping__c = CBM.Id;
                            newCaseMap.get(caseId).Product_Skill__c = CBM.Skill__c;
                            break;
                        }
                    }
                }
            } 
        }catch(Exception e ){
            System.debug('An exception occurred: ' + e.getMessage());  
        }
    }
    
    public void updateCaseBrandAndSkillOnInsert(List<Case> newCaseList){
        set<string> emailSet = new set<string>();
        Map<Case, Map<String, Case>> emailMap2 = new Map<Case, Map<String, Case>>();
        Map<String, String> emailAndSkillMap = new Map<String,String>();
        
        if(newCaseList!=null){
            System.debug('newCaseList~~~~~~~~'+newCaseList);
            Map<String, Case> emailMap;
            
            for(Case aCase : newCaseList){                
                if(aCase.Brand__c != '' && aCase.Brand__c !=Null){
                    string caseBrandEmail;
                    emailMap = new Map<String, Case>();
                    caseBrandEmail = aCase.Country_Name__c +'.'+ aCase.Brand__c + '@unilever.com';                    
                    caseBrandEmail = caseBrandEmail.toLowerCase().replace(':','').replace(' ','');
                    System.debug('@@@caseBrandEmail '+caseBrandEmail);
                    emailSet.add(caseBrandEmail);
                    emailMap.put(caseBrandEmail, aCase);
                    emailMap2.put(aCase, emailMap);
                }
            }
        }
        System.debug('@@@@EmailSet '+ emailSet);
        List<cec_Case_Brand_Mapping__c> caseBrandMapping =[Select id, Inbound_Email__c, Skill__c from cec_Case_Brand_Mapping__c where Inbound_Email__c IN : emailSet] ;
        System.debug('@@@caseBrandMappingInsert ' +caseBrandMapping);
        try{
            if(!caseBrandMapping.isEmpty()){
                for(cec_Case_Brand_Mapping__c CBM : caseBrandMapping){
                    for(case aCase :newCaseList){
                        case thisCase = emailMap2.get(aCase).get(CBM.Inbound_Email__c);
                        if(thisCase == aCase){
                            aCase.Case_Brand_Mapping__c = CBM.Id;
                            aCase.Product_Skill__c = CBM.Skill__c;
                            break;
                        }
                    }
                }
            }
        }catch(Exception e ){
            System.debug('An exception occurred: ' + e.getMessage());  
        }
    }
}