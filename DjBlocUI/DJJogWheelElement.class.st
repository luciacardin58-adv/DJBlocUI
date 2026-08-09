"
I am a deck's pitch fader, +/-8% by default, with a reset to zero.
My value is a percentage; the deck converts it to a rate multiplier.
"
Class {
	#name : 'DJJogWheelElement',
	#superclass : 'DJPanelElement',
	#instVars : [
		'position',
		'bpmLabel',
		'timeLabel',
		'marker',
		'onNudge'
	],
	#category : 'DjBlocUI-DeckBody',
	#package : 'DjBlocUI',
	#tag : 'DeckBody'
}

{ #category : 'examples' }
DJJogWheelElement class >> example [
	"Drag the platter: the marker follows and the nudge fraction
	 prints to the Transcript."
	<script>
	| wheel container space |
	wheel := self new.
	wheel bpm: 128.0.
	wheel elapsed: '02:14'.
	wheel position: 0.35.
	wheel onNudge: [ :fraction |
		wheel position: wheel position + fraction.
		Transcript show: fraction printString; cr ].
	container := DJPanelElement new beMatchingParent; yourself.
	container addChild: wheel.
	space := container inSpace.
	space extent: 280 @ 280.
	space title: 'DJJogWheelElement'.
	space show
]

{ #category : 'accessing' }
DJJogWheelElement >> bpm: aNumber [
	bpmLabel text: (DJTheme
			 textElement: (aNumber printShowingDecimalPlaces: 1)
			 color: DJTheme text
			 size: 16) text
]

{ #category : 'building' }
DJJogWheelElement >> buildMarker [
	"The marker is placed by trigonometry, so the layout must leave
	 it alone."

	marker := BlElement new
		          background: DJTheme accent;
		          geometry: BlCircleGeometry new;
		          extent: 14 @ 14;
		          constraintsDo: [ :c | c ignoreByLayout ];
		          yourself.
	self updateMarker.
	^ marker
]

{ #category : 'accessing' }
DJJogWheelElement >> diameter [ 
^ 200
]

{ #category : 'accessing' }
DJJogWheelElement >> elapsed: aString [
	timeLabel text:
		(DJTheme textElement: aString color: DJTheme dimText size: 12) text
]

{ #category : 'initialization' }
DJJogWheelElement >> initialize [
	position := 0.
	super initialize.
	self geometry: BlCircleGeometry new.
	self constraintsDo: [ :c |
		c horizontal exact: self diameter.
		c vertical exact: self diameter ].
	self initializeEvents
]

{ #category : 'initialization' }
DJJogWheelElement >> initializeEvents [
	self addEventHandlerOn: BlDragEvent do: [ :event |
		self nudgeBy: event delta y negated / 200 ]
]

{ #category : 'initialization' }
DJJogWheelElement >> initializeParts [
	bpmLabel := DJTheme textElement: '--' color: DJTheme text size: 16.
	timeLabel := DJTheme textElement: '00:00' color: DJTheme dimText size: 12.
	self addChildren: { bpmLabel. timeLabel }.
	self addChild: self buildMarker
]

{ #category : 'private' }
DJJogWheelElement >> nudgeBy: aFraction [
	onNudge ifNotNil: [ :block | block value: aFraction ]
 
]

{ #category : 'accessing' }
DJJogWheelElement >> onNudge: aBlock [
	"Answers a fraction: positive forward, negative back."
	onNudge := aBlock
]

{ #category : 'updating' }
DJJogWheelElement >> updateMarker [
	| angle radius centre |
	angle := position * 2 * Float pi - (Float pi / 2).
	radius := self diameter / 2 - 18.
	centre := self diameter / 2.
	marker position:
		centre + (angle cos * radius) - 7 @ (centre + (angle sin * radius) - 7)
]
