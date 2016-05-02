public with sharing class AR_InsuranceTradeRegsAndPolicyController extends AR_ApplicationBaseController
{
    public List<AR_SObjectHolder> insuranceObjectList {get;set;}
    public List<AR_SObjectHolder> policyObjectList {get;set;}
    public List<AR_SObjectHolder> tradeRegulatoryObjectList {get;set;}
    
    public AR_SObjectHolder applicationObject {get;set;}
    public AR_SObjectHolder insuranceObject {get;set;}
    public AR_SObjectHolder policyObject {get;set;}
    public AR_SObjectHolder tradeRegulatoryObject {get;set;}
    
    private String RTInsurance;
    private String RTCompanyPolicies;
    private String RTTradeRegulatoryBodies;
    
    public AR_InsuranceTradeRegsAndPolicyController()
    {
        this.insuranceObject    = new AR_SObjectHolder(getCleanInsuranceObject());
        this.insuranceObjectList = new List<AR_SObjectHolder>();
        
        this.policyObject       = new AR_SObjectHolder(getCleanPolicyObject());
        this.policyObjectList   = new List<AR_SObjectHolder>();
        
        this.tradeRegulatoryObject      = new AR_SObjectHolder(getCleanTradeRegulatoryObject());
        this.tradeRegulatoryObjectList  = new List<AR_SObjectHolder>();
    }
    
    private void loadMyFieldSets()
    {
        fieldSetMap = new Map<String,Map<String,List<Schema.FieldSetMember>>>();
        this.fieldSetMap.put('ar_Insurance_and_Policy__c', AR_MetaDataHandler.GetAllInsurancePolicyFieldsets());
    }
    
    private void loadMyData()
    {
        AR_ObjectSelectHandler2 tmp_dataHandler = new AR_ObjectSelectHandler2(application.getId());
        
        RTInsurance             = tmp_DataHandler.currentRTMap.get('ar_Insurance_and_Policy__c').get('Insurance').Id;
        
        System.debug('#RTInsurance: ' + RTInsurance);
        
        RTCompanyPolicies       = tmp_DataHandler.currentRTMap.get('ar_Insurance_and_Policy__c').get('Company_Policies').Id;
        
        System.debug('#RTCompanyPolicies: ' + RTCompanyPolicies);
        
        RTTradeRegulatoryBodies = tmp_DataHandler.currentRTMap.get('ar_Insurance_and_Policy__c').get('Trade_and_Regulatory_Bodies').Id;
        
        System.debug('#RTTradeRegulatoryBodies: ' + RTTradeRegulatoryBodies);
        
        this.insuranceObject        = new AR_SObjectHolder(getCleanInsuranceObject());
        this.policyObject           = new AR_SObjectHolder(getCleanPolicyObject());
        this.tradeRegulatoryObject  = new AR_SObjectHolder(getCleanTradeRegulatoryObject());
        
        this.applicationObject      = tmp_DataHandler.SelectApplication(new Set<String>());
        
        Set<String> tmp_fieldsInsuranceObjectList = AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Insurance_and_Policy__c'));
        
        // Query Insurance
        if(tmp_fieldsInsuranceObjectList != null)
        {
            insuranceObjectList = tmp_dataHandler.SelectInsuranceObjectList(tmp_FieldsInsuranceObjectList);
            
            if(insuranceObjectList.isEmpty())
            {
                InsuranceObjectList = AR_FixedDescriptionsHandler.getInsuranceOptions(getCleanInsuranceObject());
            }
        }
        
        // Query Polices
        if(tmp_FieldsInsuranceObjectList != null)
        {
            policyObjectList = tmp_DataHandler.SelectPolicyObjectList(tmp_FieldsInsuranceObjectList);
            
            if(policyObjectList.isEmpty())
            {
                policyObjectList = AR_FixedDescriptionsHandler.getPolicies(getCleanPolicyObject());
            }
        }
        
        
        // Query Trades
        if(tmp_FieldsInsuranceObjectList != null)
        {
            tradeRegulatoryObjectList = tmp_DataHandler.SelectTradeRegulatoryObjectList(tmp_FieldsInsuranceObjectList);
        }
        
        if(tradeRegulatoryObjectList.isEmpty())
        {
        	addRowToTradeRegulatoryObjectList();
        }
        // Query attachments
        
        
    }
    
    protected override void loadObjectsForProgressBar() {
        addFormList('ar_Insurance_and_Policy__c#Insurance', insuranceObjectList);
        addFormList('ar_Insurance_and_Policy__c#Policy', policyObjectList);
        addFormList('ar_Insurance_and_Policy__c#Trade', tradeRegulatoryObjectList);
        addFormObject('ar_Application__c', applicationObject);
    }
    
    public void saveMyData()
    {
        cleanInsuranceObjectList();
        cleanPolicyObjectList();
        cleanTradeRegulatoryObjectList();
        
        List<ar_Insurance_and_Policy__c> tmp_ObjListUpsert = new List<ar_Insurance_and_Policy__c>();
        List<ar_Insurance_and_Policy__c> tmp_ObjListDelete = new List<ar_Insurance_and_Policy__c>();
        
        for(AR_SObjectHolder obj:InsuranceObjectList)
        {
            tmp_ObjListUpsert.add((ar_Insurance_and_Policy__c) obj.obj);
        }
        
        for(AR_SObjectHolder obj:PolicyObjectList)
        {
            tmp_ObjListUpsert.add((ar_Insurance_and_Policy__c) obj.obj);
        }
        
        for(AR_SObjectHolder obj:TradeRegulatoryObjectList)
        {
            if(obj.getId() != null && obj.getIsDeleted())
            {
                tmp_ObjListDelete.add((ar_Insurance_and_Policy__c) obj.obj);
            }
            else
            {
                tmp_ObjListUpsert.add((ar_Insurance_and_Policy__c) obj.obj);
            }
        }
        
        System.Debug('#tmp_ObjListUpsert: ' + tmp_ObjListUpsert);
        
        upsert tmp_ObjListUpsert;
        
        update applicationObject.obj;
        
        List<Attachment> tmp_attachmentstoUpsert = new List<Attachment>();
        
        for(AR_SObjectHolder obj:InsuranceObjectList)
        {
            obj.setAllFilesParentIds();
            if(!obj.getFilesasList().isempty())
            {
                tmp_attachmentstoUpsert.addall(obj.getFilesasList());
            }
        }
        
        for(AR_SObjectHolder obj:PolicyObjectList)
        {
            obj.setAllFilesParentIds();
            if(!obj.getFilesasList().isempty())
            {
                tmp_attachmentstoUpsert.addall(obj.getFilesasList());
            }
        }
        
        for(AR_SObjectHolder obj:TradeRegulatoryObjectList)
        {
            obj.setAllFilesParentIds();
            if(!obj.getFilesasList().isempty())
            {
                tmp_attachmentstoUpsert.addall(obj.getFilesasList());
            }
        }
        
        if(!tmp_attachmentstoUpsert.isempty())
        {
            upsert tmp_attachmentstoUpsert;
        }
        
        for(AR_SObjectHolder obj:InsuranceObjectList)
        {
            obj.SetAllBodystoNull();
        }
        
        for(AR_SObjectHolder obj:PolicyObjectList)
        {
            obj.SetAllBodystoNull();
        }
        
        for(AR_SObjectHolder obj:TradeRegulatoryObjectList)
        {
            obj.SetAllBodystoNull();
        }
        
        if(tradeRegulatoryObjectList.isEmpty())
        {
        	addRowToTradeRegulatoryObjectList();
        }
        // Upsert Insurance
        
        
        // Upsert Policies
        
        
        // Upsert Trades
        
        
        // Upsert attachments
        
        
    }
    
    
    // Add row
    public PageReference addRowToInsuranceObjectList()
    {
        insuranceObjectList.add(insuranceObject);
        insuranceObject = new AR_SObjectHolder(getCleanInsuranceObject());
        
        return null;
    }
    
    public PageReference addRowToPolicyObjectList()
    {
        policyObjectList.add(policyObject);
        policyObject = new AR_SObjectHolder(getCleanPolicyObject());
        
        saveMyData();
        
        return null;
    }
    
    public PageReference addRowToTradeRegulatoryObjectList()
    {
        tradeRegulatoryObjectList.add(tradeRegulatoryObject);
        tradeRegulatoryObject = new AR_SObjectHolder(getCleanTradeRegulatoryObject());
        
        return null;
    }
    
    
    
    private ar_Insurance_and_Policy__c getCleanInsuranceObject()
    {
        return new ar_Insurance_and_Policy__c(RecordTypeId = RTInsurance, Application__c = (Id) application.getId());
    }
    
    
    private ar_Insurance_and_Policy__c getCleanPolicyObject()
    {
        return new ar_Insurance_and_Policy__c(RecordTypeId = RTCompanyPolicies, Application__c = (Id) application.getId(),Held__c =false,Attached_to_Supporting_Docs_Tab__c = false);
    }
    
    
    private ar_Insurance_and_Policy__c getCleanTradeRegulatoryObject()
    {
        return new ar_Insurance_and_Policy__c(RecordTypeId = RTTradeRegulatoryBodies, Application__c = (Id) application.getId());
    }
    
    
    public void cleanInsuranceObjectList()
    {
        ar_Insurance_and_Policy__c tmp_cleanobj = GetCleanInsuranceObject();
        
        List<AR_SObjectHolder> tmp_newObjList = new List<AR_SObjectHolder>();
        
        for(AR_SObjectHolder obj : insuranceObjectList)
        {
            if(tmp_cleanobj != obj.obj)
            {
                tmp_newObjList.add(obj);
            }
        }
        
        insuranceObjectList = tmp_newObjList;
    }
    
    public void cleanPolicyObjectList()
    {
        ar_Insurance_and_Policy__c tmp_cleanobj = GetCleanPolicyObject();
        
        List<AR_SObjectHolder> tmp_newObjList = new List<AR_SObjectHolder>();
        
        for(AR_SObjectHolder obj : policyObjectList)
        {
            if(tmp_cleanobj != obj.obj)
            {
                tmp_newObjList.add(obj);
            }
        }
        
        policyObjectList = tmp_newObjList;
    }
    
    public void cleanTradeRegulatoryObjectList()
    {
        ar_Insurance_and_Policy__c tmp_cleanobj = GetCleanTradeRegulatoryObject();
        
        List<AR_SObjectHolder> tmp_newObjList = new List<AR_SObjectHolder>();
        
        for(AR_SObjectHolder obj : tradeRegulatoryObjectList)
        {
            if(tmp_cleanobj != obj.obj)
            {
                tmp_newObjList.add(obj);
            }
        }
        
        tradeRegulatoryObjectList = tmp_newObjList;
    }
    
}