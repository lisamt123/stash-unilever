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
private class CoreNTImportUtilityTest {
	
    static testMethod void importUtilityPositiveTest() {  
        
        CoreNTImportUtility xmlImport = new CoreNTImportUtility();
        String username = Userinfo.getUserEmail();
        System.debug('username '+username);
        String xml='<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+
                    '<Project xmlns="http://schemas.microsoft.com/project">'+
                    '<Title>Sample_MPP_One123</Title>'+
                    '<StartDate>2014-03-05T08:00:00</StartDate>'+
                    '<FinishDate>2014-03-31T17:00:00</FinishDate>'+
                    '<Tasks>'+
                        '<Task>'+
                            '<UID>0</UID>'+
                            '<Name>XUnit Test Summary Task 2</Name>'+
                            '<OutlineNumber>2</OutlineNumber>'+
                            '<PercentComplete>1</PercentComplete>'+
                            '<PercentWorkComplete>1</PercentWorkComplete>'+
                            '<Critical>1</Critical>'+
                            '<Start>2014-03-10T08:00:00</Start>'+
                            '<Finish>2014-03-10T17:00:00</Finish>'+
                            '<Milestone>0</Milestone>'+ 
                            '<Summary>1</Summary>'+
                        '</Task>'+
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
                            '<Name>Network</Name>'+         
                            '<Initials>Owner</Initials>'+
                            '<Group>NO</Group>'+            
                            '<EmailAddress>'+username+'</EmailAddress>'+            
                        '</Resource>'+
                        '<Resource>'+
                            '<UID>2</UID>'+
                            '<Name>Senior</Name>'+          
                            '<Initials>Leader</Initials>'+
                            '<Group>SL</Group>'+            
                            '<EmailAddress>satish_osuri@mindtree.com</EmailAddress>'+            
                        '</Resource>'+
                        '<Resource>'+
                            '<UID>3</UID>'+
                            '<Name>Task</Name>'+            
                            '<Initials>Performer</Initials>'+
                            '<Group>TP</Group>'+            
                            '<EmailAddress>pradeep_ramanagoudadodamani@mindtree.com</EmailAddress>'+         
                        '</Resource>'+
                    '</Resources>'+
                    '<Assignments>'+
                        '<Assignment>'+
                            '<TaskUID>73</TaskUID>'+
                            '<ResourceUID>1</ResourceUID>'+
                        '</Assignment>'+
                    '</Assignments>'+
                    '</Project>'    ;
            Blob xmlBlob = Blob.valueOf(xml);
            
            xmlImport.importProject(xmlBlob);
            //xmlImport.insertSalesforceObjects();
    }
    
    static testMethod void importUtilityNegativeTest() {
    	CoreNTImportUtility xmlImport = new CoreNTImportUtility();
        String username = Userinfo.getUserEmail();
    	String xml='<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+
                    '<Project xmlns="http://schemas.microsoft.com/project">'+
                    '<Title>Sample_MPP_One123</Title>'+
                    '<StartDate></StartDate>'+
                    '<FinishDate></FinishDate>'+
                    '<Tasks>'+
                        '<Task>'+
                        '</Task>'+
                        '<Task>'+
                            
                            '<Name>XUnit Test Summary Task 2</Name>'+
                            '<OutlineNumber>2</OutlineNumber>'+
                            '<PercentComplete></PercentComplete>'+
                            '<Critical>1</Critical>'+
                            '<Start></Start>'+
                            '<Finish></Finish>'+
                            
                        '</Task>'+
                        '<Task>'+
                            '<UID>101</UID>'+
                            '<Name>Task1</Name>'+
                            '<OutlineNumber>2.1</OutlineNumber>'+
                            '<PercentComplete>1</PercentComplete>'+
                            '<Critical>1</Critical>'+
                            '<Start>2014-03-10T08:00:00</Start>'+
                            '<Finish></Finish>'+
                            '<Milestone>0</Milestone>'+ 
                            '<Summary>0</Summary>'+                         
                        '</Task>'+
                        '<Task>'+
                            '<UID>102</UID>'+
                            '<OutlineNumber>2.2</OutlineNumber>'+
                            '<Critical>1</Critical>'+
                            '<Start>2014-03-10T08:00:00</Start>'+
                        '</Task>'+
                        '<Task>'+
                            '<UID>103</UID>'+
                            '<Name>Task3</Name>'+
                            '<OutlineNumber>2.3</OutlineNumber>'+
                            '<PercentComplete>100</PercentComplete>'+
                            '<Critical>1</Critical>'+
                            '<Start>2014-03-10T08:00:00</Start>'+
                            '<Finish>2014-03-07T17:00:00</Finish>'+
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
                            '<Finish>2014-03-10T17:00:00</Finish>'+
                            '<Summary>1</Summary>'+
                        '</Task>'+
                        '<Task>'+
                            '<UID>93</UID>'+
                            '<Name>XUnit Test Summary Task 4</Name>'+
                            '<OutlineNumber>3.1</OutlineNumber>'+
                            '<PercentComplete>1</PercentComplete>'+
                            '<Critical></Critical>'+
                            '<Milestone>0</Milestone>'+ 
                            '<Summary>1</Summary>'+
                        '</Task>'+
                        '<Task>'+
                           '<Name></Name>'+
                            '<OutlineNumber></OutlineNumber>'+
                            '<PercentComplete></PercentComplete>'+
                            '<Start></Start>'+
                            '<Finish></Finish>'+
                            '<Milestone></Milestone>'+  
                            
                        '</Task>'+
                        '<Task>'+
                        
                        '<Summary>0</Summary>'+ 
                        '</Task>'+
                        '<Task>'+
                        '<Milestone>1</Milestone>'+ 
                        '<Summary>1</Summary>'+ 
                        '</Task>'+
                        '<Task>'+
                        '<Milestone>0</Milestone>'+ 
                        '<Summary></Summary>'+ 
                        '</Task>'+
                    '</Tasks>'+
                    '<Resources>'+
                        '<Resource>'+
                            '<UID>1</UID>'+
                            '<Name>Network</Name>'+         
                            '<Initials>Owner</Initials>'+
                            '<Group>NO</Group>'+            
                            '<EmailAddress>'+username+'</EmailAddress>'+            
                        '</Resource>'+
                        '<Resource>'+
                            '<UID></UID>'+
                            '<Initials></Initials>'+
                            '<Group></Group>'+            
                            '<EmailAddress></EmailAddress>'+            
                        '</Resource>'+
                        '<Resource>'+
                            '<UID></UID>'+
                            '<Initials></Initials>'+
                            '<EmailAddress></EmailAddress>'+            
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
                    //xmlImport = new CoreNTImportUtility();
                    Blob xmlBlob = Blob.valueOf(xml);            
                    xmlImport.importProject(xmlBlob);
    
    }
    
}