public class PQN_CheckDelete
{
   private ApexPages.standardcontroller stdCtrl;

   public PQN_CheckDelete(ApexPages.Standardcontroller std)
   {
      stdCtrl=std;
   }

   public PageReference checkDelete()
   {
       Boolean delpqn = true;
      PQN_Pallet_Quality_Non_Conformance__c pqn =(PQN_Pallet_Quality_Non_Conformance__c) stdctrl.getRecord();
      
      PQN_Pallet_Quality_Non_Conformance__c pqn1 = [select id,DC_Country__c from PQN_Pallet_Quality_Non_Conformance__c where id=:pqn.id];
      if(userinfo.getusertype() == 'Standard'){
      
            List<PermissionSetAssignment> PermissionSetAssigs = new List<PermissionSetAssignment>();
            PermissionSetAssigs = [select id,PermissionSet.name,Assignee.country from PermissionSetAssignment where AssigneeId =: userinfo.getuserid()];
            for(PermissionSetAssignment psa: PermissionSetAssigs){
                if(psa.PermissionSet.name == 'PQN_Internal_User' && psa.Assignee.country != pqn1.DC_Country__c){
                    system.debug('wwwwwwwwww'+psa.Assignee.country);
                    delpqn = false;
                }
            }
        }
      
      if (delpqn)
      {
          //return stdCtrl.delete();
          PageReference ref = stdCtrl.delete();
          ref.getParameters().put('nooverride','1'); // Any value will do
          return ref;
      }
      else
      {
         return null;
      }
   }
}