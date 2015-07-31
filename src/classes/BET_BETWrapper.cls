/*************************************************************************************
Name : BET_BETWrapper

Purpose : Class containing all BET information required  by IPM. It will be used in all communication with 

external systems when a  notification of a change to BET data is needed.

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      k.szepietowski@polsource.com  20-07-2015  Initial
*************************************************************************************/

public with sharing class BET_BETWrapper {
    
    //Id of Bet
    public Id BetId{get;set;}
    //Name of Bet
    public String BetName{get;set;}
    //Bet Status
    public String Status{get;set;}
    //Date of First release
    public Date FirstReleaseDate{get;set;}
    //Due date of first release
    public Date FirstReleaseDueDate{get;set;}
    //Date of final release
    public Date FinalReleaseDate{get;set;}
    //Due date of final release
    public Date FinalReleaseDueDate{get;set;}
    //Value indicating if BET is archived
    public Boolean isArchived{get;set;}
    //Id of BET owner user
    public Id BetOwner{get;set;}
    
    
    /************************************************************
        Purpose: Class containing all information about user and access level for creation of member request.
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    public class MemberRequest{
        
        //Id of User
        public Id UserId{get;set;}
        public String AccessLevel{get;set;}
    } 


}