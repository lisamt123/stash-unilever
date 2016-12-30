@isTest(SeeAllData=false)
Private class UL_ProductPartTriggerUtil_Test{
    private static Integer UNIT_PER_CASE =10;
    @testSetup
    private static void CreateTestData(){
    //Create Product Template record
    ACCL__Product_Template__c testProdTemp = new ACCL__Product_Template__c();
    testProdTemp.Name ='Product Template for test';
    testProdTemp.ACCL__Active__c =True;
    testProdTemp.ACCL__Sales_Org__c = 'AR01';
    testProdTemp.ACCL__Description_Language_1__c ='English';
    insert testProdTemp;
    
    //Create Product Record    
    ACCL__Product__c testProd = new ACCL__Product__c();
    testProd.Name ='TestProduct';
    testProd.ACCL__Product_Template__c =testProdTemp.id;
    testProd.ACCL__Product_Code__c = '1234';
    testProd.ACCL__Product_Level__c = 'Producto';
    testProd.ACCL__Description_1_Language_1__c ='English1';
    
    insert testProd;
    
    //Create Product2 Record    
    ACCL__Product__c testProd1 = new ACCL__Product__c();
    testProd1.Name ='TestProduct1';
    testProd1.ACCL__Product_Template__c = testProdTemp.id;
    testProd1.ACCL__Product_Code__c = '12345';
    testProd1.ACCL__Product_Level__c = 'Producto';
    testProd1.ACCL__Description_1_Language_1__c ='English2';
    
    insert testProd1;
    
    //Create UOM record on Product2 record
    ACCL__Unit_of_Measure__c testUoM = new ACCL__Unit_of_Measure__c();
    testUoM.ACCL__Product__c = testProd1.id;
    testUoM.ACCL__Unit_Type__c ='ConsumerUnit';
    testUoM.ACCL__Sort__c = 2;
    testUoM.UL_UnitsPerCase__c = UNIT_PER_CASE;
    
    insert testUoM;     
    }
    
    //Testing while calculating CU Quantity values
    @isTest
    private static void CalCUQUantity(){
        Id parentProdId, childProdId;
        List<ACCL__Product__c> Prod = [SELECT Id, Name FROM ACCL__Product__c WHERE Name IN ('TestProduct','TestProduct1')];
    
        for(ACCL__Product__c tProd : Prod){
            if(tProd.Name.equals('TestProduct')){
                parentProdId = tProd.id;
            }
            else{
                childProdId = tProd.id;
            }
        }
    //Creat Product Part(BoM) record
    ACCL__Product_Part__c ProdPart = new ACCL__Product_Part__c();
    ProdPart.ACCL__Parent_Product__c = parentProdId;
    ProdPart.ACCL__Child_Product__c = childProdId ;
    ProdPart.ACCL__Quantity__c =40;
    ProdPart.ACCL__Valid_From__c = Date.TODAY();
    ProdPart.ACCL__Valid_Thru__c = Date.Today();
    
    insert ProdPart;   
    List<ACCL__Product_Part__c> InProdPart = [SELECT Id, Name, UL_CU_Quantity__c FROM ACCL__Product_Part__c WHERE ID =:ProdPart.ID ];
    system.assertEquals(InProdPart[0].UL_CU_Quantity__c,UNIT_PER_CASE * ProdPart.ACCL__Quantity__c);
    
    ProdPart.ACCL__Quantity__c =50;
    update ProdPart;
    InProdPart = [SELECT Id, Name, UL_CU_Quantity__c FROM ACCL__Product_Part__c WHERE ID =:ProdPart.ID ];
    system.assertEquals(InProdPart[0].UL_CU_Quantity__c,UNIT_PER_CASE * ProdPart.ACCL__Quantity__c);
    }
}