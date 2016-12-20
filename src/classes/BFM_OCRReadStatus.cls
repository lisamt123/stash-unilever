@RestResource(urlMapping='/BFM/OCRStatus/v1/*')
global class BFM_OCRReadStatus {
    
    @HttpPost
    global static BFM_OCRReadStatusResponse getRecordsPending(Integer maxRecords){
        BFM_OCRReadStatusResponse response = new BFM_OCRReadStatusResponse();
        response.responseItems = new List<BFM_OCRReadStatusResponse.ResponseItem>();
        
        List<BFM_POD__c> pods = [SELECT Id, OCR_Task_ID__c, OCR_Status__c,Amazon_File_Link__c,Upload_date__c FROM BFM_POD__c WHERE OCR_Status__c != 'SubmissionFailed' AND
                                        OCR_Status__c != 'ProcessingFailed' AND
                                        OCR_Status__c != 'Completed' LIMIT :maxRecords];
        List<BFM_NFS__c> nfss = [SELECt Id, OCR_Task_ID__c,Carrier__r.City__c, OCR_Status__c, External_File_Path__c FROM BFM_NFS__c WHERE OCR_Status__c != 'SubmissionFailed' AND
                                        OCR_Status__c != 'ProcessingFailed' AND
                                        OCR_Status__c != 'Completed' limit :maxRecords];
        
        List<BFM_OCR_Template__c> tID = [select id from BFM_OCR_Template__c where Name='POD template' Limit 1];
            
        Map<String, Id> nfsTMap = new Map<String, Id>(); 
        for(BFM_OCR_Template__c objCS : [select id,City__c from BFM_OCR_Template__c where City__c != null Limit 100])
                nfsTMap.put(objCS.City__c, objCS.Id);    
                    
            
        
        
        for(BFM_POD__c pod: pods){
            BFM_OCRReadStatusResponse.ResponseItem responseItem = new BFM_OCRReadStatusResponse.ResponseItem();
            responseItem.recordType = 'pod';
            responseItem.salesforceId = pod.Id;                                
            responseItem.taskId = pod.OCR_Task_ID__c;
            responseItem.ocrStatus = pod.OCR_Status__c;
            responseItem.templateId = tID[0].id;
            responseItem.fileStoreId = pod.Amazon_File_Link__c;
            responseItem.uploadDate = pod.Upload_date__c;
            response.responseItems.add(responseItem);
        } 
        for(BFM_NFS__c nfs: nfss){
            BFM_OCRReadStatusResponse.ResponseItem responseItem = new BFM_OCRReadStatusResponse.ResponseItem();
            responseItem.recordType = 'nfs';
            responseItem.salesforceId = nfs.Id;                                
            responseItem.taskId = nfs.OCR_Task_ID__c;
            responseItem.ocrStatus = nfs.OCR_Status__c;
            responseItem.templateId = nfsTMap.get(nfs.Carrier__r.City__c);
            responseItem.fileStoreId = nfs.External_File_Path__c;
            responseItem.uploadDate = System.now();
            response.responseItems.add(responseItem);
        } 
        response.responseItems.sort();
        
        List<BFM_OCRReadStatusResponse.responseItem> returnList = new List<BFM_OCRReadStatusResponse.responseItem>();
        Integer sizeLimit;
        if(maxRecords > response.responseItems.size()){
            sizeLimit = response.responseItems.size();
        } else{
            sizeLimit = maxRecords;
        }
        for(integer i =0; i< sizeLimit; i++){
            returnList.add(response.responseItems[i]);
            
        }
        response.responseItems = returnList;    
        return response;
    }
}