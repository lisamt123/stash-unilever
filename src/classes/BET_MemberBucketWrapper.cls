/*************************************************************************************
Name : BET_MemberBucketWrapper

Purpose : Wrapper class used by Suggest member component. Will enable information about how
	      suggested members will be grouped. Grouping is relevant only for UI and will not have any impact on 
		  how members will be created in BET.

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      k.szepietowski@polsource.com  20-07-2015  Initial
*************************************************************************************/

public class BET_MemberBucketWrapper {
	
    //Bucket name
    public String GroupName{get;set;}
    //List of ids of using belonging to group
    public List<Id> GroupUserIds{get;set;}
}