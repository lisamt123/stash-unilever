/* -----------------------------------------------------------------------------------------------------------------------
   Name:        BC_ChatterGroupExistCheck.trigger 
   Description: 1) Trigger on the Brand Centre to see if the Chatter group which the user has input exists.
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   November 2013    1.0    Ray Creasey         Initial Release 
   November 2013    2.0    Vanessa Barros      Finishing trigger
  ------------------------------------------------------------------------------------------------------------------------ */
trigger BC_ChatterGroupExistCheck on Brand_Centre_New__c (before insert, before update) {
    Set<string> chatterGrpId = new Set<string>();
    
    //the set will store the chatter group id inserted by the user on the brand centre record
    for(Brand_Centre_New__c  b:trigger.new){
        chatterGrpId.add(b.chatter_group_id__c);
    }
    
    Map<string, collaborationGroup> mapGroups = new Map<string,collaborationGroup>();
    
    //the map will store all the chatter groups that are not archived
    List<collaborationGroup> lcg = [SELECT Id from CollaborationGroup where IsArchived = false ];
    
    for(collaborationGroup l_aux :lcg){
        // need this conversion because SF keep a id with 18 charaters on the BD and only show to the user 15 charaters
        string idd = string.valueOf(l_aux.id);
        string id = idd.left(15);
        mapGroups.put(id,l_aux);
    }
    
    //If the chatter group added in the brand centre record doesnt not exist on the chatter group map, SF will send an error to the Brand Centre page layout
    if(mapGroups.size()>0 && chatterGrpId.size()>0){
        for(string cg: chatterGrpId){
            if(!mapGroups.containsKey(cg)){
                Trigger.new[0].chatter_group_id__c.addError('This group does not exist or has been archived?');
            }
        }        
    
    }  

}