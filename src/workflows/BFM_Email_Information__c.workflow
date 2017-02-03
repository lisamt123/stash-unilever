<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BFM_Email_Information_External_Id</fullName>
        <field>External_Id__c</field>
        <formula>Address_Code__c + Contact_Number__c</formula>
        <name>BFM EmailInformation External Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BFM Email Information External Id</fullName>
        <actions>
            <name>BFM_Email_Information_External_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Address_Code__c) || ISCHANGED(Contact_Number__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
