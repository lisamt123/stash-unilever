<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
   <!-- <fieldUpdates>
        <fullName>Planning_Level_Name_update</fullName>
        <field>Name</field>
        <formula>UL_Customer__r.Name</formula>
        <name>Planning Level Name update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>-->
    <fieldUpdates>
        <fullName>UL_Update_Promotion_Name</fullName>
        <field>Name</field>
        <formula>UL_Customer__r.Name</formula>
        <name>UL_Update_Promotion_Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_Update_Sales_ORG</fullName>
        <field>UL_Sales_Organisation__c</field>
        <formula>UL_Customer__r.UL_Sales_Organization__c</formula>
        <name>UL_Update_Sales_ORG</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UL_Account_Name_Update</fullName>
        <actions>
            <name>UL_Update_Promotion_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UL_Update_Sales_ORG</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
