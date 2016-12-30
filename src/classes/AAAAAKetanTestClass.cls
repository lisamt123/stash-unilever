public class AAAAAKetanTestClass{
String txId ='';
String content = '';


public static void readLOExtChartValues(String txId, String content){

List<KpiValueDescriptor> result = new List<KpiValueDescriptor>();
Map <String, Object> deserializedBoPromotionMap = (Map <String, Object> ) JSON.deserializeUntyped(content);

Map <String, Object> boPromotion = (Map <String, Object>) deserializedBoPromotionMap.get('BOPromotion');
Id promotionId = (Id)boPromotion.get('Id');

        
        Map<String,Object> postParameters = new Map<String,Object>();
        postParameters.put('promotionid', promotionId);
        postParameters.put('measurecodes', new List<String>{'IEVL','PTPC','LETP','LROI','PROI'});

        HttpRequest req = new HttpRequest();
        String body = JSON.serialize(postParameters);

        req.setEndpoint('callout:' + 'ACSF_Service_Url/ACSF/GetPromotionKPIs');
        req.setTimeout(120000);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        req.setHeader('txId', txid);
        req.setBody(body);
        req.setCompressed(true);
        
        Integer jwtValidPeriod= 30;//Integer.valueOf(SystemSettingUtil.getSystemSetting(Constants.SYSTEM_SETTING_JWT_EXPIRATION_TIME, txId, Constants.DEFAULT_JWT_EXPIRATION_TIME));
        
        req = JWT.addJwtTokenToHttpHeader(req,'/ACSF/GetPromotionKPIs', jwtValidPeriod  ); 
        HttpResponse res;
        try {
            Http http = new Http();
            res = http.send(req);
            system.debug('>>>>>>>>>>>>>>Req='+req);
            String responseResult = res.getBody();
            system.debug('>>>>>>>>>>>>>>.responseResult: ' + responseResult);
            
            List<Object> result2 = (List<Object>)JSON.deserializeUntyped(responseResult);
            For(Object o : result2) {
                Map<String,Object> temp = (Map<String,Object>) o;
                KpiValueDescriptor kpi = new KpiValueDescriptor((Id)temp.get('id'), String.valueOf(temp.get('kpiId')), String.valueOf(temp.get('level')), Double.valueOf(temp.get('value')));
                result.add(kpi);
                system.debug('kpiDescriptor: ' + kpi);
            }
        } catch(System.CalloutException e) {
            System.debug('Callout Error: ' + e);
            System.debug(res.toString());
        }
}
}