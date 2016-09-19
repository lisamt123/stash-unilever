public class ICB_Cockpit_Open_CC {
    private static final String CONST_TYPE_CONTACT_SALES;
    private static final String CONST_TYPE_CONTACT_OPERATOR;
    private static final String CONST_STAGE_PENDING;
    private static final String CONST_SOLICITATION;
    private static final String CONST_EMPTY;
    private static final String CONST_STAGE_AVAILABLE;
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
        CONST_TYPE_CONTACT_SALES = 'Ice Cream Salesman';
        CONST_TYPE_CONTACT_OPERATOR = 'Operator';
        CONST_STAGE_PENDING = 'Pending';
        CONST_SOLICITATION = 'Solicitation';
        CONST_EMPTY = '[]';
        CONST_STAGE_AVAILABLE = 'Available';
        mapLineItem = new Map<String,ICB_Wrapper_Cockpit_CC>();
        mapUserPhoto = new Map<Id, String>();
        mapInventory = new Map<String,ICB_Wrapper_Cockpit_CC>();
        mapPriceBook = new Map<String,PriceBookEntry>();
        setContactId = new Set<Id>();
        contactId = [SELECT ContactId FROM User WHERE isPortalEnabled = TRUE AND Id =: UserInfo.getUserId()].ContactId;
        accountId = [SELECT AccountId FROM Contact WHERE Id =:contactId].AccountId;
        mapContact = new Map<Id,Contact>([SELECT Id,
                                          Name,
                                          AccountId,
                                          Account.Name,
                                          ICB_Type__c,
                                          ICB_Sales_Locale__c
                                          FROM Contact
                                          WHERE AccountId =: accountId]);
    }
    
    @AuraEnabled
    public static List<ICB_Wrapper_Cockpit_CC> getContacts()
    {
        System.debug('Entering <getContacts>');
        List<ICB_Wrapper_Cockpit_CC> listWrapper = new List<ICB_Wrapper_Cockpit_CC>();
        try
        {
            List<Opportunity> listOpportunity = ICB_Cockpit_CC_DAO.returnListOppOpen(mapContact);
            List<OpportunityLineItem> listOpportunityLineItem = ICB_Cockpit_CC_DAO.returnListOppItem(mapContact);
            
            for(User user : [SELECT ContactId, FullPhotoUrl FROM User WHERE isPortalEnabled = TRUE AND ContactId =: mapContact.keySet()])
            {
                mapUserPhoto.put(user.ContactId, user.FullPhotoUrl);
            }
            
            mapLineItem = ICB_Cockpit_Helper.returnMapLineItem(ICB_Cockpit_CC_DAO.returnListOppItem(mapContact),false);
            listWrapper.addAll(returnOpportunitiesContacts(ICB_Cockpit_CC_DAO.returnListOppOpen(mapContact)));
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
    public static List<ICB_Wrapper_Cockpit_CC> getInventories(String accountName,String operation, String idContact)
    {
        System.debug('Entering <getInventories>: '+ accountName);
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
            opp.ICB_Sales_Locale__c = mapContact.get(idContact).ICB_Sales_Locale__c;
            
            Database.upsert(opp);
            createOppItem(opp.id,inventoryList);
            getInventories(accountName, CONST_SOLICITATION, idContact);
            updateInventory(inventoryList);
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
    public static Opportunity updateOpportunity(Opportunity opp,String listJson)
    {
        System.debug('Entering <updateOpportunity>: '+ JSON.serializePretty(opp));
        System.debug('Entering <updateOpportunity>: '+ listJson);
        
        try
        {
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
    Purpose: Create opportunity line items based in opportunity create
    Parameters: @inventoryList(list of items)
				@oppName(name of opportunity)
    			@operation(type of operation)
    Returns: Void
    Throws [Exceptions]: NONE
    ********************************************************************/
   	private static void createOppItem(Id oppId,String inventoryList)
    {
        System.debug('Entering <createOppItem>: '+oppId);
        System.debug('Entering <createOppItem>: '+inventoryList);
        
        List<ICB_Wrapper_Cockpit_CC> listInventories = ICB_Cockpit_Helper.deserializeJSON(inventoryList);
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
        Database.upsert(listOppItem);
        System.debug('Exiting <createOppItem>');
    }
     /*******************************************************************
    Purpose: Update opportunity line item for devolutions and increment items
    Parameters: @inventoryList(list of items)
				@operation(type of operation. Values: true or false)
    Returns: Void
    Throws [Exceptions]: Exception
    ********************************************************************/
    @AuraEnabled
    public static void updateOppItem(String inventoryList, String idContact)
    {
        System.debug('Entering <updateOppItem><inventoryList>: '+ inventoryList);
		System.debug('Entering <updateOppItem><idContact>: '+ idContact);       
        
        List<OpportunityLineItem> oppItem = new List<OpportunityLineItem>();
        Set<String> setProduct = new Set<String>();
         
        try
        {
            List<ICB_Wrapper_Cockpit_CC> listInventories;
            if(!inventoryList.equalsIgnoreCase(CONST_EMPTY))
            {
                listInventories = ICB_Cockpit_Helper.deserializeJSON(inventoryList);
                setMapsIvtPb(listInventories);
            }
            for(OpportunityLineItem opp : ICB_Cockpit_CC_DAO.updateOppItemListOppItem(mapPriceBook))
            {
                setProduct.add(opp.Product2Id + String.valueOf(opp.Opportunity.ICB_Contact__c));
               
                if(mapInventory.get(opp.PriceBookEntry.Name).quantity > 0 && idContact == opp.Opportunity.ICB_Contact__c)
                {
                    opp.Quantity = mapInventory.get(opp.PriceBookEntry.Name).quantity == null ? 0 : mapInventory.get(opp.PriceBookEntry.Name).quantity + opp.Quantity;
                    opp.TotalPrice = opp.Quantity * mapPriceBook.get(opp.PriceBookEntryId).UnitPrice;
                    opp.ICB_Total_Purchase_Price__c = opp.Quantity * mapPriceBook.get(opp.PriceBookEntryId).ICB_Purchase_Price__c; 
                    oppItem.add(opp);
                    updateInventory(inventoryList);
                }
                oppItem.add(opp);
            }
      		
            Database.upsert(oppItem);
            createOppItemNewProduct(idContact, listInventories, setProduct);
        }
        catch(Exception e)
        {
             System.debug(Label.ICB_ERROR_MESSAGE + e.getMessage());
        }
        System.debug('Exiting <updateOppItem>');
    }
     /*******************************************************************
    Purpose: Create opportunity line items based when have a new product 
    Parameters: @listInventories(list of items)
				@oppId(id of opportunity)
    			@setProduct(products that not contains in list)
    Returns: Void
    Throws [Exceptions]: NONE
    ********************************************************************/
    private static void createOppItemNewProduct(String idContact,List<ICB_Wrapper_Cockpit_CC> listInventories,Set<String> setProduct)
    {
        System.debug('Entering <createOppItemNewProduct><oppId>: '+ idContact);
        System.debug('Entering <createOppItemNewProduct><listInventories>: '+ listInventories);
		System.debug('Entering <createOppItemNewProduct><setProduct>: '+ setProduct); 
        String oppId = [Select Id From Opportunity Where ICB_Contact__c =: idContact AND StageName =: CONST_STAGE_AVAILABLE].Id;
        for(ICB_Wrapper_Cockpit_CC ivt : listInventories)
        {
            if(!setProduct.contains(ivt.invetoryItem.ICB_Product__c + idContact))
            {
                List<ICB_Wrapper_Cockpit_CC> inventory = new List<ICB_Wrapper_Cockpit_CC>();
                inventory.add(ivt);
                createOppItem(oppId, JSON.serializePretty(inventory));                
            }
        }
        System.debug('Exiting <createOppItemNewProduct>');
    }
    /*******************************************************************
    Purpose: Update inventories for decrement or increment value
    Parameters: @inventoryList(list of items)
				@operation(type of operation. Values: increment or decrement )
    Returns: Void
    Throws [Exceptions]: NONE
    ********************************************************************/
    private static void updateInventory(String inventoryList)
    {
        System.debug('Entering <updateInventory>: '+ inventoryList);
        
        List<ICB_Wrapper_Cockpit_CC> listInventory = ICB_Cockpit_Helper.deserializeJSON(inventoryList);
        List<ICB_Inventory_Line_Item__c> listUpdateIvt = new List<ICB_Inventory_Line_Item__c>();
        setMapsIvtPb(listInventory);
        for(ICB_Wrapper_Cockpit_CC ivt : listInventory)
        {
            if(ivt.quantity <= (ivt.invetoryItem.ICB_Quantity_Unit__c + ivt.quantityMin))
            {
                ivt.invetoryItem.ICB_Quantity_Unit__c = ivt.invetoryItem.ICB_Quantity_Unit__c - (ivt.quantity - ivt.quantityMin);  
                listUpdateIvt.add(ivt.invetoryItem);        
            }
        }
        Database.update(listUpdateIvt);
        System.debug('Exiting <updateInventory>: ');
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
}