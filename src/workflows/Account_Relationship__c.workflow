<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FS_Update_Merged_Account_Name</fullName>
        <field>FS_MergedAccountName__c</field>
        <formula>FS_MergedAccount__r.Name</formula>
        <name>FS Update Merged Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FS Update Merge Account Name</fullName>
        <actions>
            <name>FS_Update_Merged_Account_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>FS_MasterAccount__c  &lt;&gt;   null</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
