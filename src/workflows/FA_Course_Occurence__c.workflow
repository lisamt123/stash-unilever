<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FA_CourseOccurence_External_ID</fullName>
        <field>FA_External_ID__c</field>
        <formula>FA_Course__c +  TEXT(FA_Start_Date_Time__c) + TEXT( FA_End_Date_Time__c) + FA_Training_Venue__c + FA_Training_Room__c</formula>
        <name>FA CourseOccurence External ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FA Update External ID Of Course Occurence</fullName>
        <actions>
            <name>FA_CourseOccurence_External_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
