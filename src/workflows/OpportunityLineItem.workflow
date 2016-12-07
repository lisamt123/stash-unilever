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
        <fullName>FS_DIST_TMI_To_Copy_of_Dist_TMI</fullName>
        <description>Copy DIST TMI To Non Formula Field</description>
        <field>Copy_of_DIST_TMI__c</field>
        <formula>FS_DISTTMI__c</formula>
        <name>FS DIST TMI To Copy of Dist TMI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Total_COGS_To_Copy_of_Total_COGS</fullName>
        <description>FS Total COGS To Copy of Total COGS</description>
        <field>FS_Copy_of_Total_COGS__c</field>
        <formula>TotalCOGS__c</formula>
        <name>FS Total COGS To Copy of Total COGS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_UpdateSalesPrice</fullName>
        <description>Updating sales price to zero.</description>
        <field>UnitPrice</field>
        <formula>0</formula>
        <name>Update Sales Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
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
        <reevaluateOnChange>true</reevaluateOnChange>
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
    <fieldUpdates>
        <fullName>FS_UpdateuniqueProduct</fullName>
        <description>Update the unique product field to restrict adding same products to opportunity.</description>
        <field>FS_UniqueProduct__c</field>
        <formula>OpportunityId+Product2Id</formula>
        <name>FS Update unique Product</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FS_NSV_CALCULATION</fullName>
        <description>Update FS NSV CALCULATION</description>
        <field>FS_NSV_CALCULATION__c</field>
        <formula>IF( ISPICKVAL(  CurrencyIsoCode, &apos;CAD&apos;) , Quantity * PricebookEntry.FS_Bracket_3__c * 0.99, Quantity * PricebookEntry.FS_Bracket_1__c * 0.99)</formula>
        <name>Update FS NSV CALCULATION</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>FS Adding Unique Products</fullName>
        <actions>
            <name>FS_UpdateuniqueProduct</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Created to restrict adding same products to opportunity.</description>
        <formula>AND($Profile.Name=&quot;Unilever Food Solution - Russia&quot;,  Opportunity.RecordType.Name =&quot;RUFS Opportunity TPR&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FS Copy DIST TMI and COGS To Non Formula Field</fullName>
        <actions>
            <name>FS_DIST_TMI_To_Copy_of_Dist_TMI</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FS_Total_COGS_To_Copy_of_Total_COGS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy DIST TMI and Total COGS To Non Formula Field. Needed to roll-up DIST TMI formula field to the Opportunity</description>
        <formula>OR(
ISCHANGED(FS_DISTTMI__c),
ISCHANGED(TotalCOGS__c),
NOT(ISBLANK(FS_DISTTMI__c)),
NOT(ISBLANK(TotalCOGS__c))
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
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
        <fullName>FS NSV Calculation</fullName>
        <actions>
            <name>Update_FS_NSV_CALCULATION</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Quantity</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Calculate NSV for Canada or US</description>
        <triggerType>onAllChanges</triggerType>
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
        <description>If 100% discount for samples ordering, the lines items should be flagged as samples</description>
        <formula>AND(Opportunity.RecordType.DeveloperName= &apos;FS_OpportunityTPR&apos;, Discount = 1)</formula>
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
