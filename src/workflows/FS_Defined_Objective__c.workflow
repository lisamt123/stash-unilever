<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_alert_to_objective_owner_for_approval</fullName>
        <description>Email alert to objective owner for approval</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Defined_Objectives_Approved</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_to_objective_owner_for_rejection</fullName>
        <description>Email alert to objective owner for rejection</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Defined_Objectives_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>FS_UpdateApprovedOfDefObj</fullName>
        <description>It is used to update Approved field on defined objective</description>
        <field>FS_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Update Approved for defined objective</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_UpdateDefinedObjectiveStatus</fullName>
        <description>It is used to cheange the status on defined objective when rejected</description>
        <field>FS_Status__c</field>
        <literalValue>Planning</literalValue>
        <name>Update Defined objective status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_UpdateStatusOnDefObj</fullName>
        <description>Is is used to update status on defined objective</description>
        <field>FS_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update status on defined objective</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FS_Risk</fullName>
        <active>false</active>
        <criteriaItems>
            <field>FS_Defined_Objective__c.FS_Objective_Type__c</field>
            <operation>equals</operation>
            <value>Retain / Differentiate</value>
        </criteriaItems>
        <description>If a Defined Objective has an Objective Type value of Retain/Differentiate, update RecordType to Risk.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
