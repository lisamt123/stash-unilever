public class BFM_ShipmentUpdate_CC {
    Account acc;
    public BFM_ShipmentUpdate_CC(ApexPages.StandardController stdCtr){
        acc = [Select Id FROM Account LIMIT 1];
        
    }
    
    public void updateAcc(){
        update acc;
    }
}