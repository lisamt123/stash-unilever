<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AF_SendEmailToCatFinance</fullName>
        <description>AF_SendEmailToCatFinance</description>
        <protected>false</protected>
        <recipients>
            <recipient>AF_Category_Finance_Email</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/AF_Email_To_CatFinance_ToEnterActuals_HTML</template>
    </alerts>
    <alerts>
        <fullName>Email_to_send_out_when_Currency_Update_is_Required</fullName>
        <ccEmails>reetha.joseph@cognizant.com</ccEmails>
        <description>Email to send out when Currency Update is Required</description>
        <protected>false</protected>
        <recipients>
            <recipient>AF_CMCO_Super_User</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/AF_CurrencyUpdate_HTML</template>
    </alerts>
    <rules>
        <fullName>AF_SendEmailBonusQuartToCatFinance</fullName>
        <actions>
            <name>AF_SendEmailToCatFinance</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Send_Email__c.sendEmailBonusQuartToCatFinance__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AF_SendEmailToCatFinance</fullName>
        <actions>
            <name>AF_SendEmailToCatFinance</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Send_Email__c.sendEmailToCatFinance__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Currency Update Required</fullName>
        <actions>
            <name>Email_to_send_out_when_Currency_Update_is_Required</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Send_Email__c.AF_CurrencyUpdateRequired__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
