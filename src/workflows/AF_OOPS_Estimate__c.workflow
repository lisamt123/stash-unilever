<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>OOPS_Estimate_Comment</fullName>
        <field>AF_isComment__c</field>
        <literalValue>1</literalValue>
        <name>OOPS Estimate Comment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Crossborder</fullName>
        <field>AF_Is_Crossborder_Wk__c</field>
        <formula>IF( AF_IsCrossBorder__c , &apos;True&apos;, &apos;False&apos;)</formula>
        <name>Update Crossborder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>oopsActualEstStatus</fullName>
        <field>oopsEstimateStatus__c</field>
        <formula>Text(AF_Status__c)</formula>
        <name>oopsActualEstStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AF_OOPS_Actual__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>AF_oopsEstimateStatusUpdate</fullName>
        <actions>
            <name>oopsActualEstStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AF_OOPS_Estimate__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OOPS Estimate Checked</fullName>
        <actions>
            <name>OOPS_Estimate_Comment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AF_isComment__c == false &amp;&amp; priorvalue( AF_Estimate__c )&gt;0 &amp;&amp; ischanged(AF_Estimate__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Is Crossborder Field Rule</fullName>
        <actions>
            <name>Update_Crossborder</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>AF_OOPS_Estimate__c.AF_IsCrossBorder__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>AF_OOPS_Estimate__c.AF_IsCrossBorder__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This is used to update Is Crossborder field.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
