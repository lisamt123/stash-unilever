/**
* @author       Cognizant 
* @date         7/11/2016
* @description  This class is used to test the functionality of IPM_SourcePlanController class 
*/
@isTest
private class IPM_SourcePlanController_Test{
    private static List<IPM_SourcingUnit__c> sourcingUt = new List<IPM_SourcingUnit__c>();
    private static final string GLOBAL_PL_EMAIL_ID = 'globalProjectLeader@unilever.com.test';
    private static final string REGIONAL_PL_EMAIL_ID = 'regionalProjectLeader@unilever.com.test';
    private static final string LOCAL_PL_EMAIL_ID = 'localProjectLeader@unilever.com.test';
    private static Set<String> projectNameSet = new Set<String>{'GKM3TestComments1'};
    private static PageReference  pRef;
   
    /*******************************************************************************************************
    * @description  Test Method to initialize data for test methods
    * @name : initializeData
    * @param : void
    * @return :void
    */
    @testSetup public static void initializeData()
    {   
        User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
        Test.startTest();
        
        List<User> userList = new List<User>();
        System.runAs(adminUser)
        {   
            User globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
            globalProjectLeader.email = GLOBAL_PL_EMAIL_ID;

            User regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
            regionalProjectLeader.email = REGIONAL_PL_EMAIL_ID;

            User localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
            localProjectLeader.email = LOCAL_PL_EMAIL_ID;

            userList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader};

            update userList;
        } 
        
        List<String> emailList = new List<String>{GLOBAL_PL_EMAIL_ID,REGIONAL_PL_EMAIL_ID,LOCAL_PL_EMAIL_ID}; 
        User globalProjectLeader =null; User regionalProjectLeader =null;  User localProjectLeader =null;
        
