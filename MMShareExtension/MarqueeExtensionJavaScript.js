var MarqueeMakerExtension = function() {};

MarqueeMakerExtension.prototype = {
run: function(arguments) {
    
//    var images = document.querySelectorAll('img[src$=".gif"]');
//    
//    var urls = [];
//    
//    Array.prototype.forEach.call(images, function (image) {
//                                 if (image.src.length > 0) {
//                                 
//                                 urls.push(image.src);
//
//                                 
//                                 }
//                                 });
    var images = document.querySelectorAll('img[src$=".gif"]');
    var srcList = [];
    for(var i = 0; i < images.length; i++) {
        srcList.push(images[i].src);
    }
    
    arguments.completionFunction(srcList);

//    console.log(urls);
}


}

var ExtensionPreprocessingJS = new MarqueeMakerExtension;