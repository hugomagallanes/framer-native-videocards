# Native iOS Dailymotion player
[![license](https://img.shields.io/github/license/bpxl-labs/RemoteLayer.svg)](https://opensource.org/licenses/MIT)
![Maintenance](https://img.shields.io/maintenance/yes/2018.svg)

<!-- <img src="https://raw.githubusercontent.com/hugomagallanes/nativeIOSDailymotionPlayer/master/projectCover%402x.png" width="375"> -->

Native videocards featuring auto-playing and with a loading animation.


### Installation

#### Using Framer Modules

<a href='https://open.framermodules.com/input-framer'>
  <img alt='Install with Framer Modules' src='https://www.framermodules.com/assets/badge@2x.png' width='160' height='40' />
</a>

#### Manually

1. Download project from Github
2. Copy `nativeVideocard.coffee` into `modules/` folder inside your Framer project
3. Import it into your Framer project by adding
```coffeescript
Videocard = require "nativeVideocard"
```


### Customization

| Property         | Type                    | Description                           |
| -----------------|:-----------------------:|---------------------------------------|
| `setThumbnail`   | *URL*                   | Sets videocard thumbnail
| `setChannel`     | *String*                | Sets videocard channel
| `setHeader`      | *String*                | Sets videocard header
| `isSoundOn`      | *Bolean*                | Turn ON or OFF videocard sound


### Internal functions

To play video do not use the regular `video.player.play()`, use instead the follow function which checks if the browser has fully loaded the video before playing. If the video has not been fully loaded it plays a loading animation.

```coffeescript
Videocard.LoadVideo()
```


### Loading animation

Loading animation is a separate class inside the nativeVideocard` file, because it is for internal use only it cannot be called from Framer. To use it just use the following functions.

##### Start animation
```coffeescript
@.{layerName}.LoadAnimation()
```

##### Stop animation
```coffeescript
@.{layerName}.LoadAnimation().StopAnimation()
```

As an additional step, do not forget to hide the parent layer when stopping the animation.
