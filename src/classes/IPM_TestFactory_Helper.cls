public with sharing class IPM_TestFactory_Helper {
    public static final String CHARTER_GATE_FULL = 'Charter Gate Full';
    public static final String IDEA_GRAPHIC= 'Idea / Graphic';
    public static final String IDEAS = 'Ideas';
    public static boolean FALSE_VAR = False;
    public static final String GCLT_RCLT = 'GCLT & RCLT';
    public static final String TEST_CONTENT =  'A quick brown fox jumped over a lazy dog';
    public static final String NEWVARIANTSIZE_STR = 'New Variant/ Size';
    public static final String COREPARAMETER_BLG = 'BLG';
    public static final String COREPARAMETER_GROWTHECORE ='Grow the Core';
    public static final String COREPARAMETER_NEWSCHANNEL = 'New Channels';
    public static final String COREPARAMETER_REGULATORY = 'Regulatory/ Compliance';
    public static final String COREPARAMETER_SUPPLYCHAIN ='Supply Chain';
    public static final String COREPARAMETER_TECHNOLOGYDEV = 'Technology Development';
    public static final String COREPARAMETER_VIP = 'VIP';
    public static final string QUESTIONTYPE_STR = 'Consumer';
    public static final string EMPTY_STRING = '';
    public static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
    public static List<IPM_Financial__c> finList = new List<IPM_Financial__c>();
    public static List<IPM_Financial_Year__c> finYear=new List<IPM_Financial_Year__c>();
    
    public static Id REGIONAL_ROLLOUT_RECTYPE = Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).RecordTypeId;
    public static Id LOCAL_ROLLOUT_RECTYPE = Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).RecordTypeId;
    
    public static ID  taskMasterRecordType = Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get(IPM_Utils.IPM_STANDARD_TASKS).getRecordTypeId();
    
    public static ID globalCompanyCardRecId = Schema.SObjectType.IPM_Company_Card__c.RecordTypeInfosByName.get(IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL).RecordTypeId;
    public static ID regionalCompanyCardRecId = Schema.SObjectType.IPM_Company_Card__c.RecordTypeInfosByName.get(IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_REGIONAL).RecordTypeId;
    public static ID localCompanyCardRecId = Schema.SObjectType.IPM_Company_Card__c.RecordTypeInfosByName.get(IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_LOCAL).RecordTypeId;
    
    public static ID recTypeRnD = Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RNDQUESTION_RECORD_TYPE).RecordTypeId;
    public static ID recTypeIDPOS = Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.POS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
    
    // RQS and Corporate Risk(CR) Record Type 
    public static ID recTypeIDRQS = Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RQS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
    public static ID recTypeIDCR = Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.CORPORATE_RISK_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;

    // R&D feasibility, Suppy Chain Feasibility and Risk Record Type 
    public static ID recTypeRnDFeasibility = Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RNDFEASIBILITYQUESTION_RECORD_TYPE).RecordTypeId;
    public static ID recTypeSCFeasibility = Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.SCFEASIBILITY_RECORD_TYPE).RecordTypeId;
    public static ID recTypeRisk = Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RISKQUESTION_RECORD_TYPE).RecordTypeId;
    
    public static List<IPM_Project_Template__c> getIMPProjectTemplateList() {
        Map<String,List<Object>> projTemMap =  new Map<String,List<Object>>{
        'IPM_Template_Complexity__c' => new List<Object>{IPM_ConstantUtils.COMPLEXITY_FULL,IPM_ConstantUtils.COMPLEXITY_FULL,IPM_ConstantUtils.COMPLEXITY_FULL,IPM_ConstantUtils.COMPLEXITY_FULL,IPM_ConstantUtils.COMPLEXITY_FULL}
        };
        System.savePoint sp = Database.setSavepoint();  
        List<IPM_Project_Template__c> projectTemplateList = (List<IPM_Project_Template__c>)IPM_TestFactory.createSObjectList('IPM_Project_Template__c',projTemMap,true);
        insert projectTemplateList;
        Database.rollback(sp);
        return projectTemplateList;
    }

    public static List<IPM_Document_Template__c> getIPMDocumentTemplateList() {
        List<IPM_Project_Template__c> projTemplateList = getIMPProjectTemplateList();
        List<IPM_Document_Template__c> documentTemlateList = new List<IPM_Document_Template__c>();
        for(IPM_Project_Template__c projTempl : projTemplateList) {      
            Map<String,Object> docTemMap =  new Map<String,Object>{'IPM_Project_Template__c' => projTempl.ID,'IPM_Document_Template_Name__c' =>CHARTER_GATE_FULL, 'IPM_Document_Type__c' => IPM_ConstantUtils.FIELD_SUFFIX_CHARTER};
            IPM_Document_Template__c docTempl = (IPM_Document_Template__c)IPM_TestFactory.createSObject('IPM_Document_Template__c',docTemMap,false);
            documentTemlateList.add(docTempl);
        }
        insert documentTemlateList;
        return documentTemlateList;
    }
    public static final String UNITED_STATES = 'United States';
    public static final String ENGLISH = 'English';
    public static List<ar_Geography__c> getGeographyList() {
        List<ar_Geography__c> geographyList = new List<ar_Geography__c>();
        //System.savePoint sp = Database.setSavepoint();  
        Map<String,List<Object>> geographyMap =  new Map<String,List<Object>>{
        'Country__c' => new List<Object>{UNITED_STATES,UNITED_STATES,UNITED_STATES,UNITED_STATES,UNITED_STATES},
        'Languages_Available__c' => new List<Object>{ENGLISH,ENGLISH,ENGLISH,ENGLISH,ENGLISH}
        };
        List<ar_Geography__c> geographicList = (List<ar_Geography__c>)IPM_TestFactory.createSObjectList('ar_Geography__c',geographyMap,true);
        insert geographicList;
       // Database.rollback(sp);
       return geographicList;   
    }
    
    public static Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; //retrieve the profile of the user
    public static User createUser(Boolean doInsert) {
        String uniqueUserEMailId = getUniqueUsername();
        User u = new User(Alias = uniqueUserEMailId.substring(18,23), Email=uniqueUserEMailId, 
            EmailEncodingKey=IPM_ConstantUtils.USER_EMAIL_ENCODE, LastName='IPMUSER_LASTNAME', LanguageLocaleKey=IPM_ConstantUtils.USER_LOCALEKEY, 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey=IPM_ConstantUtils.USER_TIMEZONEKEY, UserName=uniqueUserEMailId, 
            IPM_Category__c = IPM_ConstantUtils.TEST_STR  , IPM_Brand_Positioning__c= IPM_ConstantUtils.TEST_STR,IPM_Brand_Name__c =IPM_ConstantUtils.TEST_STR,
            IPM_Role__c=IPM_ConstantUtils.USER_IPM_ROLE ,IPM_Sub_Category__c=IPM_ConstantUtils.TEST_STR , isActive =true);
        
        if(doInsert) { 
            insert u;
        }
        return u;
    }
    
    public static Profile PAdmin = [SELECT Id FROM Profile WHERE Name='System Administrator']; //retrieve the profile of the user
    public static User createUserAdmin(Boolean doInsert) {
        String uniqueUserEMailId = getUniqueUsername();
        User u = new User(Alias = uniqueUserEMailId.substring(18,23), Email=uniqueUserEMailId, 
            EmailEncodingKey=IPM_ConstantUtils.USER_EMAIL_ENCODE, LastName='IPMUSER_LASTNAME', LanguageLocaleKey=IPM_ConstantUtils.USER_LOCALEKEY, 
            LocaleSidKey='en_US', ProfileId = PAdmin.Id, 
            TimeZoneSidKey=IPM_ConstantUtils.USER_TIMEZONEKEY, UserName=uniqueUserEMailId, 
            IPM_Category__c = IPM_ConstantUtils.TEST_STR  , IPM_Brand_Positioning__c= IPM_ConstantUtils.TEST_STR,IPM_Brand_Name__c =IPM_ConstantUtils.TEST_STR,
            IPM_Role__c=IPM_ConstantUtils.USER_IPM_ROLE ,IPM_Sub_Category__c=IPM_ConstantUtils.TEST_STR , isActive =true);
        
        if(doInsert) { 
            insert u;
        }
        return u;
    }
    
    
    public static String getUniqueUsername() {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        return (uniqueName + '@bosscard' + orgId + '.org');
    }
    public static IPM_Project_Template__c createIPMProjectTemplate(Boolean doInsert) {
        Map<String,Object> projTemMap =  new Map<String,Object>{'IPM_Template_Complexity__c' => 'Full'};
        IPM_Project_Template__c projTemplate = (IPM_Project_Template__c)IPM_TestFactory.createSObject('IPM_Project_Template__c',projTemMap,FALSE);
        if(doInsert) { 
            insert projTemplate;
        }
            return projTemplate;
    }   
    
    public static IPM_Document_Template__c creteIPMDocumentTemplate(Boolean doInsert) {
        Map<String,Object> docTemMap =  new Map<String,Object>{'IPM_Document_Template_Name__c'=> CHARTER_GATE_FULL, 'IPM_Document_Type__c' => IPM_ConstantUtils.FIELD_SUFFIX_CHARTER};
        IPM_Document_Template__c ipdoctem = (IPM_Document_Template__c)IPM_TestFactory.createSObject('IPM_Document_Template__c',docTemMap,FALSE);
        if(doInsert) { 
            insert ipdoctem;
        }
        return ipdoctem;
    }
    
    public static IPM_Section__c createIPMSection(Boolean doInsert) {
        Map<String,Object> sectMap =  new Map<String,Object>{'IPM_Section_Sequence__c'=> IPM_ConstantUtils.IDEAS_SEQUENCE, 
                    'IPM_Section_Name__c' => IDEA_GRAPHIC, 'IPM_Negotiable__c' => FALSE};
        IPM_Section__c secMast = (IPM_Section__c)IPM_TestFactory.createSObject('IPM_Section__c',sectMap,FALSE);
        if(doInsert) { 
            insert secMast;
        }
        return secMast;
    }
    
    public static List<IPM_Project__c> insertIPMProjectList(){ 
        Map<String,List<Object>> IPMProjectMap =  new Map<String,List<Object>>{
                    'IPM_Project_Name__c' => new List<Object>{'test1','test2', 'test3'},
                    'IPM_PM_Approach__c' => new List<Object>{'External','External', 'External'},
                    'IPM_IsCompleted__c' => new List<Object>{true,true, true},
                    'IPM_Fast_Track_Project__c' => new List<Object>{false,false,false},
                    'IPM_Phase__c' => new List<Object>{IPM_ConstantUtils.PHASE_IDEAS,IPM_ConstantUtils.PHASE_IDEAS, IPM_ConstantUtils.PHASE_IDEAS},
                    'IPM_Market_Type__c' => new List<Object>{'Lite','Full','Lite'},
                    'IPM_Target_Launch_Dates__c' => new List<Object>{System.today()+10,System.today()+5, System.today()+3},
                    'IPM_Project_Leader__c' => new List<Object>{UserInfo.getUserId(),UserInfo.getUserId()},
                    'IPMProject_Span__c' => new List<Object>{IPM_ConstantUtils.SpanGlobal,IPM_ConstantUtils.Regional,IPM_ConstantUtils.Local}
                 };
           
        projectList = (List<IPM_Project__c>)IPM_TestFactory.createSObjectList('IPM_Project__c',IPMProjectMap,false);
       
        insert projectList;
        projectList[0].IPMProject_Span__c = 'Global';
        projectList[1].IPMProject_Span__c = 'Regional';
        projectList[1].IPM_Parent_Project__c = projectList[0].id;
        projectList[2].IPMProject_Span__c = 'Local';
        projectList[2].IPM_Parent_Project__c =  projectList[0].id;
        update projectList;
        return projectList;
    }
    
   public static List<IPM_Financial__c> insertIPMFinancialList(Boolean DOinsert){ 
        String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Default'].Id;
        Map<String,List<Object>> IPMProjectMap =  new Map<String,List<Object>>{
                    'IPM_Project_Name__c' => new List<Object>{'test1','test2', 'test3'},
                    'RecordTypeId' => new List<Object>{strRecordTypeId,strRecordTypeId, strRecordTypeId},
                    'Parent_Project__c' => new List<Object>{projectList[0].Id,projectList[1].Id, projectList[2].Id},
                    'Target_Launch_Date__c' => new List<Object>{System.today()+10,System.today()+5, System.today()+3},
                    'Financial_External_ID__c' => new List<Object>{'globalMCOName','RegionalMCOName','localMCOName'}
                 };
           
        finList = (List<IPM_Financial__c>)IPM_TestFactory.createSObjectList('IPM_Financial__c',IPMProjectMap,true); 
        if(DOinsert)
           insert finList;
        return finList;
    }
  public static List<IPM_Financial_Year__c> insertIPMFinancialYearList(){
                 String id1 = finList[0].id;
                 String id2 = finList[1].id;
                 String id3 = finList[2].id;
                 String fin1 = id1.subString(IPM_ConstantUtils.intialVal, id1.length()-3);
                 String fin2 = id2.subString(IPM_ConstantUtils.intialVal, id2.length()-3);
                 String fin3 = id3.subString(IPM_ConstantUtils.intialVal, id3.length()-3);
               /*  Map<String,List<Object>> IPMProjectMap =  new Map<String,List<Object>>{
                    'IPM_Financial__c' => new List<Object>{fin1,fin1,fin1,fin2,fin3},
                    'Name' => new List<Object>{'Y0','Y1','Y1','Y0','Y1','Y2'},
                    'year__c' => new List<Object>{'Innovation','Innovation','Calendar','Innovation','Calendar','Innovation'},
                    'PL_type__c' => new List<Object>{'','Gross','Incremental','','Incremental','Incremental'}
                 };*/
           IPM_Financial_Year__c finYear1 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear1.IPM_Financial__c= finList[0].Id;
            finYear1.Name = 'Y1';
            finYear1.year__c = 'Innovation';
            finYear1.PL_type__C = 'Gross';
            finYear.add(finYear1);
            IPM_Financial_Year__c finYear2 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear2.IPM_Financial__c= finList[1].Id;
            finYear2.Name = 'Y1';
            finYear2.year__c = 'Calendar';
            finYear2.PL_type__C = 'Incremental';
            finYear.add(finYear2);
            IPM_Financial_Year__c finYear3 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear3.IPM_Financial__c= finList[1].Id;
            finYear3.Name = 'Y0';
            finYear3.year__c = 'Innovation';
            finYear.add(finYear3);
            IPM_Financial_Year__c finYear4 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear4.IPM_Financial__c= finList[2].Id;
            finYear4.Name = 'Y0';
            finYear4.year__c = 'Innovation';
            finYear.add(finYear4);
       // finYear = (List<IPM_Financial_Year__c>)IPM_TestFactory.createSObjectList('IPM_Financial_Year__c',IPMProjectMap,true);
        insert finYear;
        return finYear;
  }
    
    // IPM Project List Sample Data 
    public static List<IPM_Project__c> createIPMProjectList(Boolean doInsert, Integer listSize){
        
        List<IPM_Project__c> testIPMProjList = new List<IPM_Project__c>();

        for(Integer i = 1; i <= listSize; i++){
            
            Map<String,Object> projMap =  new Map<String,Object>{'Name' => 'TestComments' + i,'IPM_Project_Name__c'=>'TestComments' + i,
                                        'IPM_Complexity__c' =>IPM_ConstantUtils.COMPLEXITY_FULL, 'IPM_GateKeeping_Model__c' => GCLT_RCLT,
                                        'IPM_Target_Launch_Dates__c' => System.today().addMonths(6), 'IPM_Project_Leader__c' => UserInfo.getUserId(), 'IPM_Phase__c'=> IPM_ConstantUtils.PHASE_IDEAS};
            IPM_Project__c projectRecord = (IPM_Project__c)IPM_TestFactory.createSObject('IPM_Project__c',projMap,TRUE);
            testIPMProjList.add(projectRecord);
            system.debug('Nitin '+ String.valueOf(i) + ':::'+testIPMProjList);
            
        }
        
        if(doInsert) { 
            insert testIPMProjList;
        }
        return testIPMProjList;
    }
        // IPM Project List Sample Data 
    public static List<IPM_Project__c> createIPMProjectListUser(Boolean doInsert, Integer listSize){
        
        List<IPM_Project__c> testIPMProjList = new List<IPM_Project__c>();

        for(Integer i = 1; i <= listSize; i++){
            
            Map<String,Object> projMap =  new Map<String,Object>{'Name' => 'IPMProjectName' + i,'IPM_Project_Name__c'=>'IPMProjectName' + i,
                                        'IPM_Complexity__c' =>IPM_ConstantUtils.COMPLEXITY_FULL, 'IPM_GateKeeping_Model__c' => GCLT_RCLT,
                                        'IPM_Target_Launch_Dates__c' => System.today().addMonths(6), 'IPM_Project_Leader__c' => UserInfo.getUserId(), 'IPM_Phase__c'=> IPM_ConstantUtils.PHASE_IDEAS};
            IPM_Project__c projectRecord = (IPM_Project__c)IPM_TestFactory.createSObject('IPM_Project__c',projMap,TRUE);
            testIPMProjList.add(projectRecord);
            system.debug('Nitin '+ String.valueOf(i) + ':::'+testIPMProjList);
            
        }
        
        if(doInsert) { 
            insert testIPMProjList;
        }
        return testIPMProjList;
    }
    
    
    // IPM Project List Sample Data 
    public static List<IPM_Project__c> createOriginalProjectList(Boolean doInsert, Integer listSize){
        
        List<IPM_Project__c> testIPMProjList = new List<IPM_Project__c>();
        for(Integer i = 1; i <= listSize; i++){
            Map<String,Object> projMap =  new Map<String,Object>{'Name' => 'TestComments' + i,'IPM_Project_Name__c'=>'TestComments' + i,
                                        'IPM_Complexity__c' =>IPM_ConstantUtils.COMPLEXITY_FULL, 'IPM_GateKeeping_Model__c' => GCLT_RCLT,
                                        'IPM_Target_Launch_Dates__c' => System.today().addMonths(6),'IPMProject_Span__c'=>'Global', 
                                        'IPM_Project_Leader__c' => UserInfo.getUserId(),'IPM_CompanyCardText__c' => 'Global Company Card',
                                        'IPM_Brand_Positioning__c' => 'Dirt is Good','IPM_Project_Type__c' => 'Original',
                                        'IPM_ProjectSubType__c' => 'Innovation/Renovation','IPM_Phase__c'=> IDEAS,
                                        'IPM_Category_Text__c' => 'HHC','IPM_Child_Complexity__c' =>IPM_ConstantUtils.COMPLEXITY_FULL};
            IPM_Project__c projectRecord = (IPM_Project__c)IPM_TestFactory.createSObject('IPM_Project__c',projMap,TRUE);
            testIPMProjList.add(projectRecord);
        }
        
        if(doInsert) { 
            insert testIPMProjList;
        }
        return testIPMProjList;
    }
      
    public static IPM_Project__c createIPMProject(Boolean doInsert){
        Map<String,Object> projMap =  new Map<String,Object>{'Name' => 'TestComments',
                                    'IPM_Complexity__c' =>IPM_ConstantUtils.COMPLEXITY_FULL, 'IPM_GateKeeping_Model__c' => GCLT_RCLT};
        IPM_Project__c projectRecord = (IPM_Project__c)IPM_TestFactory.createSObject('IPM_Project__c',projMap,TRUE);
        if(doInsert) { 
            insert projectRecord;
        }
        return projectRecord;
    }
    
    public static IPM_Project_Rollout__c createIPMProjectRollout(Boolean doInsert) {
        Map<String,Object> projRollOutMap =  new Map<String,Object>{'RecordTypeId'=> REGIONAL_ROLLOUT_RECTYPE ,
                                            'IPM_Rollout_Project__c' =>'TestComments_SEAA', 'Market_Cluster__c' => 'SEAA',
                                            'Target_Launch_Date__c' =>date.today()};
        IPM_Project_Rollout__c projRollOut = (IPM_Project_Rollout__c)IPM_TestFactory.createSObject('IPM_Project_Rollout__c',projRollOutMap,FALSE);
        if(doInsert) {
            insert projRollOut;
        }
        return projRollOut;
    }
    
    public static List<IPM_Project_Rollout__c> createRegionalRolloutList(Boolean doInsert,List<IPM_Project__c> pProjectList,List<User> projectLeaders) 
    {
        Map<String,List<Object>> regionalRolloutMap = new Map<String,List<Object>>
        {
            'IPM_Rollout_Project__c' => new List<String>(),'RecordTypeId' => new List<object>(),'Market_Cluster__c' => new List<String>(),
            'Market_Cluster_Name__c' => new List<String>(),'Target_Launch_Date__c' => new List<object>(),'IPM_Rollout_Span__c' => new List<object>(),
            'IPM_Rollout_Type__c' => new List<object>(),'IPM_Regional_PL_Text__c' => new List<object>(),'IPM_Regional_PL__c' => new List<Id>(),
            'IPM_Project__c' => new List<Id>()
        };
        
        Date sixMonthsLater = date.today().addMonths(6);
        
        Id regionalRecordType = Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).RecordTypeId;
        
        for(Integer counter=0;counter<pProjectList.size();counter++)
        {
            regionalRolloutMap.get('IPM_Rollout_Project__c').add(pProjectList[counter].IPM_Project_Name__c+'_AFR');
            regionalRolloutMap.get('IPM_Rollout_Project__c').add(pProjectList[counter].IPM_Project_Name__c+'_LA');
            
            regionalRolloutMap.get('Market_Cluster__c').add('GEO0060');
            regionalRolloutMap.get('Market_Cluster__c').add('GEO0005');
            
            regionalRolloutMap.get('Market_Cluster_Name__c').add('Africa');
            regionalRolloutMap.get('Market_Cluster_Name__c').add('Latin America');
            
            regionalRolloutMap.get('Target_Launch_Date__c').addAll(new List<Object>{sixMonthsLater,sixMonthsLater});
            
            regionalRolloutMap.get('IPM_Rollout_Span__c').addAll(new List<Object>{'Regional','Regional'});
            
            regionalRolloutMap.get('IPM_Rollout_Type__c').addAll(new List<Object>{'Rollout','Rollout'});
    
            regionalRolloutMap.get('RecordTypeId').addAll(new List<Object>{regionalRecordType,regionalRecordType});
            
            regionalRolloutMap.get('IPM_Regional_PL__c').addAll(new List<Object>{projectLeaders[counter].Id,projectLeaders[counter].Id});
            
            regionalRolloutMap.get('IPM_Regional_PL_Text__c').addAll(new List<Object>{projectLeaders[counter].Name,projectLeaders[counter].Name});
            
            regionalRolloutMap.get('IPM_Project__c').addAll(new List<Object>{pProjectList[counter].Id,pProjectList[counter].Id});
        }
        
        List<IPM_Project_Rollout__c> regionalRolloutList = (List<IPM_Project_Rollout__c>)IPM_TestFactory.createSObjectList('IPM_Project_Rollout__c',regionalRolloutMap,false);
        
        if(doInsert) {
            insert regionalRolloutList;
        }
        
        return regionalRolloutList;
    }
         
        
    public static List<IPM_Project_Rollout__c> createLocalRolloutsList(Boolean doInsert,Map<Id,List<IPM_Project_Rollout__c>> projectToRegionalRolloutMap,List<User> projectLeaders)
    {
        
        Map<String,List<Object>> localRolloutMap = new Map<String,List<Object>>
        {
            'IPM_Rollout_Project__c' => new List<String>(),'Market_Cluster__c' => new List<String>(),
            'Market_Cluster_Name__c' => new List<String>(),'Target_Launch_Date__c' => new List<Object>(),'IPM_Rollout_Span__c' => new List<String>(),
            'IPM_Rollout_Type__c' => new List<String>(),'IPM_Regional_PL_Text__c' => new List<String>(),'IPM_Regional_PL__c' => new List<Id>(),
            'IPM_Project__c' => new List<Id>(),'Type__c' => new List<String>(),'Regional_Rollout__c' => new List<Id>(),'MCO_Name__c' => new List<String>(),
            'IPM_Status__c' => new List<String>(),'MCO__c' => new List<String>(),'RecordTypeId' => new List<ID>()
        };
        
        Id localRecordType = Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).RecordTypeId;
        
        System.debug('localRecordType-->>'+localRecordType);
        for(Id projectId : projectToRegionalRolloutMap.keySet())
        {   
            for(IPM_Project_Rollout__c projectRollout : projectToRegionalRolloutMap.get(projectId))
            {
                if(projectRollout.IPM_Rollout_Project__c.contains('AFR'))
                {
                    localRolloutMap.get('IPM_Rollout_Project__c').add(projectRollout.IPM_Rollout_Project__c+'_UMCA');
                    localRolloutMap.get('MCO__c').add('LV4_GEO0085');
                    localRolloutMap.get('MCO_Name__c').add('Africa');
                    localRolloutMap.get('Market_Cluster_Name__c').add('Africa Emerging Markets');
                }
                else if(projectRollout.IPM_Rollout_Project__c.contains('LA'))
                {
                    localRolloutMap.get('IPM_Rollout_Project__c').add(projectRollout.IPM_Rollout_Project__c+'_BR'); 
                    localRolloutMap.get('MCO__c').add('LV4_BR');
                    localRolloutMap.get('MCO_Name__c').add('Brazil');
                    localRolloutMap.get('Market_Cluster_Name__c').add('Latin America');
                }
                
                localRolloutMap.get('RecordTypeId').add(localRecordType);
                System.debug('localRolloutMap-->>'+localRolloutMap.get('RecordTypeId'));
                
                localRolloutMap.get('Market_Cluster__c').add(projectRollout.Market_Cluster__c);
  
                localRolloutMap.get('IPM_Rollout_Type__c').add(projectRollout.IPM_Rollout_Type__c);
                localRolloutMap.get('Target_Launch_Date__c').add(projectRollout.Target_Launch_Date__c);
                localRolloutMap.get('IPM_Rollout_Span__c').add('Local');
                localRolloutMap.get('Type__c').add('MCO');
                localRolloutMap.get('IPM_Status__c').add('Leader');
                localRolloutMap.get('Regional_Rollout__c').add(projectRollout.Id);
                localRolloutMap.get('IPM_Project__c').add(projectId);
            }
        }
          
        List<IPM_Project_Rollout__c> localRolloutList = (List<IPM_Project_Rollout__c>)IPM_TestFactory.createSObjectList('IPM_Project_Rollout__c',localRolloutMap,false);
        
        if(doInsert) {
            insert localRolloutList;
        }
        return localRolloutList;
    }   
        
    
    // Sample IPMProjectDocument list Data
    public static List<IPM_Project_Document__c> createIPMProjectDocumentList(Boolean doInsert, Integer listSize) {
        
        List<IPM_Project_Document__c> ipmProjDocTestList = new List<IPM_Project_Document__c>();
        
        for(Integer i = 0; i < listSize; i++ ){
            Map<String,Object> projDocMap =  new Map<String,Object>{'Name' => 'Test Doc' + i, 'IPM_GateDocuments__c' => IPM_ConstantUtils.CHARTER_GATE, 
                                            'IPM_Contract_GateKeeper_Model__c' => GCLT_RCLT};
            IPM_Project_Document__c projDocument = (IPM_Project_Document__c)IPM_TestFactory.createSObject('IPM_Project_Document__c',projDocMap,FALSE);
            ipmProjDocTestList.add(projDocument);
        }   
        if(doInsert) { 
            insert ipmProjDocTestList;
        }
        return ipmProjDocTestList;
    }
    
    public static IPM_Project_Document__c createIPMProjectDocument(Boolean doInsert) {
        Map<String,Object> projDocMap =  new Map<String,Object>{'IPM_GateDocuments__c' => IPM_ConstantUtils.CHARTER_GATE, 
                                        'IPM_Contract_GateKeeper_Model__c' =>GCLT_RCLT};
        IPM_Project_Document__c projDocument = (IPM_Project_Document__c)IPM_TestFactory.createSObject('IPM_Project_Document__c',projDocMap,FALSE);
        if(doInsert) { 
            insert projDocument;
        }
        return projDocument;
    }
    
    public static List<IPM_Project_Document_Section__c> createIPMProjectDocumentSectionList(Boolean doInsert, Integer listSize) {
        
        List<IPM_Project_Document_Section__c> impProjDocSectionTestList = new List<IPM_Project_Document_Section__c>();        
        for(Integer i = 0; i < listSize; i++){
            Map<String,Object> projDocSecMap =  new Map<String,Object>{'IPM_Section_Name__c' =>IDEA_GRAPHIC,
                                            'IPM_Default_Section__c' => True};
            IPM_Project_Document_Section__c pojDocSection = (IPM_Project_Document_Section__c)IPM_TestFactory.createSObject('IPM_Project_Document_Section__c'
                                                ,projDocSecMap,FALSE);
            impProjDocSectionTestList.add(pojDocSection);
        }
       
        if(doInsert) { 
            insert impProjDocSectionTestList;
        }
        return impProjDocSectionTestList;
    }
    
    public static IPM_Project_Document_Section__c createIPMProjectDocumentSection(Boolean doInsert) {
        Map<String,Object> projDocSecMap =  new Map<String,Object>{'IPM_Section_Name__c' =>IDEA_GRAPHIC,
                                            'IPM_Default_Section__c' => True};
        IPM_Project_Document_Section__c pojDocSection = (IPM_Project_Document_Section__c)IPM_TestFactory.createSObject('IPM_Project_Document_Section__c'
                                            ,projDocSecMap,FALSE);
        if(doInsert) { 
            insert pojDocSection;
        }
        return pojDocSection;
    }
    
    public static IPM_Project_Document_Section_Content__c createIPMProjectDocumentSectionContent(Boolean doInsert) {
        Map<String,Object> projDocSecConMap =  new Map<String,Object>{'Name' => 'Test Document Section'};
        IPM_Project_Document_Section_Content__c projDocSecCon = (IPM_Project_Document_Section_Content__c)IPM_TestFactory.createSObject('IPM_Project_Document_Section_Content__c'
                                        ,projDocSecConMap,false);
        if(doInsert) { 
            insert projDocSecCon;
        }
        return projDocSecCon;
    }
    
    public static IPM_Customer_Channel_Priority_Order__c createIPMCustomerChannelPriorityOrder(Boolean doInsert) {
        Map<String,Object> iccPOMap =  new Map<String,Object>{'Name' => 'HyperMarket','Priority_Order_Value__c'=>'1'};
        IPM_Customer_Channel_Priority_Order__c iccPO = (IPM_Customer_Channel_Priority_Order__c)IPM_TestFactory.createSObject('IPM_Customer_Channel_Priority_Order__c'
                                  ,iccPOMap,false);
        if(doInsert) { 
            insert iccPO;
        }
        return iccPO;
    }
    
    public static IPM_Financial__c createIPMFinancial(Boolean doInsert) {
        Map<String,Object> finConMap =  new Map<String,Object>{'Volume_Unit__c'=>'Total Tons','Financial_External_ID__c'=>'TESTAPPROVERCL_CONSOLIDATED',
                              'Target_Launch_Date__c'=>System.today(),'Status__c'=>'Not Started'};
        IPM_Financial__c finCon = (IPM_Financial__c)IPM_TestFactory.createSObject('IPM_Financial__c',finConMap,true);
        if(doInsert) { 
            insert finCon;
        }
        return finCon;
    }
    
    // Sample List of IPM Bosscard Data 
    public static List<IPM_Bosscard__c> createIPMBosscardList(Boolean doInsert, Integer listSize) {
        
        List<IPM_Bosscard__c> ipmBosscardTestList = new List<IPM_Bosscard__c>();
        for(Integer i = 0; i < listSize; i++){
            Map<String,Object> bossCardMap =  new Map<String,Object>{'IPM_BosscardName__c' => 'TestBosscard'+i,'IPM_Assumptions__c' =>TEST_CONTENT,
                                                                    'IPM_Background__c'=>TEST_CONTENT,'IPM_Constraints__c' =>TEST_CONTENT,
                                                                    'IPM_Consumer_Need__c'=>TEST_CONTENT,'IPM_Deliverables__c'=>TEST_CONTENT,
                                                                    'IPM_Potential_Business_Opportunity__c'=>TEST_CONTENT,'IPM_Resources__c'=>TEST_CONTENT,
                                                                    'IPM_Scope__c'=>TEST_CONTENT,'IPM_IsSaved__c'=>true,
                                                                    'IPM_Brand_Positioning__c'=>'Dirt Is Good','IPM_Target_Launch_Date__c'=>'20/10/2020',
                                                                    'IPM_Is_Archived__c' => false};
            IPM_Bosscard__c ipmBosscard = (IPM_Bosscard__c)IPM_TestFactory.createSObject('IPM_Bosscard__c',bossCardMap,false);
            ipmBosscardTestList.add(ipmBosscard);
        }
        if(doInsert) { 
            insert ipmBosscardTestList;
        }
        return ipmBosscardTestList;
    }
    
    public static IPM_Bosscard__c createIPMBosscard(Boolean doInsert) {
        Map<String,Object> bossCardMap =  new Map<String,Object>{'IPM_BosscardName__c' => 'Test Boss card','IPM_Assumptions__c' =>TEST_CONTENT,
                                                                'IPM_Background__c'=>TEST_CONTENT,'IPM_Constraints__c' =>TEST_CONTENT,
                                                                'IPM_Consumer_Need__c'=>TEST_CONTENT,'IPM_Deliverables__c'=>TEST_CONTENT,
                                                                'IPM_Potential_Business_Opportunity__c'=>TEST_CONTENT,'IPM_Resources__c'=>TEST_CONTENT,
                                                                'IPM_Scope__c'=>TEST_CONTENT,'IPM_IsSaved__c'=>true,
                                                                'IPM_Brand_Positioning__c'=>'Dirt Is Good','IPM_Target_Launch_Date__c'=>'20/10/2020',
                                                                'IPM_Is_Archived__c' => false};
        IPM_Bosscard__c ipmBosscard = (IPM_Bosscard__c)IPM_TestFactory.createSObject('IPM_Bosscard__c',bossCardMap,false);
        if(doInsert) { 
            insert ipmBosscard;
        }
        return ipmBosscard;
    }
    
    public static IPM_Task__c createIPMTask(Id projId, Boolean doInsert) {
        Map<String,Object> taskDataMap =  new Map<String,Object>{'Name' => 'testtask'};
        if(projId != null) {taskDataMap.put('IPM_Project__c', projId);}
        
        IPM_Task__c task = (IPM_Task__c)IPM_TestFactory.createSObject('IPM_Task__c',taskDataMap,false);
        if(doInsert) { 
            insert task;
        }
        return task;
    }
    
    // Sample IPMMileStone List Data 
    public static List<IPM_Milestone__c> createIPMMilestoneList(Boolean doInsert, Integer listSize) {
        
        List<IPM_Milestone__c> milestoneTestList = new List<IPM_Milestone__c>();
        for(Integer i = 0; i < listSize; i++){
             Map<String,Object> milestoneDataMap =  new Map<String,Object>{'Name' => 'test milestone' + i};
             IPM_Milestone__c milestone = (IPM_Milestone__c)IPM_TestFactory.createSObject('IPM_Milestone__c',milestoneDataMap,false);
             milestoneTestList.add(milestone);          
        }
        if(doInsert){ 
            insert milestoneTestList;
        }
        return milestoneTestList;
    }
    
    public static IPM_Milestone__c createIPMMilestone(Id projId, Boolean doInsert) {
        Map<String,Object> milestoneDataMap =  new Map<String,Object>{'Name' => 'test milestone'};
        if(projId != null) {milestoneDataMap.put('IPM_Project__c', projId);}
        
        IPM_Milestone__c milestone = (IPM_Milestone__c)IPM_TestFactory.createSObject('IPM_Milestone__c',milestoneDataMap,false);
        if(doInsert) { 
            insert milestone;
        }
        return milestone;
    }
    
    // Sample Data List of IPMProject Resource     
    public static List<IPM_Project_Resource__c> createIPMProjectResourceList(Boolean doInsert, Integer listSize) {
        
        List<IPM_Project_Resource__c> ipmProjResourceTestList = new List<IPM_Project_Resource__c>();
        
        for(Integer i = 0; i < listSize; i++){
            Map<String,Object> projResourceDataMap =  new Map<String,Object>{'IPM_Role_Type__c' => IPM_ConstantUtils.IPM_ROLE_FINANCE, 'IPM_Project_Role_Owner__c' => true};
            IPM_Project_Resource__c projResource = (IPM_Project_Resource__c)IPM_TestFactory.createSObject('IPM_Project_Resource__c',projResourceDataMap,false);
            ipmProjResourceTestList.add(projResource);
        }
    
        if(doInsert) { 
            insert ipmProjResourceTestList;
        }
        return ipmProjResourceTestList;
    }
    
    public static IPM_Project_Resource__c createIPMProjectResource(Id projId, Boolean doInsert) {
        Map<String,Object> projResourceDataMap =  new Map<String,Object>{'IPM_Role_Type__c' => IPM_ConstantUtils.IPM_ROLE_FINANCE, 'IPM_Project_Role_Owner__c' => true};
        if(projId != null) {projResourceDataMap.put('IPM_Project__c', projId);}
        
        IPM_Project_Resource__c projResource = (IPM_Project_Resource__c)IPM_TestFactory.createSObject('IPM_Project_Resource__c',projResourceDataMap,false);
        if(doInsert) { 
            insert projResource;
        }
        return projResource;
    }
    
    public static IPM_Company_Card__c createIPMCompanyCard(Boolean doInsert){
        Map<String,Object> comcardMap =  new Map<String,Object>{'Name'=>'Test Company Card','IPM_Company_Type__c'=>'Global','IPM_Managed_category__c'=>'TestManagedCategory'};
        IPM_Company_Card__c comcard = (IPM_Company_Card__c)IPM_TestFactory.createSObject('IPM_Company_Card__c',comcardMap,false);   
        if(doInsert) { 
            insert comcard;
        }
        return comcard;
    }
    
    public static IPM_Company_Card__c createGlobalCompanyCard(Boolean doInsert){
        Map<String,Object> comcardMap =  new Map<String,Object>{'Name'=>'Test Company Card','IPM_Company_Type__c'=>'Global','IPM_Managed_category__c'=>'TestManagedCategory','recordTypeId' => globalCompanyCardRecId};
        IPM_Company_Card__c comcard = (IPM_Company_Card__c)IPM_TestFactory.createSObject('IPM_Company_Card__c',comcardMap,false);   
        if(doInsert) { 
            insert comcard;
        }
        return comcard;
    }
    
    public static IPM_Company_Card__c createRegionalCompanyCard(Boolean doInsert){
        Map<String,Object> comcardMap =  new Map<String,Object>{'Name'=>'Test Regional Company Card','IPM_Company_Type__c'=>'Global','IPM_Managed_category__c'=>'RegionalManagedCategory','recordTypeId' => regionalCompanyCardRecId};
        IPM_Company_Card__c comcard = (IPM_Company_Card__c)IPM_TestFactory.createSObject('IPM_Company_Card__c',comcardMap,false);   
        if(doInsert) { 
            insert comcard;
        }
        return comcard;
    }
    
    public static IPM_Company_Card__c createLocalCompanyCard(Boolean doInsert){
        Map<String,Object> comcardMap =  new Map<String,Object>{'Name'=>'Test Local Company Card','IPM_Company_Type__c'=>'Local','IPM_Managed_category__c'=>'LocalManagedCategory','recordTypeId' => localCompanyCardRecId};
        IPM_Company_Card__c comcard = (IPM_Company_Card__c)IPM_TestFactory.createSObject('IPM_Company_Card__c',comcardMap,false);   
        if(doInsert) { 
            insert comcard;
        }
        return comcard;
    }
   
    public static IPM_User_Profile__c createUserProfile(Boolean doInsert) {
        Map<String,Object> userProfMap =  new Map<String,Object>{'Name'=>'Test User Profile','IPM_User_Function__c'=>'Project Leader',
                                                'IPM_User_Role__c'=>'BD','IPM_User_Function__c'=>'true','IPM_Central_Team__c'=>'true',
                                                'Export_Porfolio_Data__c'=>'true','IPM_Work_Level__c'=>'WL2+'};
        IPM_User_Profile__c userProf  = (IPM_User_Profile__c)IPM_TestFactory.createSObject('IPM_User_Profile__c',userProfMap,false);    
        if(doInsert) { 
            insert userProf;
        }
        return userProf;
    }
    
    public static List<IPM_User_Profile__c> createUserProfileList(List<ID> userIdList,List<IPM_Company_Card__c> companyCardList,Boolean doInsert ) 
    {
        Map<String,List<Object>> userProfMap =  new Map<String,List<Object>>{
                                                'Name'=> new List<String>(),'IPM_User_Function__c'=> new List<String>(),
                                                'IPM_User_Role__c'=>new List<String>(),'IPM_Company_Card__c'=>new List<Id>(),
                                                'IPM_Central_Team__c'=> new List<Boolean>(),'IPM_Work_Level__c'=> new List<String>(),
                                                'IPM_Region__c' => new List<String>(),'IPM_User__c' => new List<Id>()};
                                                
        for(Integer counter=0;counter < userIdList.size();counter++)
        {
            userProfMap.get('Name').add(companyCardList.get(counter).Name);
            userProfMap.get('IPM_User__c').add(userIdList.get(counter));
            userProfMap.get('IPM_Company_Card__c').add(companyCardList.get(counter).Id);    
            userProfMap.get('IPM_User_Function__c').add('Project Leader');
            userProfMap.get('IPM_User_Role__c').add('BD');
            userProfMap.get('IPM_Central_Team__c').add(true);
            userProfMap.get('IPM_Work_Level__c').add('WL2+');
            userProfMap.get('IPM_Region__c').add('South Asia');
            
        }                                        
        
        System.debug('userProfMap-->>'+userProfMap);
        List<IPM_User_Profile__c> userProfList = (List<IPM_User_Profile__c>)IPM_TestFactory.createSObjectList('IPM_User_Profile__c',userProfMap,false);
        
        if(doInsert) { 
            insert userProfList;
        }
        return userProfList;
    }
    
    
    public static List<MDO_Geography__c> createGeographyList(Boolean doInsert, Integer listSize) {
        
        List<MDO_Geography__c> mdmGeographyTestList = new List<MDO_Geography__c>();
        
        MDO_Geography__c goegraphiesCluster = new MDO_Geography__c();
        goegraphiesCluster.Name = 'AsiaParent';
        goegraphiesCluster.parent_L2__c =goegraphiesCluster.id;
        goegraphiesCluster.geography_type__c = 'Unilever Cluster';
        goegraphiesCluster.Status__c = 'Active';
        goegraphiesCluster.ISO_3166_1_Code__c = 'G1';
        goegraphiesCluster.name_united_nations__c = 'G1';
        mdmGeographyTestList.add(goegraphiesCluster);
       
        MDO_Geography__c goegraphiesMCO = new MDO_Geography__c();
        goegraphiesMCO.Name = 'Asia';
        goegraphiesMCO.parent_L2__c =goegraphiesCluster.id;
        goegraphiesMCO.geography_type__c = 'Country Group';
        goegraphiesMCO.Status__c = 'Active';
        goegraphiesMCO.ISO_3166_1_Code__c = 'G2';
        goegraphiesMCO.name_united_nations__c = 'G2';
        mdmGeographyTestList.add(goegraphiesMCO);
        
        MDO_Geography__c goegraphiesCountry = new MDO_Geography__c();
        goegraphiesCountry.Name = 'India';
        goegraphiesCountry.parent_L2__c =goegraphiesMCO.id;
        goegraphiesCountry.geography_type__c = 'Country';
        goegraphiesCountry.Status__c = 'Active';
        goegraphiesCountry.ISO_3166_1_Code__c = 'G3';
        goegraphiesCountry.name_united_nations__c = 'G3';
        mdmGeographyTestList.add(goegraphiesCountry);
        
       /* for(Integer i = 0; i < listSize; i++){
            Map<String,Object> geoMap =  new Map<String,Object>{'Name'=>'Test Geography' + i};
            MDO_Geography__c geo  = (MDO_Geography__c)IPM_TestFactory.createSObject('mdm_Geography__c',geoMap,false);   
            mdmGeographyTestList.add(geo);
        }*/
           
        //if(doInsert) { 
            insert mdmGeographyTestList;
      //  }
        return mdmGeographyTestList;
    }
    
     public static List<mdo_Geography__c> createMDOGeographyList(Boolean doInsert, Integer listSize) {
        
        List<MDO_Geography__c> mdoGeographyTestList = new List<MDO_Geography__c>();
        for(Integer i = 0; i < listSize; i++){
            Map<String,Object> geoMap =  new Map<String,Object>{'Name'=>'Test Geography' + i};
            MDO_Geography__c geo  = (MDO_Geography__c)IPM_TestFactory.createSObject('MDO_Geography__c',geoMap,false);   
            mdoGeographyTestList.add(geo);
        }
           
        if(doInsert) { 
            insert mdoGeographyTestList;
        }
        return mdoGeographyTestList;
    }
   
       
    public static mdm_Geography__c createGeography(Boolean doInsert) {
        Map<String,Object> geoMap =  new Map<String,Object>{'Name'=>'Test Geography'};
        mdm_Geography__c geo  = (mdm_Geography__c)IPM_TestFactory.createSObject('mdm_Geography__c',geoMap,false);   
        if(doInsert) { 
            insert geo;
        }
        return geo;
    }
    
    public static List<IPM_Country__c> createIPMCountryList(Boolean doInsert, Integer listSize) {
        
        List<IPM_Country__c> IPMCountryTestList = new List<IPM_Country__c>();
        for(Integer i = 0; i < listSize; i++){
            Map<String,Object> countryMap =  new Map<String,Object>{'Name'=>'Test Country'};
            IPM_Country__c country  = (IPM_Country__c)IPM_TestFactory.createSObject('IPM_Country__c',countryMap,false);
            IPMCountryTestList.add(country);
        } 
        if(doInsert) { 
            insert IPMCountryTestList;
        }
        return IPMCountryTestList;
    }
    
    public static IPM_Country__c createIPMCountry(Boolean doInsert) {
        Map<String,Object> countryMap =  new Map<String,Object>{'Name'=>'Test Country'};
        IPM_Country__c country  = (IPM_Country__c)IPM_TestFactory.createSObject('IPM_Country__c',countryMap,false); 
        if(doInsert) { 
            insert country;
        }
        return country;
    }
    
    public static mdm_CU_Sales_SKU_Count_Mapping__c createCU_SalesSKU_CountMapping(Boolean doInsert) {
        Map<String,Object> cuSalesSKUCntMappingMap =  new Map<String,Object>{'Name'=>'NameCU','Country__c'=>'Test Country1','CU_Volume__c'=>2343};
        mdm_CU_Sales_SKU_Count_Mapping__c cuSalesSKUCntMapping  = (mdm_CU_Sales_SKU_Count_Mapping__c)IPM_TestFactory.createSObject('mdm_CU_Sales_SKU_Count_Mapping__c',cuSalesSKUCntMappingMap,false);  
        if(doInsert) { 
            insert cuSalesSKUCntMapping;
        }
        return cuSalesSKUCntMapping;
    }
    public static IPM_Financial_Year__c createIPMFinancialYear(Boolean doInsert) {
        Map<String,Object> IPMFinancialYearMap =  new Map<String,Object>{'Name'=>'Y0',
                                                        'Year__c'=>'0','Year_Type__c'=>'Innovation'};
        IPM_Financial_Year__c financialYear  = (IPM_Financial_Year__c)IPM_TestFactory.createSObject('IPM_Financial_Year__c',IPMFinancialYearMap,false); 
        if(doInsert) { 
            insert financialYear;
        }
        return financialYear;
    }
    
    public static List<IPM_ProjectMetadata__c> createIPMProjectMetadata(){
        return Test.loadData(IPM_ProjectMetadata__c.sObjectType, 'IPM_Project_Metadata');   
    }  
    
    public static IPM_CoreParameter_Strategic_help_content__c createIPMCoreParameterStrategicHelpContent(Boolean doInsert) {
        Map<String,Object> IPMCoreParameterStrategicHelpContentMap =  new Map<String,Object>{'Name'=>'IPM CoreParameter Strategic text',
                                                        'IPM_BLG__c'=>'Activity which does not involve a physical change to the product or pack but builds penetration and/or consumption of the current range usually via an activation activity. ...we know our growth is not only dependent on physical product launches and we mus',
                                                        'IPM_Innovation__c'=>'A physical change to the product or pack that brings new consumer benefits and/or significant improvements in performance and claim strength utilizing technology that does not already exist in the market. ...true innovation is not commonplace approximatel',
                                                        'IPM_Renovation__c'=>'A physical change to the product or pack that is perceived as a variation to an existing offering in the market and uses technology that already exists in the market. ...the majority of our projects are renovation as we are always improving our product an'};
        IPM_CoreParameter_Strategic_help_content__c IPMCoreParameterStrategicHelpContent  = (IPM_CoreParameter_Strategic_help_content__c)IPM_TestFactory.createSObject('IPM_CoreParameter_Strategic_help_content__c',IPMCoreParameterStrategicHelpContentMap,false);    
        if(doInsert) { 
            insert IPMCoreParameterStrategicHelpContent;
        }
        return IPMCoreParameterStrategicHelpContent;
    }
    public static IPM_Questionnaire__c createIPMQuestionnaire(Id projId, Boolean doInsert) {
        Map<String,Object> IPMQuestionnaireMap =  new Map<String,Object>{'IPM_HelpText_Yes__c'=>'Less',
                                                        'IPM_HelpText_No__c'=>'3',
                                                        'IPM_HelpText_Partly__c'=>'4',
                                                        'IPM_Question__c'=>'Investment Risk'};
        if(projId != null) {IPMQuestionnaireMap.put('IPM_Project__c', projId);}
        IPM_Questionnaire__c IPMQuestionnaire  = (IPM_Questionnaire__c)IPM_TestFactory.createSObject('IPM_Questionnaire__c',IPMQuestionnaireMap,false); 
        if(doInsert) { 
            insert IPMQuestionnaire;
        }
        return IPMQuestionnaire;
    }
    
    public static List<IPM_Questionnaire__c> createIPMQuestionnaireList(Id projId,Boolean doInsert){
        List<IPM_Questionnaire__c> IPMQuestionnaireList=new List<IPM_Questionnaire__c>();
        if(!String.isBlank(projId)){
            Map<String,List<Object>> IPMQuestionnaireMap =  new Map<String,List<Object>>{
                'RecordTypeId'=>new List<Object>{Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.POS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId,Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.POS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId,Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RQS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId},
                'IPM_POS_Question_Type__c'=>new List<Object>{QUESTIONTYPE_STR, QUESTIONTYPE_STR,QUESTIONTYPE_STR},  
                'IPM_Sequence_Number__c'=>new List<Object>{1,2,3},
                'IPM_Question__c'=>new List<Object>{'Test POS Question1','Test POS Question2','Test RQS Question'},
                'IPM_HelpText_Yes__c'=>new List<Object>{'Help Text Yes','Help Text Yes','Help Text Yes'},
                'IPM_HelpText_No__c'=>new List<Object>{'help Text No','help Text No','help Text No'},
                'Is_Master__c'=>new List<Object>{true,true,true},
                'IPM_HelpText_Partly__c'=>new List<Object>{'help text partly','help text partly','help text partly'},
                'IPM_Project__c'=>new List<Object>{EMPTY_STRING,EMPTY_STRING,EMPTY_STRING},
                'IPM_Show_Create_Link__c'=>new List<Object>{null,'true',null}, 
                'IPM_RQS_Gate_Type__c'=>new List<Object>{EMPTY_STRING,EMPTY_STRING,'Charter'},
                'IPM_HelpText_Five__c'=>new List<Object>{EMPTY_STRING,EMPTY_STRING,'One more'}
            };
            
            IPMQuestionnaireList=(List<IPM_Questionnaire__c>)IPM_TestFactory.createSObjectList('IPM_Questionnaire__c',IPMQuestionnaireMap,false);
            System.debug('IPMQuestionnaireList-->>>'+IPMQuestionnaireList);
            if(doInsert) { 
                insert IPMQuestionnaireList;
            }
        }
        return IPMQuestionnaireList;    
    }
    
    public static IPM_Financial_File__c createIPMFinancialFile(Id projId, Boolean doInsert){
        Map<String,Object> IPMFinancialFileMap =  new Map<String,Object>{'Name'=>'ABCDEF.xlsx'};
        if(projId != null) {IPMFinancialFileMap.put('IPM_Project__c', projId);}
        IPM_Financial_File__c IPMIPMFinancialFile  = (IPM_Financial_File__c)IPM_TestFactory.createSObject('IPM_Financial_File__c',IPMFinancialFileMap,false);   
        if(doInsert) { 
            insert IPMIPMFinancialFile;
        }
        return IPMIPMFinancialFile;
    }
    public static IPM_Gate_CMI__c createGateCMI(Id projId, Boolean doInsert){
        Map<String,Object> GateCMIMap =  new Map<String,Object>{'Test__c'=>'Test', 'KPI__c'=>'testkpi', 'Gate__c'=>'Contract'};
        if(projId != null) {GateCMIMap.put('IPM_Project__c', projId);}
        IPM_Gate_CMI__c GateCMI  = (IPM_Gate_CMI__c)IPM_TestFactory.createSObject('IPM_Gate_CMI__c',GateCMIMap,false);  
        if(doInsert) { 
            insert GateCMI;
        }
        return GateCMI;
    }
    
    public static IPM_Gate_CMI_KPI_Inputs__c createGateCMIKPIInputs(Boolean doInsert){
        Map<String,Object> GateCMIKPIInputsMap =  new Map<String,Object>{'Name'=>'settings1','IPM_Test__c'=>'Test', 'IPM_KPI__c'=>'testkpi', 'IPM_Inputs__c'=>'Test Input1,Test Input2'};
        
        IPM_Gate_CMI_KPI_Inputs__c GateCMIKPIInputs  = (IPM_Gate_CMI_KPI_Inputs__c)IPM_TestFactory.createSObject('IPM_Gate_CMI_KPI_Inputs__c',GateCMIKPIInputsMap,false);   
        if(doInsert) { 
            insert GateCMIKPIInputs;
        }
        return GateCMIKPIInputs;
    }
    
    public static IPM_CorePara_helps_example__c createCoreParamHelpExapmle(Boolean doInsert){
        Map<String,Object> coreParamHelpExapmleMap =  new Map<String,Object>{'IPM_Answer__c'=>'ImprovementTest','IPM_Core_Parameter_Helps__c'=>'Test', 'IPM_Core_Parameter_Help__c'=>'testkpi'};
        
        IPM_CorePara_helps_example__c coreParamHelpExapmle  = (IPM_CorePara_helps_example__c)IPM_TestFactory.createSObject('IPM_CorePara_helps_example__c',coreParamHelpExapmleMap,false);   
        if(doInsert) { 
            insert coreParamHelpExapmle;
        }
        return coreParamHelpExapmle;
        
    }
     /******************************************************
    * @description: to create IPM Projects
    * @param1 - bosscard: Id of the bosscard
    * @return : Created list of all projects
    */
    public static List<IPM_Project__c> createIPMProjects(Id bosscard){
       
       //retreive all the projects with full & lite complexities
       List<IPM_Project__c > listOfIpmProjects= [SELECT IPM_Complexity__c 
                                                 FROM IPM_Project__c 
                                                 WHERE IPM_Complexity__c ='Full' OR IPM_Complexity__c ='Lite'];
       List<IPM_Project__c> ipmProjects = new List<IPM_Project__c>();
       if(listOfIpmProjects!=null && listOfIpmProjects.isEmpty()){
           IPM_Project__c ipmProject = IPM_TestFactory_Helper.createIPMProject(false);
           if(bosscard !=  null){
               ipmProject.IPM_Bosscard__c = bosscard;
           }
           ipmProject.IPM_Project_Name__c ='test1';
           ipmProjects.add(ipmProject);
           ipmProject = new IPM_Project__c();
           ipmProjects.add(ipmProject);
           insert ipmProjects;
       } else{
           ipmProjects = listOfIpmProjects;  
           
       }
       return ipmProjects;
    }
    
    public static List<IPM_CoreParameter__c> createIPMCoreParameterCustomSettings() {
       List<IPM_CoreParameter__c> listIPMCoreParameterCustomSettings = new List<IPM_CoreParameter__c>();
       IPM_CoreParameter__c CP1 = new IPM_CoreParameter__c(Name='Question one', Q1__c= 'Launch New Brand', Q2__c='Brand Migration', Q3__c='Brand Extention', Q4__c='New Format', Q5__c='New Platform', Q6__c=NEWVARIANTSIZE_STR, Q7__c=COREPARAMETER_GROWTHECORE, Q8__c=COREPARAMETER_NEWSCHANNEL, Q9__c=COREPARAMETER_BLG, Q10__c=COREPARAMETER_VIP, Q11__c=COREPARAMETER_TECHNOLOGYDEV, Q12__c=COREPARAMETER_SUPPLYCHAIN, Q13__c=COREPARAMETER_REGULATORY, Q14__c='Other',Question__c='Please categorize project in one of the following areas in order to define Market Place Activity');  
       IPM_CoreParameter__c CP2 = new IPM_CoreParameter__c(Name='Question two', Q1__c= 'New Core Product', Q2__c='New Benefit', Q3__c='Improvement', Q4__c='Variant', Q5__c='No Change', Q6__c=NEWVARIANTSIZE_STR, Q7__c=COREPARAMETER_GROWTHECORE, Q8__c=COREPARAMETER_NEWSCHANNEL, Q9__c=COREPARAMETER_BLG, Q10__c=COREPARAMETER_VIP, Q11__c=COREPARAMETER_TECHNOLOGYDEV, Q12__c=COREPARAMETER_SUPPLYCHAIN, Q13__c=COREPARAMETER_REGULATORY, Q14__c='Other',Question__c='Let’s define the extent of impact on the consumers perceived value from this project');  
       IPM_CoreParameter__c CP3 = new IPM_CoreParameter__c(Name='Question three', Q1__c= 'Radical', Q2__c='Next Generation', Q3__c='Incremental', Q4__c='Base', Q5__c='No Change', Q6__c=NEWVARIANTSIZE_STR, Q7__c=COREPARAMETER_GROWTHECORE, Q8__c=COREPARAMETER_NEWSCHANNEL, Q9__c=COREPARAMETER_BLG, Q10__c=COREPARAMETER_VIP, Q11__c=COREPARAMETER_TECHNOLOGYDEV, Q12__c=COREPARAMETER_SUPPLYCHAIN, Q13__c=COREPARAMETER_REGULATORY, Q14__c='Other',Question__c='How would you like to qualify the technology change brought in by this project?');  
       IPM_CoreParameter__c CP4 = new IPM_CoreParameter__c(Name='Strategic Intent', Q1__c= 'Ideas', Q2__c='Feasibility', Q3__c='Capability',Q4__c='Base', Q5__c='No Change', Q6__c=NEWVARIANTSIZE_STR, Q7__c=COREPARAMETER_GROWTHECORE, Q8__c=COREPARAMETER_NEWSCHANNEL, Q9__c=COREPARAMETER_BLG, Q10__c=COREPARAMETER_VIP, Q11__c=COREPARAMETER_TECHNOLOGYDEV, Q12__c=COREPARAMETER_SUPPLYCHAIN, Q13__c=COREPARAMETER_REGULATORY,Question__c='Please specify the phase in which you would like to initiate the project?');  
       listIPMCoreParameterCustomSettings.add(CP1);
       listIPMCoreParameterCustomSettings.add(CP2);
       listIPMCoreParameterCustomSettings.add(CP3);
       listIPMCoreParameterCustomSettings.add(CP4);
        
        insert listIPMCoreParameterCustomSettings;
        return listIPMCoreParameterCustomSettings;
   } 
   
   public static IPM_OTIF_Status__c createIPMOTIFStatus(Boolean doInsert){
        Map<String,Object> IPMOTIFStatusMap =  new Map<String,Object>{'Name'=>'Contract Attractive Business'};
        
        IPM_OTIF_Status__c IPMOTIFStatus  = (IPM_OTIF_Status__c)IPM_TestFactory.createSObject('IPM_OTIF_Status__c',IPMOTIFStatusMap,false); 
        if(doInsert) { 
            insert IPMOTIFStatus;
        }
        return IPMOTIFStatus;
    }
    public static List<IPM_POS_RQS_Mapping__c> createPOS_RQSMapping(Boolean doInsert){
        List<IPM_POS_RQS_Mapping__c> ipmPosRqsMappingCustomSettingList = new List<IPM_POS_RQS_Mapping__c>();
        IPM_POS_RQS_Mapping__c prm1 = new IPM_POS_RQS_Mapping__c(Name='Brand',Score__c=3);
        ipmPosRqsMappingCustomSettingList.add(prm1);
        if(doInsert) { 
            insert ipmPosRqsMappingCustomSettingList;
        }
        return ipmPosRqsMappingCustomSettingList;
    }
    
    /************************Creation Of Share Objects**************************/
    
    //Create generic share object record
    public static SObject createShareObject (String ObjectName){ //IPM_Project_Rollout__c.id,psa.assigneeId,falseorTrue
        Map<String,Object> ShareMap =  new Map<String,Object>{'accesslevel'=> IPM_ConstantUtils.ACCESS_EDIT};
        
        SObject Share  = IPM_TestFactory.createSObject(ObjectName,ShareMap,false);  
    
        return Share;
    }
    //Create mdo Geography object record
    public static mdo_Geography__c createMDOGeography(Boolean doInsert) {
        Map<String,Object> geoMap =  new Map<String,Object>{'Name'=>'Test Geography'};
        mdo_Geography__c geo  = (mdo_Geography__c)IPM_TestFactory.createSObject('mdo_Geography__c',geoMap,false);   
        if(doInsert) { 
            insert geo;
        }
        return geo;
    }
    
    //Create mdo product category object record
    public static MDO_Category__c createMDOCategory(Boolean doInsert) {
        Map<String,Object> catMap =  new Map<String,Object>{'Name'=>'Test Categoty','geography_type__c'=>'Cluster'};
        MDO_Category__c categoryR  = (MDO_Category__c)IPM_TestFactory.createSObject('MDO_Category__c',CatMap,false);   
        if(doInsert) { 
            insert categoryR;
        }
        return categoryR;
    }
    //Create mdo Brand Positioning object record
    public static MDO_BrandPosition__c createMDOBrandPosition(Boolean doInsert) {
        Map<String,Object> BrandPMap =  new Map<String,Object>{'Name'=>'Test Brand P','status'=>'active'};
        MDO_BrandPosition__c BrandP  = (MDO_BrandPosition__c)IPM_TestFactory.createSObject('MDO_BrandPosition__c',BrandPMap,false);   
        if(doInsert) { 
            insert BrandP;
        }
        return BrandP;
    }
    
    //Create mdm Brand Positioning object record
    public static mdm_Brand_Position__c createMDMBrandPosition(Boolean doInsert) {
        Map<String,Object> BrandPMap =  new Map<String,Object>{'Name'=>'Test Brand P','status'=>'active','Category_Name__c'=>'Laundry'};
        mdm_Brand_Position__c BrandP  = (mdm_Brand_Position__c)IPM_TestFactory.createSObject('mdm_Brand_Position__c',BrandPMap,false);   
        if(doInsert) { 
            insert BrandP;
        }
        return BrandP;
    }
    //Create mdm Brand Positioning object record
    public static mdm_Product_Category__c createMDMCategory(Boolean doInsert) {
        Map<String,Object> BrandPMap =  new Map<String,Object>{'Name'=>'Test Brand P','L2_Product_Category__c'=>'Household Care','L5_Product_Category__c'=>'Dishwash'};
        mdm_Product_Category__c BrandP  = (mdm_Product_Category__c)IPM_TestFactory.createSObject('mdm_Product_Category__c',BrandPMap,false);   
        if(doInsert) { 
            insert BrandP;
        }
        return BrandP;
    }
    
    //Create mdm Brand Positioning object record
    public static  List<mdm_Brand_Position__c> createMDMBrandPositionList(Boolean doInsert) 
    {
        
         Map<String,List<Object>> MDMBrandPosMap = new Map<String,List<Object>>{
        'Name' => new List<String>{'TestBrand1','TestBrand2','TestBrand3'},
        'status'=>new List<String>{'active','active','active'},
        'Brand_Position_Name__c'=>new List<String>{'BP1','BP2','BP3'},
        'Category_Name__c' => new List<String>{'TestManagedCategory','RegionalManagedCategory','LocalManagedCategory'}
        };
        
        
        List<mdm_Brand_Position__c> brandPositionList = (List<mdm_Brand_Position__c>)IPM_TestFactory.createSObjectList('mdm_Brand_Position__c',MDMBrandPosMap,false);
            
        if(doInsert) { 
            insert brandPositionList;
        }
        return brandPositionList;
    }
    
    //Create mdo Brand Positions object record    
    public static MDO_BrandPositions__c createMDOBrandPositions(Boolean doInsert) {
        Map<String,Object> BrandPMap =  new Map<String,Object>{'Name'=>'Test Brand Postions','status'=>'active'};
        MDO_BrandPositions__c BrandP  = (MDO_BrandPositions__c)IPM_TestFactory.createSObject('MDO_BrandPositions__c',BrandPMap,false);   
        if(doInsert) { 
            insert BrandP;
        }
        return BrandP; 
    }
    public static IPM_Market_Cluster_Short_Names__c createMarketshortName(Boolean doInsert){
       Map<String,Object> clusterMap =  new Map<String,Object>{'Name'=>'SAS','Unilever_Cluster__c'=>'South Asia','Short_Name__c'=>'SAS'};
        IPM_Market_Cluster_Short_Names__c mCluster  = (IPM_Market_Cluster_Short_Names__c)IPM_TestFactory.createSObject('IPM_Market_Cluster_Short_Names__c',clusterMap,false);   
        if(doInsert) { 
            insert mCluster;
        }
        return mCluster; 
        
    }
   
    public static IPM_MCO_Short_Names__c createMCOshortName(Boolean doInsert){
       Map<String,Object> mcoMap =  new Map<String,Object>{'Name'=>'OSA','Country_Group__c'=>'Other South Asia','Short_Name__c'=>'OSA'};
        IPM_MCO_Short_Names__c mco  = (IPM_MCO_Short_Names__c)IPM_TestFactory.createSObject('IPM_MCO_Short_Names__c',mcoMap,false);   
        if(doInsert) { 
            insert mco;
        }
        return mco; 
        
    }
    
    public static uw_BET__c getTestBet(){
        uw_Brand__c brand = new uw_Brand__c(Name = 'Test Brand',StylePalette__c = 'toolkit-theme-light');
        insert brand;
        
        uw_Inoplan_Project__c inopProject = new uw_Inoplan_Project__c(name = 'No Inoplan Project' + Math.random());
        insert inopProject;
              
        uw_BET__c bet = new uw_BET__c(uw_Brand__c = brand.id,Status__c = 'First release',Inoplan_Project__c = inopProject.id,Name = 'TestBET');
        return bet;
    }
    
    public static List<IPM_Project_Template__c> projectTemplateList{get;set;}
    public static List<IPM_Document_Template__c> documentTemplateList{get;set;}
    public static List<IPM_Task__c> taskTemplateList{get;set;}
    public static List<IPM_Section__c> sectionTemplateList{get;set;}
    public static List<IPM_Milestone__c> milestoneTemplateList{get;set;}
    public static List<IPM_Questionnaire__c> questionnaireTemplateList{get;set;}
    public static List<IPM_ProjectMetadata__c> projectMetadataList{get;set;}
    public static List<IPM_Project_Type__c> projectTypeList{get;set;}
    public static List<MDM_Geography__c> mdmGeoList {get;set;}
    public static List<IPM_Gate_CMI_KPI_Inputs__c> cmiGateKPIInputList {get;set;}
    public static List<IPM_CMI_Color_Mapping__c> cmiColorCodes {get;set;}
    
    public static void getProjectMasterData()
    {
        Map<String,List<Object>> projectTemplateMap = new Map<String,List<Object>>
        { 'IPM_Category__c'=> new List<String>{'HHC','HHC'},
          'IPM_Template_Complexity__c' => new List<String>{'Full','Lite'},
          'IPM_Template_Name__c' => new List<String>{'HHC-FULL','HHC-Lite'},
          'IPM_Project_Type__c' => new List<String>{'Original','Original'}
        };
        
        projectTemplateList = (List<IPM_Project_Template__c>)IPM_TestFactory.createSObjectList('IPM_Project_Template__c',projectTemplateMap,false);  
        
        System.debug('projectTemplateList--->>'+projectTemplateList[0].Id);
        System.debug('projectTemplateList--->>'+projectTemplateList[1].Id);
        
        insert projectTemplateList;
        
        Map<String,List<Object>> documentTemplateMap = new Map<String,List<Object>>
        { 'IPM_Document_Order__c'=> new List<String>{'1.0','2.0','3.0','4.0','1.0','2.0','3.0','4.0'},
          'IPM_Document_Template_Name__c' => new List<String>{'Charter Gate Full','Contract Gate Full','Market Ready Gate Full','Market Deployment Gate Full','Charter Gate Lite','Contract Gate Lite','Market Ready Gate Lite','Market Deployment Gate Lite'},
          'IPM_Document_Type__c' => new List<String>{'Charter','Contract','Market Ready','Market Deployment','Charter','Contract','Market Ready','Market Deployment'},
          'IPM_Project_Template__c' => new List<Id>{projectTemplateList[0].Id,projectTemplateList[0].Id,projectTemplateList[0].Id,projectTemplateList[0].Id,projectTemplateList[1].Id,projectTemplateList[1].Id,projectTemplateList[1].Id,projectTemplateList[1].Id}  
        };
        
        documentTemplateList = (List<IPM_Document_Template__c>)IPM_TestFactory.createSObjectList('IPM_Document_Template__c',documentTemplateMap,false);
        
        insert documentTemplateList;
        
        
        Map<String,List<Object>> taskMasterMap = new Map<String,List<Object>>
        { 'IPM_Function__c' => new List<String>{'BB','R&D','SC','CD','CMI','Finance','BB','R&D'},
          'IPM_Phase__c' => new List<String>{'Ideas','Feasibility','Capability','Market Ready','Ideas','Feasibility','Capability','Market Ready'},
          'IPM_Project_Template__c' => new List<Id>{projectTemplateList[0].Id,projectTemplateList[0].Id,projectTemplateList[0].Id,projectTemplateList[0].Id,projectTemplateList[1].Id,projectTemplateList[1].Id,projectTemplateList[1].Id,projectTemplateList[1].Id},
          'IPM_Task_Complexity__c' => new List<String>{'Full','Full','Full','Full','Lite','Lite','Lite','Lite'},
          'IPM_Task_Name__c' =>new List<String>{'Develop and lock concept','Develop packaging brief ','Action customer feedback','Full stock building','Identify target audience','Ensure Customer appeal is clear','Factory commissioning','Respond to questions from BB to any open ends'},
          'IPM_Task_Type__c' => new List<String>{'Non-Negotiable','Non-Negotiable','Non-Negotiable','Non-Negotiable','Negotiable','Negotiable','Negotiable','Negotiable'},
          'IPM_Type_of_Gate__c' =>new List<String>{'Charter','Contract','Market Ready','Market Deployment','Charter','Contract','Market Ready','Market Deployment'},
          'Name' => new List<String>{'Develop and lock concept','Develop packaging brief ','Action customer feedback','Full stock building','Identify target audience','Ensure Customer appeal is clear','Factory commissioning','Respond to questions from BB to any open ends'},
          'recordTypeId' => new List<Id>{taskMasterRecordType,taskMasterRecordType,taskMasterRecordType,taskMasterRecordType,taskMasterRecordType,taskMasterRecordType,taskMasterRecordType,taskMasterRecordType}
        };
        
        taskTemplateList = (List<IPM_Task__c>)IPM_TestFactory.createSObjectList('IPM_Task__c',taskMasterMap,false);
        
        insert taskTemplateList;
        
        List<IPM_Task__c> masterTasks = [Select Id,IPM_Phase__c,IPM_Project_Template__c,IPM_Task_Complexity__c,IPM_Task_Name__c from IPM_Task__c where recordTypeId =:taskMasterRecordType AND IPM_Project_Template__c in :projectTemplateList];
        
        Map<String,List<IPM_Task__c>> phaseToTaskList = new Map<String,List<IPM_Task__c>>();
        Map<String,List<IPM_Task__c>> complexityToTaskList = new Map<String,List<IPM_Task__c>>();
        for(IPM_Task__c task : masterTasks)
        {
            List<IPM_Task__c> taskList = new List<IPM_Task__c>();
             
            if(phaseToTaskList.containsKey(task.IPM_Phase__c))
            {
                taskList = phaseToTaskList.get(task.IPM_Phase__c);  
            }
            taskList.add(task);
            phaseToTaskList.put(task.IPM_Phase__c,taskList);
            
            List<IPM_Task__c> ctaskList = new List<IPM_Task__c>();
             
            if(complexityToTaskList.containsKey(task.IPM_Task_Complexity__c))
            {
                ctaskList = complexityToTaskList.get(task.IPM_Task_Complexity__c);  
            }
            ctaskList.add(task);
            complexityToTaskList.put(task.IPM_Task_Complexity__c,ctaskList);
        }
        
        System.assertEquals(phaseToTaskList.get('Ideas').size(), 2);
        System.assertEquals(complexityToTaskList.get('Full').size(), 4);
        Map<String,String> sectionTypeMap = new Map<String,String>{'1'=>'Header','2'=>'Header','3'=>'Header','4'=>'Header','5'=>'Header','6'=>'Header','7'=>'Header',
            '8'=>'Header','1.2'=>'Sub Header','2.2'=>'Sub Header','3.1'=>'Sub Header','3.2'=>'Sub Header','3.3'=>'Sub Header','3.4'=>'Sub Header',
            '4.2'=>'Sub Header','6.2'=>'Sub Header','1.1'=>'Text','1.2'=>'Text','1.3'=>'Text','2.1'=>'Text','3.2'=>'Text','3.4'=>'Text','3.5'=>'Text',
            '5.1'=>'Text','5.2'=>'Text','6.2'=>'Text','7.1'=>'Text','7.2'=>'Text','7.3'=>'Text','7.4'=>'Text','8.1'=>'Text','8.2'=>'Text','8.3'=>'Text',
            '8.4'=>'Text','8.5'=>'Text','8.6'=>'Text','8.7'=>'Text','1.2.1'=>'Text','1.2.2'=>'Text','2.2.2'=>'Text','3.1.1'=>'Text','3.1.2'=>'Text',
            '3.1.3'=>'Text','3.1.5'=>'Text','3.2.2'=>'Text','3.3.2'=>'Text','3.4.1'=>'Text','3.4.2'=>'Text','4.2.1'=>'Text','4.2.2'=>'Text','4.2.3'=>'Text',
            '2.2'=>'Static Table','4.1'=>'Static Table','5.3'=>'Static Table','6.3'=>'Static Table','7.1'=>'Static Table','7.2'=>'Static Table',
            '7.3'=>'Static Table','6.2.1'=>'Static Table','3.3'=>'Dynamic Complex Table','6.1'=>'Dynamic Complex Table','6.3'=>'Dynamic Complex Table',
            '6.2.2'=>'Dynamic Complex Table'};
        
        List<String> functionalGroup = new List<String>{'BD','PL','BB','CD','CMI','R&D','SC','Finance','RnD'};
        List<String> SequenceList = new List<String>{'1','1.1','1.2','1.2','1.3','1.3','1.3','1.3','1.4',
                '2','2.1','2.1','2.2','2.2','3','3.1','3.2','3.2','3.2','3.3','3.3','3.4','3.4','3.5','4','4.1','4.2','4.2',
                '5','5','5.1','5.1','5.1','5.2','5.2','5.2','5.3','6','6.1','6.2','6.2','6.2','6.3','6.3','7','7.1','7.1','7.2','7.2','7.3','7.3','7.3','7.4'};
        
        Map<String,String> sectionNameMap = new Map<String,String>{'1'=>'Introduction','1.1'=>'Idea / Graphic','1.2'=>'Feedback from Last Gate','1.2'=>'Justification','1.3'=>'Key Changes since Contract Gate','1.3'=>'Feedback from BOSSCARD','1.3'=>'Key Issues Needing Focus in Gate Meeting','1.3'=>'Key Changes since Market Ready Gate','1.4'=>'Gate Keeper Checklist','2'=>'External','2.1'=>'Competitors','2.1'=>'Competitors','2.2'=>'Customers','2.2'=>'Customers/Channels','3'=>'Mix','3.1'=>'Proposition','3.2'=>'Pack','3.2'=>'Product','3.2'=>'Pack','3.3'=>'Product','3.3'=>'Mix Qualification Plan and Action Standards (Table)','3.4'=>'Price','3.4'=>'Degree of Commonality','3.5'=>'Full Mix','4'=>'Deployment','4.1'=>'Promotion Guidance for Deployment - PRELIMINARY','4.2'=>'Place Guidance for Deployment','4.2'=>'Place','5'=>'Technical','5'=>'Technical','5.1'=>'R&D Technical  Readiness','5.1'=>'R&D Initial Outline (Product/Pack)','5.1'=>'R&D Feasibility','5.2'=>'Supply Chain Technical  Readiness','5.2'=>'Supply Chain Initial Outline','5.2'=>'Supply Chain Feasibility','5.3'=>'Environmental Impact','6'=>'Financial','6.1'=>'Business Case vs. Action Standards','6.2'=>'Assumptions, Risks, Sensitivities','6.2'=>'Initial Estimate of Opportunity','6.2'=>'Business Waste','6.3'=>'BD/BB Alignment','6.3'=>'Monitoring Performance in Market','7'=>'Project Management','7.1'=>'Rollout Plans','7.1'=>'Risk','7.2'=>'Country Feedback & Requirements','7.2'=>'Milestones','7.3'=>'Regional BD Team FB & Reqs','7.3'=>'Regional BD Team Feedback to Global','7.3'=>'OTIF','7.4'=>'Human Resources','8'=>'Appendix','8.1'=>'BD/BB Alignment','8.1'=>'CUs and Complexity','8.1'=>'Customers / Channels','8.1'=>'Milestones','8.2'=>'Rollout Plans','8.2'=>'Consumer Evidence - Concept','8.2'=>'Assortment Strategy','8.3'=>'Monitoring Performance in Market','8.4'=>'Mix Qualification Plan and Action Standards (Table)','8.5'=>'Environmental Impact','8.6'=>'Pack/Graphics','8.6'=>'Initial Estimate of Opportunity','8.7'=>'Risk','8.7'=>'Regional BD Team FB & Reqs','1.2.1'=>'Consumer Need','1.2.1'=>'Fit with National Category Building Plan (NCBP)','1.2.2'=>'Strategic Fit','1.2.2'=>'Fit with BMP Jobs to be Done','2.2.2'=>'Trade Story','3.1.1'=>'Target Audience','3.1.2'=>'Concept','3.1.3'=>'Consumer Evidence - Concept','3.1.3'=>'Communication','3.1.5'=>'Consumer Evidence - Communication','3.1.5'=>'Trademarks','3.2.1'=>'CUs and Complexity','3.2.2'=>'Consumer Evidence - Pack','3.3.2'=>'Consumer Evidence - Product','3.4.1'=>'Proposed Pricing','3.4.2'=>'Consumer Evidence - Price','3.4.2'=>'Other Price Rationale (beyond consumer evidence shown in 3.5 below)','4.2.1'=>'Assortment Strategy','4.2.2'=>'Merchandising Strategy','4.2.3'=>'Trade Promotion Strategy','6.2.1'=>'Assumptions','6.2.2'=>'Sensitivity Analysis'};
        Map<String,String> sectionExternalIDMap = new Map<String,String>{'1'=>'Introduction','1.1'=>'Idea_Graphic','1.2'=>'Feedback_from_Last_Gate','1.2'=>'Country_Strategic_Context','1.3'=>'Key_Changes_since_Contract_Gate','1.3'=>'Feedback_from_BOSSCARD','1.3'=>'Key_Issues_needing_focus_in_Gate_Meeting','1.3'=>'Key_Changes_since_Market_Ready_Gate','1.4'=>'Gate_Keeper_Checklist','2'=>'External','2.1'=>'Competitors','2.1'=>'Competitor','2.2'=>'Customers','2.2'=>'Customers_Channels','3'=>'Mix','3.1'=>'Proposition','3.2'=>'Pack','3.2'=>'Product','3.2'=>'Pack_Graphics','3.3'=>'Product_Sub_Header','3.3'=>'Mix_Qualification_Plan_and_Action_Standards','3.4'=>'Price','3.4'=>'Degree_of_Commonality','3.5'=>'Full_Mix','4'=>'Deployment','4.1'=>'Promotion_Guidance_for_Deployment','4.2'=>'Place_Guidance_for_Deployment','4.2'=>'Place','5'=>'Technical_Header','5'=>'Technical','5.1'=>'R&D_Technical_Readiness','5.1'=>'R&D_Initial_Outline_Product_Pack','5.1'=>'R&D_Feasibility','5.2'=>'Supply_Chain_Technical_Readiness','5.2'=>'Supply_Chain_Initial_Outline','5.2'=>'Supply_Chain_Feasibility','5.3'=>'Environmental_Impact','6'=>'Financial','6.1'=>'Business_Case_Action_Standards','6.2'=>'Assumptions_Risks_Sensitivities','6.2'=>'Initial_Estimate_of_Opportunity','6.2'=>'Business_Waste','6.3'=>'BD/BB_Alignment','6.3'=>'Monitoring_Performance_in_Market','7'=>'Project_Management','7.1'=>'Rollout_Plans','7.1'=>'Risk','7.2'=>'Country_Feedback_Requirements','7.2'=>'Milestones','7.3'=>'Regional_BD_Team_FB_Req','7.3'=>'Regional_BD_Team_Feedback_to_Global','7.3'=>'OTIF_Status','7.4'=>'Human_Resources','8'=>'Appendix','8.1'=>'BD/BB_Alignment_Appendix','8.1'=>'CU_And_Complexity_Appendix','8.1'=>'Customers_Channels_Appendix','8.1'=>'Milestones_Appendix','8.2'=>'Rollout_Plans_Appendix','8.2'=>'Consumer_Evidence_Concept_Appendix','8.2'=>'Assortment_Strategy_Appendix','8.3'=>'Monitoring_Performance_in_Market_Appendix','8.4'=>'Mix_Qualification_Plan_and_Action_Standards_Appendix','8.5'=>'Environmental_Impact_Appendix','8.6'=>'Pack_Graphics_Appendix','8.6'=>'Initial_Estimate_of_Opportunity_Appendix','8.7'=>'Risk_Appendix','8.7'=>'Regional_BD_Team_FB_Req_Appendix','1.2.1'=>'Consumer_Need','1.2.1'=>'Fit_with_National_Category_Building_Plan','1.2.2'=>'Strategic_Fit','1.2.2'=>'Fit_with_BMP_Jobs_to_be_Done','2.2.2'=>'Trade_Story','3.1.1'=>'Target_Audience','3.1.2'=>'Concept','3.1.3'=>'Consumer_Evidence_Concept','3.1.3'=>'Communication','3.1.5'=>'Consumer_Evidence_Communication','3.1.5'=>'Trademarks','3.2.1'=>'CU_And_Complexity','3.2.2'=>'Consumer_Evidence_Pack','3.3.2'=>'Consumer_Evidence_Product','3.4.1'=>'Proposed_Pricing','3.4.2'=>'Consumer_Evidence_Price','3.4.2'=>'Other_Price_Rationale','4.2.1'=>'Assortment_Strategy','4.2.2'=>'Merchandising_Strategy','4.2.3'=>'Trade_Promotion_Strategy','6.2.1'=>'Assumptions','6.2.2'=>'Sensitivity_Analysis'}; 
        Map<String,Boolean> sectionNegotiableMap = new Map<String,Boolean>{'1'=>FALSE,'1.1'=>FALSE,'1.2'=>FALSE,'1.2'=>FALSE,'1.3'=>FALSE,'1.3'=>FALSE,'1.3'=>FALSE,'1.3'=>FALSE,'1.4'=>TRUE,'2'=>TRUE,'2.1'=>TRUE,'2.1'=>TRUE,'2.2'=>FALSE,'2.2'=>TRUE,'3'=>FALSE,'3.1'=>FALSE,'3.2'=>FALSE,'3.2'=>TRUE,'3.2'=>FALSE,'3.3'=>FALSE,'3.3'=>FALSE,'3.4'=>FALSE,'3.4'=>TRUE,'3.5'=>FALSE,'4'=>TRUE,'4.1'=>TRUE,'4.2'=>TRUE,'4.2'=>TRUE,'5'=>FALSE,'5'=>FALSE,'5.1'=>FALSE,'5.1'=>FALSE,'5.1'=>FALSE,'5.2'=>FALSE,'5.2'=>FALSE,'5.2'=>FALSE,'5.3'=>TRUE,'6'=>TRUE,'6.1'=>FALSE,'6.2'=>FALSE,'6.2'=>FALSE,'6.2'=>TRUE,'6.3'=>TRUE,'6.3'=>TRUE,'7'=>FALSE,'7.1'=>TRUE,'7.1'=>FALSE,'7.2'=>TRUE,'7.2'=>TRUE,'7.3'=>TRUE,'7.3'=>TRUE,'7.3'=>FALSE,'7.4'=>TRUE,'8'=>FALSE,'8.1'=>TRUE,'8.1'=>FALSE,'8.1'=>TRUE,'8.1'=>TRUE,'8.2'=>TRUE,'8.2'=>TRUE,'8.2'=>TRUE,'8.3'=>TRUE,'8.4'=>FALSE,'8.5'=>FALSE,'8.6'=>FALSE,'8.6'=>FALSE,'8.7'=>FALSE,'8.7'=>TRUE,'1.2.1'=>FALSE,'1.2.1'=>TRUE,'1.2.2'=>TRUE,'1.2.2'=>TRUE,'2.2.2'=>FALSE,'3.1.1'=>FALSE,'3.1.2'=>TRUE,'3.1.3'=>TRUE,'3.1.3'=>TRUE,'3.1.5'=>TRUE,'3.1.5'=>FALSE,'3.2.1'=>TRUE,'3.2.2'=>TRUE,'3.3.2'=>TRUE,'3.4.1'=>FALSE,'3.4.2'=>TRUE,'3.4.2'=>TRUE,'4.2.1'=>TRUE,'4.2.2'=>TRUE,'4.2.3'=>TRUE,'6.2.1'=>FALSE,'6.2.2'=>TRUE}; 
        Map<String,String> sectionFunctionalMap = new Map<String,String>{'1'=>'','1.1'=>'PL','1.2'=>'PL','1.2'=>'BD','1.3'=>'BD','1.3'=>'PL','1.3'=>'PL','1.3'=>'BB','1.4'=>'PL','2'=>'','2.1'=>'BD','2.1'=>'BD','2.2'=>'BD','2.2'=>'CD','3'=>'','3.1'=>'CMI','3.2'=>'CMI','3.2'=>'CMI','3.2'=>'BB','3.3'=>'BB','3.3'=>'CMI','3.4'=>'CMI','3.4'=>'BD','3.5'=>'CMI','4'=>'','4.1'=>'BD','4.2'=>'BD','4.2'=>'BD','5'=>'','5'=>'R&D','5.1'=>'R&D','5.1'=>'R&D','5.1'=>'R&D','5.2'=>'SC','5.2'=>'SC','5.2'=>'SC','5.3'=>'R&D','6'=>'','6.1'=>'Finance','6.2'=>'Finance','6.2'=>'Finance','6.2'=>'BB','6.3'=>'Finance','6.3'=>'BB','7'=>'','7.1'=>'PL','7.1'=>'BB','7.2'=>'BB','7.2'=>'BB','7.3'=>'BD','7.3'=>'BD','7.3'=>'BB','7.4'=>'PL','8'=>'','8.1'=>'Finance','8.1'=>'BD','8.1'=>'CD','8.1'=>'BD','8.2'=>'BD','8.2'=>'CMI','8.2'=>'CD','8.3'=>'BB','8.4'=>'CMI','8.5'=>'RnD','8.6'=>'BD','8.6'=>'Finance','8.7'=>'BD','8.7'=>'BD','1.2.1'=>'BD','1.2.1'=>'BB','1.2.2'=>'BD','1.2.2'=>'BB','2.2.2'=>'CD','3.1.1'=>'BD','3.1.2'=>'BD','3.1.3'=>'CMI','3.1.3'=>'BB','3.1.5'=>'CMI','3.1.5'=>'BD','3.2.1'=>'BD','3.2.2'=>'CMI','3.3.2'=>'CMI','3.4.1'=>'BD','3.4.2'=>'CMI','3.4.2'=>'BB','4.2.1'=>'CD','4.2.2'=>'CD','4.2.3'=>'CD','6.2.1'=>'Finance','6.2.2'=>'Finance'};
        
        
        Map<String,List<Object>> sectionMasterMap = new Map<String,List<Object>>{
            'External_ID__c' => new List<Object>(),'IPM_Document_Template__c' => new List<Object>(),'IPM_FunctionalRole__c' => new List<Object>(),
            'IPM_Negotiable__c' => new List<Object>(),'IPM_Section_Name__c' => new List<Object>(),'IPM_Section_Sequence__c'=>new List<Object>(),
            'IPM_Section_Type__c' => new List<Object>()};
        
        for(IPM_Document_Template__c tempDoc : documentTemplateList)
        {
            for(Integer counter =0;counter < SequenceList.size();counter++)
            {
                if(sectionExternalIDMap.containsKey(SequenceList.get(counter)))
                {
                    sectionMasterMap.get('External_ID__c').add(sectionExternalIDMap.get(SequenceList.get(counter)));
                }
                
                if(sectionFunctionalMap.containsKey(SequenceList.get(counter)))
                {
                    sectionMasterMap.get('IPM_FunctionalRole__c').add(sectionFunctionalMap.get(SequenceList.get(counter)));
                }
                
                if(sectionNegotiableMap.containsKey(SequenceList.get(counter)))
                {
                    sectionMasterMap.get('IPM_Negotiable__c').add(sectionNegotiableMap.get(SequenceList.get(counter)));
                }
                
                if(sectionNameMap.containsKey(SequenceList.get(counter)))
                {
                    sectionMasterMap.get('IPM_Section_Name__c').add(sectionNameMap.get(SequenceList.get(counter)));
                }
                
                if(sectionExternalIDMap.containsKey(SequenceList.get(counter)))
                {
                    sectionMasterMap.get('IPM_Section_Type__c').add(sectionTypeMap.get(SequenceList.get(counter)));
                }
                
                sectionMasterMap.get('IPM_Section_Sequence__c').add(SequenceList.get(counter));
                
                sectionMasterMap.get('IPM_Document_Template__c').add(tempDoc.Id);
            }
        }
        
        sectionTemplateList = (List<IPM_Section__c>)IPM_TestFactory.createSObjectList('IPM_Section__c',sectionMasterMap,false);
        
        insert sectionTemplateList;
        
        Map<String,List<Object>> milestoneTemplateMap = new Map<String,List<Object>>{
        'IPM_Category__c' => new List<String>{'Home Care','Home Care','Home Care','Home Care','Home Care'},
        'IPM_Name__c' => new List<String>{'Charter Gate Approval','Contract Gate Approval','Market Ready Gate Approval','Market Deployment Gate Approval','Post Launch Evaluation'},
        'IPM_No_Of_Days_for_Developing_Emerging__c' => new List<String>{'','','','-120',''},
        'IPM_No_Of_Days_for_Developing__c' => new List<String>{'','','','-180',''},
        'IPM_Phase__c'=> new List<String>{'Ideas','Feasibility','Capability','Market Ready','Market Deployment'},
        'IPM_Type_of_gate__c' => new List<String>{'Charter','Contract','Market Ready','Market Deployment','Market Deployment'},
        'IPM_Type_of_Milestone__c' => new List<String>{'Standard','Standard','Standard','Standard','Standard'}};
        
        milestoneTemplateList = (List<IPM_Milestone__c>)IPM_TestFactory.createSObjectList('IPM_Milestone__c',milestoneTemplateMap,false);
        
        insert milestoneTemplateList;
        
        List<Id> recordIdList = new List<Id>{recTypeRnD,recTypeIDPOS,recTypeIDRQS,recTypeIDCR,recTypeRnDFeasibility,recTypeSCFeasibility,recTypeRisk};
         
        Map<String,List<Object>> questionnaireMap = new Map<String,List<Object>>{'RecordTypeId' => new List<Id>(),'Is_Master__c' => new List<Boolean>(),'IPM_Score__c' => new List<Integer>()};
        
        for(Id recordId : recordIdList)
        {
            for(Integer counter=0;counter < 3;counter++)
            {
                questionnaireMap.get('RecordTypeId').add(recordId);  
                questionnaireMap.get('Is_Master__c').add(true);
                questionnaireMap.get('IPM_Score__c').add(counter); 
            }
        }
        
        questionnaireTemplateList = (List<IPM_Questionnaire__c>)IPM_TestFactory.createSObjectList('IPM_Questionnaire__c',questionnaireMap,false);
        
        insert questionnaireTemplateList;
        
        mdmGeoList = Test.loadData(MDM_Geography__c.sObjectType, 'IPM_Unilever_Geo');
        
        projectMetadataList = Test.loadData(IPM_ProjectMetadata__c.sObjectType, 'IPM_Project_Metadata');
        
        projectTypeList = Test.loadData(IPM_Project_Type__c.sObjectType, 'IPM_ProjectType'); 
        
        cmiGateKPIInputList = Test.loadData(IPM_Gate_CMI_KPI_Inputs__c.sObjectType, 'IPM_GateCMIKPIInputs');
        
        cmiColorCodes = Test.loadData(IPM_CMI_Color_Mapping__c.sObjectType, 'IPM_CMIColorCodes');
        
    }
    
    public static List<IPM_Gate_CMI__c> createCMIGateRecords(Boolean doInsert,List<IPM_Project__c> pProjectList)
    {
        List<IPM_Gate_CMI__c> finalCMIGateList = new List<IPM_Gate_CMI__c>();
            
        Map<String,List<Object>> CMIGateRecordMap = new Map<String,List<Object>>{
        'Gate__c' => new List<String>{'Charter','Charter','Contract'},
        'Element__c' => new List<String>{'Concept','Concept','Product Test'},
        'Test__c' => new List<String>{'Idea Screener - Nielsen','Innoscreen * ideas - Ipsos','Branded Product Test - Ipsos'},
        'IPM_Skip_Test__c' => new List<Boolean>{false,false,false},
        'Country__c' => new List<String>{'Africa','Brazil','Africa'},
        'KPI__c' => new List<String>{'Salience/Attraction Matrix','RED','Overall Score'}
        };
        
        for(IPM_project__c project : pProjectList)
        {
            List<IPM_Gate_CMI__c> tempCMIGateList = (List<IPM_Gate_CMI__c>)IPM_TestFactory.createSObjectList('IPM_Gate_CMI__c',CMIGateRecordMap,false);
            
            for(IPM_Gate_CMI__c cmiGate : tempCMIGateList)
            {
                cmiGate.IPM_Project__c = project.Id;
            }
            
            finalCMIGateList.addAll(tempCMIGateList);
        }
        
        if(doInsert)
        {
            insert finalCMIGateList;
        }
        
        return finalCMIGateList;
    }
  
    // Create reporting custom setting records
    public static IPM_Reporting__c createIPMReportingCustomSetting() {
       
       IPM_Reporting__c RP = new IPM_Reporting__c(Name='BD BB Report', Last_Batch_RunDate__c= System.now(), Y1__c = 1, Y2__c=2, Y3__c=3, Y4__c=4, Y5__c=5, Y_1__c = -1, Y_2__c=-2, Y_3__c=-3);  
       
        insert RP;
        return RP;
   } 
    
    //coreparameter configuration
    public static List<IPM_CoreParameter_Configration__c> createIPMCoreParameterConfig() {
      return Test.loadData(IPM_CoreParameter_Configration__c.sObjectType, 'IPM_CoreparameterConfig');
   } 
   //get all coreparameter questions
   public static List<IPM_CoreParameter_Questions__c> createIPMCoreParameterAllQuestions() {
        return Test.loadData(IPM_CoreParameter_Questions__c.sObjectType, 'IPM_CoreparameterQuestions');   
    } 
   //get innovation and renovation details
   public static List<IPM_InnovationRenovation__c> createIPMCoreParameterInnoReno() {
        return Test.loadData(IPM_InnovationRenovation__c.sObjectType, 'IPM_InnovationRenova');   
    } 
   //get category based conditions
   public static List<IPM_Category__c> createIPMCategory() {
        return Test.loadData(IPM_Category__c.sObjectType, 'IPM_Category');   
    }  
    
    //get Project Type data
    public static List<IPM_Project_Type__c> createIPMProjectType() {
        return Test.loadData(IPM_Project_Type__c.sObjectType, 'IPM_ProjectType'); 
    } 
    //get coreparameter graph
    public static List<IPM_Coreparameter_Graph__c> createCoreGraph() {
        return Test.loadData(IPM_Coreparameter_Graph__c.sObjectType, 'IPM_Coreparameter_Graph'); 
    }
    public static List<ipm_project__share> shareIPMProject(List<IPM_Project__c>listProjects,List<User>listUsers){
        List<ipm_project__share>listProjShare=new List<ipm_project__share>();
        for(IPM_Project__c pro:listProjects){
            for(user u:listUsers){
               ipm_project__share projShare=new ipm_project__share();
               projShare.accessLevel='EDIT';
               projShare.userorgroupid=u.id;
               projShare.parentid=pro.id;
               listProjShare.add(projShare);
            }
        }
        
     return listProjShare;
    }
  
}