<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Deal_Approved_Update_Step2</fullName>
        <description>To Update Deal Approved from false to true</description>
        <field>DealApproved__c</field>
        <literalValue>1</literalValue>
        <name>Deal Approved Update Step2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Approved_Update_set_to_false</fullName>
        <description>Deal approved update set as false when opportunity in final reject .</description>
        <field>DealApproved__c</field>
        <literalValue>0</literalValue>
        <name>Deal Approved Update set to false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Update</fullName>
        <field>DealApproved__c</field>
        <literalValue>0</literalValue>
        <name>Deal Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>NAFS Email to opportunity owner when Deal approval exactly 60 days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.DealApproved__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>05 – Won</value>
        </criteriaItems>
        <description>Any time Deal Approved on opportunity is set to True, it should expire in 61 days.By expire,that field should be set back to False &amp; Email must be sent to Opp Owner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Alert_to_Opp_Owner</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Deal_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
