<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>IPM_Project_In_To_Cluster</fullName>
        <field>IPM_Unique_Project__c</field>
        <formula>CASESAFEID(IPM_Project__c)</formula>
        <name>Project In To Cluster</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Unique_Cluster_Name</fullName>
        <field>IPM_Unique_Cluster_Name__c</field>
        <formula>upper(Name)</formula>
        <name>Unique Cluster Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Update_Cluster_Name</fullName>
        <field>Name</field>
        <formula>UPPER(Name)</formula>
        <name>Update Cluster Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>IPM Cluster Name Update</fullName>
        <actions>
            <name>IPM_Update_Cluster_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Convert lower to upper name</description>
        <formula>if(Name !=null,true,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IPM Unique Cluster Name</fullName>
        <actions>
            <name>IPM_Unique_Cluster_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>if(Name!=null, true,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unique Project IN Cluster</fullName>
        <actions>
            <name>IPM_Project_In_To_Cluster</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>if(IPM_Project__c !=null &amp;&amp; IPM_Cluster_Self__c !=null,true,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
