public with sharing class af_usersearch {
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
  public af_usersearch() {
    soql = 'select id,firstname, lastname,email,name from user where lastname LIKE \'a%\'';
    runQuery();
  }

  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }

  // runs the actual query
  public void runQuery() {

    try {
      users = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20');
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
    }

  }


  public PageReference runSearch() {



    soql = 'select id,firstname, lastname,email,name from user where ';
    if (!firstName.equals(''))
    soql += 'firstname LIKE \''+String.escapeSingleQuotes(firstName)+'%\'';
    if (!lastName.equals('')){
        if (!firstName.equals('')) soql +=' and ';
        soql += 'lastname LIKE \''+String.escapeSingleQuotes(lastName)+'%\'';
      }
      if (!email.equals('')){
         if (!firstName.equals('') || !lastName.equals('') ) soql +=' and '; 
        soql += 'email LIKE \''+String.escapeSingleQuotes(email)+'%\'';
      }
    if(!firstName.equals('') || !lastName.equals('') || !email.equals('') )
    {runQuery();}

    return null;
  }


}