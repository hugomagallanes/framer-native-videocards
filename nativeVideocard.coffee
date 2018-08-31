# Add the following line to your project in Framer Studio.
# myModule = require "myModule"
# Reference the contents by name, like myModule.myFunction() or myModule.myVar


###  ===================================================================
     || GLOBAL VARIABLES ||
==================================================================== ###

black100 = "#0D0D0D"


###  ===================================================================
     || COMPONENT: LoaderView ||
==================================================================== ###


class LoaderView extends Layer
  constructor: (@options = {}) ->

    @options.backgroundColor ?= black100
    @options.height ?= 100
    @options.width ?= 100


		# ||-----------|| 📂 LAYERS: STRUCTURE ||-----------------||
    @loadingOutter = new Layer
      name: "loadingOutter"

    @loadingInner = new Layer
      name: "loadingInner"

    # ||-----------|| 🚩 INITIATES COMPONENT ||---------------||
    super @options

		# ||-----------|| 📂 LAYERS: STYLE ||---------------------||
    allLayers = [@loadingOutter, @loadingInner]

    for layer in allLayers
        layer.borderRadius = 100
        layer.originX = 0.5
        layer.originY = 0.5
        layer.parent = @
        layer.size = 80
        layer.x = 40
        layer.y = @midY

    @loadingOutter.backgroundColor = "white"
    @loadingOutter.opacity = 1
    @loadingOutter.scale = 0

    @loadingInner.backgroundColor = "#00191E"
    @loadingInner.opacity = 0
    @loadingInner.scale = .7


		# ||-----------|| 🛠 DEFINING FUNCTIONS ||----------------||
		LoadAnimation: ->
			# print "Starting animation"

			# Defines all the animation states
			expand = new Animation @loadingOutter,
	      opacity: 1
	      scale: 1
	      options:
	        curve: Bezier.ease
	        time: .8
	    fadeOut = new Animation @loadingOutter,
	      opacity: 0
	      scale: 1
	      options:
	        curve: Bezier.ease
	        time: .8
	    innerExpand = new Animation @loadingInner,
	      opacity: 0
	      scale: 1
	      options:
	        curve: Bezier.ease
	        time: .8

			# Defines onAnimationEnd behaviours
			expand.on Events.AnimationEnd, =>
		      # Outter: Start animation
		      fadeOut.start()

		      # Inner: Reset this specific settings
		      @loadingInner.opacity = 1
		      @loadingInner.scale = .7
		      # Inner: Start animation
		      innerExpand.start()
		  fadeOut.on Events.AnimationEnd, =>

		      # Outter: Reset animation
		      expand.reset()
		      # Outter: Restart animation
		      expand.start()

		      # Inner: Reset animation
		      innerExpand.reset()

			# 🚩 Starts animation
			expand.start()

			# Function: Stops all animations when called
			StopAnimation: =>
				# print "Stop all animations"

				@.loadingOutter.animateStop()
				@.loadingInner.animateStop()


###  ===================================================================
     || COMPONENT: Videocard ||
==================================================================== ###

class exports.Videocard extends Layer
	constructor: (@options = {}) ->

		#--> Unchangeable defaults
		@options.backgroundColor = "grey"
		@options.width = 343
		@options.height = 276
		@options.isSoundOn ?= true


		# ||-----------|| 📂 LAYERS: STRUCTURE ||-----------------||
		@video = new VideoLayer
			backgroundColor: black100
			name: "video"

		@overlay = new LoaderView
			name: "overlayLoading"

		@thumbnail = new Layer
			backgroundColor: null
			image: @options.setThumbnail || "https://bit.ly/2Ph6adO"
			name: "thumbnail"

		@actions = new Layer
			backgroundColor: null
			name: "actions"

		@sound = new Layer
			name: "sound"

		@channel = new TextLayer
			name: "channel"
			text: @options.setChannel || "Channel Name"

		@header = new TextLayer
			name: "header"
			text: @options.setHeader || "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ultricies est ut efficit."


		# ||-----------|| 🚩 INITIATES COMPONENT ||---------------||
		super @options


		# ||-----------|| 📂 LAYERS: STYLE ||---------------------||
		@actions.parent = @

		@video.parent = @
		@video.height = 194
		@video.width = @width

		@overlay.parent = @.video
		@overlay.size = @.video.size

		@thumbnail.parent = @
		@thumbnail.height = 194
		@thumbnail.opacity = 1
		@thumbnail.width = @width

		@sound.parent = @
		@sound.backgroundColor = "blue"
		@sound.size = 50
		@sound.x = Align.right
		@sound.y = @.video.maxY + 8

		@channel.parent = @
		@channel.color = black100
		@channel.lineHeight = 1
		@channel.fontFamily = "Retina-bold"
		@channel.fontSize = 12
		@channel.opacity = .8
		@channel.width = @width
		@channel.y = @.video.maxY + 10

		@header.parent = @
		@header.color = black100
		@header.line = 1.4
		@header.fontFamily = "Retina-regular"
		@header.fontSize = 15
		@header.width = @width - 47
		@header.y = @.channel.maxY + 6

		# ↳Sets a 2-lines maximum
		@header.height = (@header.fontSize * @header.lineHeight ) * 2
		# ↳Truncates text
		@header.textOverflow = "ellipsis"


		# ||-----------|| 🎟 EVENTS ||----------------------------||

		# Mutes sounds if isSoundOn is set to 'false'
		if @options.isSoundOn is false
			@video.player.muted = true


	# ||-----------|| 🛎 GETTERS AND SETTERS ||-----------------||

	#--> Fetches isSoundOn current state
	@define 'isSoundOn',
		get: ->
			@options.isSoundOn
		set: (value) ->
			@options.isSoundOn = value
			if @options.isSoundOn is false
				@.video.player.muted = true
			else
				@.video.player.muted = false



	# ||-----------|| 🛠 DEFINING EVENTS ||-------------------||

	#--> Loads Videocard
	# Type: Function
	# Description: It loads video into player, then plays loading animation while setting a interval to check if the video has correctly loaded.
	LoadVideo: (videoURL) ->

		# Stores video's readyState
		ReadyState = @video.player.readyState

		# Function: Clears setInterval
		StopChecking = (value) ->
			clearInterval(value)

		# 🚩 Loads video
		@video.video = videoURL

		# Starts loading animation
		@.overlay.LoadAnimation()

		CheckLoadingState = setInterval ( =>
				print @video.player.readyState

				if @video.player.readyState isnt 4
					print "Loading video..."

				else
					print "Video is ready to play! 👌"

					@.overlay.LoadAnimation().StopAnimation()

					StopChecking(CheckLoadingState)

					# Hide loading overlay
					@overlay.visible = false

					@video.player.play()

		), 1000
