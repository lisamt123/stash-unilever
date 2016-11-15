<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Bio_Deadline</fullName>
        <field>FAU_Biography_Deadline__c</field>
        <formula>FAU_Start_Date__c -28</formula>
        <name>Bio Deadline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
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
    <fieldUpdates>
        <fullName>Invitation_Deadline</fullName>
        <field>FAU_Invitation_ResponseDeadline__c</field>
        <formula>FAU_Start_Date__c +7</formula>
        <name>Invitation Deadline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_BIO</fullName>
        <description>Compute Biography Deadline date based on the program start date.</description>
        <field>FAU_Biography_Deadline__c</field>
        <formula>FAU_Start_Date__c -28</formula>
        <name>Populate BIO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Invitation_Deadline</fullName>
        <field>FAU_Invitation_ResponseDeadline__c</field>
        <formula>FAU_Start_Date__c+7</formula>
        <name>Populate Invitation Deadline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FAU Deadlines Dates</fullName>
        <actions>
            <name>Bio_Deadline</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Invitation_Deadline</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>FAU_Program__c.FAU_Category__c</field>
            <operation>equals</operation>
            <value>Core</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Program__c.FAU_Category__c</field>
            <operation>equals</operation>
            <value>Franchise</value>
        </criteriaItems>
        <description>This workflow modifies the Invitation response deadline and Bio Deadline as required for HP2 and HP3 Programs</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
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
    <rules>
        <fullName>Populate Invitation Deadline and BIO dates</fullName>
        <actions>
            <name>Populate_BIO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Invitation_Deadline</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the dates on program object based on the Program Start date</description>
        <formula>OR( FAU_Start_Date__c != NULL ,  ISCHANGED(FAU_Start_Date__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
