String adminUserId = '005E0000002cAtm'; //SFDC2 Admin2
List<CollaborationGroup> cGrps = new List<CollaborationGroup>();
Map <String, Id> cgMap = new Map <String, Id>();

for(CollaborationGroup cg : [select Id, Name from CollaborationGroup where name='All Four Acres' or name like 'groupName-%']) {
    cgMap.put(cg.Name, cg.Id);
}

if(!cgMap.keySet().contains('All Four Acres')) {
    cgrps.add(new CollaborationGroup(Name='All Four Acres', CollaborationType='Public',OwnerId = adminUserId));
}
for(Integer i=0;i<7;i++) {
    if(!cgMap.keySet().contains('groupName-'+i)) {
        cgrps.add(new CollaborationGroup(Name='groupName-'+i, CollaborationType='Public',OwnerId = adminUserId));
    }
}
if(!cgrps.isEmpty()) {
    insert cgrps;
}
cgMap.clear();
for(CollaborationGroup cg : [select Id, Name from CollaborationGroup where name='All Four Acres' or name like 'groupName-%']) {
    cgMap.put(cg.Name, cg.Id);
}

List <FA_Config_Settings__c> fcs = [select id, name, FA_Value__c from FA_Config_Settings__c];
for(FA_Config_Settings__c f : fcs) {
    if(f.name=='FA_AllFourAcres') {
        f.FA_Value__c=((String)(cgMap.get('All Four Acres'))).left(15);
    } else if (f.name=='FA_HelpGroup') {
        f.FA_Value__c=((String)(cgMap.get('groupName-1'))).left(15);
    } else if (f.name=='FA_EnhanceLivelihoods') {
        f.FA_Value__c=((String)(cgMap.get('groupName-2'))).left(15);
    } else if (f.name=='FA_ImprovingHealth') {
        f.FA_Value__c=((String)(cgMap.get('groupName-3'))).left(15);
    } else if (f.name=='FA_ReduceEnvImpacts') {
        f.FA_Value__c=((String)(cgMap.get('groupName-4'))).left(15);
    } else if (f.name=='FA_UL2020GroupId') {
        f.FA_Value__c=((String)(cgMap.get('groupName-5'))).left(15);
    } else if (f.name=='FA_UL2020Programme') {
        f.FA_Value__c=((String)(cgMap.get('groupName-6'))).left(15);
    }
}

update fcs;
if([select count() from Pinnovate_Preference__c where name='DEFAULT']==0) {
    insert new Pinnovate_Preference__c(name='DEFAULT');
}
if([select count() from AF_Currency__c where AF_Currency_Code__c='USD' and AF_Fiscal_Year_new__c=:string.valueof(System.now().year())]==0) {
    insert new AF_Currency__c( Locked__c=false, AF_Currency_Code__c='USD', AF_Fiscal_Year_new__c=string.valueof(System.now().year()));
}

// Dupeblocker setup for CEC
delete [select id from CRMfusionDBR101__Scenario__c where name='test'];
CRMfusionDBR101__Scenario__c s = new CRMfusionDBR101__Scenario__c();
s.Name='test';
s.CRMfusionDBR101__Match_on_Insert_Action__c = 'Do Nothing';
s.CRMfusionDBR101__Match_on_Update_Action__c = 'Do Nothing';
s.CRMfusionDBR101__Scenario_Type__c = 'Account';
s.CRMfusionDBR101__Person_Account_Scenario__c = true; 
s.CRMfusionDBR101__Rebuild_Needed__c = true; 
s.CRMfusionDBR101__Deployed__c = true;
insert s;
CRMfusionDBR101__Scenario_Rule__c sr = new CRMfusionDBR101__Scenario_Rule__c ();
sr.CRMfusionDBR101__Scenario__c=s.Id;
sr.CRMfusionDBR101__Scenario_Type__c = 'Account';
sr.CRMfusionDBR101__Field_Name__c='personmailingpostalcode';
sr.CRMfusionDBR101__Mapping_Type__c='Exact';
insert sr;