/*******************************************************
 * @Description: Test class for IPM_Gate_RollOuts_Controller
 * @Author:Cognizant
 * @Date:05/08/2015
 * *****************************************************/

@isTest
public class IPM_Gate_RollOuts_Controller_Test{

    public static IPM_Project__c project;
    public static IPM_Project_Rollout__c projRoll;
    public static IPM_Project_Rollout__c projLocalRoll;
    public static list<IPM_Country__c> countryList;
    public static mdm_Geography__c masterCountry;
    
    public static IPM_Document_Template__c ipdt;
    public static IPM_Project_Template__c projTempl;
    public static IPM_Section__c secMst;
    
    public static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Document_Section__c projDocSec;
    
    public static IPM_Project__c projectRecord;
    public static IPM_Project_Rollout__c projRollOut;
    public static IPM_Project_Rollout__c localRollout;
    public static mdm_Geography__c mstCountry;
    public static IPM_Country__c country;
    public static IPM_Project_Template__c projTemplate;
    public static IPM_Document_Template__c ipdoctem;
    public static IPM_Section__c secMast;
    public static IPM_Project_Document__c projDocument;
    public static IPM_Project_Document_Section__c pojDocSection;
    public static User testUser;
    
    /*String replaced for duplicate literals*/
    public static final string COUNTRY_STR = 'Australia';
    public static final string LEADER_STR = 'Leader';
    public static final string ANZ_STR = 'ANZ';
    
    /*******************************************************
     * @Description: Method to initilize data
     * *****************************************************/
    static void initializeData(){
        
        //Creation test user
           	Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
     
        testUser = IPM_TestFactory_Helper.createUser(FALSE);
        testUser.ProfileId = p.Id; 
        insert testUser;
        
        //IPM_Project__c projectRecord=new IPM_Project__c();
        projectRecord = IPM_TestFactory_Helper.createIPMProject(FALSE);
        insert projectRecord;
        
        List<IPM_Project__c> projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectRecord.ID ];
        
        project=projlList[0];
        System.assertEquals(projlList.size(), 1);
        
        
        //IPM_Project_Rollout__c projRollOut=new IPM_Project_Rollout__c();
        projRollOut= IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
        projRollOut.IPM_Project__c=project.ID;
        projRollOut.IPM_Rollout_Project__c='TestRollouts_SEAA';
        projRollOut.IPM_Status__c= LEADER_STR;
        projRollOut.IPM_Regional_PL__c=testUser.id;
        
        insert projRollOut;
        List<IPM_Project_Rollout__c> projRollOutList=[SELECT ID,RecordTypeId,IPM_Rollout_Project__c,Market_Cluster__c,Target_Launch_Date__c,IPM_Regional_PL__c FROM IPM_Project_Rollout__c WHERE ID=:projRollOut.ID ];
        
        projRoll=projRollOutList[0];
        System.assertEquals(projRollOutList.size(), 1);
        
        //IPM_Project_Rollout__c localRollout=new IPM_Project_Rollout__c();
        localRollout = IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
        localRollout.IPM_Project__c=project.Id;
        localRollout.Name='TestRollouts_SEAA_ANZ';
        localRollout.IPM_Rollout_Project__c='TestRollouts_SEAA_ANZ';
        localRollout.RecordTypeId=Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get('Local Rollouts').RecordTypeId;
        localRollout.IPM_Status__c= LEADER_STR;
        localRollout.Regional_Rollout__c=projRollOut.Id;
        localRollout.Type__c='MCO';
        localRollout.Market_Cluster__c='GEO0022';
        localRollout.MCO__c='LV4_GEO0041';
        
        insert localRollout;
        List<IPM_Project_Rollout__c> projLocalRollOutList=[SELECT ID,RecordTypeId,IPM_Rollout_Project__c,Market_Cluster__c,Target_Launch_Date__c,IPM_Regional_PL__c FROM IPM_Project_Rollout__c WHERE ID=:localRollout.ID ];
        
