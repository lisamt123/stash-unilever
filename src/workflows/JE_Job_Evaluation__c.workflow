<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>JE_Change_Score_Workflow</fullName>
        <field>Change_Score_Workflow__c</field>
        <formula>Change_Score__c</formula>
        <name>JE Change Score Workflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>JE_Job_Grade_of_Line_Manager</fullName>
        <field>Job_Grade_of_Line_Manager_Workflow__c</field>
        <formula>Job_Grade_of_Line_Manager_Score__c-1</formula>
        <name>JE Job Grade of Line Manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>JE_No_of_Direct_Reports_Update</fullName>
        <field>No_of_Direct_Reports_Workflow__c</field>
        <formula>Number_of_Direct_Reports_Score__c</formula>
        <name>JE No. of Direct Reports Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>JE_Problem_Solving</fullName>
        <description>Used to store the Problem Solving unweighted score that is used to calculate the weighted score</description>
        <field>Problem_Solving_Workflow__c</field>
        <formula>Problem_Solving_Score__c</formula>
        <name>JE Problem Solving</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>JE_Turnover_Direct_Accountability</fullName>
        <field>Turnover_Direct_Accountability_Workflow__c</field>
        <formula>Turnover_Direct_Accountability_Score__c</formula>
        <name>JE Turnover Direct Accountability</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>JE_Turnover_LM_s_Accountability</fullName>
        <field>Turnover_LM_s_Accountability_Workflow__c</field>
        <formula>Turnover_LM_s_Accountability_Score__c</formula>
        <name>JE Turnover LM&apos;s Accountability</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>JE Change Score Workflow</fullName>
        <actions>
            <name>JE_Change_Score_Workflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>JE_Job_Evaluation__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Used to store the Change Score value from the Change Score formula field in order to calculate the weighted Change Score value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JE Job Line of Manager Workflow</fullName>
        <actions>
            <name>JE_Job_Grade_of_Line_Manager</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>JE_Job_Evaluation__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Used to store the value of the Job Line of Manager score to use in Reporting Layer Validation calculation</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JE No%2E of Direct Reports Update</fullName>
        <actions>
            <name>JE_No_of_Direct_Reports_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>JE_Job_Evaluation__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Used to bypass formula compile errors. This value * multiplier = Total Score (weighted)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JE Problem Solving Workflow</fullName>
        <actions>
            <name>JE_Problem_Solving</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>JE_Job_Evaluation__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JE Turnover Direct Accountability Workflow</fullName>
        <actions>
            <name>JE_Turnover_Direct_Accountability</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>JE_Job_Evaluation__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Used to calculate the weighted score for Turnover - Direct Accountability</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JE Turnover LM%27s Accountability Workflow</fullName>
        <actions>
            <name>JE_Turnover_LM_s_Accountability</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>JE_Job_Evaluation__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Used to store the value from the Turnover LM&apos;s Accountability Score CASE field which can then be used to calculate overall score</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
