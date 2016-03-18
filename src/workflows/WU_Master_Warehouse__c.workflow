<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval for Committed PalletStorage</fullName>
        <protected>false</protected>
        <recipients>
            <field>WU_WarehouseManager_Email__c</field>
            <type>email</type>
        </recipients>
        <template>Warehouse_Utilization/Warehouse_Committed_Capacity</template>
    </alerts>
    <alerts>
        <fullName>Approve Committed Warehouse Utilization</fullName>
        <ccEmails>vaishali.thite@cognizant.com</ccEmails>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <template>Warehouse_Utilization/Warehouse_Committed_Capacity</template>
    </alerts>
    <alerts>
        <fullName>Notify WarehousePOC</fullName>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <template>Warehouse_Utilization/WU_Warehouse_Committed_StoragetoPOC</template>
    </alerts>
    <alerts>
        <fullName>WU ApprovalNotification</fullName>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <template>Warehouse_Utilization/WU_Warehouse_Committed_StoragetoPOC</template>
    </alerts>
    <alerts>
        <fullName>WU ApprovalRequest</fullName>
        <protected>false</protected>
        <recipients>
            <field>WU_WarehouseManager_Email__c</field>
            <type>email</type>
        </recipients>
        <template>Warehouse_Utilization/Warehouse_Committed_Capacity</template>
    </alerts>
    <alerts>
        <fullName>Warehouse capacity below committed capacity%21</fullName>
        <ccEmails>vaishali.thite@cognizant.com</ccEmails>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <template>Warehouse_Utilization/Capacity_Verification_Required</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approved</fullName>
        <field>WU_Approval_Status__c</field>
        <formula>&apos;Approved&apos;</formula>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reject Committed PalletStorage</fullName>
        <description>after rejection revert committed pallet storage</description>
        <field>WU_Committed_Max_PalletStorage__c</field>
        <formula>WU_Prior_CommittedPalletStorage__c</formula>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected</fullName>
        <field>WU_Approval_Status__c</field>
        <formula>&apos;Rejected&apos;</formula>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Revert Prior value</fullName>
        <field>WU_Prior_CommittedPalletStorage__c</field>
        <formula>WU_Prior_CommittedPalletStorage__c</formula>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetPriorValueForCommittedPallet</fullName>
        <field>WU_Committed_Max_PalletStorage__c</field>
        <formula>WU_Prior_CommittedPalletStorage__c</formula>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted</fullName>
        <field>WU_Approval_Status__c</field>
        <formula>&apos;Submitted&apos;</formula>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WU Update Warehouse Capacity Record Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Edit_Warehouse_Capacity</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WU AutoSubmitApproval</fullName>
        <active>false</active>
        <description>Whenever Max Committed Pallet Storage value will change Auto submit approval notification</description>
        <formula>WU_Committed_Max_PalletStorage__c  &lt;&gt;  WU_Prior_CommittedPalletStorage__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WU Change Warehouse Capacity Record Type</fullName>
        <actions>
            <name>WU Update Warehouse Capacity Record Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Change Record type of Record when record is created.</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WU MaxCommitted PalleStorage</fullName>
        <active>false</active>
        <description>Whenever Max Committed Pallet Storage value will change make flag true</description>
        <formula>IF( PRIORVALUE( WU_Committed_Max_PalletStorage__c )  &lt;&gt; WU_Committed_Max_PalletStorage__c, true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WU_Warehouse Capacity Limit Exceed Notification</fullName>
        <actions>
            <name>Warehouse capacity below committed capacity%21</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>whenever Warehouse capacity will exceed 80%: system shall send notification to Warehouse Excellence Operations user.</description>
        <formula>AND(WU_Committed_Max_PalletStorage__c &gt;0, 
(WU_Current_Utilization__c  /  WU_Committed_Max_PalletStorage__c)*100 &gt;= 80)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
