  function areYouSure(element,confirmationText,elementText){
        if(confirm(confirmationText)){
            element.value = elementText;
            return true;
        }
        return false;
    }