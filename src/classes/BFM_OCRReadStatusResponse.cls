global class BFM_OCRReadStatusResponse  {
    global class ResponseItem implements Comparable{
        global String recordType;
        global String salesforceId;
        global String taskId;
        global String ocrStatus;
        global String templateId;
        global String fileStoreId;
        global Datetime uploadDate;
        
        public Integer compareTo(Object otherObj){
            BFM_OCRReadStatusResponse.ResponseItem other = (BFM_OCRReadStatusResponse.ResponseItem) otherObj;
            if(this.uploadDate == other.UploadDate || this.uploadDate == null || other.uploadDate == null){
                return 0;
            }
            if(this.uploadDate > other.UploadDate){
                return 1;
            } else{
                return -1;
            }
        }
    }
    
    global List<BFM_OCRReadStatusResponse.ResponseItem> responseItems;
}