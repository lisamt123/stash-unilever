<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Win_POS_Set_User_Country_for_Downloads</fullName>
        <field>Downloaded_in_Country__c</field>
        <formula>Downloaded_By__r.Country</formula>
        <name>Win@POS Set User Country for Downloads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WinatPOS Set User Country for Downloads</fullName>
        <actions>
            <name>Win_POS_Set_User_Country_for_Downloads</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Download_Statistics__c.Downloaded_By__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
