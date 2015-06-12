/* -----------------------------------------------------------------------------------------------------------------------
   Name:        uw_bet_update_totalnumberof_betmembers.cls 
   Description: 1) Class which handles the logic to update the total number of bet members( on brandexperience records
                   when someone joins/leaves the bet
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   December 2013     1.0        Teenu Pius           Initial Release for BET 2.0
  ------------------------------------------------------------------------------------------------------------------------ */

public class uw_bet_update_totalnumberof_betmembers 
{
  //Static variable to make sure method is called only once
    public static boolean firstRun_updatetotalnum = true;
    
    //Static variable to make sure account trigger is not called always
    public static boolean runAccount_trigger = false;
    
    //Static method to update total number of members in a Brand experience toolkit .Called from team member trigger.
    //Triggers an update on uw_bet__c  
    public static void updatetotalnumber(list<uw_BET_Team_Member__c>TriggerNewList,list<uw_BET_Team_Member__c>TriggeroldList)
      {   
        List<uw_BET_Team_Member__c> teammembers = new list<uw_BET_Team_Member__c>();
        Map<Id,uw_bet__c> betrecords = new map<id,uw_bet__c>();
        if(TriggerNewList!=null)
        teammembers.addAll(TriggerNewList);
        if(TriggeroldList!=null)
        teammembers.addAll(TriggeroldList);   
        
        for( uw_BET_Team_Member__c item:teammembers)
        {
        //Process only those team member who has a bet,userid associated and whose invitation is not pending and has access to BET toolkit
        if((item.Bet__C!=null) && (item.Team_Member__c!=null) && (item.Invite_Pending__c==false)&& (item.BETEnabled__c==true))  
        {      
            betrecords.put(item.bet__C,new uw_bet__c(id=item.bet__C));
        }
        }      
        //This initiates the trigger on bet object.
        update betrecords.values();
     
    }//end of method updatetotalnumber
    
   
     //Static method to initalise count of total members of bet to zero .called from bet object trigger  
        public static void initalisemembers(list<uw_BET__c>TriggerNewList)
          { 
            for(uw_bet__c a:TriggerNewList)
            a.Total_Number_of_Members__c = 0;       
        }//End of method initalise members
       
      //Static method called from account trigger to recalculate the size of child   
    public static void recalculateaccountchild(list<uw_BET__c>TriggerNewList,map<Id,uw_bet__C>TriggerNewmapbet)
      { 
            //Fetch the members who met the condition
            List<uw_BET__c> BETS = [select id,(select id from BET_Team_Members__r where ( Team_Member__c!=null and Invite_Pending__c=false and BETEnabled__c=true )) from uw_bet__c where id in :TriggerNewlist];
            for(uw_bet__c a:BETS)
             triggernewmapbet.get(a.id).Total_Number_of_Members__c = a.BET_Team_Members__r.size();
            
      }//End of method recalculateaccount child       
  }//End of class