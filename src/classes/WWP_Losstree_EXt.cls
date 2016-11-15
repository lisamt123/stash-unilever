global class WWP_Losstree_EXt {

public boolean showingPanel{get;set;}
public string code1{get;set;}
public decimal plantCode{get;set;}

   public WWP_Losstree_EXt(WWP_LossTree_CC controller) {    
   }
    
    
    public void showPanelsDiv1(){
    //string code= Apexpages.currentPage().getParameters().get('firstParams1');
    //code1 = code;
    code1= Apexpages.currentPage().getParameters().get('firstParams1');
    //system.debug(code);
    
    if(code1 != null){
    
    Map<string,WWP_Master_Table__c> masterTableValues= WWP_Master_Table__c.getAll();
    
    if(masterTableValues.get(code1).OR_Tolerance__c != null)
            
    plantCode= masterTableValues.get(code1).OR_Tolerance__c;
    
    showingPanel = true;}
    else{
    showingPanel = false;}
    //plantCode = 96;
    system.debug(showingPanel);
    
    }
}