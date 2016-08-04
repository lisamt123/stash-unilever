<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_email_to_Vendor_Email</fullName>
        <description>Send email to Vendor Email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VPM_ApprovalEmails/VPM_Send_email_to_Vendor</template>
    </alerts>
    <alerts>
        <fullName>VPM_NotifiedBusinessRequesterRequestFLSTeam</fullName>
        <description>Notification to Business Requester that request has been rejected by FLSTeam</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VPM_ApprovalEmails/VPM_RequestRejectNotification</template>
    </alerts>
    <alerts>
        <fullName>VPM_NotifiedBusinessRequesterRequestFinanceTeam</fullName>
        <description>Notification to Business Requester that  request has been rejected by Finance Team</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VPM_ApprovalEmails/VPM_RequestRejectNotification</template>
    </alerts>
    <alerts>
        <fullName>VPM_NotifiedBusinessRequesterRequestProcurementTeam</fullName>
        <description>Notification to Business Requester that request has been rejected by ProcurementTeam</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VPM_ApprovalEmails/VPM_RequestRejectNotification</template>
    </alerts>
    <alerts>
        <fullName>VPM_RequestApprovalPending</fullName>
        <description>VPM - Used to send Notification to the Business Requestor  when the request is Approval Pending Status</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VPM_ApprovalEmails/VPM_RequestApprovalPendingNotification</template>
    </alerts>
    <alerts>
        <fullName>VPM_RequestRejectNotification</fullName>
        <description>VPM - Used to send Notification to the Business Requestor  when the request is rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VPM_ApprovalEmails/VPM_RequestRejectNotification</template>
    </alerts>
    <alerts>
        <fullName>VPM_RequestSubmittedForFLSRework</fullName>
        <description>VPM - Used to send Notification to the Business Requestor  when the request is send for Rework</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VPM_ApprovalEmails/VPM_RequestrequestingforRework</template>
    </alerts>
    <alerts>
        <fullName>VPM_RequestSubmittedForFLS_MDMOpsReviewNotification</fullName>
        <description>VPM - Used to send Notification to the Business Requestor  when the request is send for FLS /MDM Ops Review</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VPM_ApprovalEmails/VPM_RequestReviewNotification</template>
    </alerts>
    <fieldUpdates>
        <fullName>VPM_AssignRequestToMDMOps</fullName>
        <description>Assign request to MDM Ops</description>
        <field>OwnerId</field>
        <lookupValue>VPM_MDMOps</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign request to MDM Ops</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_BankDetails</fullName>
        <field>VPM_ProvidedBankDetails__c</field>
        <literalValue>1</literalValue>
        <name>VPM_BankDetails</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeOwnerToFLSQueue</fullName>
        <description>VPM - Sets the Owner as FLS Queue on entering approval process.</description>
        <field>OwnerId</field>
        <lookupValue>VPM_FLS</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Owner To FLS Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeOwnerToFinanceQueue</fullName>
        <description>VPM - Sets the Owner to Finance Queue on entering Approval Process</description>
        <field>OwnerId</field>
        <lookupValue>VPM_Finance</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Owner To Finance Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeOwnerToMDMOpsQueue</fullName>
        <description>VPM - Sets the Owner as MDM Ops Queue on entering approval process.</description>
        <field>OwnerId</field>
        <lookupValue>VPM_MDMOps</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Owner To MDM Ops Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeOwnerToProcurement_Queue</fullName>
        <description>VPM - Sets the Owner as Procurement Queue on entering Approval Process.</description>
        <field>OwnerId</field>
        <lookupValue>VPM_Procurement</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Owner To Procurement Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ClearApprovalWorkerID</fullName>
        <description>Sets the Approval Worker ID text field to blank</description>
        <field>VPM_Approval_Worker_ID__c</field>
        <name>VPM Clear Approval Worker ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ClearApprovalWorkerName</fullName>
        <description>Sets text field Approval Worker name to blank</description>
        <field>VPM_Approval_Worker__c</field>
        <name>VPM Clear Approval Worker Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_FinanceSubmittedYes</fullName>
        <description>VPM - Sets the Finance Submitted field to &apos;Yes&apos; to confirm Finance have finished their review. Triggers a process builder to handle different updates.</description>
        <field>VPM_FinanceSubmitted__c</field>
        <literalValue>Yes</literalValue>
        <name>Finance Submitted Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_MDMOPSSubmittedYes</fullName>
        <description>VPM - Sets the MDM Ops Submitted field to &apos;Yes&apos; to confirm MDM Ops have finished their review. Triggers a process builder to handle different updates.</description>
        <field>VPM_MDMOpsSubmitted__c</field>
        <literalValue>Yes</literalValue>
        <name>MDM OPS Submitted Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_PaymentTerms30DKDefault</fullName>
        <description>Sets default value of Payment Terms to 30DK</description>
        <field>VPM_PaymentTerms__c</field>
        <literalValue>30DK_Within 30 days Due net (30NET)</literalValue>
        <name>Payment Terms 30DK Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_PaymentTerms90DKDefault</fullName>
        <description>Sets Payment Terms to 90DK</description>
        <field>VPM_PaymentTerms__c</field>
        <literalValue>90DK_Within 90 days Due net (90NET)</literalValue>
        <name>Payment Terms 90DK Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_PaymentTermsP030Default</fullName>
        <description>Default payment terms for Sirius, U2K2 and Cordillera if Vendor is an SME</description>
        <field>VPM_PaymentTerms__c</field>
        <literalValue>P030_Within 30 days Due net (30NET)</literalValue>
        <name>Payment Terms P030 Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_PaymentTermsP090Default</fullName>
        <description>Sets Payment Terms to P090</description>
        <field>VPM_PaymentTerms__c</field>
        <literalValue>P090_Within 90 days Due net (90NET)</literalValue>
        <name>Payment Terms P090 Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_PaymentTermsS090Default</fullName>
        <description>Sets Payment terms to S090</description>
        <field>VPM_PaymentTerms__c</field>
        <literalValue>S090_Within 90 days Due net (90NET)</literalValue>
        <name>Payment Terms S090 Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ProcurementRejected</fullName>
        <description>VPM - Sets the Purchasing Request status to &apos;Procurement Rejected&apos; based on Procurement Rejection decision</description>
        <field>VPM_Status__c</field>
        <literalValue>Procurement Rejected</literalValue>
        <name>Status Procurement Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ProcurementSubmittedYes</fullName>
        <description>VPM - Sets the Procurement Submitted field to &apos;Yes&apos; to confirm Procurement have finished their review. Triggers a process builder to handle different updates.</description>
        <field>VPM_ProcurementSubmitted__c</field>
        <literalValue>Yes</literalValue>
        <name>Procurement Submitted Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_Provided</fullName>
        <field>VPM_ProvidedUnblockUndelete__c</field>
        <literalValue>1</literalValue>
        <name>VPM_ProvidedUnblockUndelete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ProvidedBlock_Delete</fullName>
        <field>VPM_ProvidedBlockDelete__c</field>
        <literalValue>1</literalValue>
        <name>VPM_ProvidedBlock/Delete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ProvidedFinancialSensitive</fullName>
        <field>VPM_ProvidedFinancialSensitive__c</field>
        <literalValue>1</literalValue>
        <name>VPM_ProvidedFinancialSensitive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ProvidedPaymentTerms</fullName>
        <field>VPM_ProvidedPaymentTerms__c</field>
        <literalValue>1</literalValue>
        <name>VPM_ProvidedPaymentTerms</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_RecordTypeVendorRequest</fullName>
        <description>Changes record type to Vendor Request, i.e. the default record type where a Vendor lookup has not yet been completed</description>
        <field>RecordTypeId</field>
        <lookupValue>VPM_VendorReq</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type Vendor Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_RequestGroupTime</fullName>
        <description>VPM - Time when it got assigned to group.</description>
        <field>VPM_RequestGroupTime__c</field>
        <formula>NOW()</formula>
        <name>VPM_RequestGroupTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_SearchTerm2Update</fullName>
        <field>VPM_SearchTerm2__c</field>
        <formula>IF( LEN( VPM_VendorName1__c) &gt;= 20 

,  RIGHT(LEFT(VPM_VendorName1__c, 20),10) 
,
 IF(LEN( VPM_VendorName1__c) &gt; 10 , 
RIGHT(VPM_VendorName1__c,LEN( VPM_VendorName1__c)-10)
,&apos;&apos;) 
)</formula>
        <name>VPM_Search Term 2 Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_SetPaymentTermsDefaultNonSME</fullName>
        <field>VPM_PaymentTerms__c</field>
        <name>VPM Set Payment Terms Default non SME</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>NextValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_SetPaymentTermsDefaultValuesSME</fullName>
        <description>Sets the 30 day limited payment term values if Vendor is an SME</description>
        <field>VPM_PaymentTerms__c</field>
        <name>VPM Set Payment Terms Default values SME</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>NextValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_Set_Email_Flag_to_No</fullName>
        <description>Resets the Flag once work flow rule has been fired</description>
        <field>VPM_VendordoesntExistFlag__c</field>
        <name>VPM Set Email Flag to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatusDraftRequest</fullName>
        <description>Sets the record status in the custom status field back to &apos;Draft Request&apos;</description>
        <field>VPM_Status__c</field>
        <literalValue>Draft Request</literalValue>
        <name>Status is Draft Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatusFLSApproved</fullName>
        <description>VPM - Sets the status of the record to FLS Approved based on an Approved decision.</description>
        <field>VPM_Status__c</field>
        <literalValue>FLS Approved</literalValue>
        <name>Status FLS Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatusFLSApproveds</fullName>
        <field>VPM_Status__c</field>
        <literalValue>FLS Approved</literalValue>
        <name>Status FLS Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatusFLSRejected</fullName>
        <description>VPM - Sets the Purchasing Request status to &apos;FLS Rejected&apos; based on FLS rejection decision</description>
        <field>VPM_Status__c</field>
        <literalValue>FLS Rejected</literalValue>
        <name>Status FLS Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatusFinanceApproved</fullName>
        <field>VPM_Status__c</field>
        <literalValue>Finance Approved</literalValue>
        <name>Status Finance Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatusFinanceRejected</fullName>
        <description>VPM - Sets the Purchasing Request status to &apos;Finance  Rejected&apos; based on Finance  Rejection decision</description>
        <field>VPM_Status__c</field>
        <literalValue>Finance Rejected</literalValue>
        <name>Status Finance Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatusMDMOpsReview</fullName>
        <description>Updates the record status to &apos;MDM Ops Review&apos;</description>
        <field>VPM_Status__c</field>
        <literalValue>MDM Ops Review</literalValue>
        <name>Status MDM Ops Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatusProcurementApproved</fullName>
        <description>VPM - Sets the Purchasing Request status to &apos;Procurement Approved &apos; based on Procurement Approval decision</description>
        <field>VPM_Status__c</field>
        <literalValue>Procurement Approved</literalValue>
        <name>Status Procurement Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_Status_Finance_Approved</fullName>
        <description>VPM - Sets the Purchasing Request status to &apos;Finance  Approved &apos; based on Finance  Approval decision</description>
        <field>VPM_Status__c</field>
        <literalValue>Finance Approved</literalValue>
        <name>Status Finance Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_UpdateOwner</fullName>
        <field>OwnerId</field>
        <lookupValue>VPM_MDMOps</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>VPM Update Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_UpdateRequestGroup</fullName>
        <description>VPM - Update request group to MDM Ops</description>
        <field>VPM_RequestLastWithGroup__c</field>
        <literalValue>Procurement</literalValue>
        <name>VPM_UpdateRequestGroup</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_UpdateSearchTerm1</fullName>
        <description>Updates Search Term 1 with the first 10 characters of Vendor Name</description>
        <field>VPM_SearchTerm_1__c</field>
        <formula>LEFT(VPM_VendorName1__c,10)</formula>
        <name>Update Search Term 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_UpdateStatusBPMSubmitFail</fullName>
        <description>VPM Update Status when BPM submit fails</description>
        <field>VPM_Status__c</field>
        <literalValue>MDM Ops Review - SAP BPM submit Failed</literalValue>
        <name>Update Status when BPM submit fails</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_UpdateStatusRejected</fullName>
        <field>VPM_Status__c</field>
        <literalValue>MDM Ops Review - SAP BPM Approval Rejected</literalValue>
        <name>VPM Update request status when rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_UpdateStatusToSubmitted</fullName>
        <field>VPM_Status__c</field>
        <literalValue>BPM Record Submitted</literalValue>
        <name>Update Request Status Submitted to BPM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Send Email Notification when status is FLS Requested Re-Work</fullName>
        <actions>
            <name>VPM_RequestSubmittedForFLSRework</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_Status__c</field>
            <operation>equals</operation>
            <value>FLS Requested Re-Work</value>
        </criteriaItems>
        <description>VPM  - Used to send notification to the Business Requester when Status Changes to FLS Requested Re-Work</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VPM Default Search Term 1 and 2</fullName>
        <actions>
            <name>VPM_SearchTerm2Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VPM_UpdateSearchTerm1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_Status__c</field>
            <operation>equals</operation>
            <value>Draft Request</value>
        </criteriaItems>
        <description>VPM - takes the value in the &apos;name&apos; field and uses it to default &apos;Search Term 1&apos; and &apos;Search Term 2&apos; in SAP</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VPM Default Value Payment Terms if Vendor is SME Fusion</fullName>
        <actions>
            <name>VPM_PaymentTerms30DKDefault</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>VPM - Used to set the Default Values for Payment Terms if Vendor is an SME is Yes in Fusion</description>
        <formula>ISCHANGED( VPM_IsVendorSME__c )
