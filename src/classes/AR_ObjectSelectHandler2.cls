public with sharing class AR_ObjectSelectHandler2 {
    //***************************
    //Attributes
    //***************************
    public Map<String,Map<String, RecordType>> currentRTMap {get;set;}
    //***************************
    //Variables
    //***************************
    public String x_ApplicationId;
    
    private String RTCompanyPolicies;
    private String RTInsurance;
    private String RTTradeRegulatoryBodies;
    
    private String RTGeneral;
    private String RTNonUnilever;
    private String RTExperience;
    private String RTProject;
    
    private String RTTask;
    private String RTArtwork;
    
    //***************************
    //Constructor
    //***************************
    public AR_ObjectSelectHandler2(String AppId)
    {
        x_ApplicationId = AppId;
        currentRTMap = new Map<String,Map<String, RecordType>>();
        currentRTMap = AR_ObjectSelectHandler2.getRecordTypeInfo(new Set<String>{'ar_Experience__c','ar_Insurance_and_Policy__c', 'ar_Fixed_Price_Rate_Card__c'}, new Set<String>{'Task', 'Artwork','Company_Policies', 'Insurance', 'Trade_and_Regulatory_Bodies','Project','Expertise', 'Experience'});
        //Recird Type call
        RTGeneral       = currentRTMap.get('ar_Experience__c').get('Expertise').id; //General
        RTExperience        = currentRTMap.get('ar_Experience__c').get('Experience').id;
        RTProject       = currentRTMap.get('ar_Experience__c').get('Project').id;
            
        RTCompanyPolicies       = currentRTMap.get('ar_Insurance_and_Policy__c').get('Company_Policies').id;
        RTInsurance             = currentRTMap.get('ar_Insurance_and_Policy__c').get('Insurance').id;
        RTTradeRegulatoryBodies = currentRTMap.get('ar_Insurance_and_Policy__c').get('Trade_and_Regulatory_Bodies').id;
        
        RTTask                      = currentRTMap.get('ar_Fixed_Price_Rate_Card__c').get('Task').Id;
        RTArtwork                   = currentRTMap.get('ar_Fixed_Price_Rate_Card__c').get('Artwork').Id;
    }
    
    //***************************
    //Methodes
    //***************************
    
    
    public AR_SObjectHolder SelectApplication(Set<String> p_FieldSet)
    {
        AR_SObjectHolder tmp_AppData = new AR_SObjectHolder();
        Set<String> tmp_FieldSet = p_FieldSet;
        
        String query = 'SELECT ';
        tmp_FieldSet.add('Name');
        //tmp_FieldSet.add('Id');
        tmp_FieldSet.add('Length_of_client_relationship__c');
        tmp_FieldSet.add('Additional_Information__c');
        tmp_FieldSet.add('Strategic_Capabilities__c');
        tmp_FieldSet.add('Strategic_Capabilities_Video__c');
        tmp_FieldSet.add('Agency_Expertise__c');
        tmp_FieldSet.add('Awards__c');
        tmp_FieldSet.add('Vimeo_Link__c');
        tmp_FieldSet.add('Currency__c');
        
        for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }
        query += 'Id, Form_Progress__c FROM ar_Application__c where Id = :x_ApplicationId ';
            
        for(ar_Application__c App:Database.query(query))
        {
            tmp_AppData = new AR_SObjectHolder(App);
        }
        
        // load attachments
        tmp_AppData.setFiles( getFiles(tmp_AppData.getId(), false) );
        
        return tmp_AppData;
    }
    
    public List<AR_SObjectHolder> selectProjectObjectList(Set<String> p_FieldSet)
    {
        List<AR_SObjectHolder> tmp_ObjData = new List<AR_SObjectHolder>();
        Set<String> tmp_FieldSet = p_FieldSet;
        
        String query = 'SELECT ';
        
        tmp_FieldSet.add('Name');
        //tmp_FieldSet.add('Id');
        
        for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }
        query += 'Id FROM ar_Experience__c where Application__c  = :x_ApplicationId and RecordTypeId = :RTProject ';
        
        Set<Id> prjIds = new Set<Id>(); 
        for(ar_Experience__c Data:Database.query(query))
        {
            tmp_ObjData.add(new AR_SObjectHolder(Data));
            prjIds.add( data.id );
        }
        
        List<Attachment> prjFiles = getFiles( prjIds, false);
        for(AR_SObjectHolder prj : tmp_ObjData)
            prj.setFiles( prjFiles );
            
            
        return tmp_ObjData;
    }
    
    public List<AR_SObjectHolder> SelectFinancial(Set<String> p_FieldSet)
    {
        List<AR_SObjectHolder> tmp_ObjData = new List<AR_SObjectHolder>();
        Set<String> tmp_FieldSet = p_FieldSet;
        
        String query = 'SELECT ';
        
        tmp_FieldSet.add('Name');
        //tmp_FieldSet.add('Id');
        
        for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }
        query += 'Id FROM ar_Financial__c where Application__c  = :x_ApplicationId ';
            
        for(ar_Financial__c Data:Database.query(query))
        {
            
            tmp_ObjData.add(new AR_SObjectHolder(Data));
        }
        
        return tmp_ObjData;
    }
    
    
    public List<AR_SObjectHolder> SelectShareholder(Set<String> p_FieldSet)
    {
        List<AR_SObjectHolder> tmp_ObjData = new List<AR_SObjectHolder>();
        Set<String> tmp_FieldSet = p_FieldSet;
        
        String query = 'SELECT ';
        
        tmp_FieldSet.add('Name');
        //tmp_FieldSet.add('Id');
        
        for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }
        query += 'Id FROM ar_Shareholder__c where Application__c  = :x_ApplicationId ';
            
        for(ar_Shareholder__c Data:Database.query(query))
        {
            
            tmp_ObjData.add(new AR_SObjectHolder(Data));
        }
        
        return tmp_ObjData;
    }
    
    public List<AR_SObjectHolder> SelectFixRateCard(Set<String> p_FieldSet)
    {
        List<AR_SObjectHolder> tmp_ObjData = new List<AR_SObjectHolder>();
        Set<String> tmp_FieldSet = p_FieldSet;
        
        String query = 'SELECT ';
        
        tmp_FieldSet.add('Name');
        //tmp_FieldSet.add('Id');
        
        for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }
        query += 'Id FROM ar_Fixed_Price_Rate_Card__c where Application__c  = :x_ApplicationId ';
            
        for(ar_Fixed_Price_Rate_Card__c Data:Database.query(query))
        {
            
            tmp_ObjData.add(new AR_SObjectHolder(Data));
        }
        
        return tmp_ObjData;
    }
    
    public AR_SObjectHolder selectAgencyExperience(Set<String> p_FieldSet)
    {
        System.debug('#### START');
        AR_SObjectHolder tmp_ObjData = new AR_SObjectHolder();
        Set<String> tmp_FieldSet = p_FieldSet;
        
        String query = 'SELECT ';
        
        tmp_FieldSet.add('Name');
        //tmp_FieldSet.add('Id');
        
        for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }
        query += 'Id FROM ar_Experience__c where Application__c  = :x_ApplicationId and RecordTypeId = :RTGeneral';
        System.debug('#### Query ar_Experience__c' + query) ;
        Set<Id> ExperienceIds = new Set<Id>();  
        for(ar_Experience__c Data:Database.query(query))//Database.query(query)
        {
            tmp_ObjData = new AR_SObjectHolder(Data);
            ExperienceIds.add( data.id );
        }
        
        List<Attachment> ExperienceFiles = getFiles( ExperienceIds, false);
    
        tmp_ObjData.setFiles( ExperienceFiles );
        
        return tmp_ObjData;
    }
    
    public List<AR_SObjectHolder> SelectRevenueBreakdownObjectList(Set<String> p_FieldSet)
    {
        List<AR_SObjectHolder> tmp_DataList = new List<AR_SObjectHolder>();
        Set<String> tmp_FieldSet = p_FieldSet;
        
        String query = 'SELECT ';
        
        tmp_FieldSet.add('Name');
        //tmp_FieldSet.add('Id');
        
        for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }
        query += 'Id FROM ar_Revenue_Breakdown__c where Application__c  = :x_ApplicationId ';
            
        for(ar_Revenue_Breakdown__c Data:Database.query(query))
        {
            tmp_DataList.add(new AR_SObjectHolder(Data));
        }
        
        return tmp_DataList;
    }
    
            
    public List<AR_SObjectHolder> SelectGeographyObjectList(Set<String> p_FieldSet)
    {
        List<AR_SObjectHolder> tmp_DataList = new List<AR_SObjectHolder>();
        Set<String> tmp_FieldSet = p_FieldSet;
        
        String query = 'SELECT ';
        
        tmp_FieldSet.add('Name');
        //tmp_FieldSet.add('Id');
        
        for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }
        query += 'Id FROM ar_Geography__c where Application__c  = :x_ApplicationId ';
            
        for(ar_Geography__c Data:Database.query(query))
        {
            tmp_DataList.add(new AR_SObjectHolder(Data));
        }
        
        return tmp_DataList;
    }
    
    public Map<String,List<AR_SObjectHolder>> selectAllExperienceObjects(Set<String> p_FieldSet)
    {
        Map<String,List<AR_SObjectHolder>> tmp_returnMap = new Map<String,List<AR_SObjectHolder>>();
        Set<String> tmp_values = new Set<String>{'Unilever','Non-Unilever'};
        List<AR_SObjectHolder> tmp_DataListuni = new List<AR_SObjectHolder>();
        List<AR_SObjectHolder> tmp_DataListNonuni = new List<AR_SObjectHolder>();
        
        Set<String> tmp_FieldSet = p_FieldSet;
        tmp_FieldSet.add('Name');
        
        String query = 'SELECT ';
        
         for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }//RTGeneral //RTExperience
        query += 'Id FROM ar_Experience__c where Application__c  = :x_ApplicationId and RecordTypeId = : RTExperience and Unilever_Non_Unilever__c IN :tmp_values';
        
        for(ar_Experience__c Data:Database.query(query))
        {
            if(Data.Unilever_Non_Unilever__c == 'Unilever')
            {
                tmp_DataListuni.add(new AR_SObjectHolder(Data));
            }
            else
            {
                tmp_DataListNonuni.add(new AR_SObjectHolder(Data));
            }
        }
        tmp_returnMap.put('Unilever',tmp_DataListuni);
        tmp_returnMap.put('NonUnilever',tmp_DataListNonuni);
        
        return tmp_returnMap;
    }

    public List<AR_SObjectHolder> SelectRateCardObjectList(Set<String> p_FieldSet)
    {
        List<AR_SObjectHolder> tmp_DataList = new List<AR_SObjectHolder>();
        Set<String> tmp_FieldSet = p_FieldSet;
        
        String query = 'SELECT ';
        tmp_FieldSet.add('Name');
        //tmp_FieldSet.add('Id');
        
        for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }
        query += 'Id FROM ar_Rate_Card__c where Application__c  = :x_ApplicationId ';
            
        for(ar_Rate_Card__c Data:Database.query(query))
        {
            tmp_DataList.add(new AR_SObjectHolder(Data));
        }
        
        return tmp_DataList;
    }   
    
    public List<AR_FixedRateCardHelper> SelectFixedRateCard(Set<String> p_FieldSet)
    {
        List<AR_SObjectHolder> tmp_DataList = new List<AR_SObjectHolder>();
        Map<String,AR_FixedRateCardHelper> tmp_RateCardMap = new  Map<String,AR_FixedRateCardHelper>();
        
        Set<String> tmp_FieldSetForFRCC = new Set<String> ();
        
        String queryFRCC = 'SELECT ';
        tmp_FieldSetForFRCC.add('Agency__c');
        tmp_FieldSetForFRCC.add('Application__c');
        tmp_FieldSetForFRCC.add('Country__c');
        tmp_FieldSetForFRCC.add('Name');
        tmp_FieldSetForFRCC.add('Rate_Card_Comments__c');
        
        for(String f : tmp_FieldSetForFRCC) 
        {
            queryFRCC += f + ', ';
        }
        
        queryFRCC += 'Id FROM ar_Fixed_Price_Rate_Card_Location__c where Application__c  = :x_ApplicationId';
        
        for(ar_Fixed_Price_Rate_Card_Location__c Data:Database.query(queryFRCC))
        {
        	AR_SObjectHolder rc = new AR_SObjectHolder();
            rc.obj = Data;
            AR_FixedRateCardHelper tmphelper = new AR_FixedRateCardHelper(rc);
            tmp_RateCardMap.put(Data.id,tmphelper);
        }
        
        Set<String> tmp_FieldSet = p_FieldSet;
        
        String query = 'SELECT ';
        tmp_FieldSet.add('Order__c');
        tmp_FieldSet.add('Task_Group_short__c');
        tmp_FieldSet.add('RecordTypeId');
        tmp_FieldSet.add('FRC_Country__c');
        
        for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }
        query += 'Id FROM ar_Fixed_Price_Rate_Card__c where Application__c  = :x_ApplicationId ORDER BY Order__c';
        
        for(ar_Fixed_Price_Rate_Card__c Data:Database.query(query))
        {
        	if(tmp_RateCardMap.containskey(Data.FRC_Country__c))
        	{
        	   AR_SObjectHolder rc = new AR_SObjectHolder();
           	   rc.obj = Data;
           	   tmp_RateCardMap.get(Data.FRC_Country__c).addObjtoList(rc);
        	}
           
        }
        return tmp_RateCardMap.values();
    }

    public List<AR_SObjectHolder> SelectSupplierInfoObjectList(Set<String> p_FieldSet)
    {
        List<AR_SObjectHolder> tmp_DataList = new List<AR_SObjectHolder>();
        Set<String> tmp_FieldSet = p_FieldSet;
        
        String query = 'SELECT ';
        
        tmp_FieldSet.add('Name');
        //tmp_FieldSet.add('Id');
        
        
        for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }
        query += 'Id FROM ar_Supplier_Info__c where Application__c  = :x_ApplicationId ';
        
        Set<Id> supplierIds = new Set<Id>();
        for(ar_Supplier_Info__c Data:Database.query(query))
        {
            tmp_DataList.add(new AR_SObjectHolder(Data));
            supplierIds.add( data.id );
        }
        
        // load files
        List<Attachment> supplierFiles = getFiles( supplierIds, false);
        for(AR_SObjectHolder supplier : tmp_DataList)
            supplier.setFiles( supplierFiles );
        
        return tmp_DataList;
    }

    public List<AR_SObjectHolder> SelectInsuranceObjectList(Set<String> p_FieldSet)
    {
        List<AR_SObjectHolder> tmp_DataList = new List<AR_SObjectHolder>();
        Set<String> tmp_FieldSet = p_FieldSet;
        
        String query = 'SELECT ';
        
        tmp_FieldSet.add('Name');
        //tmp_FieldSet.add('Id');
        tmp_FieldSet.add('Custom_Setting_Data__c');
        
        for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }
        query += 'Id FROM ar_Insurance_and_Policy__c where Application__c  = :x_ApplicationId and RecordTypeId = :RTInsurance';
            
        for(ar_Insurance_and_Policy__c Data:Database.query(query))
        {
            AR_SObjectHolder tmp_holder = new AR_SObjectHolder(Data);
            if(Data.Custom_Setting_Data__c = true )
            {
                tmp_holder.setPrefilled(true);
            }
            tmp_DataList.add(tmp_holder);
        }
        
        return tmp_DataList;
    }       

    public List<AR_SObjectHolder> SelectPolicyObjectList(Set<String> p_FieldSet)
    {
        List<AR_SObjectHolder> tmp_DataList = new List<AR_SObjectHolder>();
        Set<String> tmp_FieldSet = p_FieldSet;
        
        String query = 'SELECT ';
        
        tmp_FieldSet.add('Name');
        //tmp_FieldSet.add('Id');
        
        for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }
        query += 'Id FROM ar_Insurance_and_Policy__c where Application__c  = :x_ApplicationId and RecordTypeId = :RTCompanyPolicies';
            
        
        Set<Id> policyIds = new Set<Id>();  
        
        for(ar_Insurance_and_Policy__c Data:Database.query(query))
        {
            AR_SObjectHolder tmp_holder = new AR_SObjectHolder(Data);
            if(Data.Custom_Setting_Data__c = true )
            {
                tmp_holder.setPrefilled(true);
            }
            tmp_DataList.add(tmp_holder);
            policyIds.add( Data.id );
        }
        
        List<Attachment> policyFiles = getFiles( policyIds, false);
        
        for(AR_SObjectHolder policy : tmp_DataList)
        {
            policy.setFiles( policyFiles );
        }
        
        return tmp_DataList;
    }       

    public List<AR_SObjectHolder> SelectTradeRegulatoryObjectList(Set<String> p_FieldSet)
    {
        List<AR_SObjectHolder> tmp_DataList = new List<AR_SObjectHolder>();
        Set<String> tmp_FieldSet = p_FieldSet;
        
        String query = 'SELECT ';
        
        tmp_FieldSet.add('Name');
        //tmp_FieldSet.add('Id');
        
        
        for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }
        query += 'Id FROM ar_Insurance_and_Policy__c where Application__c  = :x_ApplicationId and RecordTypeId = :RTTradeRegulatoryBodies';
            
        for(ar_Insurance_and_Policy__c Data:Database.query(query))
        {
            tmp_DataList.add(new AR_SObjectHolder(Data));
        }
        
        return tmp_DataList;
    }
    
    public List<AR_SObjectHolder> SelectCompetitorObjectList(Set<String> p_FieldSet)
    {
        List<AR_SObjectHolder> tmp_DataList = new List<AR_SObjectHolder>();
        Set<String> tmp_FieldSet = p_FieldSet;
        
        String query = 'SELECT ';
        
        tmp_FieldSet.add('Name');
        //tmp_FieldSet.add('Id');
        
        for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }
        query += 'Id FROM ar_Competitor__c where Application__c  = :x_ApplicationId ';
            
        for(ar_Competitor__c Data:Database.query(query))
        {
            tmp_DataList.add(new AR_SObjectHolder(Data));
        }
        
        return tmp_DataList;
    }
    
    public static Map<String,Map<String, RecordType>> getRecordTypeInfo(Set<String> objType, Set<String> developerNames) {
        Map<String,Map<String, RecordType>> info = new Map<String,Map<String, RecordType>>();
        for(RecordType rt : [select id, name, developerName, sobjectType from RecordType where sobjectType in :objType and developerName in :developerNames]) {
            //info.put(rt.developerName, rt);
            if(info.containsKey(rt.sobjectType))
            {
                info.get(rt.sobjectType).put(rt.developerName,rt);
            }
            else
            {
                info.put(rt.sobjectType, new Map<String, RecordType>());
                info.get(rt.sobjectType).put(rt.developerName,rt);
            }
        }
        return info;
    }
    
    public static Map<String,Map<String, RecordType>> getAllRecordTypeInfo() {
        Map<String,Map<String, RecordType>> info = new Map<String,Map<String, RecordType>>();
        for(RecordType rt : [select id, name, developerName, sobjectType from RecordType]) {
            //info.put(rt.developerName, rt);
            if(info.containsKey(rt.sobjectType))
            {
                info.get(rt.sobjectType).put(rt.developerName,rt);
            }
            else
            {
                info.put(rt.sobjectType, new Map<String, RecordType>());
                info.get(rt.sobjectType).put(rt.developerName,rt);
            }
        }
        return info;
    }
    
    public List<Attachment> getFiles(Id parentId, boolean loadBody) {
        return getFiles(new Set<Id>{ parentId }, loadBody);
    }
    
    public List<Attachment> getFiles(Set<Id> parentIds, boolean loadBody) {
        List<Attachment> files = new List<Attachment>();
        Set<Id> local_parentIds = parentIds;
        String soql = 'SELECT Id, Name, BodyLength, ContentType, ParentId ';
        if(loadBody)
            soql += ', Body ';
        soql += ' FROM Attachment WHERE ParentId IN :local_parentIds ORDER BY Name';
        system.debug(logginglevel.info, 'FILES SOQL: ' + soql);
        for(Attachment a : Database.query(soql))
            files.add(a);
        return files;
    }
    
}