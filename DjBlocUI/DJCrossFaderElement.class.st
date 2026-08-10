"
I am the horizontal fader blending the two decks.

I sit between the channel strips and belong to neither deck. 0 is deck A alone, 100 is deck B alone, 50 is both at full.

beHorizontal sends rebuild, which swaps widgetSize and rebuilds my parts, so the size constraints DJFaderElement declared for the vertical default are stale by the time I am built and have to be restated.'
"
Class {
	#name : 'DJCrossFaderElement',
	#superclass : 'DJFaderElement',
	#category : 'DjBlocUI-MixerStrip',
	#package : 'DjBlocUI',
	#tag : 'MixerStrip'
}

{ #category : 'example' }
DJCrossFaderElement class >> example [
	<script>
	| container fader readout space |
	fader := self new.
	readout := DJTheme textElement: 'A 0.50   B 0.50' color: DJTheme accent size: 12.
	fader callBack: [ :each |
		readout text: (DJTheme
				 rope: 'A ' , (fader gainA printShowingDecimalPlaces: 2)
					 , '   B ' , (fader gainB printShowingDecimalPlaces: 2)
				 color: DJTheme accent
				 size: 12) ].
	container := DJPanelElement new beMatchingParent; yourself.
	container addChildren: { fader. readout }.
	space := container inSpace.
	space extent: 400 @ 160.
	space title: 'DJCrossfaderElement'.
	space show
]

{ #category : 'helper' }
DJCrossFaderElement >> centre [
	self setValueSilently: 50
]

{ #category : 'accessing' }
DJCrossFaderElement >> gainA [
	"Linear blend. A real crossfader curve is a later decision - this
	 dips 6dB in the middle, which is audible but correct enough to
	 wire the decks up."
	^ (100 - self value) / 100
]

{ #category : 'accessing' }
DJCrossFaderElement >> gainB [
	^ self value / 100
]

{ #category : 'initialization' }
DJCrossFaderElement >> initialize [
	"beHorizontal sends rebuild, which may reset widgetSize - so the
	 size constraints DJFaderElement declared for the vertical default
	 have to be re-read afterwards."
	super initialize.
	self beHorizontal.
	self constraintsDo: [ :c |
		c horizontal exact: self widgetSize x.
		c vertical exact: self widgetSize y ]
]

{ #category : 'testing' }
DJCrossFaderElement >> isCentred [
	^ (self value - 50) abs < 1
]

{ #category : 'initialization' }
DJCrossFaderElement >> nitialize [
	super initialize.
	self beHorizontal.
	self setValueSilently: 50.
	self constraintsDo: [ :c |
		c horizontal exact: self widgetSize x.
		c vertical exact: self widgetSize y ]
]
