# Cordova Video Splash Screen Plugin

![OutSystems Logo](https://www.outsystems.com/apple-touch-icon.png)

This plugin allows Cordova apps to use a video as a splash screen on both iOS and Android platforms. The video will play immediately when the app is launched.

## Getting Started

To install the plugin using the Cordova CLI, run the following command:

cordova plugin add https://github.com/os-adv-dev/cordova-plugins-SplashScreenVideo.git

## Preferences

### Global Preferences

- **SPLASH_BACKGROUND_COLOR**: Set the background color of the splash screen. Accepts standard color formats in HEX.
- **FADE_DURATION**: Sets the fade duration for the splash screen. The default value is `0.7`. It likely represents the time in seconds for the fade effect.
- **VIDEO_URL**: The URL of the video that will be used as the splash screen. For example: `https://file-examples.com/storage/fe235481fb64f1ca49a92b5/2017/04/file_example_MP4_1280_10MG.mp4`.

### iOS Specific Preferences

- **DARK_STATUSBAR**: Determines whether the status bar should appear dark during the splash screen on iOS devices. The default value is `true`.

### Setting Preferences in OutSystems

If you're implementing this plugin in an OutSystems application, set these preferences in the Extensibility Configuration of the plugin wrapper module:

```json
{
  "plugin": {
    "url": "https://github.com/os-adv-dev/cordova-plugins-SplashScreenVideo.git",
    "variables": [
      {
        "name": "SPLASH_BACKGROUND_COLOR",
        "value": "#FFFFFF"
      },
      {
        "name": "FADE_DURATION",
        "value": "0.7"
      },
      {
        "name": "DARK_STATUSBAR",
        "value": "true"
      },
      {
        "name": "VIDEO_URL",
        "value": "https://file-examples.com/storage/fe235481fb64f1ca49a92b5/2017/04/file_example_MP4_1280_10MG.mp4"
      }
    ]
  }
}
```
### Credits
This plugin was created by André Grillo - OutSystems

### License
This plugin is licensed under the Apache License, Version 2.0. See the LICENSE file for more details.
