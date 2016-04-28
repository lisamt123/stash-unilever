<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Disable_CEC</fullName>
        <description>TO : Disabling the &apos;IsCEC&apos; checkbox.</description>
        <field>IsCEC__c</field>
        <literalValue>0</literalValue>
        <name>Disable CEC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Disable_George</fullName>
        <description>TO : Disabling the &apos;IsGeorge&apos; Check box</description>
        <field>IsGeorge__c</field>
        <literalValue>0</literalValue>
        <name>Disable George</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Enable_CEC</fullName>
        <description>Enabling the &apos;IsCEC&apos; check box</description>
        <field>IsCEC__c</field>
        <literalValue>1</literalValue>
        <name>Enable CEC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Enable_George</fullName>
        <description>TO : Enabling the &apos;IsGeorge&apos; checkbox.</description>
        <field>IsGeorge__c</field>
        <literalValue>1</literalValue>
        <name>Enable George</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TO Reason Code Check%28Both CEC%2FGeorge%29</fullName>
        <actions>
            <name>Enable_CEC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Enable_George</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>TO :  Check whether the L5 Code belongs to &apos;CEC / George&apos;.</description>
        <formula>LEFT(L5_Code__c, 2) = &apos;CG&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TO Reason Code Check%28Only CEC%2FNo Match%29</fullName>
        <actions>
            <name>Disable_George</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Enable_CEC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>TO : checks whether the L5 Code belongs to CEC or not.</description>
        <formula>AND((LEFT(L5_Code__c, 1) != &apos;_&apos;),(LEFT(L5_Code__c, 2) != &apos;CG&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TO Reason Code Check%28Only George%29</fullName>
        <actions>
            <name>Disable_CEC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Enable_George</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>TO : Check whether &apos;L5 Code&apos; belongs to George or not.</description>
        <formula>LEFT(L5_Code__c, 2) = &apos;_G&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
