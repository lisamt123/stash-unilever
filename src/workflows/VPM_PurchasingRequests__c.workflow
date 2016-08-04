<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notification_for_Logged</fullName>
        <description>Notification for Logged</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>VPM_ApprovalEmails/VPM_Requesthasbeenlogged</template>
    </alerts>
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
        <fullName>VPM_NotifiedBusinessRequesterRequestFreightTeam</fullName>
        <description>Notification to Business Requestor that request has been rejected by FreightTeam</description>
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
        <fullName>Assign_to_Freight</fullName>
        <field>OwnerId</field>
        <lookupValue>VPM_RussianCustomTax</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Russian</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ChangeReworkStatustoNo</fullName>
        <description>VPM _ Used the Rest the rework flag as the approval process has been recall manually.</description>
        <field>VPM_Rework__c</field>
        <literalValue>No</literalValue>
        <name>Change Rework Status to No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Business_Requestor_Flag_to_Null</fullName>
        <field>VPM_BusinessRequestorSubmitted__c</field>
        <name>Change Business Requestor Flag to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to</fullName>
        <field>VPM_RussiaSubmitted__c</field>
        <literalValue>Yes</literalValue>
        <name>Change Status to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to_FLS_review</fullName>
        <field>VPM_Status__c</field>
        <literalValue>FLS Review</literalValue>
        <name>Change Status to FLS review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FLS_SubmittedYes</fullName>
        <description>VPM - Sets FLS Submitted Field to &apos;Yes&apos; to confirm FLS have finished their review. Triggers a process builder to handle different updates</description>
        <field>VPM_AdvancedFormSubmitted__c</field>
        <literalValue>Yes</literalValue>
        <name>FLS Submitted Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Request_Last_with_Group_Freight</fullName>
        <field>VPM_RequestLastWithGroup__c</field>
        <literalValue>Freight</literalValue>
        <name>Request Last with Group Freight</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Request_Last_with_Group_Russian_Custom_T</fullName>
        <field>VPM_RequestLastWithGroup__c</field>
        <literalValue>Russian Custom Tax</literalValue>
        <name>Request Last with Group Russian Custom T</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateEccRield</fullName>
        <field>VPM_ECC__c</field>
        <literalValue>Sirius</literalValue>
        <name>UpdateEccRield</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
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
        <fullName>VPM_AssigntoFreight</fullName>
        <field>OwnerId</field>
        <lookupValue>VPM_Freight</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Freight</name>
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
        <fullName>VPM_BusinessRequestorSubmitted_No</fullName>
        <field>VPM_BusinessRequestorSubmitted__c</field>
        <name>BusinessRequestorSubmitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeAdvanceFormSubmittedtonull</fullName>
        <field>VPM_AdvancedFormSubmitted__c</field>
        <name>Change Advance Form Submitted to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeFreightApprovalRequiredToNull</fullName>
        <field>VPM_FreightApprovalRequired__c</field>
        <literalValue>0</literalValue>
        <name>Change Freight Approval Required To Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeFreightSubmittedToNull</fullName>
        <field>VPM_FreightSubmitted__c</field>
        <name>Change Freight Submitted To Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeIsInApprovalProcess</fullName>
        <field>VPM_IsInApprovalProcess__c</field>
        <literalValue>Approval Completed</literalValue>
        <name>Change Is In Approval Process To Complet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeIsinApprovalStatus</fullName>
        <field>VPM_IsInApprovalProcess__c</field>
        <literalValue>In Approval Process</literalValue>
        <name>Change IsinApproval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeIslockStatusFalse</fullName>
        <field>VPM_IsLock__c</field>
        <literalValue>0</literalValue>
        <name>Changes Is lock Status to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeIslockStatusTrue</fullName>
        <description>VPM - Set  islock flag as True when the record is the approval process</description>
        <field>VPM_IsLock__c</field>
        <literalValue>1</literalValue>
        <name>Changes Is lock Status to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeIslockStatusto_False</fullName>
        <field>VPM_IsLock__c</field>
        <literalValue>0</literalValue>
        <name>Changes Is lock Status to False</name>
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
        <fullName>VPM_ChangeOwnerToFreightQueue</fullName>
        <description>VPM - Sets the Owner as Freight Queue on entering approval process.</description>
        <field>OwnerId</field>
        <lookupValue>VPM_Freight</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Owner To Freight Queue</name>
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
        <fullName>VPM_ChangeOwnerToProc5001</fullName>
        <description>VPM - Sets The Owner as Proc 5001 Queue On Entering Approval Process</description>
        <field>OwnerId</field>
        <lookupValue>VPM_Proc5001ProcessEquipment</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Owner To Proc 5001</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeOwnerToProc6003</fullName>
        <field>OwnerId</field>
        <lookupValue>VPM_Proc6003CreativeServices</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Owner To Proc 6003</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
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
        <fullName>VPM_ChangeOwnerToRussianCustomTax</fullName>
        <description>VPM</description>
        <field>OwnerId</field>
        <lookupValue>VPM_RussianCustomTax</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Owner to Russian Custom Tax</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeReworkStatusNo</fullName>
        <description>VPM _ Used the Rest the rework flag as the approval process has been recall manually.</description>
        <field>VPM_Rework__c</field>
        <literalValue>No</literalValue>
        <name>Change Rework Status to No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeReworkStatus_No</fullName>
        <field>VPM_Rework__c</field>
        <literalValue>No</literalValue>
        <name>Change Rework Status to No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeRussiaSubmittedtoNull</fullName>
        <field>VPM_RussiaSubmitted__c</field>
        <name>Change Russia Submitted to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeRussianApprovalRequiredToNull</fullName>
        <field>VPM_RussianTaxApprovalRequired__c</field>
        <literalValue>0</literalValue>
        <name>Change Russian Approval Required To Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeStatusToFreightReject</fullName>
        <field>VPM_Status__c</field>
        <literalValue>Freight Rejected</literalValue>
        <name>Change Status To Freight Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeStatusToRussianApproved</fullName>
        <field>VPM_Status__c</field>
        <literalValue>Russian Custom Tax Approved</literalValue>
        <name>Change Status To Russian Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangesIslockStatusFalse</fullName>
        <field>VPM_IsLock__c</field>
        <literalValue>0</literalValue>
        <name>Changes Is lock Status False</name>
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
        <name>Changes Is lock Status to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangesIslockStatusTrue</fullName>
        <description>VPM - Set  islock flag as True when the record is the approval process</description>
        <field>VPM_IsLock__c</field>
        <literalValue>1</literalValue>
        <name>Changes Is lock Status to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
        <fullName>VPM_FreightApprovedYes</fullName>
        <field>VPM_FreightSubmitted__c</field>
        <literalValue>Yes</literalValue>
        <name>Freight Approved Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_IsInApprovalProcessBlank</fullName>
        <description>Resets is in approval process to blank on recall</description>
        <field>VPM_IsInApprovalProcess__c</field>
        <name>Is in Approval Process Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
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
        <fullName>VPM_OwnerIsMDMOps</fullName>
        <description>Updates record owner to MDM Ops queue</description>
        <field>OwnerId</field>
        <lookupValue>VPM_MDMOps</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner is MDM Ops</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
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
        <fullName>VPM_ProcurementApprovalRequiredIsNo</fullName>
        <description>Resets the flag for checking whether a Procurement approval is required</description>
        <field>VPM_ProcurementApprovalRequired__c</field>
        <literalValue>0</literalValue>
        <name>Procurement Approval Required is No</name>
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
        <fullName>VPM_RequestLastWithGroupProcurement</fullName>
        <field>VPM_RequestLastWithGroup__c</field>
        <literalValue>Procurement</literalValue>
        <name>Request Last with Group Procurement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_Reset_IsInApproval_Flag</fullName>
        <field>VPM_IsInApprovalProcess__c</field>
        <name>Reset isInApproval Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ReworktoNo</fullName>
        <field>VPM_Rework__c</field>
        <literalValue>No</literalValue>
        <name>Rework to No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_RussiaApprovedtoyes</fullName>
        <field>VPM_RussiaSubmitted__c</field>
        <literalValue>Yes</literalValue>
        <name>Russia Approved to yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
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
        <fullName>VPM_StatusFreightApproved</fullName>
        <field>VPM_Status__c</field>
        <literalValue>Freight Approved</literalValue>
        <name>Status Freight Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatusFreightRejected</fullName>
        <field>VPM_Status__c</field>
        <literalValue>Freight Rejected</literalValue>
        <name>Status Freight Rejected</name>
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
        <fullName>VPM_StatusRussianCustomTax</fullName>
        <field>VPM_Status__c</field>
        <literalValue>Russian Custom Tax Approved</literalValue>
        <name>Status Russian Custom Tax</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatusRussianCustomTaxRejected</fullName>
        <field>VPM_Status__c</field>
        <literalValue>Russian Custom Tax Rejected</literalValue>
        <name>Status Russian Custom Tax Rejected</name>
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
        <fullName>VPM_StatustoApprovalPending</fullName>
        <field>VPM_Status__c</field>
        <literalValue>Approval Pending</literalValue>
        <name>Status to Approval Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatustoFreightApproved</fullName>
        <field>VPM_Status__c</field>
        <literalValue>Freight Approved</literalValue>
        <name>Status to Freight Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
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
    <fieldUpdates>
        <fullName>test_No</fullName>
        <field>VPM_Rework__c</field>
        <literalValue>No</literalValue>
        <name>test No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Change the Owner Id to MDM Ops Queue</fullName>
        <actions>
            <name>VPM_ChangeOwnerIdtoMDMOpsQueue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_Status__c</field>
            <operation>contains</operation>
            <value>MDM Ops</value>
        </criteriaItems>
        <description>VPM - Used to update the Owner id to MDM Ops Queues  when the request is under MDM Team for Review</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
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
        <fullName>Set default Values for Vendor Type  %26  Authorisation Group from Commodity Codes</fullName>
        <active>false</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_Status__c</field>
            <operation>equals</operation>
            <value>Draft Request</value>
        </criteriaItems>
        <description>VPM  - Set default Values for Vendor Type  &amp;  Authorisation Group from Commodity Codes</description>
        <triggerType>onCreateOnly</triggerType>
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
        <fullName>VPM Default Value Payment Terms if Vendor not SME Cordillera Sirius</fullName>
        <actions>
            <name>VPM_PaymentTermsP090Default</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>VPM - Used to set the Default Values for Payment Terms if Vendor is an SME is No in Cordillera and Sirius</description>
        <formula>ISPICKVAL(VPM_IsVendorSME__c,&quot;&quot;)
