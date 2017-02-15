/**  PROGRAM NAME    :  UL_CreateTransactionController  
     * This class is used for Transaction Creation
       The class is an extension controller and only called on creation of new Transaction page. Standard New buttons are overridden by the VF page CreateTransaction.
     * @see    CreateTransaction Visualforce page
     * @author  ankita.tukaram.parab@accenture.com
     * @version  1.0
     * @Created Date 2016-04-25  ankita.tukaram.parab@accenture.com  creation 
*/
/**  PROGRAM NAME    :  UL_CreateTransactionController  
     * This class is used for Transaction Creation
       The class is an extension controller and only called on creation of new Transaction page. Standard New buttons are overridden by the VF page CreateTransaction.
       This Controller has been modified to trigger the Approval process only for the Cross Category Transaction.
     * @see    UL_CreateTransaction Visualforce page
     * @Updated By  soumyodeep.guha@accenture.com
     * @version  1.0
     * @Created Date 2016-10-11  
*/
global with sharing class UL_CreateTransactionController {
    /** the page standard controller **/ 
    private ApexPages.StandardController transactionController;
    private static String transactionTemplateApiName = ACCL__Fund_Transaction_Template__c.sObjectType.getDescribe().getName();
    private static String transactionApiName = ACCL__Fund_Transaction__c.sObjectType.getDescribe().getName();
    private static String transactionRowsApiName = ACCL__Fund_Transaction_Row__c.sObjectType.getDescribe().getName();
    private static String salesOrgApiName = ACCL__Sales_Organization__c.sObjectType.getDescribe().getName();
    private Map<Id,ACCL__Fund_Transaction_Template__c   > transactionTemplateMap;
    private Map<Id,ACCL__Fund__c> fundMap;
    /** the related Fund_Transaction__c record **/
    global ACCL__Fund_Transaction__c relatedRecord { get;  set; } 
    global String transactionType {get; set;}
    global String transactionDate {get; set;}
    global String salesOrg {get; set;}
    private String sourceFund {get; set;}
    global Boolean hasViewRights{get; set;}
    global List<SelectOption> lstTransactionTemplates {get;set;}
    private List<PermissionSetAssignment> lstcurrentUserPerSet {get; set;}
    global Boolean sourceFundFlag{get; set;}// This flag will be used to display editable source fund
    global Boolean sourceFundButtonFlag{get; set;}// This flag will be used to display read only source fund
    global Boolean displayTransactionTemplateSecurityFlag { get; set;}
    global Boolean crossCategoryAllowedFlag {get; set;} /**CheckBox field for the Cross Category identification on Transaction Template**/
    private static final string sentForApproval = 'Sent/Pending Approval';
    private string nameSp = UL_Utility.MANAGEDPACKAGE_NAMESPACE;
    //variables to display Exception
    global  Boolean msgFlag{set;get;} 
    //variable for CRUD/FLS check
    private list<string> fieldAPINameList;
    private String sourceFundSalesOrg;
    //Variable to set the savepoint if there is any error in inserting transaction rows.
    private Savepoint sp;
    boolean crossCategoryFlag;
    Id nextApproverId;
    List<User> userLst = new List<User>();
    

     /**Constructor of CreateTransactionController class
     *  @name CreateTransactionController 
     *  @param ApexPages.StandardController
     *  @return void
     *  @throws Standard and Custom exceptions
     *  @author ankita.tukaram.parab@accenture.com
     */
    global UL_CreateTransactionController(ApexPages.StandardController ctr) {

        this.transactionController = ctr;
        this.relatedRecord = (ACCL__Fund_Transaction__c) ctr.getRecord();
        //Retrieve the permission set assignment for the current user
        lstcurrentUserPerSet =    [SELECT Id, PermissionSet.Name,AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId() Limit: (LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())];
        
        sourceFund = apexpages.currentpage().getparameters().get('sourceFund');//sourceFund is used to create Transfer Transaction Out of Fund
        if(sourceFund != null &&  sourceFund != UL_Utility.NULL_VALUE)
        {
            this.relatedRecord.ACCL__Source_Fund__c = sourceFund;
            sourceFundButtonFlag = true;
        }
        system.debug('>>>');
        checkTransferTransactionAccess();
        system.debug('>>>');
        loadTransactionFields();
        system.debug('>>>');
    }
     /**Custom method to find out all valid Transaction templates on load of the page.
     If transaction template is Transfer,Source fund is also displayed.
     *  @name loadTransactionFields 
     *  @param None
     *  @return void
     *  @throws Standard and Custom exceptions
     *  @author ankita.tukaram.parab@accenture.com
     */
    private void loadTransactionFields() {
        try
        {
                DateTime dt = datetime.now();
                transactionDate=dt.format();// Display todays date
                lstTransactionTemplates = new List<SelectOption>();
                UL_SecurityUtil.checkObjectIsAccessibleOrThrowError(transactionTemplateApiName);
                //FLS/CRUD check for ACCL__Fund_Transaction_Template__c 
                fieldAPINameList = new list<string>{
                'id',
                'name',
                        nameSp+'Active__c',
                        nameSp+'Transaction_Type__c',
                        nameSp+'Sales_Org__c'
                };
                UL_SecurityUtil.checkFLSPermissionOrThrowError(ACCL__Fund_Transaction_Template__c.sObjectType.getDescribe().getName(),
                fieldAPINameList,'view');
                displayTransactionTemplateSecurityFlag = true;
                // Find out all valid Transaction Templates which are active
                transactionTemplateMap=new Map<Id,ACCL__Fund_Transaction_Template__c    >([select id, Name, ACCL__Active__c, ACCL__Sales_Org__c, UL_Cross_Category_Transfer_Allowed__c,
                                                                            ACCL__Transaction_Type__c, ACCL__Description__c from ACCL__Fund_Transaction_Template__c  
                                                                            where ACCL__Active__c = true order by createddate Limit: (LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())]);
                if(sourceFund != null && sourceFund != UL_Utility.NULL_VALUE){
                    sourceFundSalesOrg = [Select ACCL__Sales_Org__c from ACCL__Fund__c where Id = :sourceFund Limit: (LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())].ACCL__Sales_Org__c;
                }
                for(ACCL__Fund_Transaction_Template__c   tt : TransactionTemplateMap.values())
                {
                    if(checkTransactionAccess(tt.ACCL__Transaction_Type__c))
                     {
                        //If source fund is not null i.e user is navigating from create Transaction button on fund, then do not add any Transaction type except Transfer Transaction
                        if(sourceFund!= null &&  sourceFund != UL_Utility.NULL_VALUE && 
                           tt.ACCL__Transaction_Type__c != UL_Utility.TRANSACTION_TYPE_TRANSFER){
                            continue;
                        }    
                        if((sourceFund!= null && sourceFund != UL_Utility.NULL_VALUE && sourceFundSalesOrg == tt.ACCL__Sales_Org__c) || sourceFund== null){  

                        lstTransactionTemplates.add(new SelectOption(tt.id,tt.ACCL__Description__c+' - '+tt.ACCL__sales_org__c));
                        if(this.relatedRecord.ACCL__Fund_Transaction_Template__c     == null){
                         this.relatedRecord.ACCL__Fund_Transaction_Template__c  = tt.id;
                        }
                        transactionType = TransactionTemplateMap.get(this.relatedRecord.ACCL__Fund_Transaction_Template__c  ).ACCL__Transaction_Type__c;
                        salesOrg = TransactionTemplateMap.get(this.relatedRecord.ACCL__Fund_Transaction_Template__c ).ACCL__Sales_Org__c;
                        
                        if(transactionType == UL_Utility.TRANSACTION_TYPE_TRANSFER){
                            sourceFundFlag= true;// Display source fund only when transaction type is Transfer
                         }
                         else{
                            sourceFundFlag= false;
                     }
                }


        }
                }

        }
        catch(Exception Ex)
        {
            showError(ApexPages.Severity.Error,ex.getMessage());
        }
    }
    /**Custom method to find out if user has access to transfer Transaction if transaction is created through Create Transaction Button.
    Transfer Transaction access through a button is given only through FM permission set.
     *  @name checkTransferTransactionAccess 
     *  @param None
     *  @return void
     *  @throws Standard and Custom exceptions
     *  @author ankita.tukaram.parab@accenture.com
     */
    private void checkTransferTransactionAccess() {
    try{
            Boolean transferTransactionAccess = false;
            if(sourceFund!= null &&  sourceFund != UL_Utility.NULL_VALUE && lstcurrentUserPerSet!=null && lstcurrentUserPerSet.size()>0)
            {
                for (PermissionSetAssignment psa: lstcurrentUserPerSet)
                {
                    if((psa.PermissionSet.Name.equals(UL_Utility.ACSF_FM_PERMISSION_SET)))// User will have access to transfer transaction if User is having FM permission set
                     {
                        transferTransactionAccess= true;
                        break;
                     }
                }
                if(!transferTransactionAccess || lstcurrentUserPerSet ==null)
                {
                  throw new UL_CustomException(Label.ACCL.TRANSFER_TRANSACTION_ACCESS);//Display error if User not having CABO FM permission set is tring to create a transfer transaction
                }
                else
                {
                    hasViewRights = true;// Give access to Create Transfer Transaction to CABO FM user
                }
            }
            else
            {
                hasViewRights = true;
            }
        }
        catch(Exception Ex)
        {
            showError(ApexPages.Severity.Error,ex.getMessage());
        }
    }
    /**Custom method to check the access for Transaction based on the permission Set.
    For FM permission set or FA permission set with transaction type as Initial or Adjustment,access is provided.
     *  @name checkTransactionAccess 
     *  @param None
     *  @return Boolean
     *  @throws Standard and Custom exceptions
     *  @author ankita.tukaram.parab@accenture.com
     */    
    private Boolean checkTransactionAccess(String transactionType) {
        Boolean transactionAccess = false;
        for (PermissionSetAssignment psa: lstcurrentUserPerSet)
        {
            // If Current user is CABO FA,then user can view only initial and adjustment transaction types
            if((psa.PermissionSet.Name.equals(UL_Utility.ACSF_FA_PERMISSION_SET) && 
            transactionType !=null && (transactionType == UL_Utility.TRANSACTION_TYPE_INITIAL 
            || transactionType == UL_Utility.TRANSACTION_TYPE_ADJUSTMENT ) ) )
             {
                transactionAccess= true;
                break;
             }
            else if(psa.PermissionSet.Name.equals(UL_Utility.ACSF_FM_PERMISSION_SET))
            {
                transactionAccess= true;// If Current user is CABO FM,then user can view All transaction types
                break;
            }       
        }
        return transactionAccess;
    }
    /**Custom method called on change of Transaction template to change the transaction type.Also to displaye source fund accordingly.
     *  @name reloadTransaction 
     *  @param None
     *  @return PageReference
     *  @throws Standard and Custom exceptions
     *  @author ankita.tukaram.parab@accenture.com
     */    
    global PageReference reloadTransaction() {
        PageReference currentPage =null;
        try{
            if(this.relatedRecord.ACCL__Fund_Transaction_Template__c     != null){//Check if Transaction Template is not null
                    transactionType = TransactionTemplateMap.get(this.relatedRecord.ACCL__Fund_Transaction_Template__c  ).ACCL__Transaction_Type__c;//When Transaction Tempalate changes,change the transaction type associated with it on page.
                    salesOrg = TransactionTemplateMap.get(this.relatedRecord.ACCL__Fund_Transaction_Template__c ).ACCL__Sales_Org__c;
                    crossCategoryFlag = TransactionTemplateMap.get(this.relatedRecord.ACCL__Fund_Transaction_Template__c ).UL_Cross_Category_Transfer_Allowed__c;
                    
                    if(transactionType == UL_Utility.TRANSACTION_TYPE_TRANSFER){
                        sourceFundFlag= true;
                    }
                    else{
                        sourceFundFlag= false;
              }
        }
        }
        catch(Exception ex)
        {
            showError(ApexPages.Severity.Error,ex.getMessage());
        }
        return currentPage;         
    }
    /**Custom method called on save of Transaction.Function will call validateTransaction method to validate the transfer tranaction and 
    if it is successfull,Transaction and its corresponding Transaction rows are inserted.
     *  @name save 
     *  @param None
     *  @return PageReference
     *  @throws Standard and Custom exceptions
     *  @author ankita.tukaram.parab@accenture.com
     */    
    global PageReference saveRecord() {
    PageReference currentPage =null;
    try{
        Set <id>fundIdSet = new Set<id>();
            if(relatedRecord!=null)
            {
                if(relatedRecord.ACCL__Source_Fund__c != null){
                    fundIdSet.add(relatedRecord.ACCL__Source_Fund__c);
                }
                if(relatedRecord.ACCL__Target_Fund__c != null){
                    fundIdSet.add(relatedRecord.ACCL__Target_Fund__c);
                }
                fieldAPINameList = new list<string>{
                        'id',
                        nameSp+'Amount__c'
                };
                UL_SecurityUtil.checkFLSPermissionOrThrowError(ACCL__Fund__c.sObjectType.getDescribe().getName(),fieldAPINameList,'view');
                fundMap = new Map<Id,ACCL__Fund__c>([select id,ACCL__Amount__c from ACCL__Fund__c where id =: fundIdSet Limit: (LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())]);// Retreive all amounts of the source and target funds.
                List<ACCL__Fund_Transaction_Row__c>listTransactionRow = new list<ACCL__Fund_Transaction_Row__c>();
                if(fundMap != null)
                {    
                    if(validateTransaction(this.relatedRecord,fundMap))// Validate if the current transaction is proper.
                    {
                        UL_SecurityUtil.checkObjectIsCreateableOrThrowError(transactionApiName);
                       // sp = Database.setSavePoint();
                       if(transactionTemplateMap.get(
                            this.relatedRecord.ACCL__Fund_Transaction_Template__c).ACCL__Transaction_Type__c != UL_Utility.TRANSACTION_TYPE_TRANSFER)
                        {
                          relatedRecord.ACCL__Source_Fund__c = UL_Utility.STRING_NULL;
                        }
                        UL_SecurityUtil.checkObjectIsAccessibleOrThrowError(salesOrgApiName);
                            //FLS/CRUD check for Sales Organisation fields before query
                            fieldAPINameList = new list<string>{
                                    'name',
                                    nameSp+'Currency__c'
                            };
                        UL_SecurityUtil.checkFLSPermissionOrThrowError(salesOrgApiName,fieldAPINameList,'view');
                        system.debug('### Going to assign currency for Template salesOrg ---> '+salesOrg);
                        if(salesOrg != null)//If Sales Org from page is not null
                        {
                            /*Query sales organisation object to retreive the currency of sales organisation*/
                            List<ACCL__Sales_Organization__c>lstSalesOrg=[select name, ACCL__Currency__c from ACCL__Sales_Organization__c where name=:salesOrg Limit: (LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())];
                            if(lstSalesOrg != null && lstSalesOrg.size()>0 && lstSalesOrg[0].ACCL__Currency__c != null)
                            {
                                /*Assign the currency of the sales org to transaction currency field*/
                                relatedRecord.ACCL__Currency__c = lstSalesOrg[0].ACCL__Currency__c;
                                system.debug('### if Currency finally assigned ---> '+relatedRecord.ACCL__Currency__c);  
                            }
                        }
                        else
                        {
                            /*Query sales organisation object to retreive the currency of global sales organisation*/
                            List<ACCL__Sales_Organization__c>lstSalesOrg=[select name,ACCL__Currency__c from ACCL__Sales_Organization__c where 
                                                                ACCL__Global_Sales_Org__c = true Limit: (LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())];
                            if(lstSalesOrg != null && lstSalesOrg.size()>0 && lstSalesOrg[0].ACCL__Currency__c != null)
                            {
                                /*Assign the currency of the sales org to transaction currency field*/
                                relatedRecord.ACCL__Currency__c = lstSalesOrg[0].ACCL__Currency__c;
                                system.debug('### Currency finally assigned from global sales org---> '+relatedRecord.ACCL__Currency__c);  
                            }

                        }
                        /*Soumyodeep>> To make the status of all Cross Category and Transfer transaction to Sent For Approval */
                        if(transactionType == UL_Utility.TRANSACTION_TYPE_TRANSFER && crossCategoryFlag == TRUE){
                            relatedRecord.UL_Status__c = sentForApproval;
                            insert relatedRecord;
                            }
                        else
                        {
                             insert relatedRecord;//Creation is triggered through VF page and creates only one record at a time.
                        }
                        
                        UL_SecurityUtil.checkObjectIsCreateableOrThrowError(transactionRowsApiName);
                        if(transactionType == UL_Utility.TRANSACTION_TYPE_INITIAL)
                        {
                            // In case if Initial transaction,amount will be added in the target fund
                            listTransactionRow.add(createTransactionRows(relatedRecord.ACCL__Amount__c,
                                                   null,relatedRecord.ACCL__Target_Fund__c,relatedRecord.id));
                        }
                        else if(transactionType == UL_Utility.TRANSACTION_TYPE_ADJUSTMENT)
                        {
                            // In case if Adjustment transaction,amount will be deducted from the target fund
                            listTransactionRow.add(createTransactionRows((-1)*relatedRecord.ACCL__Amount__c,
                                                   null,relatedRecord.ACCL__Target_Fund__c,relatedRecord.id));
                        }
                        else if(transactionType.equalsIgnoreCase(UL_Utility.TRANSACTION_TYPE_TRANSFER) && crossCategoryFlag == FALSE)
                        {
                           
                           // In case if Transfer transaction,amount will be deducted from the source fund and added in the target fund
                            listTransactionRow.add(createTransactionRows(relatedRecord.ACCL__Amount__c,
                                                   relatedRecord.ACCL__Source_Fund__c,relatedRecord.ACCL__Target_Fund__c,relatedRecord.id));
                            listTransactionRow.add(createTransactionRows((-1)*relatedRecord.ACCL__Amount__c,
                                                   relatedRecord.ACCL__Target_Fund__c,relatedRecord.ACCL__Source_Fund__c,relatedRecord.id));
                        }
                        else if(transactionType.equalsIgnoreCase(UL_Utility.TRANSACTION_TYPE_TRANSFER) && crossCategoryFlag == TRUE)
                        {
                            
                            /**Query the Customer Marketing director for the Sales org**/
                              permissionset permissionId =[SELECT Id FROM PermissionSet WHERE Name = 'SoCo_Customer_Marketing_Director'];
                              list<PermissionSetAssignment> userid = [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId =:permissionId.id LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())];
                              list<id> userIdList=new list<id>();
                              for(PermissionSetAssignment userIdLoop:userid){
                                  userIdList.add(userIdLoop.AssigneeId);
                              }
                              userLst = [SELECT Id, Name FROM User WHERE id In:userIdList and ACCL__Sales_Org__c=:salesOrg Limit 1];
                            
                            /**Create an approval request for the Cross Category Transfer transaction**/                               
                            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                            req1.setComments('Submitting transaction request for approval.');
                            req1.setObjectId(relatedRecord.id);
                            
                            /**Submit the record for approval on behalf of the created user**/
                            req1.setSubmitterId(relatedRecord.CreatedById);
                            
                            /**Submit the record to specific process and skip the criteria evaluation**/
                            req1.setProcessDefinitionNameOrId(UL_Utility.FUND_TRANSFER_TRANSACTION_APPROVAL_PROCESS);
                            req1.setSkipEntryCriteria(false);
                            
                            relatedRecord.UL_Approver__c = userLst[0].Name; 
                            update relatedRecord;
        
                            /**Submit the approval request for the transaction**/
                            Approval.ProcessResult result = Approval.process(req1);
                            
                                
                        }
                        if(!listTransactionRow.isempty())
                        {
                            //if listTransactionRow is not empty,insert the transaction rows.
                            insertTransactionRows(listTransactionRow);
                            ACCL__Fund__c fundrecord= new ACCL__Fund__c(Id =relatedRecord.ACCL__Target_Fund__c);
                            ApexPages.StandardController ctr = new ApexPages.StandardController(fundrecord);
                            currentPage = ctr.view();
                            system.debug('listTransactionRow'+listTransactionRow);
                            system.debug('current page value'+currentPage);
                            currentPage.setRedirect(true);
                        }
                        else
                        {
                            ACCL__Fund_Transaction__c fundTransactionRecord = relatedRecord;
                            ApexPages.StandardController ctr = new ApexPages.StandardController(fundTransactionRecord);
                            currentPage = ctr.view();
                            system.debug('@@'+currentPage);
                            currentPage.setRedirect(true);
                        }
                    }
                }
            }
    }
    catch(Exception ex)
    {
       msgFlag = true;
       ApexPages.addMessages(ex); 
      //showError(ApexPages.Severity.Error,ex.getMessage());
    }
    return currentPage;         
    }

     /**Custom method to validate if Transaction data is valid or not and throws the exception if transaction is not valid.
     *  @name validateTransaction 
     *  @param None
     *  @return void
     *  @throws Standard and Custom exceptions
     *  @author ankita.tukaram.parab@accenture.com
     */
    private Boolean validateTransaction(ACCL__Fund_Transaction__c relatedRecord,map<Id,ACCL__Fund__c> fundMap)
    {
        if(relatedRecord.ACCL__Amount__c <= 0)// Check if Amount is greater than 0,otherwise throw validation
        {
          throw new UL_CustomException(Label.ACCL.TRANSACTION_AMOUNT_GREATER_THAN_ZERO);
        }
        else if(transactionTemplateMap.get(
                    this.relatedRecord.ACCL__Fund_Transaction_Template__c).ACCL__Transaction_Type__c == UL_Utility.TRANSACTION_TYPE_ADJUSTMENT )
        {
            Double fundAmount= fundMap.get(this.relatedRecord.ACCL__Target_Fund__c).ACCL__Amount__c;
            if(fundAmount != null && fundAmount - relatedRecord.ACCL__Amount__c < 0)//If After transaction,Fund amount in target fund will be less than or equal to 0,Validation should be given.
            {
              throw new UL_CustomException(Label.ACCL.REMANING_FUND_AMOUNT_GREATER_THAN_ZERO);
            }
        }
        else if(transactionTemplateMap.get(
                    this.relatedRecord.ACCL__Fund_Transaction_Template__c).ACCL__Transaction_Type__c == UL_Utility.TRANSACTION_TYPE_TRANSFER)
        {
            if(this.relatedRecord.ACCL__Source_Fund__c == null)// If source fund is null for transfer transaction,validation will be given
            {
              throw new UL_CustomException(Label.ACCL.SOURCE_FUND_IS_NULL);
            }
            if(this.relatedRecord.ACCL__Source_Fund__c != null && this.relatedRecord.ACCL__Target_Fund__c != null && 
               this.relatedRecord.ACCL__Source_Fund__c == this.relatedRecord.ACCL__Target_Fund__c)
            //Validation if source fund and target fund are same.
            {
              throw new UL_CustomException(Label.ACCL.SOURCE_FUND_TARGET_FUND_SHOULD_NOT_BE_SAME);
            }
            Double fundAmount= fundMap.get(this.relatedRecord.ACCL__Source_Fund__c).ACCL__Amount__c;
            if(fundAmount != null && fundAmount - relatedRecord.ACCL__Amount__c < 0)//If After transaction,Fund amount in source fund will be less than or equal to 0,Validation should be given.
            {
              throw new UL_CustomException(Label.ACCL.REMANING_FUND_AMOUNT_GREATER_THAN_ZERO);
            }
        }
        return true;
    }

    /**Custom method to insert transaction rows.
    If there is any rollback in inserting transaction rows,System will revert back the inserted transaction also.
     *  @name insertTransactionRows 
     *  @param None
     *  @return void
     *  @throws Standard and Custom exceptions
     *  @author ankita.tukaram.parab@accenture.com
     */
    private Void insertTransactionRows(List<ACCL__Fund_Transaction_Row__c> lstTransactionRow)
    {
        try
        {
            insert lstTransactionRow;//Inserts maximum two records at a time as creation is through VF page.
        }
        catch(Exception ex)
        {
           // database.rollback(sp);
            showError(ApexPages.Severity.Error,Label.ACCL.TRANSACTION_ROLLBACK_ON_ERROR);
        }
    }

    /**Custom method to create transaction rows
     *  @name createTransactionRows 
     *  @param Decimal amount,Id sourceFund,Id targetFund,Id transactionRecord
     *  @return Fund_Transaction_Row__c
     *  @throws Standard and Custom exceptions
     *  @author ankita.tukaram.parab@accenture.com
     */
    private ACCL__Fund_Transaction_Row__c createTransactionRows(Decimal amount,Id sourceFund,Id targetFund,Id transactionRecord)
    {
        ACCL__Fund_Transaction_Row__c transRow = new ACCL__Fund_Transaction_Row__c();
        transRow.ACCL__Amount__c = amount;
        transRow.ACCL__Source_Fund__c = sourceFund;
        transRow.ACCL__Target_Fund__c = targetFund;
        transRow.ACCL__Fund_Transaction__c = transactionRecord;
        return transRow;
    }

    /**Method to show error message in controller
     *  @name showError 
     *  @param ApexPages.Severity severity,string eMsg
     *  @return void
     *  @throws Standard and Custom exceptions
     *  @author ankita.tukaram.parab@accenture.com
     */
    private void showError(ApexPages.Severity severity,string eMsg)
    {
        msgFlag= true;
        ApexPages.Message errorMsg= new ApexPages.Message(severity,eMsg); 
        ApexPages.addMessage(errorMsg);
    }
}