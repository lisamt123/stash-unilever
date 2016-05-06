<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>WWP_Loss_Type_DC_FU</fullName>
        <field>Loss_Type__c</field>
        <literalValue>Dispatch Compliance</literalValue>
        <name>WWP Loss Type DC FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WWP_Loss_Type_MRP_FU</fullName>
        <field>Loss_Type__c</field>
        <literalValue>MRP Compliance</literalValue>
        <name>WWP Loss Type MRP FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WWP_Loss_Type_OR_FU</fullName>
        <field>Loss_Type__c</field>
        <literalValue>Output Reliability</literalValue>
        <name>WWP Loss Type OR FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WWP_Loss_Update_in_SFDC_False_FU</fullName>
        <field>Loss_Updated_in_Salesforce__c</field>
        <literalValue>0</literalValue>
        <name>WWP_Loss Update in SFDC False FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WWP_Loss_Update_in_SFDC_True_FU</fullName>
        <field>Loss_Updated_in_Salesforce__c</field>
        <literalValue>1</literalValue>
        <name>WWP Loss Update in SFDC True FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WWP Loss Type MRP WF</fullName>
        <actions>
            <name>WWP_Loss_Type_MRP_FU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Actual_Receipt__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Planned_Receipt__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WWP_Loss Update in SCDG True WF</fullName>
        <actions>
            <name>WWP_Loss_Update_in_SFDC_True_FU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Sub_Family__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Description__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WWP_Loss Update in SFDC False WF</fullName>
        <actions>
            <name>WWP_Loss_Update_in_SFDC_False_FU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Name__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Sub_Family__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Loss_Description__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WWP_LossType_DC_WF</fullName>
        <actions>
            <name>WWP_Loss_Type_DC_FU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Actual_Dispatch__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Planned_Dispatch__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Actual_Production__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Planned_Production__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WWP_LossType_OR_WF</fullName>
        <actions>
            <name>WWP_Loss_Type_OR_FU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Actual_Production__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Planned_Production__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Actual_Dispatch__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WWP_Loss_Tree__c.Planned_Dispatch__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
