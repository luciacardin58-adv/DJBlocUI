"
I am the horizontal fader blending the two decks.

I sit between the channel strips and belong to neither deck. 0 is deck A alone, 100 is deck B alone, 50 is both at full.

beHorizontal sends rebuild, which swaps widgetSize and rebuilds my parts, so the size constraints DJFaderElement declared for the vertical default are stale by the time I am built and have to be restated.'
"
Class {
	#name : 'DJCrossfaderElement',
	#superclass : 'DJFaderElement',
	#category : 'DjBlocUI-MixerStrip',
	#package : 'DjBlocUI',
	#tag : 'MixerStrip'
}

{ #category : 'api - bounds' }
DJCrossfaderElement class >> defaultBarThickness [ 

^ 14
]

{ #category : 'example' }
DJCrossfaderElement class >> example [
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
DJCrossfaderElement >> centre [
	self setValueSilently: 50
]

{ #category : 'accessing' }
DJCrossfaderElement >> gainA [
	"Linear blend. A real crossfader curve is a later decision - this
	 dips 6dB in the middle, which is audible but correct enough to
	 wire the decks up."
	^ (100 - self value) / 100
]

{ #category : 'accessing' }
DJCrossfaderElement >> gainB [
	^ self value / 100
]

{ #category : 'initialization' }
DJCrossfaderElement >> initialize [
	
	super initialize.
	self beHorizontal.
	self barThickness: self class defaultBarThickness.
	self restateSize.
	self centre
]

{ #category : 'testing' }
DJCrossfaderElement >> isCentred [
	^ (self value - 50) abs < 1
]

{ #category : 'helper' }
DJCrossfaderElement >> restateSize [
	"barLength:thickness: and beHorizontal both recompute widgetSize through applySize, but neither updates the constraints DJFaderElement declared. Anything that resizes me has to say so again."

	self constraintsDo: [ :c |
		c horizontal exact: self widgetSize x.
		c vertical exact: self widgetSize y ]
]

{ #category : 'helper' }
DJCrossfaderElement >> spanWidth: anInteger [
	"Size my bar so my whole widget comes out anInteger wide. ICFader adds a marginLength at each end and no length padding."

	self
		barLength: anInteger - (2 * self marginLength)
		thickness: self barThickness.
	self restateSize
]
