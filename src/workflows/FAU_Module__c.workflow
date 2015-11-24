<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FAU_Update_Module_1_End_Date</fullName>
        <field>FAU_Module_1_End_Date__c</field>
        <formula>FAU_End_Date__c</formula>
        <name>FAU Update Module 1 End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>FAU_Program__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_Module_1_Start_Date</fullName>
        <field>FAU_Module_1_Start_Date__c</field>
        <formula>FAU_Start_Date__c</formula>
        <name>FAU Update Module 1 Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>FAU_Program__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_Module_2_End_Date</fullName>
        <field>FAU_Module_2_End_Date__c</field>
        <formula>FAU_End_Date__c</formula>
        <name>FAU Update Module 2 End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>FAU_Program__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_Module_2_Start_Date</fullName>
        <field>FAU_Module_2_Start_Date__c</field>
        <formula>FAU_Start_Date__c</formula>
        <name>FAU Update Module 2 Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>FAU_Program__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>FAU Update Module 1 Dates</fullName>
        <actions>
            <name>FAU_Update_Module_1_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FAU_Update_Module_1_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>FAU_Module__c.FAU_Module_Number__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <description>FIELD UPDATES: Updates the  module 1 start and end dates on the program from the module.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FAU Update Module 2 Dates</fullName>
        <actions>
            <name>FAU_Update_Module_2_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FAU_Update_Module_2_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>FAU_Module__c.FAU_Module_Number__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <description>FIELD UPDATES: Updates the module 2 start and end dates on the program from the module.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
