/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_Usersearch
@CreateDate : 17/6/2014
@Description : This is used to display the user details in ASC based on their lastname
@             
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_Usersearch {
    public String firstname {get;set;}
    public String lastname {get;set;}
    public String email {get;set;}
    public String name {get;set;}
    // the soql without the order and limit
    private String soql {get;set;}
    // the collection of contacts to display
    public List<User> users {get;set;}
    // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    }
    /***********************************************************************************
*  @Description: this method is to sort in by lastname 
*  @name : sortField
*  @param : none.
*  @return: none.
*************************************************************************************/
    // the current field to sort by. defaults to last name
    public String sortField {
        get  { if (sortField == null) {sortField = 'lastName'; } return sortField;  }
        set;
    }
    // format the soql for display on the visualforce page
    public String debugSoql {
        get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
        set;
    }
    // init the controller and display some sample data when the page loads
    public AF_Usersearch() {
        soql = 'select id,firstname, lastname,email,name from user where lastname LIKE \'a%\'';
        runQuery();
    }
    /***********************************************************************************
*  @Description: this method is to sort in ASC 
*  @name : toggleSort
*  @param : none.
*  @return: none.
*************************************************************************************/
    // toggles the sorting of query from asc<-->desc
    public void toggleSort() {
        // simply toggle the direction
        sortDir = 'asc'.equals(sortDir)? 'desc' : 'asc';
        // run the query again
        runQuery();
    }
    /***********************************************************************************
*  @Description: this method is to query the users from the database and display's the error message 
*  @name : runQuery
*  @param : none.
*  @return: none.
*************************************************************************************/
    // runs the actual query
    public void runQuery() {
        try {
            users = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20');
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    }
    /***********************************************************************************
*  @Description: this method is to check the user name and emails 
*  @name : runSearch
*  @param : none.
*  @return: none.
*************************************************************************************/
    public PageReference runSearch() {
        soql = 'select id,firstname, lastname,email,name from user where ';
        if (!''.equals(firstName))
        soql += 'firstname LIKE \''+String.escapeSingleQuotes(firstName)+'%\'';
        if (!''.equals(lastName)){
            if (!''.equals(firstName)) soql +=' and ';
            soql += 'lastname LIKE \''+String.escapeSingleQuotes(lastName)+'%\'';
        }
        if (!''.equals(email)){
            if (!''.equals(firstName) || !''.equals(lastName) ) soql +=' and '; 
            soql += 'email LIKE \''+String.escapeSingleQuotes(email)+'%\'';
        }
        if(!''.equals(firstName) || !''.equals(lastName) || !''.equals(email) )
        {runQuery();}
        return null;
    }
}