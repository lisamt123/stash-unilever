<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>WinatPOS_Set_User_Country_for_Search</fullName>
        <field>Searched_in_Country__c</field>
        <formula>Searched_By__r.Country</formula>
        <name>WinatPOS Set User Country for Search</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WinatPOS Set User Country for Search Stats</fullName>
        <actions>
            <name>WinatPOS_Set_User_Country_for_Search</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Search_Statistics__c.Searched_By__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
