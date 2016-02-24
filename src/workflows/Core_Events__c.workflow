<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Core_Edit_Other</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Conference App - Record Type</fullName>
        <actions>
            <name>Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Core_Events__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Core_Create</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
