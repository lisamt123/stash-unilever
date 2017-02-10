<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>VPM_EmailForRework</fullName>
        <description>VPM- Email For rework</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_RequestrequestingforRework</template>
    </alerts>
    <alerts>
        <fullName>VPM_EmailRequestCompleted</fullName>
        <description>VPM- Email for request completed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>VPM_MDMOpsEmail__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_Requesthasbeencompleted</template>
    </alerts>
    <alerts>
        <fullName>VPM_MDMRequestSubmitted</fullName>
        <description>VPM - Used to send Notification to the Business Requestor when the request (Bloc/Delete) is submitted manually</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_Requesthasbeencompleted</template>
    </alerts>
    <alerts>
        <fullName>VPM_NotificationForLogged</fullName>
        <description>VPM - Notification For Logged</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_Requesthasbeenlogged</template>
    </alerts>
    <alerts>
        <fullName>VPM_RequestAbortedNotification</fullName>
        <description>VPM - Used to send an email to the creator when a request has been Aborted.</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_RequestHasBeenAborted</template>
    </alerts>
    <alerts>
        <fullName>VPM_RequestApprovalPending</fullName>
        <description>VPM - Used to send Notification to the Business Requestor  when the request is Approval Pending Status</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_RequestApprovalPendingNotification</template>
    </alerts>
    <alerts>
        <fullName>VPM_RequestRejectMDMNotification</fullName>
        <description>VPM - Used to send Notification to the MDM Ops  when the request is rejected</description>
        <protected>false</protected>
        <recipients>
            <field>VPM_MDMOpsEmail__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_SAPBPMRejected</template>
    </alerts>
    <alerts>
        <fullName>VPM_RequestRejectNotification</fullName>
        <description>VPM - Used to send Notification to the Business Requestor  when the request is rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_RequestRejectNotification</template>
    </alerts>
    <alerts>
        <fullName>VPM_RequestSubmittedForFLSRework</fullName>
        <description>VPM Not Used- Used to send Notification to the Business Requestor  when the request is send for Rework</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_RequestrequestingforRework</template>
    </alerts>
    <alerts>
        <fullName>VPM_RequestSubmittedForFLS_MDMOpsReviewNotification</fullName>
        <description>VPM - Used to send Notification to the Business Requestor  when the request is send for FLS /MDM Ops Review</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_RequestReviewNotification</template>
    </alerts>
    <alerts>
        <fullName>VPM_RequestforUsertoCompleteVendorRequestSurvey</fullName>
        <description>Request for User to Complete Vendor Request Survey</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_UserSurveyRequest</template>
    </alerts>
    <alerts>
        <fullName>VPM_RequesthasbeenloggedMDM</fullName>
        <description>VPM_RequesthasbeenloggedMDM</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_RequesthasbeenloggedMDM</template>
    </alerts>
    <alerts>
        <fullName>VPM_ReworkNotification</fullName>
        <description>VPM - Used to send Notification to the Business Requestor when the request is send for Rework</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_RequestrequestingforRework</template>
    </alerts>
    <alerts>
        <fullName>VPM_SendEmailToRequestorAfterWebformUpdate</fullName>
        <description>VPM Send Email to Requestor After Webform Update</description>
        <protected>false</protected>
        <recipients>
            <field>VPM_EmailOfWebformSender__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_EmailForRequestorAfterWebformUpdate</template>
    </alerts>
    <alerts>
        <fullName>VPM_SendEmailToRequestorBeforeWebformUpdate</fullName>
        <description>VPM Send Email to Requestor Before Webform Update</description>
        <protected>false</protected>
        <recipients>
            <field>VPM_EmailOfWebformSender__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_EmailForRequestorBeforeWebformUpdate</template>
    </alerts>
    <alerts>
        <fullName>VPM_SendEmailToVendorEmail</fullName>
        <description>VPM Send email to Vendor Email</description>
        <protected>false</protected>
        <recipients>
            <field>VPM_VendorContactDetail__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_RequestVendorDetails</template>
    </alerts>
    <fieldUpdates>
        <fullName>VPM_ApprovalStatusAproval</fullName>
        <description>VPM - Used to Set the status as &quot;Approved&quot; when the request is Approved by the team</description>
        <field>VPM_ApprovalStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>VPM - Approval Status Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ApprovalStatusPending</fullName>
        <description>Update the Approval Status to Pending</description>
        <field>VPM_ApprovalStatus__c</field>
        <literalValue>Pending</literalValue>
        <name>VPM - Approval Status Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ApprovalStatusRejection</fullName>
        <description>VPM - Used to set the flag as &quot;Reject&quot;</description>
        <field>VPM_ApprovalStatus__c</field>
        <literalValue>Rejected</literalValue>
        <name>VPM - Approval Status Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ApprovedByBankValidationEmail</fullName>
        <description>VPM - captures the email of bank Validation Approver.</description>
        <field>VPM_BankValidationApprovedByEmail__c</field>
        <formula>$User.Email</formula>
        <name>VPM - Approved By Bank Validation Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ApprovedByFLSEmail</fullName>
        <description>VPM - captures the email of FLS approver.</description>
        <field>VPM_FLSApprovedByEmail__c</field>
        <formula>$User.Email</formula>
        <name>VPM - Approved By FLS Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ApprovedByFinanceEmail</fullName>
        <description>VPM - captures the emial of approver user.</description>
        <field>VPM_FinanceApprovedByEmail__c</field>
        <formula>$User.Email</formula>
        <name>VPM - Approved By Finance Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ApprovedByFreightEmail</fullName>
        <description>VPM - captures the email of freight approver.</description>
        <field>VPM_FreightApprovedByEmail__c</field>
        <formula>$User.Email</formula>
        <name>VPM-Approved By Freight Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ApprovedByMasterDataEmail</fullName>
        <description>VPM- captures the email of Master data approver.</description>
        <field>VPM_MasterDataApprovedByEmail__c</field>
        <formula>$User.Email</formula>
        <name>VPM-Approved By Master Data Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ApprovedByProcurementEmail</fullName>
        <description>VPM - captures the email of approved by User</description>
        <field>VPM_ProcurementApprovedByEmail__c</field>
        <formula>$User.Email</formula>
        <name>VPM-Approved By Procurement Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ApprovedByRussianEmail</fullName>
        <description>VPM - Captures the approver email.</description>
        <field>VPM_RussainCustomTaxApprovedByEmail__c</field>
        <formula>$User.Email</formula>
        <name>VPM-Approved By Russian Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ApprovedTime</fullName>
        <description>VPM- Time the Request is Approved by the group.</description>
        <field>VPM_ProcurementApproval__c</field>
        <formula>NOW()</formula>
        <name>VPM - Approved Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_AssigntoRussian</fullName>
        <description>VPM - Used to set the Owner as &quot;Russian Queue&quot;</description>
        <field>OwnerId</field>
        <lookupValue>VPM_RussianCustomTax</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>VPM - Assign to Russian</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_BankApprovedTime</fullName>
        <description>VPM - time when the bank Validator approves the request.</description>
        <field>VPM_BankValidatorApproval__c</field>
        <formula>NOW()</formula>
        <name>Bank Approved Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_BankReworks</fullName>
        <description>VPM -used to track no of times bank sends for rework</description>
        <field>VPM_BankValidatorReworks__c</field>
        <formula>VPM_BankValidatorReworks__c  + 1</formula>
        <name>Bank Reworks</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeAdvanceFormSubmittedtonull</fullName>
        <description>VPM - Reset Advance form Submitted Flag</description>
        <field>VPM_AdvancedFormSubmitted__c</field>
        <name>VPM - Change Adv Form Submitted  null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeBusinessRequestorFlagtoNull</fullName>
        <description>VPM - Reset the Business Requester Submitted Flag to Null</description>
        <field>VPM_BusinessRequestorSubmitted__c</field>
        <name>VPM - Change BusinessReqFlag to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeIsInApprovalProcess</fullName>
        <description>VPM - Used to set the Is In Approval Process Flag as &quot;Approval Compeleted&quot;</description>
        <field>VPM_IsInApprovalProcess__c</field>
        <literalValue>Approval Completed</literalValue>
        <name>VPM - Change IsInApprovalPro To Complet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeIsinApprovalStatus</fullName>
        <description>VPM - Used as Flag which will set the Is In Approved Values &amp; these field is used in PB</description>
        <field>VPM_IsInApprovalProcess__c</field>
        <literalValue>In Approval Process</literalValue>
        <name>VPM - Change IsinApproval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeOwnerIdtoMDMOpsQueue</fullName>
        <description>VPM - Update  Owner Id field to MDM Ops Queue when the status of request is MDM Ops Review</description>
        <field>OwnerId</field>
        <lookupValue>VPM_MDMOps</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change the Owner Id to MDM Ops Queue</name>
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
        <fullName>VPM_ChangeOwnerToFreightQueue</fullName>
        <description>VPM - Sets the Owner as Freight Queue on entering approval process.</description>
        <field>OwnerId</field>
        <lookupValue>VPM_Freight</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>VPM - Change Owner To Freight Queue</name>
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
        <name>VPM - Change Owner To Procurement Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeOwnerToRussianCustomTax</fullName>
        <description>VPM - Change Owner to Russian Custom Tax</description>
        <field>OwnerId</field>
        <lookupValue>VPM_RussianCustomTax</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Owner to Russian Custom Tax</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeOwnertoECCQueue</fullName>
        <description>VPM - Used to set the Owner as &quot;ECC queue&quot;</description>
        <field>OwnerId</field>
        <lookupValue>VPM_ECCQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>VPM - Change Owner to ECC Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeReworkStatusNo</fullName>
        <description>VPM - Used to set Rework Flag as &quot;No&quot;</description>
        <field>VPM_Rework__c</field>
        <literalValue>No</literalValue>
        <name>VPM - Change Rework Status to No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeStatusBankApproved</fullName>
        <description>VPM -  Used to reset the status as &quot;Bank Data Validation Approved &quot; when the request is approved by Bank Data team</description>
        <field>VPM_Status__c</field>
        <literalValue>Bank Data Validation Approved</literalValue>
        <name>VPM - Change Status Bank Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeStatusMDMApproved</fullName>
        <description>VPM  -  Set the status as Local MDM Approved</description>
        <field>VPM_Status__c</field>
        <literalValue>Master Data Management Approved</literalValue>
        <name>VPM - Change Status MDM Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeStatusToFreightReject</fullName>
        <description>VPM - Used to Set the status as &quot;Freight Reject&quot; when the request get rejected</description>
        <field>VPM_Status__c</field>
        <literalValue>Freight Rejected</literalValue>
        <name>VPM - Change Status To Freight Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeStatustoFLSreview</fullName>
        <description>VPM - Used to set the status as &quot;FLS Review&quot;</description>
        <field>VPM_Status__c</field>
        <literalValue>FLS Review</literalValue>
        <name>VPM - Change Status to FLS review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangelastGroupwithFLS</fullName>
        <description>VPM - Used to set Last Group so that it will be used in Reporting</description>
        <field>VPM_RequestLastWithGroup__c</field>
        <literalValue>FLS</literalValue>
        <name>VPM - Change last Group with FLS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangesIslockStatusNo</fullName>
        <description>VPM - Set the islock flaf to false when the record ia Approve/reject/recall</description>
        <field>VPM_IsLock__c</field>
        <literalValue>0</literalValue>
        <name>VPM - Changes Is lock Status to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangesStatusFinanceApproved</fullName>
        <description>VPM - Used to set the status as &quot;Finance Approved &quot; when the request is approved by the Finance Team</description>
        <field>VPM_Status__c</field>
        <literalValue>Finance Approved</literalValue>
        <name>VPM - Changes Status Finance Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangesStatusFreightApproved</fullName>
        <description>VPM - Used to set the status as &quot;Freight Approved&quot; when the request is Approved by Freight team</description>
        <field>VPM_Status__c</field>
        <literalValue>Freight Approved</literalValue>
        <name>VPM - Changes Status Freight Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangesStatusProcurementApprove</fullName>
        <description>VPM - Used to set the status as &quot;Procurement Approved&quot; when the Procurement Team approved the Request</description>
        <field>VPM_Status__c</field>
        <literalValue>Procurement Approved</literalValue>
        <name>VPM - Changes Status Procurement Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangesStatusRussianApprove</fullName>
        <description>VPM - Used to set the status as &quot;Russian Approved &quot; when the Request is approved by Russian Team member</description>
        <field>VPM_Status__c</field>
        <literalValue>Russian Custom Tax Approved</literalValue>
        <name>VPM - Changes Status Russian Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ClearApprovalWorkerID</fullName>
        <description>VPM  - Sets the Approval Worker ID text field to blank</description>
        <field>VPM_ApprovalWorkerID__c</field>
        <name>VPM - Clear Approval Worker ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ClearApprovalWorkerName</fullName>
        <description>VPM - Sets text field Approval Worker name to blank</description>
        <field>VPM_ApprovalWorker__c</field>
        <name>VPM -  Clear Approval Worker Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ECCSubmittedToYes</fullName>
        <description>VPM - Used to set falg which will indicate the Bank Approved has approved the request</description>
        <field>VPM_BankDataValidationSubmitted__c</field>
        <literalValue>Yes</literalValue>
        <name>VPM - Status Bank Data Submitted To Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_Email_of_Webform_Sender</fullName>
        <description>VPM - Sends email to Vendor with Webform details</description>
        <field>VPM_EmailOfWebformSender__c</field>
        <formula>$User.Email</formula>
        <name>Email of Webform Sender</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_FLSApprovedTime</fullName>
        <description>VPM- Time when the FLS approves the request.</description>
        <field>VPM_FLSApproval__c</field>
        <formula>NOW()</formula>
        <name>FLS Approved Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_FLSReworks</fullName>
        <description>VPM - used to track no of times FLS sends for rework</description>
        <field>VPM_FLSReworks__c</field>
        <formula>VPM_FLSReworks__c  + 1</formula>
        <name>FLS Reworks</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_FinanceApprovedTime</fullName>
        <description>VPM- Time when the finance approves the request.</description>
        <field>VPM_FinanceApproval__c</field>
        <formula>NOW()</formula>
        <name>Finance Approved Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_FinanceReworks</fullName>
        <description>VPM - no of times Finance sends to reworl</description>
        <field>VPM_FinanceReworls__c</field>
        <formula>VPM_FinanceReworls__c  + 1</formula>
        <name>Finance Reworks</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_FinanceSubmittedYes</fullName>
        <description>VPM - Sets the Finance Submitted field to &apos;Yes&apos; to confirm Finance have finished their review. Triggers a process builder to handle different updates.</description>
        <field>VPM_FinanceSubmitted__c</field>
        <literalValue>Yes</literalValue>
        <name>VPM - Finance Submitted Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_FreightApprovedTime</fullName>
        <description>VPM - Time when the freight approves the request.</description>
        <field>VPM_FreightApproval__c</field>
        <formula>NOW()</formula>
        <name>Freight Approved Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_FreightApprovedYes</fullName>
        <description>VPM  - Used as Flag which will denote as &quot;Freight&quot; has Approved the request</description>
        <field>VPM_FreightSubmitted__c</field>
        <literalValue>Yes</literalValue>
        <name>VPM - Freight Approved Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_FreightReworks</fullName>
        <description>VPM - used to track number of timed Freight sends to rework</description>
        <field>VPM_FreightReworks__c</field>
        <formula>VPM_FreightReworks__c  + 1</formula>
        <name>Freight Reworks</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_HoursSpentWithRussian_Custom</fullName>
        <description>VPM - To calculate total no. of hours request was with Russian Custom tax  queue</description>
        <field>VPM_HoursSpentWithRussianCustomTax__c</field>
        <formula>VPM_HoursSpentWithRussianCustomTax__c  + IF(VPM_NoOfDays__c&gt; 0  ,((VPM_NoOfDays__c-1)*24) 

+(VALUE(TEXT((VALUE(LEFT(MID ( TEXT (NOW()), 12, 5), FIND(&apos;:&apos;, MID ( TEXT (NOW()), 12, 5))-1)) 
+ 
VALUE( 
RIGHT(MID ( TEXT (NOW()), 12, 5), FIND(&apos;:&apos;, MID ( TEXT (NOW()), 12, 5))-1))/60) 
- 
(VALUE(LEFT(MID ( TEXT (VPM_RequestGroupTime__c), 12, 5), FIND(&apos;:&apos;, MID ( TEXT (VPM_RequestGroupTime__c), 12, 5))-1)) 
+ 
VALUE( 
RIGHT(MID ( TEXT (VPM_RequestGroupTime__c), 12, 5), FIND(&apos;:&apos;, MID ( TEXT (VPM_RequestGroupTime__c), 12, 5))-1))/60)) )) ,
( NOW() - VPM_RequestGroupTime__c) *24 )</formula>
        <name>Hours Spent With Russian Custom</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_IsInApprovalProcessBlank</fullName>
        <description>VPM - Resets is in approval process to blank on recall</description>
        <field>VPM_IsInApprovalProcess__c</field>
        <name>VPM - Is in Approval Process Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_IsLockTrue</fullName>
        <description>VPM - set a Flag which is used for check the request is in Approval or Not</description>
        <field>VPM_IsLock__c</field>
        <literalValue>1</literalValue>
        <name>VPM - Change IsLockTrue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_MDMSubmittedYes</fullName>
        <description>VPM - Set the flag as &quot;Yes&quot; the Local MDM submitted the request</description>
        <field>VPM_MasterDataManagementSubmitted__c</field>
        <literalValue>Yes</literalValue>
        <name>VPM - MDM Submitted Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_MasterDataManagementApprovedTime</fullName>
        <description>VPM- Time the Request is Approved by the group.</description>
        <field>VPM_MasterDataManagementApproval__c</field>
        <formula>NOW()</formula>
        <name>Master Data Management Approved Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_NextApproveNameRussian</fullName>
        <description>VPM - Used to set the Next Approval Name so that it can be used in Email Templates</description>
        <field>VPM_Set_Approver_Name__c</field>
        <literalValue>Russian User</literalValue>
        <name>VPM - Next Approve Name Russian</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_NextApproverNameBank</fullName>
        <description>VPM Update the VPM Set Approver Name To Bank user</description>
        <field>VPM_Set_Approver_Name__c</field>
        <literalValue>Bank user</literalValue>
        <name>VPM - Next Approver Name Bank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_NextApproverNameFLS</fullName>
        <description>VPM - Used to set the Next Approval so that it can be used in Email Template</description>
        <field>VPM_Set_Approver_Name__c</field>
        <literalValue>FLS User</literalValue>
        <name>VPM - Next Approver Name FLS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_NextApproverNameFin</fullName>
        <description>VPM - Used to set the Next Approval Name so that it can be used in ermail Alert</description>
        <field>VPM_Set_Approver_Name__c</field>
        <literalValue>Finance User</literalValue>
        <name>VPM - Next Approver NameFinance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_NextApproverNameFreight</fullName>
        <description>VPM - Used to Set the Next Approval Name which will be used in Email Template</description>
        <field>VPM_Set_Approver_Name__c</field>
        <literalValue>Freight User</literalValue>
        <name>VPM - Next Approver Nam eFreight</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_NextApproverNameMDMOps</fullName>
        <description>VPM update Vendor Request: VPM Set Approver Name to MDM Ops User</description>
        <field>VPM_Set_Approver_Name__c</field>
        <literalValue>MDM Ops User</literalValue>
        <name>VPM - Next Approver Name MDM Ops</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_NextApproverNameProcurement</fullName>
        <description>VPM - Used to set the approval Name as &quot;Procurement User &quot; which is used in  Email Template</description>
        <field>VPM_Set_Approver_Name__c</field>
        <literalValue>Procurement User</literalValue>
        <name>VPM  - Next Approver Name Procurement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ProcurementRejected</fullName>
        <description>VPM - Sets the Purchasing Request status to &apos;Procurement Rejected&apos; based on Procurement Rejection decision</description>
        <field>VPM_Status__c</field>
        <literalValue>Procurement Rejected</literalValue>
        <name>VPM - Status Procurement Rejected</name>
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
        <name>VPM - Procurement Submitted Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_RecordTypeVendorRequest</fullName>
        <description>VPM - Changes record type to Vendor Request, i.e. the default record type where a Vendor lookup has not yet been completed</description>
        <field>RecordTypeId</field>
        <lookupValue>VPM_VendorReq</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>VPM - Record Type Vendor Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_RegionForWFR12</fullName>
        <description>Updates the &apos;Reporting Region&apos; field with the value of one of the following Europe, North America, Latin America, South East Asia &amp; Australia, Africa</description>
        <field>VPM_ReportingRegion__c</field>
        <formula>CASE(VPM_CountryRequestingVendor__c,
	&quot;Austria&quot;,&quot;Europe&quot;,
	&quot;Belgium&quot;,&quot;Europe&quot;,
	&quot;Bulgaria&quot;,&quot;Europe&quot;,
	&quot;Czech Republic&quot;,&quot;Europe&quot;,
	&quot;Denmark&quot;,&quot;Europe&quot;,
	&quot;Estonia&quot;,&quot;Europe&quot;,
	&quot;Finland&quot;,&quot;Europe&quot;,
	&quot;France&quot;,&quot;Europe&quot;,
	&quot;Greece&quot;,&quot;Europe&quot;,
	&quot;Hungary&quot;,&quot;Europe&quot;,
	&quot;Ireland&quot;,&quot;Europe&quot;,
	&quot;Italy&quot;,&quot;Europe&quot;,
	&quot;Netherlands&quot;,&quot;Europe&quot;,
	&quot;Norway&quot;,&quot;Europe&quot;,
	&quot;Poland&quot;,&quot;Europe&quot;,
	&quot;Romania&quot;,&quot;Europe&quot;,
	&quot;Serbia&quot;,&quot;Europe&quot;,
	&quot;Slovakia&quot;,&quot;Europe&quot;,
	&quot;Spain&quot;,&quot;Europe&quot;,
	&quot;Switzerland&quot;,&quot;Europe&quot;,
	&quot;Sweden&quot;,&quot;Europe&quot;,
	&quot;United Kingdom&quot;,&quot;Europe&quot;,
	&quot;USA&quot;,&quot;North America&quot;,
	&quot;Canada&quot;,&quot;North America&quot;,
	&quot;Peru&quot;,&quot;Latin America&quot;,
	&quot;Brazil&quot;,&quot;Latin America&quot;,
	&quot;Mexico&quot;,&quot;Latin America&quot;,
	&quot;El Salvador&quot;,&quot;Latin America&quot;,
	&quot;Guatemala&quot;,&quot;Latin America&quot;,
	&quot;Colombia&quot;,&quot;Latin America&quot;,
	&quot;Ecuador&quot;,&quot;Latin America&quot;,
	&quot;Dominican Rep.&quot;,&quot;Latin America&quot;,
	&quot;Argentina&quot;,&quot;Latin America&quot;,
	&quot;Nicaragua&quot;,&quot;Latin America&quot;,
	&quot;Trinidad,Tobago&quot;,&quot;Latin America&quot;,
	&quot;Costa Rica&quot;,&quot;Latin America&quot;,
	&quot;Honduras&quot;,&quot;Latin America&quot;,
	&quot;Venezuela&quot;,&quot;Latin America&quot;,
	&quot;Chile&quot;,&quot;Latin America&quot;,
	&quot;Paraguay&quot;,&quot;Latin America&quot;,
	&quot;Panama&quot;,&quot;Latin America&quot;,
	&quot;Uruguay&quot;,&quot;Latin America&quot;,
	&quot;Thailand&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;Australia&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;Singapore&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;Myanmar&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;Philippines&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;Indonesia&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;New Zealand&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;Vietnam&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;Cambodia&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;Zambia&quot;,&quot;Africa&quot;,
	&quot;Kenya&quot;,&quot;Africa&quot;,
	&quot;Malawi&quot;,&quot;Africa&quot;,
	&quot;Uganda&quot;,&quot;Africa&quot;,
	&quot;Zimbabwe&quot;,&quot;Africa&quot;,
	&quot;Ivory Coast&quot;,&quot;Africa&quot;,
	&quot;Nigeria&quot;,&quot;Africa&quot;,
	&quot;Mozambique&quot;,&quot;Africa&quot;,
	&quot;South Africa&quot;,&quot;Africa&quot;,
	&quot;Ghana&quot;,&quot;Africa&quot;,
	&quot;Ethiopia&quot;,&quot;Africa&quot;,
	&quot;Tanzania&quot;,&quot;Africa&quot;, 
	&quot;Dijbouti&quot;,&quot;Africa&quot;,

NULL)</formula>
        <name>Region for WFR 1/2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_RegionForWFR22</fullName>
        <description>Updates the &apos;Reporting Region&apos; field with the value of one of the following South Asia, North Asia, NAMET RUB, Fusion</description>
        <field>VPM_ReportingRegion__c</field>
        <formula>CASE(VPM_CountryRequestingVendor__c, 
&quot;Pakistan&quot;,&quot;South Asia&quot;, 
&quot;Bangladesh&quot;,&quot;South Asia&quot;, 
&quot;China&quot;,&quot;South Asia&quot;, 
&quot;Japan&quot;,&quot;South Asia&quot;, 
&quot;Taiwan&quot;,&quot;South Asia&quot;, 
&quot;Hong Kong&quot;,&quot;South Asia&quot;, 
&quot;Iran&quot;,&quot;NAMET RUB&quot;, 
&quot;Algeria&quot;,&quot;NAMET RUB&quot;, 
&quot;Egypt&quot;,&quot;NAMET RUB&quot;, 
&quot;Saudi Arabia&quot;,&quot;NAMET RUB&quot;, 
&quot;Tunisia&quot;,&quot;NAMET RUB&quot;, 
&quot;Utd.Arab Emir&quot;,&quot;NAMET RUB&quot;, 
&quot;Russian Fed.&quot;,&quot;NAMET RUB&quot;, 
&quot;Kazakhstan&quot;,&quot;NAMET RUB&quot;,
&quot;Ukraine&quot;,&quot;NAMET RUB&quot;,
&quot;Morocco&quot;,&quot;NAMET RUB&quot;,
&quot;Israel&quot;,&quot;NAMET RUB&quot;, 
&quot;Turkey&quot;,&quot;NAMET RUB&quot;, 
&quot;Bahrain&quot;,&quot;NAMET RUB&quot;, 
&quot;Oman&quot;,&quot;NAMET RUB&quot;, 
&quot;India&quot;,&quot;Fusion&quot;, 
&quot;Nepal&quot;,&quot;Fusion&quot;, 
&quot;Sri Lanka&quot;,&quot;Fusion&quot;,
NULL)</formula>
        <name>Region for WFR 2/2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_RejectedByEmail</fullName>
        <description>VPM - captures the email of approver</description>
        <field>VPM_RejectedByEmail__c</field>
        <formula>$User.Email</formula>
        <name>VPM-Rejected By Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
        <fullName>VPM_RequestLastwithGroupFLS</fullName>
        <description>VPM - USed to set the Request Last with . which will be used in Report</description>
        <field>VPM_RequestLastWithGroup__c</field>
        <literalValue>FLS</literalValue>
        <name>VPM - Request Last with Group FLS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_RequestLastwithGroupFreight</fullName>
        <description>VPM - USed to set the Request Last with . which will be used in Report</description>
        <field>VPM_RequestLastWithGroup__c</field>
        <literalValue>Freight</literalValue>
        <name>VPM - Request Last with Group Freight</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_RequestLastwithGroupRussianCustom</fullName>
        <description>VPM - Used to Set the Last Request Last with which is used in Reporting</description>
        <field>VPM_RequestLastWithGroup__c</field>
        <literalValue>Russian Custom Tax</literalValue>
        <name>VPM - Req Last with Grp Russian</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ResetBankApprovalflag</fullName>
        <description>VPM - Used to reset the  Bank Approval flag</description>
        <field>VPM_BankDataValidationRequired__c</field>
        <literalValue>0</literalValue>
        <name>VPM - Reset Bank Approval flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ResetFinanceApprovalflag</fullName>
        <description>VPM - Used to reset the Finance Required flag when the Request is recall</description>
        <field>VPM_FinanceApprovalRequired__c</field>
        <literalValue>0</literalValue>
        <name>VPM - Reset Finance Approval Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ResetFreightApprovalflag</fullName>
        <description>VPM - Used to reset the flag which is used to indicate whether the procurement Approval required</description>
        <field>VPM_FreightApprovalRequired__c</field>
        <literalValue>0</literalValue>
        <name>VPM - Reset Freight Approval flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ResetProcurementApprovalflag</fullName>
        <description>VPM - Used to reset the Procurement Required flag when the Request is recall</description>
        <field>VPM_ProcurementApprovalRequired__c</field>
        <literalValue>0</literalValue>
        <name>VPM - Reset Procurement Approval flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ResetRussianApprovalflag</fullName>
        <description>VPM - Used to Reset the Flag which is indication whether the Russian Approval is required or not</description>
        <field>VPM_RussianTaxApprovalRequired__c</field>
        <literalValue>0</literalValue>
        <name>VPM - Reset Russian Approval flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_RussiaApprovedSubmittedtoYes</fullName>
        <description>VPM - Used to Set the Flag which will Russian has Approved the request</description>
        <field>VPM_RussiaSubmitted__c</field>
        <literalValue>Yes</literalValue>
        <name>VPM - Russia Approved to yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_RussianApprovedTime</fullName>
        <description>VPM- Time whent he Russian Custom tax approves the request.</description>
        <field>VPM_RussianCustomsTaxApporval__c</field>
        <formula>NOW()</formula>
        <name>Russian Approved Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_RussianReworks</fullName>
        <description>VPM - used to track no of time russian custom tax sends for rework</description>
        <field>VPM_RussianCustomTaxReworks__c</field>
        <formula>VPM_RussianCustomTaxReworks__c  + 1</formula>
        <name>Russian Reworks</name>
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
        <description>VPM - Sets the 30 day limited payment term values if Vendor is an SME</description>
        <field>VPM_PaymentTerms__c</field>
        <name>VPM Set Payment Terms Default values SME</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>NextValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_Set_Email_Flag_to_No</fullName>
        <description>VPM - Resets the Flag once work flow rule has been fired</description>
        <field>VPM_VendordoesntExistFlag__c</field>
        <name>VPM Set Email Flag to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatusDraftRequest</fullName>
        <description>VPM - Sets the record status in the custom status field back to &apos;Draft Request&apos;</description>
        <field>VPM_Status__c</field>
        <literalValue>Draft Request</literalValue>
        <name>VPM - Status is Draft Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatusECCRejected</fullName>
        <description>VPM - Used to set te Status as &quot;ECC Rejectd &quot;</description>
        <field>VPM_Status__c</field>
        <literalValue>Bank Data Validation Rejected</literalValue>
        <name>VPM - Status Bank Data Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatusFLSApproveds</fullName>
        <description>VPM-  Used to set the Status as &quot;FLS Approvved &quot;</description>
        <field>VPM_Status__c</field>
        <literalValue>FLS Approved</literalValue>
        <name>VPM - Status FLS Approved</name>
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
        <name>VPM - Status FLS Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatusFinanceRejected</fullName>
        <description>VPM - Sets the Purchasing Request status to &apos;Finance  Rejected&apos; based on Finance  Rejection decision</description>
        <field>VPM_Status__c</field>
        <literalValue>Finance Rejected</literalValue>
        <name>VPM - Status Finance Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatusMDMRejected</fullName>
        <description>VPM - Used to set the status as &quot;Rejected&quot; when local MDM rejected Request</description>
        <field>VPM_Status__c</field>
        <literalValue>Master Data Management Rejected</literalValue>
        <name>VPM - Status MDM Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatusRussianCustomTaxRejected</fullName>
        <description>VPM - Sets the Purchasing Request status to &apos;Russian Custom Tax Rejected&apos; based on Russian Custom Tax rejection decision</description>
        <field>VPM_Status__c</field>
        <literalValue>Russian Custom Tax Rejected</literalValue>
        <name>VPM - Status Russian Custom Tax Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatustoApprovalPending</fullName>
        <description>VPM - Used to set the Status as &quot;Approval Pending&quot;</description>
        <field>VPM_Status__c</field>
        <literalValue>Approval Pending</literalValue>
        <name>VPM - Status to Approval Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_SubmissiontoFLSTime</fullName>
        <description>VPM -  Time when the Request is submitted to FLS queue.</description>
        <field>VPM_SubmissionToFLS__c</field>
        <formula>NOW()</formula>
        <name>Submission to FLS Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_UpdateOwner</fullName>
        <description>VPM - Update the Vendor Request: Owner To MDM Ops Queue</description>
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
        <name>VPM - UpdateRequestGroup</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_UpdateStatusBPMSubmitFail</fullName>
        <description>VPM - Update Status when BPM submit fails</description>
        <field>VPM_Status__c</field>
        <literalValue>MDM Ops Review - SAP BPM submit Failed</literalValue>
        <name>Update Status when BPM submit fails</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_UpdateStatusField</fullName>
        <description>VPM - Set Status field to Draft Request on create</description>
        <field>VPM_Status__c</field>
        <literalValue>Draft Request</literalValue>
        <name>VPM - Update Status Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_UpdateStatusRejected</fullName>
        <description>VPM - Update the Vendor Request: Status to None</description>
        <field>VPM_Status__c</field>
        <name>VPM Update request status when rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_Webform_sent_to_Vendor</fullName>
        <description>VPM - Update the Vendor Request: Webform sent to Vendor To True</description>
        <field>VPM_WebformSentToVendor__c</field>
        <literalValue>1</literalValue>
        <name>Webform sent to Vendor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Change the Owner Id to MDM Ops Queue</fullName>
        <actions>
            <name>VPM_ChangeOwnerIdtoMDMOpsQueue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_Status__c</field>
            <operation>contains</operation>
            <value>MDM Ops</value>
        </criteriaItems>
        <description>VPM - Used to update the Owner id to MDM Ops Queues  when the request is under MDM Team for Review</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VPM Email to Requestor After Webform Update</fullName>
        <actions>
            <name>VPM_SendEmailToRequestorAfterWebformUpdate</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_VendorWebformSubmitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_AdvancedFormSubmitted__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Send Email to Requestor if web form updated after request has been sent for approval</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VPM Email to Requestor Before Webform Update</fullName>
        <actions>
            <name>VPM_SendEmailToRequestorBeforeWebformUpdate</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_VendorWebformSubmitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_AdvancedFormSubmitted__c</field>
            <operation>notEqual</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Send Email to Requestor if web form updated before request has been sent for approval</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VPM Notification Logged Message for 2 level of Approval</fullName>
        <active>false</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_NumberofApprovalsRequired__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_AdvancedFormSubmitter__c</field>
            <operation>equals</operation>
            <value>Procurement</value>
        </criteriaItems>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_FinanceApprovalRequired__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_RequestLastWithGroup__c</field>
            <operation>equals</operation>
            <value>Business Requestor</value>
        </criteriaItems>
        <description>Email Notification for logged when 2 level of approvals</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VPM Notification for Logged MDM Ops Review</fullName>
        <actions>
            <name>VPM_NextApproverNameMDMOps</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_Status__c</field>
            <operation>equals</operation>
            <value>MDM Ops Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_AdvancedFormSubmitter__c</field>
            <operation>equals</operation>
            <value>Business Requestor</value>
        </criteriaItems>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_NumberofApprovalsRequired__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <description>send notification for logged email to the request creator when the status is MDM Ops Review</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VPM Reporting Region %281%2F2%29</fullName>
        <actions>
            <name>VPM_RegionForWFR12</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the &apos;Reporting Region&apos; value when &apos;Country Requesting Vendor&apos; is changed as per region buckets defined by MDM Ops specifically:
