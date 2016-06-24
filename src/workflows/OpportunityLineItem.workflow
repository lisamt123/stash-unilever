<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>NFS_SalesPrice</fullName>
        <field>UnitPrice</field>
        <formula>0</formula>
        <name>Sales Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NFS_UpdateNumberOfLocations</fullName>
        <field>NumberOfLocations__c</field>
        <name>Update Number Of Locations</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <targetObject>OpportunityId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NFS_UpdateQuantity</fullName>
        <description>When any of the three products is added to an opportunity product line on an opportunity, it should default to null for both Quantity and Sales Price.</description>
        <field>Quantity</field>
        <formula>0</formula>
        <name>Update Quantity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NFS_UpdateRate</fullName>
        <field>FS_Rate__c</field>
        <formula>FS_Rate__c</formula>
        <name>Update Rate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>OpportunityId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NFS_UpdateRate</fullName>
        <field>FS_Rate__c</field>
        <formula>Opportunity.FS_Rate__c</formula>
        <name>Update Rate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>NFS Update Opportunity Product</fullName>
        <actions>
            <name>NFS_UpdateRate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.UnitPrice</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>To update Number of Locations and Rate fields on opportunity product</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
