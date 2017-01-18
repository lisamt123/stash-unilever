Public class KUN_Links implements Comparable {

    public String Id {get;set;}
       
    public String Title{get;set;}
    
    public String LinkURL{get;set;}
    public String URL{get;set;}
    public String CSSStyle{get;set;}
    
    public datetime LinkDate{get;set;}
    
    public String ShortDescription{get;set;}
    
  
        /**
        * The comparator method used in sorting
        *
        * @param obj The object to compare to
        * @return the integer value of the comparison between the objects
        */
        public Integer compareTo(Object obj) {
        
            KUN_Links moLinks= (KUN_Links )(obj);
            if (this.LinkDate > moLinks.LinkDate ) {
                return 1;
            }
            return 0;
        }

  }