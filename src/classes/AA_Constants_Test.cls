/**
 * Name:        -   AA_Constants_Test
 * @description -   This is the test class for AA_Constants Class to verify the Constants Class.
 * @Author      -   Aslesha R K     
 */
@isTest
public class AA_Constants_Test {
/*******************************************************************
Purpose: This method test whether the contants are defined.
********************************************************************/
    static testMethod void constantTest() {
        AA_Constants objConstant = new AA_Constants();
        system.assert(objConstant!=null);
    }
}