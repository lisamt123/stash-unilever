/**
 * IPM_BD_BB_Reportbatch_Test : Test class for IPM_BD_BB_Report_Batch apex class
 * @author - Cognizant
 *
 */
 
@isTest
private class IPM_BD_BB_Report_Batch_Test {  
    
    public static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
    public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
    public static List<IPM_Financial_Year__c> lstFinancialYear=new List<IPM_Financial_Year__c>();
    public static List<IPM_Milestone__c> ipmMileStoneTestList=new List<IPM_Milestone__c>();
    public static List<IPM_Country__c> ipmcountrylist = new List<IPM_Country__c>();
    public static IPM_Reporting__c reportParameter;
    public static user systemAdmin;
    public static User testUser;
    public static List<User> userList;
    public static Id projid;
    public static set<id> projidset = new set<id>();
    public static final String YEAR_1 = 'Y1';
    public static final String GROSS = 'Gross';
    public static final String INCREMENTAL = 'Incremental';
    public static final String CALENDAR = 'Calendar';
    private static final string IPMUSER_LASTNAME='IPMUSER_LASTNAME';
    private static final string BD_BB_REPORT = 'BD BB Report';
    
     /**********************************************************************
    *  @Description: Test Method to create project data for the other test methods
    *  @name : createProject
    *  @param : none
    *  @return : none
    *************************************************************************/
    static void createProject(){
      systemAdmin= IPM_TestFactory_Helper.createUserAdmin(false);
        system.runAs(systemAdmin){
            testUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);
            userList = IPM_TestFactory_Helper.createUserList(); 
            system.assertEquals(userList[0].LastName,IPMUSER_LASTNAME,'Error in User Creation');
        }
        
        //Insert data for Custom setting
        reportParameter = IPM_TestFactory_Helper.createIPMReportingCustomSetting(BD_BB_REPORT, true);
        List<IPM_Reporting__c>reportParameterlist=[SELECT Id,Name FROM IPM_Reporting__c WHERE Id=:reportParameter.Id limit 1];
        system.assertEquals(reportParameterlist[0].Name,reportParameter.Name,'Error in IPMReporting Custom Setting Creation'); //positive test
        
