window.onload = function(){
    window.onerror = function(err) {
        log('window.onerror: ' + err)
    }
    
    document.body.style.backgroundColor = 'red';
    var allImage = document.querySelectorAll("img");
    
    var imageUrlsArray = new Array();
    var imageSizeArray = new Array();
    
    for(var i = 0;i < allImage.length;i++){
        var image = allImage[i];
        imageUrlsArray.push([image.getAttribute('src')]);
        image.setAttribute('id',i);
        
        var scale = image.height/image.width;
        imageSizeArray.push(scale);
        
        image.onclick = function(index){
            
            setupWebViewJavascriptBridge(function(bridge) {
                                         var uniqueId = 1
                                         
                                         
                                         bridge.callHandler('ClickImage', {'index': index.target.getAttribute('id')}, function(response) {
                                                            log('JS got response', response)
                                                            })
                                         });
            
        };
    }
    document.body.style.backgroundColor = "red";
    
    
    function setupWebViewJavascriptBridge(callback) {
        if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
        if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
        window.WVJBCallbacks = [callback];
        var WVJBIframe = document.createElement('iframe');
        WVJBIframe.style.display = 'none';
        WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
        document.documentElement.appendChild(WVJBIframe);
        setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
    }
    
    
    
    setupWebViewJavascriptBridge(function(bridge) {
                                 var uniqueId = 1
                                 function log(message, data) {
                                 var log = document.getElementById('log')
                                 var el = document.createElement('div')
                                 el.className = 'logLine'
                                 el.innerHTML = uniqueId++ + '. ' + message + ':<br/>' + JSON.stringify(data)
                                 if (log.children.length) { log.insertBefore(el, log.children[0]) }
                                 else { log.appendChild(el) }
                                 }
                                 
                                 bridge.registerHandler('testJavascriptHandler', function(data, responseCallback) {
                                                        log('ObjC called testJavascriptHandler with', data)
                                                        var responseData = { 'Javascript Says':'Right back atcha!' }
                                                        log('JS responding with', responseData)
                                                        responseCallback(responseData)
                                                        })
                                 
                                 document.body.appendChild(document.createElement('br'))
                                 
                                 
                                 bridge.callHandler('getImageUrls', {'imageUrl': imageUrlsArray,'imageSize':imageSizeArray}, function(response) {
                                                    log('JS got response', response)
                                                    })
                                 });
    
    
}