<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Debit_Card_Active_field_update</fullName>
        <description>CEC Debit Card Active field update is used to update the active status to inactive after the expiry date.</description>
        <field>Active__c</field>
        <literalValue>0</literalValue>
        <name>Debit Card Active field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Debit_Card_Status</fullName>
        <description>CEC Update Debit Card Status is used to set the status field of debit card.</description>
        <field>Status__c</field>
        <literalValue>Expired</literalValue>
        <name>Update Debit Card Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CEC Debit Card Inactivation</fullName>
        <active>true</active>
        <criteriaItems>
            <field>CEC_Debit_Card_Detail__c.Status__c</field>
            <operation>equals</operation>
            <value>Issued,Reactivated</value>
        </criteriaItems>
        <description>CEC Debit Card Inactivation rule is used to set the expiry date and status of debit card.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Debit_Card_Active_field_update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Debit_Card_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CEC_Debit_Card_Detail__c.Expiry_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