&amp;&amp;
ISPICKVAL(VPM_IsVendorSME__c,&quot;Yes&quot;)
&amp;&amp;
ISPICKVAL( VPM_ECC__c,&quot;Fusion&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VPM Default Value Payment Terms if Vendor is SME Sirius U2K2 Cordillera</fullName>
        <actions>
            <name>VPM_PaymentTermsP030Default</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>VPM - Used to set the Default Values for Payment Terms if Vendor is an SME is Yes in Sirius, U2K2 or Cordillera</description>
        <formula>ISCHANGED( VPM_IsVendorSME__c )
&amp;&amp;
ISPICKVAL(VPM_IsVendorSME__c,&quot;Yes&quot;)
&amp;&amp;
OR(
ISPICKVAL( VPM_ECC__c,&quot;Sirius&quot;),
ISPICKVAL( VPM_ECC__c,&quot;U2K2&quot;),
ISPICKVAL( VPM_ECC__c,&quot;Cordillera&quot;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VPM Default Value Payment Terms if Vendor not SME Fusion</fullName>
        <actions>
            <name>VPM_PaymentTerms90DKDefault</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>VPM - Used to set the Default Values for Payment Terms if Vendor is an SME is No in Fusion</description>
        <formula>ISPICKVAL(VPM_IsVendorSME__c,&quot;&quot;)
||
AND(
ISCHANGED(VPM_IsVendorSME__c),
ISPICKVAL(VPM_IsVendorSME__c,&quot;No&quot;)
)
&amp;&amp;
ISPICKVAL( VPM_ECC__c,&quot;Fusion&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VPM Default Value Payment Terms if Vendor not SME U2K2</fullName>
        <actions>
            <name>VPM_PaymentTermsS090Default</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>VPM - Used to set the Default Values for Payment Terms if Vendor is an SME is No in U2K2</description>
        <formula>ISPICKVAL(VPM_IsVendorSME__c,&quot;&quot;)
||
AND(
ISCHANGED(VPM_IsVendorSME__c),
ISPICKVAL(VPM_IsVendorSME__c,&quot;No&quot;)
)
&amp;&amp;
ISPICKVAL( VPM_ECC__c,&quot;U2K2&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VPM Send email to Vendor</fullName>
        <actions>
            <name>Send_email_to_Vendor_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>VPM_Set_Email_Flag_to_No</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_VendordoesntExistFlag__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Sends email to Vendor with Webform details</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VPM Update Salesforce Request Submitted to MDM</fullName>
        <actions>
            <name>VPM_UpdateStatusToSubmitted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_MDMInsertUpdateStatus__c</field>
            <operation>equals</operation>
            <value>Submitted to BPM</value>
        </criteriaItems>
        <description>Update Salesforce status depending on MDM service call</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VPM Update Salesforce when request fails to submit to BPM</fullName>
        <actions>
            <name>VPM_AssignRequestToMDMOps</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VPM_UpdateStatusBPMSubmitFail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_MDMInsertUpdateStatus__c</field>
            <operation>equals</operation>
            <value>Failed to Submit to BPM</value>
        </criteriaItems>
        <description>Update status field in salesforce depending on MDM service call</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VPM Update salesforce when request gets rejected at BPM</fullName>
        <actions>
            <name>VPM_AssignRequestToMDMOps</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VPM_UpdateStatusRejected</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_MDMInsertUpdateStatus__c</field>
            <operation>equals</operation>
            <value>Approval Rejected in BPM</value>
        </criteriaItems>
        <description>Update salesforce record depending on MDM service call</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VPM_ResetValuesOnCreate</fullName>
        <actions>
            <name>VPM_ChangeReworkStatusNo</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VPM_ChangesIslockStatusNo</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VPM_RecordTypeVendorRequest</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VPM_StatusDraftRequest</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Resets certain system values in picklists and fields on create to ensure the request is considered as a new request if it is cloned from a different request</description>
        <formula>True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
