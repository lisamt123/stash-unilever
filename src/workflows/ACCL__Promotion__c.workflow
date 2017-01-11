<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>UL_SoCo_Workflow_Approved</fullName>
        <description>SoCo Workflow - Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/UL_SoCo_Promotion_Approved</template>
    </alerts>
    <fieldUpdates>
        <fullName>Org_Update</fullName>
        <field>UL_Sales_Organization__c</field>
        <formula>ACCL__Sales_Org__c</formula>
        <name>Org Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_CurrentStatus_Approved</fullName>
        <field>UL_Current_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>CurrentStatus_Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_CurrentStatus_BandedPackApproved</fullName>
        <field>UL_Current_Status__c</field>
        <literalValue>Banded Pack Approved</literalValue>
        <name>CurrentStatus_BandedPackApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_CurrentStatus_DirectorCheck</fullName>
        <field>UL_Current_Status__c</field>
        <literalValue>Director Check</literalValue>
        <name>CurrentStatus_DirectorCheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_CurrentStatus_FinanceCheck</fullName>
        <field>UL_Current_Status__c</field>
        <literalValue>Finance Check</literalValue>
        <name>CurrentStatus_FinanceCheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_CurrentStatus_ManagerCheck</fullName>
        <field>UL_Current_Status__c</field>
        <literalValue>Manager Check</literalValue>
        <name>CurrentStatus_ManagerCheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_CurrentStatus_Planning</fullName>
        <field>UL_Current_Status__c</field>
        <literalValue>Planning</literalValue>
        <name>CurrentStatus_Planning</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_In_Store_End_Date_Update</fullName>
        <description>Updates the In-Store End Date</description>
        <field>ACCL__Placement_Date_Thru__c</field>
        <formula>ACCL__Date_Thru__c</formula>
        <name>In-Store End Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_Sharing_Type_Text_Update</fullName>
        <field>UL_Sharing_Type_Txt__c</field>
        <formula>UL_Sharing_Type_Form__c</formula>
        <name>Sharing Type Text Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_Shipment_End_Date_Update</fullName>
        <description>Updates  the shipment date in the promotion when the End date of the promotion is updated</description>
        <field>ACCL__Delivery_Date_Thru__c</field>
        <formula>ACCL__Date_Thru__c</formula>
        <name>Shipment End Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_UpdateInStoreDateFrom</fullName>
        <field>ACCL__Placement_Date_From__c</field>
        <formula>ACCL__Date_From__c</formula>
        <name>UL_UpdateInStoreDateFrom</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_UpdateInStoreDateThru</fullName>
        <field>ACCL__Placement_Date_Thru__c</field>
        <formula>ACCL__Date_Thru__c</formula>
        <name>UL_UpdateInStoreDateThru</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_UpdateOrderDateFrom</fullName>
        <description>Update order date from</description>
        <field>ACCL__Order_Date_From__c</field>
        <formula>ACCL__Date_From__c</formula>
        <name>UL_UpdateOrderDateFrom</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_UpdateOrderDateThru</fullName>
        <description>Update order date Thru</description>
        <field>ACCL__Order_Date_Thru__c</field>
        <formula>ACCL__Date_Thru__c</formula>
        <name>UL_UpdateOrderDateThru</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_UpdateShipmentDateFrom</fullName>
        <field>ACCL__Delivery_Date_From__c</field>
        <formula>ACCL__Date_From__c</formula>
        <name>UL_UpdateShipmentDateFrom</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_UpdateShipmentDateThru</fullName>
        <field>ACCL__Delivery_Date_Thru__c</field>
        <formula>ACCL__Date_Thru__c</formula>
        <name>UL_UpdateShipmentDateThru</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UL_Update_Slogan</fullName>
        <field>ACCL__Slogan_Language_1__c</field>
        <formula>IF(  ISPICKVAL(ACCL__Promotion_Template__r.UL_Promo_Type_ControlView__c,&apos;LTA&apos; ) ,UL_Account__r.Name+&apos;-&apos;+  UL_Category__c +&apos;-&apos;+   UL_Brand__c +&apos;-&apos;+TEXT(UL_Feature__c) +&apos;-&apos;+ TEXT(DAY(ACCL__Placement_Date_From__c)) +&apos;/&apos;+ TEXT(MONTH(ACCL__Placement_Date_From__c))+&apos;/&apos;+ TEXT(YEAR(ACCL__Placement_Date_From__c))  +&apos;-&apos;+ 
TEXT(DAY(ACCL__Placement_Date_Thru__c)) +&apos;/&apos;+ TEXT(MONTH(ACCL__Placement_Date_Thru__c))+&apos;/&apos;+ TEXT(YEAR(ACCL__Placement_Date_Thru__c))  +&apos;-&apos;+
UL_Free_Text__c, UL_Account__r.Name+&apos;-&apos;+  UL_Category__c +&apos;-&apos;+   UL_Brand__c +&apos;-&apos;+TEXT(UL_Mechanic__c) +&apos;-&apos;+  TEXT(UL_Sub_Mechanic__c) +&apos;-&apos;+  TEXT(UL_Feature__c) +&apos;-&apos;+ TEXT(DAY(ACCL__Placement_Date_From__c)) +&apos;/&apos;+ TEXT(MONTH(ACCL__Placement_Date_From__c))+&apos;/&apos;+ TEXT(YEAR(ACCL__Placement_Date_From__c))  +&apos;-&apos;+ 
TEXT(DAY(ACCL__Placement_Date_Thru__c)) +&apos;/&apos;+ TEXT(MONTH(ACCL__Placement_Date_Thru__c))+&apos;/&apos;+ TEXT(YEAR(ACCL__Placement_Date_Thru__c))  +&apos;-&apos;+ UL_Free_Text__c)</formula>
        <name>UL_Update Slogan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ACCL__Update Promotion Record Type</fullName>
        <active>false</active>
        <criteriaItems>
            <field>ACCL__Promotion__c.ACCL__Phase__c</field>
            <operation>equals</operation>
            <value>Committed,Cancelled</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sales Org Update on Promotion</fullName>
        <actions>
            <name>Org_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ACCL__Promotion__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UL_Promotion_End_Date_Update</fullName>
        <actions>
            <name>UL_In_Store_End_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UL_Shipment_End_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow is to update all the End dates in a promotion when the Promotion End date is updated in the End Date Status</description>
        <formula>ISCHANGED(  ACCL__Date_Thru__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UL_Sharing_ Type_ Update</fullName>
        <actions>
            <name>UL_Sharing_Type_Text_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UL_Update_Promotion_Name</fullName>
        <actions>
            <name>UL_Update_Slogan</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ACCL__Anchor_Account__c != null &amp;&amp;  ACCL__Promotion_Template__r.UL_Calculate_Slogan_Name__c = true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
