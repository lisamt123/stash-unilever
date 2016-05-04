<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FAU_Update_Program_Recordtype_Status</fullName>
        <description>Update Program Recordtype Status to Inactive</description>
        <field>RecordTypeId</field>
        <lookupValue>Template_Inactive</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>FAU Update Program Recordtype Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FAU_Program_Make_Template_Inactive</fullName>
        <actions>
            <name>FAU_Update_Program_Recordtype_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>FAU_Program__c.FAU_Status__c</field>
            <operation>equals</operation>
            <value>In Active</value>
        </criteriaItems>
        <description>FIELD UPDATE: Program make template inactive.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
