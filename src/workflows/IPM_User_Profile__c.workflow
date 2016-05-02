<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>IPM_Update_User_Company_Card</fullName>
        <description>Field update for the Unique field in the Record</description>
        <field>Unique_User_Company_Card__c</field>
        <formula>CASESAFEID(IPM_Company_Card__c) &amp;  CASESAFEID(IPM_User__c)</formula>
        <name>IPM Update User Company Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>IPM Update User Company Card</fullName>
        <actions>
            <name>IPM_Update_User_Company_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To update unique field for the user profile record</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
