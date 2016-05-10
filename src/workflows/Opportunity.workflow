<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>NAFS Email to opportunity owner when Deal approval exactly 60 days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.NAFSDealApproved__c</field>
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
    <rules>
        <fullName>NFS Update Profitability Checkbox</fullName>
        <actions>
            <name>NFS_UpdateProfitable1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.NFS_PBIPercent__c</field>
            <operation>greaterOrEqual</operation>
            <value>20</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.NFS_CUMCFYear2__c</field>
            <operation>greaterThan</operation>
            <value>EUR 0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
