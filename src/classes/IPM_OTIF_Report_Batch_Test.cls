/**
 * IPM_OTIF_Reportbatch_Test : Test class for IPM_OTIF_Report_Batch apex class
 * @author - Cognizant
 *
 */
 
@isTest
private class IPM_OTIF_Report_Batch_Test {  
    
    private static IPM_Project__c project;// Project object initialization    
    private static IPM_Project_Template__c projTempl;   
    private static IPM_Project_Document__c projDoc; 
    private static IPM_Section__c secMst;   
    private static IPM_Document_Template__c ipdt;   
    private static string RECORD_NOT_CREATED_SUCCESSFULLY='records not created successfully'; 
    private static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();   
    public static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
    public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
    public static List<IPM_Financial_Year__c> lstFinancialYear=new List<IPM_Financial_Year__c>();
    public static List<IPM_Milestone__c> ipmMileStoneTestList=new List<IPM_Milestone__c>();
    public static List<IPM_Country__c> ipmcountrylist = new List<IPM_Country__c>();
    public static IPM_Reporting__c reportParameter;
    public static user systemAdmin;
    public static User testUser;
    public static List<User> userList;
    public static set<id> projidset = new set<id>();
    public static final String YEAR_3 = 'Y3';
    public static final String GROSS = 'Gross';
    public static final String INCREMENTAL = 'Incremental';
    public static final String CALENDAR = 'Calendar';
    private static final string IPMUSER_LASTNAME='IPMUSER_LASTNAME';
    private static final string GREEN='Green';  
    private static final string RED='Red';
    private static final string AMBER='Amber';  

    /**********************************************************************
    *  @Description: Test Method to create generic project and other related objects data that will be used by other methods of this test class
    				 This method will prepare test records for IPM_Project__c, IPM_Milestone__c, IPM_Project Document etc, all these records will be used to populate
    				 the IPM Analytic records.
    *  @name       : initializeData1
    *  @param      : none
    *  @return     : none
    *************************************************************************/
    // Method to Initialize Project related data for 
    static void initializeData1(){
              
            systemAdmin= IPM_TestFactory_Helper.createUserAdmin(false);
            system.runAs(systemAdmin){
                testUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);
                userList = IPM_TestFactory_Helper.createUserList(); 
                system.assertEquals(userList[0].LastName,IPMUSER_LASTNAME,'Error in User Creation');
                  //creating Project Template
                  IPM_Project_Template__c projTemplate = IPM_TestFactory_Helper.createIPMProjectTemplate(FALSE);
                  insert projTemplate;
                  List<IPM_Project_Template__c> projTemplList=[SELECT ID,IPM_Template_Complexity__c FROM IPM_Project_Template__c WHERE ID=:projTemplate.ID LIMIT 1];
                  projTempl=projTemplList[0];        
                 // System.assertEquals(projTempl.IPM_Template_Complexity__c, IPM_ConstantUtils.COMPLEXITY_FULL,RECORD_NOT_CREATED_SUCCESSFULLY);
                  
                  IPM_Document_Template__c ipdoctem = IPM_TestFactory_Helper.creteIPMDocumentTemplate(FALSE);
                  ipdoctem.IPM_Project_Template__c = projTempl.ID;
                  insert ipdoctem;
                  List<IPM_Document_Template__c> projDocTemplList=[SELECT ID,IPM_Project_Template__c,IPM_Document_Template_Name__c,IPM_Document_Type__c FROM IPM_Document_Template__c WHERE ID=:ipdoctem.ID LIMIT 1];
                  ipdt=projDocTemplList[0];
                  System.assertEquals(projDocTemplList[0].id,ipdoctem.id,RECORD_NOT_CREATED_SUCCESSFULLY);//positive test
                
                  //Creating master Section
                  IPM_Section__c secMast = IPM_TestFactory_Helper.createIPMSection(FALSE);
                  secMast.IPM_Document_Template__c = ipdt.ID;
                  insert secMast;
                  List<IPM_Section__c> projSecMstlList=[SELECT ID,IPM_Document_Template__c,IPM_Section_Sequence__c,IPM_Section_Name__c FROM IPM_Section__c WHERE ID=:secMast.ID LIMIT 1];
                  secMst=projSecMstlList[0];                
            }
            
