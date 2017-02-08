function handleKeyPress(e){
    if (window.event && window.event.keyCode == 13 || e.which == 13) {
        searchAf();
    }
}