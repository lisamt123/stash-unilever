<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UID_UpdateSalesFlag</fullName>
        <field>UID_Sales_Flag__c</field>
        <formula>If(Order.RecordType.Name == &apos;Primary Sales&apos;,0,1)</formula>
        <name>UID_UpdateSalesFlag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