            Id projid;
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
            
            list<IPM_Project__c> projectListtest = new list<IPM_Project__c>([SELECT id,Name FROM IPM_Project__c WHERE id IN:projectList Limit 100]);
            system.assertEquals(projectList[0].Name,projectListtest[0].Name,'Name doesnt matched');
            
            List<IPM_Analytics_OTIF__c> analyticsRecDelList = new list<IPM_Analytics_OTIF__c>();
            
            if(!analyticsRecDelList.isEmpty()){
                insert analyticsRecDelList;
            }
            
            //Test Finance data creation            
            lstFinancial = IPM_TestFactory_Helper.insertIPMFinancialList(true);
            list<IPM_Financial__c> insertedfinancialrecord = new list <IPM_Financial__c> ([SELECT id,Name,Target_Launch_Date__c FROM IPM_Financial__c WHERE id IN:lstFinancial Limit 100]);
            system.assertEquals(insertedfinancialrecord[0].Target_Launch_Date__c,lstFinancial[0].Target_Launch_Date__c,'Project Financials TLD differs');

            //Test Financial Year Data creation/update
            lstFinancialYear = IPM_TestFactory_Helper.insertIPMFinancialYearList();
            
            list<IPM_Financial_Year__c> insertedfinancialyrrecord = new list <IPM_Financial_Year__c> ([SELECT id,Year__c FROM IPM_Financial_Year__c WHERE id IN:lstFinancialYear AND YEAR__c ='Innovation'Limit 100]);
            system.assertEquals(insertedfinancialyrrecord[0].Year__c,IPM_ConstantUtils.YEAR_TYPE_INNOVATION,'Project FinancialYear differs');

            //Test Project Document Data Creation/update
            
            
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
              //creating Project Template
              IPM_Project_Template__c projTemplate = IPM_TestFactory_Helper.createIPMProjectTemplate(FALSE);
              insert projTemplate;
              List<IPM_Project_Template__c> projTemplList=[SELECT ID,IPM_Template_Complexity__c FROM IPM_Project_Template__c WHERE ID=:projTemplate.ID LIMIT 1];
              projTempl=projTemplList[0];                   
            
