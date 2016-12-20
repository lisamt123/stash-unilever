public with sharing class BFM_PurgeRecords_CC{
    public boolean showmsg{get; set;}
    public BFM_PurgeRecords_CC(){
        showmsg = false;
    }
    public void purge_rec(){
        Database.executebatch(new BFM_Purge_batchClass());
        showmsg = true;
    }
}