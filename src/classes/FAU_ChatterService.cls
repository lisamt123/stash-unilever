public Interface FAU_ChatterService
{

	/**
	 * creates a Chatter Group for a program
	 * @param program to create the group for
	 * @param ownderId the User who will own the chatter group
	 */
	//void createChatterGroups(List<FAU_Program__c> programs);  

	CollaborationGroup createChatterGroup(FAU_Program__c program, Id ownerId);


	//List<CollaborationGroupMember> addParticipantsToProgramChatterGroup(List<FAU_Participant__c> participants);


	void commitChatterGroups(List<CollaborationGroup> chatterGroups, List<FAU_Program__c> programs);

	void commitChatterMember(List<CollaborationGroupMember> lCollaborationGroupMembers);


}