        projLocalRoll=projLocalRollOutList[0];
        System.assertEquals(projLocalRollOutList.size(), 1);
        
        //mdm_Geography__c mstCountry=new mdm_Geography__c();
        mstCountry =  IPM_TestFactory_Helper.createGeography(FALSE);
        mstCountry.Unilever_Cluster__c='SEAA';
        mstCountry.Country_Cluster__c=ANZ_STR;
        mstCountry.World__c='World';
        mstCountry.Country_Cluster_Code__c='GEO0041';
        mstCountry.UN_Independent_Country__c=COUNTRY_STR;
        mstCountry.ISO_3166_1_Num_Code__c='036';
        mstCountry.Region__c='Asia/RAM';
        mstCountry.Country_Group__c=ANZ_STR;
        mstCountry.ISO_Country_Dependency_Name__c=COUNTRY_STR;
        mstCountry.ISO_Country_Dependency_Medium_Name__c=COUNTRY_STR;
        mstCountry.Market_Type__c='Developed';
        mstCountry.ISO_3166_1_Code__c='AU';
        mstCountry.Region_Code__c='GEO0003';
        mstCountry.Country_Sub_Group_Name__c=ANZ_STR;
        mstCountry.Country_Sub_Group_Code__c='LV5_GEO0041';
        mstCountry.ISO_3166_1_Alpha_Code__c='AUS';
        mstCountry.World_Code__c='GEO0001';
        mstCountry.Country_Group_Code__c='LV4_GEO0041';
        mstCountry.Unilever_Cluster_Code__c='GEO0022';
        mstCountry.ISO_Country_Dependency_Office_EN_Name__c=COUNTRY_STR;
        mstCountry.Market_Type_Code__c='D001';
        mstCountry.ISO_Country_Dependency_Short_Name__c=COUNTRY_STR;
        mstCountry.ISO_Country_Dependency_Code__c='UIM00020';
        mstCountry.Name='id';
        insert mstCountry;
        
        List<mdm_Geography__c> mstCountrylist=[Select Id,Name From mdm_Geography__c where id=:mstCountry.id ];
        masterCountry=mstCountrylist[0];
        masterCountry.Name=masterCountry.id;
        system.assertEquals(mstCountrylist.size(),1);
        
        update masterCountry;
        
    /*    IPM_Country__c country=new IPM_Country__c(IPM_Project__c=project.Id,
                                                   Local_Rollout__c=projLocalRoll.Id,
                                                   Project_Country__c='TestRollouts_SEAA_AU',
                                                   IPM_Rollout_Status__c='With MCO',
                                                   Geography__c=masterCountry.id); */
        
