<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GBVP_return_SOW</fullName>
        <description>GBVP return SOW</description>
        <protected>false</protected>
        <recipients>
            <field>Approval_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Oblix_SOW_Email/SOW_returned_to_Marketeer_2</template>
    </alerts>
    <alerts>
        <fullName>SOW_Approved_by_Agency</fullName>
        <description>SOW Approved by Agency</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Unilever_SOW_Approver_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Oblix_SOW_Email/SOW_Approved_by_Agency</template>
    </alerts>
    <alerts>
        <fullName>SOW_Approved_by_Unilever</fullName>
        <description>SOW Approved by Unilever</description>
        <protected>false</protected>
        <recipients>
            <field>Approval_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Oblix_SOW_Email/SOW_Approved_by_Unilever_2</template>
    </alerts>
    <alerts>
        <fullName>SOW_Ready_for_Internal_Approval</fullName>
        <description>SOW Ready for Internal Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Unilever_SOW_Approver_Name_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Unilever_SOW_Approver_Name_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Unilever_SOW_Approver_Name_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Unilever_SOW_Approver_Name_5__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Unilever_SOW_Approver_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Oblix_SOW_Email/SOW_for_Internal_Approval</template>
    </alerts>
    <alerts>
        <fullName>SOW_Returned_to_Unilever</fullName>
        <description>SOW Returned to Unilever</description>
        <protected>false</protected>
        <recipients>
            <field>Approval_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Oblix_SOW_Email/SOW_returned_to_Marketeer_by_Agency</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_SOW_Status_Awaiting_Agency_tbc</fullName>
        <field>SOW_Status__c</field>
        <literalValue>Pending Agency Approval</literalValue>
        <name>Update SOW Status Awaiting Agency tbc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SOW_Status_to_Approved</fullName>
        <field>SOW_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update SOW Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SOW_Status_to_Draft</fullName>
        <field>SOW_Status__c</field>
        <literalValue>Draft - with Unilever</literalValue>
        <name>Update SOW Status to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SOW_Status_to_Returned_ByApprover</fullName>
        <field>SOW_Status__c</field>
        <literalValue>Returned by Approver</literalValue>
        <name>Update SOW Status to Returned ByApprover</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SOW_Status_to_Returned_by_Agency</fullName>
        <field>SOW_Status__c</field>
        <literalValue>Returned by Agency</literalValue>
        <name>Update SOW Status to Returned by Agency</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
