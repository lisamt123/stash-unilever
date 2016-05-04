<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AR_Application_Has_Passed_the_Initial_Review</fullName>
        <description>AR Application Has Passed the Initial Review</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Roster/AR_Application_Request_has_Passed_Initial_Review</template>
    </alerts>
    <alerts>
        <fullName>AR_Application_Rejected_at_Initial_Review</fullName>
        <description>AR Application Rejected at Initial Review</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Roster/AR_Application_Rejected_at_Initial_Review</template>
    </alerts>
    <alerts>
        <fullName>AR_Application_is_Approved</fullName>
        <description>AR Application is Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Roster/AR_Application_is_Approved</template>
    </alerts>
    <alerts>
        <fullName>AR_Application_is_Rejected_at_Final_Stage</fullName>
        <description>AR Application is Rejected at Final Stage</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Roster/AR_Application_Rejected_At_Final_Stage</template>
    </alerts>
    <alerts>
        <fullName>AR_Application_is_Submitted</fullName>
        <description>AR Application is Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>General_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Roster/AR_Application_Submitted</template>
    </alerts>
    <alerts>
        <fullName>AR_Send_Login_details_to_Agency</fullName>
        <description>AR - Send Login details to Agency</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Roster/AR_Send_Agency_Login_Details</template>
    </alerts>
    <fieldUpdates>
        <fullName>AR_Application_Status_Set_Final_Review</fullName>
        <field>Status__c</field>
        <literalValue>Final Review</literalValue>
        <name>AR Application Status Set Final Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AR_Application_Status_Set_Initial_Review</fullName>
        <field>Status__c</field>
        <literalValue>Initial Review</literalValue>
        <name>AR Application Status Set Initial Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AR_Application_Status_Set_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>AR Application Status Set Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AR_Application_Status_is_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>AR Application Status is Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AR_Cannot_Reapply_Until_date</fullName>
        <field>Cannot_reapply_until__c</field>
        <formula>Today() + 180</formula>
        <name>AR Cannot Reapply Until Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AR - Send Agency login details</fullName>
        <actions>
            <name>AR_Send_Login_details_to_Agency</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ar_Application__c.Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Send login details to Agency when they just got registered in the Portal.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
