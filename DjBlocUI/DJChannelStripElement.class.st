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
		'levelMeter'
	],
	#category : 'DjBlocUI-MixerStrip',
	#package : 'DjBlocUI',
	#tag : 'MixerStrip'
}

{ #category : 'examples' }
DJChannelStripElement class >> example [
	<script>
	| space |
	space := DJChannelStripElement new inSpace.
	space extent: 200 @ 620.
	space title: 'DJChannelStripElement'
		; show
]

{ #category : 'building' }
DJChannelStripElement >> buildKnobsColumn [
	| column |
	eqControls := DJEqControlsElement new.
	filterKnob := DJFilterKnobElement label: 'FILTER'.
	column := DJPanelElement new beBare; yourself.
	column constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
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
	super initialize.
	self beRow.
	self beMatchingParent
]

{ #category : 'building' }
DJChannelStripElement >> initializeParts [
	channelFader := DJChannelFaderElement label: 'VOL'.
	levelMeter := DJLevelMeterElement new.
	self addChildren: {
		channelFader.
		self buildKnobsColumn.
		levelMeter }
]

{ #category : 'accessing' }
DJChannelStripElement >> levelMeter [
	^ levelMeter
]
