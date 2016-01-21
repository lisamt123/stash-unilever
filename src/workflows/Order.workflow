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

