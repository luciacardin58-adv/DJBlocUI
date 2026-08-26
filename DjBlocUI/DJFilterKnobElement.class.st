"
I am a channel''s bipolar filter knob: low-pass left of centre, high-pass right. Centre is bypass.

Like the EQ knobs I answer -100 to 100 and leave the cutoff mapping to the deck. isLowPass and isHighPass say which side I am on so a caller does not have to know which sign means what.
"
Class {
	#name : 'DJFilterKnobElement',
	#superclass : 'DJKnobElement',
	#category : 'DjBlocUI-MixerStrip',
	#package : 'DjBlocUI',
	#tag : 'MixerStrip'
}

{ #category : 'examples' }
DJFilterKnobElement class >> example [
	<script>
	| container space |
	container := DJPanelElement new beMatchingParent; yourself.
	container addChild: (self label: 'FILTER').
	space := container inSpace.
	space extent: 200 @ 200.
	space title: 'DJFilterKnobElement'.
	space show
]

{ #category : 'accessing' }
DJFilterKnobElement >> diameter [ 
^ 18
]

{ #category : 'initialization' }
DJFilterKnobElement >> initialize [

	super initialize.
	self diameter: self class defaultDiameter.
	self minValue: -100.
	self maxValue: 100.
	self setValueSilently: 0
]

{ #category : 'testing' }
DJFilterKnobElement >> isBypassed [
	^ self value abs < 1
]

{ #category : 'testing' }
DJFilterKnobElement >> isHighPass [
	^ self value > 0
]

{ #category : 'testing' }
DJFilterKnobElement >> isLowPass [
	^ self value < 0
]

{ #category : 'accessing' }
DJFilterKnobElement >> maxValue: aNumber [

	super maxValue: aNumber.
	maxLabel text: '' asRopedText
]

{ #category : 'accessing' }
DJFilterKnobElement >> minValue: aNumber [
"ICKnob prints the range into minLabel and maxLabel, which share the bottom band with currentLabel and overprint it at our diameter. The range is fixed and known from the strip, so only the current value gets the room. The elements stay, blank: applyLabelSizes sends transformDo: to both without a nil guard."

	super minValue: aNumber.
	minLabel text: '' asRopedText
]

{ #category : 'helper' }
DJFilterKnobElement >> reset [
	self setValueSilently: 0
]
