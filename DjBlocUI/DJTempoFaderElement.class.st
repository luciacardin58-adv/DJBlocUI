"
I am a deck''s pitch fader, plus or minus 8 percent.

Read snappedValue, not value: my travel quantises to pixels, so a reset
fader lands near zero rather than on it and sync would correct forever.
snappedValue answers exactly 0 inside snapWindow. rateMultiplier converts
it for the deck.
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

{ #category : 'as yet unclassified' }
DJTempoFaderElement >> buildMarker [
	"The marker is placed by trigonometry, so the layout must leave
	 it alone."
	marker := BlElement new
		          background: DJTheme accent;
		          geometry: BlCircleGeometry new;
		          size: 14 @ 14;
		          constraintsDo: [ :c | c ignoreByLayout ];
		          yourself.
	self updateMarker.
	^ marker
]

{ #category : 'initialization' }
DJTempoFaderElement >> initialize [
	"initializeValues already set value := minValue against the old
	 0 to 100 range, so the value has to be restated once the range
	 is right, or the handle and the value disagree."
	super initialize.
	self minValue: -8.
	self maxValue: 8.
	self setValueSilently: 0
]

{ #category : 'initialization' }
DJTempoFaderElement >> initializeParts [
	bpmLabel := DJTheme textElement: '--' color: DJTheme text size: 16.
	timeLabel := DJTheme textElement: '00:00' color: DJTheme dimText size: 12.
	self addChildren: { bpmLabel. timeLabel }.
	self addChild: self buildMarker
]

{ #category : 'as yet unclassified' }
DJTempoFaderElement >> nitializeEvents [
	self addEventHandlerOn: BlDragEvent do: [ :event |
		self nudgeBy: event delta y negated / 200 ]
 
]
