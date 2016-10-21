<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>ICB_Update_Subject</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Event.RecordTypeId</field>
            <operation>equals</operation>
            <value>Ice Cream Visit</value>
        </criteriaItems>
        <criteriaItems>
            <field>Event.AccountId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>The auto created visit name should be composed by Company Name + SAP code.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
