"
I am a deck''s pitch fader, plus or minus 8 percent.

Read snappedValue, not value: my travel quantises to pixels, so a resetfader lands near zero rather than on it and sync would correct forever. snappedValue answers exactly 0 inside snapWindow.

I answer a percentage, not a multiplier: **DJPlayer** converts .
"
Class {
	#name : 'DJTempoFaderElement',
	#superclass : 'DJFaderElement',
	#instVars : [
		'bpmLabel',
		'timeLabel',
		'marker'
	],
	#category : 'DjBlocUI-DeckBody',
	#package : 'DjBlocUI',
	#tag : 'DeckBody'
}

{ #category : 'example' }
DJTempoFaderElement class >> example [
	<script>
	| container fader readout space |
	fader := self label: 'TEMPO'.
	readout := DJTheme textElement: fader displayString color: DJTheme accent size: 12.
	fader callBack: [ :each |
		readout text: (DJTheme
				 textElement: fader displayString
				 color: DJTheme accent
				 size: 12) text ].
	container := DJPanelElement new beMatchingParent; yourself.
	container addChildren: { fader. readout }.
	space := container inSpace.
	space extent: 200 @ 380.
	space title: 'DJTempoFaderElement'.
	space show
]

{ #category : 'example' }
DJTempoFaderElement class >> exampleSilent [
	"No readout. If the thumb moves here but not in example, the
	 callback is raising mid-drag."
	<script>
	| container space |
	container := DJPanelElement new beMatchingParent; yourself.
	container addChild: (self new callBack: [ :each | ]; yourself).
	space := container inSpace.
	space extent: 200 @ 360.
	space title: 'DJTempoFaderElement (bare)'.
	space show
]

{ #category : 'displaying' }
DJTempoFaderElement >> displayString [
	"The percentage as shown. snappedValue, not value, so the readout
	 reads 0.00 through the centre window."
	^ (self snappedValue printShowingDecimalPlaces: 2) , ' %'
]

{ #category : 'initialization' }
DJTempoFaderElement >> initialize [
"initializeValues already set value := minValue against the old0 to 100 range, so the value has to be restated once the range is right, or the handle and the value disagree."

super initialize.
	self name: 'TEMPO'.
	self minValue: -8.
	self maxValue: 8.
	self setValueSilently: 0

]

{ #category : 'accessing' }
DJTempoFaderElement >> isCentred [
	^ self snappedValue = 0
]

{ #category : 'operations' }
DJTempoFaderElement >> reset [
	"Silent: the deck asked for this, so telling it back would echo."
	self setValueSilently: 0
]

{ #category : 'as yet unclassified' }
DJTempoFaderElement >> sizeScale [
	^ 0.7
]

{ #category : 'accessing' }
DJTempoFaderElement >> snapWindow [ 
^ 0.15
]

{ #category : 'accessing' }
DJTempoFaderElement >> snappedValue [
	"Without this a reset deck sits at 0.004 percent and sync corrects
	 forever. Snapping is a DJ decision, so it lives here rather than
	 in DJFaderElement or upstream."
	^ self value abs < self snapWindow
		  ifTrue: [ 0 ]
		  ifFalse: [ self value ]
]
