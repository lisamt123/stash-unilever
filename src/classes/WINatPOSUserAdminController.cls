/*===========================================================================
  Name:  WINatPOSUserAdmunController                                                       
  Copyright notice:                                                          
  ===========================================================================
  ===========================================================================
   Purpose: Controller for WINatPOSUserAdmin page                                                                  
  -------                                                                    
  ===========================================================================
  ===========================================================================
  History                                                                   
  -------                                                                   
  VERSION  AUTHOR           DATE              DETAIL          RELEASE/CSR   
   1.0 -  Darren Sabey   9/12/2013      INITIAL DEVELOPMENT               
  ===========================================================================*/

public with sharing class WINatPOSUserAdminController {

    // Public bind variables
    public String searchString {get; set;}
    public List<UserWrapper> users {get; set;}
    public String permissionSetId {get; set;}
    public List<SelectOption> permissionSetOptions {get; set;}
    public Boolean showSaveMessages {get; set;}
    
    // Private member variables
    public Map<Id, PermissionSet> permissionSetMap {get; set;}
    private Map<String, Integer> permissionSetRankings;
    private Map<Id, UserWrapper> userMap;

    // Max number of search results to display
    private static Integer MAX_SEARCH_RESULTS = 101;
    
    // Constructor
    public WINatPOSUserAdminController() {
        
        // Initialise the page bind variables
        permissionSetId = 'None';
        users = new List<UserWrapper>();
        showSaveMessages = false;
        
        // The rankings map is used to determine the seniority of the three WIN@POS permission sets availble to 
        // Platform users. If a user has been assigned to multiple WIN@POS permission sets, this map will enable  
        // the code to determine which is the highest ranking permission set using the integer in the values array
        permissionSetRankings = new Map<String, Integer>();
        permissionSetRankings.put('WIN_POS_Agency_User', 0);
        permissionSetRankings.put('WIN_POS_VIEWER', 1);
        permissionSetRankings.put('WIN_POS_PUBLISHER', 2);
        permissionSetRankings.put('WIN_POS_ADMIN', 3);
        //KS added community permision set
        
        
        
        // Store the WIN@POS permission sets 
        permissionSetMap = new Map<Id, PermissionSet>();
        
        // Bind variable for permission set select options in VF page
        permissionSetOptions = new List<SelectOption>();
        permissionSetOptions.add(new SelectOption('None', 'None'));
        
        // Populate the permission set collections
        for (PermissionSet ps : [Select Id, Name, Label 
                                 From PermissionSet
                                 Where Name In :permissionSetRankings.keyset()
                                 Order By Name DESC]) {
            permissionSetMap.put(ps.Id, ps);
            permissionSetOptions.add(new SelectOption(ps.Id, ps.Label));  
              System.debug('---------'+permissionSetOptions);                                    
        }
        
        // Info message presented to users when the page first loads
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, Label.WP_User_Admin_Help_Text));
        
    }

    // Method retrieves user records to work with in the VF page
    public PageReference search() {
        
        // Prevent users from receiving a platform error specifying too few search characters
        if (searchString == null || searchString.length() < 3) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.WP_Search_String_Too_Short));
            return null;
        }
        
        // This private member variable has multiple functions. One is to bind the values array to the search results in the page
        userMap = new Map<Id, UserWrapper>();
        
        // Only search for Salesforce Platform users - we only support permission sets for this license type at the moment (system admins can be handled manually)
        for (User u : (List<User>) [FIND :searchString IN ALL Fields RETURNING User(Id, Name, UserName, Email, Profile.Name Where IsActive = true And Profile.UserLicense.Name = 'Salesforce Platform' Limit :MAX_SEARCH_RESULTS)][0]) {
            userMap.put(u.Id, new UserWrapper(false, u));
        }
        
        // Check the number of records returned by the SOSL search - if equal to limit we need to warn the user
        if (userMap.size() == MAX_SEARCH_RESULTS) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, Label.WP_User_Admin_Too_Many_Results_Part_1 + ' ' + MAX_SEARCH_RESULTS + ' ' + Label.WP_User_Admin_Too_Many_Results_Part_2));
        }
        
        // Retrieve the assigned permission sets for the search result records
        updatePermissionSets();
        
        // Populate the list the binds to the pageBlockTable
        users = userMap.values();
        
        // Search was successful so allow save action
        showSaveMessages = true;
        
        return null;    
    }
    
    public PageReference clear() {
        
        // Clear all search fields and results
        searchString = '';
        userMap = new Map<Id, UserWrapper>();
        users = new List<UserWrapper>();
        permissionSetId = 'None';       
        return null;    
    }
    
    // Methods applies changes requested by user
    public PageReference applyUpdates() {
        
        if (permissionSetId == 'None') {
            // Handle removal of permission sets
            removePermissionSets();
        } else {
            // Handle addition of permission sets and get back the successfully processed users
            Map<Id, String> newUsers = addPermissionSets();
            addAppUsage(newUsers);
        }
        
        // Refresh the permission sets for the users in the search results
        updatePermissionSets();
        
        return null;    
    } 
    
    private Map<Id, String> addPermissionSets() {
      
        // List of successfully processed users
        Map<Id, String> newUsers = new Map<Id, String>();
          
        // List of permission set assignments to insert
        List<PermissionSetAssignment> psasToInsert = new List<PermissionSetAssignment>();
        
        for (UserWrapper uw : users) {
            // If selected and the user doesn't already have the selected permission set...
            if (uw.selected && ! uw.psm.containsKey((Id) permissionSetId)) {
                // Instantiate the insert sobject
                psasToInsert.add(new PermissionSetAssignment(AssigneeId=uw.u.Id,PermissionSetId=permissionSetId));
            }
        }
        
        // Execute the DML to create the assignments, set the option to allow failures
        List<Database.SaveResult> results =  Database.insert(psasToInsert, false);
        
        // Assume no errors
        Boolean errorsFound = false;
        
        // Iterate through the results
        for (Integer i = 0; i < results.size(); i++) {
            Database.SaveResult res = results[i];
            if (res.isSuccess()) {
                newUsers.put(psasToInsert[i].AssigneeId, userMap.get(psasToInsert[i].AssigneeId).u.UserName);       
            }
            else {
                if (! errorsFound) {
                    // If failure...
                    errorsFound = true;
                    // Notify the user that something went wrong
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.WP_User_Admin_Error_Saving_Changes));
                }                           
            }                   
        }
        return newUsers;
    }
    
    @future
   private static void addAppUsage(Map<Id, String> newUsers) {
        
        List<Application_Usage__c> appUsageToUpsert = new List<Application_Usage__c>();

        for (Id id : newUsers.keyset()) {
            appUsageToUpsert.add(new Application_Usage__c(Unique_ID__c=id + 'WIN@POS',User__c=id,Name=newUsers.get(id)+' - WIN@POS',Application__c='WIN@POS',Assigned__c=true,Assigned_Date__c=System.now()));
        }      
        Database.upsert(appUsageToUpsert, Application_Usage__c.Unique_ID__c);
        
    }
    
    private void removePermissionSets() {
        
        // Used to query for permission set assignment records to delete
        Set<Id> userIds = new Set<Id>();
        
        // Used to perform the delete DML in bulk
        List<PermissionSetAssignment> psas = new List<PermissionSetAssignment>();
            
        for (UserWrapper uw : users) {
            // If selected
            if (uw.selected) {
                userIds.add(uw.u.Id);
                // Assume success of delete DML, errors will be handled by the refresh logic
                uw.ps = null;           
                uw.psm = new Map<Id, PermissionSet>();
            }
        }
        
        // Populate the list of permission set assignments to delete
        for (PermissionSetAssignment psa : [Select Id 
                                            From PermissionSetAssignment
                                            Where AssigneeId In :userIds
                                            And PermissionSetId In :permissionSetMap.keyset()]) {
            psas.add(psa);                                      
        }
        
        // Execute the DML to delete the records 
        List<Database.DeleteResult> results = Database.delete(psas);
        
        // Assume no errors
        Boolean errorsFound = false;
        
        // Iterate through the results
        for (Database.DeleteResult res : results) {
            if (! res.isSuccess() && ! errorsFound) {
                // If failure...
                errorsFound = true;
                // Notify the user that something went wrong
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.WP_User_Admin_Error_Saving_Changes));
                return;
            }
        }
    }
   
    private void updatePermissionSets() {
        
        // Retrieve and rank the permission sets of the users displayed in the search results
        for (PermissionSetAssignment psa : [Select AssigneeId, PermissionSet.Name, PermissionSet.Label 
                                            From PermissionSetAssignment 
                                            Where AssigneeId In :userMap.keyset()
                                            And PermissionSetId In :permissionSetMap.keyset()]) {
            // Populate the map that allows us to check we aren't creating a duplicate permission set assignment
            userMap.get(psa.AssigneeId).psm.put(psa.PermissionSetId, psa.PermissionSet);
            // Now determine which of the possible multiple permission set assigments we display for each of our users
            PermissionSet existingPS = userMap.get(psa.AssigneeId).ps; 
            if (existingPS == null) {
                userMap.get(psa.AssigneeId).ps = psa.PermissionSet;
            } else {
                if (newPermissionSetRanksHigher(existingPS.Name, psa.PermissionSet.Name)) {
                    userMap.get(psa.AssigneeId).ps = psa.PermissionSet;
                }
            }
        }       
    }
    
    private Boolean newPermissionSetRanksHigher(String existingPS, String newPS) {
        
        // Method determines which of multiple WIN@POS permission sets assigned to a user ranks higher
        Integer eRank = permissionSetRankings.get(existingPS.toUpperCase());
        Integer nRank = permissionSetRankings.get(newPS.toUpperCase());
        if (nRank > eRank) {
            return true;
        } else {
            return false;   
        }
    }
    
    // Need a wrapper class to allow users to select records in pageBlockTable
    class UserWrapper {
        // Has the record been selected in the pageBlockTable?
        public Boolean selected {get; set;}
        // User record
        public User u {get; set;}
        // The most "senior" WIN@POS permission set assigned to the user
        public PermissionSet ps {get; set;}
        // The list of WIN@POS permission sets assigned to the user
        public Map<Id, PermissionSet> psm {get; set;}
        
        // Constructor
        UserWrapper(Boolean s, User u) {
            this.selected = s;
            this.u = u;
            this.ps = null;
            this.psm = new Map<Id, PermissionSet>();
        }   
    }
    
}