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

{ #category : 'defaults' }
DJMixerElement class >> crossfaderHeight [
	"Full-width bottom row: filter sliders outboard, crossfader centred."

	^ 42
	
]

{ #category : 'building' }
DJMixerElement class >> crossfaderSpan [
	"Strip to strip. My width less my own padding and the hairline each side."

	^ self defaultWidth - (DJTheme gap * 2) - 2
]

{ #category : 'defaults' }
DJMixerElement class >> defaultWidth [

	^ (DJChannelStripElement defaultWidth * 2) + self meterColumnWidth
	  + (DJTheme gap * 4)
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

{ #category : 'building' }
DJMixerElement >> crossfaderSpan [
	"Strip to strip. My width less my own padding and the hairline each side."

	^ self defaultWidth - (DJTheme gap * 2) - 2
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

	
	self addChild: self buildStripsRow.
	self addChild: self buildCrossfaderRow
]

{ #category : 'accessing' }
DJMixerElement >> leftStrip [ 
^ leftStrip 
]

{ #category : 'accessing' }
DJMixerElement >> rightStrip [

^ rightStrip
]
