@isTest
global class OV_KpiTransactionServiceImpl_Test{
    public static final String NO_CHANGE = 'NO CHANGE';

    public static testMethod void runTransactionsOrderTest(){
        OV_KPI_Config__c config = new OV_KPI_Config__c(name = 'Config', Max__c = 10);
        insert config;
        
        List<OV_GetKPI_Mapping__c > mappingList = new List<OV_GetKPI_Mapping__c >();
        mappingList.add(new OV_GetKPI_Mapping__c(Name='timeRange', Header__c = 'Time Range', Field_API_Name__c = 'Time_Range__c',  Object_API_Name__c = 'OV_KPI_Dimension_Time_Range__c',  Order__c = 1, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='wlGroup', Header__c = 'WL Group', Field_API_Name__c = 'WL_Group__c',  Object_API_Name__c = 'OV_KPI_Dimension_WL_GROUP__c',  Order__c = 2, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='businessUnit', Header__c = 'Business Unit', Field_API_Name__c = 'Business_Unit__c',  Object_API_Name__c = 'OV_KPI_Dimension_Business_Unit__c',  Order__c = 3, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='geography', Header__c = 'Geography', Field_API_Name__c = 'Geography__c',  Object_API_Name__c = 'OV_KPI_Dimension_Geography__c',  Order__c = 4, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='organisationalUnit', Header__c = 'Org Unit', Field_API_Name__c = 'Organisational_Unit__c',  Object_API_Name__c = 'OV_KPI_Dimension_Org_Unit__c',  Order__c = 5, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='salesOrgNA', Header__c = 'Org Unit', Field_API_Name__c = 'NA_Sales_Org__c',  Object_API_Name__c = 'OV_KPI_Dimension_NA_Sales_Org__c',  Order__c = 6, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='opcoNA', Header__c = 'NA OPCO', Field_API_Name__c = 'NA_OPCO__c',  Object_API_Name__c = 'OV_KPI_Dimension_NA_OPCO__c',  Order__c = 7, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='productCategory', Header__c = 'Product Category', Field_API_Name__c = 'Product_Category__c',  Object_API_Name__c = 'OV_KPI_Dimension_Product_Category__c',  Order__c = 8, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='productCategoryNA', Header__c = 'NA Product Category', Field_API_Name__c = 'NA_Product_Category__c',  Object_API_Name__c = 'OV_KPI_Dimension_NAProductCategory__c',  Order__c = 9, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='brand', Header__c = 'Brand', Field_API_Name__c = 'Brand__c',  Object_API_Name__c = 'OV_KPI_Dimension_Brand__c',  Order__c = 10, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='brandNA', Header__c = 'NA Brand', Field_API_Name__c = 'NA_Brand__c',  Object_API_Name__c = 'OV_KPI_Dimension_NA_Brand__c',  Order__c = 11, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='customer', Header__c = 'Customer', Field_API_Name__c = 'Customer__c',  Object_API_Name__c = 'OV_KPI_Dimension_Customer__c',  Order__c = 12, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='channel', Header__c = 'Channel', Field_API_Name__c = 'Channel__c',  Object_API_Name__c = 'OV_KPI_Dimension_Channel__c',  Order__c = 13, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='kpiName', Header__c = 'KPI Name', Field_API_Name__c = 'KPI_Name__c',  Object_API_Name__c = 'OV_KPI_Dimension_KPI_Name__c',  Order__c = 14, isDisplayed__c = true));
             
        insert mappingList;       

        OV_KPI_Dimension_KPI_Name__c kpiName1 = new OV_KPI_Dimension_KPI_Name__c(Name='KPI Name 1', Visible_Columns__c='brand;businessUnit;channel;', Code__c = 'test123', Code_Text__c = 'LABEL_1234');
        insert kpiName1;

        OV_KPI_Dimension_Brand__c brand1 = new OV_KPI_Dimension_Brand__c(Name='Brand 1', Code__c = 'Brand 1');
        insert brand1;

        OV_KPI_Dimension_Business_Unit__c bUnit1 = new OV_KPI_Dimension_Business_Unit__c(Name='B Unit 1', Code__c = 'B Unit 1');
        insert bUnit1;

        OV_KPI_Dimension_Channel__c channel1 = new OV_KPI_Dimension_Channel__c(Name='Channel 1', Code__c = 'Channel 1');
        insert channel1;

        OV_KPI_Dimension_Geography__c geography1 = new OV_KPI_Dimension_Geography__c(Name='Geography 1', Code__c = 'Geography 1');
        insert geography1;

        OV_KPI_Dimension_Time_Range__c timerange1 = new OV_KPI_Dimension_Time_Range__c(Name='Time Range 1', Code__c = 'Time Range 1');
        insert timerange1;

        OV_KPI_Dimension_KPI_Name__c kpiName2 = new OV_KPI_Dimension_KPI_Name__c(Name='KPI Name 2', Visible_Columns__c='brand;businessUnit;channel;', Code__c = 'test1', Code_Text__c = 'LABEL_1');
        insert kpiName2;

        OV_KPI_Dimension_Brand__c brand2 = new OV_KPI_Dimension_Brand__c(Name='Total Brand 2', Code__c = 'Brand 2');
        insert brand2;

        OV_KPI_Dimension_Business_Unit__c bUnit2 = new OV_KPI_Dimension_Business_Unit__c(Name='Total B Unit 2', Code__c = 'B Unit 2');
        insert bUnit2;

        OV_KPI_Dimension_Channel__c channel2 = new OV_KPI_Dimension_Channel__c(Name='Total Channel 2', Code__c = 'Channel 2');
        insert channel2;

        OV_KPI_Dimension_Geography__c geography2 = new OV_KPI_Dimension_Geography__c(Name='total Geography 2', Code__c = 'Geography 2');
        insert geography2;

        OV_KPI_Dimension_Time_Range__c timerange2 = new OV_KPI_Dimension_Time_Range__c(Name='Total Time Range 2', Code__c = 'Time Range 2');
        insert timerange2;

        OV_KPI_Dimension_Time_Range__c timerange3 = new OV_KPI_Dimension_Time_Range__c(Name='Total Time Range 3', Code__c = 'Time Range 3');
        insert timerange3;
        
        //row without total
        OV_KPI_Transaction__c tran1 = new OV_KPI_Transaction__c(Value_Current_Period__c='10', Value_Previous_Period__c = '5', Direction__c =NO_CHANGE, 
                                                                KPI_Name_Code__c='test211', Source__c='test1', File_Version__c='1', 
                                                                Source_Timestamp__c=Datetime.now(), Data_Tag__c='tag1',
                                                                KPI_Name__c         =   kpiName1.Id,
                                                                Brand__c            =   brand1.Id,
                                                                Business_Unit__c    =   bUnit1.Id,
                                                                Channel__c          =   channel1.Id,
                                                                Geography__c        =   geography1.Id,
                                                                Time_Range__c       =   timerange1.Id
                                                                );
        insert tran1;

        //row with two totals
        OV_KPI_Transaction__c tran2 = new OV_KPI_Transaction__c(Value_Current_Period__c='11', Value_Previous_Period__c = '5', Direction__c =NO_CHANGE, 
                                                                KPI_Name_Code__c='test212', Source__c='test2', File_Version__c='2', 
                                                                Source_Timestamp__c=Datetime.now(), Data_Tag__c='tag2',
                                                                KPI_Name__c         =   kpiName1.Id,
                                                                Brand__c            =   brand1.Id,
                                                                Business_Unit__c    =   bUnit1.Id,
                                                                Channel__c          =   channel1.Id,
                                                                Geography__c        =   geography2.Id,
                                                                Time_Range__c       =   timerange3.Id
                                                                );
        insert tran2;

        //row with two totals
        OV_KPI_Transaction__c tran22 = new OV_KPI_Transaction__c(Value_Current_Period__c='12', Value_Previous_Period__c = '5', Direction__c =NO_CHANGE, 
                                                                KPI_Name_Code__c='test213', Source__c='test3', File_Version__c='3', 
                                                                Source_Timestamp__c=Datetime.now(), Data_Tag__c='tag3',
                                                                KPI_Name__c         =   kpiName1.Id,
                                                                Brand__c            =   brand1.Id,
                                                                Business_Unit__c    =   bUnit1.Id,
                                                                Channel__c          =   channel1.Id,
                                                                Geography__c        =   geography2.Id,
                                                                Time_Range__c       =   timerange2.Id
                                                                );
        insert tran22;

        //row with two totals
        OV_KPI_Transaction__c tran3 = new OV_KPI_Transaction__c(Value_Current_Period__c='13', Value_Previous_Period__c = '5', Direction__c =NO_CHANGE, 
                                                                KPI_Name_Code__c='test214', Source__c='test4', File_Version__c='4', 
                                                                Source_Timestamp__c=Datetime.now(), Data_Tag__c='tag4',
                                                                KPI_Name__c         =   kpiName1.Id,
                                                                Brand__c            =   brand1.Id,
                                                                Business_Unit__c    =   bUnit1.Id,
                                                                Channel__c          =   channel2.Id,
                                                                Geography__c        =   geography2.Id,
                                                                Time_Range__c       =   timerange2.Id
                                                                );
        insert tran3;

        //row with four totals
        OV_KPI_Transaction__c tran4 = new OV_KPI_Transaction__c(Value_Current_Period__c='14', Value_Previous_Period__c = '5', Direction__c =NO_CHANGE, 
                                                                KPI_Name_Code__c='test215', Source__c='test5', File_Version__c='5', 
                                                                Source_Timestamp__c=Datetime.now(), Data_Tag__c='tag5',
                                                                KPI_Name__c         =   kpiName1.Id,
                                                                Brand__c            =   brand1.Id,
                                                                Business_Unit__c    =   bUnit2.Id,
                                                                Channel__c          =   channel2.Id,
                                                                Geography__c        =   geography2.Id,
                                                                Time_Range__c       =   timerange2.Id
                                                                );
        insert tran4;

        
        
        Map<String, Set<Id>> dimensionMap = new Map<String, Set<Id>>();
        dimensionMap.put('kpiName', new Set<Id>{kpiName1.Id});

        Map<String, Object> results = OV_KpiTransactionServiceImpl.getKPITransactions(dimensionMap);
        List<Map<String,String>> transactions = (List<Map<String,String>>)results.get('transactions');

        system.assertEquals(tran4.Id,  transactions[0].get('id')); 
        system.assertEquals(tran3.Id,  transactions[1].get('id'));
        system.assertEquals(tran22.Id, transactions[2].get('id'));
        system.assertEquals(tran2.Id,  transactions[3].get('id'));
        system.assertEquals(tran1.Id,  transactions[4].get('id'));
    }
}