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
        <fullName>Update_Approved_for_defined_objective</fullName>
        <description>It is used to update Approved field on defined objective</description>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>Update Approved for defined objective</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Defined_objective_status</fullName>
        <description>It is used to cheange the status on defined objective when rejected</description>
        <field>Status__c</field>
        <literalValue>Planning</literalValue>
        <name>Update Defined objective status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_on_defined_objective</fullName>
        <description>Is is used to update status on defined objective</description>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update status on defined objective</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
