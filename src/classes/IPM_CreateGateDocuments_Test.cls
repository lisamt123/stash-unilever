@isTest
public class IPM_CreateGateDocuments_Test {
    public static IPM_Project__c project;
    public static IPM_Project__c regionalProject;
    public static IPM_Project__c localProject;
    public static IPM_Project_Document__c projDoc;
    public static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Project_Document_Section__c projDocSec1;
    public static IPM_Project_Document_Section__c projDocSec2;
    public static IPM_Project_Document_Section__c projDocSec3;
    public static IPM_Project_Document_Section__c projDocSec4;
    public static IPM_Project_Document_Section__c projDocSec5;
    public static IPM_Project_Document_Section__c projDocSec6;
    public static IPM_Project_Document_Section__c projDocSec7;
    public static IPM_Project_Document_Section__c projDocSec8;
    public static IPM_Project_Document_Section__c projDocSec9;
    public static IPM_Project_Document_Section__c projDocSec11;
    public static IPM_Project_Document_Section__c projDocSec12;
    public static IPM_Project_Document_Section__c projDocSec13;
    public static IPM_Project_Document_Section__c projDocSec14;
    public static IPM_Project_Document_Section__c projDocSec15;
    public static IPM_Project_Document_Section__c projDocSec16;
    public static IPM_Project_Document_Section__c projDocSec17;
    public static IPM_Project_Document_Section__c projDocSec18;
    public static IPM_Project_Document_Section__c projDocSec19;
    public static IPM_Project_Document_Section__c projDocSec20;
    public static IPM_Project_Document_Section__c projDocSec21;
    public static IPM_Project_Document_Section__c projDocSec22;
    public static IPM_Project_Document_Section__c projDocSec23;
    public static IPM_Project_Document_Section__c projDocSec24;
    public static IPM_Project_Document_Section__c projDocSec25;
    public static IPM_Project_Document_Section__c projDocSec26;
    public static IPM_Project_Document_Section__c projDocSec27;
    public static IPM_Project_Document_Section__c projDocSec28;
    public static IPM_Project_Document_Section__c projDocSec29;
    public static IPM_Project_Document_Section__c projDocSec30;
    public static IPM_Project_Document_Section__c projDocSec31;
    public static IPM_Project_Document_Section__c projDocSec32;
    public static IPM_Project_Document_Section__c projDocSec33;

    public static IPM_Project_Document_Section_Content__c projDocSecCon;
    public static IPM_Project_Rollout__c projRoll;
    public static IPM_Document_Template__c ipdt;
    public static IPM_Project_Template__c projTempl;
    public static IPM_Section__c secMst;
    public static IPM_Section__c secMst1;
    public static IPM_Section__c secMst2;
    public static IPM_Section__c secMst3;
    public static IPM_Section__c secMst4;
    public static IPM_Section__c secMst5;
    public static IPM_Section__c secMst6;
    public static IPM_Section__c secMst7;
    public static IPM_Section__c secMst8;
    public static IPM_Section__c secMst9;
    public static IPM_Section__c secMst10;
    public static IPM_Section__c secMst11;
    public static IPM_Section__c secMst12;
    public static IPM_Section__c secMst13;
    public static IPM_Section__c secMst14;
    public static IPM_Section__c secMst15;
    public static IPM_Section__c secMst16;
    public static IPM_Section__c    secMst17;
    public static IPM_Section__c    secMst18;
    public static IPM_Section__c    secMst19;
    public static IPM_Section__c    secMst20;
    public static IPM_Section__c    secMst21;
    public static IPM_Section__c    secMst22;
    public static IPM_Section__c    secMst23;
    public static IPM_Section__c    secMst24;
    public static IPM_Section__c    secMst25;
    public static IPM_Section__c    secMst26;
    public static IPM_Section__c    secMst27;
    public static IPM_Section__c    secMst28;
    public static IPM_Section__c    secMst29;
    public static IPM_Section__c    secMst30;
    public static IPM_Section__c    secMst31;
    public static IPM_Section__c    secMst32;
    
