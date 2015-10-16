var MarqueeMakerExtension = function() {};

MarqueeMakerExtension.prototype = {
run: function(arguments) {
    arguments.completionFunction({"baseURI" : document.baseURI});
}
    
finalize: function(arguments) {
    marqueeWrapper(arguments["marqueeTagNames"]);

}
}

var ExtensionPreprocessingJS = new MarqueeMakerExtension;