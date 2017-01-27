<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BFM_Rejection_email_alert_to_carrier_user</fullName>
        <description>BFM Rejection email alert to carrier user</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BFM_Email_Templates/BFM_Rejection_mail_to_Carrier_user</template>
    </alerts>
    <fieldUpdates>
        <fullName>BFM_Check_Request_Approved</fullName>
        <description>Flags as true the Request Approved field for Process Builder Triggering.</description>
        <field>Request_Approved__c</field>
        <literalValue>1</literalValue>
        <name>BFM Check Request Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
