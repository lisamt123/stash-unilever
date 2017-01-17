public class SAFE_SolutionArchivedTabBPSec_CC 
{
    integer totalRecs = 0;
    integer count= 0;    
    integer limitSize= 5;
    public string userid {get; set;}
    
    // To load data into the table
    public SAFE_SolutionArchivedTabBPSec_CC(ApexPages.StandardController controller)
    {
        totalRecs = [select count() from SAFE_Solutions__c ];
        userid = Userinfo.getUserId();       
        
    } 
    
    public List<SAFE_Solutions__c> getsolutionList()
    {
        List<SAFE_Solutions__c> solutionList = [SELECT Name,SAFE_Solution_Status__c,SAFE_Solution_Type__c,
                                                SAFE_Solution_in_Use__c,SAFE_Solution_Category__c,SAFE_Price_Per_Unit__c,SAFE_Material_Type__c
                                                FROM SAFE_Solutions__c WHERE SAFE_Solution_Status__c = 'Archived'];         
        return solutionList;
    }
    
    /*Risk Assessments List as pagination implementation*/
    public PageReference Firstbtn() 
    {
        count=0;
        return null;
    }
    
    /*Risk Assessments List as pagination implementation*/
    public PageReference prvbtn() 
    {
        count=count-limitsize;
        return null;
    }
    
    /*Risk Assessments List as pagination implementation*/
    public PageReference Nxtbtn() 
    {
        system.debug(count);
        count=count+limitsize;system.debug('limitsize'+limitsize);
        return null;
    }
    
    /*Risk Assessments List as pagination implementation*/
    public PageReference lstbtn() 
    {
        count= totalrecs - math.mod(totalRecs,LimitSize);
        return null;
    }
    
    /*Risk Assessments List as pagination implementation*/
    public Boolean getNxt() 
    {
        if((count+ LimitSize) > totalRecs)
            return true;
        else
            return false;
    }
    
    /*Risk Assessments List as pagination implementation*/
    public Boolean getPrv() 
    {
        if(count== 0)
            return true;
        else
            return false;
    }          
    
}