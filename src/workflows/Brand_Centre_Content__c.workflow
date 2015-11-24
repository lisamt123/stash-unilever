<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BC_updateHeaderField</fullName>
        <field>Header__c</field>
        <literalValue>1</literalValue>
        <name>BC_updateHeaderField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BC_updateHeaderField</fullName>
        <actions>
            <name>BC_updateHeaderField</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Brand_Centre_Content__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Header Section Community,Header Section Latest News,Header Section Online,Header Section Right Side</value>
        </criteriaItems>
        <description>update header field checkbox to help on custom visualforce page brand centre content</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
