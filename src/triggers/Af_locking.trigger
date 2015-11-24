trigger Af_locking on AF_Brand_Estimate__c (before update) {
   set<id> userset = new set<id>();
   set<id> useridset = new set<id>();
   for(AF_Brand_Estimate__c a : trigger.new)
   {
       AF_Brand_Estimate__c ab = trigger.oldmap.get(a.id);
       if(ab.AF_Locked__c == true && a.AF_Locked__c == true  )
         useridset.add(userinfo.getuserid());
   }
  //map<id,PermissionSetAssignment> pmap = new map<id,PermissionSetAssignment>([SELECT AssigneeId,Id,PermissionSetId FROM PermissionSetAssignment where PermissionSet.name=:'AF_CMCO_Super_User' limit 10]);
   for(permissionsetassignment p : [SELECT AssigneeId,Id,PermissionSetId FROM PermissionSetAssignment where PermissionSet.name=:'AF_CMCO_Super_User' and assigneeid in: useridset])
   {
       if(p.assigneeid != null)
         userset.add(p.assigneeid);
     
   }
   for(AF_Brand_Estimate__c a : trigger.new)
   {
      system.debug(userset +'u====');
       AF_Brand_Estimate__c ab = trigger.oldmap.get(a.id);
       if(ab.AF_Locked__c == true && a.AF_Locked__c == true && !userset.contains(userinfo.getuserid()) )
          a.adderror('Record is locked, CMCO Super user can only edit this records');
   }
}