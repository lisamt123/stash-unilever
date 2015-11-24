<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FA_Update_External_ID_Of_Pre_Work_Task</fullName>
        <field>FA_External_ID__c</field>
        <formula>FA_OccMember__c+FA_Occurence_Task__c</formula>
        <name>FA Update External ID Of Pre Work Task</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FA Update External ID Of Pre Work Task</fullName>
        <actions>
            <name>FA_Update_External_ID_Of_Pre_Work_Task</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>To avoid duplicates of the record.</description>
        <formula>ISNEW()||ISCHANGED(FA_OccMember__c)|| ISCHANGED( FA_Occurence_Task__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
