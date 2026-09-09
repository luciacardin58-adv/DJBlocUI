"
I am one deck's mixer channel: volume fader, EQ, filter and level meter.

I am a row of three columns. The volume fader sits on the left, the knob column, EQ bands over the filter, in the middle, and the level meter on the right. Stacking the fader under the knobs made me as tall as all my
parts put together, which does not fit the console's deck band; side by side I am only as tall as my tallest part.

I sit between the two decks and own no transport state.
"
Class {
	#name : 'DJChannelStripElement',
	#superclass : 'DJPanelElement',
	#instVars : [
		'eqControls',
		'filterKnob',
		'channelFader',
		'levelMeter',
		'mirrored'
	],
	#category : 'DjBlocUI-MixerStrip',
	#package : 'DjBlocUI',
	#tag : 'MixerStrip'
}

{ #category : 'initialization' }
DJChannelStripElement class >> defaultWidth [
"Derived from my columns, never stated twice."

	^ self labelColumnWidth + self knobColumnWidth + self faderColumnWidth
	  + (DJTheme gap * 2)
]

{ #category : 'examples' }
DJChannelStripElement class >> example [
	<script>
	| space |
	space := DJChannelStripElement new inSpace.
	space extent: 200 @ 620.
	space title: 'DJChannelStripElement'
		; show
]

{ #category : 'size' }
DJChannelStripElement class >> faderColumnWidth [
	"Gain knob on top, volume fader below."

	^ 45
]

{ #category : 'size' }
DJChannelStripElement class >> knobColumnWidth [

	^ 34
]

{ #category : 'size' }
DJChannelStripElement class >> labelColumnWidth [

	^ 16
]

{ #category : 'size' }
DJChannelStripElement class >> meterColumnWidth [
	"Shared between both strips. Headphone buttons on top, VU meters below."

	^ 60
]

{ #category : 'accessing' }
DJChannelStripElement class >> mirrored [
	"Deck B. The flag must be set before initializeParts reads it."

	^ self basicNew
		  setMirrored: true;
		  initialize;
		  yourself
]

{ #category : 'size' }
DJChannelStripElement class >> rowHeight [

	^ 35
]

{ #category : 'api - layout' }
DJChannelStripElement >> beTightColumn [

	self layout: (BlLinearLayout vertical cellSpacing: 0)
]

{ #category : 'api - layout' }
DJChannelStripElement >> beTightRow [

	self layout: (BlLinearLayout horizontal cellSpacing: 0)
]

{ #category : 'building' }
DJChannelStripElement >> buildFaderColumn [

	| column |
	column := DJBoxElement new
		          exactWidth: self class faderColumnWidth;
		          matchHeight;
		          yourself.
	column addChild: channelFader.
	^ column
]

{ #category : 'building' }
DJChannelStripElement >> buildKnobsColumn [

	| column |
	eqControls := DJEqControlsElement new.
	filterKnob := DJFilterKnobElement label: 'FILTER'.
	column := DJBoxElement new
		          beTightColumn;
		          exactWidth: self class knobColumnWidth;
		          matchHeight;
		          yourself.
	column addChildren: { eqControls. filterKnob }.
	^ column
]

{ #category : 'accessing' }
DJChannelStripElement >> channelFader [
	^ channelFader
]

{ #category : 'accessing' }
DJChannelStripElement >> eqCOntrols [ 
^ eqControls 
]

{ #category : 'accessing' }
DJChannelStripElement >> filterKnob [
	^ filterKnob
]

{ #category : 'accessing' }
DJChannelStripElement >> gain [

^ channelFader gain
]

{ #category : 'initialization' }
DJChannelStripElement >> initialize [

	mirrored ifNil: [ mirrored := false ].
	super initialize.
	self beTightRow.
	self constraintsDo: [ :c |
		c horizontal exact: self class defaultWidth.
		c vertical matchParent ]
]

{ #category : 'initialization' }
DJChannelStripElement >> initializeParts [

	| columns |
	channelFader := DJChannelFaderElement label: 'VOL'.
	columns := { self buildKnobsColumn. self buildFaderColumn }.
	self isMirrored ifTrue: [ columns := columns reversed ].
	self addChildren: columns
]

{ #category : 'accessing' }
DJChannelStripElement >> isMirrored [
	^ mirrored 
]

{ #category : 'accessing' }
DJChannelStripElement >> levelMeter [
	^ levelMeter
]

{ #category : 'accessing' }
DJChannelStripElement >> levelMeter: aDJLevelMeterElement [
	"The mixer owns the placement; I only hold the reference."

	levelMeter := aDJLevelMeterElement
]

{ #category : 'accessing' }
DJChannelStripElement >> setMirrored: aBoolean [

	mirrored := aBoolean
]
