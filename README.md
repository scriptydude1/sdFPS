# sdFPS
Simple collection of modules that tries to transform ROBLOX into a more bearable "First Person experience".

*this is my little sideproject so uhh wacky stuff is to be expected.*

### Features
**Simple** - This project doesn't try to create a custom CharacterController or a custom Animate script. 

**Modular** - Project's scripts is broken down into many small functions and modules. Camera, Mouse, Preferences etc.

**Doesn't tamper with the original scripts** - This project isn't rewritting ROBLOX Core Scripts, it builds on top of it.

## Modules (TODO)
* *Camera (src/player/Camera/init.lua)* - This handles client camera and different custom cameratypes.
* *Mouse (src/player/Mouse.lua)* - This handles client mouse. Move delta, LMB and RMB detection, Wheel scroll detection (TODO).
* *Preferences (src/player/Preferences.lua)* - Stores client preferences, such as mouse sensetivity or camera's FOV. TODO save and load preferences from server.

