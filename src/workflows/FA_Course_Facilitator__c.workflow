<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FA_CourseFacilitator_External_ID</fullName>
        <field>FA_External_ID__c</field>
        <formula>FA_Course__c + FA_Facilitator__c</formula>
        <name>FA CourseFacilitator External ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FA Update External ID Of Course Facilitator</fullName>
        <actions>
            <name>FA_CourseFacilitator_External_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow will update the external Id field on the Course Facilitator record</description>
        <formula>ISNEW() || ISCHANGED( FA_Facilitator__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
