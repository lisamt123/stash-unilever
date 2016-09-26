/**********************************************************************
Name: AccountDAO
Copyright © 2016 Unilever

Purpose:
DAO class for retrieve queries in objet Account

History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Thiago Oliveira 12/08/2016  Class creation  
***********************************************************************/
public with sharing class ICB_AccountDAO {
    
    // Instance Class
    private static final ICB_AccountDAO instance = new ICB_AccountDAO();
    
    // Construtor 
    public ICB_AccountDAO() {}
    
    // Get Instance method to return a static final instance of this object. 
    public static ICB_AccountDAO getInstance(){
        return instance;
    }
    
    public String getAccount(Contact contactParam){
        
      return [SELECT Name FROM Account WHERE Id =: contactParam.AccountId].Name;
    }
}