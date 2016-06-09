<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_to_Opp_Owner</fullName>
        <description>Email Alert to Opp Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NAFS_Email_Templates/NAFS_Email_to_opportunity_owner_when_Deal_approval_exactly_60_days</template>
    </alerts>
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
