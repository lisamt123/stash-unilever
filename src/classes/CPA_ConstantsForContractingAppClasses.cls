/**********************************************************************
Name: CPA_ConstantsForContractingAppClasses()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: Provides required constants for all classes developed for Contracting App.
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR           DATE            DETAIL Description
1.0         Dinesh Girase    29/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public class CPA_ConstantsForContractingAppClasses{

    public static final String INSERTCONSTANT= 'insert';
    public static final String UPDATECONSTANT= 'update';
    public static final String REQUIRED= 'Required';
    public static final String LOICUSTOMSETTING = 'CPA_LOIMandatoryMessages__c';
    public static final String PWORFCUSTOMSETTING = 'CPA_PWORFMandatoryMessages__c';
    public static final String MANDATORY = 'Mandatory';
    public static final String YES = 'Yes';
    public static final String NO = 'No';
    public static final String TEST = 'Test';
    public static final String TEST_EMAIL = 'test@test.com';
    public static final String PWOlinkedtoCR = 'Mandatory when Request type is Project Scope Change (CR)';
    //Below constant is for auto generated PWORF
    public static final String PWORF_DEFAULT_VALUE = 'Please refer to the original PWORF in SharePoint';
    
    public static final String RESUBMITTED = 'Resubmitted';
    public static final String SUBMITTED = 'Submitted';
    public static final String CANCELLED = 'Cancelled';
    public static final String ACCEPTED = 'Accepted';
    public static final String ANSWERED = 'Answered';
    public static final String SIGNED = 'Signed';
    public static final String RETURNED = 'Returned';
    public static final String DELIVERED = 'Delivered';
    public static final String SentForClosure = 'Sent For Closure';
    public static final String Closed = 'Closed';
    public static final String SentForTermination = 'Sent For Termination';
    public static final String Terminated = 'Terminated';
    public static final String SAVED= 'Saved';
    public static final String READYTOSUBMIT= 'Ready To Submit';
    public static final String PDF = 'pdf';
    public static final String PLAN_ANALYSE = 'plan; analyse';
    public static final String PWOISTERMINATED= 'PWO is Terminated';
    
    public static final String EUROPE = 'Europe';
    public static final String ONETWOTHREE = '123';
    public static final String APPLICATIONPDF = 'application/pdf';
    public static final String APPLICATIONEXCEL = 'application/vnd.ms-excel';
    
    public static final String CRTRIGGERNAME = 'CPA_CR_Trigger';
    public static final String PWOTRIGGERNAME = 'CPA_Project_Work_Order_Trigger';
    public static final String PWORFTRIGERNAME = 'CPA_PWORF_Trigger';
    public static final String LOITRIGGERNAME = 'CPA_LOI_Trigger';
    public static final String ATTACHMENTTRIGERNAME = 'CPA_AfterAttachment';
    public static final String UDATRIGGER= 'CPA_User_Defined_Attribute';
    public static final String HLEREQUESTTRIGERNAME = 'CPA_HLERequest';
    public static final String QUERIESTRIGERNAME = 'CPA_Queries';
    public static final String QUERYCOMMENTTRIGERNAME = 'CPA_Query_comment';
    public static final String KEYCONTACTTRIGERNAME = 'CPA_Key_Contact_Trigger';
    public static final String REQUIRMENTANDDELIVERABLETRIGERNAME = 'CPA_Requirements_and_Deliverables';
    public static final String RESOURCEREQUIREMENTTRIGERNAME = 'Resource_Requirement';
    
    public static final String SUBMITFORAPPROVAL = 'Submitted for approval. Please approve.';
    public static final String WITHHOLD = 'Withhold';
    public static final String RECALLINGUNLOCKREQ = 'Recalling and unlocking request.';
    public static final String REMOVED = 'Removed';
    public static final String AUTOACCEPT= 'Auto Accepted';
    public static final String APPROVE= 'Approve';
    public static final String OTHER= 'Other';
    public static final String OTHERS= 'Others';
    public static final String PLAN= 'Plan';
    public static final String ANALYSE= 'Analyse';
    public static final String DESIGN= 'Design';
    public static final String BUILD= 'Build';
    //public static final String TEST= 'Test';
    public static final String DEPLOY= 'Deploy';
    public static final String RA= 'RA';
    public static final String PA= 'PA';
    public static final String RESOURCEAUGMENTATION='Resource Augmentation';
    public static final String PADBTD='PADBTD';
    public static final String DBTD='DBTD';
    public static final String PWORFCANTBEDELETED='PWORF cant be deleted';
    public static final String REQUESTFORTERMINATION='Request For Termination';
    
    public static final String PWO='PWO';
    public static final String CNF='CNF';
    public static final String TNF='TNF';
    public static final String CR='CR';
    public static final String LOI='LOI';        
    public static final String RECORDTYPE='recordType';
    
    public static final String LOIREASONFORRETURN='CPA_LOI_Reason_for_return';
    public static final String PWOCNFTNFRETURNREASON='CPA_PwoCnfTnf_Return_Reason';
    public static final String CRREASONFORRETURN='CPA_CR_Reason_for_return';
    public static final String PWORFREASONFORWITHHOLD='CPA_PWORF_Reason_for_Withhold';
    public static final String UNKONWN='unkonwn';
    public static final String SPREADSHEET='spreadsheet';
    public static final String COMMERCIAL='Commercial';
    public static final String MSEXCEL='ms-excel';
    public static final String PHILIPPINES='PHILIPPINES';
    public static final String INDIA='INDIA';
    public static final String INDICATIVEEXPENSES='Indicative Expenses';
    public static final String NONPAYROLL='Non Payroll';
    public static final String PMOTAX='PMO Tax';
    public static final String CONTINGENCYCHARGES='Contingency Charges';
    public static final String DISCOUNTS='Discounts';
    public static final String AUTHORISATION='Authorisation';
    public static final String RMS='RMS';
    public static final String RESOURCE='Resource';
    public static final String LOIFILENAME='LOI RentReceipt.pdf.pdf';
    public static final String COMMERCIALPWOCSV='Commercial for PWO.csv';
    public static final String PWOPDFFILENAME='PWO RentReceipt.pdf.pdf';
    public static final String COMMERCIALCRCSV='Commercial for CR.csv';
    public static final String CRPDFFILENAME='CR RentReceipt.pdf.pdf';
    public static final String STRSELECT='select';
    
    
    //Constants for PWORF form mandatory fields
    public static final String ENDDATECANNOTBEBEFORESTARTDATE='End date canot be before start date';
    public static final String MANDATORYFIELDSMESSAGE='Below field(s) are mandatory to Submit the record';
    public static final String MANDATORYIFPROJECTREQUIRELOI='Mandatory, if Work at Risk required is Yes';
    public static final String EXPECTEDGOLIVEDATEVALIDATION='Expected go-live date canot be before Expected start date';
    public static final String EXPECTEDGOLIVEDATE='Expected go-live date';
    public static final String CAPSMT='CPA_SMT';
    public static final String EXPECTEDSTARTDATEVALIDATION='Expected start date canot be past date';
    public static final String PHASESCOVEREDBYWAR='Phases covered by the WAR';
    public static final String DIRECTORAPPROVEDWAR='Director who approved W@R spend';
    public static final String ITCRESOURCESUTIL='ITC Resources Utilization';
    public static final String WHATSPECIFICROLES='What specific roles do you require?';
    public static final String WHYISWORKATRISKREQ='Why is Work at Risk required?';
    public static final String WORKATRISKSTARTDATE='Work at Risk Start Date';
    public static final String MANDAYSREQFORWAR='Man Days required for W@R';
    public static final String WORKATRISKREQMANDATORY='Work at Risk required?*';
    public static final String WORKATRISKREQ='Work at Risk required?';
    public static final String ROLEORSYSAUTHDETAIL='Role or System Authorisation detail';
    public static final String ROLEAUTHINTRODUCEDCHANGED='Role/Authorisation Introduced/Changed?';
    public static final String PROJECTSCALE='Project Type';
    public static final String PROJECTREQPERFORMANCETESTING='Project Require Performance Testing';
    public static final String PROJECTREQDATASPECIFICTESTING='Project Require Data Specific Testing';
    public static final String PROCESSOFFICEAREAE2E='Process Office Area E2E';
    public static final String OTHERPROJECTPHASES='Other Project Phases';
    public static final String OTHERPROCESSOFFICEAREAE2E='Other-Process Office area E2E';
    public static final String ISTHISPROJINVASIVEINNATURE='Is this ‘Project’ Invasive in nature?';
    public static final String NEWORREWORKEDINTREQ='New or ReWorked Integration Requirement';
    public static final String APPPERTESTINGNEEDED='Application Performance Testing Needed';
    public static final String DATASPECIFICTESTINGREQ='Data-specific testing required?';
    public static final String INTERFACETOSYSDETAIL='Interface to the system Detail';
    public static final String INTERFACEINTROCHANGED='Interface Introduced/Changed?';
    public static final String HASWARBEENDISCUSSEDWITHSUPPER='Agreed with Supplier Performance Team';
    public static final String GOVRISKANDCOMPLIANCE='Governance Risk and Compliance';
    public static final String EXPECTEDSTDTFORPLANANDANALYSE='Expected Start Date for Plan and Analyse';
    public static final String EXPECTEDSTDTFORDBTDPWO='Expected Start Date for DBTD PWO';
    public static final String THIRDPARTYULCONFDATA='3rd Party/Unilever Confidential Data';
    public static final String COREBUMODELCHANGED='Core Business Model changed?';
    public static final String POSTGOLIVESUPPORTSERVICE='Post Go-Live Support Service';
    public static final String TRAVELARRANGEMENTS='Travel Arrangements';
    public static final String SUMMARYOFREQANDDEL='Summary Of Requirements & Deliverables';
    public static final String PROJECTDEPENDENCIES='Project Dependencies';
    public static final String PLANNINGSESSIONSEXPECTED='Planning sessions expected';
    public static final String IMPACTIFGOLIVEDATENOTMET='Impact if go live date not met';
    public static final String EXPECTEDPASTARTDATE='Expected PA Start Date';
    public static final String EXPSTDTFORDBTDPWO='Expected Start Date for DBTD PWO';
    public static final String EXPBUGOLIVEDATE='Expected Business Go live date';
    public static final String BUCRITICALMILESTONES='Business critical milestones';
    public static final String APPINFRASTRUCTURE='Application infrastructure';
    public static final String ANALYSESESSIONSEXPECTED='Analyse sessions expected';
    public static final String ACCEPTANCECRITERIA='Acceptance Criteria';
    public static final String PROJECTREQUESTOREMAIL='Project requestor Email';
    public static final String PROJECTREQUESTORNAME='Project requestor Name';
    
    
    
    public static final String REVISEDSUBDATE='Revised Submission Date';
    public static final String PWOLINKEDTOCR1='PWO linked to CR';
    public static final String OTHERREQUESTTYPE='Other-Request Type';
    public static final String REQUESTTYPE='Request Type';
    public static final String REGION='Region';
    public static final String PRICINGMODEL='Pricing Model';
    public static final String LANDSCAPE='Landscape';
    public static final String ICCNUMBER='ICC Number';
    public static final String COSTCENTER='Cost Center';
    public static final String COSTCENTERDETAILS='Cost Center Details';
    public static final String BUSINESSAREA='Business Area';
    public static final String ULPROJECTMANAGER='Unilever project manager';
    public static final String ULFINANCEBP='Unilever Finance BP/Contact';
    public static final String ULCONTENTAPPROVER='Unilever content approver';
    public static final String ULBUDGETAPPROVER='Unilever budget approver';
    public static final String TITLE='Title';
    public static final String STACKHOLDEREXPECTATIONS='Stakeholder Expectations';
    public static final String OVERALLPURPOSEOFPROJ='Overall purpose/function of the project';
    public static final String OUTOFSCOPE='Out of Scope';
    public static final String INSCOPE='In Scope';
    public static final String BUSINESSCASE='Business Case';
    public static final String EXPECTEDSTDT='Expected start date';
    public static final String PROJECTPHASES='Project Phases';
    public static final String ROLELEVEL='Role (Level 1-13)';
    public static final String RESOURCELOCATION='Resource Location';
    public static final String BUDGETEXPENSESPER='Budget Expenses (% of Resource Cost)';
    public static final String INDICATIVETIMELINEENDDATE='Indicative timeline end date';
    public static final String INDICATIVETIMELINESTDATE='Indicative timeline start date';
    public static final String REQUIREMENTSANDDELIVERABLES='Requirements and Deliverables';
    public static final String KEYCONTACTS='Key Contacts';
    public static final String RESOURCEREQUIREMENT='Resource Requirement';
    public static final String EXPTGOLIVEDATENOTPASTDATE='Expected go-live date canot be past date';
    public static final String CPASMT='CPA_SMT';
    public static final String CPAADM='CPA_ADM';
    public static final String CPAULPM='CPA_ULPM'; 
    public static final String WhyProjectInvasiveInNature='Why Project Invasive in nature?';
    public static final String MANDATORYIFPRJISINVASIVEINNATURTE='Mandatory, If Project is Invasive in nature';
    public static final String MANDATORYIFPRJROLESYSADMIN='Mandatory, if the project has Role or System Authorization';
    public static final String MANDATORYIFPRJREQPERFTEST='Mandatory, If Project Require Performance Testing';
    public static final String MANDATORYIFPRJREQDATASPTESTING='Mandatory, If Project Require Data Specific Testing';
    public static final String MANDATORYIFOTHERISSELECTEDINPP='Mandatory, If Other is selected in Project Phases.';
    public static final String MANDATORYIFOTHISSELECTEDINPO='Mandatory, If Other is selected in Process Office area E2E.';
    public static final String MANDATORYIFINTERFACE='Mandatory, If there is Interface to the system';
    public static final String MANDATORYIFRTISPSC='Mandatory, If Request Type is Project Scope Change (CR).';
    public static final String MANDATORYIFOTHISSELECTEDINRT='Mandatory, If Other is selected in Request Type.';
    public static final String NOTREQUIREDWHENREQUESTTYPENOTOTHER='Required only when Request Type is Other.';
    public static final String NOTREQUIREDWHENPROJECTPHASENOTOTHER='Required only when Project Phases is Other.';
    public static final String PROJECTSCOPECHANGE='Project Scope Change (CR)';
    public static final String MANDATORYIFCOSTCENTNOTPROVIDED='Mandatory only when the Cost Center is not provided.';
    public static final String MANDATORYIFICCNOISPROVIDED='Mandatory. But if ICC number is provided, CC can be avoided.';
    public static final String ULPMEMAIL='Unilever Project Manager Email';
    public static final String ULPMENAME='Unilever Project Manager Name';
    public static final String ULFMENAME='Unilever Finance BP/Contact Name';
    public static final String ULFMEMAIL='Unilever Finance BP/Contact Email';
    public static final String ULBANAME='Unilever Budget Approver Name';
    public static final String ULBAEMAIL='Unilever Budget Approver Email';
    public static final String ULCANAME='Unilever Content Approver Name';
    public static final String ULCAEMAIL='Unilever Content Approver Email';
    
    public static final String PWOTITLE = 'PWO title';
    public static final String EXPENSECHAGRESOFLOI = 'Expense charges of LOI';
    public static final String CNFULCAEMAIL=  'CNF Unilever Content Approver Email';
    public static final String TNFULCONTACTEMAIL=  'TNF Unilever Contact Email';
    public static final String ASSUMPTIONS=  'Assumptions';
    public static final String BPETITLE = 'BPE Title';
    public static final String HLENAME = 'HLE Name*';
    
    
    public static final String CPA_Standalone_PWO_RecordTypeId = 'Standalone PWO';
    public static final String CPA_PWO_RecordTypeId = 'PWO';
    public static final String CPA_CNF_RecordTypeId = 'PWO CNF'; 
    public static final String CPA_TNF_RecordTypeId = 'PWO TNF'; 
    
    public static final String CPA_Standalone_CR_RecordTypeId= 'Standalone CR';
    public static final String CPA_HLE_Recordtype = 'HLE';
    public static final String CPA_BPE_Recordtype= 'BPE';
    
    
    public static final String CPA_CNF_historical_TNF_id = 'TNF';
    public static final String CPA_CNF_historical_CNF_id = 'CNF';
    
    public static final String CPA_PWO_OBJECT_ID = CPA_project_work_order__c.getSObjectType().getDescribe().getKeyPrefix();
    public static final String CPA_LOI_ID = CPA_LOI__c.getSObjectType().getDescribe().getKeyPrefix();
    public static final String CPA_CR_ID = CPA_CR__c.getSObjectType().getDescribe().getKeyPrefix();
    
    public static final String CPA_PWORF_ALL_RECORDTYPE = 'Other';
    public static final String CPA_PWORF_RA_RECORDTYPE = 'Resource Augmentation';
    
    public static final String CPA_KEYCONTACTNOTUPDATED= ' Key Contact cannot be updated, as PWORF is already accepted/Cancelled By Vendor.';
    public static final String CPA_KEYCONTACTNOTUPDATEDFORSMT= ' Key Contact cannot be updated, as PWORF is already Cancelled.';
    public static final String CPA_KEYCONTACTNOTDELETED= ' Key Contact Cannot be deleted.';
    
    public static final String REQUIRMENTANDDELIVERABLENOTUPDATE = ' Requirements and Deliverables cannot be updated, as PWORF is already accepted/Cancelled By Vendor.';
    public static final String REQUIRMENTANDDELIVERABLENOTUPDATEFORSMT = ' Requirements and Deliverables cannot be updated, as PWORF is already Cancelled';
    public static final String REQUIRMENTANDDELIVERABLENOTDELETE = ' Requirements and Deliverables Cannot be deleted.';
    
    public static final String RESOURCEREQUIREMENTNOTUPDATED= ' Resource requirement cannot be updated, as PWORF is already accepted/Cancelled By Vendor.';
    public static final String RESOURCEREQUIREMENTNOTUPDATEDFORSMT= ' Resource requirement cannot be updated, as PWORF is already Cancelled.';
    public static final String RESOURCEREQUIREMENTNOTDELETED= ' Resource requirement Cannot be deleted.';
    
    Public static final String PROJECTDECRIPTION = 'Project Description*';
    Public static final String RETURNFROMDOCSIGN = ' is returned from DocuSign';
    
    public static final String CONTRACTDELETE = 'Contract can be deleted in Save and Return Status only';
    public static final String COMMERICALDELETE = 'Commercial can be deleted in Save and Return Status only';
    public static final String STANDALONECR = 'Standalone CR';

}