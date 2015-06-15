@isTest
public class IPMProcessFinancialUpload_Test {
    public static IPM_Project__c project;
    public static IPM_Project__c childProject;
    public static IPM_Project_Rollout__c proRoll=new IPM_Project_Rollout__c();
    public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
    public static Id currentFinancialId;
    public static IPM_Financial__c finCon=new IPM_Financial__c();
    public static IPM_Financial__c finDef=new IPM_Financial__c();
    public static IPM_Financial_Year__c finYear=new IPM_Financial_Year__c();
    public static Attachment attach1 = new Attachment();
    public static Attachment attach2 = new Attachment();
    public static Attachment sharedStringAttachment= new Attachment();
    public static String xmlContent;
    public static String ipmFinancialFileId;
    public static Map<String, Attachment> mapAttachments=new Map<String, Attachment>();
    public static Map<String, IPM_Financial__c> mapFinancials=new Map<String, IPM_Financial__c>();
    public static Map<String, IPM_Financial_Year__c> mapFinancialYears=new Map<String, IPM_Financial_Year__c>();
    public static string proId;
   // public static Map<String, Attachment> mapAttachments=new Map<String, Attachment>();
    public static IPM_Financial_File__c finFile=new IPM_Financial_File__c(); 
    public static string SHARED_STRINGS='ABCDEF.xlsx';
    
    static testMethod void initializeData(){
        project=new IPM_Project__c();
        project.Name='ABCDEF';
        project.IPM_Phase__c='Ideas';
        project.IPM_Complexity__c='Lite';
        //project.IPM_GateKeeping_Model__c='RCLT'; 
        project.Sustainability_Period__c='3';
        insert project;
        
        /*childProject=new IPM_Project__c();
        childProject.Name='TESTAPPROVERCL_SEAA';
        childProject.IPM_Phase__c='Feasibility';
        childProject.IPM_Complexity__c='Full';
        childProject.IPM_GateKeeping_Model__c='RCLT'; 
        childProject.Sustainability_Period__c='3';
        insert childProject;*/

        String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
        proRoll=new IPM_Project_Rollout__c();
        proRoll.Name='ABCDEF_SEAA';
        proRoll.RecordTypeId=strRecordTypeId;
        proRoll.IPM_Project__c=project.ID;
        proRoll.Target_Launch_Date__c=System.today();
        proRoll.Market_Cluster_Name__c='SEAA';
        proRoll.Market_Cluster__c='GEO0022';
        proRoll.Local_Project__c=project.Id;
        proRoll.Regional_Project__c=project.Id;
        insert proRoll;
        
        String strRecordTypeId1=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
        finCon.RecordTypeId=strRecordTypeId1;
        finCon.Volume_Unit__c='Total Tons';
        finCon.Financial_External_ID__c='ABCDEF_CONSOLIDATED';
        finCon.Target_Launch_Date__c=System.today();
        finCon.Status__c='Not Started';
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        finCon.Parent_Project__c=project.Id;
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        insert finCon;
         
        String strRecordTypeId2=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Default'].Id;
        finDef.RecordTypeId=strRecordTypeId2;
        finDef.Volume_Unit__c='Total Tons';
        finDef.Financial_External_ID__c='external11';
        finDef.Target_Launch_Date__c=System.today();
        finDef.Status__c='Not Started';
        finDef.IPM_Project_Rollout__c=proRoll.Id;
        finDef.Parent_Project__c=project.Id;
        finDef.IPM_Project_Rollout__c=proRoll.Id;
        insert finDef;
        
        currentFinancialId=finDef.Id;
         
        finYear.IPM_Financial__c=finCon.Id;
        finYear.Name='Y0';
        finYear.Year__c='0';
        finYear.Year_Type__c='Innovation';
        insert finYear;  
        
        String strRecordTypeId3=[Select Id From RecordType Where SobjectType='IPM_Financial_File__c' and Name='Default'].Id;
          finFile.RecordTypeId=strRecordTypeId3;
        finFile.Name='ABCDEF.xlsx';
        finFile.IPM_Project__c=project.Id;
        
        insert finFile; 
        
        
        
        /*xmlContent = 'This is a test string';   
          
        attach1.parentId = finCon.id;
        String nameF='xl/sharedStrings.xml';
        
        attach1.name = nameF;
        //attach1.body = blob.toPDF(nameF);
        String s=EncodingUtil.base64Encode(Blob.valueOf(xmlContent));
        attach1.body=blob.toPDF(s);
        //String nameFile= EncodingUtil.base64Encode(attach1); 
        insert attach1;*/
        
        Blob b = Blob.valueOf('est Data');  
      
    //Attachment attachment = new Attachment();  
    attach1.ParentId = finCon.Id;  
    attach1.Name = 'xl/sharedStrings.xml';  
    attach1.Body = b; 
    insert attach1;
        
       /* xmlContent = 'This is a test string1';       
        attach2.parentId = finFile.id;
        attach2.name = 'xl/worksheets/sheet1.xml';
        attach2.body = blob.toXML(xmlContent);
        insert attach2;*/
        
        //sharedStringAttachment=attach;
    }
    
     static testMethod void dotest(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        Test.setCurrentPage(pRef);
        mapFinancials.put(finCon.Id,finCon);
         mapFinancialYears.put(finYear.Id,finYear);
         ipmFinancialFileId=finCon.Id;
        IPMProcessFinancialUpload ipnProFinUp=new IPMProcessFinancialUpload();
       //proId=ipnProFinUp.execute(ipmFinancialFileId);
       
    }
}