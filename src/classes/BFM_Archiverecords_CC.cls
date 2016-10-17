public class BFM_Archiverecords_CC{
    public BFM_Archiverecords_CC(){
    
    }
    public void bfm_delete_records(){
        date numofdays = system.Today()-7;
        
        
        
        //Error Log
        List<BFM_Error_Log__c> listErrorlogs = new List<BFM_Error_Log__c>();
        listErrorlogs = [select id from BFM_Error_Log__c where createddate <=: numofdays];
        if(!listErrorlogs.isEmpty()){
            delete listErrorlogs;
        }
        
        //File
        List<BFM_File__c> listfiles = new List<BFM_File__c>();
        listfiles = [select id from BFM_File__c where createddate <=: numofdays];
        if(!listfiles.isEmpty()){
            delete listfiles;
        }
        
        //Invoice Withhold Tax
        List<BFM_Invoice_Withhold_Tax__c> listInvoiceTax = new List<BFM_Invoice_Withhold_Tax__c>();
        listInvoiceTax = [select id from BFM_Invoice_Withhold_Tax__c where createddate <=: numofdays];
        if(!listInvoiceTax.isEmpty()){
            delete listInvoiceTax;
        }
        
        //IVA
        List<BFM_IVA__c> listIva = new List<BFM_IVA__c>();
        listIva = [select id from BFM_IVA__c where createddate <=: numofdays];
        if(!listIva.isEmpty()){
            delete listIva;
        }
        
        //MIGO
        List<BFM_MIGO__c> listMigo = new List<BFM_MIGO__c>();
        listMigo = [select id from BFM_MIGO__c where createddate <=: numofdays];
        if(!listMigo.isEmpty()){
            delete listMigo;
        }
        
        //MIRO Item Tax
        List<BFM_MIRO_Item_Tax__c> listMiroItemTax = new List<BFM_MIRO_Item_Tax__c>();
        listMiroItemTax = [select id from BFM_MIRO_Item_Tax__c where createddate <=: numofdays];
        if(!listMiroItemTax.isEmpty()){
            delete listMiroItemTax;
        }
        
        //MIRO WithHold Tax
        List<BFM_MIRO_Withhold_Tax__c> listMiroWitholdtax = new List<BFM_MIRO_Withhold_Tax__c>();
        listMiroWitholdtax = [select id from BFM_MIRO_Withhold_Tax__c where createddate <=: numofdays];
        if(!listMiroWitholdtax.isEmpty()){
            delete listMiroWitholdtax;
        }
        
        //MIRO Item
        List<BFM_MIRO_Item__c> listMiroItem = new List<BFM_MIRO_Item__c>();
        listMiroItem = [select id from BFM_MIRO_Item__c where createddate <=: numofdays];
        if(!listMiroItem.isEmpty()){
            delete listMiroItem;
        }
        
        //MIRO HEADER
        List<BFM_MIRO_Header__c> listMiroheader = new List<BFM_MIRO_Header__c>();
        listMiroheader = [select id from BFM_MIRO_Header__c where createddate <=: numofdays];
        if(!listMiroheader.isEmpty()){
            delete listMiroheader;
        }
        
        //POD
        List<BFM_POD__c> listPod = new List<BFM_POD__c>();
        listPod = [select id from BFM_POD__c where createddate <=: numofdays];
        if(!listPod.isEmpty()){
            delete listPod;
        }
        
        //Tax Code
        List<BFM_Tax_Code__c> listTaxCode = new List<BFM_Tax_Code__c>();
        listTaxCode = [select id from BFM_Tax_Code__c where createddate <=: numofdays];
        if(!listTaxCode.isEmpty()){
            delete listTaxCode;
        }
        
        //NF-E
        List<BFM_NF_e__c> listnfes = new List<BFM_NF_e__c>();
        listnfes = [select id from BFM_NF_e__c where createddate <=: numofdays];
        if(!listnfes.isEmpty()){
            delete listnfes;
        }
        
        //NF-E DF
        List<BFM_NF_e_DF__c> listnfedfs = new List<BFM_NF_e_DF__c>();
        listnfedfs = [select id from BFM_NF_e_DF__c where createddate <=: numofdays];
        if(!listnfedfs.isEmpty()){
            delete listnfedfs;
        }
        
        //CC-E
        List<BFM_CC_e__c> listcces = new List<BFM_CC_e__c>();
        listcces = [select id from BFM_CC_e__c where createddate <=: numofdays];
        if(!listcces.isEmpty()){
            delete listcces;
        }
        
        //CT-E
        List<BFM_CT_e__c> listctes = new List<BFM_CT_e__c>();
        listctes = [select id from BFM_CT_e__c where createddate <=: numofdays];
        if(!listctes.isEmpty()){
            delete listctes;
        }
        
                
        //MDF-E
        List<BFM_MDF_e__c> listmdfs = new List<BFM_MDF_e__c>();
        listmdfs = [select id from BFM_MDF_e__c where createddate <=: numofdays];
        if(!listmdfs.isEmpty()){
            delete listmdfs;
        }
        
        //NFS
        List<BFM_nfs__c> listnfs = new List<BFM_nfs__c>();
        listnfs = [select id from BFM_nfs__c where createddate <=: numofdays];
        if(!listnfs.isEmpty()){
            delete listnfs;
        }
        
        //Occurrence // Occurrence deletes: debit Note
        List<BFM_Occurrence__c> listOccurrences = new List<BFM_Occurrence__c>();
        listOccurrences = [select id from BFM_Occurrence__c where createddate <=: numofdays];
        if(!listOccurrences.isEmpty()){
            delete listOccurrences;
        }
        
        //Shipment  //shipments deletes: stages, ses, delivery
        List<BFM_Shipment__c> listShipments = new List<BFM_Shipment__c>();
        listShipments = [select id from BFM_Shipment__c where createddate <=: numofdays];
        if(!listShipments.isEmpty()){
            delete listShipments;
        }
        
        
        
        
        
        
    }
}