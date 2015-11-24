<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BC_updateEditArticleTemplate</fullName>
        <field>Edit_Article_Template_Front_End__c</field>
        <literalValue>1</literalValue>
        <name>BC_updateEditArticleTemplate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_AF_UserTypeText</fullName>
        <field>AF_UserTypeText__c</field>
        <formula>text(AF_Agency_Fees_User_Type__c)</formula>
        <name>Update AF_UserTypeText</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_User_Categories</fullName>
        <field>AF_Categories__c</field>
        <formula>AF_Category__c</formula>
        <name>Update User Categories</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AF_User</fullName>
        <actions>
            <name>Update_AF_UserTypeText</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BC_updateEditArticleTemplate</fullName>
        <actions>
            <name>BC_updateEditArticleTemplate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Unilever Way - Marketing - Brand Centre Admin</value>
        </criteriaItems>
        <description>Unilever Way - Marketing - Brand Centre Admin
need the field selected automatically</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Check Categories</fullName>
        <actions>
            <name>Update_User_Categories</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
