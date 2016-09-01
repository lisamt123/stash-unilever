<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CI_R2R_Project_Description</fullName>
        <field>Description__c</field>
        <formula>CIR2R_Innovation__r.Project_Description__c</formula>
        <name>CI_R2R Project Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_R2R_Project_Name</fullName>
        <field>Project_Name__c</field>
        <formula>CIR2R_Innovation__r.Project_Name__c</formula>
        <name>CI_R2R Project Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_R2R_Target_Closure_Date</fullName>
        <field>Target_Closure__c</field>
        <formula>CIR2R_Innovation__r.Target_Completion_Date__c</formula>
        <name>CI_R2R Target Closure Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_R2R_Update_Description_Null</fullName>
        <field>Description__c</field>
        <name>CI_R2R Update Description_Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_R2R_Update_PE_Null</fullName>
        <field>Project_Cat__c</field>
        <name>CI_R2R Update PE_Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_R2R_Update_RAG2_R</fullName>
        <field>RAG__c</field>
        <literalValue>Red</literalValue>
        <name>CI_R2R Update RAG2_R</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_R2R_Update_RAG_A</fullName>
        <field>RAG__c</field>
        <literalValue>Amber</literalValue>
        <name>CI_R2R Update RAG_A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_R2R_Update_RAG_G</fullName>
        <field>RAG__c</field>
        <literalValue>Green</literalValue>
        <name>CI_R2R Update RAG_G</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_R2R_Update_RAG_Null</fullName>
        <field>RAG__c</field>
        <name>CI_R2R Update RAG_Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_R2R_Update_Target_Date_Null</fullName>
        <field>Target_Closure__c</field>
        <name>CI_R2R Update Target Date_Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_R2R_Update_Project_Name_Null</fullName>
        <field>Project_Name__c</field>
        <name>C_R2R Update Project Name_Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Green</fullName>
        <field>RAG__c</field>
        <literalValue>Green</literalValue>
        <name>Update Green</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CI_R2R Populate Project Name and Project Description</fullName>
        <actions>
            <name>CI_R2R_Project_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CI_R2R_Project_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CI_R2R_Target_Closure_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>CIR2R_Innovation__c &lt;&gt; null</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CI_R2R Update RAG Color_A</fullName>
        <actions>
            <name>CI_R2R_Update_RAG_A</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( CIR2R_Innovation__c &lt;&gt; null , ISPICKVAL( CIR2R_Innovation__r.RAG__c , &apos;Amber&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CI_R2R Update RAG Color_G</fullName>
        <actions>
            <name>CI_R2R_Update_RAG_G</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL( CIR2R_Innovation__r.RAG__c , &apos;Green&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CI_R2R Update RAG Color_R</fullName>
        <actions>
            <name>CI_R2R_Update_RAG2_R</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL( CIR2R_Innovation__r.RAG__c , &apos;Red&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CI_R2R Update RAG%2CProject Name and Target Date_Null</fullName>
        <actions>
            <name>CI_R2R_Update_Description_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CI_R2R_Update_PE_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CI_R2R_Update_RAG_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CI_R2R_Update_Target_Date_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>C_R2R_Update_Project_Name_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(CIR2R_Innovation__c = null, RecordType.DeveloperName = &apos;CI_SME_with_CI&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
