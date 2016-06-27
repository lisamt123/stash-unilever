Public class PBS_ReportGenerator_CC{
public List<PBS_Profile__c> userNames;
public String selectedValue{get;set;}
public List<Report> reports { set;get; } 
    public Pagereference generateCrsStatusReport(){
        Pagereference pageref;
        reports = [SELECT id,Name FROM Report where Name='PBS Course Status' limit 1]; 
        for(Report rep : reports){
        pageref = new Pagereference('/'+rep.id);
    }
        
        return pageref;
    }
    public Pagereference gnrtTPlanAsgmntsWithUserDtlsRprt(){
        Pagereference pageref;
        reports = [SELECT id,Name FROM Report where Name='PBS_TPlan Assignments With User Details' limit 1]; 
        for(Report rep : reports){
        pageref = new Pagereference('/'+rep.id);
    }
    return pageref;
    }
    public Pagereference generateCrsStatsByUserRprt(){
        Pagereference pageref;
        reports = [SELECT id,Name FROM Report where Name='PBS Course Status By UserName' limit 1]; 
        for(Report rep : reports){
        pageref = new Pagereference('/'+rep.id);
    }
    return pageref;
    }
    public Pagereference generateCrsStatsByUserinDetl(){
        Pagereference pageref;
        reports = [SELECT id,Name FROM Report where Name='PBS Course Status In Detail' limit 1]; 
        for(Report rep : reports){
        pageref = new Pagereference('/apex/PBS_CourseStatusInDetailReport?id='+rep.id);
    }
    return pageref;
    }
 
}