             // Create Project
              IPM_Project__c projectRecord = IPM_TestFactory_Helper.createIPMProject(FALSE);
              insert projectRecord;
              projectList.add(projectRecord);
              List<IPM_Project__c> projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectRecord.ID LIMIT 1];
              project=projlList[0];
              System.assertEquals(projlList[0].id,projectRecord.id,RECORD_NOT_CREATED_SUCCESSFULLY);//positive test
              
              //insert project document
              IPM_Project_Document__c projDocument = IPM_TestFactory_Helper.createIPMProjectDocument(FALSE);
              projDocument.IPM_Project__c=project.ID;
              projDocument.IPM_Project_Template__c= projTempl.Id;  
              insert projDocument;
              projDocList=[SELECT IPM_GateDocuments__c,IPM_Project__c,IPM_Project_Template__c,IPM_Contract_GateKeeper_Model__c FROM IPM_Project_Document__c WHERE ID=:projDocument.ID LIMIT 1];
              projDoc=projDocList[0];
              System.assertEquals(projDocList[0].IPM_Project__c,project.ID,RECORD_NOT_CREATED_SUCCESSFULLY);//positive test
              
              // Creationg Project Document Sections
              IPM_Project_Document_Section__c pojDocSection = IPM_TestFactory_Helper.createIPMProjectDocumentSection(FALSE);
              pojDocSection.IPM_Project_Document__c=projDoc.ID;
              pojDocSection.IPM_Section__c=secMst.Id;
              pojDocSection.IPM_Section_Name__c = IPM_ConstantUtils.OTIF_STATUS;
              pojDocSection.IPM_Gate_Document__c = IPM_Utils.Charter;
              insert pojDocSection;
              List<IPM_Project_Document_Section__c> projDocSecList=[SELECT ID,IPM_Default_Section__c,IPM_Project_Document__c,IPM_Section__c FROM IPM_Project_Document_Section__c WHERE ID=:pojDocSection.ID LIMIT 1];
              System.assertEquals(projDocSecList[0].IPM_Section__c,secMst.Id,RECORD_NOT_CREATED_SUCCESSFULLY); //positive test 
                
              IPM_Project_Document_Section__c pojDocSectionContract = IPM_TestFactory_Helper.createIPMProjectDocumentSection(FALSE);
              pojDocSectionContract.IPM_Project_Document__c=projDoc.ID;
              pojDocSectionContract.IPM_Section__c=secMst.Id;
              pojDocSectionContract.IPM_Section_Name__c = IPM_ConstantUtils.OTIF_STATUS;
              pojDocSectionContract.IPM_Gate_Document__c = IPM_Utils.Contract;
              insert pojDocSectionContract;
              projDocSecList=[SELECT ID,IPM_Default_Section__c,IPM_Project_Document__c,IPM_Section__c FROM IPM_Project_Document_Section__c WHERE ID=:pojDocSectionContract.ID LIMIT 1];
              System.assertEquals(projDocSecList[0].IPM_Section__c,secMst.Id,RECORD_NOT_CREATED_SUCCESSFULLY); //positive test 

              IPM_Project_Document_Section__c pojDocSectionMD = IPM_TestFactory_Helper.createIPMProjectDocumentSection(FALSE);
              pojDocSectionMD.IPM_Project_Document__c=projDoc.ID;
              pojDocSectionMD.IPM_Section__c=secMst.Id;
              pojDocSectionMD.IPM_Section_Name__c = IPM_ConstantUtils.OTIF_STATUS;
              pojDocSectionMD.IPM_Gate_Document__c = IPM_Utils.MarketDeployment;
              insert pojDocSectionMD;
              projDocSecList=[SELECT ID,IPM_Default_Section__c,IPM_Project_Document__c,IPM_Section__c FROM IPM_Project_Document_Section__c WHERE ID=:pojDocSectionMD.ID LIMIT 1];
              System.assertEquals(projDocSecList[0].IPM_Section__c,secMst.Id,RECORD_NOT_CREATED_SUCCESSFULLY); //positive test 
              
              IPM_Project_Document_Section__c pojDocSectionMR = IPM_TestFactory_Helper.createIPMProjectDocumentSection(FALSE);
              pojDocSectionMR.IPM_Project_Document__c=projDoc.ID;
              pojDocSectionMR.IPM_Section__c=secMst.Id;
              pojDocSectionMR.IPM_Section_Name__c = IPM_ConstantUtils.OTIF_STATUS;
              pojDocSectionMR.IPM_Gate_Document__c = IPM_Utils.MarketReady;
              insert pojDocSectionMR;
              projDocSecList=[SELECT ID,IPM_Section__c FROM IPM_Project_Document_Section__c WHERE ID=:pojDocSectionMR.ID LIMIT 1];           
              System.assertEquals(projDocSecList[0].IPM_Section__c,secMst.Id,RECORD_NOT_CREATED_SUCCESSFULLY); //positive test 

              List<IPM_Project_Document_Section_Content__c> pDSContectList = new List<IPM_Project_Document_Section_Content__c>(); 
              //  Creationg Project Document Sections Content   
              IPM_Project_Document_Section_Content__c pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSection.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.OTIF_CONCEPT_TEST;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = GREEN;              
              pDSContectList.add(pojDocSectionSectionCont);
              
              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSection.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.OTIF_SCOPING_COMPLETE;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = GREEN;              
              pDSContectList.add(pojDocSectionSectionCont);
              
              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSectionContract.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.OTIF_CUSTOMER_APPEAL;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = GREEN;
              pDSContectList.add(pojDocSectionSectionCont);
              
              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSectionContract.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.OTIF_CAPEX_APPROVED;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = GREEN;
              pDSContectList.add(pojDocSectionSectionCont);

              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSectionContract.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.OTIF_TECHNICAL_FEASIBILITY;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = GREEN;
              pDSContectList.add(pojDocSectionSectionCont);
              
              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSectionContract.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.OTIF_ATTRACTIVE_BUSINESS_CASE;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = GREEN;
              pDSContectList.add(pojDocSectionSectionCont);

              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSectionContract.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.OTIF_MATERIALS_SOURCING_STRATEGIES_AGREED;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = GREEN;
              pDSContectList.add(pojDocSectionSectionCont);
              
              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSectionContract.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.OTIF_TECHNICAL_ACTION_STANDARDS_ACHIEVED_BY_LEAD_REGION;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = GREEN;
              pDSContectList.add(pojDocSectionSectionCont);

              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSectionContract.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.CONTRACT_PRODUCT;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = GREEN;
              pDSContectList.add(pojDocSectionSectionCont);
              
              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSectionContract.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.CONTRACT_FULL_MIX;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = RED;
              pDSContectList.add(pojDocSectionSectionCont);
              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSectionContract.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.CONTRACT_COMMUNICATION;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = AMBER;
              pDSContectList.add(pojDocSectionSectionCont);
              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSectionContract.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.OTIF_BASES_I;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = GREEN;
              pDSContectList.add(pojDocSectionSectionCont);           
              
              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSectionMR.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.OTIF_COMMUNICATION_BET_FINAL_RELEASE_AVAILABILITY;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = GREEN;
              pDSContectList.add(pojDocSectionSectionCont);           
              
              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSectionMR.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.OTIF_TECHNICAL_AND_PRODUCTION_CAPABILITY_CONFIRMED;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = GREEN;
              pDSContectList.add(pojDocSectionSectionCont);

              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSectionMR.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.OTIF_SPEC_BILLS_OF_MATERIALS_IN_INTERSPEC;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = GREEN;
              pDSContectList.add(pojDocSectionSectionCont);

              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSectionMR.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.OTIF_TECH_PROD_CAPABILITY_CONF_MAIN_PLANT;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = GREEN;
              pDSContectList.add(pojDocSectionSectionCont);

              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSectionMR.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.OTIF_BASES_III;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = GREEN;
              pDSContectList.add(pojDocSectionSectionCont);

              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSectionMR.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.OTIF_COMMUNICATION_FULL_THINK_BIG_PACK_AVAILABLE;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = GREEN;
              pDSContectList.add(pojDocSectionSectionCont); 

              pojDocSectionSectionCont = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(FALSE);      
              pojDocSectionSectionCont.IPM_Project_Document_Section__c=pojDocSectionMD.ID;
              pojDocSectionSectionCont.IPM_OTIF_Measure__c = IPM_ConstantUtils.OTIF_FIRST_PROD_CONF_SPEC_FINALISED;
              pojDocSectionSectionCont.IPM_OTIF_Status__c = GREEN;
              pDSContectList.add(pojDocSectionSectionCont);           
              
              insert pDSContectList;
              List<IPM_Project_Document_Section_Content__c> projDocSecContList=[SELECT ID,IPM_Project_Document_Section__c,IPM_OTIF_Measure__c, IPM_OTIF_Status__c FROM IPM_Project_Document_Section_Content__c WHERE ID IN:pDSContectList LIMIT 100];   
              System.assertEquals(projDocSecContList.size(),19,RECORD_NOT_CREATED_SUCCESSFULLY); //positive test              
              for(IPM_Project_Document_Section_Content__c temp : projDocSecContList){
              	if(temp.IPM_OTIF_Measure__c == IPM_ConstantUtils.CONTRACT_COMMUNICATION){
              		system.assertEquals(temp.IPM_OTIF_Status__c, AMBER, RECORD_NOT_CREATED_SUCCESSFULLY);
              	}
              	if(temp.IPM_OTIF_Measure__c == IPM_ConstantUtils.CONTRACT_FULL_MIX){
              		system.assertEquals(temp.IPM_OTIF_Status__c, RED, RECORD_NOT_CREATED_SUCCESSFULLY);
              	}
              	if(temp.IPM_OTIF_Measure__c == IPM_ConstantUtils.CONTRACT_PRODUCT){
              		system.assertEquals(temp.IPM_OTIF_Status__c, GREEN, RECORD_NOT_CREATED_SUCCESSFULLY);
              	}
              }
                            
            }  
    }
    
    /**********************************************************************
    *  @Description: Test Method to initialize data for the other test methods
    *  @name : initializeData2
    *  @param : none
    *  @return : none
    *************************************************************************/
    static void initializeData2(){
        systemAdmin= IPM_TestFactory_Helper.createUserAdmin(false);
            system.runAs(systemAdmin){
                testUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);
                userList = IPM_TestFactory_Helper.createUserList(); 
                system.assertEquals(userList[0].LastName,IPMUSER_LASTNAME,'Error in User Creation');
            }
            
        system.runAs(testUser ){
         
        
        List<IPM_Project__c> globalprojectlist = new List<IPM_Project__c>();
            //Test project creation
            projectList = IPM_TestFactory_Helper.insertIPMProjectList();                      
            IPM_Project__c proj;          
            for(IPM_Project__c p:projectList){
                if(p.IPMProject_Span__c.equalsignorecase(IPM_Utils.valueGlobal)){
                    p.IPM_Project_Type__c = IPM_Utils.Original;
                    p.IPM_Category_Text__c = IPM_ConstantUtils.HHC_CONSTANT;
                    p.IPM_Project_Leader__c = testUser.Id;
                    proj = p;
                    globalprojectlist.add(p);                  
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
            
            list<IPM_Project__c> projectListtest = new list<IPM_Project__c>([SELECT id,Name FROM IPM_Project__c WHERE id IN:projectList Limit 100]);
            system.assertEquals(projectList[0].Name,projectListtest[0].Name,'Project Name Differs');
            
        // Create Regional Rollouts for Created Global project.
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,globalprojectlist,new List<User>{userList[1],userList[1],userList[1]});
            insert regionalRolloutList;
            
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
            List<IPM_Project_Rollout__c> rollout = [Select Id from IPM_Project_Rollout__c where IPM_Project__c =: proj.id limit 1];
            IPM_Financial__c finRegional = new IPM_Financial__c();      
            finRegional.Parent_Project__c = proj.Id;
            finRegional.IPM_Project_Rollout__c = rollout[0].id;
            finRegional.RecordTypeId = strRecordTypeConId;
            finRegional.Financial_External_ID__c = proj.name+IPM_Utils.CONSOLIDATED;
            finRegional.Target_Launch_Date__c = System.today()+100000;
            finList.add(finRegional);
            
            List<IPM_Project__c> ipmproj = [Select Id, Name from IPM_Project__c where IPM_Parent_Project__c =: proj.id and IPMProject_Span__c = 'Regional' limit 1];
            IPM_Financial__c finlocal = new IPM_Financial__c();
            finlocal.Parent_Project__c = ipmproj[0].id;
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
            //finYear1.Name = YEAR_1;
            finYear1.Year_Type__c = INNOVATION;
            finYear1.PL_type__C = GROSS;
            finYear1.NAME = YEAR_3;
            finYear1.Year__c = IPM_Utils.n3;         
            finYear.add(finYear1);
            IPM_Financial_Year__c finYear2 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear2.IPM_Financial__c= finList[0].Id;
            //finYear2.Name = YEAR_1;
            finYear2.NAME = YEAR_3;
            finYear2.Year__c = IPM_Utils.n3;             
            finYear2.Year_Type__c = INNOVATION;
            finYear2.PL_type__C = INCREMENTAL;
            finYear.add(finYear2);            
            IPM_Financial_Year__c finYear3 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear3.IPM_Financial__c= finList[0].Id;
            //finYear3.Name = YEAR_1;
            finYear3.Year_Type__c = CALENDAR;
            finYear3.NAME = YEAR_3;
            finYear3.Year__c = IPM_Utils.n3;                         
            finYear3.PL_type__C = GROSS;
            finYear.add(finYear3);            
            IPM_Financial_Year__c finYear4 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear4.IPM_Financial__c= finList[0].Id;
            //finYear4.Name = YEAR_1;
            finYear4.Year_Type__c = CALENDAR;
            finYear4.NAME = YEAR_3;
            finYear4.Year__c = IPM_Utils.n3;                         
            finYear4.PL_type__C = INCREMENTAL;
            finYear.add(finYear4);
            
            //For Local Rollouts
            IPM_Financial_Year__c finYear5 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear5.IPM_Financial__c= finList[1].Id;
//            finYear5.Name = YEAR_1;
            finYear5.NAME = YEAR_3;
            finYear5.Year__c = IPM_Utils.n3;
            finYear5.Year_Type__c = INNOVATION;
            finYear5.PL_type__C = GROSS;
            finYear.add(finYear5);
            IPM_Financial_Year__c finYear6 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear6.IPM_Financial__c= finList[1].Id;
            //finYear6.Name = YEAR_1;
            finYear6.NAME = YEAR_3;
            finYear6.Year__c = IPM_Utils.n3;         
            finYear6.year_type__c = INNOVATION;
            finYear6.PL_type__C = INCREMENTAL;
            finYear.add(finYear6);            
            IPM_Financial_Year__c finYear7 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear7.IPM_Financial__c= finList[1].Id;
            //finYear7.Name = YEAR_1;
            finYear7.NAME = YEAR_3;
            finYear7.Year__c = IPM_Utils.n3;         
            finYear7.year_type__c = CALENDAR;
            finYear7.PL_type__C = GROSS;
            finYear.add(finYear7);            
            IPM_Financial_Year__c finYear8 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finYear8.IPM_Financial__c= finList[1].Id;
            //finYear8.Name = YEAR_1;
            finYear8.NAME = YEAR_3;
            finYear8.Year__c = IPM_Utils.n3;
            finYear8.year_type__c = CALENDAR;
            finYear8.PL_type__C = INCREMENTAL;
            finYear.add(finYear8);
            insert finYear;         
             
            list<IPM_Financial_Year__c> insertedfinancialyrrolloutrecords = new list <IPM_Financial_Year__c> ([SELECT id,Name FROM IPM_Financial_Year__c WHERE id IN:finYear Limit 100]);
            system.assertEquals(insertedfinancialyrrolloutrecords[0].Name,finYear[0].Name,'FinancialYear Name differs');
        
        }
    }
        
     /**********************************************************************
    *  @Description: This method is used to execute the IPM_OTIF_Report_Batch 
                    job to copy project details to analytics object.
    *  @name : testOTIFreport1
    *  @param : none
    *  @return : none
    *************************************************************************/  
    static testMethod void testOTIFreport1() {  
        Test.startTest();    
        initializeData1();     
           
        system.runAs(testUser){
            string  query = 'SELECT Id,IPM_Global_ProjectId__c,Project_External_ID__c,Name,IPM_Parent_Project__r.Name,IPM_Parent_Project__r.Id,IPM_Project_Leader__r.Name,Deputy_Project_Leader__r.Name,IPM_Technical_Project_Leader__r.Name,IPM_Finance_Lead__r.Name,IPM_Rollout_Status__c,IPM_Category_Group__c,IPM_Category_Text__c,IPM_Phase__c,IPM_Brand_Positioning__c,IPMProject_Span__c, IPMProject_Type__c,Project_Countries__c,IPM_No_of_Country_Rollouts__c,IPM_Threshold_Value__c,IPM_Company_Card__r.Name,IPM_Cluster__c,Market_Cluster__c,Market_Cluster_Name__c,IPM_Clustering__c,IPM_Clusters__c,IPM_Answer_of_Q1__c, IPM_Answer_of_Q2__c, Exempt_from_Threshold__c, IPM_Answer_of_Q3__c,IPM_Strategic_Intent__c,IPM_Target_Launch_Year__c,IPM_Target_Launch_Month__c,IPM_Actual_Launch_Date__c, IPM_Actual_Launch_Month__c,IPM_Actual_Launch_Year__c,IPMPlatform__c,IPM_Project_Type__c,IPM_Project_Description__c,IPM_Target_Launch_Dates__c,IPM_Project_Rollout__c,IPM_Misalligned__c,CreatedDate,IPM_Project_Start_Date__c,IPM_Parent_Project__r.IPM_Project_Rollout__r.Target_Launch_Date__c,IPM_CPP__c,IPM_Fast_Track_Project__c,Is_Archieved__c,IPM_Global_OR_Regional__c,IPM_Project_Rollout__r.Target_Launch_Date__c, IPM_Project_Rollout__r.KeyMCO__c FROM IPM_Project__c'; 
            IPM_OTIF_Report_Batch  batchs = new IPM_OTIF_Report_Batch(query); 
            database.executebatch(batchs,100);
        }       
 
        Test.stopTest();
        List<IPM_Analytics_OTIF__c> otifList = [Select Id,Name from IPM_Analytics_OTIF__c limit 50000];
        system.assertequals(otifList.size(),4,'OTIF Records Size 4');            
                         
    }
    
     /**********************************************************************
    *  @Description: This method is used to execute the IPM_OTIF_Report_Batch 
                    job to copy project details to analytics object.
    *  @name : testOTIFreport2
    *  @param : none
    *  @return : none
    *************************************************************************/  
        static testMethod void testOTIFreport2() { 
        initializeData2();   
        Test.startTest();         
        system.runAs(testUser){
            string  query = 'SELECT Id,IPM_Global_ProjectId__c,Project_External_ID__c,Name,IPM_Parent_Project__r.Name,IPM_Parent_Project__r.Id,IPM_Project_Leader__r.Name,Deputy_Project_Leader__r.Name,IPM_Technical_Project_Leader__r.Name,IPM_Finance_Lead__r.Name,IPM_Rollout_Status__c,IPM_Category_Group__c,IPM_Category_Text__c,IPM_Phase__c,IPM_Brand_Positioning__c,IPMProject_Span__c, IPMProject_Type__c,Project_Countries__c,IPM_No_of_Country_Rollouts__c,IPM_Threshold_Value__c,IPM_Company_Card__r.Name,IPM_Cluster__c,Market_Cluster__c,Market_Cluster_Name__c,IPM_Clustering__c,IPM_Clusters__c,IPM_Answer_of_Q1__c, IPM_Answer_of_Q2__c, Exempt_from_Threshold__c, IPM_Answer_of_Q3__c,IPM_Strategic_Intent__c,IPM_Target_Launch_Year__c,IPM_Target_Launch_Month__c,IPM_Actual_Launch_Date__c, IPM_Actual_Launch_Month__c,IPM_Actual_Launch_Year__c,IPMPlatform__c,IPM_Project_Type__c,IPM_Project_Description__c,IPM_Target_Launch_Dates__c,IPM_Project_Rollout__c,IPM_Misalligned__c,CreatedDate,IPM_Project_Start_Date__c,IPM_Parent_Project__r.IPM_Project_Rollout__r.Target_Launch_Date__c,IPM_CPP__c,IPM_Fast_Track_Project__c,Is_Archieved__c,IPM_Global_OR_Regional__c,IPM_Project_Rollout__r.Target_Launch_Date__c, IPM_Project_Rollout__r.KeyMCO__c FROM IPM_Project__c'; 
            IPM_OTIF_Report_Batch  batch = new IPM_OTIF_Report_Batch(query); 
            database.executebatch(batch,100);
            
        }                   
        Test.stopTest();
        List<IPM_Analytics_OTIF__c> otifList = [Select Id,Name from IPM_Analytics_OTIF__c limit 50000];
        system.assertequals(otifList.size(),7,'OTIF Records Size 7');
    }
    
    
}