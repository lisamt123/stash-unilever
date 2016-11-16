<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
            <type>creator</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_SendWebformtoVendor</template>
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
        <fullName>VPM_ChangeOwnerToFLSQueue</fullName>
        <description>VPM - Sets the Owner as FLS Queue on entering approval process.</description>
        <field>OwnerId</field>
        <lookupValue>VPM_FLS</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>VPM - Change Owner To FLS Queue</name>
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
