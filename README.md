# mägic.ObsClient-demo
A demo of mägic.ObsClient

This is a work in progress of Demo of [mägic.ObsClient](https://github.com/scawp/magic.ObsClient), refer to this for documentation. this project is intended as a simple example, as such advanced features will not be implemented (however I do plan on releasing a bigger project based on this in future), only bug fixes will be addressed, please see [issues](https://github.com/scawp/magic.ObsClient-demo/issues). 

#### Screenshot from android:

<img src="https://github.com/scawp/magic.ObsClient-demo/blob/main/docs/img/screenshot.jpg" width="25%" />

## Requirements
- [Love2d](https://love2d.org) version used 11.3
- [OBS](https://obsproject.com) version used 27.0.1
- [obs-websocket](https://github.com/Palakis/obs-websocket/releases/tag/4.9.1) version used 4.9.1

## Dependencies 
- [lunajson](https://github.com/grafi-tt/lunajson)
- [love2d-lua-websocket](https://github.com/flaribbit/love2d-lua-websocket)
- [mägic.ObsClient](https://github.com/scawp/magic.ObsClient)
- [urutora](https://github.com/tavuntu/urutora) currently using [urutora-fork](https://github.com/scawp/urutora-fork) for android compatibility

`lunajson`, `love2d-lua-websocket`, `urutora` and `mägic.ObsClient` are included as submodules, clone the project with the following command to fetch all:

```gitclone --recurse-submodules git@github.com:scawp/magic.ObsClient-demo.git```

## Note
The project links to submodules via symlinking, this my be an issue for windows users (enable Windows 10 Developer mode and configure git for symlinks)

#I don't care about the code, how do I run this?!

## Android

From the Play Store download [love2d](https://play.google.com/store/apps/details?id=org.love2d.android&hl=en_US&gl=US)
Copy `remote.love` (either by building from the code in this repo or from the `release` page) onto your device (If you use DropBox you can open this directly from the app)
Run!

An APK file or direct download from the Play Store may be provided in future

## Windows/Linux

TODO!
