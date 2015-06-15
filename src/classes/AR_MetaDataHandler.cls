public with sharing class AR_MetaDataHandler {
	//***************************
	//Attributes
	//***************************

	//***************************
	//Variables
	//***************************
	
	//***************************
	//Constructor
	//***************************
	
	
	//***************************
	//Methodes
	//***************************

	
	//*
	//Gets the needet FieldSet Info from the Application Object
	//*	
	public static Map<String,List<Schema.FieldSetMember>> GetAllApplicationFieldsets()
	{
		Map<String,List<Schema.FieldSetMember>> tmp_FieldMemberMap = new Map<String,List<Schema.FieldSetMember>>();
		
		Schema.DescribeSObjectResult tmp_app = ar_Application__c.sObjectType.getDescribe();
		Map<String, Schema.FieldSet> Tmp_FieldSetMap = tmp_app.fieldSets.getMap();
		for(String Key:Tmp_FieldSetMap.Keyset())
		{
			tmp_FieldMemberMap.put(Key,Tmp_FieldSetMap.get(Key).getFields());
		}
		
		return tmp_FieldMemberMap;
	}
	
	public static Map<String,List<Schema.FieldSetMember>> GetAllShareholderFieldsets()
	{
		
		Map<String,List<Schema.FieldSetMember>> tmp_FieldMemberMap = new Map<String,List<Schema.FieldSetMember>>();
		
		Schema.DescribeSObjectResult tmp_app = ar_Shareholder__c.sObjectType.getDescribe();
		Map<String, Schema.FieldSet> Tmp_FieldSetMap = tmp_app.fieldSets.getMap();
		for(String Key:Tmp_FieldSetMap.Keyset())
		{
			tmp_FieldMemberMap.put(Key,Tmp_FieldSetMap.get(Key).getFields());
		}
		
		return tmp_FieldMemberMap;
	}
	
	//*
	//Gets the needet FieldSet Info from the ar_Financial__c Object
	//*	
	public static Map<String,List<Schema.FieldSetMember>> GetAllFinancialFieldsets()
	{
		
		Map<String,List<Schema.FieldSetMember>> tmp_FieldMemberMap = new Map<String,List<Schema.FieldSetMember>>();
		
		Schema.DescribeSObjectResult tmp_app = ar_Financial__c.sObjectType.getDescribe();
		Map<String, Schema.FieldSet> Tmp_FieldSetMap = tmp_app.fieldSets.getMap();
		for(String Key:Tmp_FieldSetMap.Keyset())
		{
			tmp_FieldMemberMap.put(Key,Tmp_FieldSetMap.get(Key).getFields());
		}
		
		return tmp_FieldMemberMap;
	}
	
	
	//*
	//Gets the needet FieldSet Info from the ar_Financial__c Object
	//*	
	public static Map<String,List<Schema.FieldSetMember>> GetAllRevenueBreakdownFieldsets()
	{		
		Map<String,List<Schema.FieldSetMember>> tmp_FieldMemberMap = new Map<String,List<Schema.FieldSetMember>>();
		
		Schema.DescribeSObjectResult tmp_app = ar_Revenue_Breakdown__c.sObjectType.getDescribe();
		Map<String, Schema.FieldSet> Tmp_FieldSetMap = tmp_app.fieldSets.getMap();
		for(String Key:Tmp_FieldSetMap.Keyset())
		{
			tmp_FieldMemberMap.put(Key,Tmp_FieldSetMap.get(Key).getFields());
		}
		
		return tmp_FieldMemberMap;
	}
	

	//*
	//Gets the needet FieldSet Info from the ar_Financial__c Object
	//*	
	public static Map<String,List<Schema.FieldSetMember>> GetAllGeographyFieldsets()
	{
		Map<String,List<Schema.FieldSetMember>> tmp_FieldMemberMap = new Map<String,List<Schema.FieldSetMember>>();
		
		Schema.DescribeSObjectResult tmp_app = ar_Geography__c.sObjectType.getDescribe();
		Map<String, Schema.FieldSet> Tmp_FieldSetMap = tmp_app.fieldSets.getMap();
		for(String Key:Tmp_FieldSetMap.Keyset())
		{
			tmp_FieldMemberMap.put(Key,Tmp_FieldSetMap.get(Key).getFields());
		}
		
		return tmp_FieldMemberMap;
	}
	
	//*
	//Gets the needet FieldSet Info from ar_Experience__c
	//*
	public static Map<String,List<Schema.FieldSetMember>> GetAllExperienceFieldsets()
	{
		
		Map<String,List<Schema.FieldSetMember>> tmp_FieldMemberMap = new Map<String,List<Schema.FieldSetMember>>();
		
		Schema.DescribeSObjectResult tmp_app = ar_Experience__c.sObjectType.getDescribe();
		Map<String, Schema.FieldSet> Tmp_FieldSetMap = tmp_app.fieldSets.getMap();
		for(String Key:Tmp_FieldSetMap.Keyset())
		{
			tmp_FieldMemberMap.put(Key,Tmp_FieldSetMap.get(Key).getFields());
		}
		
		return tmp_FieldMemberMap;
	}
	
	//*
	//Gets the needet FieldSet Info from ar_Rate_Card__c
	//*
	public static Map<String,List<Schema.FieldSetMember>> GetAllRateCardFieldsets()
	{
		
		Map<String,List<Schema.FieldSetMember>> tmp_FieldMemberMap = new Map<String,List<Schema.FieldSetMember>>();
		
		Schema.DescribeSObjectResult tmp_app = ar_Rate_Card__c.sObjectType.getDescribe();
		Map<String, Schema.FieldSet> Tmp_FieldSetMap = tmp_app.fieldSets.getMap();
		for(String Key:Tmp_FieldSetMap.Keyset())
		{
			tmp_FieldMemberMap.put(Key,Tmp_FieldSetMap.get(Key).getFields());
		}
		
		return tmp_FieldMemberMap;
	}
	//*
	//Gets the needet FieldSet Info from ar_Supplier_Info__c
	//*
	public static Map<String,List<Schema.FieldSetMember>> GetAllSupplierInfoFieldsets()
	{
		
		Map<String,List<Schema.FieldSetMember>> tmp_FieldMemberMap = new Map<String,List<Schema.FieldSetMember>>();
		
		Schema.DescribeSObjectResult tmp_app = ar_Supplier_Info__c.sObjectType.getDescribe();
		Map<String, Schema.FieldSet> Tmp_FieldSetMap = tmp_app.fieldSets.getMap();
		for(String Key:Tmp_FieldSetMap.Keyset())
		{
			tmp_FieldMemberMap.put(Key,Tmp_FieldSetMap.get(Key).getFields());
		}
		
		return tmp_FieldMemberMap;
	}
	
	
	//*
	//Gets the needet FieldSet Info from ar_Insurance_and_Policy__c
	//*
	public static Map<String,List<Schema.FieldSetMember>> GetAllInsurancePolicyFieldsets()
	{

		
		Map<String,List<Schema.FieldSetMember>> tmp_FieldMemberMap = new Map<String,List<Schema.FieldSetMember>>();
		
		Schema.DescribeSObjectResult tmp_app = ar_Insurance_and_Policy__c.sObjectType.getDescribe();
		Map<String, Schema.FieldSet> Tmp_FieldSetMap = tmp_app.fieldSets.getMap();
		for(String Key:Tmp_FieldSetMap.Keyset())
		{
			tmp_FieldMemberMap.put(Key,Tmp_FieldSetMap.get(Key).getFields());
		}
		
		return tmp_FieldMemberMap;
	}
	//*
	//Gets the needet FieldSet Info from ar_Competitor__c
	//*
	public static Map<String,List<Schema.FieldSetMember>> GetAllCompetitorFieldsets()
	{

		Map<String,List<Schema.FieldSetMember>> tmp_FieldMemberMap = new Map<String,List<Schema.FieldSetMember>>();
		
		Schema.DescribeSObjectResult tmp_app = ar_Competitor__c.sObjectType.getDescribe();
		Map<String, Schema.FieldSet> Tmp_FieldSetMap = tmp_app.fieldSets.getMap();
		for(String Key:Tmp_FieldSetMap.Keyset())
		{
			tmp_FieldMemberMap.put(Key,Tmp_FieldSetMap.get(Key).getFields());
		}
		
		return tmp_FieldMemberMap;
	}
	
	//*
	//Gets the needet FieldSet Info from ar_Competitor__c
	//*
	public static Map<String,List<Schema.FieldSetMember>> GetAllFixRateCardFieldsets()
	{

		Map<String,List<Schema.FieldSetMember>> tmp_FieldMemberMap = new Map<String,List<Schema.FieldSetMember>>();
		
		Schema.DescribeSObjectResult tmp_app = ar_Fixed_Price_Rate_Card__c.sObjectType.getDescribe();
		Map<String, Schema.FieldSet> Tmp_FieldSetMap = tmp_app.fieldSets.getMap();
		for(String Key:Tmp_FieldSetMap.Keyset())
		{
			tmp_FieldMemberMap.put(Key,Tmp_FieldSetMap.get(Key).getFields());
		}
		
		return tmp_FieldMemberMap;
	}
	
	//*
	//Get a Set of Fields for the Object
	//*
	public static Set<String> GetFieldNamesFromSelect(Map<String,List<Schema.FieldSetMember>> p_ObjectFieldMap)
	{
		Set<String> tmp_FieldNameSet = new Set<String> ();
		for(List<Schema.FieldSetMember> Fields:p_ObjectFieldMap.values())
		{
			for(Schema.FieldSetMember Field:Fields)
			{
				tmp_FieldNameSet.add(Field.getFieldPath());
			}
		}
		return tmp_FieldNameSet;
	}
	
	public static Map<String,List<SelectOption>> GetPicklistValuesForFieldsInObject (string objectName)
	{
		Map<String,List<SelectOption>> fieldNamePicklistValues = new Map<String,List<SelectOption>>();
		for (Schema.SobjectField field :Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().values())
		{
			if (string.valueOf(field.getDescribe().getType()) == 'PICKLIST' || string.valueOf(field.getDescribe().getType()) == 'MULTIPICKLIST')
			{
				List<SelectOption> picklistOptions = new List<SelectOption>();
				for (Schema.PicklistEntry picklistEntry :field.getDescribe().getPicklistValues())
				{
					picklistOptions.add(new SelectOption(picklistEntry.getValue(),picklistEntry.getValue()));
				}
				fieldNamePicklistValues.put(field.getDescribe().getName(),picklistOptions);
			}
		}
		return fieldNamePicklistValues;
	}
	

}