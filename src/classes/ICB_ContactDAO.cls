/**********************************************************************
Name: ContactDAO
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
DAO class for retrieve queries in objet Contact
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Thiago Oliveira 12/08/2016  Class creation  
***********************************************************************/
public with sharing class ICB_ContactDAO {
    
    // Instance Class
    private static final ICB_ContactDAO instance = new ICB_ContactDAO();
    
    // Construtor 
    public ICB_ContactDAO() {}
    
    // Get Instance method to return a static final instance of this object. 
    public static ICB_ContactDAO getInstance(){
        return instance;
    }
    
    public String getContactId(String userIdParam){
       // userIdParam ='00519000000PPjb';
        return [SELECT ContactId FROM User WHERE Id =: userIdParam ].ContactId;
    }
    
    public Contact getContact(String ContactIdParam){
        
        return [SELECT AccountId FROM CONTACT WHERE Id =: ContactIdParam Limit 1];
    }    
}