- Europe
- North America
- Latin America
- South East Asia &amp; Australia
- Africa
Paired with VPM Reporting Region 2/2</description>
        <formula>IF( OR( VPM_CRVT__c=&quot;Austria&quot;, VPM_CRVT__c=&quot;Belgium&quot;, VPM_CRVT__c=&quot;Bulgaria&quot;, VPM_CRVT__c=&quot;Czech Republic&quot;, VPM_CRVT__c=&quot;Denmark&quot;, VPM_CRVT__c=&quot;Estonia&quot;, VPM_CRVT__c=&quot;Finland&quot;, VPM_CRVT__c=&quot;France&quot;, VPM_CRVT__c=&quot;Greece&quot;, VPM_CRVT__c=&quot;Hungary&quot;, VPM_CRVT__c=&quot;Ireland&quot;, VPM_CRVT__c=&quot;Italy&quot;, VPM_CRVT__c=&quot;Netherlands&quot;, VPM_CRVT__c=&quot;Norway&quot;, VPM_CRVT__c=&quot;Poland&quot;, VPM_CRVT__c=&quot;Romania&quot;, VPM_CRVT__c=&quot;Serbia&quot;, VPM_CRVT__c=&quot;Slovakia&quot;, VPM_CRVT__c=&quot;Spain&quot;, VPM_CRVT__c=&quot;Switzerland&quot;, VPM_CRVT__c=&quot;Sweden&quot;, VPM_CRVT__c=&quot;United Kingdom&quot;, VPM_CRVT__c=&quot;USA&quot;, VPM_CRVT__c=&quot;Canada&quot;, VPM_CRVT__c=&quot;Peru&quot;, VPM_CRVT__c=&quot;Brazil&quot;, VPM_CRVT__c=&quot;Mexico&quot;, VPM_CRVT__c=&quot;El Salvador&quot;, VPM_CRVT__c=&quot;Guatemala&quot;, VPM_CRVT__c=&quot;Colombia&quot;, VPM_CRVT__c=&quot;Ecuador&quot;, VPM_CRVT__c=&quot;Dominican Rep.&quot;, VPM_CRVT__c=&quot;Argentina&quot;, VPM_CRVT__c=&quot;Nicaragua&quot;, VPM_CRVT__c=&quot;Trinidad,Tobago&quot;, VPM_CRVT__c=&quot;Costa Rica&quot;, VPM_CRVT__c=&quot;Honduras&quot;, VPM_CRVT__c=&quot;Venezuela&quot;, VPM_CRVT__c=&quot;Chile&quot;, VPM_CRVT__c=&quot;Paraguay&quot;, VPM_CRVT__c=&quot;Panama&quot;, VPM_CRVT__c=&quot;Uruguay&quot;, VPM_CRVT__c=&quot;Thailand&quot;, VPM_CRVT__c=&quot;Australia&quot;, VPM_CRVT__c=&quot;Singapore&quot;, VPM_CRVT__c=&quot;Myanmar&quot;, VPM_CRVT__c=&quot;Philippines&quot;, VPM_CRVT__c=&quot;Indonesia&quot;, VPM_CRVT__c=&quot;New Zealand&quot;, VPM_CRVT__c=&quot;Vietnam&quot;, VPM_CRVT__c=&quot;Cambodia&quot;, VPM_CRVT__c=&quot;Zambia&quot;, VPM_CRVT__c=&quot;Kenya&quot;, VPM_CRVT__c=&quot;Malawi&quot;, VPM_CRVT__c=&quot;Uganda&quot;, VPM_CRVT__c=&quot;Zimbabwe&quot;, VPM_CRVT__c=&quot;Ivory Coast&quot;, VPM_CRVT__c=&quot;Nigeria&quot;, VPM_CRVT__c=&quot;Mozambique&quot;, VPM_CRVT__c=&quot;South Africa&quot;, VPM_CRVT__c=&quot;Ghana&quot;, VPM_CRVT__c=&quot;Ethiopia&quot;, VPM_CRVT__c=&quot;Tanzania&quot; ),	 TRUE,FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VPM Reporting Region %282%2F2%29</fullName>
        <actions>
            <name>VPM_RegionForWFR22</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the &apos;Reporting Region&apos; value when &apos;Country Requesting Vendor&apos; is changed as per region buckets defined by MDM Ops specifically:
-South Asia
-North Asia
-NAMET RUB
-Fusion
Paired with VPM Reporting Region 1/2</description>
        <formula>IF( OR( VPM_CRVT__c=&quot;Pakistan&quot;, VPM_CRVT__c=&quot;Bangladesh&quot;, VPM_CRVT__c=&quot;China &quot;, VPM_CRVT__c=&quot;Japan&quot;, VPM_CRVT__c=&quot;Taiwan&quot;, VPM_CRVT__c=&quot;Hong Kong&quot;, VPM_CRVT__c=&quot;Algeria&quot;, VPM_CRVT__c=&quot;Bahrain&quot;, VPM_CRVT__c=&quot;Egypt&quot;, VPM_CRVT__c=&quot;Iran&quot;, VPM_CRVT__c=&quot;Israel&quot;, VPM_CRVT__c=&quot;Kazakhstan&quot;, VPM_CRVT__c=&quot;Morocco&quot;, VPM_CRVT__c=&quot;Oman&quot;, VPM_CRVT__c=&quot;Russian Fed.&quot;, VPM_CRVT__c=&quot;Saudi Arabia&quot;, VPM_CRVT__c=&quot;Tunisia&quot;, VPM_CRVT__c=&quot;Turkey&quot;, VPM_CRVT__c=&quot;Utd.Arab Emir.&quot;, VPM_CRVT__c=&quot;Ukraine&quot;, VPM_CRVT__c=&quot;India &quot;, VPM_CRVT__c=&quot;Nepal&quot; ),	 TRUE,FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VPM Send email to Vendor</fullName>
        <actions>
            <name>VPM_SendEmailToVendorEmail</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>VPM_Email_of_Webform_Sender</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VPM_Set_Email_Flag_to_No</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VPM_Webform_sent_to_Vendor</name>
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
        <fullName>VPM Update Salesforce when request fails to submit to BPM</fullName>
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
            <name>VPM_UpdateStatusRejected</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_MDMInsertUpdateStatus__c</field>
            <operation>equals</operation>
            <value>Approval Rejected in BPM</value>
        </criteriaItems>
        <description>Update salesforce record depending on MDM service call</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VPM_CountryRegionUpdate</fullName>
        <active>false</active>
        <formula>ISCHANGED(VPM_Country__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VPM_EmailForRework</fullName>
        <actions>
            <name>VPM_EmailForRework</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_Status__c</field>
            <operation>contains</operation>
            <value>Bank Data Validation Requested Re-Work,Finance Requested Re-Work,FLS Requested Re-Work,Freight Requested Re-Work,MDM Ops Review Requested Re-Work,Procurement Requested Re-Work,Russian Custom Tax Requested Re-Work</value>
        </criteriaItems>
        <description>VPM - send email for rework to the record creator</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VPM_EmailNotificationForRequestCompleted</fullName>
        <actions>
            <name>VPM_EmailRequestCompleted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_Status__c</field>
            <operation>equals</operation>
            <value>Request Completed</value>
        </criteriaItems>
        <description>VPM- email notification to record creator when the request is completed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VPM_EmailNotificationSAPBPMRejectedToMDM</fullName>
        <actions>
            <name>VPM_RequestRejectMDMNotification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_Status__c</field>
            <operation>equals</operation>
            <value>SAP BPM Approval Rejected</value>
        </criteriaItems>
        <description>Sent Email to MDM Ops User when Record is Rejected in SAP BPM</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VPM_ResetValuesOnCreate</fullName>
        <actions>
            <name>VPM_RecordTypeVendorRequest</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VPM_UpdateStatusField</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Resets certain system values in picklists and fields on create to ensure the request is considered as a new request if it is cloned from a different request</description>
        <formula>True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