    public static IPM_Questionnaire__c ques;
    public static User user;
    public static IPM_OTIF_Status__c ipmOtif;
    //test data for Market Ready
    static testMethod void initializeDataMarketReady()
    {
        Test.startTest();   
        List<IPM_Project_Document_Section__c> projDocSecList=new List<IPM_Project_Document_Section__c>();
        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
       
        User u1 = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            
            u1 = new User(Alias = 'cregd1', Email='cregd1@testorg4.com', 
            EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='cregd1@testorg4.com', 
            IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
            IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
            insert u1;
          System.runAs(u1) {
                psa.AssigneeId = u1.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
        
        List<IPM_Project_Rollout__Share>rollShareList=new list<IPM_Project_Rollout__Share>();
        IPM_Project_Rollout__Share roll=new IPM_Project_Rollout__Share();
        
        projTempl=new IPM_Project_Template__c();
        projTempl.IPM_Template_Complexity__c='Full';
        insert projTempl;
        
        ipdt=new IPM_Document_Template__c();
        ipdt.IPM_Project_Template__c=projTempl.ID;
        ipdt.IPM_Document_Template_Name__c='Market Ready Gate Full';
        ipdt.IPM_Document_Type__c='Market Ready';
        insert ipdt;
        
        secMst=new IPM_Section__c();
        secMst.IPM_Document_Template__c=ipdt.ID;
        secMst.IPM_Section_Sequence__c='1.1';
        secMst.IPM_Section_Name__c='Idea / Graphic';
        insert secMst;
        
        secMst1=new IPM_Section__c();
        secMst1.IPM_Document_Template__c=ipdt.ID;
        secMst1.IPM_Section_Sequence__c='3.1.1';
        secMst1.IPM_Section_Name__c='Trade Story';
        insert secMst1;
        
        secMst2=new IPM_Section__c();
        secMst2.IPM_Document_Template__c=ipdt.ID;
        secMst2.IPM_Section_Sequence__c='2.2.1';
        secMst2.IPM_Section_Name__c='Priority Channels, Key Customer Feedback & Implications to the Mix/Plan';
        insert secMst2;
        
        secMst3=new IPM_Section__c();
        secMst3.IPM_Document_Template__c=ipdt.ID;
        secMst3.IPM_Section_Sequence__c='2.2.1';
        secMst3.IPM_Section_Name__c='Target Audience';
        insert secMst3;
        
        secMst4=new IPM_Section__c();
        secMst4.IPM_Document_Template__c=ipdt.ID;
        secMst4.IPM_Section_Sequence__c='3.1.3';
        secMst4.IPM_Section_Name__c='Concept';
        insert secMst4;
        
        secMst5=new IPM_Section__c();
        secMst5.IPM_Document_Template__c=ipdt.ID;
        secMst5.IPM_Section_Sequence__c='3.7';
        secMst5.IPM_Section_Name__c='Communication';
        insert secMst5;
        
        secMst6=new IPM_Section__c();
        secMst6.IPM_Document_Template__c=ipdt.ID;
        secMst6.IPM_Section_Sequence__c='6.1';
        secMst6.IPM_Section_Name__c='Trademarks';
        insert secMst6;
        
        secMst7=new IPM_Section__c();
        secMst7.IPM_Document_Template__c=ipdt.ID;
        secMst7.IPM_Section_Sequence__c='7.1';
        secMst7.IPM_Section_Name__c='Pack/Graphics';
        insert secMst7;
        
        
        secMst8=new IPM_Section__c();
        secMst8.IPM_Document_Template__c=ipdt.ID;
        secMst8.IPM_Section_Sequence__c='2.2';
        secMst8.IPM_Section_Name__c='Product';
        insert secMst8;
        
        secMst9=new IPM_Section__c();
        secMst9.IPM_Document_Template__c=ipdt.ID;
        secMst9.IPM_Section_Sequence__c='7.2';
        secMst9.IPM_Section_Name__c='Consumer Evidence - Product';
        insert secMst9;
        
        secMst10=new IPM_Section__c();
        secMst10.IPM_Document_Template__c=ipdt.ID;
        secMst10.IPM_Section_Sequence__c='7.3';
        secMst10.IPM_Section_Name__c='CUs and Complexity';
        insert secMst10;
        
        secMst11=new IPM_Section__c();
        secMst11.IPM_Document_Template__c=ipdt.ID;
        secMst11.IPM_Section_Sequence__c='7.5';
        secMst11.IPM_Section_Name__c='OTIF Status';
        secMst11.IPM_Section_Type__c='Static Table';
        insert secMst11;
        
        secMst12=new IPM_Section__c();
        secMst12.IPM_Document_Template__c=ipdt.ID;
        secMst12.IPM_Section_Sequence__c='1.2';
        secMst12.IPM_Section_Name__c='Proposed Pricing';
        insert secMst12;
        
        secMst13=new IPM_Section__c();
        secMst13.IPM_Document_Template__c=ipdt.ID;
        secMst13.IPM_Section_Sequence__c='6.1';
        secMst13.IPM_Section_Name__c='Other Price Rationale';
        insert secMst13;
        
        secMst14=new IPM_Section__c();
        secMst14.IPM_Document_Template__c=ipdt.ID;
        secMst14.IPM_Section_Sequence__c='1.3';
        secMst14.IPM_Section_Name__c='Full Mix';
        insert secMst14;
        
        secMst15=new IPM_Section__c();
        secMst15.IPM_Document_Template__c=ipdt.ID;
        secMst15.IPM_Section_Sequence__c='1.2';
        secMst15.IPM_Section_Name__c='Degree of Commonality';
        //secMst33.IPM_Section_Type__c='Sub Header';
        insert secMst15;
        
        secMst16=new IPM_Section__c();
        secMst16.IPM_Document_Template__c=ipdt.ID;
        secMst16.IPM_Section_Sequence__c='1.2';
        secMst16.IPM_Section_Name__c='Mix Qualification Plan and Action Standards';
        //secMst16.IPM_Section_Type__c='Sub Header';
        insert secMst16;
        
        secMst17=new IPM_Section__c();
        secMst17.IPM_Document_Template__c=ipdt.ID;
        secMst17.IPM_Section_Sequence__c='1.2';
        secMst17.IPM_Section_Name__c='Mix Qualification Plan and Action Standards (Table)';
        //secMst17.IPM_Section_Type__c='Sub Header';
        insert secMst17;
        
        secMst18=new IPM_Section__c();
        secMst18.IPM_Document_Template__c=ipdt.ID;
        secMst18.IPM_Section_Sequence__c='1.2';
        secMst18.IPM_Section_Name__c='Promotion Guidance for Deployment – PRELIMINARY';
        //secMst18.IPM_Section_Type__c='Sub Header';
        insert secMst18;
        
        secMst19=new IPM_Section__c();
        secMst19.IPM_Document_Template__c=ipdt.ID;
        secMst19.IPM_Section_Sequence__c='1.2';
        secMst19.IPM_Section_Name__c='Assortment Strategy';
        secMst19.IPM_Section_Type__c='Sub Header';
        insert secMst19;
        
        secMst20=new IPM_Section__c();
        secMst20.IPM_Document_Template__c=ipdt.ID;
        secMst20.IPM_Section_Sequence__c='1.2';
        secMst20.IPM_Section_Name__c='Merchandising Strategy';
        //secMst20.IPM_Section_Type__c='Sub Header';
        insert secMst20;
        
        secMst21=new IPM_Section__c();
        secMst21.IPM_Document_Template__c=ipdt.ID;
        secMst21.IPM_Section_Sequence__c='1.2';
        secMst21.IPM_Section_Name__c='Trade Promotion Strategy';
        //secMst21.IPM_Section_Type__c='Sub Header';
        insert secMst21;
        
        secMst22=new IPM_Section__c();
        secMst22.IPM_Document_Template__c=ipdt.ID;
        secMst22.IPM_Section_Sequence__c='1.2';
        secMst22.IPM_Section_Name__c='Environmental Impact';
        //secMst22.IPM_Section_Type__c='Sub Header';
        insert secMst22;
        
        secMst23=new IPM_Section__c();
        secMst23.IPM_Document_Template__c=ipdt.ID;
        secMst23.IPM_Section_Sequence__c='1.2';
        secMst23.IPM_Section_Name__c='Business Case vs. Action Standards';
        //secMst23.IPM_Section_Type__c='Sub Header';
        insert secMst23;
        
        secMst24=new IPM_Section__c();
        secMst24.IPM_Document_Template__c=ipdt.ID;
        secMst24.IPM_Section_Sequence__c='1.2';
        secMst24.IPM_Section_Name__c='Assumptions';
        //secMst24.IPM_Section_Type__c='Sub Header';
        insert secMst24;
        
        secMst25=new IPM_Section__c();
        secMst25.IPM_Document_Template__c=ipdt.ID;
        secMst25.IPM_Section_Sequence__c='1.2';
        secMst25.IPM_Section_Name__c='Sensitivity Analysis';
        //secMst25.IPM_Section_Type__c='Sub Header';
        insert secMst25;
        
        secMst26=new IPM_Section__c();
        secMst26.IPM_Document_Template__c=ipdt.ID;
        secMst26.IPM_Section_Sequence__c='1.2';
        secMst26.IPM_Section_Name__c='BD/BB Alignment';
        //secMst26.IPM_Section_Type__c='Sub Header';
        insert secMst26;
        
        secMst27=new IPM_Section__c();
        secMst27.IPM_Document_Template__c=ipdt.ID;
        secMst27.IPM_Section_Sequence__c='1.2';
        secMst27.IPM_Section_Name__c='Business Waste';
        //secMst27.IPM_Section_Type__c='Sub Header';
        insert secMst27;
        
        secMst28=new IPM_Section__c();
        secMst28.IPM_Document_Template__c=ipdt.ID;
        secMst28.IPM_Section_Sequence__c='1.2';
        secMst28.IPM_Section_Name__c='Rollout Plans';
        //secMst28.IPM_Section_Type__c='Sub Header';
        insert secMst28;
        
        secMst29=new IPM_Section__c();
        secMst29.IPM_Document_Template__c=ipdt.ID;
        secMst29.IPM_Section_Sequence__c='1.2';
        secMst29.IPM_Section_Name__c='Risk';
        //secMst29.IPM_Section_Type__c='Sub Header';
        insert secMst29;
        
        secMst30=new IPM_Section__c();
        secMst30.IPM_Document_Template__c=ipdt.ID;
        secMst30.IPM_Section_Sequence__c='1.2';
        secMst30.IPM_Section_Name__c='Milestones';
        //secMst30.IPM_Section_Type__c='Sub Header';
        insert secMst30;
        
        secMst31=new IPM_Section__c();
        secMst31.IPM_Document_Template__c=ipdt.ID;
        secMst31.IPM_Section_Sequence__c='1.2';
        secMst31.IPM_Section_Name__c='Feedback from Last Gate';
        //secMst31.IPM_Section_Type__c='Sub Header';
        insert secMst31;
        
        secMst32=new IPM_Section__c();
        secMst32.IPM_Document_Template__c=ipdt.ID;
        secMst32.IPM_Section_Sequence__c='1.2';
        secMst32.IPM_Section_Name__c='Justification';
        secMst32.IPM_Section_Type__c='Sub Header';
        insert secMst32;
        
        
        project=new IPM_Project__c();
        project.Name='TestComments';
        
        project.IPM_Phase__c='Feasibility';
        project.IPM_Complexity__c='Full';
        project.IPM_GateKeeping_Model__c='GCLT & RCLT'; 
        insert project;
        
        projRoll=new IPM_Project_Rollout__c();
        projRoll.IPM_Project__c=project.ID;
        projRoll.RecordTypeId=Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get('Regional Rollout').RecordTypeId;
        projRoll.IPM_Rollout_Project__c='TestComments_SEAA';
        projRoll.Market_Cluster__c='SEAA';
        projRoll.Target_Launch_Date__c=date.today();
        projRoll.IPM_Regional_PL__c=u1.Id;
        
        insert projRoll;
        
        roll.ParentId= projRoll.Id;
        roll.userOrGroupId = psa.AssigneeId ;
        roll.accesslevel = 'Edit';
        rollShareList.add(roll);
        insert rollShareList;
        
        
        projDoc=new IPM_Project_Document__c();
        projDoc.IPM_GateDocuments__c='Contract'; 
        projDoc.IPM_Project__c=project.ID;
        projDoc.IPM_Project_Template__c= projTempl.Id;  
        projDOc.IPM_Contract_GateKeeper_Model__c='GCLT & RCLT';
        insert projDoc;
        projDocList.add(projDoc);
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='Idea / Graphic'; 
        projDocSec.IPM_Section__c=secMst.Id;
        projDocSecList.add(projDocSec);
        
        projDocSec1=new IPM_Project_Document_Section__c();
        projDocSec1.IPM_Project_Document__c=projDoc.ID;
        projDocSec1.IPM_Section_Name__c='Trade Story'; 
        projDocSec1.IPM_Section__c=secMst1.Id;
        projDocSecList.add(projDocSec1);
        
        projDocSec2=new IPM_Project_Document_Section__c();
        projDocSec2.IPM_Project_Document__c=projDoc.ID;
        projDocSec2.IPM_Section_Name__c='Priority Channels, Key Customer Feedback & Implications to the Mix/Plan'; 
        projDocSec2.IPM_Section__c=secMst2.Id;
        projDocSecList.add(projDocSec2);
        
        projDocSec3=new IPM_Project_Document_Section__c();
        projDocSec3.IPM_Project_Document__c=projDoc.ID;
        projDocSec3.IPM_Section_Name__c='Target Audience'; 
        projDocSec3.IPM_Section__c=secMst3.Id;
        projDocSecList.add(projDocSec3);
        
        projDocSec4=new IPM_Project_Document_Section__c();
        projDocSec4.IPM_Project_Document__c=projDoc.ID;
        projDocSec4.IPM_Section_Name__c='Concept'; 
        projDocSec4.IPM_Section__c=secMst4.Id;
        projDocSecList.add(projDocSec4);
        
        projDocSec5=new IPM_Project_Document_Section__c();
        projDocSec5.IPM_Project_Document__c=projDoc.ID;
        projDocSec5.IPM_Section_Name__c='Communication'; 
        projDocSec5.IPM_Section__c=secMst5.Id;
        projDocSecList.add(projDocSec5);
        
        projDocSec6=new IPM_Project_Document_Section__c();
        projDocSec6.IPM_Project_Document__c=projDoc.ID;
        projDocSec6.IPM_Section_Name__c='Trademarks'; 
        projDocSec6.IPM_Section__c=secMst6.Id;
        projDocSecList.add(projDocSec6);
        
        projDocSec7=new IPM_Project_Document_Section__c();
        projDocSec7.IPM_Project_Document__c=projDoc.ID;
        projDocSec7.IPM_Section_Name__c='Pack/Graphics'; 
        projDocSec7.IPM_Section__c=secMst7.Id;
        projDocSecList.add(projDocSec7);
        
        projDocSec8=new IPM_Project_Document_Section__c();
        projDocSec8.IPM_Project_Document__c=projDoc.ID;
        projDocSec8.IPM_Section_Name__c='Product'; 
        projDocSec8.IPM_Section__c=secMst8.Id;
        projDocSecList.add(projDocSec8);
        
        
        projDocSec9=new IPM_Project_Document_Section__c();
        projDocSec9.IPM_Project_Document__c=projDoc.ID;
        projDocSec9.IPM_Section_Name__c='Consumer Evidence - Product'; 
        projDocSec9.IPM_Section__c=secMst9.Id;
        projDocSecList.add(projDocSec9);
        
        projDocSec11=new IPM_Project_Document_Section__c();
        projDocSec11.IPM_Project_Document__c=projDoc.ID;
        projDocSec11.IPM_Section_Name__c='CUs and Complexity'; 
        projDocSec11.IPM_Section__c=secMst10.Id;
        projDocSecList.add(projDocSec11);
        
        projDocSec12=new IPM_Project_Document_Section__c();
        projDocSec12.IPM_Project_Document__c=projDoc.ID;
        projDocSec12.IPM_Section_Name__c='OTIF Status'; 
        projDocSec12.IPM_Section__c=secMst11.Id;
        projDocSecList.add(projDocSec12);
        
        projDocSec13=new IPM_Project_Document_Section__c();
        projDocSec13.IPM_Project_Document__c=projDoc.ID;
        projDocSec13.IPM_Section_Name__c='Proposed Pricing'; 
        projDocSec13.IPM_Section__c=secMst12.Id;
        projDocSecList.add(projDocSec13);
        
        projDocSec14=new IPM_Project_Document_Section__c();
        projDocSec14.IPM_Project_Document__c=projDoc.ID;
        projDocSec14.IPM_Section_Name__c='Other Price Rationale'; 
        projDocSec14.IPM_Section__c=secMst13.Id;
        projDocSecList.add(projDocSec14);
        
        projDocSec15=new IPM_Project_Document_Section__c();
        projDocSec15.IPM_Project_Document__c=projDoc.ID;
        projDocSec15.IPM_Section_Name__c='Full Mix'; 
        projDocSec15.IPM_Section__c=secMst14.Id;
        projDocSecList.add(projDocSec15);
        
        projDocSec16=new IPM_Project_Document_Section__c();
        projDocSec16.IPM_Project_Document__c=projDoc.ID;
        projDocSec16.IPM_Section_Name__c='Degree of Commonality'; 
        projDocSec16.IPM_Section__c=secMst15.Id;
        projDocSecList.add(projDocSec16);
        
        projDocSec17=new IPM_Project_Document_Section__c();
        projDocSec17.IPM_Project_Document__c=projDoc.ID;
        projDocSec17.IPM_Section_Name__c='Mix Qualification Plan and Action Standards'; 
        projDocSec17.IPM_Section__c=secMst16.Id;
        projDocSecList.add(projDocSec17);
        
        projDocSec18=new IPM_Project_Document_Section__c();
        projDocSec18.IPM_Project_Document__c=projDoc.ID;
        projDocSec18.IPM_Section_Name__c='Mix Qualification Plan and Action Standards (Table)'; 
        projDocSec18.IPM_Section__c=secMst17.Id;
        projDocSecList.add(projDocSec18);
        
        projDocSec19=new IPM_Project_Document_Section__c();
        projDocSec19.IPM_Project_Document__c=projDoc.ID;
        projDocSec19.IPM_Section_Name__c='Promotion Guidance for Deployment – PRELIMINARY'; 
        projDocSec19.IPM_Section__c=secMst18.Id;
        projDocSecList.add(projDocSec19);
        
        projDocSec20=new IPM_Project_Document_Section__c();
        projDocSec20.IPM_Project_Document__c=projDoc.ID;
        projDocSec20.IPM_Section_Name__c='Assortment Strategy'; 
        projDocSec20.IPM_Section__c=secMst19.Id;
        projDocSecList.add(projDocSec20);
        
        projDocSec21=new IPM_Project_Document_Section__c();
        projDocSec21.IPM_Project_Document__c=projDoc.ID;
        projDocSec21.IPM_Section_Name__c='Merchandising Strategy'; 
        projDocSec21.IPM_Section__c=secMst20.Id;
        projDocSecList.add(projDocSec21);
        
        projDocSec22=new IPM_Project_Document_Section__c();
        projDocSec22.IPM_Project_Document__c=projDoc.ID;
        projDocSec22.IPM_Section_Name__c='Trade Promotion Strategy'; 
        projDocSec22.IPM_Section__c=secMst21.Id;
        projDocSecList.add(projDocSec22);
        
        projDocSec23=new IPM_Project_Document_Section__c();
        projDocSec23.IPM_Project_Document__c=projDoc.ID;
        projDocSec23.IPM_Section_Name__c='Environmental Impact'; 
        projDocSec23.IPM_Section__c=secMst22.Id;
        projDocSecList.add(projDocSec23);
        
        projDocSec24=new IPM_Project_Document_Section__c();
        projDocSec24.IPM_Project_Document__c=projDoc.ID;
        projDocSec24.IPM_Section_Name__c='Business Case vs. Action Standards'; 
        projDocSec24.IPM_Section__c=secMst23.Id;
        projDocSecList.add(projDocSec24);
        
        projDocSec25=new IPM_Project_Document_Section__c();
        projDocSec25.IPM_Project_Document__c=projDoc.ID;
        projDocSec25.IPM_Section_Name__c='Assumptions'; 
        projDocSec25.IPM_Section__c=secMst24.Id;
        projDocSecList.add(projDocSec25);
        
        projDocSec26=new IPM_Project_Document_Section__c();
        projDocSec26.IPM_Project_Document__c=projDoc.ID;
        projDocSec26.IPM_Section_Name__c='Sensitivity Analysis'; 
        projDocSec26.IPM_Section__c=secMst25.Id;
        projDocSecList.add(projDocSec26);
        
        projDocSec27=new IPM_Project_Document_Section__c();
        projDocSec27.IPM_Project_Document__c=projDoc.ID;
        projDocSec27.IPM_Section_Name__c='BD/BB Alignment'; 
        projDocSec27.IPM_Section__c=secMst26.Id;
        projDocSecList.add(projDocSec27);
        
        projDocSec28=new IPM_Project_Document_Section__c();
        projDocSec28.IPM_Project_Document__c=projDoc.ID;
        projDocSec28.IPM_Section_Name__c='Business Waste'; 
        projDocSec28.IPM_Section__c=secMst27.Id;
        projDocSecList.add(projDocSec28);
        
        projDocSec29=new IPM_Project_Document_Section__c();
        projDocSec29.IPM_Project_Document__c=projDoc.ID;
        projDocSec29.IPM_Section_Name__c='Rollout Plans'; 
        projDocSec29.IPM_Section__c=secMst28.Id;
        projDocSecList.add(projDocSec29);
        
        projDocSec30=new IPM_Project_Document_Section__c();
        projDocSec30.IPM_Project_Document__c=projDoc.ID;
        projDocSec30.IPM_Section_Name__c='Risk'; 
        projDocSec30.IPM_Section__c=secMst29.Id;
        projDocSecList.add(projDocSec30);
        
        projDocSec31=new IPM_Project_Document_Section__c();
        projDocSec31.IPM_Project_Document__c=projDoc.ID;
        projDocSec31.IPM_Section_Name__c='Milestones'; 
        projDocSec31.IPM_Section__c=secMst30.Id;
        projDocSecList.add(projDocSec31);
        
        projDocSec32=new IPM_Project_Document_Section__c();
        projDocSec32.IPM_Project_Document__c=projDoc.ID;
        projDocSec32.IPM_Section_Name__c='Feedback from Last Gate'; 
        projDocSec32.IPM_Section__c=secMst31.Id;
        projDocSecList.add(projDocSec32);
        
        projDocSec33=new IPM_Project_Document_Section__c();
        projDocSec33.IPM_Project_Document__c=projDoc.ID;
        projDocSec33.IPM_Section_Name__c='Justification'; 
        projDocSec33.IPM_Section__c=secMst32.Id;
        projDocSecList.add(projDocSec33);
        
        projDocSecCon=new IPM_Project_Document_Section_Content__c();
        projDocSecCon.IPM_Project_Document_Section__c=projDocSec.ID;
        insert projDocSecCon;
        
        insert projDocSecList;
        
        ques=new IPM_Questionnaire__c();
        ques.RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('GateKeeperChecklist').RecordTypeId;
        ques.IPM_Sequence_Number__c=1;
        ques.IPM_Section_Sequence_Number__c='1.2.1';
        ques.IPM_Question__c='Test GK Question';
        ques.IPM_RQS_Gate_Type__c='Charter';
        ques.IPM_HelpText_Yes__c='Help Text Yes';
        ques.IPM_HelpText_No__c='help Text No';
        ques.IPM_HelpText_Partly__c='help text partly';
        ques.IPM_Project_Document_Section__c=projDocSec.Id;
        ques.Is_Master__c=true;
        insert ques;
        
        ipmOtif=new IPM_OTIF_Status__c ();
        ipmOtif.Name='Contract Attractive Business';
        ipmOtif.IPM_Gate_Document_Type__c='Market Ready';
        insert ipmOtif;
        Test.stopTest();
    }
    //Market Deployment
    static testMethod void initializeDataMarketDeployment()
    {
        Test.startTest();
        List<IPM_Project_Document_Section__c> projDocSecList=new List<IPM_Project_Document_Section__c>();
        PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
       
        User u1 = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            
            u1 = new User(Alias = 'cregd2', Email='cregd2@testorg4.com', 
            EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='cregd2@testorg4.com', 
            IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
            IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
            insert u1;
          System.runAs(u1) {
                psa.AssigneeId = u1.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
        List<IPM_Project_Rollout__Share>rollShareList=new list<IPM_Project_Rollout__Share>();
        IPM_Project_Rollout__Share roll=new IPM_Project_Rollout__Share();
        
        projTempl=new IPM_Project_Template__c();
        projTempl.IPM_Template_Complexity__c='Full';
        insert projTempl;
        
        ipdt=new IPM_Document_Template__c();
        ipdt.IPM_Project_Template__c=projTempl.ID;
        ipdt.IPM_Document_Template_Name__c='Market Deployment Gate Full';
        ipdt.IPM_Document_Type__c='Market Deployment';
        insert ipdt;
        
        secMst=new IPM_Section__c();
        secMst.IPM_Document_Template__c=ipdt.ID;
        secMst.IPM_Section_Sequence__c='1.1';
        secMst.IPM_Section_Name__c='Idea / Graphic';
        insert secMst;
        
        secMst1=new IPM_Section__c();
        secMst1.IPM_Document_Template__c=ipdt.ID;
        secMst1.IPM_Section_Sequence__c='3.1.1';
        secMst1.IPM_Section_Name__c='Trade Story';
        insert secMst1;
        
        secMst2=new IPM_Section__c();
        secMst2.IPM_Document_Template__c=ipdt.ID;
        secMst2.IPM_Section_Sequence__c='2.2.1';
        secMst2.IPM_Section_Name__c='Target Audience';
        insert secMst2;
        
        secMst3=new IPM_Section__c();
        secMst3.IPM_Document_Template__c=ipdt.ID;
        secMst3.IPM_Section_Sequence__c='2.2.1';
        secMst3.IPM_Section_Name__c='Concept';
        insert secMst3;
        
        secMst4=new IPM_Section__c();
        secMst4.IPM_Document_Template__c=ipdt.ID;
        secMst4.IPM_Section_Sequence__c='3.1.3';
        secMst4.IPM_Section_Name__c='Communication';
        insert secMst4;
        
        secMst5=new IPM_Section__c();
        secMst5.IPM_Document_Template__c=ipdt.ID;
        secMst5.IPM_Section_Sequence__c='3.7';
        secMst5.IPM_Section_Name__c='Pack';
        insert secMst5;
        
        secMst6=new IPM_Section__c();
        secMst6.IPM_Document_Template__c=ipdt.ID;
        secMst6.IPM_Section_Sequence__c='6.1';
        secMst6.IPM_Section_Name__c='Product';
        insert secMst6;
        
        secMst7=new IPM_Section__c();
        secMst7.IPM_Document_Template__c=ipdt.ID;
        secMst7.IPM_Section_Sequence__c='7.1';
        secMst7.IPM_Section_Name__c='Pack/Graphics';
        insert secMst7;
        
        
        secMst8=new IPM_Section__c();
        secMst8.IPM_Document_Template__c=ipdt.ID;
        secMst8.IPM_Section_Sequence__c='2.2';
        secMst8.IPM_Section_Name__c='Pricing';
        insert secMst8;
        
        secMst9=new IPM_Section__c();
        secMst9.IPM_Document_Template__c=ipdt.ID;
        secMst9.IPM_Section_Sequence__c='7.2';
        secMst9.IPM_Section_Name__c='Proposed Pricing';
        insert secMst9;
        
        secMst10=new IPM_Section__c();
        secMst10.IPM_Document_Template__c=ipdt.ID;
        secMst10.IPM_Section_Sequence__c='7.3';
        secMst10.IPM_Section_Name__c='Other Price Rationale (beyond consumer evidence shown in 3.5 below)';
        insert secMst10;
        
        secMst11=new IPM_Section__c();
        secMst11.IPM_Document_Template__c=ipdt.ID;
        secMst11.IPM_Section_Sequence__c='7.5';
        secMst11.IPM_Section_Name__c='OTIF Status';
        secMst11.IPM_Section_Type__c='Static Table';
        insert secMst11;
        
        secMst12=new IPM_Section__c();
        secMst12.IPM_Document_Template__c=ipdt.ID;
        secMst12.IPM_Section_Sequence__c='1.2';
        secMst12.IPM_Section_Name__c='Other Price Rationale';
        insert secMst12;
        
        secMst13=new IPM_Section__c();
        secMst13.IPM_Document_Template__c=ipdt.ID;
        secMst13.IPM_Section_Sequence__c='6.1';
        secMst13.IPM_Section_Name__c='Mix Summary of Performance vs. Action Standards';
        insert secMst13;
        
        secMst14=new IPM_Section__c();
        secMst14.IPM_Document_Template__c=ipdt.ID;
        secMst14.IPM_Section_Sequence__c='1.3';
        secMst14.IPM_Section_Name__c='Mix Qualification Plan and Action Standards';
        insert secMst14;
        
        secMst15=new IPM_Section__c();
        secMst15.IPM_Document_Template__c=ipdt.ID;
        secMst15.IPM_Section_Sequence__c='1.2';
        secMst15.IPM_Section_Name__c='Promotion';
        //secMst33.IPM_Section_Type__c='Sub Header';
        insert secMst15;
        
        secMst16=new IPM_Section__c();
        secMst16.IPM_Document_Template__c=ipdt.ID;
        secMst16.IPM_Section_Sequence__c='1.2';
        secMst16.IPM_Section_Name__c='Promotion Guidance for Deployment – PRELIMINARY';
        //secMst16.IPM_Section_Type__c='Sub Header';
        insert secMst16;
        
        secMst17=new IPM_Section__c();
        secMst17.IPM_Document_Template__c=ipdt.ID;
        secMst17.IPM_Section_Sequence__c='1.2';
        secMst17.IPM_Section_Name__c='Assortment Strategy';
        //secMst17.IPM_Section_Type__c='Sub Header';
        insert secMst17;
        
        secMst18=new IPM_Section__c();
        secMst18.IPM_Document_Template__c=ipdt.ID;
        secMst18.IPM_Section_Sequence__c='1.2';
        secMst18.IPM_Section_Name__c='Merchandising Strategy';
        //secMst18.IPM_Section_Type__c='Sub Header';
        insert secMst18;
        
        secMst19=new IPM_Section__c();
        secMst19.IPM_Document_Template__c=ipdt.ID;
        secMst19.IPM_Section_Sequence__c='1.2';
        secMst19.IPM_Section_Name__c='Trade Promotional Strategy';
        //secMst19.IPM_Section_Type__c='Sub Header';
        insert secMst19;
        
        secMst20=new IPM_Section__c();
        secMst20.IPM_Document_Template__c=ipdt.ID;
        secMst20.IPM_Section_Sequence__c='1.2';
        secMst20.IPM_Section_Name__c='Trade Promotion Strategy';
        //secMst20.IPM_Section_Type__c='Sub Header';
        insert secMst20;
        
        secMst21=new IPM_Section__c();
        secMst21.IPM_Document_Template__c=ipdt.ID;
        secMst21.IPM_Section_Sequence__c='1.2';
        secMst21.IPM_Section_Name__c='Business Waste';
        //secMst21.IPM_Section_Type__c='Sub Header';
        insert secMst21;
        
        secMst22=new IPM_Section__c();
        secMst22.IPM_Document_Template__c=ipdt.ID;
        secMst22.IPM_Section_Sequence__c='1.2';
        secMst22.IPM_Section_Name__c='Milestones';
        //secMst22.IPM_Section_Type__c='Sub Header';
        insert secMst22;
        
        secMst23=new IPM_Section__c();
        secMst23.IPM_Document_Template__c=ipdt.ID;
        secMst23.IPM_Section_Sequence__c='1.2';
        secMst23.IPM_Section_Name__c='Feedback from Last Gate';
        //secMst23.IPM_Section_Type__c='Sub Header';
        insert secMst23;
        
        secMst24=new IPM_Section__c();
        secMst24.IPM_Document_Template__c=ipdt.ID;
        secMst24.IPM_Section_Sequence__c='1.2';
        secMst24.IPM_Section_Name__c='Justification';
        secMst24.IPM_Section_Type__c='Sub Header';
        insert secMst24;
        
        project=new IPM_Project__c();
        project.Name='TestComments';
        project.IPM_Phase__c='Capability';
        project.IPM_Complexity__c='Full';
        project.IPM_GateKeeping_Model__c='GCLT & RCLT'; 
        project.IPM_Project_Leader__c=u1.Id;
        insert project;
        
        regionalProject=new IPM_Project__c();
        regionalProject.IPM_Parent_Project__c=project.Id;
        regionalProject.Name='TestComments_SEAA';
        regionalProject.IPM_Phase__c='Capability';
        regionalProject.IPM_Complexity__c='Full';
        regionalProject.IPM_GateKeeping_Model__c='GCLT & RCLT'; 
        regionalProject.IPM_Project_Leader__c=u1.Id;
        insert regionalProject;
        
        localProject=new IPM_Project__c();
        localProject.IPM_Parent_Project__c=regionalProject.Id;
        localProject.Name='TestComments_SEAA_AF';
        localProject.IPM_Phase__c='Capability';
        localProject.IPM_Complexity__c='Full';
        localProject.IPM_GateKeeping_Model__c='GCLT & RCLT'; 
        localProject.IPM_Project_Leader__c=u1.Id;
        insert localProject;
        
        projRoll=new IPM_Project_Rollout__c();
        projRoll.IPM_Project__c=project.ID;
        projRoll.RecordTypeId=Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get('Regional Rollout').RecordTypeId;
        projRoll.IPM_Rollout_Project__c='TestComments_SEAA';
        projRoll.Market_Cluster__c='SEAA';
        projRoll.Target_Launch_Date__c=date.today();
        projRoll.IPM_Regional_PL__c=u1.Id;
        insert projRoll;
        
        roll.ParentId= projRoll.Id;
        roll.userOrGroupId = psa.AssigneeId ;
        roll.accesslevel = 'Edit';
        rollShareList.add(roll);
        insert rollShareList;
        
        projDoc=new IPM_Project_Document__c();
        projDoc.IPM_GateDocuments__c='Market Ready'; 
        projDoc.IPM_Project__c=regionalProject.ID;
        projDoc.IPM_Project_Template__c= projTempl.Id;  
        projDOc.IPM_Contract_GateKeeper_Model__c='GCLT & RCLT';
        insert projDoc;
        projDocList.add(projDoc);
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='Idea / Graphic'; 
        projDocSec.IPM_Section__c=secMst.Id;
        projDocSecList.add(projDocSec);

        projDocSec1=new IPM_Project_Document_Section__c();
        projDocSec1.IPM_Project_Document__c=projDoc.ID;
        projDocSec1.IPM_Section_Name__c='Trade Story'; 
        projDocSec1.IPM_Section__c=secMst1.Id;
        projDocSecList.add(projDocSec1);
        
        projDocSec2=new IPM_Project_Document_Section__c();
        projDocSec2.IPM_Project_Document__c=projDoc.ID;
        projDocSec2.IPM_Section_Name__c='Target Audience'; 
        projDocSec2.IPM_Section__c=secMst2.Id;
        projDocSecList.add(projDocSec2);

        projDocSec3=new IPM_Project_Document_Section__c();
        projDocSec3.IPM_Project_Document__c=projDoc.ID;
        projDocSec3.IPM_Section_Name__c='Concept'; 
        projDocSec3.IPM_Section__c=secMst3.Id;
        projDocSecList.add(projDocSec3);
        
        projDocSec4=new IPM_Project_Document_Section__c();
        projDocSec4.IPM_Project_Document__c=projDoc.ID;
        projDocSec4.IPM_Section_Name__c='Communication'; 
        projDocSec4.IPM_Section__c=secMst4.Id;
        projDocSecList.add(projDocSec4);

        projDocSec5=new IPM_Project_Document_Section__c();
        projDocSec5.IPM_Project_Document__c=projDoc.ID;
        projDocSec5.IPM_Section_Name__c='Pack'; 
        projDocSec5.IPM_Section__c=secMst5.Id;
        projDocSecList.add(projDocSec5);

        projDocSec6=new IPM_Project_Document_Section__c();
        projDocSec6.IPM_Project_Document__c=projDoc.ID;
        projDocSec6.IPM_Section_Name__c='Product'; 
        projDocSec6.IPM_Section__c=secMst6.Id;
        projDocSecList.add(projDocSec6);
        
        projDocSec7=new IPM_Project_Document_Section__c();
        projDocSec7.IPM_Project_Document__c=projDoc.ID;
        projDocSec7.IPM_Section_Name__c='Pack/Graphics'; 
        projDocSec7.IPM_Section__c=secMst7.Id;
        projDocSecList.add(projDocSec7);
        
        projDocSec8=new IPM_Project_Document_Section__c();
        projDocSec8.IPM_Project_Document__c=projDoc.ID;
        projDocSec8.IPM_Section_Name__c='Pricing'; 
        projDocSec8.IPM_Section__c=secMst8.Id;
        projDocSecList.add(projDocSec8);
        
        projDocSec9=new IPM_Project_Document_Section__c();
        projDocSec9.IPM_Project_Document__c=projDoc.ID;
        projDocSec9.IPM_Section_Name__c='Proposed Pricing'; 
        projDocSec9.IPM_Section__c=secMst9.Id;
        projDocSecList.add(projDocSec9);

        projDocSec11=new IPM_Project_Document_Section__c();
        projDocSec11.IPM_Project_Document__c=projDoc.ID;
        projDocSec11.IPM_Section_Name__c='Other Price Rationale (beyond consumer evidence shown in 3.5 below)'; 
        projDocSec11.IPM_Section__c=secMst10.Id;
        projDocSecList.add(projDocSec11);

        projDocSec12=new IPM_Project_Document_Section__c();
        projDocSec12.IPM_Project_Document__c=projDoc.ID;
        projDocSec12.IPM_Section_Name__c='OTIF Status'; 
        projDocSec12.IPM_Section__c=secMst11.Id;
        projDocSecList.add(projDocSec12);
        
        projDocSec13=new IPM_Project_Document_Section__c();
        projDocSec13.IPM_Project_Document__c=projDoc.ID;
        projDocSec13.IPM_Section_Name__c='Other Price Rationale'; 
        projDocSec13.IPM_Section__c=secMst12.Id;
        projDocSecList.add(projDocSec13);
        
        projDocSec14=new IPM_Project_Document_Section__c();
        projDocSec14.IPM_Project_Document__c=projDoc.ID;
        projDocSec14.IPM_Section_Name__c='Mix Summary of Performance vs. Action Standards'; 
        projDocSec14.IPM_Section__c=secMst13.Id;
        projDocSecList.add(projDocSec14);
        
        projDocSec15=new IPM_Project_Document_Section__c();
        projDocSec15.IPM_Project_Document__c=projDoc.ID;
        projDocSec15.IPM_Section_Name__c='Mix Qualification Plan and Action Standards'; 
        projDocSec15.IPM_Section__c=secMst14.Id;
        projDocSecList.add(projDocSec15);
        
        projDocSec16=new IPM_Project_Document_Section__c();
        projDocSec16.IPM_Project_Document__c=projDoc.ID;
        projDocSec16.IPM_Section_Name__c='Promotion'; 
        projDocSec16.IPM_Section__c=secMst15.Id;
        projDocSecList.add(projDocSec16);
        
        projDocSec17=new IPM_Project_Document_Section__c();
        projDocSec17.IPM_Project_Document__c=projDoc.ID;
        projDocSec17.IPM_Section_Name__c='Promotion Guidance for Deployment – PRELIMINARY'; 
        projDocSec17.IPM_Section__c=secMst16.Id;
        projDocSecList.add(projDocSec17);
        
        projDocSec18=new IPM_Project_Document_Section__c();
        projDocSec18.IPM_Project_Document__c=projDoc.ID;
        projDocSec18.IPM_Section_Name__c='Assortment Strategy'; 
        projDocSec18.IPM_Section__c=secMst17.Id;
        projDocSecList.add(projDocSec18);

        projDocSec19=new IPM_Project_Document_Section__c();
        projDocSec19.IPM_Project_Document__c=projDoc.ID;
        projDocSec19.IPM_Section_Name__c='Merchandising Strategy'; 
        projDocSec19.IPM_Section__c=secMst18.Id;
        projDocSecList.add(projDocSec19);

        projDocSec20=new IPM_Project_Document_Section__c();
        projDocSec20.IPM_Project_Document__c=projDoc.ID;
        projDocSec20.IPM_Section_Name__c='Trade Promotional Strategy'; 
        projDocSec20.IPM_Section__c=secMst19.Id;
        projDocSecList.add(projDocSec20);

        projDocSec21=new IPM_Project_Document_Section__c();
        projDocSec21.IPM_Project_Document__c=projDoc.ID;
        projDocSec21.IPM_Section_Name__c='Trade Promotion Strategy'; 
        projDocSec21.IPM_Section__c=secMst20.Id;
        projDocSecList.add(projDocSec21);
        
        projDocSec22=new IPM_Project_Document_Section__c();
        projDocSec22.IPM_Project_Document__c=projDoc.ID;
        projDocSec22.IPM_Section_Name__c='Business Waste'; 
        projDocSec22.IPM_Section__c=secMst21.Id;
        projDocSecList.add(projDocSec22);

        projDocSec23=new IPM_Project_Document_Section__c();
        projDocSec23.IPM_Project_Document__c=projDoc.ID;
        projDocSec23.IPM_Section_Name__c='Milestones'; 
        projDocSec23.IPM_Section__c=secMst22.Id;
        projDocSecList.add(projDocSec23);

        projDocSec24=new IPM_Project_Document_Section__c();
        projDocSec24.IPM_Project_Document__c=projDoc.ID;
        projDocSec24.IPM_Section_Name__c='Feedback from Last Gate'; 
        projDocSec24.IPM_Section__c=secMst23.Id;
        projDocSecList.add(projDocSec24);
        
        projDocSec25=new IPM_Project_Document_Section__c();
        projDocSec25.IPM_Project_Document__c=projDoc.ID;
        projDocSec25.IPM_Section_Name__c='Justification'; 
        projDocSec25.IPM_Section__c=secMst24.Id;
        projDocSecList.add(projDocSec25);
        insert projDocSecList;
        
        projDocSecCon=new IPM_Project_Document_Section_Content__c();
        projDocSecCon.IPM_Project_Document_Section__c=projDocSec.ID;
        insert projDocSecCon;
        
        ques=new IPM_Questionnaire__c();
        ques.RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('GateKeeperChecklist').RecordTypeId;
        ques.IPM_Sequence_Number__c=1;
        ques.IPM_Section_Sequence_Number__c='1.2.1';
        ques.IPM_Question__c='Test GK Question';
        ques.IPM_RQS_Gate_Type__c='Charter';
        ques.IPM_HelpText_Yes__c='Help Text Yes';
        ques.IPM_HelpText_No__c='help Text No';
        ques.IPM_HelpText_Partly__c='help text partly';
        ques.IPM_Project_Document_Section__c=projDocSec.Id;
        ques.Is_Master__c=true;
        insert ques;
        
        ipmOtif=new IPM_OTIF_Status__c ();
        ipmOtif.Name='Contract Attractive Business';
        ipmOtif.IPM_Gate_Document_Type__c='Market Ready';
        insert ipmOtif;
        Test.stopTest();
    }
    static testMethod void initializeData()
    {
        Test.startTest();
        List<PermissionSetAssignment> newPermissionSetAccess = new List<PermissionSetAssignment>(); //list for new permission sets
       PermissionSet Fps=new PermissionSet();
        Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
        PermissionSetAssignment psa = new PermissionSetAssignment();
       
        User u1 = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            
            u1 = new User(Alias = 'cregd3', Email='cregd3@testorg4.com', 
            EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='cregd3@testorg4.com', 
            IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
            IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
            insert u1;
          System.runAs(u1) {
                psa.AssigneeId = u1.Id;
                psa.PermissionSetId = Fps.Id;
                insert psa;
           }
        List<IPM_Project_Rollout__Share> rollShareList=new list<IPM_Project_Rollout__Share>();
        IPM_Project_Rollout__Share roll=new IPM_Project_Rollout__Share();
        
        projTempl=new IPM_Project_Template__c();
        projTempl.IPM_Template_Complexity__c='Full';
        insert projTempl;
        
        ipdt=new IPM_Document_Template__c();
        ipdt.IPM_Project_Template__c=projTempl.ID;
        ipdt.IPM_Document_Template_Name__c='Contract Gate Full';
        ipdt.IPM_Document_Type__c='Contract';
        insert ipdt;
        
        secMst=new IPM_Section__c();
        secMst.IPM_Document_Template__c=ipdt.ID;
        secMst.IPM_Section_Sequence__c='1.1';
        secMst.IPM_Section_Name__c='Idea / Graphic';
        insert secMst;
        
        secMst1=new IPM_Section__c();
        secMst1.IPM_Document_Template__c=ipdt.ID;
        secMst1.IPM_Section_Sequence__c='3.1.1';
        secMst1.IPM_Section_Name__c='Concept';
        insert secMst1;
        
        secMst2=new IPM_Section__c();
        secMst2.IPM_Document_Template__c=ipdt.ID;
        secMst2.IPM_Section_Sequence__c='2.2.1';
        secMst2.IPM_Section_Name__c='Priority Channels, Key Customer Feedback & Implications to the Mix/Plan';
        insert secMst2;
        
        secMst3=new IPM_Section__c();
        secMst3.IPM_Document_Template__c=ipdt.ID;
        secMst3.IPM_Section_Sequence__c='2.2.1';
        secMst3.IPM_Section_Name__c='Target Audience';
        insert secMst3;
        
        secMst4=new IPM_Section__c();
        secMst4.IPM_Document_Template__c=ipdt.ID;
        secMst4.IPM_Section_Sequence__c='3.1.3';
        secMst4.IPM_Section_Name__c='Consumer Evidence - Concept';
        insert secMst4;
        
        secMst5=new IPM_Section__c();
        secMst5.IPM_Document_Template__c=ipdt.ID;
        secMst5.IPM_Section_Sequence__c='3.7';
        secMst5.IPM_Section_Name__c='Mix Qualification Plan and Action Standards (Table)';
        insert secMst5;
        
        secMst6=new IPM_Section__c();
        secMst6.IPM_Document_Template__c=ipdt.ID;
        secMst6.IPM_Section_Sequence__c='6.1';
        secMst6.IPM_Section_Name__c='Business Case vs. Action Standards';
        insert secMst6;
        
        secMst7=new IPM_Section__c();
        secMst7.IPM_Document_Template__c=ipdt.ID;
        secMst7.IPM_Section_Sequence__c='7.1';
        secMst7.IPM_Section_Name__c='Rollout Plans';
        insert secMst7;
        
        
        secMst8=new IPM_Section__c();
        secMst8.IPM_Document_Template__c=ipdt.ID;
        secMst8.IPM_Section_Sequence__c='2.2';
        secMst8.IPM_Section_Name__c='Customers/Channels';
        insert secMst8;
        
        secMst9=new IPM_Section__c();
        secMst9.IPM_Document_Template__c=ipdt.ID;
        secMst9.IPM_Section_Sequence__c='7.2';
        secMst9.IPM_Section_Name__c='Risk';
        insert secMst9;
        
        secMst10=new IPM_Section__c();
        secMst10.IPM_Document_Template__c=ipdt.ID;
        secMst10.IPM_Section_Sequence__c='7.3';
        secMst10.IPM_Section_Name__c='Milestones';
        insert secMst10;
        
        secMst11=new IPM_Section__c();
        secMst11.IPM_Document_Template__c=ipdt.ID;
        secMst11.IPM_Section_Sequence__c='7.5';
        secMst11.IPM_Section_Name__c='OTIF Status';
        secMst11.IPM_Section_Type__c='Static Table';
        insert secMst11;
        
        secMst12=new IPM_Section__c();
        secMst12.IPM_Document_Template__c=ipdt.ID;
        secMst12.IPM_Section_Sequence__c='1.2';
        secMst12.IPM_Section_Name__c='Feedback from Last Gate';
        insert secMst12;
        
        secMst13=new IPM_Section__c();
        secMst13.IPM_Document_Template__c=ipdt.ID;
        secMst13.IPM_Section_Sequence__c='6.1';
        secMst13.IPM_Section_Name__c='Financial Action Standards';
        insert secMst13;
        
        secMst14=new IPM_Section__c();
        secMst14.IPM_Document_Template__c=ipdt.ID;
        secMst14.IPM_Section_Sequence__c='1.3';
        secMst14.IPM_Section_Name__c='Feedback from BOSSCARD';
        insert secMst14;
        
        secMst15=new IPM_Section__c();
        secMst15.IPM_Document_Template__c=ipdt.ID;
        secMst15.IPM_Section_Sequence__c='1.2';
        secMst15.IPM_Section_Name__c='Justification';
        secMst15.IPM_Section_Type__c='Sub Header';
        insert secMst15;
        
        project=new IPM_Project__c();
        project.Name='TestComments';
        
        project.IPM_Phase__c='Ideas';
        project.IPM_Complexity__c='Full';
        project.IPM_GateKeeping_Model__c='GCLT & RCLT'; 
        insert project;
        
        projRoll=new IPM_Project_Rollout__c();
        projRoll.IPM_Project__c=project.ID;
        projRoll.RecordTypeId=Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get('Regional Rollout').RecordTypeId;
        projRoll.IPM_Rollout_Project__c='TestComments_SEAA';
        projRoll.Market_Cluster__c='SEAA';
        projRoll.Target_Launch_Date__c=date.today();
        projRoll.IPM_Regional_PL__c=u1.Id;
        insert projRoll;
        
        roll.ParentId= projRoll.Id;
        roll.userOrGroupId = psa.AssigneeId ;
        roll.accesslevel = 'Edit';
        rollShareList.add(roll);
        insert rollShareList;
        
        projDoc=new IPM_Project_Document__c();
        projDoc.IPM_GateDocuments__c='Charter'; 
        projDoc.IPM_Project__c=project.ID;
        projDoc.IPM_Project_Template__c= projTempl.Id;  
        projDOc.IPM_Contract_GateKeeper_Model__c='GCLT & RCLT';
        insert projDoc;
        projDocList.add(projDoc);
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='Idea / Graphic'; 
        projDocSec.IPM_Section__c=secMst.Id;
        insert projDocSec;
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='Concept'; 
        projDocSec.IPM_Section__c=secMst1.Id;
        insert projDocSec;
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='Priority Channels, Key Customer Feedback & Implications to the Mix/Plan'; 
        projDocSec.IPM_Section__c=secMst2.Id;
        insert projDocSec;
        
        projDocSec=new IPM_Project_Document_Section__c();
        
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='Target Audience'; 
        projDocSec.IPM_Section__c=secMst3.Id;
        insert projDocSec;
        
        projDocSec=new IPM_Project_Document_Section__c();
        
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='Consumer Evidence - Concept'; 
        projDocSec.IPM_Section__c=secMst4.Id;
        insert projDocSec;
        
        projDocSec=new IPM_Project_Document_Section__c();
        
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='Mix Qualification Plan and Action Standards (Table)'; 
        projDocSec.IPM_Section__c=secMst5.Id;
        insert projDocSec;
        projDocSec=new IPM_Project_Document_Section__c();
        
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='Business Case vs. Action Standards'; 
        projDocSec.IPM_Section__c=secMst6.Id;
        insert projDocSec;
        projDocSec=new IPM_Project_Document_Section__c();
        
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='Rollout Plans'; 
        projDocSec.IPM_Section__c=secMst7.Id;
        insert projDocSec;
        projDocSec=new IPM_Project_Document_Section__c();
        
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='Customers/Channels'; 
        projDocSec.IPM_Section__c=secMst8.Id;
        insert projDocSec;
        
        
        projDocSec=new IPM_Project_Document_Section__c();
        
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='Risk'; 
        projDocSec.IPM_Section__c=secMst9.Id;
        insert projDocSec;
        projDocSec=new IPM_Project_Document_Section__c();
        
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='Milestones'; 
        projDocSec.IPM_Section__c=secMst10.Id;
        insert projDocSec;
        projDocSec=new IPM_Project_Document_Section__c();
        
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='OTIF Status'; 
        projDocSec.IPM_Section__c=secMst11.Id;
        insert projDocSec;
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='Feedback from Last Gate'; 
        projDocSec.IPM_Section__c=secMst12.Id;
        insert projDocSec;
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='Financial Action Standards'; 
        projDocSec.IPM_Section__c=secMst13.Id;
        insert projDocSec;
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='Feedback from BOSSCARD'; 
        projDocSec.IPM_Section__c=secMst14.Id;
        insert projDocSec;
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section_Name__c='Justification'; 
        projDocSec.IPM_Section__c=secMst15.Id;
        insert projDocSec;

        projDocSecCon=new IPM_Project_Document_Section_Content__c();
        projDocSecCon.IPM_Project_Document_Section__c=projDocSec.ID;
        insert projDocSecCon;
        
        ques=new IPM_Questionnaire__c();
        ques.RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('GateKeeperChecklist').RecordTypeId;
        ques.IPM_Sequence_Number__c=1;
        ques.IPM_Section_Sequence_Number__c='1.2.1';
        ques.IPM_Question__c='Test GK Question';
        ques.IPM_RQS_Gate_Type__c='Charter';
        ques.IPM_HelpText_Yes__c='Help Text Yes';
        ques.IPM_HelpText_No__c='help Text No';
        ques.IPM_HelpText_Partly__c='help text partly';
        ques.IPM_Project_Document_Section__c=projDocSec.Id;
        ques.Is_Master__c=true;
        insert ques;
        
        ipmOtif=new IPM_OTIF_Status__c ();
        ipmOtif.Name='Contract Attractive Business';
        ipmOtif.IPM_Gate_Document_Type__c='Contract';
        insert ipmOtif;
        Test.stopTest();
    }
    static testMethod void testCreateContractDocument()
    {
        initializeData();
        
        IPM_CreateGateDocuments ipmCreateDoc=new IPM_CreateGateDocuments();
        IPM_CreateRolloutProjects.createProjects(projDocList);
        
        IPM_CreateGateDocuments.createContractDocument(projDocList, project.IPM_GateKeeping_Model__c);
    }
    static testMethod void testCreateMRDocument()
    {
        initializeDataMarketReady();
        IPM_CreateGateDocuments.createMarketReadyDocument(projDocList);
    }
    static testMethod void testCreateMDDocument()
    {
        initializeDataMarketDeployment();
        IPM_CreateGateDocuments.createMarketDeploymentDocument(projDocList);
    }
    
    public static User  testRunAs() {
        List<User> usrname = [SELECT UserName from User where UserName='standarduser@testorg4.com' ];
        User u = new User();
        
        if(usrname== null){
            // Setup test data
            // This code runs as the system user
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            
            u = new User(Alias = 'cregd5', Email='cregd5@testorg4.com', 
            EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='cregd5@testorg4.com', 
            IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
            IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
            insert u;
            
            
            
            System.runAs(u) {
                
                
                PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic'];
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.AssigneeId = u.Id;
                psa.PermissionSetId = ps.Id;
                insert psa;
                
                
                // The following code runs as user 'u' 
                System.debug('Current User: ' + UserInfo.getUserName());
                System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            }
        }
        else {
            if(usrname.size()>0){
                u = [SELECT Alias,Email,EmailEncodingKey,LastName,LanguageLocaleKey,LocaleSidKey,ProfileId ,TimeZoneSidKey,UserName, IPM_Category__c ,IPM_Brand_Positioning__c, IPM_Brand_Name__c ,IPM_Role__c , IPM_Sub_Category__c    from User where UserName='standarduser@testorg4.com' ];
                
            }     
        }   
        return u ;
    }
}