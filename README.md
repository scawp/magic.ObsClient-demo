# mägic.ObsClient-demo
A demo of mägic.ObsClient

This is a work in progress of Demo of [mägic.ObsClient](https://github.com/scawp/magic.ObsClient), refer to this for documentation. this project is intended as a simple example, as such advanced features will not be implemented (however I do plan on releasing a bigger project based on this in future), only bug fixes will be addressed, please see [issues](https://github.com/scawp/magic.ObsClient-demo/issues). 

# Requirements
- [Love2d](https://love2d.org) version used 11.3
- [OBS](https://obsproject.com) version used 27.0.1
- [obs-websocket](https://github.com/Palakis/obs-websocket/releases/tag/4.9.1) version used 4.9.1
- [lunajson](https://github.com/grafi-tt/lunajson)
- [love2d-lua-websocket](https://github.com/flaribbit/love2d-lua-websocket)
- [mägic.ObsClient](https://github.com/scawp/magic.ObsClient)

`lunajson`, `love2d-lua-websocket` and `mägic.ObsClient` are included as submodules, clone the project with the following command to fetch all:

```gitclone --recurse-submodules git@github.com:scawp/magic.ObsClient-demo.git```

# Note
The project links to submodules via symlinking, this my be an issue for windows users (enable Windows 10 Developer mode and configure git for symlinks)
