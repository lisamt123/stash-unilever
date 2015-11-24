<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>WinatPOS_AG_Set_BrandName_KeyWord_Search</fullName>
        <field>Brand_Name_For_KeyWord_Search__c</field>
        <formula>Brand__r.Name</formula>
        <name>WinatPOS AG Set BrandName KeyWord Search</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WinatPOS_AG_Set_Cat_Name_KeyWord_Search</fullName>
        <field>Category_Name_for_KeyWord_Search__c</field>
        <formula>Category__r.Name</formula>
        <name>WinatPOS AG Set Cat Name KeyWord Search</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WinatPOS_AG_Set_Cluster_KeyWord_Search</fullName>
        <field>Market_Cluster_for_KeyWord_Search__c</field>
        <formula>TEXT(Market_Cluster__c)</formula>
        <name>WinatPOS AG Set Cluster KeyWord Search</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WinatPOS_AG_Set_Type_KeyWord_Search</fullName>
        <field>Type_for_Keyword_Search__c</field>
        <formula>TEXT(Type__c)</formula>
        <name>WinatPOS AG Set Type KeyWord Search</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WinatPOS AG Brand Name for KeyWord Search</fullName>
        <actions>
            <name>WinatPOS_AG_Set_BrandName_KeyWord_Search</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WinatPOS AG Cat Name for KeyWord Search</fullName>
        <actions>
            <name>WinatPOS_AG_Set_Cat_Name_KeyWord_Search</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WinatPOS AG Cluster for KeyWord Search</fullName>
        <actions>
            <name>WinatPOS_AG_Set_Cluster_KeyWord_Search</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WinatPOS AG Type for KeyWord Search</fullName>
        <actions>
            <name>WinatPOS_AG_Set_Type_KeyWord_Search</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
