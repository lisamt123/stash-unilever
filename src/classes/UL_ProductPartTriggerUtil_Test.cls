@isTest(SeeAllData=false)
Private class UL_ProductPartTriggerUtil_Test{
    private static Integer UNIT_PER_CASE =10;
    @testSetup
    private static void CreateTestData(){
    //Create Product Template record
    ACSFUL001__Product_Template__c testProdTemp = new ACSFUL001__Product_Template__c();
    testProdTemp.Name ='Product Template for test';
    testProdTemp.ACSFUL001__Active__c =True;
    testProdTemp.ACSFUL001__Sales_Org__c = 'AR01';
    testProdTemp.ACSFUL001__Description_Language_1__c ='English';
    insert testProdTemp;
    
    //Create Product Record    
    ACSFUL001__Product__c testProd = new ACSFUL001__Product__c();
    testProd.Name ='TestProduct';
    testProd.ACSFUL001__Product_Template__c =testProdTemp.id;
    testProd.ACSFUL001__Product_Code__c = '1234';
    testProd.ACSFUL001__Product_Level__c = 'Producto';
    testProd.ACSFUL001__Description_1_Language_1__c ='English1';
    
    insert testProd;
    
    //Create Product2 Record    
    ACSFUL001__Product__c testProd1 = new ACSFUL001__Product__c();
    testProd1.Name ='TestProduct1';
    testProd1.ACSFUL001__Product_Template__c = testProdTemp.id;
    testProd1.ACSFUL001__Product_Code__c = '12345';
    testProd1.ACSFUL001__Product_Level__c = 'Producto';
    testProd1.ACSFUL001__Description_1_Language_1__c ='English2';
    
    insert testProd1;
    
    //Create UOM record on Product2 record
    ACSFUL001__Unit_of_Measure__c testUoM = new ACSFUL001__Unit_of_Measure__c();
    testUoM.ACSFUL001__Product__c = testProd1.id;
    testUoM.ACSFUL001__Unit_Type__c ='ConsumerUnit';
    testUoM.ACSFUL001__Sort__c = 2;
    testUoM.UL_UnitsPerCase__c = UNIT_PER_CASE;
    
    insert testUoM;     
    }
    
    //Testing while calculating CU Quantity values
    @isTest
    private static void CalCUQUantity(){
        Id parentProdId, childProdId;
        List<ACSFUL001__Product__c> Prod = [SELECT Id, Name FROM ACSFUL001__Product__c WHERE Name IN ('TestProduct','TestProduct1')];
    
        for(ACSFUL001__Product__c tProd : Prod){
            if(tProd.Name.equals('TestProduct')){
                parentProdId = tProd.id;
            }
            else{
                childProdId = tProd.id;
            }
        }
    //Creat Product Part(BoM) record
    ACSFUL001__Product_Part__c ProdPart = new ACSFUL001__Product_Part__c();
    ProdPart.ACSFUL001__Parent_Product__c = parentProdId;
    ProdPart.ACSFUL001__Child_Product__c = childProdId ;
    ProdPart.ACSFUL001__Quantity__c =40;
    ProdPart.ACSFUL001__Valid_From__c = Date.TODAY();
    ProdPart.ACSFUL001__Valid_Thru__c = Date.Today();
    
    insert ProdPart;   
    List<ACSFUL001__Product_Part__c> InProdPart = [SELECT Id, Name, UL_CU_Quantity__c FROM ACSFUL001__Product_Part__c WHERE ID =:ProdPart.ID ];
    system.assertEquals(InProdPart[0].UL_CU_Quantity__c,UNIT_PER_CASE * ProdPart.ACSFUL001__Quantity__c);
    
    ProdPart.ACSFUL001__Quantity__c =50;
    update ProdPart;
    InProdPart = [SELECT Id, Name, UL_CU_Quantity__c FROM ACSFUL001__Product_Part__c WHERE ID =:ProdPart.ID ];
    system.assertEquals(InProdPart[0].UL_CU_Quantity__c,UNIT_PER_CASE * ProdPart.ACSFUL001__Quantity__c);
    }
}