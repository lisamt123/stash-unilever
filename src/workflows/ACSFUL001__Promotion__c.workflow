<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Org_Update</fullName>
        <field>UL_Sales_Organization__c</field>
        <formula>ACSFUL001__Sales_Org__c</formula>
        <name>Org Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_Sharing_Type_Text_Update</fullName>
        <field>UL_Sharing_Type_Txt__c</field>
        <formula>UL_Sharing_Type_Form__c</formula>
        <name>Sharing Type Text Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_slogan</fullName>
        <field>ACSFUL001__Slogan_Language_1__c</field>
        <formula>ACSFUL001__Anchor_Account__r.Name  +&apos;-&apos;+  UL_Category__c +&apos;-&apos;+  TEXT(UL_Mechanic__c) +&apos;-&apos;+  TEXT(UL_Sub_Mechanic__c) +&apos;-&apos;+  TEXT(UL_Feature__c) +&apos;-&apos;+ TEXT(ACSFUL001__Placement_Date_From__c) +&apos;-&apos;+ TEXT(ACSFUL001__Placement_Date_Thru__c)</formula>
        <name>update slogan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ACSFUL001__Update Promotion Record Type</fullName>
        <active>false</active>
        <criteriaItems>
            <field>ACSFUL001__Promotion__c.ACSFUL001__Phase__c</field>
            <operation>equals</operation>
            <value>Committed,Cancelled</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sales Org Update on Promotion</fullName>
        <actions>
            <name>Org_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ACSFUL001__Promotion__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UL_Sharing_ Type_ Update</fullName>
        <actions>
            <name>UL_Sharing_Type_Text_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>update promotion name</fullName>
        <actions>
            <name>update_slogan</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ACSFUL001__Anchor_Account__c != null</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
