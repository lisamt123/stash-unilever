/**********************************************************************
Name: ICB_Cockpit_Helper
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Helper class for controller ICB_Cockpit
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
1.0    	Antonio Raul 	27/08/2016  Class creation 
1.0    	Antonio Raul 	28/08/2016  Class finished
1.1    	Antonio Raul 	30/08/2016  Class updated
***********************************************************************/
public with sharing class ICB_Cockpit_Helper 
{
    private static final String CONST_STATUS_ITEM_OPP_SOLD_PENDING;
    private static final String CONST_STAGE_CLOSED;
    private static final String CONST_STAGE_AVAILABLE;
    private static final String CONST_STATUS_ITEM_OPP_STOCK;
    private static final String CONST_STAGE_PENDING;
    private static final String CONST_EMPTY;
    private static final String CONST_SOLICITATION;
    private static List<OpportunityLineItem> listOppItemUp;
    
    Static
    {
        CONST_STATUS_ITEM_OPP_SOLD_PENDING = 'sold pending stock';
        CONST_EMPTY = '';
        CONST_STAGE_CLOSED = 'Closed';
        CONST_STAGE_AVAILABLE = 'Available';
        CONST_STAGE_PENDING = 'Pending';
        CONST_STATUS_ITEM_OPP_STOCK = 'stock';
        CONST_SOLICITATION = 'Solicitation';
        listOppItemUp = new List<OpportunityLineItem>();
    }
    /*******************************************************************
    Purpose: Return teh map of wrapper class for method getContacts
    Parameters: @listOpportunityLineItem(list the opportunity line item returned of method getcontacts)
    Returns: Map<String,ICB_Wrapper_Cockpit_CC>
    Throws [Exceptions]: NONE
    ********************************************************************/
    public static Map<String,ICB_Wrapper_Cockpit_CC> returnMapLineItem(List<OpportunityLineItem> listOpportunityLineItem)
    {
        System.debug('Entering <returnMapLineItem>: '+ JSON.serializePretty(listOpportunityLineItem));
        Map<String,ICB_Wrapper_Cockpit_CC> mapLineItem = new Map<String,ICB_Wrapper_Cockpit_CC>();
        ICB_Wrapper_Cockpit_CC item = new ICB_Wrapper_Cockpit_CC();
        item.quantityIce = 0;
        for(OpportunityLineItem oppItem : listOpportunityLineItem)
        {
            if(mapLineItem != null)
            {
                if(!mapLineItem.keySet().contains(oppItem.OpportunityId))
                {
                    item = new ICB_Wrapper_Cockpit_CC();
                    item.quantityIce = 0;
                }
            }
            if(oppItem.ICB_STATUS_SALES__c == CONST_STATUS_ITEM_OPP_SOLD_PENDING && oppItem.ICB_STATUS_SALES__c != CONST_EMPTY)
            {
                item.quantityIce = oppItem.ICB_ITEMS_RETURNED__c == null ? 0 : item.quantityIce + oppItem.ICB_ITEMS_RETURNED__c;
                item.quantityMin = oppItem.ICB_ITEMS_RETURNED__c == null ? 0 : (Integer)oppItem.ICB_ITEMS_RETURNED__c;
            }
            else
            {
                item.quantityIce = oppItem.Quantity == null ? 0 : item.quantityIce + oppItem.Quantity; 
            }
            item.oppLineItem = oppItem;
            mapLineItem.put(oppItem.OpportunityId, item);
        } 
        System.debug('Exiting <returnMapLineItem>: '+ JSON.serializePretty(mapLineItem));
        return mapLineItem;
    }
    /*******************************************************************
    Purpose: Return teh list of wrapper class for method getInventories
    Parameters: @oppLineList(list the opportunity line item returned of method getInventories)
				@ivt(variable returned of for of method getInventories)
				@operation(current operation)
				@idContact(current contact)
    Returns: List<ICB_Wrapper_Cockpit_CC>
    Throws [Exceptions]: NONE
    ********************************************************************/
    public static List<ICB_Wrapper_Cockpit_CC> returnListWrapper(List<OpportunityLineItem> oppLineList,ICB_Inventory_Line_Item__c ivt,String operation,String idContact)
    {
        System.debug('Entering <returnListWrapper><oppLineList>: '+ JSON.serializePretty(oppLineList));
        System.debug('Entering <returnListWrapper><ivt>: '+ JSON.serializePretty(ivt));
        System.debug('Entering <returnListWrapper><operation>: '+ operation);
        System.debug('Entering <returnListWrapper><idContact>: '+ idContact);
        ICB_Wrapper_Cockpit_CC itemWrapper = new ICB_Wrapper_Cockpit_CC();
        
        List<ICB_Wrapper_Cockpit_CC> listWrapper = new List<ICB_Wrapper_Cockpit_CC>();
        
        Boolean isClosed = false;
        
        for(OpportunityLineItem oppItem : oppLineList)
        {
            
            if(oppItem.Product2Id == ivt.ICB_Product__c && idContact == oppItem.Opportunity.ICB_Contact__c && oppItem.Opportunity.StageName != CONST_STAGE_AVAILABLE)
            {
                
                itemWrapper = firstItemWrapper(operation,itemWrapper,oppItem);
            }
            else
            {
                if(oppItem.Product2Id == ivt.ICB_Product__c && idContact == oppItem.Opportunity.ICB_Contact__c)
                {
                    listWrapper.addAll(listWrapperClosed(oppItem,ivt)); 
                    isClosed = true;
                }
            }
        }
        if(!isClosed)
        {
            itemWrapper.invetoryItem = ivt;
            listWrapper.add(itemWrapper);
        }
        updateOppItem(listOppItemUp,operation);
        System.debug('Exiting <returnListWrapper>: '+ JSON.serializePretty(listWrapper));
        return listWrapper;
    }
    /*******************************************************************
    Purpose: Method helper the returnListWrapper
    Parameters: @operation(current operation)
				@itemWrapper(item returned)
				@oppItem(oppotunity line item pass for the controller class)
    Returns: ICB_Wrapper_Cockpit_CC
    Throws [Exceptions]: NONE
    ********************************************************************/
    private static ICB_Wrapper_Cockpit_CC firstItemWrapper(String operation,ICB_Wrapper_Cockpit_CC firstItem, OpportunityLineItem oppItem)
    {
        System.debug('Entering <firstItemWrapper><operation>: '+ operation);
        System.debug('Entering <firstItemWrapper><firstItem>: '+ JSON.serializePretty(firstItem));
        System.debug('Entering <firstItemWrapper><oppItem>: '+ JSON.serializePretty(oppItem));
        ICB_Wrapper_Cockpit_CC item = new ICB_Wrapper_Cockpit_CC();
        if(operation.equalsIgnoreCase(CONST_STAGE_CLOSED))	
        { 
            firstItem.quantity = oppItem.ICB_ITEMS_RETURNED__c == null ? 0 : (Integer)oppItem.ICB_ITEMS_RETURNED__c;
        }
        else
        {
            item = secondItemWrapper(operation,firstItem,oppItem);
        }
        System.debug('Exiting <firstItemWrapper><item>: '+ JSON.serializePretty(item));
        return item;
    }
    /*******************************************************************
    Purpose: Method helper the returnListWrapper
    Parameters: @operation(current operation)
				@itemWrapper(item returned)
				@oppItem(oppotunity line item pass for the controller class)
    Returns: ICB_Wrapper_Cockpit_CC
    Throws [Exceptions]: NONE
    ********************************************************************/
    private static ICB_Wrapper_Cockpit_CC secondItemWrapper(String operation,ICB_Wrapper_Cockpit_CC secondItem, OpportunityLineItem oppItem)
    {
        System.debug('Entering <secondItemWrapper><operation>: '+ operation);
        System.debug('Entering <secondItemWrapper><secondItem>: '+ JSON.serializePretty(secondItem));
        System.debug('Entering <secondItemWrapper><oppItem>: '+ JSON.serializePretty(oppItem));
        ICB_Wrapper_Cockpit_CC item = new ICB_Wrapper_Cockpit_CC();
        Boolean isStock = false;
        if(oppItem.ICB_STATUS_SALES__c == CONST_STATUS_ITEM_OPP_STOCK )
        {
            secondItem.quantity = oppItem.Quantity == null ? 0 : (Integer)oppItem.Quantity; 
            secondItem.quantityMin = oppItem.ICB_ITEMS_RETURNED__c == null ? 0 : (Integer)oppItem.ICB_ITEMS_RETURNED__c;
            isStock = true;
        }
        item = secondItem;
        item = thirdItemWrapper(operation,secondItem,oppItem,isStock); 
        item = fourthItemWrapper(operation,secondItem,oppItem);
        System.debug('Exiting <secondItemWrapper><item>: '+ JSON.serializePretty(item));
        return item;
    }
    /*******************************************************************
    Purpose: Method helper the returnListWrapper
    Parameters: @operation(current operation)
				@itemWrapper(item returned)
				@oppItem(oppotunity line item pass for the controller class)
				@isStock
    Returns: ICB_Wrapper_Cockpit_CC
    Throws [Exceptions]: NONE
    ********************************************************************/
    private static ICB_Wrapper_Cockpit_CC thirdItemWrapper(String operation,ICB_Wrapper_Cockpit_CC thirdItem, OpportunityLineItem oppItem, Boolean isStock)
    {
        System.debug('Entering <thirdItemWrapper><operation>: '+ operation);
        System.debug('Entering <thirdItemWrapper><thirdItem>: '+ JSON.serializePretty(thirdItem));
        System.debug('Entering <thirdItemWrapper><oppItem>: '+ JSON.serializePretty(oppItem));
        if(oppItem.ICB_STATUS_SALES__c == CONST_STATUS_ITEM_OPP_SOLD_PENDING && !isStock)
        {
            thirdItem.quantity = oppItem.ICB_ITEMS_RETURNED__c == null ? 0 : (Integer)oppItem.ICB_ITEMS_RETURNED__c;
            thirdItem.quantityMin = oppItem.ICB_ITEMS_RETURNED__c == null ? 0 : (Integer)oppItem.ICB_ITEMS_RETURNED__c;
            oppItem.ICB_IS_CLOSED__C = true;
            listOppItemUp.add(oppItem);
        }
        System.debug('Exiting <thirdItemWrapper><thirdItem>: '+ JSON.serializePretty(thirdItem));
        return thirdItem;
    }
    /*******************************************************************
    Purpose: Method helper the returnListWrapper
    Parameters: @operation(current operation)
				@itemWrapper(item returned)
				@oppItem(oppotunity line item pass for the controller class)
    Returns: ICB_Wrapper_Cockpit_CC
    Throws [Exceptions]: NONE
    ********************************************************************/
    private static ICB_Wrapper_Cockpit_CC fourthItemWrapper(String operation,ICB_Wrapper_Cockpit_CC fourthItem, OpportunityLineItem oppItem)
    {
        System.debug('Entering <fourthItemWrapper><operation>: '+ operation);
        System.debug('Entering <fourthItemWrapper><fourthItem>: '+ JSON.serializePretty(fourthItem));
        System.debug('Entering <fourthItemWrapper><oppItem>: '+ JSON.serializePretty(oppItem));
       if(oppItem.Opportunity.StageName == CONST_STAGE_PENDING)
        {
            if(oppItem.ICB_STATUS_SALES__c != CONST_STATUS_ITEM_OPP_SOLD_PENDING)
            {
                fourthItem.quantity = oppItem.Quantity == null ? 0 : (Integer)oppItem.Quantity; 
            }
            else
            {
                fourthItem.quantity = oppItem.ICB_ITEMS_RETURNED__c == null ? 0 : (Integer)oppItem.ICB_ITEMS_RETURNED__c;
                fourthItem.quantityMin = oppItem.ICB_ITEMS_RETURNED__c == null ? 0 : (Integer)oppItem.ICB_ITEMS_RETURNED__c;
                oppItem.ICB_IS_CLOSED__C = true;
                listOppItemUp.add(oppItem);
            }
            
        }
        System.debug('Exiting <fourthItemWrapper><fourthItem>: '+ JSON.serializePretty(fourthItem));
        return fourthItem;
    }
    /*******************************************************************
    Purpose: Updated opportunity line item
    Parameters: @listOppItemUp(list the opportunity line item returned of method getInventories)
				@operation(current operation)
    Returns: VOID
    Throws [Exceptions]: NONE
    ********************************************************************/
    private static void updateOppItem(List<OpportunityLineItem> listOppItem, String operation)
    {
        System.debug('Entering <updateOppItem><listOppItemUp>: '+ JSON.serializePretty(listOppItem));
        System.debug('Entering <updateOppItem><operation>: '+ operation);
        if(!listOppItem.isEmpty() && operation.equals(CONST_SOLICITATION))
        {
            Database.update(listOppItem);    
        }
        System.debug('Exiting <updateOppItem>');
    }
    /*******************************************************************
    Purpose: Return the list wrapper class for used in methodo getinventories
    Parameters: @oppItem(current opportunity line item)
				@ivt(variable returned of for of method getInventories)
    Returns: List<ICB_Wrapper_Cockpit_CC>
    Throws [Exceptions]: NONE
    ********************************************************************/
    private static List<ICB_Wrapper_Cockpit_CC> listWrapperClosed(OpportunityLineItem oppItem,ICB_Inventory_Line_Item__c ivt)
    {
        System.debug('Entering <listWrapperClosed><oppItem>: '+ JSON.serializePretty(oppItem));
        System.debug('Entering <listWrapperClosed><ivt>: '+ JSON.serializePretty(ivt));
        List<ICB_Wrapper_Cockpit_CC> wrapperList = new List<ICB_Wrapper_Cockpit_CC>();
        ICB_Wrapper_Cockpit_CC itemWrapper = new ICB_Wrapper_Cockpit_CC();
        itemWrapper.quantityReturned = oppItem.Quantity == null ? 0 : (Integer)oppItem.Quantity; 
        itemWrapper.invetoryItem = ivt;
        wrapperList.add(itemWrapper);
        System.debug('Exiting <listWrapperClosed>: ' + JSON.serializePretty(wrapperList));
        return wrapperList;
    }
}