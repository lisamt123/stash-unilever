/**
 * Name:        -   SAFE_SolutionsTab_CC
 * @Description -   This Solution tab will display the list of solutions related to loggedin user and giving access to selected user by clicking the grant access button. 
 * @Author      -   Anusha S from Mindtree     
 */

public with sharing class SAFE_SolutionsTab_CC{

    public Boolean displayPopup {get;set;}
    public List<SAFE_Solutions__c> Records {get; set;} 
  //  public User username {get; set;} 
    public string userid {get; set;}
    public String searchTerm {get; set;}
    public String selecteduser {get; set;}
  //  public String uId {get; set;}
    public List<User> UserTemp = new List<User>();
    
    // To load data into the table
    public SAFE_SolutionsTab_CC(ApexPages.StandardController controller) 
    {
        userid = Userinfo.getUserId();       
        Records =   [SELECT Name,SAFE_Solution_Status__c,SAFE_Supplier_Name__c,SAFE_Solution_Type__c,
                     SAFE_Solution_in_Use__c,SAFE_Solution_Category__c,SAFE_Price_Per_Unit__c,SAFE_Material_Type__c,
                     Owner.name FROM SAFE_Solutions__c WHERE CreatedById = :userid]; 
    system.debug(Records);
    } 
         
    // User Auto Complete related code
    public String getSearchTerm() 
    {
        return null;
    }
     // For auto complete functionality
    
        @RemoteAction
        public static List<User> searchuser(String searchTerm) {
       
        System.debug('user Name is: '+searchTerm );
        List<User> user = Database.query('SELECT Name,Id FROM User where Name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\' Limit 20');  
        system.debug('user'+user);
        return user;
    }
    // Assigns permission sets to the appropriate users
    // This is run as part of the setup wizard and after installations.       
            
     public void savepermissionset()
     {
     system.debug('hi:');
         if(selecteduser == '')
         {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter User'));
            //return null; 
         }
         else
         {         
           system.debug('uId1='+selecteduser);
          PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'SAFE_PM_User'];
           list <PermissionSetAssignment> PSAssignments = new list <PermissionSetAssignment>();
          
           List<User> users = [SELECT ID,(Select id,AssigneeId FROM PermissionSetAssignments WHERE PermissionSetID = :ps.Id) 
                               FROM User WHERE Profile.UserLicense.Name= 'Salesforce Platform' AND IsActive = true AND Id = :selecteduser];
          system.debug('selecteduser:'+selecteduser);   
          for( User u : users ){
                    if(u.PermissionSetAssignments.size() == 0) 
                      PSAssignments.add( new PermissionSetAssignment(AssigneeId = u.id,PermissionSetId = ps.ID ) );
            }
            insert PSAssignments;
        
          closePopup();
         }
       
            //return null;
        }
    
    // To show popup and its functionality   onclick="MyjavaFunction('{!$Component.inptID}')"
    
    public void showPopup()
    {       
        displayPopup = true;    
    }
    
    public void closePopup() 
    {
        displayPopup = false;        
    }
    
}