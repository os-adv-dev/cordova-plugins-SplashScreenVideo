#!/usr/bin/env node

const fs = require('fs');
const fetch = require('node-fetch');
const path = require("path");

module.exports = function(context) {
    return new Promise((resolve, reject) => {
        // Get the command-line arguments passed to the plugin
        const args = process.argv;

        // Find the URL parameter from the arguments
        var url = null;
        for (const arg of args) {  
          if (arg.includes('VIDEO_URL')){
            var stringArray = arg.split("=");
            url = stringArray.slice(-1).pop();
          }
        }

        // If the URL parameter is found, download the file
        if (url) {
            console.log("⬇️ Downloading file from: ", url);

            var dest = path.join(context.opts.projectRoot,"plugins" ,"com.cordova.plugin.splashscreenvideo" ,"src" , "SplashScreen.mp4".toLowerCase());

            fetch(url)
                .then(response => {
                    const fileStream = fs.createWriteStream(dest);
                    response.body.pipe(fileStream);
                    response.body.on("error", (err) => {
                        console.error("🚨 Error writing to file:", err);
                        reject(err);
                    });
                    fileStream.on("finish", function() {
                        console.log('✅ File downloaded and saved to', dest);
                        resolve();
                    });
                })
                .catch(error => {
                    console.error("🚨 Error downloading the file:", error);
                    reject(error);
                });
        } else {
            console.error("🚨 URL parameter not found in arguments.");
            reject(new Error("URL parameter not found"));
        }
    });
};
