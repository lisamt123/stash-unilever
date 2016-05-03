public with sharing class uw_TokenHelper {
    
    private final static Boolean noEncryption = false;
    
    public String taCId {get; set;}
    private String prkey {get; set;}
    
    public uw_TokenHelper() {
    	
    }

    public uw_TokenHelper(Blob seed) {
        blobKey = seed;
    }
    
    private Blob blobKey {get {
        if (blobKey == null) {
            try {
            	system.debug('blobKey: getter');
                if (!Test.isRunningTest()) {
                    uw_Custom_Setting__c cs = uw_CustomSettingsManager.getCustomSetting('TOKEN_KEY');
                    blobKey = Encodingutil.base64Decode(cs.Text_Value__c);                  
                } else {
                	uw_Custom_Setting__c cs = new uw_Custom_Setting__c();
                	cs.Text_Value__c = 'GTq2xh0iIt45Pw8Ij8os+rOJNANxAWjJYRtyfhgnUAQ=';                	
                    blobKey = Encodingutil.base64Decode(cs.Text_Value__c);                  
                }
            } catch (Exception e) {
                system.debug('Exception getting Custom Setting TOKEN_KEY: '+e);
            }
        }
        return blobKey;
    } set;}
    
    private String getToken() {
    	// TODO concatenate all the values, currently we only have Tac Id
    	return taCId;
    }

    private void putToken(String token) {
    	// TODO explode token into parts, currently we only have TaC Id
    	taCId = token;
    }

    private void resetToken() {
    	taCId = null;
    }
    
    public String encode() {
        String encoded = null;

        try {
            String plainString = getToken();
            system.debug('plainString: '+plainString);
            Blob encryptedData;
            if (!noEncryption) {
                encryptedData = Crypto.encryptWithManagedIV('AES256', blobKey, Blob.valueOf(plainString));
                system.debug('encrypted: '+encryptedData);            	
            } else {
                encryptedData = Blob.valueOf(plainString);        	
            }
            encoded = EncodingUtil.base64Encode(encryptedData);
            system.debug('encoded: '+encoded);
        } catch (Exception e) {
        	system.debug('encode: exception: '+e);
        }
        return encoded;
    }
    
    public Boolean decode(String encryptedString) {
        Boolean ok = false;

        resetToken();        
        try {
            system.debug('encryptedString: '+encryptedString);
        	Blob decoded = EncodingUtil.base64Decode(encryptedString);
            String decrypted;
            system.debug('decoded: '+decoded);          
            if (!noEncryption) {
                Blob decryptedData = Crypto.decryptWithManagedIV('AES256', blobKey, decoded);
                decrypted = decryptedData.toString();
            } else {
            	decrypted = decoded.toString();
            }
            system.debug('decrypted: '+decrypted);                  
            putToken(decrypted);
            ok = true;        	
        } catch (Exception e) {
            system.debug('decode: exception: '+e);        	
        }
        return ok;
    }
    
    public String makeTokenForURL(String encoded) {
    	system.debug('makeTokenForURL: encoded');
    	String encodedForURL = Encodingutil.urlEncode(encoded, 'UTF-8'); 
    	system.debug('encodedForURL: '+encodedForURL);
    	return encodedForURL;
    }
    
    public Boolean validate(String token) {
        system.debug('validate: '+token);
    	Boolean ok = false;
    	
    	if (!uw_HelperMethods.valueIsNull(token)) {
    		ok = decode(token);
    	}
    	
    	return ok;
    }
    
    private static testmethod void testBasic() {
        uw_Terms_Conditions__c tc = new uw_Terms_Conditions__c();
        insert tc;
        system.assert(tc.Id != null);
        system.debug('String to encode: '+tc.Id);
        
        //Blob cryptoKey = Crypto.generateAesKey(256);
        Blob cryptoKey = Encodingutil.base64Decode('GTq2xh0iIt45Pw8Ij8os+rOJNANxAWjJYRtyfhgnUAQ=');

        uw_TokenHelper th = new uw_TokenHelper(cryptoKey);
        //uw_TokenHelper th = new uw_TokenHelper('GTq2xh0iIt45Pw8Ij8os+rOJNANxAWjJYRtyfhgnUAQ=');
    	                                        //GTq2xh0iIt45Pw8Ij8os+rOJNANxAWjJYRtyfhgnUAQ=
    	system.assert(th != null);
    	
    	th.taCId = tc.Id;
    	system.assertEquals(tc.Id, th.taCId);
    	
    	String encoded = th.encode();
    	system.assert(encoded != null);
    	
    	th.makeTokenForURL(encoded);
    	
    	th.decode(encoded);
    	system.assert(th.taCId != null);
    	system.assertEquals(tc.Id, th.taCId);
    }
}