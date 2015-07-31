/*************************************************************************************
Name : BET_BETService

Purpose : Service for BET

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      k.szepietowski@polsource.com  30-07-2015  Initial
*************************************************************************************/

public with sharing class BET_BETService {
    
    
    private BET_BETService(){}
    
    /************************************************************
        Purpose: Search for BET by provided string
        Parameters: -
        Returns: 
        Throws: -[BET_CustomBETException]
    *************************************************************/
    public static BET_BETWrapper SearchBet(String searchText){
        system.debug('Entring method SearchBet with param @searchText: '+searchText);
        BET_BETWrapper betWrapper = new BET_BETWrapper();
        system.debug('Exiting method SearchBet following wrapper will be returned:'+betWrapper);
        return null;
    }
    
     /************************************************************
        Purpose: Update BET with IPM information
        Parameters: -BetId,IPMProject
        Returns: 
        Throws: -[BET_CustomBETException]
    *************************************************************/
    public static void UpdateBet(Id BetId,IPM_BETWrapper IPMProject){
        system.debug('Entring method Update with param @BetId: '+BetId+' @IPMProject: '+IPMProject);
        BET_BETWrapper betWrapper = new BET_BETWrapper();
        system.debug('Exiting method SearchBet following wrapper will be returned:'+betWrapper);
        
    }
    
    /************************************************************
        Purpose: Returns first release due date based on provided TLD (Target Launch Date)
        Parameters: -BetId,IPMProject
        Returns: 
        Throws: -[BET_CustomBETException]
    *************************************************************/
    public static Date GetFirstReleaseDueDate(Date targetLaunchDate){
        system.debug('Entring method GetFirstReleaseDueDate with param @targetLaunchDate: '+targetLaunchDate);
        
        system.debug('Exiting method GetFirstReleaseDueDate following date was returned:');
        return null;
    }
    
    
    /************************************************************
        Purpose: Returns final release due date based on provided TLD (Target Launch Date)
        Parameters: -BetId,IPMProject
        Returns: 
        Throws: -[BET_CustomBETException]
    *************************************************************/
    public static Date GetFinalReleaseDueDate(Date targetLaunchDate){
        system.debug('Entring method GetFinalReleaseDueDate with param @targetLaunchDate: '+targetLaunchDate);
        
        system.debug('Exiting method GetFinalReleaseDueDate following date was returned:');
        return null;
    }
    
    /************************************************************
        Purpose: Return data for given BET (BET_BETWrapper)
        Parameters: -betId
        Returns: 
        Throws: -[BET_CustomBETException]
    *************************************************************/
    public static BET_BETWrapper GetBet(Id betId){
        system.debug('Entring BET_BETService.GetBet with param @betd:'+betId);
        BET_BETWrapper betWrapper = new BET_BETWrapper();
        
        List<uw_BET__c> betLst = [Select Id,Name,Status__c,First_release_date__c,Final_release_date__c,Is_Archived__c,OwnerID FROM uw_BET__c WHERE Id =: betId];
        
        if(!betLst.isEmpty()){
            uw_BET__c tmpBet = betLst.get(0);
            betWrapper.BetId = tmpBet.id;
            betWrapper.BetName = tmpBet.Name;
            betWrapper.Status = tmpBet.Status__c;
            betWrapper.FirstReleaseDate = tmpBet.First_release_date__c;
            //it's temporary implemnetation need to be change in next sprint
            betWrapper.FirstReleaseDueDate = tmpBet.First_release_date__c;
            betWrapper.FinalReleaseDate = tmpBet.Final_release_date__c;
            //it's temporary implemnetation need to be change in next sprint
            betWrapper.FinalReleaseDueDate = tmpBet.Final_release_date__c;
            betWrapper.isArchived = tmpBet.Is_Archived__c;
            betWrapper.BetOwner = tmpBet.OwnerId;

        }else{
            //bet was not found throw an error
            throw new BET_CustomBETException(String.format(Label.BetServiceGetBetError,new List<String>{betId}));
        }
        
        system.debug('Exiting BET_BETService.GetBet returned folowing BET_BETWrapper: '+ betWrapper);
        
        return betWrapper;
    }
}