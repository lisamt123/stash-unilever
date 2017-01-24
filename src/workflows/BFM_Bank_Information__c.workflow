<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BFM_Bank_Information_External_Id</fullName>
        <field>External_Id__c</field>
        <formula>Carrier_Account__r.BFM_Vendor__c + Bank_Code__c + Bank_Country__c + Agency_Number__c + Account_Number__c</formula>
        <name>BFM Bank Information External Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BFM Bank Information External Id</fullName>
        <actions>
            <name>BFM_Bank_Information_External_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Carrier_Account__c) || ISCHANGED( Bank_Code__c) || ISCHANGED (Bank_Country__c) || ISCHANGED (Agency_Number__c) ||  ISCHANGED (Account_Number__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
