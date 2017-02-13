global class WWP_Losstree_EXt {
public boolean showingPanel{get;set;}
public string code1{get;set;}
public decimal plantCode{get;set;}
String valueNone = 'None';
String valueNull = '';
    public WWP_Losstree_EXt(WWP_LossTree_CC controller) {    
   }
   public void showPanelsDiv1(){
    code1= Apexpages.currentPage().getParameters().get('firstParams1');
    
    if(code1 != valueNull && code1 != valueNone){
    Map<string,WWP_Master_Table__c> masterTableValues= WWP_Master_Table__c.getAll();
    if(masterTableValues.containsKey(code1)){
    if(masterTableValues.get(code1).OR_Tolerance__c != null)
    plantCode= masterTableValues.get(code1).OR_Tolerance__c;
    showingPanel = true;}}
    else{
    showingPanel = false;}
    system.debug(showingPanel);
    }
    public PageReference  refreshFullPage(){
    system.debug('dgdgd');
    PageReference pageRef =page.WWP_LossTreeUpdate_VF;
       pageRef.setRedirect(false);
      return pageRef;
    
   }
}