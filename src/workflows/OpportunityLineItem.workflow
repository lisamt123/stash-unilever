<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>FS_Fixed_Price_review</fullName>
        <description>FS_Fixed Price review</description>
        <protected>false</protected>
        <recipients>
            <field>FS_LineManager__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>FS_AFM_Approvers</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Fixed_Price_Review_of_Opportunity_Product</template>
    </alerts>

    <fieldUpdates>
        <fullName>FS_UpdateSalesPrice</fullName>
        <description>Updating sales price to zero.</description>
        <field>UnitPrice</field>
        <formula>0</formula>
        <name>Update Sales Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_UpdateSample</fullName>
        <description>It is updating sample equals to true when discount is 100%</description>
        <field>FS_Sample__c</field>
        <literalValue>1</literalValue>
        <name>Update Sample</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_UpdateTPRCalculationFlag</fullName>
        <description>This will set the TPR Calculation Flag to check</description>
        <field>FS_TPRCalculationFlag__c</field>
        <literalValue>1</literalValue>
        <name>FS UpdateTPRCalculationFlag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Update_Line_manager</fullName>
        <description>Update line manager field on Opportunity Product</description>
        <field>FS_LineManager__c</field>
        <formula>CreatedBy.Manager.Email</formula>
        <name>FS Update Line manager Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FS Fixed Price Process</fullName>
        <actions>
            <name>FS_Fixed_Price_review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.FS_FixedPrice__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>To send an email alert to Line manger and AFM users when fixed price is true</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FS Samples Ordering</fullName>
        <actions>
            <name>FS_UpdateSalesPrice</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FS_UpdateSample</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Discount</field>
            <operation>equals</operation>
            <value>100</value>
        </criteriaItems>
        <description>If 100% discount for samples ordering, the lines items should be flagged as samples</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FS TPRCalculationFlag</fullName>
        <actions>
            <name>FS_UpdateTPRCalculationFlag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.FS_TPRCalculationFlag__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This workflow will check if TPR Calculation Flag is unchecked. If unchecked, it will set it back to check which will immediately run the Opportunity Product Trigger</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FS Update Line manager</fullName>
        <actions>
            <name>FS_Update_Line_manager</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Line manager field value from record owner</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
