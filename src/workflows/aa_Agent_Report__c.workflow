<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AA_Add_New_Brand_Review_To_ETS</fullName>
        <ccEmails>hampesh.pda@gmail.com</ccEmails>
        <description>AA Add New Brand Review To ETS</description>
        <protected>false</protected>
        <recipients>
            <recipient>ETS_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AA_Email_Templates/AA_ETS_To_CIManager_Add_New_Brand</template>
    </alerts>
    <alerts>
        <fullName>AA_ETS_To_CIManager_Add_New_Brand_Review</fullName>
        <ccEmails>asleshagujarathi@gmail.com</ccEmails>
        <description>AA ETS To CIManager Add New Brand Review</description>
        <protected>false</protected>
        <recipients>
            <recipient>CI_Manager_Default</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AA_Email_Templates/AA_ETS_To_CIManager_Add_New_Brand</template>
    </alerts>
    <rules>
        <fullName>AA Other Brand Notification to CI</fullName>
        <actions>
            <name>AA_ETS_To_CIManager_Add_New_Brand_Review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>aa_Agent_Report__c.Status__c</field>
            <operation>equals</operation>
            <value>CI Manager Approval Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>aa_Agent_Report__c.OtherBrandName__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>aa_Agent_Report__c.OtherCompanyName__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <description>This workflow will send email to CI cluster manager when report is assigned to them</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AA Other Brand Notification to ETS</fullName>
        <actions>
            <name>AA_Add_New_Brand_Review_To_ETS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>aa_Agent_Report__c.OtherBrandName__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>aa_Agent_Report__c.OtherCompanyName__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