        // Being used Below in Code. Sonar 
        system.runAs(testUser)
        {
          //Test project creation
            projectList = IPM_TestFactory_Helper.insertIPMProjectList();
            
            for(IPM_Project__c p:projectList){
                if(p.IPMProject_Span__c.equalsignorecase(IPM_Utils.valueGlobal)){
                    p.IPM_Project_Type__c = IPM_Utils.Original;
                    p.IPM_Category_Text__c = IPM_ConstantUtils.HHC_CONSTANT;
                    p.IPM_Project_Leader__c = testUser.Id;
                    projid = p.Id;                  

                }
                if(p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional)){
                    p.IPM_Project_Type__c = IPM_Utils.Rollout; 
                }
                if(p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local)){
                    p.IPM_Project_Type__c = IPM_Utils.Rollout;
                }
                p.Project_External_ID__c = p.id + p.IPMProject_Span__c;
                projidset.add(p.id);                
            }
            update projectList;
            
            list<IPM_Project__c> projectListtest = new list<IPM_Project__c>([SELECT id,Name,IPMProject_Span__c FROM IPM_Project__c WHERE id IN:projectList Limit 100]);
            system.assertEquals(projectList[0].Name,projectListtest[0].Name,'Name doesnt matched');
      }
    }
    /**********************************************************************
    *  @Description: Test Method to initialize data for the other test methods
    *  @name : initializeData1
    *  @param : none
    *  @return : none
    *************************************************************************/
    static void initializeData1(){
              
       createProject();
       system.runAs(testUser){
            List<IPM_Analytics__c> analyticsRecDelList = new list<IPM_Analytics__c>();
            for(IPM_Project__c projRec: projectList){
              IPM_Analytics__c analyticsRec =  new IPM_Analytics__c();
              analyticsRec.IPM_Project_Id__c = projRec.Id;
              analyticsRecDelList.add(analyticsRec);
            }
            if(!analyticsRecDelList.isEmpty()){
                insert analyticsRecDelList;
            }
            
            //Test Finance data creation            
            lstFinancial = IPM_TestFactory_Helper.insertIPMFinancialList(true);
            
            map<Id,IPM_Financial__c> updatededFinancialrecord = new map <Id,IPM_Financial__c> ();
            list<IPM_Financial__c> insertedfinancialrecord = new list <IPM_Financial__c> ([SELECT id,Name,Target_Launch_Date__c,Parent_Project__c,Local_Project__c,Financial_External_ID__c,Regional_Project__c
                                                    FROM IPM_Financial__c WHERE id IN:lstFinancial Limit 100]);
            
            
           for(IPM_Project__c p : projectList){
              if(p.IPMProject_Span__c.equalsignorecase(IPM_Utils.valueGlobal)){
                insertedfinancialrecord[0].Parent_Project__c = p.id;      
                insertedfinancialrecord[0].Financial_External_ID__c = p.Name + IPM_Utils.CONSOLIDATED ;
                insertedfinancialrecord[0].isActive__c=true;
                updatededFinancialrecord.put(insertedfinancialrecord[0].id,insertedfinancialrecord[0]);            
              }
              if(p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional)){
                  insertedfinancialrecord[1].Regional_Project__c = p.id;     
                  insertedfinancialrecord[1].Financial_External_ID__c = p.Name + IPM_Utils.CONSOLIDATED ;
                  insertedfinancialrecord[1].isActive__c=true;
                  updatededFinancialrecord.put(insertedfinancialrecord[1].id,insertedfinancialrecord[1]);
              }
              if(p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local)){
                 insertedfinancialrecord[2].Local_Project__c = p.id;   
                 insertedfinancialrecord[2].Financial_External_ID__c = p.Name ;  
                 insertedfinancialrecord[2].isActive__c=true;
                 updatededFinancialrecord.put(insertedfinancialrecord[2].id,insertedfinancialrecord[2]); 
              }
            }
                        
            system.debug('updatededFinancialrecord==>>'+updatededFinancialrecord);
            update updatededFinancialrecord.values();  
            
            system.assertEquals(insertedfinancialrecord[0].Target_Launch_Date__c,lstFinancial[0].Target_Launch_Date__c,'Project Financials TLD differs');

            //Test Financial Year Data creation/update
            lstFinancialYear = IPM_TestFactory_Helper.insertIPMFinancialYearList();
            
            list<IPM_Financial_Year__c> insertedfinancialyrrecord = new list <IPM_Financial_Year__c> ([SELECT id,Year__c FROM IPM_Financial_Year__c WHERE id IN:lstFinancialYear AND YEAR__c ='Innovation'Limit 100]);
            system.assertEquals(insertedfinancialyrrecord[0].Year__c,IPM_ConstantUtils.YEAR_TYPE_INNOVATION,'Project FinancialYear differs');
            //Test Milestone Data Creation/Update
            Id mileMRecordType=Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get('IPM Project Milestones').getRecordTypeId();
            ipmMileStoneTestList = IPM_TestFactory_Helper.createIPMMilestoneList(false, 7);
                          
            for(Integer i = 0; i < ipmMileStoneTestList.size(); i++){
                
                ipmMileStoneTestList[i].IPM_Due_Date__c = system.today() + i;                
                ipmMileStoneTestList[i].IPM_Type_of_Milestone__c = IPM_ConstantUtils.STANDARD;
                ipmMileStoneTestList[i].recordtypeid = mileMRecordType;
                ipmMileStoneTestList[i].IPM_Project__c = projid;
                ipmMileStoneTestList[i].IPM_Due_Date__c = system.today() + 30;          
                ipmMileStoneTestList[i].IPM_Proposed_Date__c = system.today() + 60;
                ipmMileStoneTestList[i].IPM_Completed_on__c = system.today() + 90;
                ipmMileStoneTestList[i].IPM_Name__c = projid + string.valueof(i); 
                                          
                if(i==0){
                     ipmMileStoneTestList[0].IPM_Type_of_gate__c = IPM_Utils.Charter; 
                }          
                if(i==1) {
                    ipmMileStoneTestList[1].IPM_Type_of_gate__c = IPM_Utils.Contract;
                }
                if(i==2){
                     ipmMileStoneTestList[2].IPM_Type_of_gate__c = IPM_Utils.MarketReady;
                }
                
                if(i==3){
                     ipmMileStoneTestList[3].IPM_Type_of_gate__c = IPM_Utils.MarketDeployment;
                }
                if(i==4) {
                    ipmMileStoneTestList[4].IPM_Name__c = IPM_Utils.TargetLaunchDateShiptoTrade;
                }
                
                if(i==5) {
                    ipmMileStoneTestList[5].IPM_Name__c = IPM_ConstantUtils.BET_MS_FIRST_RELEASE;
                }
                    
                if(i==6) {
                    ipmMileStoneTestList[6].IPM_Name__c = IPM_ConstantUtils.BET_MS_FINAL_RELEASE;
                }
            }

            insert ipmMileStoneTestList;
            List<IPM_Milestone__c> ipmMileStoneTestListtest = new List<IPM_Milestone__c>([SELECT Id FROM IPM_Milestone__c where id IN:ipmMileStoneTestList limit 100]);
            system.assertEquals(ipmMileStoneTestListtest.size(),7,'Count of IPM_Milestone != 7'); //positive test 
            
            //Test Country Data Creation/Update    
            //Insert Geography
            MDO_Geography__c geo = IPM_TestFactory_Helper.createMDOGeography(false);
            geo.Name='TestRegion';
            geo.geography_type__c='Cluster';
            Insert geo;
            List<MDO_Geography__c> geolist = new List<MDO_Geography__c>([SELECT Id,Name FROM MDO_Geography__c where id =: geo.id limit 1]);
            system.assertEquals(geolist[0].Name, geo.Name, 'Error in Geography Creation'); //positive test
            }  
    }
    
    /**********************************************************************
    *  @Description: Test Method to initialize data for the other test methods
    *  @name : initializeData2
    *  @param : none
    *  @return : none
    *************************************************************************/
    static void initializeData2(){
      
      createProject();
        system.runAs(testUser){
          
          List<IPM_Project__c> globalprojectlist = new List<IPM_Project__c>();
            for(IPM_Project__c p:projectList){
              if(p.IPMProject_Span__c.equalsignorecase(IPM_Utils.valueGlobal)){
                globalprojectlist.add(p);  
              }
            }
            // Create Regional Rollouts for Created Global project.
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,globalprojectlist,new List<User>{userList[1],userList[1],userList[1]});
            insert regionalRolloutList;
            
            //check regional rollouts have been created
            list<IPM_Project_Rollout__c> insertedregionalRolloutrecords = new list <IPM_Project_Rollout__c> ([SELECT id,Name FROM IPM_Project_Rollout__c WHERE id IN:regionalRolloutList Limit 100]);
            system.assertEquals(insertedregionalRolloutrecords[0].Name,regionalRolloutList[0].Name,'Project Regional Rollout Name differs');
            
            Map<Id,List<IPM_Project_Rollout__c>> projectToRolloutMap = new Map<Id,List<IPM_Project_Rollout__c>>();
            for(IPM_Project_Rollout__c projectRollout : regionalRolloutList)
            {
                List<IPM_Project_Rollout__c> projectRolloutList = new List<IPM_Project_Rollout__c>();
                if(projectToRolloutMap.containsKey(projectRollout.IPM_Project__c))
                {
                    projectRolloutList = projectToRolloutMap.get(projectRollout.IPM_Project__c);
                }
                projectRolloutList.add(projectRollout);
                projectToRolloutMap.put(projectRollout.IPM_Project__c,projectRolloutList);
            }
            
            // Create local Rollouts for Created regional Rollouts.
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{userList[2]});  
            insert localRolloutList;
            
            //check local rollouts have been created 
            list<IPM_Project_Rollout__c> insertedlocalRolloutrecords = new list <IPM_Project_Rollout__c> ([SELECT id,Name FROM IPM_Project_Rollout__c WHERE id IN:localRolloutList Limit 100]);
            system.assertEquals(insertedlocalRolloutrecords[0].Name,localRolloutList[0].Name,'Project Local Rollout differs');             
                        
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>();
                
             for(IPM_Project_Rollout__c localRollout : localRolloutList)
             {
                String geoExternalId = '';
                if(localRollout.IPM_Rollout_Project__c.contains('AFR'))
                {
                    geoExternalId = 'AGO';
                }
                else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
                {
                    geoExternalId = 'BRA';
                }
                
                IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new mdm_Geography__c(ISO_3166_1_Code__c = geoExternalId).Id,
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
                
                countryList.add(tempCountry);
             }
              
             insert countryList;
             list<IPM_Country__c> insertedcountryrecords = new list <IPM_Country__c> ([SELECT id,Name FROM IPM_Country__c WHERE id IN:countryList Limit 100]);
             system.assertEquals(insertedcountryrecords.size(),countryList.size(),'List of Project Country differs in count');            
             
             
            //Insert Financial records for rollouts
            List<IPM_Financial__c> finList = new List<IPM_Financial__c>();
            String strRecordTypeConId=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
            
            IPM_Financial__c finRegional = new IPM_Financial__c();      
            finRegional.Parent_Project__c = projid;
            finRegional.IPM_Project_Rollout__c = regionalRolloutList[0].id;
            finRegional.RecordTypeId = strRecordTypeConId;
            finRegional.Financial_External_ID__c = regionalRolloutList[0].name+IPM_Utils.CONSOLIDATED;
            finRegional.Target_Launch_Date__c = System.today()+100000;
            finList.add(finRegional);
            
            IPM_Financial__c finlocal = new IPM_Financial__c();
            finRegional.Parent_Project__c = projid;
            finlocal.IPM_Project_Rollout__c = localRolloutList[0].id;
            finlocal.RecordTypeId = strRecordTypeConId;
            finlocal.Financial_External_ID__c = localRolloutList[0].name;
            finlocal.Target_Launch_Date__c = System.today()+100000;
            finList.add(finlocal);
            
            insert finList;
            
            list<IPM_Financial__c> insertedfinancialrolloutrecords = new list <IPM_Financial__c> ([SELECT id,Name,Target_Launch_Date__c FROM IPM_Financial__c WHERE id IN:finList Limit 100]);
            system.assertEquals(insertedfinancialrolloutrecords[0].Target_Launch_Date__c,finList[0].Target_Launch_Date__c,'Financials TLD differs');
            
            //Insert Financial Year records for rollouts
            List<IPM_Financial_Year__c> finYear=new List<IPM_Financial_Year__c>();
            String INNOVATION = 'Innovation';
            
            //For Regional rollouts     
            IPM_Financial_Year__c finYear1 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear1.IPM_Financial__c= finList[0].Id;
            finYear1.Name = YEAR_1;
            finYear1.year__c = INNOVATION;
            finYear1.PL_type__C = GROSS;
            finYear.add(finYear1);
            IPM_Financial_Year__c finYear2 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear2.IPM_Financial__c= finList[0].Id;
            finYear2.Name = YEAR_1;
            finYear2.year__c = INNOVATION;
            finYear2.PL_type__C = INCREMENTAL;
            finYear.add(finYear2);            
            IPM_Financial_Year__c finYear3 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear3.IPM_Financial__c= finList[0].Id;
            finYear3.Name = YEAR_1;
            finYear3.year__c = CALENDAR;
            finYear3.PL_type__C = GROSS;
            finYear.add(finYear3);            
            IPM_Financial_Year__c finYear4 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear4.IPM_Financial__c= finList[0].Id;
            finYear4.Name = YEAR_1;
            finYear4.year__c = CALENDAR;
            finYear4.PL_type__C = INCREMENTAL;
            finYear.add(finYear4);
            
            //For Local Rollouts
            IPM_Financial_Year__c finYear5 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear5.IPM_Financial__c= finList[1].Id;
            finYear5.Name = YEAR_1;
            finYear5.year__c = INNOVATION;
            finYear5.PL_type__C = GROSS;
            finYear.add(finYear5);
            IPM_Financial_Year__c finYear6 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear6.IPM_Financial__c= finList[1].Id;
            finYear6.Name = YEAR_1;
            finYear6.year__c = INNOVATION;
            finYear6.PL_type__C = INCREMENTAL;
            finYear.add(finYear6);            
            IPM_Financial_Year__c finYear7 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear7.IPM_Financial__c= finList[1].Id;
            finYear7.Name = YEAR_1;
            finYear7.year__c = CALENDAR;
            finYear7.PL_type__C = GROSS;
            finYear.add(finYear7);            
            IPM_Financial_Year__c finYear8 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear8.IPM_Financial__c= finList[1].Id;
            finYear8.Name = YEAR_1;
            finYear8.year__c = CALENDAR;
            finYear8.PL_type__C = INCREMENTAL;
            finYear.add(finYear8);
            insert finYear;         
             
            list<IPM_Financial_Year__c> insertedfinancialyrrolloutrecords = new list <IPM_Financial_Year__c> ([SELECT id,Name FROM IPM_Financial_Year__c WHERE id IN:finYear Limit 100]);
            system.assertEquals(insertedfinancialyrrolloutrecords[0].Name,finYear[0].Name,'FinancialYear Name differs');
        
        }
    }
        
     /**********************************************************************
    *  @Description: This method is used to execute the IPM_BD_BB_Report_Batch 
                    job to copy project details to analytics object.
    *  @name : testBDBBreport1
    *  @param : none
    *  @return : none
    *************************************************************************/  
    static testMethod void testBDBBreport1() {  
        initializeData1();     
        Test.startTest();       
        system.runAs(testUser){
            string  query = 'SELECT Id,IPM_Global_ProjectId__c,Project_External_ID__c,Name,IPM_Parent_Project__r.Name,IPM_Parent_Project__r.Id,IPM_Project_Leader__r.Name,Deputy_Project_Leader__r.Name,IPM_Technical_Project_Leader__r.Name,IPM_Finance_Lead__r.Name,IPM_Rollout_Status__c,IPM_Category_Group__c,IPM_Category_Text__c,IPM_Phase__c,IPM_Brand_Positioning__c,IPMProject_Span__c, IPMProject_Type__c,Project_Countries__c,IPM_No_of_Country_Rollouts__c,IPM_Threshold_Value__c,IPM_Company_Card__r.Name,IPM_Cluster__c,Market_Cluster__c,Market_Cluster_Name__c,IPM_Clustering__c,IPM_Clusters__c,IPM_Answer_of_Q1__c, IPM_Answer_of_Q2__c, Exempt_from_Threshold__c, IPM_Answer_of_Q3__c,IPM_Strategic_Intent__c,IPM_Target_Launch_Year__c,IPM_Target_Launch_Month__c,IPM_Actual_Launch_Date__c, IPM_Actual_Launch_Month__c,IPM_Actual_Launch_Year__c,IPMPlatform__c,IPM_Project_Type__c,IPM_Project_Description__c,IPM_Target_Launch_Dates__c,IPM_Project_Rollout__c,IPM_Misalligned__c,CreatedDate,IPM_Project_Start_Date__c,IPM_Parent_Project__r.IPM_Project_Rollout__r.Target_Launch_Date__c,IPM_CPP__c,IPM_Fast_Track_Project__c,Is_Archieved__c,IPM_Global_OR_Regional__c,IPM_Project_Rollout__r.Target_Launch_Date__c, IPM_Project_Rollout__r.KeyMCO__c FROM IPM_Project__c'; 
            IPM_BD_BB_Report_Batch  batchs = new IPM_BD_BB_Report_Batch(query); 
            database.executebatch(batchs,100);  
            
            string cppRec ;
            cppRec = batchs.calculateCPP(40000.00, 400000000.00);
            system.assertequals(cppRec,'Gold','CPP value is not Gold'); 
            
            cppRec = batchs.calculateCPP(2.00, 1000.00);
            system.assertequals(cppRec,'Silver','CPP value is not SILVER'); 
            
            cppRec = batchs.calculateCPP(0.20, 1000.00);
            system.assertequals(cppRec,'Bronze','CPP value is not BRONZE'); 
            
            double turnOverVal;
            IPM_Financial_Year__c fr = lstFinancialYear[0];
            
            turnOverVal = batchs.getTurnOver(fr, True, 'TURNOVER' );
            system.assertequals(fr.Turnover_Global__c,turnOverVal,'Turnover value for global is same'); 
            
            turnOverVal = batchs.getTurnOver(fr, false, 'TURNOVER' );
            system.assertequals(fr.Turnover_Regional__c,turnOverVal,'Turnover value for Regional is same');
            
        }  
         
        List<IPM_Reporting__c>reportParameterlist1=[SELECT Id, Last_Batch_RunDate__c FROM IPM_Reporting__c WHERE Id=:reportParameter.Id limit 1];
        system.assertequals(reportParameterlist1[0].Last_Batch_RunDate__c.day(),reportParameter.Last_Batch_RunDate__c.day(),'Error in Batch Last run date update - initializeData2 Method');            
        Test.stopTest();
    }
    
     /**********************************************************************
    *  @Description: This method is used to execute the IPM_BD_BB_Report_Batch 
                    job to copy project details to analytics object.
    *  @name : testBDBBreport2
    *  @param : none
    *  @return : none
    *************************************************************************/  
        static testMethod void testBDBBreport2() { 
        initializeData2();   
        Test.startTest();         
        system.runAs(testUser){
            string  query = 'SELECT Id,IPM_Global_ProjectId__c,Project_External_ID__c,Name,IPM_Parent_Project__r.Name,IPM_Parent_Project__r.Id,IPM_Project_Leader__r.Name,Deputy_Project_Leader__r.Name,IPM_Technical_Project_Leader__r.Name,IPM_Finance_Lead__r.Name,IPM_Rollout_Status__c,IPM_Category_Group__c,IPM_Category_Text__c,IPM_Phase__c,IPM_Brand_Positioning__c,IPMProject_Span__c, IPMProject_Type__c,Project_Countries__c,IPM_No_of_Country_Rollouts__c,IPM_Threshold_Value__c,IPM_Company_Card__r.Name,IPM_Cluster__c,Market_Cluster__c,Market_Cluster_Name__c,IPM_Clustering__c,IPM_Clusters__c,IPM_Answer_of_Q1__c, IPM_Answer_of_Q2__c, Exempt_from_Threshold__c, IPM_Answer_of_Q3__c,IPM_Strategic_Intent__c,IPM_Target_Launch_Year__c,IPM_Target_Launch_Month__c,IPM_Actual_Launch_Date__c, IPM_Actual_Launch_Month__c,IPM_Actual_Launch_Year__c,IPMPlatform__c,IPM_Project_Type__c,IPM_Project_Description__c,IPM_Target_Launch_Dates__c,IPM_Project_Rollout__c,IPM_Misalligned__c,CreatedDate,IPM_Project_Start_Date__c,IPM_Parent_Project__r.IPM_Project_Rollout__r.Target_Launch_Date__c,IPM_CPP__c,IPM_Fast_Track_Project__c,Is_Archieved__c,IPM_Global_OR_Regional__c,IPM_Project_Rollout__r.Target_Launch_Date__c, IPM_Project_Rollout__r.KeyMCO__c FROM IPM_Project__c'; 
            IPM_BD_BB_Report_Batch  batch = new IPM_BD_BB_Report_Batch(query); 
            database.executebatch(batch,100);
        } 
        
        List<IPM_Reporting__c>reportParameterlist2=[SELECT Id, Last_Batch_RunDate__c FROM IPM_Reporting__c WHERE Id=:reportParameter.Id limit 1];
        system.assertequals(reportParameterlist2[0].Last_Batch_RunDate__c.day(),reportParameter.Last_Batch_RunDate__c.day(),'Error in Batch Last run date update - initializeData2 Method');            
        Test.stopTest();
    }
    
    
}