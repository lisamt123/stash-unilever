<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
        <fullName>FLS_SubmittedYes</fullName>
        <description>VPM - Sets FLS Submitted Field to &apos;Yes&apos; to confirm FLS have finished their review. Triggers a process builder to handle different updates</description>
        <field>VPM_FLSSubmitted__c</field>
        <literalValue>Yes</literalValue>
        <name>FLS Submitted Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeOwnerIdtoMDMOpsQueue</fullName>
        <description>VPM - Update  Owner Id field to MDM Ops Queue when the status of request is MDM Ops Review</description>
        <field>OwnerId</field>
        <lookupValue>VPM_MDMOpsQueue</lookupValue>
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
        <lookupValue>VPM_FLSQueue</lookupValue>
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
        <lookupValue>VPM_FinanceQueue</lookupValue>
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
        <lookupValue>VPM_MDMOpsQueue</lookupValue>
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
        <lookupValue>VPM_ProcurementQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Owner To Procurement Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeRecordTypeToFLS</fullName>
        <description>VPM - it will update the record type</description>
        <field>RecordTypeId</field>
        <lookupValue>VPM_PurRequisVendorCreate</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record type to FLS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
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
        <fullName>VPM_OwnerIsMDMOps</fullName>
        <description>Updates record owner to MDM Ops queue</description>
        <field>OwnerId</field>
        <lookupValue>VPM_MDMOpsQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner is MDM Ops</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
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
        <fullName>VPM_UpdateRequestGroup</fullName>
        <description>VPM - Update request group to MDM Ops</description>
        <field>VPM_RequestLastWithGroup__c</field>
        <literalValue>Procurement</literalValue>
        <name>VPM_UpdateRequestGroup</name>
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
        <active>true</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_Status__c</field>
            <operation>equals</operation>
            <value>MDM Ops Review</value>
        </criteriaItems>
        <description>VPM - Used to update the Owner id to MDM Ops Queues when the status &quot;MDM Ops Review&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
