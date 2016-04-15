public with sharing class Oblix_Ctrl11AuditTracking_Cmp {
	public String sObjParentId {get;set;}
	public String sObjApiName {get;set;}
	
	public Oblix_Ctrl11AuditTracking_Cmp(){
	}
	 /**
    * Run the main query for 
    * @param Sales_Id [Sales_Id]
    */

    public List<Marketing_SOW__History> getSowHistory() {
       sObjParentId = esc(sObjParentId);
       sObjApiName = esc(sObjApiName);
       sObjApiName = sObjApiName.replace('__c','__History');
       system.debug('###sObjParentId : '+sObjParentId);
       return Database.query('Select ParentId, OldValue, NewValue, IsDeleted, Id, Field, CreatedDate, CreatedById, CreatedBy.Name, Parent.Name From '+ sObjApiName +' WHERE ParentId =:sObjParentId');
       
    }
    
     /**
     * Guard against SOQL injection
     */
    private String esc(String s) {
        return s != null ? String.escapeSingleQuotes(s) : null;
    }
}