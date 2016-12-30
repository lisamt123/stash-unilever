/***************************************************************
Name: UL_TacticsValidate
Copyright © 2016 Salesforce
======================================================
Purpose:
Validate Tactics overlap with existing tactics in the same promotion and same tactics template and products mandatory at each tactics level
======================================================
History
-------
VERSION     AUTHOR             DATE              DETAIL            Description
1.0         Chandrababu Naidu    21/11/2016        INITIAL DEV     Validate Tactics overlap and products in Sprint-3.
*****************************************************************/
public with sharing class UL_TacticsValidate {
    /*******************************************************************
    Purpose: Validate Tactics overlap and products
    Version: 1.0
    Parameters: Transaction id and BOPromotion Content from controller-MyPromotionRemoteActionExtension
    Returns: Void
    Throws N/A
    ********************************************************************/
    public static void tacticsOverlap(string txid,string promContent){
         boolean productsMandate = false;
        boolean TacticsOverlap = false;
         List<ACCL__Tactic__c> LOTactics=new  List<ACCL__Tactic__c>();
        Map<String, Object> tacticDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(promContent);
        Map<String, Object> boPromotion = (Map<String, Object>) tacticDeserializedMap.get('BOPromotion');
         List<Object> LOTacticList=(List<Object>)boPromotion.get('LOTactic');
	     if(boPromotion.containsKey('LOTactic')){
             for(Object tacticobj:LOTacticList){
      	
            Map<String, Object> loTactic = (Map<String, Object>)tacticobj;
		    Set<String> listOfKeys = loTactic.keySet();
            
                 Integer status= Integer.valueOf( loTactic.get('__ObjectStatus'));
                 //Verify for the new tactics(status==6) or duplicate tactics(status==2)
                 List<String> lstOfFields = new List<String>(listOfKeys);
                 if(status==6 || status==2){
                     
                     Map<String, Object> filterCriteria = (Map<String, Object>)loTactic.get('productfilter');
                      if (filterCriteria <> null) {
    					List<Object> manualProducts = (List<Object>)filterCriteria.get('manualproducts');
                           if (manualProducts!=null && manualProducts.size()>0)
    						{
                            }
                          else{
                              //Validation if there are no products present at new or duplicate Tactic level
                              productsMandate=true;
                              //Commented below in order to handle products mandatory based on checkbox from tactic template
                            //throw new UL_TacticsValidate.CustomException(label.UL_ProductsMandatory);  
                          }
                      }
                   ACCL__Tactic__c ltactic = new ACCL__Tactic__c();
                     Set<String> setfields = new Set<String>();
                     setfields.add('ACCL__Promotion__c');
                     setfields.add('ACCL__Date_From__c');
                     setfields.add('ACCL__Date_Thru__c');
                     setfields.add('ACCL__Tactic_Template__c');
                     setfields.add('Id');
                     
                     ltactic=(ACCL__Tactic__c)checkFieldTypeAndParsetheJson(txId,setfields,loTactic,'ACCL__Tactic__c');
                  LOTactics.add(ltactic);
                 }
             }
    }
        if(LOTactics!=null && LOTactics.size()>0){
           
          list<ACCL__Tactic_Template__c> tacticTemp = [select UL_TacticOverlap__c from ACCL__Tactic_Template__c where id=:LOTactics[0].ACCL__Tactic_Template__c limit 1];
         TacticsOverlap =tacticTemp[0].UL_TacticOverlap__c;
        }
        if(TacticsOverlap && productsMandate){
          throw new UL_TacticsValidate.CustomException(label.UL_ProductsMandatory);  
        }
        system.debug('new or copied tactics-'+LOTactics);
        if(LOTactics!=null && LOTactics.size()>0){
            map<id,ACCL__Tactic__c> tacticTemp = new map<id,ACCL__Tactic__c>();
 set<id> promotionset = new set<id>();
 for(ACCL__Tactic__c TacDetails : LOTactics){
 promotionset.add(TacDetails.ACCL__Promotion__c);
 
 }
 list<ACCL__Tactic__c> existTactics = [select id,ACCL__Tactic_Template__c,ACCL__Date_From__c,ACCL__Date_Thru__c,ACCL__Promotion__c,ACCL__Tactic_Template__r.UL_TacticOverlap__c from ACCL__Tactic__c where ACCL__Promotion__c in:promotionset];
 
 if(existTactics!=null && existTactics.size()>0){
 for(ACCL__Tactic__c tacdet : existTactics){
   tacticTemp.put(tacdet.ACCL__Tactic_Template__c,tacdet);
 } 
  for(ACCL__Tactic__c newTactic : LOTactics){
  //Check Tactics for overlapping on the same Promotion and same tactics template
   
   for(ACCL__Tactic__c checkExist : existTactics){
      
   if((checkExist.id!=newTactic.id && checkExist.ACCL__Tactic_Template__r.UL_TacticOverlap__c && checkExist.ACCL__Tactic_Template__c==newTactic.ACCL__Tactic_Template__c && newTactic.ACCL__Date_From__c >= checkExist.ACCL__Date_From__c && newTactic.ACCL__Date_From__c <= checkExist.ACCL__Date_Thru__c) || (checkExist.ACCL__Tactic_Template__r.UL_TacticOverlap__c && checkExist.ACCL__Tactic_Template__c==newTactic.ACCL__Tactic_Template__c && newTactic.ACCL__Date_Thru__c >= checkExist.ACCL__Date_From__c && newTactic.ACCL__Date_Thru__c <= checkExist.ACCL__Date_Thru__c)){
    throw new UL_TacticsValidate.CustomException(label.UL_TacticsOverlap);
   }
   }
  }
  }
        }
        
    }
    /** checkFieldTypeAndParsetheJson method filter the  Json Data on field type from the UI and parse it back to SObject
     *  @name   :  checkFieldTypeAndParsetheJson
     *  @param  :  txId         GUI id for each transcation we do from UI
     *  @param  :  setfields    set of fields for a Object which is updateble
     *  @param  :  boPromotion  Map<String, Object> contains the Key as API name of field and value as value
     *  @param  :  sObjectType  object Type Like Promotion__c
     *  @return :  SObject       SObject whichc can be Type Cast to Custom/Standard object
     *  @throws :
     *  @author  : g.prajapat@accenture.com
     */
	static SObject checkFieldTypeAndParsetheJson(String txId,Set<String> setfields,Map<String, Object> boPromotion,String sObjectType)
	{
        //LoggerUtility.log('checkFieldTypeAndParsetheJson is called! Transcation Id:'+txId,sObjectType);
        SObjectType objectType = Schema.getGlobalDescribe().get(sObjectType);
        Map<String, Schema.SObjectField> sObjectFieldApiNameMap = objectType.getDescribe().fields.getMap();
        SObject sObjValue = Schema.getGlobalDescribe().get(sObjectType).newSObject() ;
        if(boPromotion!=null){
            for(String key:setfields){
                
                if(key !=null && setfields.size()>0){
                    if(boPromotion.containsKey(key))
                    {
                        
                        if(boPromotion.get(key)!=null){
                            
                            String fieldType = sObjectFieldApiNameMap.get(key).getDescribe().getType().name().ToLowerCase();
                            if(fieldType == 'date'){
                                if(boPromotion.get(key)==''){
                                     throw new UL_TacticsValidate.CustomException('Please fill date field '+key);
                                }
                                else
                                    sObjValue.put(key,objToDate(boPromotion.get(key)));
                                
                            }
                            else if(fieldType == 'reference'){
                                sObjValue.put(key,String.valueOf(boPromotion.get(key)));
                            }
                            else if(fieldType == 'currency' || fieldType == 'decimal' || fieldType == 'integer'){
                                sObjValue.put(key,Integer.valueOf(boPromotion.get(key)));
                            }
                            
                            else if(fieldType == 'double' ||fieldType == 'percent')
                            {
                            	
								sObjValue.put(key,double.valueOf(boPromotion.get(key)));
                            }
                            else if(fieldType == 'boolean'){
                                sObjValue.put(key,Boolean.valueOf(boPromotion.get(key)));
                            }
                            else if(fieldType == 'lookup'){
                                sObjValue.put(key,String.valueOf(boPromotion.get(key)));
                            }
                            else if(fieldType == 'formula'){
                                sObjValue.put(key,String.valueOf(boPromotion.get(key)));
                            }
		                    else {
								String tmp=(String)boPromotion.get(key);
								if(tmp.trim()=='')
								{
							   		throw new UL_TacticsValidate.CustomException('Please fill the Empty Field '+key);
								}
								else
								{
									sObjValue.put(key,String.valueOf(boPromotion.get(key)));
								}
						 	}
                        }
                    }
                    else{
                       
                        //throw new CustomException('field is not in the list:' + key);
                    }
                }
            }
        }
        return 	sObjValue;
    }
    /***************************************************************
    Name: customException
    Copyright © 2016 Salesforce
    ======================================================
    Purpose:
    Exception sub class
    ======================================================
    History
    -------
    VERSION     AUTHOR             DATE              DETAIL            Description
    1.0         Chandrababu Naidu    21/11/2016        INITIAL DEV     Exception sub class in Sprint-3.
    *****************************************************************/	
    public class customException extends Exception{
        
    }
    /*******************************************************************
    Purpose: Validate date and return date
    Version: 1.0
    Parameters: getting date object
    Returns: date
    Throws N/A
    ********************************************************************/
    public static Date objToDate(Object o) {
	if (o == null) return null;
	if (o instanceof Date) return (Date)o;
	if (o instanceof Long) {
	    Long i = (Long)o;
	    DateTime dt = DateTime.newInstance(i);
	    return dt.Date();
	}
	if (o instanceof Integer) {
	    Integer i = (Integer)o;
	    DateTime dt = DateTime.newInstance(i);
	    return dt.Date();
	}
	if (o instanceof String) {
	    String s = (String)o;
	    String[] strDate = s.split('-');
	     Integer myIntDate = integer.valueOf(strDate[2]);
	     Integer myIntMonth = integer.valueOf(strDate[1]);
	     Integer myIntYear = integer.valueOf(strDate[0]);
	     Date datevalue = Date.newInstance(myIntYear, myIntMonth, myIntDate);
	    return datevalue;
	}
	return Date.newInstance(1700, 1, 1);
    }
}