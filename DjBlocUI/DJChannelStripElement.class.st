"
I am one deck''s mixer channel: EQ, filter, volume fader and level meter.

I sit between the two decks and own no transport state. The fader and the meter share a row, so the meter runs alongside the fader rather than below it.
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
DJChannelStripElement >> buildFaderRow [
	| row |
	channelFader := DJChannelFaderElement label: 'VOL'.
	levelMeter := DJLevelMeterElement new.
	row := DJPanelElement new beBare; beRow; yourself.
	row constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	row addChildren: { channelFader. levelMeter }.
	^ row
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
	self beMatchingParent
]

{ #category : 'initialization' }
DJChannelStripElement >> initializeParts [
	eqControls := DJEqControlsElement new.
	filterKnob := DJFilterKnobElement label: 'FILTER'.
	self addChildren: { eqControls. filterKnob. self buildFaderRow }
]

{ #category : 'accessing' }
DJChannelStripElement >> levelMeter [
	^ levelMeter
]
