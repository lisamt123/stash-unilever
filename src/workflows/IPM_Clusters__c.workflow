<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>IPM_Update_cluster_name</fullName>
        <description>Update cluster name with standard name for backend</description>
        <field>IPM_Cluster_Name__c</field>
        <formula>Name</formula>
        <name>IPM_Update_cluster_name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>IPM_Unique_Cluster_Name</fullName>
        <actions>
            <name>IPM_Update_cluster_name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>to make cluster name as unique field</description>
        <formula>ISNEW() ||  ISCHANGED(Name) ||  ISBLANK(IPM_Cluster_Name__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
