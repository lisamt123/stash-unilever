/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CoreNTImportCtlTest {
   static testMethod void testMethodForImportingValidXMLDocument(){
    Test.StartTest();
    
    CoreNTImportCtl impProjController = new CoreNTImportCtl();
    impProjController.fileName = '';
    
    String username = Userinfo.getUserEmail();
    
    String xml='';
    impProjController.fileBody = Blob.valueOf(xml);
    impProjController.importTemplateXML();
    
    Brand_Centre_New__c brandCentreObject1=new Brand_Centre_New__c();
    brandCentreObject1.Category__c='Homecare';
    brandCentreObject1.Sub_Category__c='Household Care';
    brandCentreObject1.Name='AXE';
        
    Brand_Centre_New__c brandCentreObject2=new Brand_Centre_New__c();
    brandCentreObject2.Category__c='Personal Care';
    brandCentreObject2.Sub_Category__c='Skin Care';
    brandCentreObject2.Name='Vaseline';
        
    Brand_Centre_New__c brandCentreObject3=new Brand_Centre_New__c();
    brandCentreObject3.Category__c='Laundry';
    brandCentreObject3.Sub_Category__c='Dressings';
    brandCentreObject3.Name='Glorix';
        
    //CoreNTImportCtl impProjController = new CoreNTImportCtl();
    impProjController.fileName = 'fileName5.xml';
    xml='<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+
                    '<Project xmlns="http://schemas.microsoft.com/project">'+
                    '<Title>Sample_MPP_One1239090</Title>'+
                    '<StartDate>2014-03-05T08:00:00</StartDate>'+
                    '<FinishDate>2014-03-31T17:00:00</FinishDate>'+
                    '<Tasks>'+
                        '<Task>'+
                            '<UID>111</UID>'+
                            '<Name>XUnit Test Summary Task 2</Name>'+
                            '<OutlineNumber>2</OutlineNumber>'+
                            '<PercentComplete>1</PercentComplete>'+
                            '<Critical>1</Critical>'+
                            '<Start>2014-03-10T08:00:00</Start>'+
                            '<Finish>2014-03-10T17:00:00</Finish>'+
                            '<Milestone>0</Milestone>'+ 
                            '<Summary>1</Summary>'+
                        '</Task>'+
                        '<Task>'+
                            '<UID>73</UID>'+
                            '<Name>Task1</Name>'+
                            '<OutlineNumber>2.1</OutlineNumber>'+
                            '<PercentComplete>1</PercentComplete>'+
                            '<Critical>1</Critical>'+
                            '<Start>2014-03-10T08:00:00</Start>'+
                            '<Finish>2014-03-10T17:00:00</Finish>'+
                            '<Milestone>0</Milestone>'+ 
                            '<Summary>0</Summary>'+
                            '<PredecessorLink>'+
                                '<PredecessorUID>91</PredecessorUID>'+
                                '<Type>1</Type>'+
                                '<CrossProject>0</CrossProject>'+
                                '<LinkLag>0</LinkLag>'+
                                '<LagFormat>7</LagFormat>'+
                            '</PredecessorLink>'+
                        '</Task>'+
                        '<Task>'+
                            '<UID>74</UID>'+
                            '<Name>Task2</Name>'+
                            '<OutlineNumber>2.2</OutlineNumber>'+
                            '<PercentComplete>100</PercentComplete>'+
                            '<Critical>1</Critical>'+
                            '<Start>2014-03-10T08:00:00</Start>'+
                            '<Finish>2014-03-10T17:00:00</Finish>'+
                            '<Milestone>1</Milestone>'+ 
                            '<Summary>0</Summary>'+
                        '</Task>'+
                    '</Tasks>'+
                    '<Resources>'+
                        '<Resource>'+
                            '<UID>1</UID>'+
                            '<Name>Hinal</Name>'+           
                            '<Initials>Shah</Initials>'+
                            '<Group>NO</Group>'+            
                            '<EmailAddress>hinal_shah@mindtree.com</EmailAddress>'+         
                        '</Resource>'+
                        '<Resource>'+
                            '<UID>2</UID>'+
                            '<Name>Satish</Name>'+          
                            '<Initials>O</Initials>'+
                            '<Group>NO</Group>'+            
                            '<EmailAddress>'+username+'</EmailAddress>'+            
                        '</Resource>'+
                        '<Resource>'+
                            '<UID>3</UID>'+
                            '<Name>Pradeep</Name>'+         
                            '<Initials>R</Initials>'+
                            '<Group>TP</Group>'+            
                            '<EmailAddress>pradeep_ramanagoudadodamani@mindtree.com</EmailAddress>'+            
                        '</Resource>'+
                    '</Resources>'+
                    '<Assignments>'+
                        '<Assignment>'+
                            '<TaskUID>91</TaskUID>'+
                            '<ResourceUID>1</ResourceUID>'+
                        '</Assignment>'+
                    '</Assignments>'+
                    '</Project>'    ;
                    
    impProjController.fileBody = Blob.valueOf(xml);
    impProjController.importTemplateXML();
    
    impProjController.getCategoryItems();
    impProjController.getSubcategoryItems();
    impProjController.getBrandItems();
        
    impProjController.updateProject();
    impProjController.cancelAction();
    
    Test.StopTest();        
   }
   static testMethod void testMethodForImportingInValidXMLDocument(){
    Test.StartTest();
    CoreNTImportCtl impProjController2 = new CoreNTImportCtl();
    String username = Userinfo.getUserEmail();
    impProjController2.fileName = 'fileName6.xml';
    String xml='<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+
                    '<Project xmlns="http://schemas.microsoft.com/project">'+
                    '<Title>Sample_MPP_One1245988</Title>'+
                    '<Resources>'+
                        '<Resource>'+
                            '<UID>1</UID>'+
                            '<Name>Hinal</Name>'+           
                            '<Initials>Shah</Initials>'+
                            '<Group>NO</Group>'+            
                            '<EmailAddress>'+username+'</EmailAddress>'+            
                        '</Resource>'+
                        '<Resource>'+
                            '<UID>2</UID>'+
                            '<Name>Satish</Name>'+          
                            '<Initials>O</Initials>'+
                            '<Group>SL</Group>'+            
                            '<EmailAddress>satish_osuri@mindtree.com</EmailAddress>'+           
                        '</Resource>'+
                        '<Resource>'+
                            '<UID>5</UID>'+
                            '<Name>Pradeep</Name>'+         
                            '<Initials>R</Initials>'+
                            '<Group>TP</Group>'+            
                            '<EmailAddress></EmailAddress>'+            
                        '</Resource>'+
                        '<Resource>'+
                            '<UID>4</UID>'+
                            '<Name>Sindhu</Name>'+          
                            '<Initials>R</Initials>'+
                            '<Group>TP</Group>'+            
                            '<EmailAddress>sindhu_thazheoyyoth@mindtree.com</EmailAddress>'+            
                        '</Resource>'+
                        '<Resource>'+
                            '<UID>6</UID>'+
                            '<Name>Sindhu</Name>'+          
                            '<Initials>R</Initials>'+
                            '<Group></Group>'+          
                        '</Resource>'+
                    '</Resources>'+
                    '<Assignments>'+
                        '<Assignment>'+
                            '<TaskUID>101</TaskUID>'+
                            '<ResourceUID>1</ResourceUID>'+
                        '</Assignment>'+
                        '<Assignment>'+
                            '<TaskUID>101</TaskUID>'+
                            '<ResourceUID>2</ResourceUID>'+
                        '</Assignment>'+
                        '<Assignment>'+
                            '<TaskUID></TaskUID>'+
                            '<ResourceUID>2</ResourceUID>'+
                        '</Assignment>'+
                        '<Assignment>'+
                            '<TaskUID>102</TaskUID>'+
                            '<ResourceUID></ResourceUID>'+
                        '</Assignment>'+
                        '<Assignment>'+
                        '</Assignment>'+
                    '</Assignments>'+
                    '</Project>'    ;
                      impProjController2.fileBody = Blob.valueOf(xml);
                      impProjController2.importTemplateXML();
    Test.StopTest();        
    
   }
   static testMethod void testMethodForImportingInValidXMLDocument2(){
       Test.StartTest();
       CoreNTImportCtl impProjController3 = new CoreNTImportCtl();
       String username = Userinfo.getUserEmail();
       impProjController3.fileName = 'fileName8.xml';             
       String xml='<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+
                    '<Project xmlns="http://schemas.microsoft.com/project">'+
                    '<Title>Sample_MPP_One123678</Title>'+
                    '<Tasks>'+
                        '<Task>'+
                            '<UID>0</UID>'+
                            '<Name>XUnit Test Summary Task 2</Name>'+
                            '<OutlineNumber>2</OutlineNumber>'+
                            '<PercentComplete>1</PercentComplete>'+
                            '<PercentWorkComplete>1</PercentWorkComplete>'+
                            '<Critical>1</Critical>'+
                            '<Start>2014-03-10T08:00:00</Start>'+
                            '<Milestone>0</Milestone>'+ 
                        '</Task>'+
                        '<Task>'+
                            '<UID>91</UID>'+
                            '<Name>XUnit Test Summary Task 2</Name>'+
                            '<OutlineNumber>2</OutlineNumber>'+
                            '<PercentComplete>1</PercentComplete>'+
                            '<Start>2014-03-10T08:00:00</Start>'+
                            '<Finish>2014-03-10T17:00:00</Finish>'+
                            '<Milestone>0</Milestone>'+ 
                            '<Summary>1</Summary>'+
                        '</Task>'+
                        '<Task>'+
                            '<UID>101</UID>'+
                            '<OutlineNumber>2.1</OutlineNumber>'+
                            '<PercentComplete>1</PercentComplete>'+
                            '<Critical>1</Critical>'+
                            '<Start>2014-03-10T08:00:00</Start>'+
                            '<Finish>2014-03-10T17:00:00</Finish>'+
                            '<Milestone>0</Milestone>'+ 
                            '<Summary>0</Summary>'+                         
                        '</Task>'+
                        '<Task>'+
                            '<UID>102</UID>'+
                            '<Name>Task2</Name>'+
                            '<OutlineNumber>2.2</OutlineNumber>'+
                            '<PercentComplete>100</PercentComplete>'+
                            '<Critical>1</Critical>'+
                            '<Start>2014-03-10T08:00:00</Start>'+
                            '<Finish>2014-03-10T17:00:00</Finish>'+
                            '<Milestone>1</Milestone>'+ 
                            '<Summary>0</Summary>'+
                        '</Task>'+
                        '<Task>'+
                            '<UID>103</UID>'+
                            '<Name>Task3</Name>'+
                            '<OutlineNumber>2.3</OutlineNumber>'+
                            '<PercentComplete>100</PercentComplete>'+
                            '<Critical>1</Critical>'+
                            '<Start>2014-03-10T08:00:00</Start>'+
                            '<Finish>2014-03-10T17:00:00</Finish>'+
                            '<Milestone>0</Milestone>'+ 
                            '<Summary>0</Summary>'+
                            '<PredecessorLink>'+
                                '<PredecessorUID>101</PredecessorUID>'+
                                '<Type>1</Type>'+
                                '<CrossProject>0</CrossProject>'+
                                '<LinkLag>0</LinkLag>'+
                                '<LagFormat>7</LagFormat>'+
                            '</PredecessorLink>'+
                        '</Task>'+
                        '<Task>'+
                            '<UID>92</UID>'+
                            '<Name>XUnit Test Summary Task 3</Name>'+
                            '<OutlineNumber>3</OutlineNumber>'+
                            '<PercentComplete>1</PercentComplete>'+
                            '<Critical>1</Critical>'+
                            '<Start>2014-03-10T08:00:00</Start>'+
                            '<Finish>2014-03-10T17:00:00</Finish>'+
                            '<Milestone>0</Milestone>'+ 
                            '<Summary>1</Summary>'+
                        '</Task>'+
                        '<Task>'+
                            '<UID>93</UID>'+
                            '<Name>XUnit Test Summary Task 4</Name>'+
                            '<OutlineNumber>3.1</OutlineNumber>'+
                            '<PercentComplete>1</PercentComplete>'+
                            '<Critical>1</Critical>'+
                            '<Start>2014-03-10T08:00:00</Start>'+
                            '<Finish>2014-03-10T17:00:00</Finish>'+
                            '<Milestone>0</Milestone>'+ 
                            '<Summary>1</Summary>'+
                        '</Task>'+
                        '<Task>'+
                            '<UID></UID>'+
                            '<Name></Name>'+
                            '<OutlineNumber></OutlineNumber>'+
                            '<PercentComplete></PercentComplete>'+
                            '<Critical></Critical>'+
                            '<Start></Start>'+
                            '<Finish></Finish>'+
                            '<Milestone></Milestone>'+  
                            '<Summary></Summary>'+
                        '</Task>'+
                        '<Task>'+
                        '<Milestone>1</Milestone>'+ 
                        '<Summary>0</Summary>'+ 
                        '</Task>'+
                        '<Task>'+
                        '<Milestone>0</Milestone>'+ 
                        '<Summary>1</Summary>'+ 
                        '</Task>'+
                        '<Task>'+
                        '<Milestone>0</Milestone>'+ 
                        '<Summary>0</Summary>'+ 
                        '</Task>'+
                    '</Tasks>'+
                    '<Resources>'+
                        '<Resource>'+
                            '<UID>1</UID>'+
                            '<Name>Hinal</Name>'+           
                            '<Initials>Shah</Initials>'+
                            '<Group>NO</Group>'+            
                            '<EmailAddress>'+username+'</EmailAddress>'+            
                        '</Resource>'+
                        '<Resource>'+
                            '<UID>2</UID>'+
                            '<Name>Satish</Name>'+          
                            '<Initials>O</Initials>'+
                            '<Group>SL</Group>'+            
                            '<EmailAddress>satish_osuri@mindtree.com</EmailAddress>'+           
                        '</Resource>'+
                        '<Resource>'+
                            '<UID>5</UID>'+
                            '<Name>Pradeep</Name>'+         
                            '<Initials>R</Initials>'+
                            '<Group>TP</Group>'+            
                            '<EmailAddress></EmailAddress>'+            
                        '</Resource>'+
                        '<Resource>'+
                            '<UID>4</UID>'+
                            '<Name>Sindhu</Name>'+          
                            '<Initials>R</Initials>'+
                            '<Group>TP</Group>'+            
                        '</Resource>'+
                        '<Resource>'+
                            '<UID>6</UID>'+
                            '<Name>Sindhu</Name>'+          
                            '<Initials>R</Initials>'+
                            '<Group></Group>'+          
                                    
                        '</Resource>'+
                    '</Resources>'+
                    '<Assignments>'+
                        '<Assignment>'+
                            '<TaskUID>101</TaskUID>'+
                            '<ResourceUID>1</ResourceUID>'+
                        '</Assignment>'+
                        '<Assignment>'+
                            '<TaskUID>101</TaskUID>'+
                            '<ResourceUID>2</ResourceUID>'+
                        '</Assignment>'+
                        '<Assignment>'+
                            '<TaskUID></TaskUID>'+
                            '<ResourceUID>2</ResourceUID>'+
                        '</Assignment>'+
                        '<Assignment>'+
                            '<TaskUID>102</TaskUID>'+
                            '<ResourceUID></ResourceUID>'+
                        '</Assignment>'+
                        '<Assignment>'+
                            
                        '</Assignment>'+
                    '</Assignments>'+
                    '</Project>'    ;
                      impProjController3.fileBody = Blob.valueOf(xml);
                      impProjController3.importTemplateXML();
                      Test.StopTest();
   }
}