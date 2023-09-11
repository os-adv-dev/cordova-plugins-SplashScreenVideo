# Cordova Video Splash Screen Plugin

This plugin allows Cordova apps to use a video as a splash screen on both iOS and Android platforms. The video will play immediately when the app is launched.

## Getting Started

To install the plugin using the Cordova CLI, run the following command:

cordova plugin add https://github.com/os-adv-dev/cordova-plugins-SplashScreenVideo.git

## Preferences

### Global Preferences

- **SPLASH_BACKGROUND_COLOR**: Set the background color of the splash screen. Accepts standard color formats in HEX.
- **VIDEO_URL**: The URL of the video that will be used as the splash screen. For example: `https://github.com/os-adv-dev/public-resources/raw/main/ONE-LED-Intro.mp4`.

### iOS Specific Preferences

- **DARK_STATUSBAR**: Determines whether the status bar should appear dark during the splash screen on iOS devices. The default value is `true`.
- **FADE_DURATION**: Sets the fade duration for the splash screen. The default value is `0.7`. It likely represents the time in seconds for the fade effect.

### Clobbers
```
cordova.plugins.CDVSplashScreenVideo
```

### License
This plugin is licensed under the Apache License, Version 2.0. See the LICENSE file for more details.
