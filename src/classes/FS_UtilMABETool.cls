public class FS_UtilMABETool {
    
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
    
    Public List<Opportunity> getRelatedNewOpp(Opportunity existingOpp,List<Opportunity> listNewOpportunity){
        List<Opportunity> oppList=new List<Opportunity>();
        For(Opportunity opp : listNewOpportunity){
            If(opp.ContractId==existingOpp.ContractId){
                oppList.add(opp); 
            }
        }
        return oppList;
    }
    
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
            For(OpportunityLineItem newOli : tempExistingOliList){
                If(newOli.product2Id==oli.Product2Id){
                    oli.Quantity=oli.Quantity+newOli.quantity;
                    oli.TotalPrice=oli.TotalPrice+total_Price;
                }
            }
            tempOliListUpsert.add(oli);
        }
        system.debug(listNewPriceBookEntry);
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
    
    Public List<Contract_Product__c> getContractProduct(Opportunity existingOpp,List<Opportunity> listNewOpportunity,Map<Id,List<OpportunityLineItem>> mapRelatedOppLineItem){
        List<Contract_Product__c> tempconProductList=new List<Contract_Product__c>();
        List<Contract_Product__c> listConProdInsert=new List<Contract_Product__c>();
        
        List<OpportunityLineItem> listOli=new List<OpportunityLineItem>();
        Integer flag;
        
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
    
    Public List<Contract_Product__c> getContractProductUpdate(List<Contract_Product__c> conProdList,Map<Id,List<Contract_Product__c>> mapExistingContractConProd){
        List<Contract_Product__c> tempExistingConProductList=new List<Contract_Product__c>();
        List<Contract_Product__c> listContractProductUpdate=new List<Contract_Product__c>();
        Integer flag=0;
        For(Contract_Product__c conprod : conProdList){
            If(mapExistingContractConProd.containsKey(conProd.contract__c)){
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
            If(flag==1){                
                listContractProductUpdate.add(conProd);                
            }  
        }
        return listContractProductUpdate;       
    }
    
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
    
    Public List<FS_Contract_Product_Opportunity_Map__c> getCustomSetting(List<Contract_Product__c> listContractProductUpdate,Map<Id,List<OpportunityLineItem>> mapContractRelatedOppLineItem){
        List<FS_Contract_Product_Opportunity_Map__c> listNewCustomsetting=new List<FS_Contract_Product_Opportunity_Map__c>();
        List<OpportunityLineItem> tempOppLineItemList=new List<OpportunityLineItem>();
        For(Contract_Product__c ConProd : listContractProductUpdate){
            tempOppLineItemList=new List<OpportunityLineItem>();
            If(mapContractRelatedOppLineItem.containsKey(ConProd.Contract__c)){
                tempOppLineItemList=mapContractRelatedOppLineItem.get(ConProd.Contract__c); 
            }              
            For(OpportunityLineItem Oli : tempOppLineItemList){
                If(Oli.Product2Id==ConProd.Product__c){              
                    listNewCustomsetting.add(New FS_Contract_Product_Opportunity_Map__c(Name=String.valueof(ConProd.Id),FS_Contract_Product__c=ConProd.Id,FS_Opportunity__c=OLi.OpportunityId));
                }
            }
        }
        return listNewCustomsetting;
    }
}