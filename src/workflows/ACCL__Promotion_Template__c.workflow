<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateActivePolicy</fullName>
        <description>Update Active Policy to True</description>
        <field>ACCL__Active_Policy__c</field>
        <literalValue>1</literalValue>
        <name>UpdateActivePolicy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UL_Update Active Policy</fullName>
        <actions>
            <name>UpdateActivePolicy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ACCL__Promotion_Template__c.ACCL__Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>ACCL__Promotion_Template__c.ACCL__Sales_Org__c</field>
            <operation>equals</operation>
            <value>AR01,CL01,CL03</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
