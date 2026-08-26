"
I am a channel''s volume fader, 0 to 100, linear.

That is already ICMixerFader''s default range, so I restate nothing. I start at the top rather than at zero, because a channel loaded with a track and silent looks broken. gain answers 0 to 1 for the deck.'
"
Class {
	#name : 'DJChannelFaderElement',
	#superclass : 'DJFaderElement',
	#category : 'DjBlocUI-MixerStrip',
	#package : 'DjBlocUI',
	#tag : 'MixerStrip'
}

{ #category : 'example' }
DJChannelFaderElement class >> example [

	<script>
	| container fader readout space |
	fader := self label: 'VOL'.
	readout := DJTheme textElement: '1.00' color: DJTheme accent size: 12.
	fader callBack: [ :each |
			readout text: (DJTheme
					 rope: (fader gain printShowingDecimalPlaces: 2)
					 color: DJTheme accent
					 size: 12) ].
	container := DJPanelElement new
		             beMatchingParent;
		             yourself.
	container addChildren: {
			fader.
			readout }.
	space := container inSpace.
	space extent: 200 @ 380.
	space title: 'DJChannelFaderElement'.
	space show
]

{ #category : 'accessing' }
DJChannelFaderElement >> gain [
	"0 to 1. The deck wants a multiplier, not a percentage."
	^ self value / 100
]

{ #category : 'initialization' }
DJChannelFaderElement >> initialize [
	"initializeValues leaves value at minValue, which for a volume
	 fader means a silent channel on load."
	super initialize.
	self setValueSilently: self maxValue
]

{ #category : 'testing' }
DJChannelFaderElement >> isSilent [
	^ self value < 1
]

{ #category : 'as yet unclassified' }
DJChannelFaderElement >> sizeScale [
	^ 0.7
]
