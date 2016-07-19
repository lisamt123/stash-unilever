<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CI_Project_lead</fullName>
        <field>Project_Lead__c</field>
        <literalValue>Niraj Kothari</literalValue>
        <name>CI_Project lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_Project_lead3</fullName>
        <field>Project_Lead__c</field>
        <literalValue>Nikoletta Pinter</literalValue>
        <name>CI_Project lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_Project_lead5</fullName>
        <field>Project_Lead__c</field>
        <literalValue>Sankar/ Cristina</literalValue>
        <name>CI_Project lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_R2R_Update_Project</fullName>
        <field>Project2__c</field>
        <formula>Project__c</formula>
        <name>CI_R2R Update Project#</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_Team_Lead4</fullName>
        <field>Project_Lead__c</field>
        <literalValue>Niraj/ Murali</literalValue>
        <name>CI_Team Lead4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_Update_Lead</fullName>
        <field>Project_Lead__c</field>
        <literalValue>Henry Cardenas</literalValue>
        <name>CI_Update Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_Update_Lead1</fullName>
        <field>Project_Lead__c</field>
        <literalValue>Tomasz Mis</literalValue>
        <name>CI_Update Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_Update_Lead_field</fullName>
        <field>Project_Lead__c</field>
        <literalValue>Padma Prasad</literalValue>
        <name>CI_Update Lead field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_lead_field_update</fullName>
        <field>Project_Lead__c</field>
        <literalValue>Valeria Gulyas</literalValue>
        <name>CI_lead field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CI_Populate Project Lead1</fullName>
        <actions>
            <name>CI_Update_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CI_R2R_Innovation__c.R2R_SME_Area__c</field>
            <operation>equals</operation>
            <value>Project,Tools</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CI_Populate Project Lead2</fullName>
        <actions>
            <name>CI_Project_lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CI_R2R_Innovation__c.R2R_SME_Area__c</field>
            <operation>equals</operation>
            <value>JE,MDM,Period-End,SAP Roles</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CI_Populate Project Lead3</fullName>
        <actions>
            <name>CI_Update_Lead1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CI_R2R_Innovation__c.R2R_SME_Area__c</field>
            <operation>equals</operation>
            <value>AccRec</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CI_Populate Project Lead4</fullName>
        <actions>
            <name>CI_lead_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CI_R2R_Innovation__c.R2R_SME_Area__c</field>
            <operation>equals</operation>
            <value>CI</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CI_Populate Project Lead5</fullName>
        <actions>
            <name>CI_Update_Lead_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CI_R2R_Innovation__c.R2R_SME_Area__c</field>
            <operation>equals</operation>
            <value>FA</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CI_Populate Project Lead6</fullName>
        <actions>
            <name>CI_Project_lead3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CI_R2R_Innovation__c.R2R_SME_Area__c</field>
            <operation>equals</operation>
            <value>FR,Tax</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CI_Populate Project Lead7</fullName>
        <actions>
            <name>CI_Team_Lead4</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CI_R2R_Innovation__c.R2R_SME_Area__c</field>
            <operation>equals</operation>
            <value>FX Reval</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CI_Populate Project Lead8</fullName>
        <actions>
            <name>CI_Project_lead5</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CI_R2R_Innovation__c.R2R_SME_Area__c</field>
            <operation>equals</operation>
            <value>Inter-co</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CI_R2R Update Project%23 for CI Funnel</fullName>
        <actions>
            <name>CI_R2R_Update_Project</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CI_R2R_Innovation__c.Project__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
