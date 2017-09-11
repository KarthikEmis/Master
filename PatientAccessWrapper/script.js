document.onreadystatechange = function () {
    if(document.readyState === "complete"){
        webkit.messageHandlers.readyHandler.postMessage("");
    }
}
