# How to Sideload Apps on a Supernote Device

Supernote devices have a limited list of apps that can be installed. These apps are listed under Settings > Apps > Supernote App Store. But you can install other
Android apps through a process called sideloading. Sideloading means bypassing an app store like the built in Supernote App store.

This opens the door to customize your Supernote device even further. But, with great power, comes great responsibility.

> [!WARNING]
> Before sideloading apps it is highly recommended to backup all the data on your Supernote device.
> Sideloading apps can lead to data loss. But it's not as scary as it sounds. Do your due diligence before
> installing any app and have fun boosting the functionality of your Supernote device.

> [!NOTE]
> Not all android apps will function correctly on a Supernote device. And even if they work, they might not provide
> the best user experience as they might not be optimized for eink screens.

> [!NOTE]
> Only download apps from trusted sources and only and install apps that you have vetted. Keep in mind that malicious software can be introduced
> to your device if using a compromised app package. Again, do your due diligence.

## Overview

Sideloading requires installing ADB (Android Debug Bridge) on a host machine machine running Windows, Linux, or MacOS. ADB is the communication serve as the
bridge (pun intended) between your Supernote device and a desktop/laptop computer.

ADB is used for a variety of tasks, but this guide will only cover installing apps through ADB.

## Download ADB

ADB doesn't require being installed on your computer. You can just download it, unzip, and start using it.

Navigate to [SDK Platform Tools](https://developer.android.com/tools/releases/platform-tools) and download the zip file for the correct OS.

After unzipping, you should have a folder called ```platform-tools```. This is where the ```adb``` executable live.

## Enable Sideloading on Supernote Device

Go to ```Settings > Security & Privacy``` and make sure ```Sideloading``` is toggled.

## Connect Supernote to Computer

Use a USB cable to connect the Supernote device to your computer. You might have to enter the lock screen password for the device to be accessible from your computer.

## Open Terminal

The easiest way to do this on a Windows computer is to navigate to the ```platform-tools``` folder in File Explorer and type ```cmd``` in the address bar.

This will open a terminal session under the correct folder containing the ```adb.exe``` program.

If you are on Linux, I'm sure you know how to open a terminal window and navigate to the correct folder. So, I won't patronize you :smile:
Just remember to ```chmod +x adb``` if it is not executable after unzipping.

If you are on a Mac, I am sorry :grin:

## Check ADB Connection

Try the commands below to make sure ADB can see the Supernote device.

Windows
```
adb.exe devices
```

Linux/Mac
```
./adb devices
```

You should see an output that looks like this.
```
List of devices attached
SN00000222002020 device
```

## Install the app

Find an ```.apk``` from a reputable source and install onto your device.

Windows
```
adb.exe install \path\to\file.apk
```

Linux/Mac
```
./abd /path/to/file.apk
```

That's it! Not so scary, right?