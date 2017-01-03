<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>UL_Email_Alert_for_Approval</fullName>
        <description>Email Alert for Approval</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/UL_Fund_Transaction_Approved_Email</template>
    </alerts>
    <alerts>
        <fullName>UL_Email_Alert_for_Rejection</fullName>
        <description>Email Alert for Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/UL_Fund_Transaction_Rejected_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Status_Approved</fullName>
        <field>UL_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_Status_Approved</fullName>
        <description>Updates the Status field on the Fund Transaction record to Approved</description>
        <field>UL_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_Status_equals_Approved</fullName>
        <description>On Approval of the record the Status field will be changed to Approved</description>
        <field>UL_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Status equals Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_Status_equals_For_Approval</fullName>
        <description>Updates the status field to Sent/Pending for Approval on creation of Cross Category Transaction</description>
        <field>UL_Status__c</field>
        <literalValue>Sent/Pending Approval</literalValue>
        <name>Status equals For Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_Status_equals_Not_Approved</fullName>
        <description>On rejection the Status will be changed to Not Approved</description>
        <field>UL_Status__c</field>
        <literalValue>Not Approved</literalValue>
        <name>Status equals Not Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>status_not_approved</fullName>
        <field>UL_Status__c</field>
        <literalValue>Not Approved</literalValue>
        <name>status not approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
