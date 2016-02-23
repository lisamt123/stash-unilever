public with sharing class UtkarshRatingController{

    public Integer pcTimeMangCategoryValue {get;set;}
    public Integer pcCostMangCategoryValue {get;set;}
    public Integer pcProcessMangCategoryValue {get;set;}
    public Integer pcOutputQualityCategoryValue{get;set;}
    public Integer pccTimeMangCategoryValue {get;set;}
    public Integer pccCostMangCategoryValue {get;set;}
    public Integer pccProcessMangCategoryValue{get;set;}
    public Integer pccOutputQualityCategoryValue {get;set;}
    public Integer caTimeMangCategoryValue {get;set;}
    public Integer caCostMangCategoryValue {get;set;}
    public Integer caProcessMangCategoryValue{get;set;}
    public Integer caOutputQualityCategoryValue {get;set;}
    
    
    public void getPcTimeMangCategory(){
        
      System.debug('Pc TIME MANAGEMENT  ->  '+ pcTimeMangCategoryValue);
    }
   /*
    public void getPcCostMangCategory(){
        
      
    }
    public void getPcProcessMangCategory(){
        
      
    }
    public void getPcOutputQualityCategory(){
        
      
    }
    public void getPpcTimeMangCategory(){
        
      
    }
    public void getPpcCostMangCategory(){
        
      
    }
    public void getPpcProcessMangCategory(){
        
      
    }
    public void getPpcOutputQualityCategory(){
        
      
    }
    public void getCaTimeMangCategory(){
        
      
    }
    public void getCaCostMangCategory(){
        
      
    }
    public void getCaProcessMangCategory(){
        
      
    }
    
    public void getCaOutputQualityCategory(){
        
      
    } */
    
    public void AllValues(){
        
        System.debug('Pc TIME MANAGEMENT  ->  '+ pcTimeMangCategoryValue);
        System.debug('PC COST MANAGE MENT -> '+ pcCostMangCategoryValue);
        System.debug(' PC PROCESS MANAGEMNT -> '+ pcProcessMangCategoryValue );
        System.debug('PC OUTPUT -> '+ pcOutputQualityCategoryValue );
        System.debug('PPC TIME MAN --> ' +  pccTimeMangCategoryValue);
        System.debug('PPC COST -> ' + pccCostMangCategoryValue );
        System.debug('PPC PROCESS MANG -> '+ pccProcessMangCategoryValue);
        System.debug('PPC OUTPUT -> ' + pccOutputQualityCategoryValue  );
        System.debug('CA TIME MANG ->'+ caTimeMangCategoryValue);
        System.debug('CA COST MANG -> '+ caCostMangCategoryValue );
        System.debug('CA PROCESS MANG -> ' + caProcessMangCategoryValue);
        System.debug('CA OUTPUR -> '+ caOutputQualityCategoryValue );
        
      
    }
    

}