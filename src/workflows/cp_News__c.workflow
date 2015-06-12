<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Status_to_Inactive</fullName>
        <description>Change the status from Active to Inactive</description>
        <field>Status__c</field>
        <literalValue>Inactive</literalValue>
        <name>Status to Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Expire News Item</fullName>
        <active>true</active>
        <criteriaItems>
            <field>cp_News__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>cp_News__c.Expiry_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When a news item expires, makes it inactive</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Status_to_Inactive</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>cp_News__c.Expiry_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
