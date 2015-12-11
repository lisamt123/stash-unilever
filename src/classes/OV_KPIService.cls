/**********************************************************************
Name: OV_KPIService
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Class/service for KPI searching purpose
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             18/05/2015      INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_KPIService {
    public class OVException extends Exception {}

    /*******************************************************************
    Purpose: Method for returning KPI Name objects
    Returns: [List<OV_Wrapper.KPINameWrapper>]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static List<OV_Wrapper.KPINameWrapper> getKPINames(){
        System.debug(LoggingLevel.DEBUG, 'Entering getKPINames');
        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('OV_KPI_Name__c' , new List<String>{'Id', 'Name'});
        /*SECURITY */
        List<OV_KPI_Name__c> kpiNameList = [SELECT Id, Name FROM OV_KPI_Name__c ORDER BY Name ASC LIMIT 2000];

        List<OV_Wrapper.KPINameWrapper> kpisNames = new List<OV_Wrapper.KPINameWrapper>();
        for(OV_KPI_Name__c kpi : kpiNameList){
            kpisNames.add(createKPIName(kpi));
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting getKPINames: ' + kpisNames);
        return kpisNames;
    }

    private static OV_Wrapper.KPINameWrapper createKPIName(OV_KPI_Name__c kpiName){
        return new OV_Wrapper.KPINameWrapper(kpiName.Id, kpiName.Name);
    }

    /*******************************************************************
    Purpose: Method for returning reports basing on kpi name id
    Parameters: [String kpiNameId]
    Returns: [List<OV_Wrapper.ReportWrapper>]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static List<OV_Wrapper.ReportWrapper> getReports(Id kpiNameId){
        System.debug(LoggingLevel.DEBUG, 'Entering getReports');
        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('OV_Report__c' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('OV_KPI_Element__c' , new List<String>{'Report__c'});
        /*SECURITY */
        List<AggregateResult> kpiElementList = [SELECT Report__c, Report__r.Name FROM OV_KPI_Element__c WHERE KPI__c = :kpiNameId GROUP BY Report__c,Report__r.Name];

        List<OV_Wrapper.ReportWrapper> reports = new List<OV_Wrapper.ReportWrapper>();
        for(AggregateResult kpi : kpiElementList){
            reports.add(createReportElement(kpi));
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting getReports: ' + reports);
        return reports;
    }

    /*******************************************************************
    Purpose: Method for returning KPI elements
    Parameters: [Id kpiNameId, Id reportId]
    Returns: [List<OV_Wrapper.KPIElementWrapper>]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static List<OV_Wrapper.KPIElementWrapper> getKPIElements(Id kpiNameId, Id reportId){
        System.debug(LoggingLevel.DEBUG, 'Entering getKPIElements');
        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('OV_KPI_Element__c' , new List<String>{'Id', 'Name', 'Report__c', 'Brand__c', 'Brand_Comparator__c', 'Category__c', 'Function__c', 'Geography__c', 'KPI__c', 'Channel__c', 'Customer__c', 'TimeSpan__c', 'Direction__c', 'Rounded_Value__c', 'Target__c'});
        OV_SecurityHelper.doPrivilegedOp('OV_Report__c' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('OV_Brand__c' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('OV_Comparator__c' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('OV_Category__c' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('OV_Function__c' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('OV_Geography__c' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('OV_KPI_Name__c' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('OV_Customer__c' , new List<String>{'Name'});
        /*SECURITY */
        List<OV_KPI_Element__c> kpiElementList = [SELECT Id, Name, Report__c, Report__r.Name, Brand__c, Brand__r.Name, Brand_Comparator__c, Brand_Comparator__r.Name,
           Category__c, Category__r.Name, Function__c, Function__r.Name, Geography__c, Geography__r.Name, KPI__c, KPI__r.Name, Channel__c, Customer__c, Customer__r.Name, TimeSpan__c, Direction__c, Rounded_Value__c, Target__c FROM OV_KPI_Element__c WHERE KPI__c = :kpiNameId AND Report__c = :reportId];

        List<OV_Wrapper.KPIElementWrapper> kpiElements = new List<OV_Wrapper.KPIElementWrapper>();
        for(OV_KPI_Element__c kpi : kpiElementList){
            kpiElements.add(createKPIElement(kpi));
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting getKPIElements: ' + kpiElements);
        return kpiElements;
    }

    /*******************************************************************
    Purpose: Method for adding KPIs elements to my KPI list
    Parameters: [String kpiElementId, Id userProfileId, Boolean shouldBeNotified]
    Returns: [void]
    Sonar Note: npath complexity issue. needs refactoring however leaving for now because of too complicated and time consuming.
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static void addKPIElementToMyKPIs(String kpiElementIds, Boolean shouldBeNotified){
        System.debug(LoggingLevel.DEBUG, 'Entering addKPIElementToMyKPIs');

        Savepoint sp = Database.setSavepoint();
        try{
            Id userId = UserInfo.getUserId();
            /*SECURITY - CRUD/FLS Enforcement */
            OV_SecurityHelper.doPrivilegedOp('OV_Profile__c' , new List<String>{'Id'});
            /*SECURITY */
            OV_Profile__c profile = [SELECT Id FROM OV_Profile__c WHERE User__c =: userId];

            List<String> kpiElementIdsList = kpiElementIds.split(',');

            List<OV_KPI_Element_Interest__c> interests = new List<OV_KPI_Element_Interest__c>();
            OV_KPI_Element_Interest__c interest ;
            for(String  kpiElementId : kpiElementIdsList){
                interest = new OV_KPI_Element_Interest__c();
                interest.KPI_Element__c = kpiElementId;
                interest.User__c = profile.Id;
                interest.Wants_Notifications__c = shouldBeNotified;

                interests.add(interest);
            }
            if( !interests.isEmpty() ){
                /*SECURITY - CRUD/FLS Enforcement */
                OV_SecurityHelper.doPrivilegedOp('OV_KPI_Element_Interest__c' , new List<String>{'KPI_Element__c', 'User__c', 'Wants_Notifications__c'});
                /*SECURITY */
                insert interests;
            }
            /*SECURITY - CRUD/FLS Enforcement */
            OV_SecurityHelper.doPrivilegedOp('EntitySubscription' , new List<String>{'Id', 'SubscriberId', 'ParentId'});
            /*SECURITY */
            List<EntitySubscription> entitiesIn = [SELECT Id, SubscriberId, ParentId FROM EntitySubscription WHERE SubscriberId = :userId LIMIT 1000];
            Set<Id> entitiesInIds = new Set<Id>();
            for(EntitySubscription e : entitiesIn){
                entitiesInIds.add(e.ParentId);
            }

            OV_ChatterServiceImpl chatterService = new OV_ChatterServiceImpl();
            List<EntitySubscription> entities = new List<EntitySubscription>();
            //Follow KPIElement
            for(String  kpiElementId : kpiElementIdsList){
                if(kpiElementId != '' && kpiElementId != null && ! entitiesInIds.contains(kpiElementId)){
                    entities.add(chatterService.followKPIElement(kpiElementId, false));
                }
            }
            if( !entities.isEmpty() ){
                /*SECURITY - CRUD/FLS Enforcement */
                OV_SecurityHelper.doPrivilegedOp('EntitySubscription' , new List<String>{'Id', 'SubscriberId', 'ParentId'});
                /*SECURITY */
                insert entities;
            }

            //Follow KPIElementInterest
             List<EntitySubscription> kEntities = new List<EntitySubscription>();
            for(OV_KPI_Element_Interest__c i : interests){
                if(! entitiesInIds.contains(i.Id)){
                    kEntities.add(chatterService.followKPIElementInterest(i.Id, false));
                }
            }
            if( !kEntities.isEmpty() ){
                /*SECURITY - CRUD/FLS Enforcement */
                OV_SecurityHelper.doPrivilegedOp('EntitySubscription' , new List<String>{'Id', 'SubscriberId', 'ParentId'});
                /*SECURITY */
                insert kEntities;
            }
        }catch(Exception ex){
            Database.rollback(sp);
            throw new OVException('Error occured.'+ ex.getMessage(), ex);
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting addKPIElementToMyKPIs');
    }

    /*******************************************************************
    Purpose: Method for returning my KPI elements (basing on KPI Interest object)
    Returns: [List<OV_Wrapper.KPIElementWrapper>]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static List<OV_Wrapper.KPIElementWrapper> getMyKPIElements(String geographyId, String categoryId, String functionId, Boolean mineOnly){
        System.debug(LoggingLevel.DEBUG, 'Entering getMyKPIElements');

        Id userId = UserInfo.getUserId();

        //added filters
        String whereClause = '';
        try{
            Id vailidId;
            if(geographyId != null && geographyId != '' ){
                vailidId = Id.valueOf(geographyId);

                whereClause += ' AND (KPI_Element__r.Geography__c = \''+vailidId+
                    '\' OR KPI_Element__r.Geography__r.Parent_Geography__c = \'' +vailidId+
                    '\' OR KPI_Element__r.Geography__r.Parent_Geography__r.Parent_Geography__c = \'' +vailidId+
                    '\' OR KPI_Element__r.Geography__r.Parent_Geography__r.Parent_Geography__r.Parent_Geography__c = \'' +vailidId+ '\')';
                    /*SECURITY - CRUD/FLS Enforcement */
                    OV_SecurityHelper.doPrivilegedOp('OV_Geography__c' , new List<String>{'Parent_Geography__c'});
                    /*SECURITY */
            }

            if(categoryId != null  && categoryId != ''){
                vailidId = Id.valueOf(categoryId);

                whereClause += ' AND (KPI_Element__r.Category__c = \''+vailidId+
                '\' OR KPI_Element__r.Category__r.Parent_Category__c = \''+vailidId+
                '\' OR KPI_Element__r.Category__r.Parent_Category__r.Parent_Category__c = \''+vailidId+
                '\' OR KPI_Element__r.Category__r.Parent_Category__r.Parent_Category__r.Parent_Category__c = \''+vailidId+ '\')';
                /*SECURITY - CRUD/FLS Enforcement */
                OV_SecurityHelper.doPrivilegedOp('OV_Category__c' , new List<String>{'Parent_Category__c'});
                /*SECURITY */
            }

            if(functionId != null  && functionId != ''){
                vailidId = Id.valueOf(functionId);

                whereClause += ' AND (KPI_Element__r.Function__c = \''+vailidId+
                '\' OR KPI_Element__r.Function__r.Parent_Function__c = \''+vailidId+
                '\' OR KPI_Element__r.Function__r.Parent_Function__r.Parent_Function__c = \''+vailidId+
                '\' OR KPI_Element__r.Function__r.Parent_Function__r.Parent_Function__r.Parent_Function__c = \''+vailidId+ '\')';
                /*SECURITY - CRUD/FLS Enforcement */
                OV_SecurityHelper.doPrivilegedOp('OV_Function__c' , new List<String>{'Parent_Function__c'});
                /*SECURITY */
            }

            if(mineOnly){
                whereClause += ' AND KPI_Element__r.Report__r.OwnerId = \''+userId+'\'';
                OV_SecurityHelper.doPrivilegedOp('OV_Report__c' , new List<String>{'OwnerId'});
            }

        }catch(Exception ex){
            throw new OVException('Get favourite KPI method returns no results. Invalid parameters to build query', ex);
        }

        String query = 'SELECT KPI_Element__r.Name, KPI_Element__c, KPI_Element__r.Brand__c, KPI_Element__r.Brand__r.Name, KPI_Element__r.Brand_Comparator__c, KPI_Element__r.Brand_Comparator__r.Name, KPI_Element__r.Category__c, KPI_Element__r.Category__r.Name, KPI_Element__r.Function__c, KPI_Element__r.Function__r.Name, KPI_Element__r.Geography__c, KPI_Element__r.Geography__r.Name, KPI_Element__r.Report__c, KPI_Element__r.Report__r.Name, KPI_Element__r.KPI__c, KPI_Element__r.KPI__r.Name, KPI_Element__r.Channel__c,KPI_Element__r.Direction__c, KPI_Element__r.Rounded_Value__c, KPI_Element__r.Target__c, KPI_Element__r.TimeSpan__c, KPI_Element__r.Customer__c, KPI_Element__r.Customer__r.Name FROM OV_KPI_Element_Interest__c WHERE User__r.User__c = :userId '+whereClause;
        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('OV_KPI_Element_Interest__c' , new List<String>{'KPI_Element__c'});
        OV_SecurityHelper.doPrivilegedOp('OV_KPI_Element__c' , new List<String>{'Id', 'Name', 'Report__c', 'Brand__c', 'Brand_Comparator__c', 'Category__c', 'Function__c', 'Geography__c', 'KPI__c', 'Channel__c', 'Customer__c', 'TimeSpan__c', 'Direction__c', 'Rounded_Value__c', 'Target__c'});
        OV_SecurityHelper.doPrivilegedOp('OV_Report__c' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('OV_Brand__c' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('OV_Comparator__c' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('OV_Category__c' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('OV_Function__c' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('OV_Geography__c' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('OV_KPI_Name__c' , new List<String>{'Name'});
        OV_SecurityHelper.doPrivilegedOp('OV_Customer__c' , new List<String>{'Name'});
        /*SECURITY */
        List<OV_KPI_Element_Interest__c> kpiElementInterest = Database.query(query);

        List<OV_Wrapper.KPIElementWrapper> kpiElements = new List<OV_Wrapper.KPIElementWrapper>();
        for(OV_KPI_Element_Interest__c interest : kpiElementInterest){
            if(interest.KPI_Element__c != null){
               kpiElements.add(createKPIElementFromInterest(interest));
            }
        }

        System.debug(LoggingLevel.DEBUG, 'Exiting getMyKPIElements: ' + kpiElements);
        return kpiElements;
    }

    /*******************************************************************
    Purpose: Method for deleting my KPI element (basing on Id)
    Returns: [List<OV_Wrapper.KPIElementWrapper>]
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static void deleteMyKPI(String kpiElementId){
        System.debug(LoggingLevel.DEBUG, 'Entering deleteMyKPI');
        Id kpiElId =  Id.valueOf(kpiElementId);

        Id userId = UserInfo.getUserId();
        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('OV_KPI_Element_Interest__c' , new List<String>{'Id', 'KPI_Element__c'});
        OV_SecurityHelper.doPrivilegedOp('OV_Profile__c' , new List<String>{'User__c'});
        /*SECURITY */
        List<OV_KPI_Element_Interest__c> kpiElementInterest = [SELECT Id, KPI_Element__c FROM OV_KPI_Element_Interest__c WHERE User__r.User__c = :userId AND KPI_Element__c = :kpiElId];

        Set<Id> parentsIds = new Set<Id>();
        for(OV_KPI_Element_Interest__c k : kpiElementInterest){
            parentsIds.add(k.Id);
        }
        /*SECURITY - CRUD/FLS Enforcement */
        OV_SecurityHelper.doPrivilegedOp('EntitySubscription' , new List<String>{'Id', 'SubscriberId', 'ParentId'});
        /*SECURITY */
        List<EntitySubscription> kpiElementEntitySubscription = [SELECT Id FROM EntitySubscription WHERE SubscriberId = :userId AND ParentId IN :parentsIds LIMIT 1000];
        Savepoint sp = Database.setSavepoint();
        try{
            delete kpiElementEntitySubscription;
            delete kpiElementInterest;
        }catch(Exception ex){
            Database.rollback(sp);
            throw new OVException('Error occured.'+ ex.getMessage(), ex);
        }
    }

    private static OV_Wrapper.KPIElementWrapper createKPIElementFromInterest(OV_KPI_Element_Interest__c kpiInterest){
        return new OV_Wrapper.KPIElementWrapper(kpiInterest.KPI_Element__r.Name, kpiInterest.KPI_Element__c, kpiInterest.KPI_Element__r.Brand__c, kpiInterest.KPI_Element__r.Brand__r.Name, kpiInterest.KPI_Element__r.Brand_Comparator__c, kpiInterest.KPI_Element__r.Brand_Comparator__r.Name, kpiInterest.KPI_Element__r.Category__c, kpiInterest.KPI_Element__r.Category__r.Name, kpiInterest.KPI_Element__r.Function__c, kpiInterest.KPI_Element__r.Function__r.Name, kpiInterest.KPI_Element__r.Geography__c, kpiInterest.KPI_Element__r.Geography__r.Name, kpiInterest.KPI_Element__r.Report__c, kpiInterest.KPI_Element__r.Report__r.Name, kpiInterest.KPI_Element__r.KPI__c, kpiInterest.KPI_Element__r.KPI__r.Name, kpiInterest.KPI_Element__r.Channel__c, kpiInterest.KPI_Element__r.Direction__c, kpiInterest.KPI_Element__r.Rounded_Value__c, kpiInterest.KPI_Element__r.Target__c, kpiInterest.KPI_Element__r.TimeSpan__c, kpiInterest.KPI_Element__r.Customer__c, kpiInterest.KPI_Element__r.Customer__r.Name);
    }

    private static OV_Wrapper.KPIElementWrapper createKPIElement(OV_KPI_Element__c kpiElement){
        return new OV_Wrapper.KPIElementWrapper(kpiElement.Name, kpiElement.Id, kpiElement.Brand__c, kpiElement.Brand__r.Name, kpiElement.Brand_Comparator__c, kpiElement.Brand_Comparator__r.Name, kpiElement.Category__c, kpiElement.Category__r.Name, kpiElement.Function__c, kpiElement.Function__r.Name, kpiElement.Geography__c, kpiElement.Geography__r.Name, kpiElement.Report__c, kpiElement.Report__r.Name, kpiElement.KPI__c, kpiElement.KPI__r.Name, kpiElement.Channel__c, kpiElement.Direction__c, kpiElement.Rounded_Value__c, kpiElement.Target__c, kpiElement.TimeSpan__c, kpiElement.Customer__c, kpiElement.Customer__r.Name);
    }

    private static OV_Wrapper.ReportWrapper createReportElement(AggregateResult report){
        return new OV_Wrapper.ReportWrapper((Id)report.get('Report__c'), (String)report.get('Name'));
    }
}