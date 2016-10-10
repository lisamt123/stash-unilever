public with sharing class FS_UtilMABETool {  
    
/** Method getNewClosedOpportunity to set New opportunity which has been closed
*  @name getNewClosedOpportunity
*  @param List<Opportunity> listNewTrigger,Map<id,Opportunity> oppOldMap,Id newRecordTypeId
*  @return List<Opportunity>
*  @throws
*/
    Public List<Opportunity> getNewClosedOpportunity(List<Opportunity> listNewTrigger,Map<id,Opportunity> oppOldMap,Id newRecordTypeId){
        List<Opportunity> listNewOpportunity=new List<Opportunity>();
        for(Opportunity opp : listNewTrigger){           
            //Check if stage has been changed to Closed Won for New opportunities
            if(OppOldMap.get(opp.id).stagename!=opp.stagename && opp.isWon && opp.recordtypeid==newRecordTypeId && opp.ContractId!=Null){               
                listNewOpportunity.add(opp);//List of new opportunities which has been Won               
            }             
        }        
        return listNewOpportunity;        
    }
    
/* * Method getContractList to get list of contracts associated with opportunity
*  @name getContractList
*  @param List<Opportunity> listNewOpportunity
*  @return Set<Id>
*  @throws
*/     
    Public Set<Id> getContractList(List<Opportunity> listNewOpportunity){
        Set<Id> listContract=new Set<Id>();
        For(Opportunity opp: listNewOpportunity){
            listContract.add(opp.ContractId); 
        }
        return listContract;
    }
    
/* * Method createMapOliOpp to create map of line items with opportunity
*  @name createMapOliOpp
*  @param List<OpportunityLineItem> listExistingOppLineItem
*  @return Map<Id,List<OpportunityLineItem>>
*  @throws
*/     
    public Map<Id,List<OpportunityLineItem>> createMapOliOpp(List<OpportunityLineItem> listExistingOppLineItem){
        Map<Id,List<OpportunityLineItem>> mapRelatedOppLineItem=new Map<Id,List<OpportunityLineItem>>();
        List<OpportunityLineItem> tempOppLineItemList=new List<OpportunityLineItem>();
        For(OpportunityLineItem oli: listExistingOppLineItem){                                          
            tempOppLineItemList=new List<OpportunityLineItem>();
            if(mapRelatedOppLineItem.containskey(oli.OpportunityId))
            {
                tempOppLineItemList=mapRelatedOppLineItem.get(oli.OpportunityId);
            }               
            tempOppLineItemList.add(oli);
            mapRelatedOppLineItem.put(oli.OpportunityId,tempOppLineItemList);
        }
        return mapRelatedOppLineItem;
    }

/* * Method createMapOliOppContract to to create map of line items with contract
*  @name createMapOliOppContract
*  @param List<OpportunityLineItem> listExistingOppLineItem
*  @return Map<Id,List<OpportunityLineItem>>
*  @throws
*/     
    public Map<Id,List<OpportunityLineItem>> createMapOliOppContract(List<OpportunityLineItem> listExistingOppLineItem){
        Map<Id,List<OpportunityLineItem>> mapRelatedOppLineItem=new Map<Id,List<OpportunityLineItem>>();
        List<OpportunityLineItem> tempOppLineItemList=new List<OpportunityLineItem>();
        For(OpportunityLineItem oli: listExistingOppLineItem){                                          
            tempOppLineItemList=new List<OpportunityLineItem>();
            if(mapRelatedOppLineItem.containskey(oli.Opportunity.ContractId))
            {
                tempOppLineItemList=mapRelatedOppLineItem.get(oli.Opportunity.ContractId);
            }               
            tempOppLineItemList.add(oli);
            mapRelatedOppLineItem.put(oli.Opportunity.ContractId,tempOppLineItemList);
        }
        return mapRelatedOppLineItem;
    }

/* * Method getRelatedNewOpp to fet related list of New opportunities for existing opportunity
*  @name getRelatedNewOpp
*  @param Opportunity existingOpp,List<Opportunity> listNewOpportunity
*  @return List<Opportunity> oppList
*  @throws
*/     
    Public List<Opportunity> getRelatedNewOpp(Opportunity existingOpp,List<Opportunity> listNewOpportunity){
        List<Opportunity> oppList=new List<Opportunity>();
        For(Opportunity opp : listNewOpportunity){
            If(opp.ContractId==existingOpp.ContractId){
                oppList.add(opp); 
            }
        }
        return oppList;
    }

/* * Method getOlifromNewOpp to get line item to upsert for opportunities
*  @name getOlifromNewOpp
*  @param List<Opportunity> listNewTrigger
*  @return List<OpportunityLineItem>
*  @throws
*/     
    Public List<OpportunityLineItem> getOlifromNewOpp(Opportunity existingOpp,List<Opportunity> listNewOpp,Map<Id,List<OpportunityLineItem>> mapRelatedOppLineItem){
        List<OpportunityLineItem> tempNewOliList=new List<OpportunityLineItem>();
        List<OpportunityLineItem> tempOliListUpsert=new List<OpportunityLineItem>();
        List<OpportunityLineItem> tempExistingOliList=new List<OpportunityLineItem>();
        Set<Id> listPriceBookEntry=new Set<Id>();
        Set<Id> listNewPriceBookEntry=new Set<Id>();
        Decimal total_quantity;
        Decimal total_Price;
        If(mapRelatedOppLineItem.containsKey(existingOpp.Id)){
            tempExistingOliList=mapRelatedOppLineItem.get(existingOpp.Id);   
        }        
        For(Opportunity opp : listNewOpp){
            If(mapRelatedOppLineItem.containsKey(opp.Id)){
                tempNewOliList.addall(mapRelatedOppLineItem.get(opp.Id));   
            }           
        }        
        For(OpportunityLineItem oli : tempNewOliList){
            listNewPriceBookEntry.add(oli.PricebookEntryId);
        }
        For(OpportunityLineItem oli : tempExistingOliList){
            listPriceBookEntry.add(oli.PricebookEntryId);
            For(OpportunityLineItem newOli : tempNewOliList){
                If(newOli.product2Id==oli.Product2Id){
                    oli.Quantity=oli.Quantity+newOli.quantity;
                    oli.TotalPrice=oli.TotalPrice+newOli.TotalPrice;
                }
            }
            tempOliListUpsert.add(oli);
        }        
        For(Id pbeId : listNewPriceBookEntry){
            total_quantity=0;
            total_Price=0;
            If(!listPriceBookEntry.contains(pbeId)){
                For(OpportunityLineItem newOli : tempNewOliList){
                    If(newOli.pricebookentryId==pbeId){
                        total_quantity=total_quantity+newOli.quantity;
                        total_Price=total_Price+newOli.TotalPrice;  
                    }                        
                }
                tempOliListUpsert.add(new OpportunityLineItem(Opportunityid = existingOpp.Id,PriceBookEntryId=pbeId,quantity=total_quantity,TotalPrice=total_Price));
            }
        }        
        return tempOliListUpsert;
    }

/* * Method getMapExistingConProduct to create map of contract product for each contract
*  @name getMapExistingConProduct
*  @param List<Contract_Product__c> contractProductList
*  @return Map<Id,List<Contract_Product__c>>
*  @throws
*/     
    Public Map<Id,List<Contract_Product__c>> getMapExistingConProduct(List<Contract_Product__c> contractProductList){
        Map<Id,List<Contract_Product__c>> mapExistingContractConProd=new Map<Id,List<Contract_Product__c>>();
        List<Contract_Product__c> tempExistingConProductList=new List<Contract_Product__c>();
        for(Contract_Product__c newContractProduct : contractProductList)
        {
            tempExistingConProductList  = new List<Contract_Product__c>();
            if(mapExistingContractConProd.containskey(newContractProduct.Contract__c))
            {
                tempExistingConProductList   = mapExistingContractConProd.get(newContractProduct.Contract__c);
            }
            tempExistingConProductList.add(newContractProduct);
            mapExistingContractConProd.put(newContractProduct.Contract__c,tempExistingConProductList);            
        }
        return mapExistingContractConProd;
    }
    
/* * Method getContractProduct to get list of contract product to be created for MABE process
*  @name getContractProduct
*  @param Opportunity existingOpp,List<Opportunity> listNewOpportunity,Map<Id,List<OpportunityLineItem>> mapRelatedOppLineItem
*  @return List<Contract_Product__c>
*  @throws
*/ 
    Public List<Contract_Product__c> getContractProduct(Opportunity existingOpp,List<Opportunity> listNewOpportunity,Map<Id,List<OpportunityLineItem>> mapRelatedOppLineItem){
        List<Contract_Product__c> tempconProductList=new List<Contract_Product__c>();       
        List<OpportunityLineItem> listOli=new List<OpportunityLineItem>();
        
        For(Opportunity opp: listNewOpportunity){
            If(mapRelatedOppLineItem.containsKey(opp.Id)){
                listOli=mapRelatedOppLineItem.get(opp.Id); 
            }            
            For(OpportunityLineItem oli : listOli){
                tempconProductList.add(new Contract_Product__c(contract__c=existingOpp.ContractId,Product__c=oli.Product2Id,name=String.valueof(oli.Product2.name)));  
            }            
        }
        return tempconProductList;
    }

/* * Method getContractProductInsert to get list for contract product for insert
*  @name getContractProductInsert
*  @param List<Contract_Product__c> conProdList,Map<Id,List<Contract_Product__c>> mapExistingContractConProd
*  @return List<Contract_Product__c>
*  @throws
*/     
    Public List<Contract_Product__c> getContractProductInsert(List<Contract_Product__c> conProdList,Map<Id,List<Contract_Product__c>> mapExistingContractConProd){
        List<Contract_Product__c> tempExistingConProductList=new List<Contract_Product__c>();
        List<Contract_Product__c> listContractProductInsert=new List<Contract_Product__c>();
        Integer flag=0;
        For(Contract_Product__c conprod : conProdList){
            If(mapExistingContractConProd.containsKey(conprod.Contract__c)){
                tempExistingConProductList=mapExistingContractConProd.get(conProd.contract__c); 
            }            
            flag=0;
            If(!tempExistingConProductList.isEmpty()){
                For(Contract_Product__c existingConProd : tempExistingConProductList){
                    If(existingConProd.product__c==conProd.product__c){
                        flag=1;  
                    }
                }  
            }            
            If(flag==0){                
                listContractProductInsert.add(conProd);
                tempExistingConProductList.add(conProd);
                mapExistingContractConProd.put(conProd.Contract__c,tempExistingConProductList);
            }  
        }
        return listContractProductInsert;       
    }

/* * Method getContractProductUpdate to get list for contract product for update
*  @name getContractProductUpdate
*  @param List<Contract_Product__c> conProdList,Map<Id,List<Contract_Product__c>> mapExistingContractConProd
*  @return List<Contract_Product__c>
*  @throws
*/ 
    Public List<Contract_Product__c> getContractProductUpdate(List<Contract_Product__c> conProdList,Map<Id,List<Contract_Product__c>> mapExistingContractConProd){
        List<Contract_Product__c> tempExistingConProductList=new List<Contract_Product__c>();
        List<Contract_Product__c> listContractProductUpdate=new List<Contract_Product__c>();        
        Set<Id> contractProductList=new Set<Id>();                
        For(Contract_Product__c conProd : conProdList){            
            If(mapExistingContractConProd.containsKey(conProd.contract__c)){
                tempExistingConProductList=mapExistingContractConProd.get(conProd.contract__c);                
                For(Contract_Product__c existingConProd : tempExistingConProductList){
                    If(existingConProd.product__c==conProd.product__c){                        
                        listContractProductUpdate.add(existingConProd);
                        contractProductList.add(existingConProd.Id);
                        break;
                    }
                }  
            }                       
        }
        listContractProductUpdate=[select id,contract__c,product__c from contract_product__c where id in : contractProductList];
        return listContractProductUpdate;       
    }

/* * Method getOlitoUpdate to get list of line items to look up on corrsponding contract product
*  @name getOlitoUpdate
*  @param List<OpportunityLineItem> oppLineItemUpsert,Map<Id,List<Contract_Product__c>> mapContractConProd
*  @return List<OpportunityLineItem>
*  @throws
*/     
    Public List<OpportunityLineItem> getOlitoUpdate(List<OpportunityLineItem> oppLineItemUpsert,Map<Id,List<Contract_Product__c>> mapContractConProd){
        List<Contract_Product__c> tempConProductList=new List<Contract_Product__c>();
        List<OpportunityLineItem> oppLineItemToUpdate=new List<OpportunityLineItem>();
        For(opportunityLineItem oli: oppLineItemUpsert){            
            If(oli.Contract_Product__c==null){
                tempConProductList=new List<Contract_Product__c>();
                If(mapContractConProd.containsKey(oli.Opportunity.contractId)){
                    tempConProductList=mapContractConProd.get(oli.Opportunity.contractId); //Get relevant contract product list
                    //Open loop for each contract product for associated contract
                    For(Contract_Product__c newContractProduct : tempConProductList){                    
                        IF(oli.Pricebookentry.Product2Id==newContractProduct.Product__c){
                            oli.Contract_Product__c=newContractProduct.Id;
                            oppLineItemToUpdate.add(oli);                    
                            Break;
                        }                
                    }   
                }                                          
            }   
        }
        return oppLineItemToUpdate;
    }

/* * Method getCustomSetting to prepare custom list for contract product opportunity map
*  @name getCustomSetting
*  @param List<Contract_Product__c> listContractProductUpdate,Map<Id,List<OpportunityLineItem>> mapContractRelatedOppLineItem
*  @return List<FS_Contract_Product_Opportunity_Map__c>
*  @throws
*/ 
    Public List<FS_Contract_Product_Opportunity_Map__c> getCustomSetting(List<Contract_Product__c> listContractProductUpdate,Map<Id,List<OpportunityLineItem>> mapContractRelatedOppLineItem){
        List<FS_Contract_Product_Opportunity_Map__c> listNewCustomsetting=new List<FS_Contract_Product_Opportunity_Map__c>();
        List<OpportunityLineItem> tempOppLineItemList=new List<OpportunityLineItem>();
        For(Contract_Product__c conProd : listContractProductUpdate){
            tempOppLineItemList=new List<OpportunityLineItem>();
            If(mapContractRelatedOppLineItem.containsKey(ConProd.Contract__c)){
                tempOppLineItemList=mapContractRelatedOppLineItem.get(ConProd.Contract__c); 
            }              
            For(OpportunityLineItem Oli : tempOppLineItemList){
                If(Oli.Product2Id==ConProd.Product__c){              
                    listNewCustomsetting.add(New FS_Contract_Product_Opportunity_Map__c(Name=String.valueof(conProd.Id),FS_Contract_Product__c=ConProd.Id,FS_Opportunity__c=OLi.OpportunityId));
                }
            }
        }        
        return listNewCustomsetting;
    }
}