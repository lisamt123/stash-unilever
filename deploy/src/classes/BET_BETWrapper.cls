/*************************************************************************************
Name : BET_BETWrapper

Purpose : Class containing all BET information required  by IPM. It will be used in all communication with 

external systems when a  notification of a change to BET data is needed.

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      k.szepietowski@polsource.com  20-07-2015  Initial
1.1      piotr.czechumski              10-06-2015  Add Group category, category, brand position, brand
*************************************************************************************/

public with sharing class BET_BETWrapper {
    
    //Id of Bet
    public Id betId{get;set;}
    //Name of Bet
    public String betName{get;set;}
    //Bet Status
    public String status{get;set;}
    //Date of First release
    public Date firstReleaseDate{get;set;}
    //Due date of first release
    public Date firstReleaseDueDate{get;set;}
    //Date of final release
    public Date finalReleaseDate{get;set;}
    //Due date of final release
    public Date finalReleaseDueDate{get;set;}
    //Value indicating if BET is archived
    public Boolean isArchived{get;set;}
    //Id of BET owner user
    public Id betOwner{get;set;}
    //Id of BET group category lookup (ProductCategory)
    public Id groupCategory{get;set;}
    //Id of BET category lookup (ProductCategory)
    public Id category{get;set;}
    //Id of BET owner user
    public Id brandPosition{get;set;}
    //Id of BET owner user
    public Id brand{get;set;}
    //Date of launch
    public Datetime targetLaunchDate{get;set;}
    
    
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
    
    /************************************************************
        Purpose: BET_BETWrapper constructor
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    public BET_BETWrapper(uw_BET__c bet){
        system.debug('Entring BET_BETWrapper constructor with param @bet:'+bet);
        betToWrapper(bet);       
        system.debug('Exiting BET_BETWrapper constructor');
    }
    
    /************************************************************
        Purpose: BET_BETWrapper constructor
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    public BET_BETWrapper(){}

    /************************************************************
        Purpose: BET_BETWrapper constructor
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    public BET_BETWrapper(uw_BETWrapper.BetSearchItem bsi){
        system.debug('Entring BET_BETWrapper constructor with param '+ bsi);
        betSearchItemToBetWrapper(bsi);         
        system.debug('Exiting BET_BETWrapper constructor');
    }

    /************************************************************
        Purpose: betToWrapper converts bet record to wrapper
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    private void betToWrapper(uw_BET__c tmpBet){
        system.debug('Entring betToWrapper with params'+ tmpBet);
        
        this.BetId                  = tmpBet.id;
        this.BetName                = tmpBet.Name;
        this.Status                 = tmpBet.Status__c;
        this.FirstReleaseDate       = tmpBet.FirstReleaseDate__c;
        this.FirstReleaseDueDate    = tmpBet.First_Release_Due_Date__c;
        this.FinalReleaseDate       = tmpBet.FinalReleaseDate__c;
        this.FinalReleaseDueDate    = tmpBet.Final_Release_Due_Date__c;
        this.isArchived             = tmpBet.Is_Archived__c;
        this.BetOwner               = tmpBet.OwnerId;

        this.groupCategory          = tmpBet.Category_Group__c;
        this.category               = tmpBet.Product_Category__c;
        this.brandPosition          = tmpBet.Brand_Position__c;
        this.brand                  = tmpBet.Product_Brand__c;
        this.targetLaunchDate       = tmpBet.Launch_Date__c;

        system.debug('Exiting betToWrapper');
    }

    /************************************************************
        Purpose: betSearchItemToBetWrapper converts bet serach item to this wrapper
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    private void betSearchItemToBetWrapper(uw_BETWrapper.BetSearchItem bsi){
        system.debug('Entring betSearchItemToBetWrapper with params'+ bsi);
        
        this.BetId                  = bsi.betId;
        this.BetName                = bsi.betName;
        this.Status                 = bsi.betStatus;
        if (bsi.betFirstRelease != null){
            this.FirstReleaseDate       = bsi.betFirstRelease.date();
            //it's temporary implemnetation need to be change in next sprint
            this.FirstReleaseDueDate    = bsi.betFirstReleaseDueDate.date();    
        }
        if(bsi.betFinalRelease != null){
            this.FinalReleaseDate       = bsi.betFinalRelease.date();
            //it's temporary implemnetation need to be change in next sprint
            this.FinalReleaseDueDate    = bsi.betFinalReleaseDueDate.date();
        }
        // it's temporart implemenations need to be change with new atchive functions
        this.isArchived             = bsi.archived;
        this.BetOwner               = bsi.betOwnerId;


        this.groupCategory          = bsi.groupCategory;
        this.category               = bsi.category;
        this.brandPosition          = bsi.brandPosition;
        this.brand                  = bsi.brand;
        this.targetLaunchDate       = bsi.betLaunchDate;

        system.debug('Exiting betSearchItemToBetWrapper');
    }


}