<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AF_Check_Bonus_Comment</fullName>
        <field>AF_isComment__c</field>
        <literalValue>1</literalValue>
        <name>Check Bonus Comment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_Update_Bonus_Currency</fullName>
        <field>AF_BonusMatrixCode__c</field>
        <formula>if( ISBLANK(AF_Rate_Currency__c)|| isnull(AF_Rate_Currency__c), AF_BonusMatrixCode__c,AF_Rate_Currency__c)</formula>
        <name>Update Bonus Currency</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bonus_Value</fullName>
        <field>AF_Value__c</field>
        <formula>AF_Value_Calc__c</formula>
        <name>Bonus Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Crossborder</fullName>
        <field>AF_CrossBorder_No__c</field>
        <formula>if( AF_IsCrossBorderNew__c ,1,0)</formula>
        <name>Update Crossborder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AF Matrix Currency Code</fullName>
        <actions>
            <name>AF_Update_Bonus_Currency</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Bonus Matrix Changed</fullName>
        <actions>
            <name>AF_Check_Bonus_Comment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AF_isComment__c =false &amp;&amp;  priorvalue(AF_Value__c )&gt;0 &amp;&amp; ischanged(AF_Value__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Check Cross Border</fullName>
        <actions>
            <name>Update_Crossborder</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy Calulcated Value to Matrix</fullName>
        <actions>
            <name>Bonus_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Not(AF_Overidden__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