||
AND(
ISCHANGED(VPM_IsVendorSME__c),
ISPICKVAL(VPM_IsVendorSME__c,&quot;No&quot;)
)
&amp;&amp;
OR(
ISPICKVAL(  VPM_ECC__c ,&quot;Sirius&quot;),
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
        <fullName>VPM_BankDetails</fullName>
        <actions>
            <name>VPM_BankDetails</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED(VPM_BankCountryKey__c) || ISCHANGED(VPM_BankKey__c) || ISCHANGED(VPM_BankAccountNumber__c) || ISCHANGED(VPM_AccountHolderName__c) || ISCHANGED(VPM_ReferenceSpecificationsBankDetail__c) || ISCHANGED(VPM_BankControlKey__c) || ISCHANGED(VPM_IBAN__c) || ISCHANGED(VPM_CollectionAuthorization__c) || ISCHANGED(VPM_PartnerBankType__c)||ISCHANGED(VPM_BankName__c) || ISCHANGED(VPM_SwiftKey__c)|| NOT(ISCHANGED((VPM_BankKey__c))&amp;&amp;ISBLANK((VPM_BankKey__c)))|| NOT(ISCHANGED((VPM_BankAccountNumber__c))&amp;&amp; ISBLANK((VPM_BankAccountNumber__c))) || NOT(ISCHANGED((VPM_AccountHolderName__c))&amp;&amp; ISBLANK((VPM_AccountHolderName__c)))|| NOT(ISCHANGED((VPM_ReferenceSpecificationsBankDetail__c))&amp;&amp; ISBLANK((VPM_ReferenceSpecificationsBankDetail__c)))|| NOT(ISCHANGED((VPM_BankControlKey__c))&amp;&amp; ISBLANK((VPM_BankControlKey__c)))|| NOT(ISCHANGED((VPM_IBAN__c))&amp;&amp; ISBLANK((VPM_IBAN__c)))|| NOT(ISCHANGED((VPM_PartnerBankType__c))&amp;&amp; ISBLANK((VPM_PartnerBankType__c)))|| NOT(ISCHANGED((VPM_BankName__c))&amp;&amp; ISBLANK((VPM_BankName__c)))|| NOT(ISCHANGED((VPM_SwiftKey__c))&amp;&amp; ISBLANK((VPM_SwiftKey__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VPM_Deletion%2FBlockFlag</fullName>
        <actions>
            <name>VPM_ProvidedBlock_Delete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_DeletionBlockFlag__c</field>
            <operation>contains</operation>
            <value>Block</value>
        </criteriaItems>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_DeletionBlockFlag__c</field>
            <operation>contains</operation>
            <value>Delete</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VPM_ProvidedFinancialSensitive</fullName>
        <actions>
            <name>VPM_ProvidedFinancialSensitive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED(VPM_ReconciliationAccount__c) || ISCHANGED(VPM_PaymentMethod__c)||ISCHANGED(VPM_GRbasedIV__c) || ISCHANGED(VPM_AutomaticPurchaseOrderGeneration__c) || ISCHANGED(VPM_PaymentBlock__c) || ISCHANGED(VPM_AlternativePayee__c) || NOT(ISCHANGED(VPM_ReconciliationAccount__c)&amp;&amp; ISBLANK(VPM_ReconciliationAccount__c))|| NOT(ISCHANGED(VPM_AlternativePayee__c)&amp;&amp; ISBLANK(VPM_AlternativePayee__c))</formula>
        <triggerType>onAllChanges</triggerType>
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
    <rules>
        <fullName>VPM_UndeleteUnblockFlag</fullName>
        <actions>
            <name>VPM_Provided</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_DeletionBlockFlag__c</field>
            <operation>contains</operation>
            <value>Unblock</value>
        </criteriaItems>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_DeletionBlockFlag__c</field>
            <operation>contains</operation>
            <value>Undelete</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>test</fullName>
        <active>false</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_Status__c</field>
            <operation>equals</operation>
            <value>FLS Review,Approval Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_Rework__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
