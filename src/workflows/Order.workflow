<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UID_UpdateOrderReportDateField</fullName>
        <field>UID_Report_Date__c</field>
        <formula>EffectiveDate</formula>
        <name>UID_UpdateOrderReportDateField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UID_populate_recordType</fullName>
        <field>UID_Order_RecordType__c</field>
        <formula>RecordType.Name</formula>
        <name>UID populate recordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UID Populate Order RecordType</fullName>
        <actions>
            <name>UID_populate_recordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order.RecordTypeId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UID_UpdateOrderReportDate</fullName>
        <actions>
            <name>UID_UpdateOrderReportDateField</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order.UID_Invoice_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
