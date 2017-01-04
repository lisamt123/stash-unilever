global class BFM_AmazonConnector {
    
    public string sendFile(attachment attach,string cnpj,string filename,string objname){
               
        String attachmentBody = EncodingUtil.base64Encode(attach.Body);
        String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        String key = 'AKIAIBQE7P7QBIFKGQMQ';
        String secret = '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';
        String bucketname = 'adefr-d-freightbrazil001-bucket';
        String host = 's3.eu-central-1.amazonaws.com';
        String method = 'PUT';
        filename = attach.Name;   
        Integer currentYear = System.Today().year();  
        system.debug('File name is'+filename);
        string endpoint1='';
        if(objname=='DebitNote'){
            endpoint1 = 'https://' + bucketname + '.' + host + '/' + currentYear+'/'+'DebitNote'+'/'+filename;
        }
        if(objname=='PODReceipt'){
            endpoint1 = 'https://' + bucketname + '.' + host + '/' + currentYear+'/'+'PodReceipt'+'/'+filename;
        }
        if(objname=='gnre'){
            endpoint1 = 'https://' + bucketname + '.' + host + '/' + currentYear+'/'+'GNRE'+'/'+cnpj+'/'+filename;
        }
        system.debug('2222222222'+endpoint1);
        Url endpoint = new Url(endpoint1);
        system.debug('2222222222'+endpoint);
        
        Map<String,String> headers = new Map<String,String>();
        boolean presign=null;
        system.debug('method'+method);
        system.debug('endpoint'+endpoint);
        system.debug('headers'+headers);
        system.debug('attach.body'+attach.body);
        system.debug('presign'+presign);
        HttpRequest req = new HttpRequest();
        BFM_FileConnector c = new BFM_FileConnector(key,secret);        
        req = c.signedRequest(method,endpoint,headers,attach.body,presign);
        system.debug('ssssssssssssss'+req);
        
        Http http = new Http();
        try{
            HTTPResponse res = http.send(req);
            System.debug('*Resp:' + String.ValueOF(res.getBody()));
            System.debug('RESPONSE STRING: ' + res.toString());
            System.debug('RESPONSE STATUS: ' + res.getStatus());
            System.debug('STATUS_CODE: ' + res.getStatusCode());
            if(res.getStatusCode()==200 || res.getStatus()=='OK'){
                return endpoint1;
            }
            else{
                return '';
            }
        } catch(Exception ex){
            System.debug('There was an error: ' + ex.getMessage());
            System.debug(ex.getStackTraceString());
            return '';
        }
    }
    
    
    webservice static String getFile(string amazonlink){
        
        String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        String key = 'AKIAIBQE7P7QBIFKGQMQ';
        String secret = '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';
        String bucketname = 'adefr-d-freightbrazil001-bucket';
        String host = 's3.eu-central-1.amazonaws.com';
        String method = 'GET';          
        string endpoint1=amazonlink;
        Url endpoint = new Url(endpoint1);
        Blob b = blob.valueof('');
        Map<String,String> headers = new Map<String,String>();
        boolean presign;
        
        HttpRequest req = new HttpRequest();
        BFM_FileConnector c = new BFM_FileConnector(key,secret);        
        req = c.signedRequest(method,endpoint,headers,b,presign);
        system.debug('ssssssssssssss'+req);
        
        Http http = new Http();
        try{
            HTTPResponse res = http.send(req);
            System.debug('*Resp:' + String.ValueOF(res.getBody()));
            System.debug('RESPONSE STRING: ' + res.toString());
            System.debug('RESPONSE STATUS: ' + res.getStatus());
            System.debug('STATUS_CODE: ' + res.getStatusCode());
            if(res.getStatusCode()==200 || res.getStatus()=='OK'){
               return res.getBody();
             //   Blob contentData = res.getBodyAsBlob();
               // return 'data:application/pdf;base64,' + EncodingUtil.base64Encode(contentData);  
            }
            else{
                return '';
            }
        } catch(Exception ex){
            System.debug('There was an error: ' + ex.getMessage());
            System.debug(ex.getStackTraceString());
           return '';
        }
    }
    
    webservice static String getPDFFile(string amazonlink){
        
        String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        String key = 'AKIAIBQE7P7QBIFKGQMQ';
        String secret = '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';
        String bucketname = 'adefr-d-freightbrazil001-bucket';
        String host = 's3.eu-central-1.amazonaws.com';
        String method = 'GET';          
        string endpoint1=amazonlink;
        Url endpoint = new Url(endpoint1);
        Blob b = blob.valueof('');
        Map<String,String> headers = new Map<String,String>();
        boolean presign;
        
        HttpRequest req = new HttpRequest();
        BFM_FileConnector c = new BFM_FileConnector(key,secret);        
        req = c.signedRequest(method,endpoint,headers,b,presign);
        system.debug('ssssssssssssss'+req);
        
        Http http = new Http();
        try{
            HTTPResponse res = http.send(req);
            System.debug('*Resp:' + String.ValueOF(res.getBody()));
            System.debug('RESPONSE STRING: ' + res.toString());
            System.debug('RESPONSE STATUS: ' + res.getStatus());
            System.debug('STATUS_CODE: ' + res.getStatusCode());
            if(res.getStatusCode()==200 || res.getStatus()=='OK'){
             //  return res.getBody();
                Blob contentData = res.getBodyAsBlob();
                return 'data:application/pdf;base64,' + EncodingUtil.base64Encode(contentData);  
            }
            else{
                return '';
            }
        } catch(Exception ex){
            System.debug('There was an error: ' + ex.getMessage());
            System.debug(ex.getStackTraceString());
           return '';
        }
    }
 
}