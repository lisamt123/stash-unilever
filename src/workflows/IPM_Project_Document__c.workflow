<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_P_Document_Name</fullName>
        <field>Name</field>
        <formula>LEFT(IPM_Project__r.Name + &apos;-&apos; + TEXT(IPM_GateDocuments__c), 78)</formula>
        <name>Update P Document Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Update_Category_Status_On_Approval</fullName>
        <field>IPM_Category_Status_while_Approved__c</field>
        <formula>IPM_Project__r.IPM_Threshold_Status__c</formula>
        <name>IPM_Update_Category_Status_On_Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>IPM_Update_Category_Status_On_Approval</fullName>
        <actions>
            <name>IPM_Update_Category_Status_On_Approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Project_Document__c.IPM_Document_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Updates  IPM_Category_Status_while_Approved__c  On Approval</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Rename Project Document</fullName>
        <actions>
            <name>Update_P_Document_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
