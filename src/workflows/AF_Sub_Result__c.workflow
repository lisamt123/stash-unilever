<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Sub_Result_Update_Key</fullName>
        <field>AF_Unique_Thresholds__c</field>
        <formula>key__c</formula>
        <name>Sub Result Update Key</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Sub Result Unique</fullName>
        <actions>
            <name>Sub_Result_Update_Key</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
