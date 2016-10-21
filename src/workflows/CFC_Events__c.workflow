<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CFC_Edit_Other</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Conference App Record Type</fullName>
        <actions>
            <name>Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CFC_Events__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CFC_Create</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
