public with sharing class AR_AgencyGridView {
    
    //***************************
    //Attributes
    //***************************
    public List<Account> agencies { get;set; }
    
    // List of options for filtering
    public List<SelectOption> disciplineOptions { get;set; }
    public List<SelectOption> expertiseOptions { get;set; }
    public List<SelectOption> categoryOptions { get;set; }
    public List<SelectOption> brandOptions { get;set; }
    public List<SelectOption> locationOptions { get;set; }
    
    public String searchText { get;set; }
    
    // Variables relating to pagination of agencies
    public integer totalAgencies { get;set; }
    public integer goToPage { get;set; }
    public integer totalPages { get;set; }
    public List<Integer> pageNumbers { get;set; } 
    
    public String removeFilterString { get;set ;}
    
    // Check if a filter has been chosen
    public Boolean filterApplied {
        get {
            if (disciplineSelectedOptions.size() > 0 ||
            	expertiseSelectedOptions.size() > 0 || 
                categorySelectedOptions.size() > 0 || 
                brandSelectedOptions.size() > 0 || 
                locationSelectedOptions.size() > 0 ||
                (searchText != null && searchText != ''))
            {
                filterApplied = true;
            } 
            else 
            {
                filterApplied = false;
            }
            return filterApplied;
        }
        set;
    }
    
    // Default the sorting to the first attribute in the option list
    public String sortBy { 
        get {
            if (this.sortBy == null)
            {
                sortBy = sortByOptions[0].getValue(); // If null, set to the first value in the option list
            }
            return sortBy;
        }
        set;
    }
    
    public List<String> disciplineSelectedOptions
    {
        get {
            if (this.disciplineSelectedOptions == null) 
            {
                disciplineSelectedOptions = new List<String>();
            }
            return disciplineSelectedOptions;
        }
        set;
    }
    
    public List<String> expertiseSelectedOptions
    {
        get {
            if (this.expertiseSelectedOptions == null) 
            {
                expertiseSelectedOptions = new List<String>();
            }
            return expertiseSelectedOptions;
        }
        set;
    }
    
    public List<String> categorySelectedOptions
    {
        get {
            if (this.categorySelectedOptions == null) 
            {
                categorySelectedOptions = new List<String>();
            }
            return categorySelectedOptions;
        }
        set;
    }
    
    public List<String> brandSelectedOptions
    {
        get {
            if (this.brandSelectedOptions == null) 
            {
                brandSelectedOptions = new List<String>();
            }
            return brandSelectedOptions;
        }
        set;
    }
    
    public List<String> locationSelectedOptions
    {
        get {
            if (this.locationSelectedOptions == null) 
            {
                locationSelectedOptions = new List<String>();
            }
            return locationSelectedOptions;
        }
        set;
    }
    
    // Sort by options. The value is used in the dynamic SOQL
    public List<SelectOption> sortByOptions
    {
        get {
            if (this.sortByOptions == null) 
            {
                sortByOptions = new List<SelectOption>();
                sortByOptions.add(new SelectOption('Overall_Rating__c desc','Overall Rating'));
                sortByOptions.add(new SelectOption('Name asc','Alphabetically'));
                sortByOptions.add(new SelectOption('CreatedDate desc','Recently Joined'));
                sortByOptions.add(new SelectOption('LastModifiedDate desc','Recently Modified'));
            }
            return sortByOptions;
        }
        set;
    }
    
    public ar_Agency_Portal_CMS__c featuredText {
        get {
            if (featuredText == null)
            {
                try {
                    featuredText = [Select  Body__c From ar_Agency_Portal_CMS__c 
                                    where   Type__c = 'Agency List' Limit 1];
                } catch (Exception ex)
                {
                    featuredText = new ar_Agency_Portal_CMS__c();
                }
            }
            return featuredText;
        }   
        set;
    }
    
    // Standard Set Controller used for pagination of agencies
    public ApexPages.StandardSetController setCon {
        get {
            if (setCon == null) {
                setCon = new ApexPages.StandardSetController(agencies);
                setCon.setPageSize(pageSize);
                totalPages = (Integer)Math.ceil((Double)agencies.size() / (Double)pageSize);
                pageNumbers = new List<Integer>();
                for (Integer i = 1; i <= totalPages;i++)
                {
                    pageNumbers.add(i);
                }
            }
            return setCon;
        } set;
    }
    
    // Set this value for the total number of tickets to display per page
    public Integer pageSize {
        get { return 9; } 
        set;
    }
    
    // Query for all agencies. We need to do this to as the way the filtering works, we get all agencies
    // and then filter out. As filtering is on child records, it's hard to use filters against
    // the actual query itself. Shouldn't be a problem as record counts won't exceed 100 or so early on.
    public List<Account> allAgencies{
        get 
        {
            if (allAgencies == null)
            {
                string agencyQuery = '  Select Id, Name, Agency_Expertise__c, Description, Strategic_Capabilities__c, Overall_Rating__c, Featured__c, Discipline__c, ' + 
                                     '      (Select Id, RecordType.Name, Category__c, Brand__c From Experiences__r ' +
                                     '          Where RecordType.Name = \'Experience\' ' +
                                     '              OR  RecordType.Name = \'Project\' ' +
                                     '           Order by Category__c, Brand__c), ' + 
                                     '      (Select City__c From Geographies__r Where City__c != null Order by City__c), ' +
                                     '      (Select Id From Ratings__r), ' +
                                     '      (Select Id From Attachments Where Name LIKE \'three_%\') ' +
                                     '  From Account ' +
                                     '  Where Published__c = true ' +
                                     '  And RecordType.Name = \'Agency\' ' +
                                    '   Order By ' + sortBy;
                system.debug('### All agencies query: ' + agencyQuery);
                allAgencies = database.Query(agencyQuery);      
            } 
            return allAgencies;
        }   
        set;
    }
    
    public List<FeaturedAgency> featuredAgencies 
    {
        get
        {
            if (featuredAgencies == null)
            {
                // Get our list of project Ids, so we can query for the project attachments
                Set<Id> projectIds = new Set<Id>();
                for (Account account :allAgencies)
                {
                    if (account.Featured__c)
                    {
                        for (ar_Experience__c project :account.Experiences__r)
                        {
                            if (project.RecordType.Name == 'Project')
                            {
                                projectIds.add(project.Id);
                                break;
                            }
                        }
                    }
                }
                
                // Query the attachments and build a map of project ids to attachment
                Map<Id, Attachment> projectIdToAttachmentMap = new Map<Id, Attachment>();
                for (Attachment attachment :[Select Id, ParentId From Attachment Where ParentId IN :projectIds And Name Like 'one_%'])
                {
                    projectIdToAttachmentMap.put(attachment.ParentId, attachment);
                }
                
                // Go through our agency list again, and build our agency + attachment records
                featuredAgencies = new List<FeaturedAgency>();
                for (Account account :allAgencies)
                {
                    if (account.Featured__c)
                    {   
                        FeaturedAgency newAgency = new FeaturedAgency();
                        newAgency.agency = account;
                        for (ar_Experience__c project :account.Experiences__r)
                        {
                            if (project.RecordType.Name == 'Project')
                            {
                                newAgency.attachment = projectIdToAttachmentMap.get(project.Id);
                                break;
                            }
                        }
                        featuredAgencies.add(newAgency);
                    }
                }
            }
            return featuredAgencies;
        }
        set;
    }
    
    
    //***************************
    //Variables
    //***************************
    
    //***************************
    //Constructor
    //***************************
    public AR_AgencyGridView()
    {
        agencies = allAgencies.clone(); // Load all agencies for page instantiation
        totalAgencies = allAgencies.size();
        populateFilterOptions();
        agencies = (List<Account>)setCon.getRecords(); // Load all agencies on page instantiation
    }
    
    //***************************
    //Methods
    //***************************
    
    // Apply filters to list of agencies
    // The concept here is that we always start filtering by building the list back to all agencies.
    //      We then loop through all ages, and remove agencies that fail any filter criteria.
    //      We can't do standard dynamic SOQL based on filters because the filter logic varies based on field values and
    //          child record values
    public void filterAgencies(){
        
        agencies = allAgencies.clone();
        
        // Loop through all agences and filter appropriately. If an agency fails at any criteria, remove from list
        // and continue to next record
        for (Integer i = 0; i < agencies.size(); i++){
        
            boolean meetsCriteria = true;
            
            // Search text overrides all filters. If an agency matches on search text it stays
            if (searchText != null && searchText != '')
            {
                if (agencies[i].Name.toUpperCase().contains(searchText.toUpperCase()))
                {
                    continue;
                }
                else
                {
                    agencies.remove(i);
                    i--;
                    continue;
                }
            }
            
            // If discipline option selected, filter agency
            if (disciplineSelectedOptions != null && disciplineSelectedOptions.size() > 0)
            {
                meetsCriteria = false;
                for (String discipline :disciplineSelectedOptions)
                {
                    if (agencies[i].Discipline__c != null)
                    {
                        if (discipline == agencies[i].Discipline__c)
                        {
                        	meetsCriteria = true;
                        	break; // break out now if agency matches discipline on any selected option
                        }
                    }
                }

            }
            // Remove agency if fails above, then skip to next record in loop.
            if (!meetsCriteria)
            {
                agencies.remove(i);
                i--;
                continue;
            }
            
            // If an expertise option is selected, filter out if agency doesn't match on all options selected
            if (expertiseSelectedOptions != null && expertiseSelectedOptions.size() > 0)
            {
                meetsCriteria = false;
                integer matchCount = 0;
                
                for (String expertise :expertiseSelectedOptions)
                {
                    if (agencies[i].Agency_Expertise__c != null)
                    {
                        for (String agencyExpertise :agencies[i].Agency_Expertise__c.split(';'))
                        {
                            if (expertise == agencyExpertise) matchCount++;
                        }
                    }
                }
                if (matchCount >= expertiseSelectedOptions.size()) meetsCriteria = true;
            }
            // Remove agency if fails above, then skip to next record in loop.
            if (!meetsCriteria)
            {
                agencies.remove(i);
                i--;
                continue;
            }
            
            // If a category option is selected, filter out if agency doesn't match on all records
            if (categorySelectedOptions != null && categorySelectedOptions.size() > 0)
            {
                meetsCriteria = false;
                integer matchCount = 0;

                for (String category :categorySelectedOptions)
                {
                    for (ar_Experience__c experience :agencies[i].Experiences__r)
                    {
                        if (category == experience.Category__c) matchCount++;
                    }
                }
                if (matchCount >= categorySelectedOptions.size()) meetsCriteria = true;
            }
            // Remove agency if fails above, then skip to next record in loop.
            if (!meetsCriteria)
            {
                agencies.remove(i);
                i--;
                continue;
            }
            
            // If a brand option is selected, filter out if agency doesn't match on all selected options
            if (brandSelectedOptions != null && brandSelectedOptions.size() > 0)
            {
                meetsCriteria = false;
                integer matchCount = 0;
                for (String brand :brandSelectedOptions)
                {
                    for (ar_Experience__c experience :agencies[i].Experiences__r)
                    {
                        if (brand == experience.Brand__c) matchCount++;
                    }
                }
                if (matchCount >= brandSelectedOptions.size()) meetsCriteria = true;
            }
            // Remove agency if fails above, then skip to next record in loop.
            if (!meetsCriteria)
            {
                agencies.remove(i);
                i--;
                continue;
            }
            
            // If a location option is selected, filter out if agency doesn't match on all selected options
            if (locationSelectedOptions != null && locationSelectedOptions.size() > 0)
            {
                meetsCriteria = false;
                integer matchCount = 0;
                for (String location :locationSelectedOptions)
                {
                    for (ar_Geography__c geography :agencies[i].Geographies__r)
                    {
                        if (location == geography.City__c) matchCount++;
                    }
                }
                if (matchCount >= locationSelectedOptions.size()) meetsCriteria = true;
            }
            // Remove agency if fails above, then skip to next record in loop.
            if (!meetsCriteria)
            {
                agencies.remove(i);
                i--;
                continue;
            }
            
        }
        
        // Re-calculate filters
        populateFilterOptions();

        // Clear the set controller and build our agencies list using the set controller for pagination
        setCon = null;
        agencies = (List<Account>)setCon.getRecords();
    }
    
    // Populate filter options to display on page. 
    // This is a mix of using metadata (picklist values), and querying existing data to build our various options
    private void populateFilterOptions(){
        
        // Create maps for options to count of agencies per option
        Map<String,Integer> disciplineOptionsToCount = new Map<String,Integer>();
        Map<String,Integer> expertiseOptionsToCount = new Map<String,Integer>();
        Map<String,Integer> categoryOptionsToCount = new Map<String,Integer>();
        Map<String,Integer> brandOptionsToCount = new Map<String,Integer>();
        Map<String,Integer> locationOptionsToCount = new Map<String,Integer>();
        
        // Expertise options are built based on a picklist field, so getDescribe() for this list
        for (Schema.PicklistEntry pickListEntry :Account.Agency_Expertise__c.getDescribe().getPicklistValues())
        {
            integer optionCount = 0;
            for (Account agency :agencies)
            {
                if (agency.Agency_Expertise__c != null)
                {
                    if (agency.Agency_Expertise__c.contains(pickListEntry.getValue()))
                    {
                        optionCount++;
                    }
                }
            }
            if (optionCount > 0) expertiseOptionsToCount.put(pickListEntry.getValue(),optionCount);
        }
        
        // This map is used to make sure duplicate child records of an agency don't double count an agency in the filter options
        Map<String, Id> filterToAccountIdMap = new Map<String,Id>();

        // The other filter options are built based on child data records of agencies.
        // Here we are looping through all published agencies and child data, building our options and count for each
        for (Account agency :agencies)
        {   
        	
            if (agency.Discipline__c != null)
            {
            	// Build map for discipline filter and count
            	if (disciplineOptionsToCount.containsKey(agency.Discipline__c))
            	{
            		disciplineOptionsToCount.put(agency.Discipline__c, disciplineOptionsToCount.get(agency.Discipline__c) + 1);
            	}
            	else
            	{
            		disciplineOptionsToCount.put(agency.Discipline__c, 1);
            	}
            }
        	
            // Build map for category and brand options and count of agencies for each
            for (ar_Experience__c experience :agency.Experiences__r)
            {
                if (experience.RecordType.Name == 'Experience')
                {
                    if (experience.Category__c != null)
                    {
                    	// Make sure this category hasn't already been counted for this agency
                    	if (agency.Id != filterToAccountIdMap.get(experience.Category__c)) 
            			{
	                        // if category already exists as an option, increment the count
	                        if (categoryOptionsToCount.containsKey(experience.Category__c))
	                        {
	                            categoryOptionsToCount.put(experience.Category__c, categoryOptionsToCount.get(experience.Category__c) + 1);
	                        }
	                        else // first count of this category, set to 1
	                        {
	                            categoryOptionsToCount.put(experience.Category__c, 1);
	                        }
	                        filterToAccountIdMap.put(experience.Category__c, agency.Id); // add to the map to exclude counting the same category twice for the same agency
            			}
                    }   
                    
                    if (experience.Brand__c != null)
                    {
                    	// Make sure this brand hasn't already been counted for this agency
                    	if (agency.Id != filterToAccountIdMap.get(experience.Brand__c))
            			{
	                        // if brand option already in map, increment the count by 1
	                        if (brandOptionsToCount.containsKey(experience.Brand__c))
	                        {
	                            brandOptionsToCount.put(experience.Brand__c, brandOptionsToCount.get(experience.Brand__c) + 1);
	                        }
	                        else // first count of this brand, set the count to 1
	                        {
	                            brandOptionsToCount.put(experience.Brand__c, 1);
	                        }
	                        filterToAccountIdMap.put(experience.Brand__c, agency.Id); // add to the map to exclude counting the same brand twice for the same agency
            			}
                    }
                    
                }
            }
            
            // Build map for city options and count of agencies per city
            for (ar_Geography__c geography :agency.Geographies__r)
            {
            	// Make sure this location hasn't already been counted for this agency
            	if (agency.Id != filterToAccountIdMap.get(geography.City__c))
            	{
	                // if location already exists in map, add it to the count
	                if (locationOptionsToCount.containsKey(geography.City__c))
	                {
	                    locationOptionsToCount.put(geography.City__c, locationOptionsToCount.get(geography.City__c) + 1);
	                }
	                else // first count of this location, put it in as 1
	                {
	                    locationOptionsToCount.put(geography.City__c, 1);
	                }
	                filterToAccountIdMap.put(geography.City__c, agency.Id); // add to the map to exclude counting the same city twice for the same agency
            	}
            }
            
        }
        
        // Now that we have our maps of options to count of records, build SelectOption lists to display on VF page
        disciplineOptions = buildOptionList(disciplineOptionsToCount);
        expertiseOptions = buildOptionList(expertiseOptionsToCount);
        categoryOptions = buildOptionList(categoryOptionsToCount);
        brandOptions = buildOptionList(brandOptionsToCount);
        locationOptions = buildOptionList(locationOptionsToCount);
        
    }
    
    // Generate a SelectOption list from an optionsToCount Map
    private List<SelectOption> buildOptionList(Map<String,Integer> optionsToCountMap) {
        
        List<SelectOption> options = new List<SelectOption>();
        for (String option : optionsToCountMap.keyset()){
            options.add(new SelectOption(option, option + ' [' + optionsToCountMap.get(option) + ']'));
        }
        return SortOptionList(options);
    }
    
    // Method to sort the option list alphabetically
    private static List<SelectOption> SortOptionList(List<SelectOption> ListToSort)
    {
        if (ListToSort == null || ListToSort.size() <= 1)
        {
            return ListToSort;
        }
            
        List<SelectOption> Less = new List<SelectOption>();
        List<SelectOption> Greater = new List<SelectOption>();
        integer pivot = ListToSort.size() / 2;
          
        // save the pivot and remove it from the list
        SelectOption pivotValue = ListToSort[pivot];
        ListToSort.remove(pivot);
        
        for(SelectOption x : ListToSort)
        {
            if (x.getLabel() <= pivotValue.getLabel())
            {
                Less.add(x);
            }
            else if (x.getLabel() > pivotValue.getLabel()) 
            {
                Greater.add(x);   
            }
        }
        List<SelectOption> returnList = new List<SelectOption> ();
        returnList.addAll(SortOptionList(Less));
        returnList.add(pivotValue);
        returnList.addAll(SortOptionList(Greater));
        return returnList; 
    }  
    
    // Clear all filters
    public void clearFilters(){
        expertiseSelectedOptions.clear();
        categorySelectedOptions.clear();
        brandSelectedOptions.clear();
        locationSelectedOptions.clear();
        searchText = '';
        reloadAgencies();
        populateFilterOptions();
    }
    
    // Sort the agencies when sorting option changes
    public void reSortAgencies(){
        allAgencies = null;
        reloadAgencies();
    }
    
    // Refresh agencies based on some actions
    private void reloadAgencies(){
        agencies = allAgencies.clone();
        setCon = null;
        agencies = (List<Account>)setCon.getRecords();
    }
    
    // Pagination methods
    public void nextPage()
    {
        setCon.next();
        agencies = (List<Account>)setCon.getRecords();
    }
    
    public void previousPage()
    {
        setCon.previous();
        agencies = (List<Account>)setCon.getRecords();
    }
    
    public void goToPage()
    {
        setCon.setPageNumber(goToPage);
        agencies = (List<Account>)setCon.getRecords();
    }
    
    public void removeFilter()
    {
    	disciplineSelectedOptions = removeFilterFromList(disciplineSelectedOptions);
        expertiseSelectedOptions = removeFilterFromList(expertiseSelectedOptions);
        brandSelectedOptions = removeFilterFromList(brandSelectedOptions);
        categorySelectedOptions = removeFilterFromList(categorySelectedOptions);
        locationSelectedOptions = removeFilterFromList(locationSelectedOptions);
        filterAgencies();
    }
    
    public List<String> removeFilterFromList(List<String> selectedOptions)
    {
        for (Integer i = 0; i < selectedOptions.size(); i++)
        {
            if (removeFilterString == selectedOptions[i]) selectedOptions.remove(i);
        }
        return selectedOptions;
    }
    
    // Using a wrapper class for a featured agency, because we need to get the child attachment of a child record
    public class FeaturedAgency
    {
        public Account agency {get;set;}
        public Attachment attachment {get;set;}
    }

}