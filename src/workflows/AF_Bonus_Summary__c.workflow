<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AF_Email_To_Agency_ReadyForPO</fullName>
        <ccEmails>saranya.s117cb1@cognizant.com</ccEmails>
        <ccEmails>bhaskar.reddy2@cognizant.com</ccEmails>
        <description>AF_Email_To_Agency_ReadyForPO</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/AF_Email_To_Agency_ReadyForPO</template>
    </alerts>
    <alerts>
        <fullName>AF_Email_To_BonusApprover_PendingApproval</fullName>
        <ccEmails>saranya.s117cb1@cognizant.com</ccEmails>
        <ccEmails>bhaskar.reddy2@cognizant.com</ccEmails>
        <description>AF_Email_To_BonusApprover_PendingApproval</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/AF_Email_To_BonusApprover_PendingApproval</template>
    </alerts>
    <alerts>
        <fullName>AF_Email_To_CF_OnRejection</fullName>
        <ccEmails>saranya.s117cb1@cognizant.com</ccEmails>
        <ccEmails>bhaskar.reddy2@cognizant.com</ccEmails>
        <description>AF_Email_To_CF_OnRejection</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/AF_Email_To_CF_OnRejection</template>
    </alerts>
    <alerts>
        <fullName>AF_Email_To_CF_ReadyForPO</fullName>
        <ccEmails>saranya.s117cb1@cognizant.com</ccEmails>
        <ccEmails>bhaskar.reddy2@cognizant.com</ccEmails>
        <description>AF_Email_To_CF_ReadyForPO</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/AF_Email_To_CF_ReadyForPO</template>
    </alerts>
    <alerts>
        <fullName>AF_Email_To_CMCO_PendingSubmission</fullName>
        <ccEmails>saranya.s117cb1@cognizant.com</ccEmails>
        <ccEmails>bhaskar.reddy2@cognizant.com</ccEmails>
        <description>AF_Email_To_CMCO_PendingSubmission</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/AF_Email_To_CMCO_PendingSubmission</template>
    </alerts>
    <fieldUpdates>
        <fullName>update_key</fullName>
        <field>key__c</field>
        <formula>AF_Agency__r.Name &amp;&quot;|&quot;&amp;  AF_Brand__r.Name &amp;&quot;|&quot;&amp; AF_Fiscal_Year__c</formula>
        <name>update key</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AF_Email_To_BonusApprover_PendingApproval</fullName>
        <actions>
            <name>AF_Email_To_BonusApprover_PendingApproval</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>AF_Bonus_Summary__c.AF_Status__c</field>
            <operation>equals</operation>
            <value>With Approver</value>
        </criteriaItems>
        <description>Triggers Email to Bonus Approver from CF</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AF_Email_To_CFAgency_ReadyForPO</fullName>
        <actions>
            <name>AF_Email_To_Agency_ReadyForPO</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AF_Email_To_CF_ReadyForPO</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AF_Bonus_Summary__c.AF_Status__c</field>
            <operation>equals</operation>
            <value>Ready For PO</value>
        </criteriaItems>
        <description>Triggers Email to CF &amp; Agency when Bonus Matrix is ready for po</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AF_Email_To_CF_OnRejection</fullName>
        <actions>
            <name>AF_Email_To_CF_OnRejection</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>AF_Bonus_Summary__c.AF_Status__c</field>
            <operation>equals</operation>
            <value>W/Cat Finance</value>
        </criteriaItems>
        <criteriaItems>
            <field>AF_Bonus_Summary__c.AF_StatusFromApprover__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>Triggers Email to CF when Bonus Approver rejects the Bonus Matrix</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AF_Email_To_CMCO_PendingSubmission</fullName>
        <actions>
            <name>AF_Email_To_CMCO_PendingSubmission</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>AF_Bonus_Summary__c.AF_Status__c</field>
            <operation>equals</operation>
            <value>With CMCO</value>
        </criteriaItems>
        <criteriaItems>
            <field>AF_Bonus_Summary__c.AF_StatusFromApprover__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Triggers Email to CMCO when Bonus Approver approves the Bonus Matrix</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>update key</fullName>
        <actions>
            <name>update_key</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
