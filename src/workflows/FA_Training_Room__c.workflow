<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FA_Training_Room_External_ID</fullName>
        <field>FA_External_ID__c</field>
        <formula>Name +  FA_Training_Venue__c +  FA_Room_Number__c</formula>
        <name>FA Training Room External ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FA Update External ID Of Training Room</fullName>
        <actions>
            <name>FA_Training_Room_External_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow will update the external Id field on the Training Room record</description>
        <formula>ISNEW() || ISCHANGED(Name)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
