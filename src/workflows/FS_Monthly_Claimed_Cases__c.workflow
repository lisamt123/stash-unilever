<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FS_UpdateExternalKey</fullName>
        <description>Created to update the external key from Contract product and product</description>
        <field>External_Key__c</field>
        <formula>Contract_Product__r.Contract__r.ContractNumber +&apos;-&apos;+Contract_Product__r.Product__r.Name + &apos;-&apos;+TEXT(FS_First_of_Month__c)</formula>
        <name>FS Update External Key</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FS Update ExternalKey</fullName>
        <actions>
            <name>FS_UpdateExternalKey</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To update the  External key field from contract product,contract and product</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
