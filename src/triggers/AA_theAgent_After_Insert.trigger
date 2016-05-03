trigger AA_theAgent_After_Insert on aa_Agent_Report__c  (after insert) {

    // We only execute the trigger after a Contribution record has been inserted
    // because we need the Id of the Contribution record to already exist.

    if(trigger.isInsert){

    // aa_Agent_Report__Share is the "Share" table that was created when the
    // Organization Wide Default sharing setting was set to "Private".
    // Allocate storage for a list of aa_Agent_Report__Share records.
    
    List<aa_Agent_Report__Share> contributionShares = new List<aa_Agent_Report__Share>();

    // For each of the Contribution records being inserted, do the following:
    for(aa_Agent_Report__c contribution : trigger.new){
    
        // Create a new aa_Agent_Report__Share record to be inserted in to the Contribution_Share table.
        aa_Agent_Report__Share creatorShare = new aa_Agent_Report__Share();
        
        // Populate the aa_Agent_Report__Share record with the ID of the record to be shared.
        creatorShare.ParentId = contribution.Id;
        
        // Set the ID of user being granted access. In this case,
        // we’re setting the Id of the CreatedBy user. This is because OWD
        // is Private and the record may change owner to be reviewed 
        creatorShare.UserOrGroupId = contribution.CreatedById;
        
        // Specify that the Creator should have edit access for
        // this particular Contribution record.
        creatorShare.AccessLevel = 'edit';
        
        // Specify that the reason the Creator can edit the record is
        // because they're the Creator of the record.
        // (Creator_Access__c is the Apex Sharing Reason.)
        creatorShare.RowCause = Schema.aa_Agent_Report__Share.RowCause.Creator_Access__c;

        // Add the new Share record to the list of new Share records.
        contributionShares.add(creatorShare);
    }
    // do the DML to create shares
    if (!contributionShares.isEmpty())
      insert contributionShares;

    // Need to add Error handling code here.
    }
}