        for(User linkedUser : [Select Id,email from User where email in :emailList]){
            if(linkedUser.email == GLOBAL_PL_EMAIL_ID){
                globalProjectLeader = linkedUser;
            }else if(linkedUser.email == REGIONAL_PL_EMAIL_ID){
                regionalProjectLeader = linkedUser;
            }else{
                localProjectLeader = linkedUser;
            }
        }   
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCardGKM3 = IPM_TestFactory_Helper.createGKM3GlobalCompanyCard(false);
        IPM_Company_Card__c localCompanyCardGKM3 = IPM_TestFactory_Helper.createGKM3LocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCardGKM3,localCompanyCardGKM3};
        insert companyCardList;
         
        IPM_TestFactory_Helper.getProjectMasterDataForGKM3();
        
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader}); 
        
        
        System.runAs(globalProjectLeader)
        {
            List<IPM_Project__c> projectListGKM3 = IPM_TestFactory_Helper.projectSetUpGKM3(1,globalProjectLeader);
            insert projectListGKM3;
            
         

            
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectListGKM3,new List<User>{userList[1],userList[1],userList[1]});
            
            insert regionalRolloutList;

            system.assert(regionalRolloutList.size()>0, 'project rollout cannot be created'); //names cannot be asserted as project name set in helper class
            
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

            set<Id> setIds = new set<Id>();  
 
            // Create local Rollouts for Created regional Rollouts.
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{localProjectLeader});  
            
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                localRollout.KeyMCO__c = true;
                localRollout.IPM_Regional_PL__c = localProjectLeader.Id;
                localRollout.Target_Launch_Date__c = System.today().addMonths(10); //To cover 2523 line
                localRollout.Previous_Target_Launch_Date__c = System.today().addMonths(9); //To cover 2523 line
                setIds.add(localRollout.id);
            } 

            insert localRolloutList; 

            system.assertEquals(localRolloutList.size(), 2,'project rollout map cannot be created'); //names cannot be asserted as project and rollout map set in helper class
            
            //assert preparation
            list<IPM_Project_Rollout__c> selRolloutList = [select KeyMCO__c, IPM_Regional_PL__c, IPM_Project_Job_Status__c, IPM_RolloutJobType__c, Target_Launch_Date__c, Previous_Target_Launch_Date__c from IPM_Project_Rollout__c where id in :setIds];
            for(IPM_Project_Rollout__c localRollout : selRolloutList)
            {
                system.assertEquals(localRollout.KeyMCO__c, true, 'Key MCO  is false');
                system.assertEquals(localRollout.IPM_Regional_PL__c, localProjectLeader.Id, 'Regional PL is null');
                system.assertEquals(localRollout.IPM_Project_Job_Status__c, IPM_ConstantUtils.JOB_STATUS_ELIGIBLE, 'Job Status not eligible found');
                system.assertEquals(localRollout.Previous_Target_Launch_Date__c, System.today(), 'target lanuch date is not today'); //To cover 2523 line
            }

            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>(); 
            createMDOData();
            list<mdo_Geography__c> allMdoCountry = new list<mdo_Geography__c>();
            map<string,id> geoIdWithCode =  new map<string,id>();//map of geo code and recor id
            allMdoCountry =[select ISO_3166_1_Code__c from mdo_Geography__c LIMIT 2];
            for(mdo_Geography__c ctrs : allMdoCountry){
            	geoIdWithCode.put(ctrs.ISO_3166_1_Code__c,ctrs.id);
            }
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                String geoExternalId = IPM_ConstantUtils.BLANK; 
                
                if(localRollout.IPM_Rollout_Project__c.contains('AFR'))
                {
                    geoExternalId = 'AO';
                    
                }
                else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
                {
                    geoExternalId = 'BR';
                    
                }
                
                IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = geoIdWithCode.get(geoExternalId),
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
                
                countryList.add(tempCountry);
            }
            
            insert countryList;

            //assert on counti is sufficient, additional soql can be a risk for SOQL gov limit as this method has loads of queries.
            system.assert(countryList.size()>0, 'country records not created');
            

            
            insertSourcingUnit();

            system.assert(sourcingUt.size()>0, ' Sourcing Records not created');
            
            test.stopTest();
        }        
     
    }
    
    public static testMethod void projectPhaseChange(){
        
        List<String> emailList = new List<String>{GLOBAL_PL_EMAIL_ID,REGIONAL_PL_EMAIL_ID,LOCAL_PL_EMAIL_ID};
            
        User globalProjectLeader =null; User regionalProjectLeader =null;  User localProjectLeader =null;
        for(User linkedUser : [Select Id,email from User where email in :emailList])
        {
            if(linkedUser.email == GLOBAL_PL_EMAIL_ID)
            {
                globalProjectLeader = linkedUser;
            }
            else if(linkedUser.email == REGIONAL_PL_EMAIL_ID)
            {
                regionalProjectLeader = linkedUser;
            }
            else
            {
                localProjectLeader = linkedUser;
            }
        }          
        
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader}); 
         
        System.runAs(globalProjectLeader){       
            Test.startTest();
            
            Id locallRecordType = Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).RecordTypeId;
            IPM_Project__c globalOriginal = [select id, name, IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c, BI__c, 
                IPM_Target_Launch_Dates__c, IPM_Phase__c, IPM_ProjectGKM__c, IPM_GateKeeping_Model__c, IPM_CompanyCardText__c,
                (Select Id,Name,recordTypeId, IPM_Regional_PL__c,IPM_Project_Job_Status__c, IPM_RolloutJobType__c from IPM_Project_Rollout__r where recordTypeId =:locallRecordType )  
                FROM IPM_Project__c where IPMProject_Span__c='Global' and IPM_Project_Type__c='Original' and Name='GKM3TestComments1' limit 1];

            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChangeForGKM3(new List<Id>{globalOriginal.Id},globalProjectLeader); 
              
            update projectListPhaseChange;
            Test.stopTest(); 
            List<IPM_Project__c> project = [Select Id, Name, IPM_Phase__c, IPM_Project_Job_Status__c, (Select Id from Project_Documents__r),
                                           (Select Id from IPM_Financials_Consolidated__r) from IPM_Project__c WHERE name in :projectNameSet Limit 1];
            
            
            System.assertEquals(project[0].IPM_Phase__c, 'Feasibility','Phase not changed');
            System.assertEquals(project[0].IPM_Project_Job_Status__c, 'Completed','Job not Completed');
            System.assertEquals(project[0].Project_Documents__r.size(), 3,'Documents not created');
            System.assertEquals(project[0].IPM_Financials_Consolidated__r.size(), 3,'Financial not created');
            
        }        
    }
    
   
    // To initiate the constructor and Create a record in table
    public static testMethod void doTest2(){
        List<String> emailList = new List<String>{GLOBAL_PL_EMAIL_ID,REGIONAL_PL_EMAIL_ID,LOCAL_PL_EMAIL_ID};
            
        User globalProjectLeader =null; User regionalProjectLeader =null;  User localProjectLeader =null;
        for(User linkedUser : [Select Id,email from User where email in :emailList])
        {
            if(linkedUser.email == GLOBAL_PL_EMAIL_ID)
            {
                globalProjectLeader = linkedUser;
            }
            else if(linkedUser.email == REGIONAL_PL_EMAIL_ID)
            {
                regionalProjectLeader = linkedUser;
            }
            else
            {
                localProjectLeader = linkedUser;
            }
        }
        
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader}); 
        System.runAs(globalProjectLeader){ 
            Test.startTest();
            IPM_Project__c prj = [Select Id, Name, IPM_Phase__c, IPM_Project_Job_Status__c, (Select Id from Project_Documents__r),
                                           (Select Id from IPM_Financials_Consolidated__r) from IPM_Project__c WHERE name in :projectNameSet Limit 1];
            
	    ApexPages.currentPage().getParameters().put('Id', prj.Id);                      
            IPM_SourcePlanController srcPlanController = new IPM_SourcePlanController();
            srcPlanController.getSourceUnit();
             
             
             for(IPM_SourcePlanController.sourcePlanWrapper sourceC: srcPlanController.sourcePlanMap.values()){
                sourceC.readModeRow = true; 
                sourceC.productPlan.IPM_Format__c = 'format1';
	            sourceC.productPlan.IPM_Formulation__c = 'formulation1';
	            sourceC.productPlan.IPM_GoldenPrototype__c = true;
	            sourceC.productPlan.IPM_Of_gTO__c = 2;
	            sourceC.productPlan.IPM_Packing__c = 'kg';
	            sourceC.productPlan.IPM_ProductSize__c = 10.0;
	            sourceC.productPlan.IPM_Product_Name__c = 'name1';
	            sourceC.productPlan.IPM_Project__c = prj.id;
	            sourceC.countryStr = 'Brazil;';
             }
             srcPlanController.row_Index = 0;
            
             srcPlanController.saveRow();
             list<IPM_SourcePlanController.sourceUnitWrapper> srcUnitList = new list<IPM_SourcePlanController.sourceUnitWrapper>();
             srcUnitList = srcPlanController.sourceUnitMap.get(0); 
             for(IPM_SourcePlanController.sourceUnitWrapper srcUnitClass:srcUnitList){ 
             	srcUnitClass.sourcingPlan.IPM_SourcingUnit__c = 'Test0';
             	srcUnitClass.sourceCountries = 'Brazil;';
             }
              
             srcPlanController.sourceUnitMap.put(0,srcUnitList);
             srcPlanController.saveRow();
             
             for(IPM_SourcePlanController.sourceUnitWrapper srcUnitClass:srcUnitList){ 
             	srcUnitClass.sourcingPlan.IPM_SourcingUnit__c = 'Test0';
             	srcUnitClass.sourceCountries = '';
             }
              
             srcPlanController.sourceUnitMap.put(0,srcUnitList);
             srcPlanController.saveRow();
             
             List<IPM_ProductPlan__c> productPlanList = [SELECT name, IPM_Country__r.Country_Name__c FROM IPM_ProductPlan__c WHERE IPM_Project_Product__r.IPM_Project__c =:prj.id ];
             
             system.assert(productPlanList.size()>0, 'Product Plan was not saved');
             
            
             srcPlanController.addNewSourcePlanRow();
             
             system.assert(srcUnitList.size()>0, 'Did not add the source unit');
             
             // Remove Source Unit 
            srcPlanController.removeSourceUnit();
            system.assert(srcUnitList.size()>0, 'Did not add the source unit');
            
            srcPlanController.updateSourcinngUnit();
            srcPlanController.editModeRow();
            
             srcPlanController.cloneProjectProduct();
             for(IPM_SourcePlanController.sourcePlanWrapper sourceC: srcPlanController.sourcePlanMap.values()){
                sourceC.readModeRow = true; 
                sourceC.productPlan.IPM_Format__c = 'format2';
	            sourceC.productPlan.IPM_Formulation__c = 'formulation2';
	            sourceC.productPlan.IPM_GoldenPrototype__c = true;
	            sourceC.productPlan.IPM_Of_gTO__c = 2;
	            sourceC.productPlan.IPM_Packing__c = 'kg';
	            sourceC.productPlan.IPM_ProductSize__c = 10.0;
	            sourceC.productPlan.IPM_Product_Name__c = 'name2';
	            sourceC.productPlan.IPM_Project__c = prj.id;
	            sourceC.countryStr = 'Brazil;';
             }
             srcPlanController.row_Index = 1;
             srcPlanController.saveEditModeRowData();
            // srcPlanController.saveRow();
             srcPlanController.editModeRowAfterSave(srcPlanController.row_Index);
             srcPlanController.editModeRow();
             
             
             srcPlanController.cloneProjectProductAfterSave(0);
             srcPlanController.getSourcedinto();
             srcPlanController.updateCapabilityForSourcingUnit();
             srcPlanController.deleteProduct();
             srcPlanController.createProjectProductOnLoad();
             
            
             Test.stopTest();
        }      
    }
    
    private static void createMDOData(){
    	 //create mdo geography records for master data
            list<mdo_Geography__c> mdoGeoList =  new list<mdo_Geography__c>();
            mdo_Geography__c mdoGeoOne = new mdo_Geography__c();
            mdoGeoOne.name =  'Angola';
            mdoGeoOne.ISO_3166_1_Code__c = 'AO';
            mdoGeoOne.geography_type__c = 'Country';
            mdoGeoOne.mdm_id__c = 'AO';
            mdoGeoList.add(mdoGeoOne);
            mdo_Geography__c mdoGeoTwo = new mdo_Geography__c();
            mdoGeoTwo.name =  'Brazil';
            mdoGeoTwo.ISO_3166_1_Code__c = 'BR';
            mdoGeoTwo.geography_type__c = 'Country';
            mdoGeoTwo.mdm_id__c = 'BR';
            mdoGeoList.add(mdoGeoTwo);
            insert mdoGeoList;
    }
    
           private static void insertSourcingUnit(){
            	            // Inserting Data into IPM_SourcingUnit__c
            for(Integer i = 0; i<5;i++){
                IPM_SourcingUnit__c su = new IPM_SourcingUnit__c();
                su.Source_Unit_Name__c = 'Test'+i;
                su.Status__c = true;
                sourcingUt.add(su);
            }
            
            insert sourcingUt;
            }
            
	    public static testMethod void testProductSourcingPlan(){
    	List<IPM_SourcingPlan__c> lstSourcingPlan = new List<IPM_SourcingPlan__c>();  
    	List<IPM_SourcingUnit__c> lstSourcingUnit = new List<IPM_SourcingUnit__c>();  	
	    List<String> emailList = new List<String>{GLOBAL_PL_EMAIL_ID,REGIONAL_PL_EMAIL_ID,LOCAL_PL_EMAIL_ID};
	        
	    User globalProjectLeader =null; User regionalProjectLeader =null;  User localProjectLeader =null;
	    for(User linkedUser : [Select Id,email from User where email in :emailList])
	    {
	        if(linkedUser.email == GLOBAL_PL_EMAIL_ID)
	        {
	            globalProjectLeader = linkedUser;
	        }
	        else if(linkedUser.email == REGIONAL_PL_EMAIL_ID)
	        {
	            regionalProjectLeader = linkedUser;
	        }
	        else
	        {
	            localProjectLeader = linkedUser;
	        }
	    }
	    
	    IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader}); 
	    System.runAs(globalProjectLeader){ 
	        Test.startTest();
	        IPM_Project__c prj = [Select Id, Name, IPM_Phase__c, IPM_Project_Job_Status__c, (Select Id from Project_Documents__r),
	                                       (Select Id from IPM_Financials_Consolidated__r) from IPM_Project__c WHERE name in :projectNameSet Limit 1];
	                                       
	        IPM_Project_Product__c oProjectProduct = new IPM_Project_Product__c();
	        oProjectProduct.IPM_Project__c = prj.Id;
	        oProjectProduct.IPM_Product_Name__c = 'Test Project Product';
	        oProjectProduct.IPM_Format__c = 'Format';
	        oProjectProduct.IPM_Formulation__c = 'Formulation';
	        oProjectProduct.IPM_Packing__c='Packaging';
	        oProjectProduct.IPM_ProductSize__c=12;
	        oProjectProduct.IPM_ProductSizeMetrics__c='kg';
	        oProjectProduct.IPM_GoldenPrototype__c=false;
	        oProjectProduct.IPM_Of_gTO__c=12;        
	        insert oProjectProduct;
	        
	        system.assert(oProjectProduct.id != null, 'Project product was not saved');
	       	
	       	IPM_SourcingUnit__c oSourcingUnit1 = new IPM_SourcingUnit__c();
	        oSourcingUnit1.Category__c = 'Deodorants & Fragrances';
	        oSourcingUnit1.Source_Unit_Name__c = 'AeroBRZ / Aguai';
	        oSourcingUnit1.Status__c = true;	
	        lstSourcingUnit.add(oSourcingUnit1);        
	        
	        IPM_SourcingUnit__c oSourcingUnit2 = new IPM_SourcingUnit__c();
	        oSourcingUnit2.Category__c = 'Deodorants & Fragrances';
	        oSourcingUnit2.Source_Unit_Name__c = 'AeroAsia / Khamgaon';
	        oSourcingUnit2.Status__c = true;	
	        lstSourcingUnit.add(oSourcingUnit2); 
	        
	        IPM_SourcingUnit__c oSourcingUnit3 = new IPM_SourcingUnit__c();
	        oSourcingUnit3.Category__c = 'Hair Care; Skin Care; Skin Cleansing';
	        oSourcingUnit3.Source_Unit_Name__c = 'Bydgoszcz';
	        oSourcingUnit3.Status__c = true;	
	        lstSourcingUnit.add(oSourcingUnit3); 
	        
	        insert lstSourcingUnit;	    
	        
	        lstSourcingUnit = [Select ID,Source_Unit_Name__c From IPM_SourcingUnit__c limit 10];
	            
	        system.assert(lstSourcingUnit.size() > 0, 'Sourcing unit was not saved');
	        
	        IPM_ProductPlan__c oProductPlan = new IPM_ProductPlan__c();
	        oProductPlan.IPM_Project_Product__c=oProjectProduct.Id;
	        insert oProductPlan;
	        system.assert(oProductPlan.id != null, 'Product plan was not saved');
	        
	        IPM_SourcingPlan__c oSourcingPlan = new IPM_SourcingPlan__c();
	        oSourcingPlan.IPM_SourcingUnit__c = lstSourcingUnit[2].Source_Unit_Name__c;
	        oSourcingPlan.IPM_Sourcing_Unit__c = lstSourcingUnit[2].id ;
	        oSourcingPlan.IPM_ProductPlan__c = oProductPlan.Id;
	        lstSourcingPlan.add(oSourcingPlan);	        
	        
	        List<IPM_Country__c> lstCountry = [Select ID From IPM_Country__c limit 10]; 
	        List<IPM_ProductPlan__c> lstProductPlan = new List<IPM_ProductPlan__c>();
	        
	        for(IPM_Country__c oCountry : lstCountry)
	        {
	        	IPM_ProductPlan__c objProductPlan = new IPM_ProductPlan__c();
	        	objProductPlan.IPM_Project_Product__c=oProjectProduct.Id;
	        	objProductPlan.IPM_Country__c = oCountry.Id;
	        	lstProductPlan.add(objProductPlan);
	        }
	        
	        List<Database.saveResult> lstResults = Database.Insert(lstProductPlan);
	        
	        
	        for (Integer i = 0; i < lstResults.size(); i++) {
	        	IPM_SourcingPlan__c objSourcingPlan = new IPM_SourcingPlan__c();
		        objSourcingPlan.IPM_SourcingUnit__c = lstSourcingUnit[i].Source_Unit_Name__c;
		        objSourcingPlan.IPM_Sourcing_Unit__c = lstSourcingUnit[i].id ;
		        objSourcingPlan.IPM_ProductPlan__c = oProductPlan.Id;
		        lstSourcingPlan.add(objSourcingPlan);       
	        }
	        
	        Insert lstSourcingPlan;
	        
            Test.setCurrentPageReference(new PageReference('Page.IPM_Product_and_Sourcing_Plan')); 
            System.currentPageReference().getParameters().put(IPM_ConstantUtils.SF_ID, prj.Id);
            IPM_SourcePlanController srcPlanController = new IPM_SourcePlanController();
            srcPlanController.createProjectProductOnLoad();
            
            lstSourcingUnit[0].Source_Unit_Name__c = 'test1';
            update lstSourcingUnit[0];
            
            lstSourcingUnit = [Select ID From IPM_SourcingUnit__c Where Source_Unit_Name__c = 'test1'];
            System.assert(lstSourcingUnit.size()>0,'Failed to update sourcing unit');
            Test.stopTest();
	    }
    }
}