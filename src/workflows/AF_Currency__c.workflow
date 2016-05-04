<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Country_Currency</fullName>
        <field>Country_Currency__c</field>
        <formula>text(AF_Country__c)  &amp; &quot;-&quot; &amp; text( AF_Currency_Code__c )</formula>
        <name>Update Country Currency</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AF_LockCurrency</fullName>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>AF_Currency__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Check Country Currency</fullName>
        <actions>
            <name>Update_Country_Currency</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(ISCHANGED( AF_Country__c ) &amp;&amp;  ISCHANGED( AF_Currency_Code__c )) || isnew()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
