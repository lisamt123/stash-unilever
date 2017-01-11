public with sharing class PQNLossTreeData {
public boolean show{get;set;}


    list<PQN_Pallet_Loss_Tree__c>  lossdataa{get;set;}
    public PQNLossTreeData(ApexPages.StandardSetController controller) {
    show = false;

    }
    public void showpanel(){
    
    show = true;
    }
  

}