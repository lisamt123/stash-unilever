/**********************************************************************
Name: ICB_Cockpit_CC
Copyright © 2016 Unilever
======================================================
======================================================
Purpose:
Controller class for lightning component ICB_Cockpit And ICB_CloseSale
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
1.0    	Antonio Raul 	09/08/2016  Class creation 
1.0    	Antonio Raul 	19/08/2016  Class finished 
2.0		Antonio Raul 	20/08/2016  Class updated
2.0		Antonio Raul 	25/08/2016  Finished updated
***********************************************************************/
public with sharing class ICB_Cockpit_CC 
{    
    
    private static final String CONST_STATUS_ITEM_OPP_SOLD_PENDING;
    private static final String CONST_STATUS_ITEM_OPP_SOLD;
    private static final String CONST_EMPTY;
    private static final String CONST_STATUS_ITEM_OPP_STOCK;
    private static final String CONST_STAGE_PENDING;
    private static final String CONST_SOLICITATION;
    private static final String CONST_DECREMENT;
    private static final String CONST_INCREMENT;
    private static final String CONST_OPERATION_IS_CLOSED;
    private static final String CONST_OPERATION_OPEN;
    private static final String CONST_TYPE_LIST;
    private static final String CONST_TYPE_CONTACT_SALES;
    private static final String CONST_TYPE_CONTACT_OPERATOR;
    //private static Id idRecTypeStandard;
    private static Map<Id,Contact> mapContact;
    private static Map<String,ICB_Wrapper_Cockpit_CC> mapLineItem;
    private static Map<Id, String> mapUserPhoto;
    private static Map<String,ICB_Wrapper_Cockpit_CC> mapInventory;
    private static Map<String,PriceBookEntry> mapPriceBook;
    private static Id contactId;
    private static Id accountId;
    private static Set<Id> setContactId;
    
    Static
    {
        CONST_STATUS_ITEM_OPP_SOLD_PENDING = 'sold pending stock';
        CONST_STATUS_ITEM_OPP_SOLD = 'sold';
        CONST_EMPTY = '[]';
        CONST_STATUS_ITEM_OPP_STOCK = 'stock';
        CONST_STAGE_PENDING = 'Pending';
        CONST_SOLICITATION = 'Solicitation';
        CONST_DECREMENT = 'decrement';
        CONST_INCREMENT = 'increment';
        CONST_OPERATION_IS_CLOSED = 'isClosed';
        CONST_OPERATION_OPEN = 'open';
        CONST_TYPE_LIST = 'List<ICB_Wrapper_Cockpit_CC>';
        CONST_TYPE_CONTACT_SALES = 'Ice Cream Salesman';
        CONST_TYPE_CONTACT_OPERATOR = 'Operator';
        mapLineItem = new Map<String,ICB_Wrapper_Cockpit_CC>();
        mapUserPhoto = new Map<Id, String>();
        mapInventory = new Map<String,ICB_Wrapper_Cockpit_CC>();
        mapPriceBook = new Map<String,PriceBookEntry>();
        setContactId = new Set<Id>();
       // idRecTypeStandard = ICB_RecordTypeMemory.getRecType(Label.ICB_SOBJECT_CONTACT, Label.ICB_REC_TYPE_STANDARD_CONTACT); 
        contactId = [SELECT ContactId FROM User WHERE isPortalEnabled = TRUE AND Id =: UserInfo.getUserId()].ContactId;
        accountId = [SELECT AccountId FROM Contact WHERE Id =:contactId].AccountId;
        mapContact = new Map<Id,Contact>([SELECT Id,
                                                  Name,
                                                  AccountId,
                                                  Account.Name,
                                                  ICB_Type__c
                                                  //ICB_Sales_Locale__c
                                          FROM Contact
                                          WHERE AccountId =: accountId]);
    }
    
    
    /*******************************************************************
    Purpose: Retrieve Contacts on the first load components ICB_Cockpit and ICB_CloseSale
    Parameters: @isClosed(information if the screem is ICB_CloseSale or not)
    Returns: List<ICB_Wrapper_Cockpit_CC>
    Throws [Exceptions]: Exception
    ********************************************************************/
    @AuraEnabled
    public static List<ICB_Wrapper_Cockpit_CC> getContacts(Boolean isClosed)
    {
        System.debug('Entering <getContacts>: '+ isClosed);
        List<ICB_Wrapper_Cockpit_CC> listWrapper = new List<ICB_Wrapper_Cockpit_CC>();
        try
        {
            List<Opportunity> listOpportunity = isClosed ? 	ICB_Cockpit_CC_DAO.returnListOppClosed(mapContact) : 
            												ICB_Cockpit_CC_DAO.returnListOppOpen(mapContact);
            List<OpportunityLineItem> listOpportunityLineItem = ICB_Cockpit_CC_DAO.returnListOppItem(mapContact);
            
            for(User user : [SELECT ContactId, FullPhotoUrl FROM User WHERE isPortalEnabled = TRUE AND ContactId =: mapContact.keySet()])
            {
                mapUserPhoto.put(user.ContactId, user.FullPhotoUrl);
            }
            
            mapLineItem = ICB_Cockpit_Helper.returnMapLineItem(listOpportunityLineItem);
            listWrapper.addAll(returnOpportunitiesContacts(listOpportunity));
            listWrapper.addAll(returnContacts());
        }
        catch(Exception e)
        {
            System.debug(Label.ICB_ERROR_MESSAGE + e.getMessage());
        }
        System.debug('Exiting <getContacts>: '+ JSON.serializePretty(listWrapper));
        return listWrapper;
    }
    
    /*******************************************************************
    Purpose: Retrieve Inventories in a list expand after click in button for the components ICB_Cockpit and ICB_CloseSale
    Parameters: @accountName(name account of user logged)
                @operation(if operation is closed or not)
                @idContact(id contact on the position of list)
    Returns: List<ICB_Wrapper_Cockpit_CC>
    Throws [Exceptions]: Exception
    ********************************************************************/
    @AuraEnabled
    public static List<ICB_Wrapper_Cockpit_CC> getInventories(String accountName, String operation, String idContact)
    {
        System.debug('Entering <getInventories>: '+ accountName);
        System.debug('Entering <getInventories>: '+ operation);
        System.debug('Entering <getInventories>: '+ idContact);
        List<ICB_Wrapper_Cockpit_CC> listWrapper = new List<ICB_Wrapper_Cockpit_CC>();
        
        try
        {
            List<OpportunityLineItem> oppLineList = ICB_Cockpit_CC_DAO.getInventoriesOppLineItemList();
            
            for(ICB_Inventory_Line_Item__c ivt : ICB_Cockpit_CC_DAO.getInventoriesIventoryLineItem(accountName))
            {
                listWrapper.addAll(ICB_Cockpit_Helper.returnListWrapper(oppLineList,ivt,operation,idContact));
            }
        }
        catch(Exception e)
        {
            System.debug(Label.ICB_ERROR_MESSAGE + ' ' +e.getMessage());
        }
        System.debug('Exiting <getInventories>: '+ JSON.serializePretty(listWrapper));
        return listWrapper;
    }
    
    /*******************************************************************
    Purpose: Creaete opportunity with current user how ownerId 
    Parameters: @idContact(id contact on the position of list)
                @oppName(name of opportunity)
                @accountName(name account of user logged)
                @idAccount(Id account of user logged)
                @inventoryList(list of invetories related contact)
    Returns: Void
    Throws [Exceptions]: Exception
    ********************************************************************/
    @AuraEnabled
    public static Opportunity createOpportunity(String idContact,String oppName, String accountName,String idAccount, String inventoryList)
    {
        System.debug('Entering <createOpportunity> 1: ' + idContact);
        System.debug('Entering <createOpportunity> 2: ' + oppName);
        System.debug('Entering <createOpportunity> 3: ' + accountName);
        System.debug('Entering <createOpportunity> 4: ' + idAccount);
        System.debug('Entering <createOpportunity> 5: ' + inventoryList);
        
        Opportunity opp = new Opportunity();
        
        try
        {
            Id priceBookId = [Select Id From PriceBook2 Where Name =: accountName].Id;
            
            opp.Name = oppName;
            opp.AccountId = idAccount;
            opp.OwnerId = UserInfo.getUserId();
            opp.StageName = CONST_STAGE_PENDING;
            opp.CloseDate = System.today(); 
            opp.Pricebook2Id = priceBookId;
            opp.ICB_OLD_QUANTITY_RETURNED__c = 0;
            opp.ICB_Contact__c = idContact;
            //opp.ICB_Sales_Locale__c = mapContact.get(idContact).ICB_Sales_Locale__c;
            
            Database.insert(opp);
            createOppItem(opp.id,inventoryList, opp.Name);
            getInventories(accountName, CONST_SOLICITATION, idContact);
            updateInventory(inventoryList,CONST_DECREMENT);
            System.debug('Exiting <createOpportunity>: ');
            return opp;
        }
        catch(Exception e)
        {
           System.debug(Label.ICB_ERROR_MESSAGE + e.getMessage());
           return null;
        }
    }
    /*******************************************************************
    Purpose: Update opportunity for change status and number of items returned
    Parameters: @opp(Opportunity changed)	
                @listJson(list of inventories or contacts)
                @isClosed(sets if opportunity is closed or not)
    Returns: Void
    Throws [Exceptions]: Exception
    ********************************************************************/
    @AuraEnabled
    public static Opportunity updateOpportunity(Opportunity opp,String listJson, Boolean isClosed)
    {
        System.debug('Entering <updateOpportunity>: '+ JSON.serializePretty(opp));
        System.debug('Entering <updateOpportunity>: '+ listJson);
        System.debug('Entering <updateOpportunity>: '+ isClosed);
        
        try
        {
            if(isClosed)
            {
                List<ICB_Wrapper_Cockpit_CC> listInventories = deserializeJSON(listJson);
                //List<ICB_Wrapper_Cockpit_CC> returnListInventories = deserializeJSON(listJson);
                //List<Opportunity> oppList = new List<Opportunity>();
                for(ICB_Wrapper_Cockpit_CC wrapper : listInventories)
                {
                    opp.ICB_OLD_QUANTITY_RETURNED__c = wrapper.quantity == null ? 0 : wrapper.quantity + opp.ICB_OLD_QUANTITY_RETURNED__c;
                    
                }
            }
            Database.update(opp);
            System.debug('Exiting <updateOpportunity>: ' + opp);
            return opp;
        }
        catch(Exception e)
        {
            System.debug(Label.ICB_ERROR_MESSAGE + e.getMessage());
            return null;
        }
        
    }
    
    /*******************************************************************
    Purpose: Update opportunity line item for devolutions and increment items
    Parameters: @inventoryList(list of items)
				@operation(type of operation. Values: true or false)
    Returns: Void
    Throws [Exceptions]: Exception
    ********************************************************************/
    @AuraEnabled
    public static void updateOppItem(String inventoryList, String operation)
    {
        System.debug('Entering <updateOppItem>: '+ inventoryList);
        System.debug('Entering <updateOppItem>: '+ operation);
       
        List<OpportunityLineItem> oppItem = new List<OpportunityLineItem>();
        
        try
        {
            if(!inventoryList.equalsIgnoreCase(CONST_EMPTY))
            {
                List<ICB_Wrapper_Cockpit_CC> listInventories = deserializeJSON(inventoryList);
                setMapsIvtPb(listInventories);
            }
            
            for(OpportunityLineItem opp : ICB_Cockpit_CC_DAO.updateOppItemListOppItem(mapPriceBook))
            {
                if(operation.equalsIgnoreCase(CONST_OPERATION_IS_CLOSED))
                {
                    opp.ICB_IS_CLOSED__c = true;
                    //oppItem.add(opp);
                }
                if(operation.equalsIgnoreCase(CONST_OPERATION_OPEN) && mapInventory.get(opp.PriceBookEntry.Name).quantity > 0 )
                {
                    opp.Quantity = mapInventory.get(opp.PriceBookEntry.Name).quantity == null ? 0 : mapInventory.get(opp.PriceBookEntry.Name).quantity + opp.Quantity;
                    opp.TotalPrice = opp.Quantity * mapPriceBook.get(opp.PriceBookEntryId).UnitPrice;
                    opp.ICB_Total_Purchase_Price__c = opp.Quantity * mapPriceBook.get(opp.PriceBookEntryId).ICB_Purchase_Price__c; 
                    oppItem.add(opp);
                }
                else if(mapInventory.get(opp.PriceBookEntry.Name).quantity <= opp.Quantity)
                {
                    
                    Integer valueQtd =  (Integer)opp.Quantity - mapInventory.get(opp.PriceBookEntry.Name).quantity;
                    if(valueQtd == 0)
                    {
                        opp.Quantity = mapInventory.get(opp.PriceBookEntry.Name).quantity;
                        opp.ICB_STATUS_SALES__c = CONST_STATUS_ITEM_OPP_STOCK;
                        opp.ICB_Total_Purchase_Price__c = 0;
                        opp.ICB_ITEMS_RETURNED__c = mapInventory.get(opp.PriceBookEntry.Name).quantity == null ? 0 : mapInventory.get(opp.PriceBookEntry.Name).quantity;
                        opp.TotalPrice = valueQtd * mapPriceBook.get(opp.PriceBookEntryId).UnitPrice;
                    }
                    else if((valueQtd == (Integer)opp.Quantity)||(inventoryList.equalsIgnoreCase(CONST_EMPTY)))
                    {
                        opp.ICB_STATUS_SALES__c = CONST_STATUS_ITEM_OPP_SOLD;
                        opp.ICB_Total_Purchase_Price__c = (Integer)opp.Quantity * mapPriceBook.get(opp.PriceBookEntryId).ICB_Purchase_Price__c;
                        opp.ICB_ITEMS_RETURNED__c = 0;
                        opp.ICB_IS_CLOSED__c = true;
                        opp.TotalPrice = valueQtd * mapPriceBook.get(opp.PriceBookEntryId).UnitPrice;
                    }
                    else
                    {
                        opp.ICB_ITEMS_RETURNED__c = mapInventory.get(opp.PriceBookEntry.Name).quantity == null ? 0 : mapInventory.get(opp.PriceBookEntry.Name).quantity;
                        opp.ICB_STATUS_SALES__c = CONST_STATUS_ITEM_OPP_SOLD_PENDING;
                        opp.ICB_Total_Purchase_Price__c = valueQtd * mapPriceBook.get(opp.PriceBookEntryId).ICB_Purchase_Price__c;
                        //opp.Quantity =  valueQtd;
                        opp.TotalPrice = mapInventory.get(opp.PriceBookEntry.Name).quantity * mapPriceBook.get(opp.PriceBookEntryId).UnitPrice;
                    }
                    
                    oppItem.add(opp);
                }
            }
            
            Database.update(oppItem);
        }
        catch(Exception e)
        {
             System.debug(Label.ICB_ERROR_MESSAGE + e.getMessage());
        }
        System.debug('Exiting <updateOppItem>');
    }

    /*******************************************************************
    Purpose: Create opportunity line items based in opportunity create
    Parameters: @inventoryList(list of items)
				@oppName(name of opportunity)
    			@operation(type of operation)
    Returns: Void
    Throws [Exceptions]: NONE
    ********************************************************************/
    private static void createOppItem(Id oppId,String inventoryList, String oppName)
    {
        System.debug('Entering <createOppItem>: '+oppId);
        System.debug('Entering <createOppItem>: '+inventoryList);
        System.debug('Entering <createOppItem>: '+oppName);
        
        List<ICB_Wrapper_Cockpit_CC> listInventories = deserializeJSON(inventoryList);
        OpportunityLineItem oppItem;
        
        List<OpportunityLineItem> listOppItem = new List<OpportunityLineItem>();
        
        setMapsIvtPb(listInventories);
        
        for(ICB_Wrapper_Cockpit_CC ivt : listInventories)
        {
            for(String priceId : mapPriceBook.keySet())
            {
                if(mapPriceBook.get(priceId).Pricebook2.Name != null){
                    if(mapPriceBook.get(priceId).Name.equals(ivt.invetoryItem.ICB_Product__r.Name) && 
                       mapPriceBook.get(priceId).Pricebook2.Name.equals(ivt.invetoryItem.ICB_Inventory__r.Name))
                    {
                        if(ivt.quantity > 0 && mapPriceBook.get(priceId).UnitPrice != null && mapPriceBook.get(priceId).ICB_Purchase_Price__c != null)
                        {
                            oppItem = new OpportunityLineItem();
                            oppItem.OpportunityId = oppId; 
                            oppItem.PricebookEntryId = priceId;
                            oppItem.Quantity = ivt.quantity;
                            oppItem.TotalPrice = ivt.quantity * mapPriceBook.get(priceId).UnitPrice;
                            oppItem.ICB_Total_Purchase_Price__c = ivt.quantity * mapPriceBook.get(priceId).ICB_Purchase_Price__c;
                            oppItem.ICB_Purchase_Price__c = mapPriceBook.get(priceId).ICB_Purchase_Price__c;
                            listOppItem.add(oppItem);
                        }
                    }
                }
            }
            
        }
        Database.insert(listOppItem);
        System.debug('Exiting <createOppItem>');
    }
    
    /*******************************************************************
    Purpose: Update inventories for decrement or increment value
    Parameters: @inventoryList(list of items)
				@operation(type of operation. Values: increment or decrement )
    Returns: Void
    Throws [Exceptions]: NONE
    ********************************************************************/
    private static void updateInventory(String inventoryList, String operation)
    {
        System.debug('Entering <updateInventory>: '+ inventoryList);
        System.debug('Entering <updateInventory>: '+ operation);
        
        List<ICB_Wrapper_Cockpit_CC> listInventory = deserializeJSON(inventoryList);
        List<ICB_Inventory_Line_Item__c> listUpdateIvt = new List<ICB_Inventory_Line_Item__c>();
        
        for(ICB_Wrapper_Cockpit_CC ivt : listInventory)
        {
            if(ivt.quantity <= ivt.invetoryItem.ICB_Quantity_Unit__c)
            {
                if(!operation.equals(CONST_INCREMENT))
                {
                    ivt.invetoryItem.ICB_Quantity_Unit__c = ivt.quantity == ivt.invetoryItem.ICB_Quantity_Unit__c ? 0 : ivt.invetoryItem.ICB_Quantity_Unit__c - ivt.quantity;  
                    listUpdateIvt.add(ivt.invetoryItem);        
                }
            }
        }
        Database.update(listUpdateIvt);
        System.debug('Exiting <updateInventory>: ');
    }
    
    /*******************************************************************
    Purpose: Deserialize JSON received of controller javascript
    Parameters: @jsonList(list of items)
    Returns: List<ICB_Wrapper_Cockpit_CC>
    Throws [Exceptions]: NONE
    ********************************************************************/
    private static List<ICB_Wrapper_Cockpit_CC> deserializeJSON(String jsonList)
    {
        System.debug('Entering <deserializeJSON>: '+ jsonList);
        Type idArrType=Type.forName(CONST_TYPE_LIST);
        List<ICB_Wrapper_Cockpit_CC> listInventories = (List<ICB_Wrapper_Cockpit_CC>) JSON.deserialize(jsonList, idArrType);
        System.debug('Exiting <deserializeJSON>: ' + JSON.serializePretty(listInventories));
        return listInventories;
    } 
    
     /*******************************************************************
    Purpose: Return names of products to used for retrieve price books 
    Parameters: @listInventory(list of items)
    Returns: Map<String,ICB_Wrapper_Cockpit_CC>
    Throws [Exceptions]: NONE
    ********************************************************************/
    private static void setMapsIvtPb(List<ICB_Wrapper_Cockpit_CC> listInventory)
    {
        System.debug('Entering <getListNames>: '+ listInventory);
        
        for(ICB_Wrapper_Cockpit_CC ivtItem : listInventory)
        {
            mapInventory.put(ivtItem.invetoryItem.ICB_Product__r.Name,ivtItem);
        }
        mapPriceBook.putAll([Select id,Name,UnitPrice,Pricebook2.Name,ICB_Purchase_Price__c from PriceBookEntry where IsActive = true AND Name =: mapInventory.keySet()]);
        System.debug('Exiting <getListNames>');
    }
    
   /*******************************************************************
    Purpose: Retrieve Contacts on the first load components ICB_Cockpit and ICB_CloseSale
    Parameters: NONE
    Returns: List<ICB_Wrapper_Cockpit_CC>
    Throws [Exceptions]: Exception
    ********************************************************************/
    private static List<ICB_Wrapper_Cockpit_CC> returnContacts()
    {
        List<ICB_Wrapper_Cockpit_CC> listWrapper = new List<ICB_Wrapper_Cockpit_CC>();
        ICB_Wrapper_Cockpit_CC itemWrapper;
        for(Contact contact : [SELECT id, Name, Account.Name, ICB_Type__c FROM Contact WHERE Id =: mapContact.keySet()])
        {
            if((!setContactId.contains(contact.Id) && contact.ICB_Type__c == CONST_TYPE_CONTACT_SALES) || 
               (!setContactId.contains(contact.Id) && contact.ICB_Type__c == CONST_TYPE_CONTACT_SALES && contactId <> contact.Id && 
                mapContact.get(contactId).ICB_Type__c == CONST_TYPE_CONTACT_OPERATOR) )
            {
                if(mapUserPhoto.keySet().contains(contact.Id)){
                    itemWrapper = new ICB_Wrapper_Cockpit_CC();
                    itemWrapper.urlImage ='';
                    itemWrapper.contactItem = mapContact.get(contact.id);
                    itemWrapper.check = false;
                    itemWrapper.checkButton = false;
                    itemWrapper.isDisabled = true;
                    itemWrapper.urlImage = mapUserPhoto.get(contact.Id);
                    listWrapper.add(itemWrapper);
                }
            }
            
        }
        return listWrapper;
    }
    /*******************************************************************
    Purpose: Retrieve Opportunities on the first load components ICB_Cockpit and ICB_CloseSale
    Parameters: NONE
    Returns: List<ICB_Wrapper_Cockpit_CC>
    Throws [Exceptions]: Exception
    ********************************************************************/
    private static List<ICB_Wrapper_Cockpit_CC> returnOpportunitiesContacts(List<Opportunity> listOpportunity)
    {
        List<ICB_Wrapper_Cockpit_CC> listWrapper = new List<ICB_Wrapper_Cockpit_CC>();
        ICB_Wrapper_Cockpit_CC itemWrapper;
        for(Opportunity opp : listOpportunity)
        {
            if((!setContactId.contains(opp.ICB_Contact__c) && opp.ICB_Contact__r.ICB_Type__c == CONST_TYPE_CONTACT_SALES)||
               (!setContactId.contains(opp.ICB_Contact__c) && opp.ICB_Contact__r.ICB_Type__c == CONST_TYPE_CONTACT_SALES && contactId <> opp.ICB_Contact__c && 
                mapContact.get(contactId).ICB_Type__c == CONST_TYPE_CONTACT_OPERATOR) && mapUserPhoto.keySet().contains(opp.ICB_Contact__c)){
                    if(mapUserPhoto.keySet().contains(opp.ICB_Contact__c) ){
                        itemWrapper = new ICB_Wrapper_Cockpit_CC();
                        itemWrapper.oppItem = opp;
                        itemWrapper.oppLineItem = mapLineItem.get(opp.id).oppLineItem;
                        itemWrapper.contactItem = mapContact.get(opp.ICB_Contact__c);
                        itemWrapper.check = false;
                        itemWrapper.checkButton = false;
                        itemWrapper.quantityIce = mapLineItem.get(opp.Id).quantityIce;
                        itemWrapper.urlImage = mapUserPhoto.get(opp.ICB_Contact__c);
                        listWrapper.add(itemWrapper);
                        setContactId.add(opp.ICB_Contact__c);
                    }
                }
        }
        return listWrapper;
    }
}