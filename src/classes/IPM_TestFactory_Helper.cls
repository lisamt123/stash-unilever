public without sharing class IPM_TestFactory_Helper {
    public static final String CHARTER_GATE_FULL = 'Charter Gate Full';
    public static final String IDEA_GRAPHIC= 'Idea / Graphic';
    public static final String IDEAS = 'Ideas';
    public static boolean FALSE_VAR = False;
    public static final String GCLT_RCLT = 'GCLT & RCLT';
    public static final String TEST_CONTENT =  'A quick brown fox jumped over a lazy dog';
    public static final String NEWVARIANTSIZE_STR = 'New Variant/ Size';
    public static final String COREPARAMETER_BLG = 'BLG';
    public static final String COREPARAMETER_GROWTHECORE ='Grow the Core';
    public static final String COREPARAMETER_NEWSCHANNEL = 'New Channels';
    public static final String COREPARAMETER_REGULATORY = 'Regulatory/ Compliance';
    public static final String COREPARAMETER_SUPPLYCHAIN ='Supply Chain';
    public static final String COREPARAMETER_TECHNOLOGYDEV = 'Technology Development';
    public static final String COREPARAMETER_VIP = 'VIP';
    public static final string QUESTIONTYPE_STR = 'Consumer';
    public static final string EMPTY_STRING = '';
    
    // IPM Project List Sample Data 
    public static List<IPM_Project__c> createOriginalProjectList(Boolean doInsert, Integer listSize){
        List<IPM_Project__c> testIPMProjList = new List<IPM_Project__c>();
        for(Integer i = 1; i <= listSize; i++){
            Map<String,Object> projMap =  new Map<String,Object>{'Name' => 'TestComments' + i,'IPM_Project_Name__c'=>'TestComments' + i,
                                        'IPM_Complexity__c' => 'Full', 'IPM_GateKeeping_Model__c' => GCLT_RCLT,
                                        'IPM_Target_Launch_Dates__c' => System.today().addMonths(6),'IPMProject_Span__c'=>'Global', 
                                        'IPM_Project_Leader__c' => UserInfo.getUserId(),'IPM_CompanyCardText__c' => 'Global Company Card',
                                        'IPM_Brand_Positioning__c' => 'Dirt is Good','IPM_Project_Type__c' => 'Original','IPM_BET_Toolkit__c' => 'Create new BET',
                                        'IPM_ProjectSubType__c' => 'Innovation/Renovation','IPM_Phase__c'=> IDEAS,
                                        'IPM_Category_Text__c' => 'Household Care','IPM_Child_Complexity__c' => 'Full'};
            IPM_Project__c projectRecord = (IPM_Project__c)IPM_TestFactory.createSObject('IPM_Project__c',projMap,TRUE);
            testIPMProjList.add(projectRecord);
        }
        if(doInsert) { 
            insert testIPMProjList;
        }
        return testIPMProjList;
    }
  
}