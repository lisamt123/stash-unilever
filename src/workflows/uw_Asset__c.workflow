<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Order_Of_Display_for_new_Assets</fullName>
        <field>Order_Of_Display__c</field>
        <formula>IF(ISNEW(),IF(uw_BET__r.No_Of_Asset_Items__c==0, 0,uw_BET__r.Max_of_Order_Of_Display__c+1),IF(PRIORVALUE(Promoted__c)==False,uw_BET__r.Max_of_Order_Of_Display__c+1, Order_Of_Display__c))</formula>
        <name>Update Order Of Display for new Assets</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>New Assets Moving to Toolkit</fullName>
        <actions>
            <name>Update_Order_Of_Display_for_new_Assets</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>uw_Asset__c.Promoted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>uw_Asset__c.Studio_Asset_Type__c</field>
            <operation>notEqual</operation>
            <value>Brand Experience Presentation</value>
        </criteriaItems>
        <description>Assigning order to new assets moving to toolkit</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