        country =  IPM_TestFactory_Helper.createIPMCountry(FALSE);
        country.IPM_Project__c=project.Id;
        country.Local_Rollout__c=projLocalRoll.Id;
        country.Project_Country__c='TestRollouts_SEAA_AU';
        country.IPM_Rollout_Status__c='With MCO';
        country.Geography__c=masterCountry.id;
        insert country;    
    }
    
     /*******************************************************
     * @Description: Method to initilize gate document data
     * *****************************************************/
    static void initializeGDData(){
                
         initializeData();
         //creating Project Template
        //IPM_Project_Template__c projTemplate=new IPM_Project_Template__c();
        projTemplate = IPM_TestFactory_Helper.createIPMProjectTemplate(TRUE);
        
        List<IPM_Project_Template__c> projTemplList=[SELECT ID,IPM_Template_Complexity__c FROM IPM_Project_Template__c WHERE ID=:projTemplate.ID];
       
        projTempl=projTemplList[0];        
        System.assertEquals(projTempl.IPM_Template_Complexity__c, 'Full');
        
        //Creating Document Template
        //IPM_Document_Template__c ipdoctem=new IPM_Document_Template__c();
        ipdoctem = IPM_TestFactory_Helper.creteIPMDocumentTemplate(FALSE);
        ipdoctem.IPM_Project_Template__c=projTempl.ID;
        insert ipdoctem;
        
        List<IPM_Document_Template__c> projDocTemplList=[SELECT ID,IPM_Project_Template__c,IPM_Document_Template_Name__c,IPM_Document_Type__c FROM IPM_Document_Template__c WHERE ID=:ipdoctem.ID ];
        ipdt=projDocTemplList[0];
        
        System.assertEquals(projDocTemplList.size(), 1);
        
        //Creating master Section
        //IPM_Section__c secMast=new IPM_Section__c();
        secMast = IPM_TestFactory_Helper.createIPMSection(FALSE);
        secMast.IPM_Document_Template__c=ipdt.ID;
        secMast.IPM_Section_Type__c='Text';        
        insert secMast;
        
        List<IPM_Section__c> projSecMstlList=[SELECT ID,IPM_Document_Template__c,IPM_Section_Sequence__c,IPM_Section_Name__c FROM IPM_Section__c WHERE ID=:secMast.ID ];
        secMst=projSecMstlList[0];
        System.assertEquals(projSecMstlList.size(), 1);
    
        //IPM_Project_Document__c projDocument=new IPM_Project_Document__c();
        projDocument = IPM_TestFactory_Helper.createIPMProjectDocument(FALSE);
        projDocument.IPM_Project__c=project.ID;
        projDocument.IPM_Project_Template__c= projTempl.Id;  
        insert projDocument;
        
        projDocList=[SELECT IPM_GateDocuments__c,IPM_Project__c,IPM_Project_Template__c,IPM_Contract_GateKeeper_Model__c FROM IPM_Project_Document__c WHERE ID=:projDocument.ID];
        projDoc=projDocList[0];
        System.assertEquals(projDocList.size(), 1);
        
        // Creationg Project Document Sections
        //IPM_Project_Document_Section__c pojDocSection=new IPM_Project_Document_Section__c();
        pojDocSection = IPM_TestFactory_Helper.createIPMProjectDocumentSection(FALSE);
        pojDocSection.IPM_Project_Document__c=projDoc.ID;
        pojDocSection.IPM_Section__c=secMst.Id;
        insert pojDocSection;
        
        List<IPM_Project_Document_Section__c> projDocSecList=[SELECT ID,IPM_Default_Section__c,IPM_Project_Document__c,IPM_Section__c FROM IPM_Project_Document_Section__c WHERE ID=:pojDocSection.ID];
        projDocSec=projDocSecList[0];
        System.assertEquals(projDocSecList.size(), 1);
    }
    
     /*******************************************************
     * @Description: Method to invoke the constructor
     * *****************************************************/
    public static testMethod void getRollouts(){
        
        Test.startTest();
        initializeData();
        PageReference pRef =Page.IPM_GATEDOCUMENT;
        pRef.getParameters().put('id',project.Id);
        Test.setCurrentPage(pRef);
        
        IPM_Gate_RollOuts_Controller rollOutController = new IPM_Gate_RollOuts_Controller ();
        rollOutController.proId=project.Id;
        //system.assertEquals(rollOutController.ipm_countries.size(),1); 
        //System.assert(rollOutController.regionalRollOutWrapperList.size() > 0);
        Test.stopTest();
    }
    
    /*******************************************************
     * @Description: Method to invoke the second constructor
     * *****************************************************/
     public static testMethod void getGateRollouts(){
     	Test.startTest();
        initializeData();
        PageReference pRef =Page.IPM_GATEDOCUMENT;
        pRef.getParameters().put('id',project.Id); 
        Test.setCurrentPage(pRef);
        IPM_Gate_RollOuts_Controller rollOutController = new IPM_Gate_RollOuts_Controller ();
        //IPM_Gate_RollOuts_Controller rollOutSecondController = new IPM_Gate_RollOuts_Controller (gdc);
        //rollOutSecondController.proId=project.Id;
        //System.assert(rollOutSecondController.regionalRollOutWrapperList.size() > 0);
        //system.assertEquals(rollOutSecondController.ipm_countries.size(),1);      
        Test.stopTest();
     }
}