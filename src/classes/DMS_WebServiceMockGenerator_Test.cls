@isTest
global class DMS_WebServiceMockGenerator_Test implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {                
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');         
        res.setStatusCode(200);
        res.setStatus('OK');
       
        if(req.getEndpoint().contains('query')) 
        {
            res.setBody('{"action":"query","responseId":"447yh5timloEbrH5ThIOu-","results":{"records":[{"Account_Owner":"00519000001B28nAAC","DistributorCode":"DMS_ES_CHALTAMIRA"},{"Account_Owner":"00519000001B292AAC","DistributorCode":"DMS_ES_CHALTAMIRA"},{"Account_Owner":"00519000001B297AAC","DistributorCode":"DMS_ES_CHALTAMIRA"},{"Account_Owner":"00519000001B29WAAS","DistributorCode":"DMS_ES_CHALTAMIRA"},{"Account_Owner":"00519000001B29gAAC","DistributorCode":"DMS_ES_CHALTAMIRA"},{"Account_Owner":"00519000001B29lAAC","DistributorCode":"DMS_ES_CHALTAMIRA"},{"Account_Owner":"00519000001B29qAAC","DistributorCode":"DMS_ES_CHALTAMIRA"},{"Account_Owner":"00519000001B29vAAC","DistributorCode":"DMS_ES_CHALTAMIRA"},{"Account_Owner":"00519000001B2AAAA0","DistributorCode":"DMS_ES_CHALTAMIRA"},{"Account_Owner":"00519000001B2AUAA0","DistributorCode":"DMS_ES_CHALTAMIRA"},{"Account_Owner":"00519000001B0T5AAK","DistributorCode":"DMS_ES_EXITO"},{"Account_Owner":"00519000001B21rAAC","DistributorCode":"DMS_ES_EXITO"},{"Account_Owner":"00519000001B24gAAC","DistributorCode":"DMS_ES_EXITO"},{"Account_Owner":"00519000001B25PAAS","DistributorCode":"DMS_ES_EXITO"},{"Account_Owner":"00519000001B25eAAC","DistributorCode":"DMS_ES_EXITO"},{"Account_Owner":"00519000001B25tAAC","DistributorCode":"DMS_ES_EXITO"},{"Account_Owner":"00519000001B26cAAC","DistributorCode":"DMS_ES_EXITO"},{"Account_Owner":"00519000001B26hAAC","DistributorCode":"DMS_ES_EXITO"},{"Account_Owner":"00519000001B27kAAC","DistributorCode":"DMS_ES_EXITO"},{"Account_Owner":"00519000001B27uAAC","DistributorCode":"DMS_ES_EXITO"},{"Account_Owner":"00519000001B28OAAS","DistributorCode":"DMS_ES_EXITO"}]}}');
        }
        else 
        {
            res.setBody('{"createdBy":{"id":"005E00000076W3PIAU","name":"Integration User(Third Party)","profilePhotoUrl":"https://unilever--ACFRDMSLD--c.cs24.content.force.com/profilephoto/005/T"},"createdDate":"2016-05-26T19:03:48.000Z","currentVersionId":"0Fc190000009jyOCAQ","currentVersionUrl":"/services/data/v36.0/wave/datasets/0Fb19000000A42BCAS/versions/0Fc190000009jyOCAQ","folder":{"id":"00l19000000VgK8AAK","label":"Teste Security","name":"Teste_Security","url":"/services/data/v36.0/wave/folders/00l19000000VgK8AAK"},"id":"0Fb19000000A42BCAS","label":"ImpactedStoresNotSecurity","lastAccessedDate":"2016-05-26T21:57:20.000Z","lastModifiedBy":{"id":"005E0000007zzJjIAI","name":"Guilherme Baccas(ThirdParty)","profilePhotoUrl":"https://unilever--ACFRDMSLD--c.cs24.content.force.com/profilephoto/005/T"},"lastModifiedDate":"2016-05-26T19:32:15.000Z","name":"ImpactedStoresNotSecurity","permissions":{"modify":true,"view":true},"type":"dataset","url":"/services/data/v36.0/wave/datasets/0Fb19000000A42BCAS","versionsUrl":"/services/data/v36.0/wave/datasets/0Fb19000000A42BCAS/versions"}');
        }
        return res;
    }    
}