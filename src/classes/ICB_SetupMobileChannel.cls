/**********************************************************************
Name: ICB_SetupMobileChannel
Copyright © 2016 Unilever

Purpose: Class used on the trigger SetupMobileChannel

History 

VERSION AUTHOR 				DATE 		DETAIL Description	
1.0 	CARLOS HENRIQUE  02/09/2016  INITIAL DEVELOPMENT.
***********************************************************************/
public with sharing class ICB_SetupMobileChannel {
    
    public static final ICB_SetupMobileChannel instance = new ICB_SetupMobileChannel();
    
    public ICB_SetupMobileChannel() {}
    
    
    // Get Instance method to return a static final instance of this object. 
    public static ICB_SetupMobileChannel getInstance(){
        return instance;
    }
    
    public void initiateMethod(List<Contact> vContact) {    
        // Set the parameters used to validate the criteria trigger.
        Boolean isPartner	= null; // Indicates if is a partner account.
        Boolean isCreated	= null; // Indicates if the creation of inventory and price book was successfully.
        String	isOperator	= null; // Indicates if is a operator contact type. 
        String 	accountName	= null; // Store the accont name. 
        String 	accountId	= null; // Store the contact Id to retrieve account info. 
        Id 		priceBookId = null; // Store the price book Id created. 
        Id 		inventoryId	= null; // Store the inventory Id creatd.        
        String  IdRecType	= null;
        String salesmanId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Ice Cream Salesman').getRecordTypeId();
        String operatorId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Ice Cream Operator').getRecordTypeId();
        
        
        // Pass the parameters to variables. 
        for(Contact c : vContact){
            IdRecType 	= c.RecordTypeId;
            isOperator 	= c.ICB_Type__c;
            accountId 	= c.AccountId;
            isCreated 	= false;
            System.debug('Entering <isOperator>'+isOperator);
            System.debug('Entering <accountName>'+accountId);
        }
        
        if(salesmanId != null || operatorId != null)
        {
                if(IdRecType == salesmanId || IdRecType == operatorId) 
            {
                
                // Retrive the partner info from account to be used as parameter. 
                List<Account> lstAccount = [Select 	Name, 
                                            isPartner
                                            From 	Account
                                            Where  	Id =: accountId];
                
                for(Account a : lstAccount){
                    accountName = a.Name;
                    isPartner 	= a.isPartner;
                }
                
                System.debug('Entering <isPartner>'+isPartner);
                System.debug('Entering <isOperator>'+isOperator);   
                System.debug('Entering <isCreated>'+isCreated); 
                
                // Check if is a partner and operator type contact. 
                if(isPartner && isOperator == Label.ICE_Type_Operator){
                    
                    System.debug('Entering <CheckIsOperator&Partner>');
                    // Check if partner has inventory and pricebook. 
                    List<ICB_Inventory__c> lstInventory = [Select 	Name 
                                                           From 	ICB_Inventory__c 
                                                           Where 	Name =: accountName Limit 1];
                    
                    // Check if has inventory created to not create a duplicated record. 
                    if(lstInventory.isEmpty()){
                        
                        System.debug('Entering <lstInventory.isEmpty>');
                        ICB_Inventory__c i = new ICB_Inventory__c();
                        PriceBook2 		 p = new PriceBook2();
                        
                        i.Name 			= accountName;
                        p.Name 			= accountName;
                        p.IsActive 		= true;
                        p.RecordTypeId	= Schema.SObjectType.PriceBook2.getRecordTypeInfosByName().get(Label.ICB_Price_Book_RecordTypeId).getRecordTypeId();
                        p.Description 	= Label.ICB_Price_Book_Description + ' ' + accountName;
                        
                        database.insert(i);
                        database.insert(p);
                        isCreated 	= true;
                        priceBookId = p.Id;
                        inventoryId = i.Id;
                        System.debug('Entering <isCreated>'+isCreated);
                        System.debug('Entering <priceBookId>'+priceBookId);
                        System.debug('Entering <inventoryId>'+inventoryId);
                        
                        
                    }
                    
                    // If inventory and price book was created, insert the related product line items. 
                    if(isCreated){
                        
                        System.debug('Entering <isCreated>'+isCreated);
                        List<Product2> 						lstPTC = ICB_Product2DAO.getInstance().getActiveProducts(); // Product list to link on price book and inventory line items. 
                        List<PriceBookEntry> 				lstPBE = new List<PriceBookEntry>(); // Pricebookentry to be created. 
                        List<ICB_Inventory_Line_Item__c> 	lstILI = new List<ICB_Inventory_Line_Item__c>(); // Inventory line items list to be created. 
                        
                        System.debug('Entering <lstPTC>'+lstPTC);
                        
                        // Check if list is not empty. 
                        if(!lstPTC.isEmpty())
                        {
                            
                            System.debug('Entering <lstPTC.isEmpty>');
                            // Create the inventory and price book entry lists to be created. 
                            for(Product2 p : lstPTC){
                                PriceBookEntry 				pbe 	= new PriceBookEntry();
                                ICB_Inventory_Line_Item__c 	ili		= new ICB_Inventory_Line_Item__c();
                                pbe.IsActive 						= true;
                                pbe.Pricebook2Id					= priceBookId;
                                pbe.Product2Id						= p.Id;
                                pbe.UnitPrice 						= 0.0;
                                ili.ICB_Active__c 					= true;
                                ili.ICB_Inventory__c  				= inventoryId;
                                ili.ICB_Product__c 					= p.Id;
                                lstPBE.add(pbe);
                                lstILI.add(ili);
                            }
                            
                            // Create the line items to inventory and price book. 
                            try{
                                System.debug('Entering <lstPBE>'+lstPBE);
                                System.debug('Entering <lstILI>'+lstILI);
                                database.insert(lstILI);
                                database.insert(lstPBE);
                            }
                            catch(DmlException e){
                                for(Contact c : vContact){
                                    c.addError(e);
                                }
                            }
                        }
                    }
                }
            }  
        }
    }
    
}