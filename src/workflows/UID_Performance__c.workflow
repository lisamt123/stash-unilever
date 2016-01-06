<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UID_UpdateIOPExternalIDField</fullName>
        <field>UID_IOP_External_ID__c</field>
        <formula>UID_Distributor__r.AccountNumber &amp; &apos;-&apos; &amp;  TEXT(UID_Year__c)</formula>
        <name>UID_UpdateIOPExternalIDField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UID_UpdateIOPExternalID</fullName>
        <actions>
            <name>UID_UpdateIOPExternalIDField</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>UID_Performance__c.UID_Year__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
