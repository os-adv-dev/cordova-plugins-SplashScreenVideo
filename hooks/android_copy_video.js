var fs = require("fs");
var path = require("path");
var utils = require("./utilities");
var defer = require("q").defer();
var constants = {
  VideoFile: "SplashScreen.mp4"
};

module.exports = function(context) {
  
  var platform = context.opts.plugin.platform;
  var platformConfig = utils.getPlatformConfigs(platform);
  if (!platformConfig) {
    utils.handleError("Invalid platform", defer);
  }

  var wwwPath = utils.getResourcesFolderPath(context, platform, platformConfig);
  var sourceFilePath = path.join(context.opts.projectRoot,"plugins" ,"com.cordova.plugin.splashscreenvideo" ,"src" , constants.VideoFile);
  //path.join(context.opts.projectRoot, "platforms", "android", "app", "src", "main", "assets", "www", "SplashVideo", "SplashScreen.mp4");
  var destFilePath = path.join(context.opts.projectRoot,"plugins" ,"com.cordova.plugin.splashscreenvideo" ,"src" , constants.VideoFile.toLowerCase());
    console.log("⭐️ wwwPath: " + wwwPath);
    console.log("⭐️ sourceFilePath: " + sourceFilePath);
    console.log("⭐️ destFilePath: " + destFilePath);

  if (fs.existsSync(sourceFilePath)) {
    utils.copyFromSourceToDestPath(defer, sourceFilePath, destFilePath);  
    fs.copyFile(sourceFilePath, destFilePath, (err) => {
      if (err) throw err;
      console.log("⭐️ Video file copied successfuly to: " + destFilePath);
    });
  } else {
    utils.handleError("🚨 No source file (video file) found from resources", defer);
  }

  return defer.promise;
}