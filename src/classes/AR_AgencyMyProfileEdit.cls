public with sharing class AR_AgencyMyProfileEdit {
	
	public AR_AgencyMyProfileEdit(ApexPages.StandardController controller) {}
	
	public Account agency { 
		get
		{
			if (agency == null)
			{
				String query = 'SELECT ';
	        	for(Schema.FieldSetMember f : this.getFields()) 
	        	{
	            	query += f.getFieldPath() + ', ';
	       		}
	        	query += 'Id, Name, ';
	        	query += '(Select Id, Name, Country__c, City__c, Office_Company_Name__c, Office_Address__c, No_of_FTE_s_Employees__c From Geographies__r) ';
	        	
	        	query += ' FROM Account Where Id = \'' + ApexPages.currentPage().getParameters().get('id') + '\'' ;
	        	return Database.query(query);
			}
			return agency;
		}
		set;
	}
	
	public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Account.FieldSets.Edit_Agency.getFields();
    }
    
    public List<ar_Experience__c> projects
    {
    	get
    	{
    		if (projects == null)
    		{
    			return [Select	Id, Name, Project_Title__c, Brand_Competitor__c,
    							(Select Id, Name From Attachments)
    					From	ar_Experience__c
    					Where	RecordType.Name = 'Project'
    						And	Agency__c = :ApexPages.currentPage().getParameters().get('id')];
    		}
    		return projects;
    	}
    	set;
    }
    
}