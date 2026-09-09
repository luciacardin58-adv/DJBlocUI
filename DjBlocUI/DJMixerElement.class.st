"
I am  =two strips over a crossfader
"
Class {
	#name : 'DJMixerElement',
	#superclass : 'DJPanelElement',
	#instVars : [
		'leftStrip',
		'rightStrip',
		'crossfader',
		'leftMeter',
		'rightMeter'
	],
	#category : 'DjBlocUI-Root',
	#package : 'DjBlocUI',
	#tag : 'Root'
}

{ #category : 'as yet unclassified' }
DJMixerElement class >> crossfaderSpan [
	"Fader to fader across the meters, as in Mixxx."

	^ self meterColumnWidth + (DJChannelStripElement faderColumnWidth * 2)
]

{ #category : 'defaults' }
DJMixerElement class >> defaultWidth [ 

^ 430
]

{ #category : 'size' }
DJMixerElement class >> meterColumnWidth [
"Shared between both strips."

	^ 60
]

{ #category : 'building' }
DJMixerElement >> buildCrossfaderRow [

	| row |
	crossfader := DJCrossfaderElement new.
	crossfader spanWidth: self class crossfaderSpan.
	crossfader constraintsDo: [ :c | c linear horizontal alignCenter ].
	row := DJBoxElement new
		          beRow;
		          matchWidth;
		          exactHeight: self class crossfaderHeight;
		          yourself.
	row addChild: crossfader.
	^ row
]

{ #category : 'building' }
DJMixerElement >> buildMeterColumn [
	"Built after the strips, because I hand each meter to one."

	| column |
	leftMeter := DJLevelMeterElement new.
	rightMeter := DJLevelMeterElement new.
	leftStrip levelMeter: leftMeter.
	rightStrip levelMeter: rightMeter.
	column := DJBoxElement new
		          beRow;
		          exactWidth: self class meterColumnWidth;
		          matchHeight;
		          yourself.
	column addChildren: { leftMeter. rightMeter }.
	^ column
]

{ #category : 'building' }
DJMixerElement >> buildStripsRow [

	| row |
	leftStrip := DJChannelStripElement new.
	rightStrip := DJChannelStripElement mirrored.
	row := DJBoxElement row.
	row addChildren: { leftStrip. self buildMeterColumn. rightStrip }.
	^ row
]

{ #category : 'accessing' }
DJMixerElement >> crossfader [ 
^ crossfader
]

{ #category : 'initialization' }
DJMixerElement >> initialize [

	super initialize.
	self constraintsDo: [ :c |
		c horizontal exact: self class defaultWidth.
		c vertical matchParent ]
]

{ #category : 'initialization' }
DJMixerElement >> initializeParts [

	crossfader := DJCrossfaderElement new.
	crossfader spanWidth: self class defaultWidth - (DJTheme gap * 2).
	self addChild: self buildStripsRow.
	self addChild: crossfader
]

{ #category : 'accessing' }
DJMixerElement >> leftStrip [ 
^ leftStrip 
]

{ #category : 'accessing' }
DJMixerElement >> rightStrip [

^ rightStrip
]
